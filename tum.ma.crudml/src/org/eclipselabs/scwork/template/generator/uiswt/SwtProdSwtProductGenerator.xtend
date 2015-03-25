package org.eclipselabs.scwork.template.generator.uiswt

import org.eclipselabs.scwork.template.InputParam
import org.eclipselabs.scwork.template.generator.ITextFileGenerator

import static extension org.eclipselabs.scwork.template.generator.common.GeneratorExtensions.*

class SwtProdSwtProductGenerator implements ITextFileGenerator {
	
	override shouldGenerate(InputParam param) {
		param.uiswtIncluded
	}
	
	override provideFile(InputParam param) {
		param.uiswtFile(#["products", "production", param.projectAlias + "-swt-client.product"])
	}
	
	override provideContent(InputParam param) 
'''
<?xml version="1.0" encoding="UTF-8"?>
<?pde version="3.5"?>

<product name="«param.projectAlias»" id="«param.uiswtProjectName».product" application="«param.uiswtProjectName».application" useFeatures="false" includeLaunchers="true">

   <configIni use="default">
      <linux>/«param.uiswtProjectName»/products/production/config.ini</linux>
      <macosx>/«param.uiswtProjectName»/products/production/config.ini</macosx>
      <win32>/«param.uiswtProjectName»/products/production/config.ini</win32>
   </configIni>

   <launcherArgs>
      <vmArgs>-Xms64m
-Xmx512m
      </vmArgs>
      <vmArgsMac>-Dorg.eclipse.swt.internal.carbon.smallFonts
      </vmArgsMac>
   </launcherArgs>

   <windowImages/>

   <splash
      location="«param.uiswtProjectName»" />
   <launcher name="«param.projectAlias»">
      <solaris/>
      <win useIco="false">
         <bmp/>
      </win>
   </launcher>

   <vm>
   </vm>

   <plugins>
      <plugin id="«param.clientProjectName»"/>
      <plugin id="«param.sharedProjectName»"/>
      <plugin id="«param.uiswtProjectName»"/>
      <plugin id="com.ibm.icu"/>
      <plugin id="javax.annotation"/>
      <plugin id="javax.inject"/>
      <plugin id="javax.xml"/>
      <plugin id="org.apache.batik.bridge"/>
      <plugin id="org.apache.batik.css"/>
      <plugin id="org.apache.batik.dom"/>
      <plugin id="org.apache.batik.dom.svg"/>
      <plugin id="org.apache.batik.ext.awt"/>
      <plugin id="org.apache.batik.parser"/>
      <plugin id="org.apache.batik.svggen"/>
      <plugin id="org.apache.batik.swing"/>
      <plugin id="org.apache.batik.transcoder"/>
      <plugin id="org.apache.batik.util"/>
      <plugin id="org.apache.batik.util.gui"/>
      <plugin id="org.apache.batik.xml"/>
      <plugin id="org.eclipse.compare.core"/>
      <plugin id="org.eclipse.core.commands"/>
      <plugin id="org.eclipse.core.contenttype"/>
      <plugin id="org.eclipse.core.databinding"/>
      <plugin id="org.eclipse.core.databinding.observable"/>
      <plugin id="org.eclipse.core.databinding.property"/>
      <plugin id="org.eclipse.core.expressions"/>
      <plugin id="org.eclipse.core.filebuffers"/>
      <plugin id="org.eclipse.core.filesystem"/>
      <plugin id="org.eclipse.core.jobs"/>
      <plugin id="org.eclipse.core.net"/>
      <plugin id="org.eclipse.core.resources"/>
      <plugin id="org.eclipse.core.runtime"/>
      <plugin id="org.eclipse.e4.core.commands"/>
      <plugin id="org.eclipse.e4.core.contexts"/>
      <plugin id="org.eclipse.e4.core.di"/>
      <plugin id="org.eclipse.e4.core.di.extensions"/>
      <plugin id="org.eclipse.e4.core.services"/>
      <plugin id="org.eclipse.e4.ui.bindings"/>
      <plugin id="org.eclipse.e4.ui.css.core"/>
      <plugin id="org.eclipse.e4.ui.css.swt"/>
      <plugin id="org.eclipse.e4.ui.css.swt.theme"/>
      <plugin id="org.eclipse.e4.ui.di"/>
      <plugin id="org.eclipse.e4.ui.model.workbench"/>
      <plugin id="org.eclipse.e4.ui.services"/>
      <plugin id="org.eclipse.e4.ui.widgets"/>
      <plugin id="org.eclipse.e4.ui.workbench"/>
      <plugin id="org.eclipse.e4.ui.workbench.addons.swt"/>
      <plugin id="org.eclipse.e4.ui.workbench.renderers.swt"/>
      <plugin id="org.eclipse.e4.ui.workbench.swt"/>
      <plugin id="org.eclipse.e4.ui.workbench3"/>
      <plugin id="org.eclipse.emf.common"/>
      <plugin id="org.eclipse.emf.ecore"/>
      <plugin id="org.eclipse.emf.ecore.change"/>
      <plugin id="org.eclipse.emf.ecore.xmi"/>
      <plugin id="org.eclipse.equinox.app"/>
      <plugin id="org.eclipse.equinox.common"/>
      <plugin id="org.eclipse.equinox.ds"/>
      <plugin id="org.eclipse.equinox.event"/>
      <plugin id="org.eclipse.equinox.preferences"/>
      <plugin id="org.eclipse.equinox.registry"/>
      <plugin id="org.eclipse.equinox.security"/>
      <plugin id="org.eclipse.equinox.security.win32.x86_64" fragment="true"/>
      <plugin id="org.eclipse.equinox.util"/>
      <plugin id="org.eclipse.help"/>
      <plugin id="org.eclipse.jface"/>
      <plugin id="org.eclipse.jface.databinding"/>
      <plugin id="org.eclipse.jface.text"/>
      <plugin id="org.eclipse.osgi"/>
      <plugin id="org.eclipse.osgi.services"/>
      <plugin id="org.eclipse.platform"/>
      <plugin id="org.eclipse.scout.commons"/>
      <plugin id="org.eclipse.scout.net"/>
      <plugin id="org.eclipse.scout.org.w3c.dom.svg.fragment" fragment="true"/>
      <plugin id="org.eclipse.scout.rt.client"/>
      <plugin id="org.eclipse.scout.rt.extension.client"/>
      <plugin id="org.eclipse.scout.rt.servicetunnel"/>
      <plugin id="org.eclipse.scout.rt.shared"/>
      <plugin id="org.eclipse.scout.rt.ui.swt"/>
      <plugin id="org.eclipse.scout.service"/>
      <plugin id="org.eclipse.scout.svg.client"/>
      <plugin id="org.eclipse.scout.svg.ui.swt"/>
      <plugin id="org.eclipse.swt"/>
      <plugin id="org.eclipse.swt.win32.win32.x86_64" fragment="true"/>
      <plugin id="org.eclipse.text"/>
      <plugin id="org.eclipse.ui"/>
      <plugin id="org.eclipse.ui.forms"/>
      <plugin id="org.eclipse.ui.intro"/>
      <plugin id="org.eclipse.ui.views"/>
      <plugin id="org.eclipse.ui.workbench"/>
      <plugin id="org.eclipse.ui.workbench.texteditor"/>
      <plugin id="org.eclipse.update.configurator"/>
      <plugin id="org.w3c.css.sac"/>
      <plugin id="org.w3c.dom.events"/>
      <plugin id="org.w3c.dom.smil"/>
      <plugin id="org.w3c.dom.svg"/>
   </plugins>


</product>
'''
}
