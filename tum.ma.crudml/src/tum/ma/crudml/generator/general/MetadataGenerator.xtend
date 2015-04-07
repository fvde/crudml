package tum.ma.crudml.generator.general

import tum.ma.crudml.generator.IExtendedGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.generator.BaseGenerator

class MetadataGenerator extends BaseGenerator{
	
	new(int priority) {
		super(priority)
	}
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		// APPLICATION NAME //
		CrudmlGenerator.createStringEntry(CrudmlGenerator.applicationName.toFirstUpper, fsa)
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutline), Identifier.Title, '''		return TEXTS.get("«CrudmlGenerator.applicationName.toFirstUpper»");''')
		
		// MANIFEST DECLARATIONS //
		// client
		fsa.addToLineEnd(CrudmlGenerator.getFile(FileType.ClientManifest), Identifier.PreviousExportPackage, ",")
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ClientManifest), Identifier.ExportPackages,
''' «CrudmlGenerator.applicationName».client.ui.desktop.form,
 «CrudmlGenerator.applicationName».client.ui.desktop.outlines.pages
 ''') 
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ClientManifest), Identifier.LastStatement, 
'''

''')
				
		// shared
		fsa.addToLineEnd(CrudmlGenerator.getFile(FileType.SharedManifest), Identifier.PreviousExportPackage, ",")
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.SharedManifest), Identifier.ExportPackages,
''' «CrudmlGenerator.applicationName».shared.ui.desktop.form,
 «CrudmlGenerator.applicationName».shared.ui.desktop.outlines.pages
''') 
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.SharedManifest), Identifier.LastStatement, 
'''

''')

		// server
		fsa.addToLineEnd(CrudmlGenerator.getFile(FileType.ServerManifest), Identifier.PreviousExportPackage, ",")
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerManifest), Identifier.ExportPackages,
''' «CrudmlGenerator.applicationName».server.ui.desktop.form,
 «CrudmlGenerator.applicationName».server.services.common.sql
''') 
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerManifest), Identifier.LastStatement, 
'''

''')
		
		// PLUGINS //
		// server
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.ServerPlugin), Identifier.ExtensionService,
'''		<service
			factory="org.eclipse.scout.rt.server.services.ServerServiceFactory"
			class="«CrudmlGenerator.applicationName».server.services.common.sql.DerbySqlService"
			session="«CrudmlGenerator.applicationName».server.ServerSession">
		</service>''')
	}	
}