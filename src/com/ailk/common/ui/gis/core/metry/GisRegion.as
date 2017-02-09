package com.ailk.common.ui.gis.core.metry
{
	/**
	 * 面对象
	 * @author shiliang
	 * 
	 */	
	public class GisRegion extends GisMetry
	{
		public var partCount:int;
		public var parts:Array;
		public function GisRegion(parts:Array=null)
		{
			super();
			this.parts = parts;
		}
		override public function toString():String{
			return "parts["+parts+"]";
		}
	}
}