package tum.ma.crudml.generator.database

import tum.ma.crudml.generator.IExtendedGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.generator.access.Component
import tum.ma.crudml.generator.CrudmlGenerator

class ServerSqlServiceGenerator implements IExtendedGenerator{
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {

		// create reference to export package
		fsa.addToLine(CrudmlGenerator.Files.get(Identifier.ServerManifest), "previousexportpackage", ",")
		fsa.modifyLines(CrudmlGenerator.Files.get(Identifier.ServerManifest), "laststatement", "Delete: thisline")
		fsa.modifyLines(CrudmlGenerator.Files.get(Identifier.ServerManifest), "exportpackages",''' «CrudmlGenerator.applicationName».server.services.common.sql''') 
		
		// create reference to service
		fsa.modifyLines(CrudmlGenerator.Files.get(Identifier.ServerPlugin), "extensionservice",
'''		<service
			factory="org.eclipse.scout.rt.server.services.ServerServiceFactory"
			class="«CrudmlGenerator.applicationName».server.services.common.sql.DerbySqlService"
			session="«CrudmlGenerator.applicationName».server.ServerSession">
		</service>''')

  		// Create sql service
  		fsa.generateFile(CrudmlGenerator.createFile(Identifier.ServerSqlService, "src/" + CrudmlGenerator.applicationName + "/server/services/common/sql/DerbySqlService.java", Component.server),
'''
/**
 * 
 */
package «CrudmlGenerator.applicationName».server.services.common.sql;

import org.eclipse.scout.rt.services.common.jdbc.AbstractDerbySqlService;

/**
 * @author «CrudmlGenerator.author»
 */
public class DerbySqlService extends AbstractDerbySqlService {
	
	@Override
	protected String getConfiguredJdbcMappingName() {
		return "«CrudmlGenerator.dbAccess»";
	}
		
	@Override
	protected String getConfiguredPassword() {
		return "«CrudmlGenerator.dbPassword»";
	}
		
	@Override
	protected String getConfiguredUsername() {
		return "«CrudmlGenerator.dbUser»";
	}
}
''')
  	
	}	
	
}