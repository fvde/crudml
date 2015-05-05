package tum.ma.crudml.emf;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.xmi.XMIResource;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceImpl;

public class EMFImporter {

	public static void main(String[] args) {

		System.out.println("Working Directory = "
				+ System.getProperty("user.dir"));

		String dir = "";
		
		String[] availableFiles = {
			"esmodel.ecore"	,
			"store.ecore",
			"crudml.ecore",
			"libary.ecore",
			"bowling.ecore",
			"biodiversity.ecore"
		};
		
		String fileName = availableFiles[0];
		String path = dir + fileName;

		EMFImporter importer = new EMFImporter();
		try {
			EPackage content = importer.loadModel(path);
			System.out.println("-----------------------");
			System.out.println("Parsing emf contents...");
			System.out.println("-----------------------");

			// start generating
			CrudmlMetaModelGenerator generator = new CrudmlMetaModelGenerator(
					content, dir);
			generator.doGenerate();

		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public EMFImporter() {

	}

	public EPackage loadModel(String fileName) throws IOException {
		URI uri = URI.createURI(fileName);
		File source = new File(fileName);
		XMIResource resource = new XMIResourceImpl(uri);
		resource.setEncoding("UTF-8");
		resource.load(new FileInputStream(source),
				new HashMap<Object, Object>());
		return (EPackage) resource.getContents().get(0);
	}
}
