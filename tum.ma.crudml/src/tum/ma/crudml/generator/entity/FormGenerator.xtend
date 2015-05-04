package tum.ma.crudml.generator.entity

import tum.ma.crudml.generator.BaseGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.crudml.Entity
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.generator.access.Component
import tum.ma.crudml.generator.utilities.GeneratorUtilities
import tum.ma.crudml.crudml.Attribute
import tum.ma.crudml.crudml.Member
import tum.ma.crudml.crudml.Reference
import java.util.Arrays

class FormGenerator extends BaseGenerator{
	
	new(int priority) {
		super(priority)
	}
	
	private int formBoxOrder = 0
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		// get entities
		val entries = input.allContents.toIterable.filter(Entity)
		
		for (Entity e : entries){
			registerInPlugins(e, fsa)
			generateService(e, fsa)
			modifyTablePage(e, fsa)
			generateForm(e, fsa)
			generatePermissions(e, fsa)
		}
	}
	
	def generateForm(Entity e, ExtendedFileSystemAccess fsa){
		val name = e.name.toFirstUpper
		
		val form = fsa.generateFile(CrudmlGenerator.createFile(FileType.Form, name, "src/" + CrudmlGenerator.applicationName + "/client/ui/desktop/form/" + name + "Form.java", Component.client),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».client.ui.desktop.form;

import org.eclipse.scout.commons.annotations.FormData;
import org.eclipse.scout.commons.annotations.Order;
import org.eclipse.scout.commons.exception.ProcessingException;
import org.eclipse.scout.rt.client.ui.form.AbstractForm;
import org.eclipse.scout.rt.client.ui.form.AbstractFormHandler;
import org.eclipse.scout.rt.client.ui.form.fields.button.AbstractCancelButton;
import org.eclipse.scout.rt.client.ui.form.fields.button.AbstractOkButton;
import org.eclipse.scout.rt.client.ui.form.fields.groupbox.AbstractGroupBox;
import org.eclipse.scout.rt.client.ui.form.fields.doublefield.AbstractDoubleField;
import org.eclipse.scout.rt.client.ui.form.fields.integerfield.AbstractIntegerField;
import org.eclipse.scout.rt.client.ui.form.fields.longfield.AbstractLongField;
import org.eclipse.scout.rt.client.ui.form.fields.stringfield.AbstractStringField;
import org.eclipse.scout.rt.client.ui.form.fields.booleanfield.AbstractBooleanField;
import org.eclipse.scout.rt.client.ui.form.fields.smartfield.AbstractSmartField;
import org.eclipse.scout.rt.shared.data.form.fields.tablefield.AbstractTableFieldData;
import org.eclipse.scout.rt.shared.TEXTS;
import org.eclipse.scout.service.SERVICES;
import org.eclipse.scout.rt.shared.services.lookup.ILookupCall;
import «CrudmlGenerator.applicationName».client.ui.desktop.form.«name»Form.MainBox.CancelButton;
import «CrudmlGenerator.applicationName».client.ui.desktop.form.«name»Form.MainBox.«name»Box;
import «CrudmlGenerator.applicationName».client.ui.desktop.form.«name»Form.MainBox.OkButton;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.«name»FormData;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.I«name»Service;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.Update«name»Permission;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.Create«name»Permission;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.Delete«name»Permission;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.Read«name»Permission;
«GeneratorUtilities.createMarker(Identifier.Imports)»

/**
 * @author «CrudmlGenerator.author»
 */
@FormData(value = «name»FormData.class, sdkCommand = FormData.SdkCommand.CREATE)
public class «name»Form extends AbstractForm {

  private Long m_«name.toFirstLower»Nr;

  /**
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  public «name»Form() throws ProcessingException {
    super();
  }

  /**
   * @return the «name»Nr
   */
  @FormData
  public Long get«name»Nr() {
    return m_«name.toFirstLower»Nr;
  }

  /**
   * @param «name.toFirstLower»Nr
   *          the «name»Nr to set
   */
  @FormData
  public void set«name»Nr(Long «name.toFirstLower»Nr) {
    m_«name.toFirstLower»Nr = «name.toFirstLower»Nr;
  }

  @Override
  protected String getConfiguredTitle() {
    return TEXTS.get("«name»");
  }

  /**
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  public void startModify() throws ProcessingException {
    startInternal(new ModifyHandler());
  }

  /**
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  public void startNew() throws ProcessingException {
    startInternal(new NewHandler());
  }

  /**
   * @return the CancelButton
   */
  public CancelButton getCancelButton() {
    return getFieldByClass(CancelButton.class);
  }

  /**
   * @return the «name»Box
   */
  public «name»Box get«name»Box(){
    return getFieldByClass(«name»Box.class);
  }

  /**
   * @return the MainBox
   */
  public MainBox getMainBox() {
    return getFieldByClass(MainBox.class);
  }

  /**
   * @return the OkButton
   */
  public OkButton getOkButton() {
    return getFieldByClass(OkButton.class);
  }

«GeneratorUtilities.createMarker(Identifier.FormClassContent)»

  @Order(10.0)
  public class MainBox extends AbstractGroupBox {

    @Order(10.0)
    public class «name»Box extends AbstractGroupBox {

      @Override
      protected String getConfiguredLabel() {
        return TEXTS.get("«name»");
      }

«GeneratorUtilities.createMarker(Identifier.FormBoxContent)»
    }

    @Order(20.0)
    public class OkButton extends AbstractOkButton {
    }

    @Order(30.0)
    public class CancelButton extends AbstractCancelButton {
    }
    «GeneratorUtilities.createMarker(Identifier.FormBoxButtons)»
  }

  public class ModifyHandler extends AbstractFormHandler {

    @Override
    protected void execLoad() throws ProcessingException {
      I«name»Service service = SERVICES.getService(I«name»Service.class);
      «name»FormData formData = new «name»FormData();
      exportFormData(formData);
      formData = service.load(formData);
      importFormData(formData);
      setEnabledPermission(new Update«name»Permission());

    }

    @Override
    protected void execStore() throws ProcessingException {
      I«name»Service service = SERVICES.getService(I«name»Service.class);
      «name»FormData formData = new «name»FormData();
      exportFormData(formData);
      formData = service.store(formData);

    }
  }

  public class NewHandler extends AbstractFormHandler {

    @Override
    protected void execLoad() throws ProcessingException {
      I«name»Service service = SERVICES.getService(I«name»Service.class);
      «name»FormData formData = new «name»FormData();
      exportFormData(formData);
      formData = service.prepareCreate(formData);
      importFormData(formData);

    }

    @Override
    protected void execStore() throws ProcessingException {
      I«name»Service service = SERVICES.getService(I«name»Service.class);
      «name»FormData formData = new «name»FormData();
      exportFormData(formData);
      formData = service.create(formData);

    }
  }
}
''')

	//generate form data
	val formData = fsa.generateFile(CrudmlGenerator.createFile(FileType.FormData, name, "src/" + CrudmlGenerator.applicationName + "/shared/ui/desktop/form/" + name + "FormData.java", Component.shared),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».shared.ui.desktop.form;

import java.util.Map;

import javax.annotation.Generated;

import org.eclipse.scout.rt.shared.data.form.AbstractFormData;
import org.eclipse.scout.rt.shared.data.form.ValidationRule;
import org.eclipse.scout.rt.shared.data.form.fields.AbstractValueFieldData;
import org.eclipse.scout.rt.shared.data.form.properties.AbstractPropertyData;
import org.eclipse.scout.rt.shared.data.form.fields.tablefield.AbstractTableFieldData;

/**
 * <b>NOTE:</b><br>
 * This class is auto generated by the Scout SDK. No manual modifications recommended.
 * 
 * @generated
 */
@Generated(value = "org.eclipse.scout.sdk.workspace.dto.formdata.FormDataDtoUpdateOperation", comments = "This class is auto generated by the Scout SDK. No manual modifications recommended.")
public class «name»FormData extends AbstractFormData {

  private static final long serialVersionUID = 1L;

  public «name»FormData() {
  }

  /**
   * access method for property «name»Nr.
   */
  public Long get«name»Nr() {
    return get«name»NrProperty().getValue();
  }

  /**
   * access method for property «name»Nr.
   */
  public void set«name»Nr(Long «name.toFirstLower»Nr) {
    get«name»NrProperty().setValue(«name.toFirstLower»Nr);
  }

  public «name»NrProperty get«name»NrProperty() {
    return getPropertyByClass(«name»NrProperty.class);
  }

  public static class «name»NrProperty extends AbstractPropertyData<Long> {

    private static final long serialVersionUID = 1L;

    public «name»NrProperty() {
    }
  }
«GeneratorUtilities.createMarker(Identifier.Content)»
}
''')

		// generate fields
		formBoxOrder = 10;
		for (Attribute a : e.attributes){
			generateFormField(e, a, fsa)
			formBoxOrder += 10
		}
		
		// register strings
		CrudmlGenerator.createStringEntry("Edit" + name, "Edit " + name + "...", fsa)
		CrudmlGenerator.createStringEntry("New" + name, "New " + name + "...", fsa)
		CrudmlGenerator.createStringEntry("Delete" + name, "Delete " + name + "...", fsa)
	}
	
	def generateService(Entity e, ExtendedFileSystemAccess fsa){
		
		val name = e.name.toFirstUpper
		
		// first we prepare some sql statements
		var bindings = ""
		var tableNames = ""
		var setTable = ""
		var hasAttributes = false
		
		for (Attribute a : e.attributes){
			switch a {
				case (a instanceof Member) : {
					hasAttributes = true
					val attribute = a as Member
					var table = attribute.name.toUpperCase
					var binding = attribute.name.toFirstLower
										
					if (attribute.enumeration != null){
						table += CrudmlGenerator.codeTypePostfix.toUpperCase
						binding += "Code"
					}
					
					tableNames += table + ", "
					bindings += ":" + binding + ", "
					setTable += table + " = :" + binding + ", "
				}
				case (a instanceof Reference) : {
					val r = a as Reference
					
					switch r.reftype {
						case "one" : {
							hasAttributes = true
							tableNames += r.name.toUpperCase + CrudmlGenerator.primaryKeyPostfix.toUpperCase + ", "
							bindings += ":" + r.name.toFirstLower + CrudmlGenerator.primaryKeyPostfix + ", "
							setTable += r.name.toUpperCase + CrudmlGenerator.primaryKeyPostfix.toUpperCase + " = :" + r.name.toFirstLower + CrudmlGenerator.primaryKeyPostfix + ", "
						}
					}
				}
			} 
		}
		
		if (hasAttributes){
			tableNames = tableNames.substring(0, tableNames.length - 2) + " "
			bindings = bindings.substring(0, bindings.length - 2) + " "
			setTable = setTable.substring(0, setTable.length - 2) + " "
		}

		var sqlCreate = 
'''
SQL.insert("" +
	"INSERT INTO «name.toUpperCase» («tableNames») " +
	"VALUES («bindings»)"
	, formData);
'''
		var sqlLoad = 
'''
    SQL.selectInto("" +
        "SELECT «tableNames»" +
        "FROM   «name.toUpperCase» " +
        "WHERE  «name.toUpperCase + CrudmlGenerator.primaryKeyPostfix.toUpperCase» = :«name.toFirstLower + CrudmlGenerator.primaryKeyPostfix» " +
        "INTO   «bindings»"
        , formData);
'''
		var sqlStore = 
'''
    SQL.update(
        "UPDATE «name.toUpperCase» " +
        "SET «setTable» " +
        "WHERE  «name.toUpperCase + CrudmlGenerator.primaryKeyPostfix.toUpperCase» = :«name.toFirstLower + CrudmlGenerator.primaryKeyPostfix»", formData);
'''
		var sqlDelete = 
'''
    SQL.delete(
        "DELETE FROM «name.toUpperCase» " +
        "WHERE  «name.toUpperCase + CrudmlGenerator.primaryKeyPostfix.toUpperCase» = :«name.toFirstLower + CrudmlGenerator.primaryKeyPostfix»", formData);
'''
		
		val service = fsa.generateFile(CrudmlGenerator.createFile(FileType.TableService, name, "src/" + CrudmlGenerator.applicationName + "/server/ui/desktop/form/" + name + "Service.java", Component.server),
'''
/**
 *
 */
package «CrudmlGenerator.applicationName».server.ui.desktop.form;

import org.eclipse.scout.commons.exception.ProcessingException;
import org.eclipse.scout.commons.exception.VetoException;
import org.eclipse.scout.rt.server.services.common.jdbc.SQL;
import org.eclipse.scout.rt.shared.TEXTS;
import org.eclipse.scout.rt.shared.services.common.security.ACCESS;
import org.eclipse.scout.service.AbstractService;
import org.eclipse.scout.commons.holders.ITableHolder;
import org.eclipse.scout.commons.holders.TableHolderFilter;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.«name»FormData;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.Create«name»Permission;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.I«name»Service;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.Read«name»Permission;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.Update«name»Permission;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.Delete«name»Permission;

/**
 * @author «CrudmlGenerator.author»
 */
public class «name»Service extends AbstractService implements I«name»Service {

  @Override
  public «name»FormData create(«name»FormData formData) throws ProcessingException {
    if (!ACCESS.check(new Create«name»Permission())) {
      throw new VetoException(TEXTS.get("AuthorizationFailed"));
    }

«sqlCreate»
«GeneratorUtilities.createMarker(Identifier.ServiceSqlCreate)»
    return formData;
  }

  @Override
  public «name»FormData load(«name»FormData formData) throws ProcessingException {
    if (!ACCESS.check(new Read«name»Permission())) {
      throw new VetoException(TEXTS.get("AuthorizationFailed"));
    }
    
«sqlLoad»
«GeneratorUtilities.createMarker(Identifier.ServiceSqlLoad)»
    return formData;
  }
  
  @Override
  public «name»FormData prepareCreate(«name»FormData formData) throws ProcessingException {
    if (!ACCESS.check(new Create«name»Permission())) {
      throw new VetoException(TEXTS.get("AuthorizationFailed"));
    }
    
    return formData;
  }

  @Override
  public «name»FormData delete(«name»FormData formData) throws ProcessingException {
    if (!ACCESS.check(new Delete«name»Permission())) {
      throw new VetoException(TEXTS.get("AuthorizationFailed"));
    }

«sqlDelete»
    return formData;
  }

  @Override
  public «name»FormData store(«name»FormData formData) throws ProcessingException {
    if (!ACCESS.check(new Update«name»Permission())) {
      throw new VetoException(TEXTS.get("AuthorizationFailed"));
    }

«sqlStore»
«GeneratorUtilities.createMarker(Identifier.ServiceSqlStore)»
    return formData;
  }
  «GeneratorUtilities.createMarker(Identifier.ServiceSqlHelper)»
}
''')

	// create table service interface
	val serviceInterface = fsa.generateFile(CrudmlGenerator.createFile(FileType.ITableService, name, "src/" + CrudmlGenerator.applicationName + "/shared/ui/desktop/form/I" + name + "Service.java", Component.shared),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».shared.ui.desktop.form;

import org.eclipse.scout.commons.exception.ProcessingException;
import org.eclipse.scout.rt.shared.validate.IValidationStrategy;
import org.eclipse.scout.rt.shared.validate.InputValidation;
import org.eclipse.scout.service.IService;

/**
 * @author «CrudmlGenerator.author»
 */
@InputValidation(IValidationStrategy.PROCESS.class)
public interface I«name»Service extends IService {

  /**
   * @param formData
   * @return
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  «name»FormData create(«name»FormData formData) throws ProcessingException;

  /**
   * @param formData
   * @return
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  «name»FormData load(«name»FormData formData) throws ProcessingException;

  /**
   * @param formData
   * @return
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  «name»FormData prepareCreate(«name»FormData formData) throws ProcessingException;
  
  /**
   * @param formData
   * @return
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  «name»FormData delete(«name»FormData formData) throws ProcessingException;

  /**
   * @param formData
   * @return
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  «name»FormData store(«name»FormData formData) throws ProcessingException;
}
 ''')
	}
	
	def generatePermissions(Entity e, ExtendedFileSystemAccess fsa){
		val name = e.name.toFirstUpper
		
		var types = Arrays.asList(
			"Read",
			"Create",
			"Update",
			"Delete"
		)
		
		for (String type : types){
			var fileType = FileType.PermissionRead
			
			switch type {
				case "Read" : fileType = FileType.PermissionRead
				case "Create" : fileType = FileType.PermissionCreate
				case "Update" : fileType = FileType.PermissionUpdate
				case "Delete" : fileType = FileType.PermissionDelete 
			}
			
			val permission = fsa.generateFile(CrudmlGenerator.createFile(fileType, name, "src/" + CrudmlGenerator.applicationName + "/shared/ui/desktop/form/" + type + name + "Permission.java", Component.shared),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».shared.ui.desktop.form;

import java.security.BasicPermission;

/**
 * @author «CrudmlGenerator.author»
 */
public class «type + name»Permission extends BasicPermission {

  private static final long serialVersionUID = 1L;

  /**
 * 
 */
  public «type + name»Permission() {
    super("«type + name»");
  }
}
''')
		}
	}
	
	def generateFormField(Entity e, Attribute a, ExtendedFileSystemAccess fsa ){
		val entityName = e.name.toFirstUpper
		var fieldName = ""
		var fieldDisplayName = ""
		var fieldClass = ""
		var fieldType = ""
		var manyTargetName = ""
		var manyBoxContent = ""
		var manyImports = ""
		var manyTableFormData = ""
		var manyTableFormMember = ""
		var lookUpCall = ""
		var smartFieldImports = ""
		var smartFieldPostfix = ""
		var isMandatory = ""
		var maxLength = ""
		var tableNewButton = ""
		var abstractTableFormType = "AbstractValueFieldData"
		
		val annotatedDisplayName = GeneratorUtilities.getName(a.annotations)
		if (!annotatedDisplayName.isNullOrEmpty){
			fieldDisplayName = annotatedDisplayName
		}
		
		switch a {
			case (a instanceof Member) : {
				val m = a as Member
				fieldName = m.name.toFirstUpper
				if (fieldDisplayName.isNullOrEmpty){
					fieldDisplayName = fieldName
				}
				if (m.enumeration != null){
					fieldName += "Code"
					var codeType = m.enumeration.name.toFirstUpper + "CodeType"
					smartFieldPostfix = "<Long>"
					fieldType = "<Long>"
					fieldClass = "Smart"
					lookUpCall = 
						'''
						
						@Override
						protected Class<? extends ICodeType<?, Long>> getConfiguredCodeType() {
						     return «codeType».class;
						}
						'''
						smartFieldImports = 
						'''
import org.eclipse.scout.rt.shared.services.common.code.ICodeType;
import «CrudmlGenerator.applicationName».shared.codetypes.«codeType»;
						'''
				} else {			
					fieldType = GeneratorUtilities.getJavaTypeFromType(m.primitive)
					fieldClass = fieldType
					fieldType = "<" + fieldType + ">"
				}
				
				if (fieldClass.equals("String")){
								maxLength = 
			'''

        @Override
        protected int getConfiguredMaxLength() {
          return «GeneratorUtilities.getLength(m.annotations)»;
        }
			'''
				}
			}
			case (a instanceof Reference) : {
				val r = a as Reference
				switch r.reftype {
					case "one" : {
						fieldName = r.name.toFirstUpper + CrudmlGenerator.primaryKeyPostfix
						if (fieldDisplayName.isNullOrEmpty){
							fieldDisplayName = r.name.toFirstUpper
						}
						fieldClass = "Smart"
						fieldType = "<Long>"
						smartFieldPostfix = "<Long>"
						lookUpCall = 
						'''
						
						@Override
						protected Class<? extends ILookupCall<Long>> getConfiguredLookupCall() {
							return «r.type.name.toFirstUpper»LookupCall.class;
						}
						'''
						smartFieldImports = 
						'''
import org.eclipse.scout.rt.shared.services.lookup.ILookupCall;
import «CrudmlGenerator.applicationName».shared.services.lookup.«r.type.name.toFirstUpper»LookupCall;
						'''
					}
					case "many" : {
						fieldName = r.name.toFirstUpper
						if (fieldDisplayName.isNullOrEmpty){
							fieldDisplayName = r.name.toFirstUpper
						}
						manyTargetName = r.type.name.toFirstUpper
						fieldClass = "Table"
						abstractTableFormType = "AbstractTableFieldData"
						
						manyImports = 
						'''
import org.eclipse.scout.rt.client.ui.basic.table.ITableRow;
import org.eclipse.scout.rt.client.ui.basic.table.columns.AbstractSmartColumn;
import org.eclipse.scout.rt.client.ui.form.fields.button.AbstractLinkButton;
import org.eclipse.scout.rt.client.ui.form.fields.tablefield.AbstractTableField;
import org.eclipse.scout.rt.extension.client.ui.action.menu.AbstractExtensibleMenu;
import org.eclipse.scout.rt.extension.client.ui.basic.table.AbstractExtensibleTable;
import «CrudmlGenerator.applicationName».client.ui.desktop.form.«e.name.toFirstUpper»Form.MainBox.New«manyTargetName»Button;
import «CrudmlGenerator.applicationName».shared.services.lookup.«manyTargetName»LookupCall;
						'''
						
						tableNewButton =
						'''
  
  /**
   * @return the New«manyTargetName»Button
   */
  public New«manyTargetName»Button getNew«manyTargetName»Button() {
    return getFieldByClass(New«manyTargetName»Button.class);
  }

						'''
						// insert new button into box
						fsa.modifyLines(CrudmlGenerator.getFile(FileType.Form, entityName), Identifier.FormBoxButtons, 
'''	

    @Order(40.0)
    public class New«manyTargetName»Button extends AbstractLinkButton {

      @Override
      protected String getConfiguredLabel() {
        return TEXTS.get("New«manyTargetName»");
      }

      @Override
      protected void execClickAction() throws ProcessingException {
        get«fieldName»Field().getTable().addRowByArray(
            new Object[]{null});
      }
    }
''')
						
						manyBoxContent = 
						'''
        
        @Override
        protected int getConfiguredGridH() {
          return 4;
        }

        @Override
        protected int getConfiguredGridW() {
          return 2;
        }

        @Override
        protected boolean getConfiguredLabelVisible() {
          return false;
        }

        @Order(10.0)
        public class Table extends AbstractExtensibleTable {

          @Override
          protected boolean getConfiguredAutoResizeColumns() {
            return true;
          }
          
          /**
           * @return the «fieldName»Column
           */
          public «fieldName»Column get«fieldName»Column() {
            return getColumnSet().getColumnByClass(«fieldName»Column.class);
          }

          @Order(10.0)
          public class «fieldName»Column extends AbstractSmartColumn<Long> {

            @Override
            protected String getConfiguredHeaderText() {
              return TEXTS.get("«fieldName»Field");
            }
            
            @Override
            protected boolean getConfiguredEditable() {
              return true;
            }

            @Override
            protected Class<? extends ILookupCall<Long>> getConfiguredLookupCall() {
              return «manyTargetName»LookupCall.class;
            }
          }

          @Order(10.0)
          public class Remove«manyTargetName»Menu extends AbstractExtensibleMenu {

            @Override
            protected String getConfiguredKeyStroke() {
              return "delete";
            }

            @Override
            protected String getConfiguredText() {
              return TEXTS.get("Delete«manyTargetName»");
            }

            @Override
            protected void execAction() throws ProcessingException {
              for (ITableRow r : getSelectedRows()) {
                deleteRow(r);
              }
            }
          }
        }
						'''
						
						// also extend the tableformdata
						val tableFormDataTableID = fieldName.toUpperCase + "_COLUMN_ID";
						
						manyTableFormMember =
						'''
    public static final int «tableFormDataTableID» = 0;
						'''
						
						manyTableFormData =
						'''
    
    public Long get«fieldName»(int row) {
      return (Long) getValueInternal(row, «tableFormDataTableID»);
    }

    public void set«fieldName»(int row, Long «fieldName.toFirstLower») {
      setValueInternal(row, «tableFormDataTableID», «fieldName.toFirstLower»);
    }

    @Override
    public int getColumnCount() {
      return 1;
    }

    @Override
    public Object getValueAt(int row, int column) {
      switch (column) {
        case «tableFormDataTableID»:
          return get«fieldName»(row);
        default:
          return null;
      }
    }

    @Override
    public void setValueAt(int row, int column, Object value) {
      switch (column) {
        case «tableFormDataTableID»:
          set«fieldName»(row, (Long) value);
          break;
      }
    }
						'''
						
						// finally we need to extend the store and load statement in the service
						var table = entityName + "_" + r.name
						var idcolumn = entityName + CrudmlGenerator.primaryKeyPostfix
						var targetcolumn = r.type.name + CrudmlGenerator.primaryKeyPostfix
						
						// load
						fsa.modifyLines(CrudmlGenerator.getFile(FileType.TableService, entityName), Identifier.ServiceSqlLoad, 
'''	

  SQL.select("" +
      "SELECT «targetcolumn.toUpperCase» " +
      "FROM «table.toUpperCase» " +
      "WHERE «idcolumn.toUpperCase» = :«idcolumn.toFirstLower» " +
      "INTO :«fieldName.toFirstLower» ",
      formData.get«fieldName»(),
      formData);
''')
						// create helper method
						fsa.modifyLines(CrudmlGenerator.getFile(FileType.TableService, entityName), Identifier.ServiceSqlHelper, 
'''	

private void update«fieldName»(«entityName»FormData formData) throws ProcessingException {
// empty columns are deleted
  for (int i = 0; i < formData.get«fieldName»().getRowCount(); i++) {
    if (formData.get«fieldName»().get«fieldName»(i) == null) {
      formData.get«fieldName»().setRowState(i, ITableHolder.STATUS_DELETED);
    }
  }
 
  SQL.delete("" +
      "DELETE FROM «table.toUpperCase» " +
      "WHERE «idcolumn.toUpperCase» = :«idcolumn.toFirstLower» " +
      "AND «targetcolumn.toUpperCase» = :{«fieldName.toFirstLower»}"
      , new TableHolderFilter(formData.get«fieldName»(), ITableHolder.STATUS_DELETED)
      , formData);
 
  SQL.insert("" +
      "INSERT INTO «table.toUpperCase» («idcolumn.toUpperCase», «targetcolumn.toUpperCase») " +
      "VALUES (:«idcolumn.toFirstLower», :{«fieldName.toFirstLower»}) "
      , new TableHolderFilter(formData.get«fieldName»(), ITableHolder.STATUS_INSERTED)
      , formData);
}
''')
						// store
						fsa.modifyLines(CrudmlGenerator.getFile(FileType.TableService, entityName), Identifier.ServiceSqlCreate,
'''	

// get the newly created id
SQL.select("SELECT MAX(«idcolumn.toUpperCase») " +
    "FROM «entityName.toUpperCase» " +
    "INTO :«idcolumn.toFirstLower»", formData);
    
update«fieldName»(formData);
''')
						fsa.modifyLines(CrudmlGenerator.getFile(FileType.TableService, entityName), Identifier.ServiceSqlStore,
'''	
update«fieldName»(formData);
''')
					}
				}
			}
		}
		
		// check annotations
		if(GeneratorUtilities.notNull(a.annotations)){
			isMandatory = 
			'''

        @Override
        protected boolean getConfiguredMandatory() {
          return true;
        }
			'''
		}
		
		// Register field name
		CrudmlGenerator.createStringEntry(fieldName + "Field", fieldDisplayName, fsa)
		
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.Form, entityName), Identifier.FormClassContent, 
'''	
  /**
   * @return the «fieldName»Field
   */
  public «fieldName»Field get«fieldName»Field(){
    return getFieldByClass(«fieldName»Field.class);
  }
  «tableNewButton»
''')

		fsa.modifyLines(CrudmlGenerator.getFile(FileType.Form, entityName), Identifier.FormBoxContent, 
'''	

      @Order(«formBoxOrder».0)
      public class «fieldName»Field extends Abstract«fieldClass»Field«smartFieldPostfix» {

        @Override
        protected String getConfiguredLabel() {
          return TEXTS.get("«fieldName»Field");
        }
        «isMandatory»
        «maxLength»
        «lookUpCall»
        «manyBoxContent»
      }
''')

		fsa.modifyLines(CrudmlGenerator.getFile(FileType.Form, entityName), Identifier.Imports, 
'''	
import «CrudmlGenerator.applicationName».client.ui.desktop.form.«entityName»Form.MainBox.«entityName»Box.«fieldName»Field;
«smartFieldImports»
«manyImports»
''')

		// now the formData
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.FormData, entityName), Identifier.Content, 
'''	

  public «fieldName» get«fieldName»() {
    return getFieldByClass(«fieldName».class);
  }
  
  public static class «fieldName» extends «abstractTableFormType»«fieldType» {

    private static final long serialVersionUID = 1L;
    «manyTableFormMember»

    public «fieldName»() {
    }
    «manyTableFormData»
  }
''')
		
	}
	
	def modifyTablePage(Entity e, ExtendedFileSystemAccess fsa){
		var name = e.name.toFirstUpper
		
		// imports
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.TablePage, name), Identifier.Imports, name,
'''	
import org.eclipse.scout.rt.extension.client.ui.action.menu.AbstractExtensibleMenu;
import «CrudmlGenerator.applicationName».client.ui.desktop.form.«name»Form;
import java.util.Set;
import org.eclipse.scout.commons.CollectionUtility;
import org.eclipse.scout.rt.client.ui.action.menu.IMenuType;
import org.eclipse.scout.rt.client.ui.action.menu.TableMenuType;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.I«name»Service;
import «CrudmlGenerator.applicationName».shared.ui.desktop.form.«name»FormData;
import org.eclipse.scout.rt.client.ui.messagebox.MessageBox;

''')
		
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.TablePage, name), Identifier.TableContent, name, 
'''	

    @Order(10.0)
    public class Edit«name»Menu extends AbstractExtensibleMenu {

      @Override
      protected String getConfiguredText() {
        return TEXTS.get("Edit«name»");
      }

      @Override
      protected void execAction() throws ProcessingException {
        «name»Form form = new «name»Form();
        form.set«name»Nr(get«name»NrColumn().getSelectedValue());
        form.startModify();
        form.waitFor();
        if (form.isFormStored()) {
          reloadPage();
        }
      }
    }
    
    @Order(20.0)
    public class New«name»Menu extends AbstractExtensibleMenu {

      @Override
      protected Set<? extends IMenuType> getConfiguredMenuTypes() {
        return CollectionUtility.<IMenuType> hashSet(TableMenuType.EmptySpace);
      }

      @Override
      protected String getConfiguredText() {
        return TEXTS.get("New«name»");
      }

      @Override
      protected void execAction() throws ProcessingException {
        «name»Form form = new «name»Form();
        form.startNew();
        form.waitFor();
        if (form.isFormStored()) {
          reloadPage();
        }
      }
    }
    
    @Order(20.0)
    public class Delete«name»Menu extends AbstractExtensibleMenu {

      @Override
      protected String getConfiguredText() {
        return TEXTS.get("Delete«name»");
      }

      @Override
      protected void execAction() throws ProcessingException {
        if (MessageBox.showDeleteConfirmationMessage("«name»")) {
          «name»FormData data = new «name»FormData();
          data.set«name»Nr(get«name»NrColumn().getSelectedValue());
          SERVICES.getService(I«name»Service.class).delete(data);
          reloadPage();
        }
      }
    }
''')
	}
	
	def registerInPlugins(Entity e, ExtendedFileSystemAccess fsa){
		
		// server
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerPlugin), Identifier.ExtensionService,
'''		<service
			factory="org.eclipse.scout.rt.server.services.ServerServiceFactory"
			class="«CrudmlGenerator.applicationName».server.ui.desktop.form.«e.name.toFirstUpper»Service"
			session="«CrudmlGenerator.applicationName».server.ServerSession">
		</service>''')
		
		// client
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ClientPlugin), Identifier.ExtensionService,
'''		<proxy
            factory="org.eclipse.scout.rt.client.services.ClientProxyServiceFactory"
            class="«CrudmlGenerator.applicationName».shared.ui.desktop.form.I«e.name.toFirstUpper»Service">
      </proxy>''')
	}
	
}