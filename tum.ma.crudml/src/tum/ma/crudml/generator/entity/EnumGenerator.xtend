package tum.ma.crudml.generator.entity

import tum.ma.crudml.generator.BaseGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.crudml.Enum
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.access.Component

class EnumGenerator extends BaseGenerator{
	
	new(int priority) {
		super(priority)
		
		currentCodeTypeId = 10000
	}
	
	private int currentCodeTypeId
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		// get enums
		val entries = input.allContents.toIterable.filter(Enum)
		
		for (Enum e : entries){
			generateEnum(e, fsa)
			currentCodeTypeId += 100
		}
	}
	
	def generateEnum(Enum e, ExtendedFileSystemAccess fsa) {
		val name = e.name.toFirstUpper
		var codes = ""
		var order = 0
		var codeCounter = 0
		
		// get codes
		for (String code : e.values){	
			var codeName = code.toFirstUpper
			order += 10
			codeCounter += 1
			codes +=
			'''
  
  @Order(«order».0)
  public static class «codeName»Code extends AbstractCode<Long> {

    private static final long serialVersionUID = 1L;
    /**
   * 
   */
    public static final Long ID = «currentCodeTypeId + codeCounter»L;

    @Override
    protected String getConfiguredText() {
      return TEXTS.get("«codeName»Code");
    }

    @Override
    public Long getId() {
      return ID;
    }
  }
			'''
			
			CrudmlGenerator.createStringEntry(codeName + "Code", code, fsa)
		}
		
		
		val form = fsa.generateFile(CrudmlGenerator.createFile(FileType.CodeType, name, "src/" + CrudmlGenerator.applicationName + "/shared/codetypes/" + name + "CodeType.java", Component.shared),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».shared.codetypes;

import org.eclipse.scout.commons.annotations.Order;
import org.eclipse.scout.commons.exception.ProcessingException;
import org.eclipse.scout.rt.shared.TEXTS;
import org.eclipse.scout.rt.shared.services.common.code.AbstractCode;
import org.eclipse.scout.rt.shared.services.common.code.AbstractCodeType;

/**
 * @author «CrudmlGenerator.author»
 */
public class «name»CodeType extends AbstractCodeType<Long, Long> {

  private static final long serialVersionUID = 1L;
  /**
 * 
 */
  public static final Long ID = «currentCodeTypeId»L;

  /**
   * @throws org.eclipse.scout.commons.exception.ProcessingException
   */
  public «name»CodeType() throws ProcessingException {
    super();
  }

  @Override
  protected String getConfiguredText() {
    return TEXTS.get("«name»");
  }

  @Override
  public Long getId() {
    return ID;
  }
  «codes»
}
''')

		CrudmlGenerator.createStringEntry(name, name, fsa)
	}
}