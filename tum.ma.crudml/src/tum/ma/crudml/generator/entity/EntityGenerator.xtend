package tum.ma.crudml.generator.entity

import tum.ma.crudml.generator.IExtendedGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.crudml.Entity
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.Component

class EntityGenerator implements IExtendedGenerator {
	
	private static var pagePackageRegistered = false
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		
		// get entities
		val entries = input.allContents.toIterable.filter(Entity)
		var registeredEntities = ""
		var registeredEntityImports = ""
		pagePackageRegistered = false;
		
		for (Entity e : entries){
			// register packages
			if (!pagePackageRegistered){
				// client
				fsa.addToLine(CrudmlGenerator.Files.get(Identifier.ClientManifest), "previousexportpackage", ",")
				fsa.modifyLines(CrudmlGenerator.Files.get(Identifier.ClientManifest), "exportpackages",''' «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages''') 
				
				// shared
				fsa.addToLine(CrudmlGenerator.Files.get(Identifier.SharedManifest), "previousexportpackage", ",")
				fsa.modifyLines(CrudmlGenerator.Files.get(Identifier.SharedManifest), "exportpackages",''' «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages''') 
				pagePackageRegistered = true;	
			}
			
			// registry string
			registeredEntities += 
'''	
	«e.name.toFirstUpper»TablePage «e.name.toFirstLower»TablePage = new «e.name.toFirstUpper»TablePage();
	pageList.add(«e.name.toFirstLower»TablePage);
'''
			registeredEntityImports +=
'''	
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.«e.name.toFirstUpper»TablePage;	
'''

			// finally create actual page (e.name.toFirstUpper + Identifier.TablePage)
			fsa.generateFile(CrudmlGenerator.createFile(Identifier.Custom, "src/" + CrudmlGenerator.applicationName + "/client/ui/desktop/outlines/pages/" + e.name.toFirstUpper + "TablePage.java", Component.client),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages;

import org.eclipse.scout.commons.annotations.Order;
import org.eclipse.scout.commons.annotations.PageData;
import org.eclipse.scout.rt.client.ui.desktop.outline.pages.AbstractPageWithTable;
import org.eclipse.scout.rt.extension.client.ui.basic.table.AbstractExtensibleTable;
import org.eclipse.scout.rt.shared.TEXTS;
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.«e.name.toFirstUpper»TablePage.Table;
import «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages.«e.name.toFirstUpper»TablePageData;

/**
 * @author «CrudmlGenerator.author»
 */
@PageData(«e.name.toFirstUpper»TablePageData.class)
public class «e.name.toFirstUpper»TablePage extends AbstractPageWithTable<Table> {

  @Override
  protected String getConfiguredTitle() {
    return TEXTS.get("«e.name.toFirstUpper»");
  }

  @Order(10.0)
  public class Table extends AbstractExtensibleTable {
  }
}
''')

			// additionally create shared page data
			fsa.generateFile(CrudmlGenerator.createFile(Identifier.Custom, "src/" + CrudmlGenerator.applicationName + "/shared/ui/desktop/outlines/pages/" + e.name.toFirstUpper + "TablePageData.java", Component.shared),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages;

import javax.annotation.Generated;

import org.eclipse.scout.rt.shared.data.basic.table.AbstractTableRowData;
import org.eclipse.scout.rt.shared.data.page.AbstractTablePageData;

/**
 * <b>NOTE:</b><br>
 * This class is auto generated by the Scout SDK. No manual modifications recommended.
 * 
 * @generated
 */
@Generated(value = "org.eclipse.scout.sdk.workspace.dto.pagedata.PageDataDtoUpdateOperation", comments = "This class is auto generated by the Scout SDK. No manual modifications recommended.")
public class «e.name.toFirstUpper»TablePageData extends AbstractTablePageData {

  private static final long serialVersionUID = 1L;

  public «e.name.toFirstUpper»TablePageData() {
  }

  @Override
  public «e.name.toFirstUpper»TableRowData addRow() {
    return («e.name.toFirstUpper»TableRowData) super.addRow();
  }

  @Override
  public «e.name.toFirstUpper»TableRowData addRow(int rowState) {
    return («e.name.toFirstUpper»TableRowData) super.addRow(rowState);
  }

  @Override
  public «e.name.toFirstUpper»TableRowData createRow() {
    return new «e.name.toFirstUpper»TableRowData();
  }

  @Override
  public Class<? extends AbstractTableRowData> getRowType() {
    return «e.name.toFirstUpper»TableRowData.class;
  }

  @Override
  public «e.name.toFirstUpper»TableRowData[] getRows() {
    return («e.name.toFirstUpper»TableRowData[]) super.getRows();
  }

  @Override
  public «e.name.toFirstUpper»TableRowData rowAt(int index) {
    return («e.name.toFirstUpper»TableRowData) super.rowAt(index);
  }

  public void setRows(«e.name.toFirstUpper»TableRowData[] rows) {
    super.setRows(rows);
  }

  public static class «e.name.toFirstUpper»TableRowData extends AbstractTableRowData {

    private static final long serialVersionUID = 1L;

    public «e.name.toFirstUpper»TableRowData() {
    }
  }
}
''')
			// string entry for page
			CrudmlGenerator.createStringEntry(e.name.toFirstUpper, fsa)
		}
		
		
		if (!registeredEntities.isNullOrEmpty){
			// reference entities in outline
			fsa.modifyLines(CrudmlGenerator.Files.get(Identifier.StandardOutline), "imports",
'''	
import org.eclipse.scout.commons.exception.ProcessingException;
import org.eclipse.scout.rt.client.ui.desktop.outline.pages.IPage;
import java.util.List;
«registeredEntityImports»
''')

			fsa.modifyLines(CrudmlGenerator.Files.get(Identifier.StandardOutline), "content",
'''	

	@Override
	protected void execCreateChildPages(List<IPage> pageList) throws ProcessingException {
	«registeredEntities»
	}
''')
		}
	}	
}