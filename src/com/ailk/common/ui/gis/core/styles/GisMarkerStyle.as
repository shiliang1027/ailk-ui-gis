package com.ailk.common.ui.gis.core.styles
{
	/**
	 * 样式对象
	 * @author shiliang
	 * 
	 */	
	public class GisMarkerStyle extends GisStyle
	{
		/**
		 *圆 
		 */		
		public static const STYLE_CIRCLE:String="circle";
		/**
		 * 
		 */		
		public static const STYLE_CROSS:String="cross";
		public static const STYLE_DIAMOND:String="diamond";
		public static const STYLE_SQUARE:String="square";
		public static const STYLE_TRIANGLE:String="triangle";
		/**
		 *只适用SuperMap 
		 */		
		public static const STYLE_SECTOR:String="sector";
		/**
		 *只适用SuperMap 
		 */	
		public static const STYLE_STAR:String="star";
		public var angle:Number;
		public var xOffset:Number;
		public var yOffset:Number;
		public function GisMarkerStyle()
		{
		}
		override public function toString():String{
			return "angle="+angle+",xOffset="+xOffset+",yOffset="+yOffset;
		}
	}
}