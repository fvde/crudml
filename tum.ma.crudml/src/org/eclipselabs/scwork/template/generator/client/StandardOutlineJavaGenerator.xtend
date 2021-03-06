package org.eclipselabs.scwork.template.generator.client

import org.eclipselabs.scwork.template.InputParam
import org.eclipselabs.scwork.template.ProjectType
import org.eclipselabs.scwork.template.generator.ITextFileGenerator

import static extension org.eclipselabs.scwork.template.generator.common.GeneratorExtensions.*
import tum.ma.crudml.generator.utilities.GeneratorUtilities
import tum.ma.crudml.generator.access.Identifier

class StandardOutlineJavaGenerator implements ITextFileGenerator {
	
	override shouldGenerate(InputParam param) {
		param.clientIncluded && param.projectType == ProjectType.OUTLINE_BASED_APPLICATION
	}
	
	override provideFile(InputParam param) {
		param.clientSourceFile(#["ui", "desktop", "outlines", "StandardOutline.java"])
	}
	
	override provideContent(InputParam param) 
'''
«param.copyrightHeader»
package «param.clientProjectName».ui.desktop.outlines;

import org.eclipse.scout.rt.extension.client.ui.desktop.outline.AbstractExtensibleOutline;
import org.eclipse.scout.rt.shared.TEXTS;
«GeneratorUtilities.createMarker(Identifier.Imports)»

/**
 * «param.authorName.box("@author ", "")»
 */
public class StandardOutline extends AbstractExtensibleOutline {

  @Override
  protected String getConfiguredTitle() {
«GeneratorUtilities.createMarker(Identifier.Title, 1)»    return TEXTS.get("StandardOutline");
  }
«GeneratorUtilities.createMarker(Identifier.Content)»}
'''
}
