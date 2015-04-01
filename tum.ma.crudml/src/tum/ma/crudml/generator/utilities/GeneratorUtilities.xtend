package tum.ma.crudml.generator.utilities

import java.util.ArrayList
import tum.ma.crudml.generator.access.FileMarker
import tum.ma.crudml.generator.access.Identifier

class GeneratorUtilities {
	def static getStringFromArray(Iterable<String> iterable){
		var result = ""
		
		// Note the -1, for the last line we dont need another seperator
		for (var x = 0; x < iterable.length - 1; x++){
			result += iterable.get(x) + System.getProperty("line.separator")
		}
		
		result += iterable.get(iterable.length - 1);
		
		return result;
	}
	
	def static mergeAtLine(Iterable<String> a, Iterable<String> b, int line){
		var result = new ArrayList<String>();
		
		if (line >= a.length){
			result.addAll(a)
			result.addAll(b)
			return result
		}	
		
		for (var index = 0; index < a.length; index++){
			if (index == line){
				for (String newline : b){
					result.add(newline)
				}
			}
			
			result.add(a.get(index))
		}
		
		return result
	}
	
	def static createMarker(Identifier ident){
		createMarker(ident.toString, 0)
	}
	
	def static createMarker(Identifier ident, int size){
		createMarker(ident.toString, size)
	}
	
	def static createMarker(Identifier ident, String name){
		createMarker(ident.toString + name, 0)
	}
	
	def private static createMarker(String identifier, int size){
		return FileMarker.markerTag + identifier + FileMarker.markerAttributeTag + size + FileMarker.markerTag
	}
}