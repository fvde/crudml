package tum.ma.crudml.scout;

import java.io.File;
import java.util.List;

import org.eclipse.xtext.generator.IFileSystemAccess;
import org.eclipselabs.scwork.template.InputParam;
import org.eclipselabs.scwork.template.ProjectType;
import org.eclipselabs.scwork.template.TemplateUtility;
import org.eclipselabs.scwork.template.generator.IFileGenerator;

import tum.ma.crudml.generator.ExtendedFileSystemAccess;

public class ScoutProjectGenerator {

	public static void generateScoutTemplateProject(String workspaceName,
			String projectAlias, String projectName, String authorName,
			ExtendedFileSystemAccess fsa) {

		InputParam param = new InputParam();
		
		// File access
		param.setFileSystemAccess(fsa);

		// Folder where the projects will be generated:

		if (workspaceName != "") {
			param.setWorkspaceFolder(new File(workspaceName));
		}

		// Project names:
		param.setProjectAlias(projectAlias);
		param.setProjectName(projectName);

		// Flags to indicate which project should be created:
		param.setClientIncluded(true);
		param.setServerIncluded(true);
		param.setSharedIncluded(true);
		param.setUirapIncluded(true);
		param.setUiswtIncluded(true);
		param.setUiswingIncluded(true);

		// Type of application:
		param.setProjectType(ProjectType.OUTLINE_BASED_APPLICATION);

		// Additional configuration:
		param.setAuthorName(authorName);

		StringBuilder sb = new StringBuilder();
		sb.append("/*******************************************************************************\n");
		sb.append(" * Copyright (c) 2015 " + authorName + " .\n");
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
