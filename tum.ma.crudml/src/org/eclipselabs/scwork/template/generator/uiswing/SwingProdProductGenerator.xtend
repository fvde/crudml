package org.eclipselabs.scwork.template.generator.uiswing

import org.eclipselabs.scwork.template.InputParam
import org.eclipselabs.scwork.template.generator.ITextFileGenerator

import static extension org.eclipselabs.scwork.template.generator.common.GeneratorExtensions.*

class SwingProdProductGenerator implements ITextFileGenerator {
	
	override shouldGenerate(InputParam param) {
		param.uiswingIncluded
	}
	
	override provideFile(InputParam param) {
		param.uiswingFile(#["products", "production", param.projectAlias + "-swing-client.product"])
	}
	
	override provideContent(InputParam param) 
'''
<?xml version="1.0" encoding="UTF-8"?>
<?pde version="3.5"?>

<product name="«param.projectAlias» Client" id="«param.uiswingProjectName».product" application="«param.uiswingProjectName».app" useFeatures="false" includeLaunchers="true">

   <configIni use="default">
      <linux>/«param.uiswingProjectName»/products/production/config.ini</linux>
      <macosx>/«param.uiswingProjectName»/products/production/config.ini</macosx>
      <win32>/«param.uiswingProjectName»/products/production/config.ini</win32>
   </configIni>

   <launcherArgs>
      <programArgsMac>--launcher.secondThread
-nosplash
      </programArgsMac>
      <vmArgs>-Xms64m
-Xmx512m
      </vmArgs>
   </launcherArgs>

   <windowImages/>

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
      <plugin id="«param.uiswingProjectName»"/>
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
      <plugin id="org.eclipse.core.contenttype"/>
      <plugin id="org.eclipse.core.jobs"/>
      <plugin id="org.eclipse.core.net"/>
      <plugin id="org.eclipse.core.runtime"/>
      <plugin id="org.eclipse.equinox.app"/>
      <plugin id="org.eclipse.equinox.common"/>
      <plugin id="org.eclipse.equinox.preferences"/>
      <plugin id="org.eclipse.equinox.registry"/>
      <plugin id="org.eclipse.equinox.security"/>
      <plugin id="org.eclipse.equinox.security.win32.x86_64" fragment="true"/>
      <plugin id="org.eclipse.osgi"/>
      <plugin id="org.eclipse.osgi.services"/>
      <plugin id="org.eclipse.scout.commons"/>
      <plugin id="org.eclipse.scout.net"/>
      <plugin id="org.eclipse.scout.org.w3c.dom.svg.fragment" fragment="true"/>
      <plugin id="org.eclipse.scout.rt.client"/>
      <plugin id="org.eclipse.scout.rt.extension.client"/>
      <plugin id="org.eclipse.scout.rt.servicetunnel"/>
      <plugin id="org.eclipse.scout.rt.shared"/>
      <plugin id="org.eclipse.scout.rt.ui.swing"/>
      <plugin id="org.eclipse.scout.rt.ui.swing.browser.swt.fragment" fragment="true"/>
      <plugin id="org.eclipse.scout.service"/>
      <plugin id="org.eclipse.scout.svg.client"/>
      <plugin id="org.eclipse.scout.svg.ui.swing"/>
      <plugin id="org.eclipse.swt"/>
      <plugin id="org.eclipse.swt.win32.win32.x86_64" fragment="true"/>
      <plugin id="org.eclipse.update.configurator"/>
      <plugin id="org.w3c.css.sac"/>
      <plugin id="org.w3c.dom.events"/>
      <plugin id="org.w3c.dom.smil"/>
      <plugin id="org.w3c.dom.svg"/>
   </plugins>


</product>
'''
}
