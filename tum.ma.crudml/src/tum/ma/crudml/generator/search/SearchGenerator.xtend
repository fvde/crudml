package tum.ma.crudml.generator.search

import tum.ma.crudml.generator.BaseGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.crudml.Entity
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.access.Component
import tum.ma.crudml.generator.utilities.GeneratorUtilities
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.crudml.Attribute
import tum.ma.crudml.crudml.Member

class SearchGenerator extends BaseGenerator{
	
	private int formBoxOrder = 0
	
	new(int priority) {
		super(priority)
	}
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		
		// Required string
		CrudmlGenerator.createStringEntry("SearchCriteria", "Search Criteria", fsa)
		
		// get entities
		val entries = input.allContents.toIterable.filter(Entity)
		
		for (Entity e : entries){
			generateSearchForm(e, fsa)
			registerSearchForm(e, fsa)
		}
	}
	
	def generateSearchForm(Entity e, ExtendedFileSystemAccess fsa){
		
		val name = e.name.toFirstUpper
		
		val form = fsa.generateFile(CrudmlGenerator.createFile(FileType.SearchForm, name, "src/" + CrudmlGenerator.applicationName + "/client/ui/desktop/outlines/pages/searchform/" + name + "SearchForm.java", Component.client),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.searchform;

import org.eclipse.scout.commons.annotations.FormData;
import org.eclipse.scout.commons.annotations.Order;
import org.eclipse.scout.commons.exception.ProcessingException;
import org.eclipse.scout.rt.client.ui.desktop.outline.pages.AbstractSearchForm;
import org.eclipse.scout.rt.client.ui.form.AbstractFormHandler;
import org.eclipse.scout.rt.client.ui.form.fields.booleanfield.AbstractBooleanField;
import org.eclipse.scout.rt.client.ui.form.fields.button.AbstractResetButton;
import org.eclipse.scout.rt.client.ui.form.fields.button.AbstractSearchButton;
import org.eclipse.scout.rt.client.ui.form.fields.doublefield.AbstractDoubleField;
import org.eclipse.scout.rt.client.ui.form.fields.groupbox.AbstractGroupBox;
import org.eclipse.scout.rt.client.ui.form.fields.integerfield.AbstractIntegerField;
import org.eclipse.scout.rt.client.ui.form.fields.longfield.AbstractLongField;
import org.eclipse.scout.rt.client.ui.form.fields.sequencebox.AbstractSequenceBox;
import org.eclipse.scout.rt.client.ui.form.fields.stringfield.AbstractStringField;
import org.eclipse.scout.rt.client.ui.form.fields.tabbox.AbstractTabBox;
import org.eclipse.scout.rt.shared.TEXTS;
import org.eclipse.scout.rt.shared.services.common.jdbc.SearchFilter;
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.searchform.«name»SearchForm.MainBox.ResetButton;
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.searchform.«name»SearchForm.MainBox.SearchButton;
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.searchform.«name»SearchForm.MainBox.TabBox;
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.searchform.«name»SearchForm.MainBox.TabBox.FieldBox;
import «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages.searchform.«name»SearchFormData;
«GeneratorUtilities.createMarker(Identifier.Imports)»

/**
 * @author «CrudmlGenerator.author»
 */
@FormData(value = «name»SearchFormData.class, sdkCommand = FormData.SdkCommand.CREATE)
public class «name»SearchForm extends AbstractSearchForm {

  /**
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  public «name»SearchForm() throws ProcessingException {
    super();
  }

  @Override
  protected String getConfiguredTitle() {
    return TEXTS.get("«name»");
  }

  @Override
  protected void execResetSearchFilter(SearchFilter searchFilter) throws ProcessingException {
    super.execResetSearchFilter(searchFilter);
    «name»SearchFormData formData = new «name»SearchFormData();
    exportFormData(formData);
    searchFilter.setFormData(formData);
  }

  @Override
  public void startSearch() throws ProcessingException {
    startInternal(new SearchHandler());
  }
  «GeneratorUtilities.createMarker(Identifier.FormClassContent)»
  
  /**
   * @return the MainBox
   */
  public MainBox getMainBox() {
    return getFieldByClass(MainBox.class);
  }

  /**
   * @return the ResetButton
   */
  public ResetButton getResetButton() {
    return getFieldByClass(ResetButton.class);
  }

  /**
   * @return the SearchButton
   */
  public SearchButton getSearchButton() {
    return getFieldByClass(SearchButton.class);
  }

  /**
   * @return the TabBox
   */
  public TabBox getTabBox() {
    return getFieldByClass(TabBox.class);
  }

  @Order(10.0)
  public class MainBox extends AbstractGroupBox {

    @Order(10.0)
    public class TabBox extends AbstractTabBox {

      @Order(10.0)
      public class FieldBox extends AbstractGroupBox {

        @Override
        protected String getConfiguredLabel() {
          return TEXTS.get("SearchCriteria");
        }
«GeneratorUtilities.createMarker(Identifier.FormBoxContent)»

      }
    }

    @Order(60.0)
    public class ResetButton extends AbstractResetButton {
    }

    @Order(70.0)
    public class SearchButton extends AbstractSearchButton {
    }
  }

  public class SearchHandler extends AbstractFormHandler {
  }
}
''')

		// generate searchformdata
		val formData = fsa.generateFile(CrudmlGenerator.createFile(FileType.SearchFormData, name, "src/" + CrudmlGenerator.applicationName + "/shared/ui/desktop/outlines/pages/searchform/" + name + "SearchFormData.java", Component.shared),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages.searchform;

import java.util.Map;

import javax.annotation.Generated;

import org.eclipse.scout.rt.shared.data.form.AbstractFormData;
import org.eclipse.scout.rt.shared.data.form.ValidationRule;
import org.eclipse.scout.rt.shared.data.form.fields.AbstractValueFieldData;
«GeneratorUtilities.createMarker(Identifier.Imports)»


/**
 * <b>NOTE:</b><br>
 * This class is auto generated by the Scout SDK. No manual modifications recommended.
 * 
 * @generated
 */
@Generated(value = "org.eclipse.scout.sdk.workspace.dto.formdata.FormDataDtoUpdateOperation", comments = "This class is auto generated by the Scout SDK. No manual modifications recommended.")
public class «name»SearchFormData extends AbstractFormData {

  private static final long serialVersionUID = 1L;

  public «name»SearchFormData() {
  }
  «GeneratorUtilities.createMarker(Identifier.Content)»
  
}
''')

		// generate fields
		formBoxOrder = 10;
		for (Attribute a : e.attributes){
			if (a instanceof Member){
				generateFormField(e, a, fsa)
				formBoxOrder += 10
			}
		}
	}
	
	def generateFormField(Entity e, Attribute a, ExtendedFileSystemAccess fsa){
		val entityName = e.name.toFirstUpper
		var fieldName = a.name.toFirstUpper
		var member = a as Member
		var fieldDisplayName = fieldName
		var fieldType = GeneratorUtilities.getJavaTypeFromType(member.primitive)
		var innerClassType = fieldType
		var fieldContent = ""
		var classContent = ""
		var fieldOrBox = ""
		var fromToImports = ""
		val isLongOrInt = fieldType.equals("Long") || fieldType.equals("Integer")
		
		val annotatedDisplayName = GeneratorUtilities.getName(a.annotations)
		if (!annotatedDisplayName.isNullOrEmpty){
			fieldDisplayName = annotatedDisplayName
		}
		
		if (isLongOrInt){
			fieldOrBox = "Box"
			innerClassType = "Sequence"
			fromToImports += 
			'''
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.searchform.«entityName»SearchForm.MainBox.TabBox.FieldBox.«fieldName»Box.«fieldName»From;
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.searchform.«entityName»SearchForm.MainBox.TabBox.FieldBox.«fieldName»Box.«fieldName»To;
			'''
			classContent = 
			'''

  /**
   * @return the «fieldName»From
   */
  public «fieldName»From get«fieldName»From() {
    return getFieldByClass(«fieldName»From.class);
  }

  /**
   * @return the «fieldName»To
   */
  public «fieldName»To get«fieldName»To() {
    return getFieldByClass(«fieldName»To.class);
  }
			'''
			
			fieldContent = 
			'''
  @Order(10.0)
  public class «fieldName»From extends Abstract«fieldType»Field {

    @Override
    protected String getConfiguredLabel() {
      return TEXTS.get("from");
    }
  }

  @Order(20.0)
  public class «fieldName»To extends Abstract«fieldType»Field {

    @Override
    protected String getConfiguredLabel() {
      return TEXTS.get("to");
    }
  }
			'''
		} else {
			fieldOrBox = "Field"
		}
		
		// start generating
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.SearchForm, entityName), Identifier.FormClassContent, 
'''	

  /**
   * @return the «fieldName»«fieldOrBox»
   */
  public «fieldName»«fieldOrBox» get«fieldName»«fieldOrBox»() {
    return getFieldByClass(«fieldName»«fieldOrBox».class);
  }
«classContent»
''')

		fsa.modifyLines(CrudmlGenerator.getFile(FileType.SearchForm, entityName), Identifier.FormBoxContent, 
'''	

      @Order(«formBoxOrder».0)
      public class «fieldName»«fieldOrBox» extends Abstract«innerClassType»«fieldOrBox» {

        @Override
        protected String getConfiguredLabel() {
          return TEXTS.get("«fieldName»Field");
        }
        «fieldContent»
      }
''')

		fsa.modifyLines(CrudmlGenerator.getFile(FileType.SearchForm, entityName), Identifier.Imports, 
'''	
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.searchform.«entityName»SearchForm.MainBox.TabBox.FieldBox.«fieldName»«fieldOrBox»;
«fromToImports»
''')

		// generate search form data field
		if (isLongOrInt){
			generateSearchFormDataField(e, fieldName + "From", fieldType, fsa)
			generateSearchFormDataField(e, fieldName + "To", fieldType, fsa)
		} else {
			generateSearchFormDataField(e, fieldName, fieldType, fsa)
		}
		
		// lastly insert sql code snippet
		if (isLongOrInt){
			fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutlineService), Identifier.SqlStatementGetTableData, entityName,
