package com.ailk.common.ui.gis.core.styles
{
	/**
	 * 形状样式对象
	 * @author shiliang
	 * 
	 */
	public class GisMarkerPredefinedStyle extends GisMarkerStyle
	{
		public var symbol:String;
		public var size:Number;
		public var color:Number;
		public var alpha:Number;
		public var border:GisLinePredefinedStyle;

		public function GisMarkerPredefinedStyle(symbol:String, size:Number=10, color:Number=0xFF0000, alpha:Number=1, xOffset:Number=0, yOffset:Number=0, angle:Number=0, border:GisLinePredefinedStyle=null)
		{
			super();
			this.symbol=symbol;
			this.size=size;
			this.color=color;
			this.alpha=alpha;
			this.xOffset=xOffset;
			this.yOffset=yOffset;
			this.angle=angle;
			this.border=border;
		}
		override public function toString():String{
			return "symbol="+symbol+",size="+size+",color="+color+",alpha="+alpha+",border="+border;
		}
	}
}