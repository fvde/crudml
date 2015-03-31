package tum.ma.crudml.generator.general

import tum.ma.crudml.generator.IExtendedGenerator
import org.eclipse.emf.ecore.resource.Resource
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess
import tum.ma.crudml.generator.CrudmlGenerator
import tum.ma.crudml.generator.access.FileType
import tum.ma.crudml.generator.access.Identifier

class MetadataGenerator implements IExtendedGenerator{
	
	override doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		// application name
		CrudmlGenerator.createStringEntry(CrudmlGenerator.applicationName.toFirstUpper, fsa)
		fsa.modifyLines(CrudmlGenerator.getFile(FileType.StandardOutline), Identifier.Title, '''		return TEXTS.get("«CrudmlGenerator.applicationName.toFirstUpper»");''')
	}	
}