'''	
if (formData.get«fieldName»From().getValue() != null) {
      statement.append("AND «fieldName.toUpperCase» >= :«fieldName.toFirstLower»From ");
    }
''')
			fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutlineService), Identifier.SqlStatementGetTableData, entityName,
'''	
if (formData.get«fieldName»To().getValue() != null) {
      statement.append("AND «fieldName.toUpperCase» <= :«fieldName.toFirstLower»To ");
    }
''')
		} else {
			fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutlineService), Identifier.SqlStatementGetTableData, entityName,
'''	
if (!StringUtility.isNullOrEmpty(formData.get«fieldName»().getValue())) {
      statement.append("AND UPPER(«fieldName.toUpperCase») LIKE UPPER(:«fieldName.toFirstLower» || '%') ");
    }
''')
		}

		// imports in standard outline import
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutlineService), Identifier.Imports,
'''	
import «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages.searchform.«entityName»SearchFormData;
''')
	}
	
	def registerSearchForm(Entity e, ExtendedFileSystemAccess fsa){
		val entityName = e.name.toFirstUpper
		
		// register in table page
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.TablePage, entityName), Identifier.ExecLoadData, entityName,
'''	
«entityName»SearchFormData formData = («entityName»SearchFormData) filter.getFormData();
if (formData == null) {
  formData = new «entityName»SearchFormData();
}
«entityName»TablePageData pageData = SERVICES.getService(IStandardOutlineService.class).get«entityName»TableData(formData);
importPageData(pageData);
''')

		// imports in table page
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.TablePage, entityName), Identifier.Imports, entityName,
'''	
import org.eclipse.scout.rt.client.ui.desktop.outline.pages.ISearchForm;
import «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages.«entityName»TablePageData;
import «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages.searchform.«entityName»SearchForm;
import «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages.searchform.«entityName»SearchFormData;
''')
		// set configured search form
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.TablePage, entityName), Identifier.Content, entityName,
'''	

  @Override
  protected Class<? extends ISearchForm> getConfiguredSearchForm() {
    return «entityName»SearchForm.class;
  }
''')

	}
	
	def generateSearchFormDataField(Entity e, String fieldName, String type, ExtendedFileSystemAccess fsa){
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.SearchFormData, e.name.toFirstUpper), Identifier.Imports,
'''	

''')

		fsa.modifyLines(CrudmlGenerator.getFile(FileType.SearchFormData, e.name.toFirstUpper), Identifier.Content,
'''	

  public «fieldName» get«fieldName»() {
    return getFieldByClass(«fieldName».class);
  }

  public static class «fieldName» extends AbstractValueFieldData<«type»> {

    private static final long serialVersionUID = 1L;

    public «fieldName»() {
    }
  }
''')
	}
	
}