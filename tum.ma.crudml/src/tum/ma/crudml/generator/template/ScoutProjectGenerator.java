package tum.ma.crudml.generator.template;

import java.io.File;
import java.util.List;

import org.eclipse.emf.ecore.resource.Resource;
import org.eclipselabs.scwork.template.InputParam;
import org.eclipselabs.scwork.template.ProjectType;
import org.eclipselabs.scwork.template.TemplateUtility;
import org.eclipselabs.scwork.template.generator.IFileGenerator;

import tum.ma.crudml.generator.BaseGenerator;
import tum.ma.crudml.generator.CrudmlGenerator;
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess;

public class ScoutProjectGenerator extends BaseGenerator{

	public ScoutProjectGenerator(int priority) {
		super(priority);
	}

	@Override
	public void doGenerate(Resource input, ExtendedFileSystemAccess fsa) {
		
		InputParam param = new InputParam();
		
		// File access
		param.setFileSystemAccess(fsa);

		// Folder where the projects will be generated:

		if (CrudmlGenerator.workspaceFolder != "") {
			param.setWorkspaceFolder(new File(CrudmlGenerator.workspaceFolder));
		}

		// Project names:
		param.setProjectAlias(CrudmlGenerator.applicationName);
		param.setProjectName(CrudmlGenerator.applicationName);

		// Flags to indicate which project should be created:
		param.setClientIncluded(true);
		param.setServerIncluded(true);
		param.setSharedIncluded(true);
		param.setUirapIncluded(false);
		param.setUiswtIncluded(false);
		param.setUiswingIncluded(true);

		// Type of application:
		param.setProjectType(ProjectType.OUTLINE_BASED_APPLICATION);

		// Additional configuration:
		param.setAuthorName(CrudmlGenerator.author);

		StringBuilder sb = new StringBuilder();
		sb.append("/*******************************************************************************\n");
		sb.append(" * Copyright (c) 2015 " + CrudmlGenerator.author + " .\n");
		sb.append(" * All rights reserved. This program and the accompanying materials\n");
		sb.append(" * are made available under the terms of the Eclipse Public License v1.0\n");
		sb.append(" * which accompanies this distribution, and is available at\n");
		sb.append(" * http://www.eclipse.org/legal/epl-v10.html\n **/ \n");
		param.setCopyrightHeader(sb.toString());

		// Do the generation:
		List<IFileGenerator> generators = TemplateUtility.getAllGenerators();
		TemplateUtility.generateAll(generators, param);
	}
}
