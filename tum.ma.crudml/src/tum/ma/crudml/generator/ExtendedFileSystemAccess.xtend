package tum.ma.crudml.generator

import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.IFileSystemAccessExtension
import org.eclipse.xtext.generator.OutputConfiguration
import org.eclipse.xtext.generator.IFileSystemAccessExtension3
import java.io.InputStream
import org.eclipse.xtext.util.RuntimeIOException

@Accessors class ExtendedFileSystemAccess implements IFileSystemAccess, IFileSystemAccessExtension, IFileSystemAccessExtension3 {
	
	private IFileSystemAccess fileSystemAccess
	private String outputConfigurationName = IFileSystemAccess.DEFAULT_OUTPUT
	
	new(IFileSystemAccess access) {
		fileSystemAccess = access
	}
	
	override deleteFile(String fileName){
		deleteFile(fileName, outputConfigurationName)
	}
	
	override deleteFile(String fileName, String outputConfigurationName) {
		val efsa = fileSystemAccess as IFileSystemAccessExtension;
		efsa.deleteFile(fileName, outputConfigurationName)
	}
		
	override generateFile(String fileName, CharSequence contents) {
		generateFile(fileName, outputConfigurationName, contents)
	}
	
	override generateFile(String fileName, String outputConfigurationName, CharSequence contents) {
		fileSystemAccess.generateFile(fileName, outputConfigurationName, contents)
	}
	
	override generateFile(String fileName, InputStream content) throws RuntimeIOException {
		generateFile(fileName, outputConfigurationName, content)
	}
	
	override generateFile(String fileName, String outputCfgName, InputStream content) throws RuntimeIOException {
		val efsa = fileSystemAccess as IFileSystemAccessExtension3;
		efsa.generateFile(fileName, outputCfgName, content) 
	}
	
	override readBinaryFile(String fileName) throws RuntimeIOException {
		readBinaryFile(fileName, outputConfigurationName)
	}
	
	override readBinaryFile(String fileName, String outputCfgName) throws RuntimeIOException {
		val efsa = fileSystemAccess as IFileSystemAccessExtension3;
		efsa.readBinaryFile(fileName, outputCfgName) 
	}
	
	override readTextFile(String fileName) throws RuntimeIOException {
		readTextFile(fileName, outputConfigurationName)
	}
	
	override readTextFile(String fileName, String outputCfgName) throws RuntimeIOException {
		val efsa = fileSystemAccess as IFileSystemAccessExtension3;
		efsa.readTextFile(fileName, outputCfgName) 
	}

}