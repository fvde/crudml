package tum.ma.crudml.generator;

import org.eclipse.emf.ecore.resource.Resource;
import tum.ma.crudml.generator.access.ExtendedFileSystemAccess;

public interface IExtendedGenerator {
	/**
	 * @param input - the input for which to generate resources
	 * @param efsa - extended file system access to be used to generate files
	 */
	public void doGenerate(Resource input, ExtendedFileSystemAccess fsa);
}
