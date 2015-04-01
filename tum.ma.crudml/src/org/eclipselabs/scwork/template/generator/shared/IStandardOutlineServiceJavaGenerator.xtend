package org.eclipselabs.scwork.template.generator.shared

import org.eclipselabs.scwork.template.InputParam
import org.eclipselabs.scwork.template.ProjectType
import org.eclipselabs.scwork.template.generator.ITextFileGenerator

import static extension org.eclipselabs.scwork.template.generator.common.GeneratorExtensions.*
import tum.ma.crudml.generator.utilities.GeneratorUtilities
import tum.ma.crudml.generator.access.Identifier

class IStandardOutlineServiceJavaGenerator implements ITextFileGenerator {
	
	override shouldGenerate(InputParam param) {
		param.sharedIncluded && param.projectType == ProjectType.OUTLINE_BASED_APPLICATION
	}
	
	override provideFile(InputParam param) {
		param.sharedSourceFile(#["services", "IStandardOutlineService.java"])
	}
	
	override provideContent(InputParam param) 
'''
«param.copyrightHeader»
package «param.sharedProjectName».services;

import org.eclipse.scout.service.IService;
«GeneratorUtilities.createMarker(Identifier.Imports)»
/**
 * «param.authorName.box("@author ", "")»
 */
public interface IStandardOutlineService extends IService {
«GeneratorUtilities.createMarker(Identifier.Content)»}
'''
}
