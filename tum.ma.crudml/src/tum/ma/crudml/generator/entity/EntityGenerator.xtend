package tum.ma.crudml.generator.entity

import tum.ma.crudml.generator.IExtendedGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.crudml.Entity
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.Component
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.generator.BaseGenerator
import tum.ma.crudml.generator.utilities.GeneratorUtilities

class EntityGenerator extends BaseGenerator {
	
	private static var oneTimeOperationsExecuted = false
	
	new(int priority) {
		super(priority)
	}
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		
		// get entities
		val entries = input.allContents.toIterable.filter(Entity)
		var registeredEntities = ""
		var registeredEntityImports = ""
		oneTimeOperationsExecuted = false;
		
		for (Entity e : entries){
			// register packages
			if (!oneTimeOperationsExecuted){
				// client
				fsa.addToLineEnd(CrudmlGenerator.getFile(FileType.ClientManifest), Identifier.PreviousExportPackage, ",")
				fsa.modifyLines(CrudmlGenerator.getFile(FileType.ClientManifest), Identifier.ExportPackages,''' «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages''') 
				fsa.modifyLines(CrudmlGenerator.getFile(FileType.ClientManifest), Identifier.LastStatement, 
'''

''')
				
				// shared
				fsa.addToLineEnd(CrudmlGenerator.getFile(FileType.SharedManifest), Identifier.PreviousExportPackage, ",")
				fsa.modifyLines(CrudmlGenerator.getFile(FileType.SharedManifest), Identifier.ExportPackages,''' «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages''') 
				fsa.modifyLines(CrudmlGenerator.getFile(FileType.SharedManifest), Identifier.LastStatement, 
'''

''')
				oneTimeOperationsExecuted = true;	
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

			// create actual page (e.name.toFirstUpper + Identifier.TablePage)
			generateTablePage(e, fsa)
			
			// additionally create shared page data
			generateTablePageData(e, fsa)
			
			// string entry for page
			CrudmlGenerator.createStringEntry(e.name.toFirstUpper, fsa)
			
			// standardOutlineService
			generateStandardOutlineService(e, fsa)
		}
		
		
		if (!registeredEntities.isNullOrEmpty){
			// reference entities in outline
			fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutline), Identifier.Imports,
'''	
import org.eclipse.scout.commons.exception.ProcessingException;
import org.eclipse.scout.rt.client.ui.desktop.outline.pages.IPage;
import java.util.List;
«registeredEntityImports»
''')

			fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutline), Identifier.Content,
'''	

	@Override
	protected void execCreateChildPages(List<IPage> pageList) throws ProcessingException {
	«registeredEntities»
	}
''')
		}
	}
	
	private def generateTablePage(Entity e, ExtendedFileSystemAccess fsa){
		val tablePage = fsa.generateFile(CrudmlGenerator.createFile(FileType.TablePage, e.name.toFirstUpper,  "src/" + CrudmlGenerator.applicationName + "/client/ui/desktop/outlines/pages/" + e.name.toFirstUpper + "TablePage.java", Component.client),
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
import org.eclipse.scout.commons.exception.ProcessingException;
import org.eclipse.scout.rt.shared.services.common.jdbc.SearchFilter;
import org.eclipse.scout.service.SERVICES;
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.«e.name.toFirstUpper»TablePage.Table;
import «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages.«e.name.toFirstUpper»TablePageData;
import «CrudmlGenerator.applicationName».shared.services.IStandardOutlineService;
«GeneratorUtilities.createMarker(Identifier.Imports, e.name.toFirstUpper)»
/**
 * @author «CrudmlGenerator.author»
 */
@PageData(«e.name.toFirstUpper»TablePageData.class)
public class «e.name.toFirstUpper»TablePage extends AbstractPageWithTable<Table> {

  @Override
  protected String getConfiguredTitle() {
    return TEXTS.get("«e.name.toFirstUpper»");
  }
  
  @Override
  protected void execLoadData(SearchFilter filter) throws ProcessingException {
    importPageData(SERVICES.getService(IStandardOutlineService.class).get«e.name.toFirstUpper»TableData());
  }

  @Order(10.0)
  public class Table extends AbstractExtensibleTable {
«GeneratorUtilities.createMarker(Identifier.TableContent, e.name.toFirstUpper)»  }
}
''')
		
	}	
	
	private def generateTablePageData(Entity e, ExtendedFileSystemAccess fsa){
		val tablePageData = fsa.generateFile(CrudmlGenerator.createFile(FileType.TablePageData, e.name.toFirstUpper, "src/" + CrudmlGenerator.applicationName + "/shared/ui/desktop/outlines/pages/" + e.name.toFirstUpper + "TablePageData.java", Component.shared),
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
«GeneratorUtilities.createMarker(Identifier.Members, e.name.toFirstUpper)»
    public «e.name.toFirstUpper»TableRowData() {
    }
«GeneratorUtilities.createMarker(Identifier.TableRowData, e.name.toFirstUpper)»  }
}
''')
	}
	
	private def generateStandardOutlineService(Entity e, ExtendedFileSystemAccess fsa){
		// register in StandardOutlineService
		val standardOutlineService = CrudmlGenerator.createFile(FileType.StandardOutlineService, "src/" + CrudmlGenerator.applicationName + "/server/services/StandardOutlineService.java", Component.server)
		fsa.modifyLines(standardOutlineService, Identifier.Content,
'''

  @Override
  public «e.name.toFirstUpper»TablePageData get«e.name.toFirstUpper»TableData() throws ProcessingException {
    «e.name.toFirstUpper»TablePageData pageData = new «e.name.toFirstUpper»TablePageData();

  «GeneratorUtilities.createMarker(Identifier.SqlStatementGetTableData, e.name.toFirstUpper)»

    return pageData;
  }
''') 	

		fsa.modifyLines(standardOutlineService, Identifier.Imports,
'''
import org.eclipse.scout.commons.exception.ProcessingException;
import org.eclipse.scout.rt.server.services.common.jdbc.SQL;
import «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages.«e.name.toFirstUpper»TablePageData;
''') 

		// register in IStandardOutlineService
		val standardOutlineServiceInterface = CrudmlGenerator.createFile(FileType.IStandardOutlineService, "src/" + CrudmlGenerator.applicationName + "/shared/services/IStandardOutlineService.java", Component.shared)
		fsa.modifyLines(standardOutlineServiceInterface, Identifier.Content,
'''

  /**
   * @return
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  «e.name.toFirstUpper»TablePageData get«e.name.toFirstUpper»TableData() throws ProcessingException;
''') 

		fsa.modifyLines(standardOutlineServiceInterface, Identifier.Imports,
'''
import org.eclipse.scout.commons.exception.ProcessingException;
import «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages.«e.name.toFirstUpper»TablePageData;
''') 
	}
}