package com.core.config {

	import com.net.ExternallyControlledObject;
	
	/**
	 * Facade para configurar externa y/o internamente las opciones más comunes y principales del sistema.
	 * @author jgomez modificada por Lechi Lechon
	 */	
	public dynamic class SystemConfig extends ExternallyControlledObject {
		
		public static const ON_LOAD:String = "on_load";
		public static const ON_FAIL:String = "on_fail";
		
	}	
	
}