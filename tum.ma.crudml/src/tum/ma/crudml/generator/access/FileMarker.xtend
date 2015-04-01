package tum.ma.crudml.generator.access

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class FileMarker {
	
	String identifier
	int line
	int size
	
	public static String markerTag = "___"
	public static String markerAttributeTag = ":"
	public static int markerNameIndex = 0
	public static int markerSizeIndex = 1
	
	new(String ident, int line, int size){
		this.identifier = ident
		this.line = line
		this.size = size
	}
}