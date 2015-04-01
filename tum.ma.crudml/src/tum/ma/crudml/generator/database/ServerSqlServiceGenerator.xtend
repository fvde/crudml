package tum.ma.crudml.generator.database

import tum.ma.crudml.generator.IExtendedGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.generator.access.Component
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.generator.BaseGenerator

class ServerSqlServiceGenerator extends BaseGenerator {
	
	new(int priority) {
		super(priority)
	}
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {

		// create reference to export package
		fsa.addToLineEnd(CrudmlGenerator.getFile(FileType.ServerManifest), Identifier.PreviousExportPackage, ",")
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerManifest), Identifier.ExportPackages,''' «CrudmlGenerator.applicationName».server.services.common.sql''') 
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerManifest), Identifier.LastStatement, 
'''

''')
		
		// create reference to service
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerPlugin), Identifier.ExtensionService,
'''		<service
			factory="org.eclipse.scout.rt.server.services.ServerServiceFactory"
			class="«CrudmlGenerator.applicationName».server.services.common.sql.DerbySqlService"
			session="«CrudmlGenerator.applicationName».server.ServerSession">
		</service>''')

  		// Create sql service
  		fsa.generateFile(CrudmlGenerator.createFile(FileType.ServerSqlService, "src/" + CrudmlGenerator.applicationName + "/server/services/common/sql/DerbySqlService.java", Component.server),
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