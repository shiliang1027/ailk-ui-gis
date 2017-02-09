package com.ailk.common.ui.gis.core.styles
{
	/**
	 * 线条样式对象
	 * @author shiliang
	 * 
	 */	
	public class GisLineStyle extends GisStyle
	{
		public static const STYLE_DASH:String="dash";
		public static const STYLE_DASHDOT:String="dashdot";
		public static const STYLE_DASHDOTDOT:String="dashdotdot";
		public static const STYLE_DOT:String="dot";
		public static const STYLE_NULL:String="none";
		public static const STYLE_SOLID:String="solid";
		//以下适用SuperMap
		public static const STYLE_COUSTOM:String="coustom";
		public static const CAP_NONE:String="null";
		public static const CAP_ROUND:String="round";
		public static const CAP_SQUARE:String="square";
		public static const JOIN_BEVEL:String="bevel";
		public static const JOIN_MITER:String="miter";
		public static const JOIN_ROUND:String="round";
		
		public var alpha:Number;
		public var color:uint;
		public var weight:Number;
		public function GisLineStyle()
		{
			super();
		}
		override public function toString():String{
			return "alpha="+alpha+",color="+color+",weight="+weight;
		}
	}
}