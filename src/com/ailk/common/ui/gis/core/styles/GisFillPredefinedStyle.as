package com.ailk.common.ui.gis.core.styles
{
	/**
	 * 形状背景填充样式对象
	 * @author shiliang
	 * 
	 */	
	public class GisFillPredefinedStyle extends GisFillStyle
	{
		public var symbol:String;
		public var color:Number;
		public var alpha:Number;
		public function GisFillPredefinedStyle(symbol:String, color:Number = 0xFF0000, alpha:Number = 1, border:GisLinePredefinedStyle = null)
		{
			super();
			this.symbol = symbol;
			this.color = color;
			this.alpha = alpha;
			this.border = border;
		}
		override public function toString():String{
			return "symbol="+symbol+",color="+color+",alpha="+alpha;
		}
	}
}