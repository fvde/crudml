package tum.ma.crudml.generator.access

import java.io.File
import java.util.HashMap
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class ExtendedFile {
	
	String name
	String path
	
	new(File file){
		this(file.path, file.name)
	}

	new(String path, String name){
		this.path = path
		this.name = name
	}
	
	/*
	 * Only use for adding markers to template code!
	 */
	def addMarker(Identifier identifier, int atLine, int size, ExtendedFileSystemAccess fsa){
		fsa.addMarker(this, identifier, atLine, size)
	}
	
	def FileMarker getMarker(Identifier identifier, String name, ExtendedFileSystemAccess fsa){
		return getMarker(identifier.toString + name, fsa)
	}
	
	def getMarker(Identifier identifier, ExtendedFileSystemAccess fsa){
		return getMarker(identifier.toString, fsa)
	}
	
	private def getMarker(String ident, ExtendedFileSystemAccess fsa){
		val markers = fsa.getMarkers(this)
		val marker = markers.findFirst[x | x.identifier == ident]
		
		if (markers.length == 0 || marker == null){
			throw new Exception("Specified marker not found!")
		}
		
		return marker;
	}
}