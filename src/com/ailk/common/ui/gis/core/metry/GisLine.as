package com.ailk.common.ui.gis.core.metry
{
	/**
	 * 线对象
	 * @author shiliang
	 * 
	 */	
	public class GisLine extends GisMetry
	{
		public var partCount:int;
		public var parts:Array;
		public function GisLine(parts:Array=null)
		{
			super();
			this.parts = parts;
		}
		override public function toString():String{
			return "parts["+parts+"]";
		}
	}
}