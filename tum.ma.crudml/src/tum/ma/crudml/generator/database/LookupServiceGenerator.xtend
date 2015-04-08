package tum.ma.crudml.generator.database

import tum.ma.crudml.generator.BaseGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.crudml.Entity
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.access.Identifier
import java.util.Arrays
import tum.ma.crudml.crudml.Attribute
import tum.ma.crudml.crudml.Member
import tum.ma.crudml.generator.access.Component
import java.util.ArrayList
import tum.ma.crudml.generator.utilities.GeneratorUtilities

class LookupServiceGenerator extends BaseGenerator {
	
	new(int priority) {
		super(priority)
	}
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		// get entities
		val entries = input.allContents.toIterable.filter(Entity)
		
		for (Entity e : entries){
			registerInPlugins(e, fsa)
			generateLookupService(e, fsa)
		}
	}
	
	def generateLookupService(Entity e, ExtendedFileSystemAccess fsa){
		
		var name = e.name.toFirstUpper
		var alias = "T"
		var primaryTable = (name + CrudmlGenerator.primaryKeyPostfix).toUpperCase
		
		// first identify descritors for the entity, that we can use to search
		var select = alias + "." + primaryTable
		var text = ""
		val descriptors = GeneratorUtilities.getDescriptors(e)
		
		if (descriptors.length > 0){
			var descriptorTables = ""
			for (Member m : descriptors){
				descriptorTables += alias + "." + m.name.toUpperCase + ", "
			}
			
			// remove ", "
			descriptorTables = descriptorTables.substring(0, descriptorTables.length - 2)
			
			select = select + ", " + descriptorTables
			text = "<text>  AND     UPPER(" + descriptorTables + ") LIKE UPPER(:text||'%') </text> "
		}	
		
		//server component
		val lookupService = fsa.generateFile(CrudmlGenerator.createFile(FileType.LookupService, name, "src/" + CrudmlGenerator.applicationName + "/server/services/lookup/" + name + "LookupService.java", Component.server),
'''
/**
 *
 */
package «CrudmlGenerator.applicationName».server.services.lookup;

import org.eclipse.scout.rt.server.services.lookup.AbstractSqlLookupService;
import «CrudmlGenerator.applicationName».shared.services.lookup.I«name»LookupService;

/**
 * @author «CrudmlGenerator.author»
 */
public class «name»LookupService extends AbstractSqlLookupService<Long> implements I«name»LookupService {

  @Override
  public String getConfiguredSqlSelect() {
    return "" +
        "SELECT  «select» " +
        "FROM    «name.toUpperCase» «alias» " +
        "WHERE   1=1 " +
        "<key>   AND     «alias».«primaryTable» = :key </key> " +
        "«text»" +
        "<all> </all> ";
  }
}
''')

		// shared components: LookupCall + ILookupService
		val lookupCall = fsa.generateFile(CrudmlGenerator.createFile(FileType.LookupCall, name, "src/" + CrudmlGenerator.applicationName + "/shared/services/lookup/" + name + "LookupCall.java", Component.shared),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».shared.services.lookup;

import org.eclipse.scout.rt.shared.services.lookup.ILookupService;
import org.eclipse.scout.rt.shared.services.lookup.LookupCall;

/**
 * @author «CrudmlGenerator.author»
 */
public class «name»LookupCall extends LookupCall<Long> {

  private static final long serialVersionUID = 1L;

  @Override
  protected Class<? extends ILookupService<Long>> getConfiguredService() {
    return I«name»LookupService.class;
  }
}
''')

		val lookupServiceInterface = fsa.generateFile(CrudmlGenerator.createFile(FileType.ILookupService, name, "src/" + CrudmlGenerator.applicationName + "/shared/services/lookup/I" + name + "LookupService.java", Component.shared),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».shared.services.lookup;

import org.eclipse.scout.rt.shared.services.lookup.ILookupService;

/**
 * @author «CrudmlGenerator.author»
 */
public interface I«name»LookupService extends ILookupService<Long> {
}
''')
	}
	

	
	
	def registerInPlugins(Entity e, ExtendedFileSystemAccess fsa){
		
		// server
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerPlugin), Identifier.ExtensionService,
'''		<service
			factory="org.eclipse.scout.rt.server.services.ServerServiceFactory"
			class="«CrudmlGenerator.applicationName».server.services.lookup.«e.name.toFirstUpper»LookupService"
			session="«CrudmlGenerator.applicationName».server.ServerSession">
		</service>''')
		
		// client
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ClientPlugin), Identifier.ExtensionService,
'''		<proxy
            factory="org.eclipse.scout.rt.client.services.ClientProxyServiceFactory"
            class="«CrudmlGenerator.applicationName».shared.services.lookup.I«e.name.toFirstUpper»LookupService">
      </proxy>''')
	}
}