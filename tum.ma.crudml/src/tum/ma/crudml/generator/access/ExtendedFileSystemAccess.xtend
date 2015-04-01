package tum.ma.crudml.generator.access

import java.io.InputStream
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IFileSystemAccessExtension
import org.eclipse.xtext.generator.IFileSystemAccessExtension3
import org.eclipse.xtext.util.RuntimeIOException
import tum.ma.crudml.generator.utilities.GeneratorUtilities
import java.util.ArrayList

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
	}
	
	def private insertLines(ExtendedFile file, String lines, int atLine){
		val currentContents = readTextFile(file)
		val currentLines = currentContents.toString.split(System.getProperty("line.separator")).toList
		val newLines = lines.split(System.getProperty("line.separator")).toList
		val result = GeneratorUtilities.mergeAtLine(currentLines, newLines, atLine - 1)
		
		// Update file
		generateFile(file, GeneratorUtilities.getStringFromArray(result))
	}
	
		
	def modifyLines(ExtendedFile file, Identifier identifier, String modification){
		modifyLines(file, identifier, "", modification)
	}
	
	def modifyLines(ExtendedFile file, Identifier identifier, String name, String modification){
		val marker = file.getMarker(identifier, name, this)
		
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
	
	def addToLineStart(ExtendedFile file, Identifier identifier, String addition){
		addToLine(file, identifier, "", addition, true)
	}
	
	def addToLineEnd(ExtendedFile file, Identifier identifier, String addition){
		addToLine(file, identifier, "", addition, false)
	}
	
	private def addToLine(ExtendedFile file, Identifier identifier, String name, String addition, boolean atTheBeginning){	
		val marker = file.getMarker(identifier, name, this)
		
		if (marker != null && marker.size == 0){
			addToLine(file, marker, addition, atTheBeginning)
		}
	}
	
	private def addToLine(ExtendedFile file, FileMarker marker, String addition, boolean atTheBeginning){	
		val contents = readTextFile(file)
		var lines = contents.toString.split(System.getProperty("line.separator")).toList
		
		if (atTheBeginning){
			lines.set(marker.line - 1, addition + lines.get(marker.line - 1))
		} else {
			lines.set(marker.line - 1, lines.get(marker.line - 1) + addition)
		}
		
		// Update file (No markers have changed!)
		generateFile(file, GeneratorUtilities.getStringFromArray(lines))
	}
	
	def addMarker(ExtendedFile file, Identifier identifier, int atLine, int size){
		addToLine(
			file, 
			new FileMarker(identifier.toString, atLine, size), 
			GeneratorUtilities.createMarker(identifier, size),
			true
		)
	}
	
	def getMarkers(ExtendedFile file){
		val lines = readTextFile(file).toString.split(System.getProperty("line.separator")).toList
		var markers = new ArrayList<FileMarker>()
		
		for (var line = 0; line < lines.length; line++){
			val tmp = lines.get(line).split(FileMarker.markerTag)
			if (tmp.length >= 2){
				// Note the + 1! This is to because most line annotation will start with 1 instead of zero
				markers.add(parseMarker(tmp.get(1), line + 1))
			}
		}
		
		return markers		
	}
	
	def removeMarkers(ExtendedFile file){
		var lines = readTextFile(file).toString.split(System.getProperty("line.separator")).toList
		var lineModified = false
		
		for (var line = 0; line < lines.length; line++){
			val tmp = lines.get(line).split(FileMarker.markerTag)
			if (tmp.length == 3){
				// last element in array contains actual line content
				lines.set(line, tmp.get(tmp.length - 1))
				lineModified = true;
			} else if (tmp.length == 2){
				// line was empty (i.e. import marker)
				lines.set(line, "")
				lineModified = true;
			}
		}
		
		if (lineModified){
			// Update file (No markers have changed!)
			generateFile(file, GeneratorUtilities.getStringFromArray(lines))
		}
	}
	
	private def parseMarker(String s, int atLine){
		val tmp = s.split(FileMarker.markerAttributeTag)
		return new FileMarker(tmp.get(FileMarker.markerNameIndex), atLine, Integer.parseInt(tmp.get(FileMarker.markerSizeIndex)))
	}
}