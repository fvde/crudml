/*
 * generated by Xtext
 */
package tum.ma.crudml.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import tum.ma.crudml.crudml.Entity
import tum.ma.crudml.generator.access.ExtendedFile
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.generator.access.Identifier
import java.util.Map
import java.util.HashMap
import tum.ma.crudml.generator.access.Component
import java.util.ArrayList
import java.util.List
import java.util.Arrays
import tum.ma.crudml.generator.template.ScoutProjectGenerator
import tum.ma.crudml.generator.database.ServerSqlServiceGenerator
import tum.ma.crudml.crudml.Metadata
import tum.ma.crudml.crudml.MetadataEntry

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class CrudmlGenerator implements IGenerator {
		
	//TODO expose in crudml
	public static String workspaceFolder = "Application"
	public static String applicationName = "app"
	public static String author = "fvde"
	public static String dbAccess = "jdbc:derby:C:\\\\db\\\\DerbyDB"
	public static String dbUser = "minicrm"
	public static String dbPassword = "minicrm"
	
	// Some local variables
	public static Map<Identifier, ExtendedFile> Files = new HashMap<Identifier, ExtendedFile>()
	private List<IExtendedGenerator> oneTimeGenerators;
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {

		// extend file system access
		val efsa = new ExtendedFileSystemAccess(fsa)
		
		// Create template
		var templateGenerator = new ScoutProjectGenerator()
		templateGenerator.doGenerate(resource, efsa)
		
		// Create extended files and markers
		generateMarkers()
		
		// Parse metadata
		parseMetadata(resource)
		
		// Register onetime generators
		oneTimeGenerators = Arrays.asList(
			new ServerSqlServiceGenerator		
		)
		
		// Generate one time components
		for (IExtendedGenerator generator : oneTimeGenerators){
			generator.doGenerate(resource, efsa)
		}
	}
	
	def generateMarkers(){
		var standardOutline = createFile(Identifier.StandardOutline, "src/" + applicationName + "/client/ui/desktop/outlines/StandardOutline.java", Component.client)
		standardOutline.addMarker("title", 20, 1)
		var servermanifest = createFile(Identifier.ServerManifest, "META-INF/MANIFEST.MF", Component.server)
		servermanifest.addMarker("exportpackages", 11, 0)
		servermanifest.addMarker("previousexportpackage", 10, 0)
		servermanifest.addMarker("laststatement", 22, 0)
		var serverplugin = createFile(Identifier.ServerPlugin, "plugin.xml", Component.server)
		serverplugin.addMarker("extensionservice", 27, 0)
	}
	
	def parseMetadata(Resource resource){
		val entries = resource.allContents.toIterable.filter(MetadataEntry)
		for (MetadataEntry entry : entries){
			switch entry {
				case entry.type == "applicationName" : applicationName = entry.value
				case entry.type == "author" : author = entry.value
				case entry.type == "workspace" : workspaceFolder = entry.value
			}
		}
	}

	def static createFile(Identifier ident, String path, Component comp){
		var name = path.split("/").last
		var file = new ExtendedFile(prefix(comp) + path, name)
		Files.put(ident, file)
		return file
	}
			
	/**
	* Creates something like "Workspacefolder/applicationname.component/"
	**/	
	def static prefix(Component comp){
		return workspaceFolder + "/" + applicationName + "."+ comp.toString + "/"
	}
}
