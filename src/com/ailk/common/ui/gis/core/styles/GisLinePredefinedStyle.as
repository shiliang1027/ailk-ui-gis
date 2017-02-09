package com.ailk.common.ui.gis.core.styles
{
	/**
	 * 线条形状样式对象
	 * @author shiliang
	 * 
	 */	
	public class GisLinePredefinedStyle extends GisLineStyle
	{
		public var symbol:String;
		public var cap:String;
		public var join:String;
		public var miterLimit:Number;
		
		public function GisLinePredefinedStyle(symbol:String, color:Number = 0xFF0000, alpha:Number = 1, width:Number = 1, cap:String = null, join:String = null, miterLimit:Number = 3)
		{
			super();
			this.symbol = symbol;
			this.color = color;
			this.alpha = alpha;
			this.weight = width;
			this.cap = cap;
			this.join = join;
			this.miterLimit = miterLimit;
		}
		
		override public function toString():String{
			return "symbol="+symbol+",cap="+cap+",join="+join+",miterLimit="+miterLimit;
		}
	}
}