package tum.ma.crudml.generator.access

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class FileMarker {
	
	int line
	int size
	
	new(int line, int size){
		this.line = line
		this.size = size
	}
}