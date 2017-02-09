package com.ailk.common.ui.gis.core.metry
{
	/**
	 * 点对象
	 * @author shiliang
	 * 
	 */	
	public class GisPoint extends GisMetry
	{
		[Bindable]
		public var x:Number=0;
		[Bindable]
		public var y:Number=0;
		public function GisPoint(x:Number,y:Number)
		{
			super();
			this.x = x;
			this.y = y;
		}
		override public function toString():String{
			return "x="+x+",y="+y;
		}
	}
}