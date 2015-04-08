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
			modifyTablePage(e, fsa)
			generateForm(e, fsa)
			generateService(e, fsa)
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
import org.eclipse.scout.rt.shared.TEXTS;
import org.eclipse.scout.service.SERVICES;
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
					tableNames += attribute.name.toUpperCase + ", "
					bindings += ":" + attribute.name.toFirstLower + ", "
					setTable += attribute.name.toUpperCase + " = :" + attribute.name.toFirstLower + ", "
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
    return formData;
  }

  @Override
  public «name»FormData load(«name»FormData formData) throws ProcessingException {
    if (!ACCESS.check(new Read«name»Permission())) {
      throw new VetoException(TEXTS.get("AuthorizationFailed"));
    }
    
«sqlLoad»
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
  public «name»FormData store(«name»FormData formData) throws ProcessingException {
    if (!ACCESS.check(new Update«name»Permission())) {
      throw new VetoException(TEXTS.get("AuthorizationFailed"));
    }

«sqlStore»
    return formData;
  }
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
		var fieldClass = ""
		var fieldType = ""
		var lookUpCall = ""
		var smartFieldImports = ""
		var smartFieldPostfix = ""
		
		switch a {
			case (a instanceof Member) : {
				fieldName = (a as Member).name.toFirstUpper
				fieldType = GeneratorUtilities.getJavaTypeFromType((a as Member).primitive)
				fieldClass = fieldType
			}
			case (a instanceof Reference) : {
				val r = a as Reference
				switch r.reftype {
					case "one" : {
						fieldName = r.name.toFirstUpper + CrudmlGenerator.primaryKeyPostfix
						fieldClass = "Smart"
						fieldType = "Long"
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
						//TODO
					}
				}
			}
		}
		
		// Register field name //TODO annotation
		CrudmlGenerator.createStringEntry(fieldName + "Field", fieldName, fsa)
		
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.Form, entityName), Identifier.FormClassContent, 
'''	
  /**
   * @return the «fieldName»Field
   */
  public «fieldName»Field get«fieldName»Field(){
    return getFieldByClass(«fieldName»Field.class);
  }
''')

		fsa.modifyLines(CrudmlGenerator.getFile(FileType.Form, entityName), Identifier.FormBoxContent, 
'''	

      @Order(«formBoxOrder».0)
      public class «fieldName»Field extends Abstract«fieldClass»Field«smartFieldPostfix» {

        @Override
        protected String getConfiguredLabel() {
          return TEXTS.get("«fieldName»Field");
        }
        «lookUpCall»
      }
''')

		fsa.modifyLines(CrudmlGenerator.getFile(FileType.Form, entityName), Identifier.Imports, 
'''	
import «CrudmlGenerator.applicationName».client.ui.desktop.form.«entityName»Form.MainBox.«entityName»Box.«fieldName»Field;
«smartFieldImports»
''')

		// now the formData
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.FormData, entityName), Identifier.Content, 
'''	

  public «fieldName» get«fieldName»() {
    return getFieldByClass(«fieldName».class);
  }
  
  public static class «fieldName» extends AbstractValueFieldData<«fieldType»> {

    private static final long serialVersionUID = 1L;

    public «fieldName»() {
    }
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