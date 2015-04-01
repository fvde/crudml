package tum.ma.crudml.generator.general

import tum.ma.crudml.generator.BaseGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.Component

class MarkerGenerator extends BaseGenerator {
	
	new(int priority) {
		super(priority)
	}
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		
		/// CLIENT ///
		var standardOutline = CrudmlGenerator.createFile(FileType.StandardOutline, "src/" + CrudmlGenerator.applicationName + "/client/ui/desktop/outlines/StandardOutline.java", Component.client)

		var clientmanifest = CrudmlGenerator.createFile(FileType.ClientManifest, "META-INF/MANIFEST.MF", Component.client)
		clientmanifest.addMarker(Identifier.ExportPackages, 10, 0, fsa)
		clientmanifest.addMarker(Identifier.PreviousExportPackage, 9, 0, fsa)
		
		/// SERVER ///
		var servermanifest = CrudmlGenerator.createFile(FileType.ServerManifest, "META-INF/MANIFEST.MF", Component.server)
		servermanifest.addMarker(Identifier.ExportPackages, 11, 0, fsa)
		servermanifest.addMarker(Identifier.PreviousExportPackage, 10, 0, fsa)
		var serverplugin = CrudmlGenerator.createFile(FileType.ServerPlugin, "plugin.xml", Component.server)
		serverplugin.addMarker(Identifier.ExtensionService, 27, 0, fsa)
		
		/// SHARED ///
		var sharedmanifest = CrudmlGenerator.createFile(FileType.SharedManifest, "META-INF/MANIFEST.MF", Component.shared)
		sharedmanifest.addMarker(Identifier.ExportPackages, 10, 0, fsa)
		sharedmanifest.addMarker(Identifier.PreviousExportPackage, 9, 0, fsa)
		var texts = CrudmlGenerator.createFile(FileType.Texts, "resources/texts/Texts.properties", Component.shared)
		texts.addMarker(Identifier.Content, 3, 0, fsa)
	}
	
}