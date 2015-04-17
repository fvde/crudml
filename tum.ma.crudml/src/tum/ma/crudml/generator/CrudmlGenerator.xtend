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
import tum.ma.crudml.generator.entity.EntityGenerator
import tum.ma.crudml.generator.general.MetadataGenerator
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.generator.general.MarkerGenerator
import tum.ma.crudml.generator.entity.AttributeGenerator
import tum.ma.crudml.generator.general.CleanUpGenerator
import java.sql.DatabaseMetaData
import tum.ma.crudml.crudml.PersistenceEntry
import tum.ma.crudml.crudml.DBTypeDefiniton
import tum.ma.crudml.crudml.DBSetupDefinition
import tum.ma.crudml.crudml.DBConnectionDefinition
import tum.ma.crudml.generator.entity.FormGenerator
import tum.ma.crudml.generator.database.LookupServiceGenerator
import tum.ma.crudml.generator.search.SearchGenerator
import tum.ma.crudml.generator.entity.EnumGenerator

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class CrudmlGenerator implements IGenerator {

	public static String workspaceFolder = "Application"
	public static String applicationName = "app"
	public static String author = "default"
	public static String dbType = "derby"
	public static boolean dbDropAndCreate = false;
	public static String dbAccess = "jdbc:derby:C:\\\\db\\\\DerbyDB"
	public static String dbUser = "minicrm"
	public static String dbPassword = "minicrm"
	public static String primaryKeyPostfix = "Nr"
	public static String codeTypePostfix = "Uid"
	public static int defaultStringLength = 100
	
	// Some local variables
	private static Map<String, ExtendedFile> Files = new HashMap<String, ExtendedFile>()
	private List<BaseGenerator> generators;
	private static List<String> registeredStrings;
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {

		// extend file system access
		val efsa = new ExtendedFileSystemAccess(fsa)
		
		// reset strings
		registeredStrings = new ArrayList<String>();
				
		// Parse metadata
		parseMetadata(resource)
		
		// Register generators. Numbers indicate priority, lower gets executed first
		// EXECUTION ORDER MATTERS, ONLY CHANGE OF YOU KNOW WHAT YOU'RE DOING
		generators = Arrays.asList(
			new ScoutProjectGenerator(0),
			new MarkerGenerator(1),
			new MetadataGenerator(5),
			new ServerSqlServiceGenerator(5),
			new EntityGenerator(5),
			new EnumGenerator(6),
			new AttributeGenerator(10),
			new FormGenerator(20),
			new LookupServiceGenerator(30),
			new SearchGenerator(40),
			new CleanUpGenerator(100)
		).sortBy[BaseGenerator x | x.priority]
		
		// Generate one time components
		for (BaseGenerator generator : generators){
			generator.doGenerate(resource, efsa)
		}
	}
	
	def parseMetadata(Resource resource){
		val metaEntries = resource.allContents.toIterable.filter(MetadataEntry)
		for (MetadataEntry entry : metaEntries){
			switch entry {
				case entry.type == "applicationName" : applicationName = entry.value
				case entry.type == "author" : author = entry.value
				case entry.type == "workspace" : workspaceFolder = entry.value
			}
		}
		
		val dbConnectionEntries = resource.allContents.toIterable.filter(DBConnectionDefinition)
		var path = ""
		for (DBConnectionDefinition entry : dbConnectionEntries){
			switch entry {
				case entry.type == "user" : dbUser = entry.value
				case entry.type == "password" : dbPassword = entry.value
				case entry.type == "path" : path = entry.value
			}
		}
		
		val dbtypeEntries = resource.allContents.toIterable.filter(DBTypeDefiniton)
		for (DBTypeDefiniton entry : dbtypeEntries){
			switch entry {
				case entry.value == "derby" : dbType = "derby"
			}
		}
		
		val dbsetupEntries = resource.allContents.toIterable.filter(DBSetupDefinition)
		for (DBSetupDefinition entry : dbsetupEntries){
			switch entry {
				case entry.value == "dropAndCreate" : dbDropAndCreate = true
				case entry.value == "none" : dbDropAndCreate = false
			}
		}
		
		if (!path.isNullOrEmpty){
			dbAccess = "jdbc:" + dbType + ":" + path;
		}
	}
	
	def static createStringEntry(String identifier, String content, ExtendedFileSystemAccess fsa){
		if (!registeredStrings.contains(identifier)){
			registeredStrings.add(identifier)
			fsa.modifyLines(getFile(FileType.Texts), Identifier.Content, identifier.toFirstUpper + "=" + content)
		}
	}
	
	def static createStringEntry(String string, ExtendedFileSystemAccess fsa){
		createStringEntry(string, string, fsa)
	}

	def static createFile(FileType ident, String path, Component comp){
		return createFile(ident.toString, path, comp)
	}
	
	def static createFile(FileType ident, String name, String path, Component comp){
		return createFile(ident.toString + name, path, comp)
	}
	
	private def static createFile(String custom, String path, Component comp){
		var name = path.split("/").last
		var file = new ExtendedFile(prefix(comp) + path, name)
		Files.put(custom, file)
		return file
	}
	
	def static getFile(FileType ident){
		return getFile(ident.toString)
	}
	
	def static getFile(FileType ident, String name){
		return getFile(ident.toString + name)
	}
	
	def static getFiles(){
		return Files.values
	}
	
	private def static getFile(String ident){
		return Files.get(ident)
	}

	def static prefix(Component comp){
		return workspaceFolder + "/" + applicationName + "."+ comp.toString + "/"
	}
}
