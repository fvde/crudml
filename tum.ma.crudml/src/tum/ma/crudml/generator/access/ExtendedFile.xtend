package tum.ma.crudml.generator.access

import java.io.File
import java.util.HashMap
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class ExtendedFile {
	
	String name
	String path
	private Map<String, FileMarker> markers
	
	new(File file){
		this(file.path, file.name)
	}

	new(String path, String name){
		this.path = path
		this.name = name
		markers = new HashMap<String, FileMarker>
	}
	
	def addMarker(Identifier identifier, int line){
		addMarker(identifier.toString, new FileMarker(line, 0))
	}
	
	def addMarker(Identifier identifier, int line, int size){
		addMarker(identifier.toString, new FileMarker(line, size))
	}
	
	def addMarker(Identifier identifier, String name, int line){
		addMarker(identifier.toString + name, new FileMarker(line, 0))
	}
	
	def addMarker(Identifier identifier, String name, int line, int size){
		addMarker(identifier.toString + name, new FileMarker(line, size))
	}
	
	private def addMarker(String identifier, FileMarker marker){
		markers.put(identifier, marker)
	}
	
	def getMarker(Identifier identifier, String name){
		return getMarker(identifier.toString + name)
	}
	
	def getMarker(Identifier identifier){
		return getMarker(identifier.toString)
	}
	
	private def getMarker(String ident){
		return markers.get(ident)
	}
	
	def insertLines(int numberOfLines, int atLine){
		for (FileMarker marker : markers.values){
			if (marker.line > atLine){
				marker.line = marker.line + numberOfLines
			}
		}
	}
}