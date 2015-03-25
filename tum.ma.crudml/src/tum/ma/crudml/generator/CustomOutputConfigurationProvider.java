package tum.ma.crudml.generator;

import java.util.HashSet;
import java.util.Set;

import org.eclipse.xtext.generator.IFileSystemAccess;
import org.eclipse.xtext.generator.IOutputConfigurationProvider;
import org.eclipse.xtext.generator.OutputConfiguration;

public class CustomOutputConfigurationProvider implements IOutputConfigurationProvider {

	  public static final String GEN_ONCE_OUTPUT = "gen-once";

	  /**
	   * @return a set of {@link OutputConfiguration} available for the generator
	   */
	   public Set<OutputConfiguration> getOutputConfigurations() {
	    OutputConfiguration defaultOutput = new OutputConfiguration(IFileSystemAccess.DEFAULT_OUTPUT);
	    defaultOutput.setDescription("Output Folder");
	    defaultOutput.setOutputDirectory("./src-gen");
	    defaultOutput.setOverrideExistingResources(true);
	    defaultOutput.setCreateOutputDirectory(true);
	    defaultOutput.setCleanUpDerivedResources(true);
	    defaultOutput.setSetDerivedProperty(true);

	    OutputConfiguration readonlyOutput = new OutputConfiguration(GEN_ONCE_OUTPUT);
	    readonlyOutput.setDescription("Read-only Output Folder");
	    readonlyOutput.setOutputDirectory("./src");
	    readonlyOutput.setOverrideExistingResources(false);
	    readonlyOutput.setCreateOutputDirectory(true);
	    readonlyOutput.setCleanUpDerivedResources(false);
	    readonlyOutput.setSetDerivedProperty(false);
	    
	    HashSet<OutputConfiguration> result = new HashSet<OutputConfiguration>();
	    result.add(defaultOutput);
	    result.add(readonlyOutput);
	    
	    return result;
	  }
	}
