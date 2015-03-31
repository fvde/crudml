package tum.ma.crudml.generator.access

import java.io.InputStream
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IFileSystemAccessExtension
import org.eclipse.xtext.generator.IFileSystemAccessExtension3
import org.eclipse.xtext.util.RuntimeIOException
import tum.ma.crudml.generator.utilities.GeneratorUtilities

@Accessors class ExtendedFileSystemAccess {
	
	private IFileSystemAccess fileSystemAccess
	private String outputConfigurationName = IFileSystemAccess.DEFAULT_OUTPUT
	
	new(){
		// Make sure to set fileSystemAccess manually!
	}
	
	new(IFileSystemAccess access) {
		fileSystemAccess = access
	}
	
	def deleteFile(ExtendedFile file){
		deleteFile(file, outputConfigurationName)
	}
	
	def deleteFile(ExtendedFile file, String outputConfigurationName) {
		val efsa = fileSystemAccess as IFileSystemAccessExtension;
		efsa.deleteFile(file.path, outputConfigurationName)
	}
		
	def generateFile(ExtendedFile file, CharSequence contents) {
		generateFile(file, outputConfigurationName, contents)
	}
	
	def generateFile(ExtendedFile file, String outputConfigurationName, CharSequence contents) {
		fileSystemAccess.generateFile(file.path, outputConfigurationName, contents)
		return file;
	}
	
	def generateFile(ExtendedFile file, InputStream content) throws RuntimeIOException {
		generateFile(file, outputConfigurationName, content)
	}
	
	def generateFile(ExtendedFile file, String outputCfgName, InputStream content) throws RuntimeIOException {
		val efsa = fileSystemAccess as IFileSystemAccessExtension3;
		efsa.generateFile(file.path, outputCfgName, content) 
	}
	
	def readBinaryFile(ExtendedFile file) throws RuntimeIOException {
		readBinaryFile(file, outputConfigurationName)
	}
	
	def readBinaryFile(ExtendedFile file, String outputCfgName) throws RuntimeIOException {
		val efsa = fileSystemAccess as IFileSystemAccessExtension3;
		efsa.readBinaryFile(file.path, outputCfgName) 
	}
	
	def readTextFile(ExtendedFile file) throws RuntimeIOException {
		readTextFile(file, outputConfigurationName)
	}
	
	def readTextFile(ExtendedFile file, String outputCfgName) throws RuntimeIOException {
		val efsa = fileSystemAccess as IFileSystemAccessExtension3;
		efsa.readTextFile(file.path, outputCfgName) 
	}
	
	def private deleteLines(ExtendedFile file, int from, int to){
		val currentContents = readTextFile(file)
		val lines = currentContents.toString.split(System.getProperty("line.separator"))
		val result = lines.filter[x | lines.indexOf(x) < from - 1 || lines.indexOf(x) >= to - 1]
		
		// Update file
		generateFile(file, GeneratorUtilities.getStringFromArray(result))
		
		// Update markers
		file.insertLines(to - from - 1, from)
	}
	
	def private insertLines(ExtendedFile file, String lines, int atLine){
		val currentContents = readTextFile(file)
		val currentLines = currentContents.toString.split(System.getProperty("line.separator")).toList
		val newLines = lines.split(System.getProperty("line.separator")).toList
		val result = GeneratorUtilities.mergeAtLine(currentLines, newLines, atLine - 1)
		
		// Update file
		generateFile(file, GeneratorUtilities.getStringFromArray(result))
		
		// Update markers
		file.insertLines(newLines.length, atLine)
	}
	
		
	def modifyLines(ExtendedFile file, Identifier identifier, String modification){
		modifyLines(file, identifier, "", modification)
	}
	
	def modifyLines(ExtendedFile file, Identifier identifier, String name, String modification){
		val marker = file.getMarker(identifier, name)
		
		if (marker == null){
			throw new Exception("Specified marker not found!")
		}
		
		// delete lines if marker has size
		if (marker.size > 0){
			deleteLines(file, marker.line, marker.line + marker.size)
		}

		// insert lines if there are any
		if (!modification.isNullOrEmpty){
			insertLines(file, modification, marker.line)
		}
	}
	
	def addToLine(ExtendedFile file, Identifier identifier, String addition){
		addToLine(file, identifier, "", addition)
	}
	
	def addToLine(ExtendedFile file, Identifier identifier, String name, String addition){	
		val marker = file.getMarker(identifier, name)
		
		if (marker != null && marker.size == 0){
			val contents = readTextFile(file)
			var lines = contents.toString.split(System.getProperty("line.separator")).toList
			lines.set(marker.line - 1, lines.get(marker.line - 1) + addition)
			
			// Update file (No markers have changed!)
			generateFile(file, GeneratorUtilities.getStringFromArray(lines))
		}
	}
}