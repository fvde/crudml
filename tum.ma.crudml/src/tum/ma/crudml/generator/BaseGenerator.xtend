package tum.ma.crudml.generator

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors abstract class BaseGenerator implements IExtendedGenerator{
	
	int priority
	
	new(int priority){
		this.priority = priority
	}
}