package tum.ma.crudml.generator.general

import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.BaseGenerator
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.ExtendedFile
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess

class CleanUpGenerator extends BaseGenerator {
	
	new(int priority) {
		super(priority)
	}
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {	
		// Iterate through all files and remove markers
		for (ExtendedFile e : CrudmlGenerator.getFiles){
			fsa.removeMarkers(e)
		}
	}
	
}