package tum.ma.crudml.generator.utilities

import java.util.ArrayList

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
		
		for (var index = 0; index < a.length; index++){
			if (index == line){
				for (String newline : b){
					result.add(newline)
				}
			}
			
			result.add(a.get(index))
		}
		
		return result;
	}
}