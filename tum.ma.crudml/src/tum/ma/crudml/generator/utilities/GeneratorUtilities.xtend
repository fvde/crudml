package tum.ma.crudml.generator.utilities

import java.util.ArrayList
import tum.ma.crudml.generator.access.FileMarker
import tum.ma.crudml.generator.access.Identifier
import tum.ma.crudml.crudml.Entity
import tum.ma.crudml.crudml.Member
import tum.ma.crudml.crudml.Attribute
import tum.ma.crudml.crudml.Annotation
import tum.ma.crudml.generator.CrudmlGenerator

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
	
	def static createMarker(Identifier ident, String name, int size){
		createMarker(ident.toString + name, size)
	}
	
	def private static createMarker(String identifier, int size){
		return FileMarker.markerTag + identifier + FileMarker.markerAttributeTag + size + FileMarker.markerTag
	}
	
	def static getDescriptor(Entity e){

		// use descriptor annotation preferably
		for (Attribute a : e.attributes){
			if (a instanceof Member){
				val member = a as Member
					
				if (isDescriptor(member.annotations)){
					return member
				}
			}
		}
		
		for (Attribute a : e.attributes){
			if (a instanceof Member){
				val member = a as Member
				val name = member.name.toLowerCase
					
				if (member.primitive.equals("string")){
					// search for common keywords for descriptors
					if (name.equals("name") || name.equals("id")){
						return member
					}
				}
			}		
		}		
		return null
	}
		
	def static getDBTypeFromType(String type){
		switch type {
			case "string" : return "VARCHAR"
			case "int" : return "INTEGER"
			case "long" : return "BIGINT"
			case "double" : return "DOUBLE"
			case "boolean" : return "BOOLEAN"
			case "date" : return "DATE"
		}
	}
	
	def static getJavaTypeFromType(String type){
		switch type {
			case "string" : return "String"
			case "int" : return "Integer"
			case "long" : return "Long"
			case "double" : return "Double"
			case "boolean" : return "Boolean"
		}
	}
	
	def static getLength(Iterable<Annotation> annotations){
		val a = getAnnotation(annotations, "@Length")
		if (a != null){
			return a.length
		}

		return CrudmlGenerator.defaultStringLength
	}	
	
	def static notNull(Iterable<Annotation> annotations){
		val a = getAnnotation(annotations, "@NotNull")
		return a != null
	}
	
	def static getName(Iterable<Annotation> annotations){
		val a = getAnnotation(annotations, "@Name")
		if (a != null){
			return a.name
		}

		return ""
	}
	
	def static isDescriptor(Iterable<Annotation> annotations){
		val a = getAnnotation(annotations, "@Descriptor")
		return a != null
	}
	
	def static getAnnotation(Iterable<Annotation> annotations, String type){
		for (Annotation a : annotations){
			if (a.annotation.startsWith(type)){
				return a
			}
		}
	}
}