package tum.ma.crudml.emf

import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.util.ArrayDeque
import java.util.ArrayList
import java.util.Deque
import java.util.HashMap
import java.util.Map
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EEnumLiteral
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.impl.EEnumImpl

class CrudmlMetaModelGenerator {

	EPackage content
	String outputDir
	Map<String, ArrayList<String>> attributes
	Deque<EClass> classes
	int loopSafetyMeasure

	new(EPackage contents, String out) {
		content = contents
		outputDir = out
		attributes = new HashMap<String, ArrayList<String>>
		classes = new ArrayDeque<EClass>()
		loopSafetyMeasure = 0
	}

	def doGenerate() {
		val metaModelName = content.name
		val metaModelFile = new File(outputDir + metaModelName.toString + ".crudml")

		var writer = new BufferedWriter(new FileWriter(metaModelFile));
		val stringBuilder = new StringBuilder();

		// add some metadata first
		stringBuilder.append(
			'''
				metadata {
					author : unknown
					applicationName : «metaModelName»
					workspace : «metaModelName.toFirstUpper»
				}
				
				persistence {
					password : minicrm
					user : minicrm
					type : derby
					path : "C:\\\\db\\\\DerbyDB"
					setup : dropAndCreate
				}
				
			''')

		// Iterate through package contents and add to file
//		for (EClassifier e : content.getEClassifiers()) {
//			System.out.println("Parsing " + e.name + "...");
//
//			if (e instanceof EClass) {
//				classes.add(e)
//			}
//			
//			// enums we can process right away
//			if (e instanceof EEnum){
//				generateEnum(e as EEnum, stringBuilder)
//			}
//		}
		
		content.eAllContents.forEach[EObject e |
			System.out.println("Parsing " + e.toString + "...");

			if (e instanceof EClass) {
				classes.add(e)
			}
			
			// enums we can process right away
			if (e instanceof EEnum){
				generateEnum(e as EEnum, stringBuilder)
			}		
		]

		// process types with supertypes gradually
		while (classes.length > 0) {
			val current = classes.pop
			loopSafetyMeasure++

			if (loopSafetyMeasure > 100) {
				throw new Exception(
					"Endless loop in super types detected, aborting. Remaining classes: " + classes.toString)
			}

			if (current.ESuperTypes.length > 0 && classes.contains(current.ESuperTypes.get(0))) {
				classes.addLast(current)
			} else {
				attributes.put(current.name.toFirstUpper, new ArrayList())
				stringBuilder.append(
					'''
						entity «current.name.toFirstUpper» {
					''')

				// process super class attributes if there are any
				// at this point we can assume that the super class has been process already
				if (current.ESuperTypes.length > 0) {
					val superClass = current.ESuperTypes.get(0)
					if (superClass.name != null) {
						for (String superAttribute : attributes.get(superClass.name.toFirstUpper)) {
							stringBuilder.append(superAttribute);
							attributes.get(current.name.toFirstUpper).add(superAttribute)
						}
					}
				}

				for (EObject o : current.eContents()) {
					System.out.println("Parsing " + current.name + ": " + o.toString + "...");
					generateAttribute(o, current.name.toFirstUpper, stringBuilder)
				}
				stringBuilder.append(
					'''
						}
						
					''');
			}
		}

		// write
		writer.write(stringBuilder.toString)

		//Close writer
		writer.close();
	}
	
	private def generateEnum(EEnum e, StringBuilder builder){
		var enumName = e.name.toFirstUpper
		
		builder.append(
					'''
						enum «enumName» {
					''')
					
		for (EEnumLiteral literal : e.ELiterals){
			builder.append(
					'''
						«literal.name.toFirstUpper»
					''')
		}
					
		builder.append(
					'''
						}
						
					''')
		
	}

	private def generateAttribute(EObject o, String entityName, StringBuilder builder) {
		var typePrefix = ""
		var type = ""
		var name = ""

		if (o instanceof EAttribute) {
			val attribute = o as EAttribute
			name = attribute.name.toFirstLower
			type = getType(attribute.EAttributeType)
		} else if (o instanceof EReference) {
			val reference = o as EReference
			name = reference.name.toFirstLower
			type = reference.EType.name.toFirstUpper

			if (reference.lowerBound == 1) {
				typePrefix = "one "
			} else {
				typePrefix = "many "
			}
		}

		if (!name.nullOrEmpty && !type.nullOrEmpty) {
			val attributeLine = '''
				«typePrefix»«name» : «type»
			'''

			attributes.get(entityName).add(attributeLine)
			builder.append(attributeLine)
		}
	}

	private def getType(EDataType eType) {
		var name = eType.name

		if (name == null) {
			return "unknown:" + name
		}
		
		if (eType instanceof EEnumImpl){
			return name;
		}

		switch name {
			case name.contains("String"): return "string"
			case name.contains("Int"): return "int"
			case name.contains("Double"): return "double"
			case name.contains("Long"): return "long"
			case name.contains("Boolean") : return "boolean"
			// TODO enventually
			case name.contains("Date") : return "string"
			case name.contains("Object") : return "string"
		}

		return "unknown:" + name
	}
}
