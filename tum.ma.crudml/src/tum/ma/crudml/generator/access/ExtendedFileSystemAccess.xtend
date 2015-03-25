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
		val result = lines.filter[x | lines.indexOf(x) < from || lines.indexOf(x) > to]
		
		generateFile(file, GeneratorUtilities.getStringFromArray(result))
	}
	
	def private insertLines(ExtendedFile file, String lines, int atLine){
		val currentContents = readTextFile(file)
		val currentLines = currentContents.toString.split(System.getProperty("line.separator")).toList
		val newLines = lines.split(System.getProperty("line.separator")).toList
		val result = GeneratorUtilities.mergeAtLine(currentLines, newLines, atLine)
		
		generateFile(file, GeneratorUtilities.getStringFromArray(result))
	}
	
	def updateLines(ExtendedFile file, String identifier, String update){
		val marker = file.getMarker(identifier)
		
		// delete lines if marker has size
		if (marker.size > 0){
			deleteLines(file, marker.line, marker.line + marker.size)
		}

		// insert lines if there are any
		if (!update.isNullOrEmpty){
			insertLines(file, update, marker.line)
		}
	}

}