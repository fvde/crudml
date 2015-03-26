package tum.ma.crudml.generator.access

import java.io.File
import java.util.HashMap
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class ExtendedFile {
	
	String name
	String path
	Map<String, FileMarker> markers
	
	new(File file){
		this(file.path, file.name)
	}

	new(String path, String name){
		this.path = path
		this.name = name
		markers = new HashMap<String, FileMarker>
	}
	
	def addMarker(String identifier, int line){
		markers.put(identifier, new FileMarker(line, 0))
	}
	
	def addMarker(String identifier, int line, int size){
		markers.put(identifier, new FileMarker(line, size))
	}
	
	def addMarker(String identifier, FileMarker marker){
		markers.put(identifier, marker)
	}
	
	def getMarker(String identifier){
		markers.get(identifier)
	}
	
	def insertLines(int numberOfLines, int atLine){
		for (FileMarker marker : markers.values){
			if (marker.line > atLine){
				marker.line = marker.line + numberOfLines
			}
		}
	}
}