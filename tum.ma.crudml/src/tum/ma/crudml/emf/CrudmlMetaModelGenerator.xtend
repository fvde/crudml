package tum.ma.crudml.emf

import org.eclipse.emf.ecore.EPackage
import java.io.File
import java.io.BufferedWriter
import java.io.FileWriter
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EDataType
import java.util.Map
import java.util.ArrayList
import java.util.HashMap
import org.eclipse.emf.ecore.EClass
import java.util.Queue
import java.util.Deque
import java.util.ArrayDeque

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
		var stringBuilder = new StringBuilder();

		// add some metadata first
		stringBuilder.append(
			'''
				metadata {
					author : unknown
					applicationName : «metaModelName»
					workspace : «metaModelName.toFirstUpper»
				}
				
			''')

		// Iterate through package contents and add to file
		for (EClassifier e : content.getEClassifiers()) {
			System.out.println("Parsing " + e.name + "...");

			if (e instanceof EClass) {
				classes.add(e)
			}
		}

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

		switch name {
			case name.contains("String"): return "string"
			case name.contains("Int"): return "int"
			case name.contains("Double"): return "double"
			case name.contains("Long"): return "long"
			case name.contains("Boolean") : return "boolean"
		}

		return "unknown:" + name
	}
}
