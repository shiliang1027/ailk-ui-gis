package com.ailk.common.ui.gis.core.styles
{
	/**
	 * 图片背景填充样式对象
	 * @author shiliang
	 * 
	 */	
	public class GisFillPictureStyle extends GisFillStyle
	{
		public var source:Object;
		public var width:Number;
		public var height:Number;
		public var pattern:Array;
		public var alpha:Number;
		public var angle:Number;
		public var xOffset:Number;
		public var xScale:Number;
		public var yOffset:Number;
		public var yScale:Number;
		public function GisFillPictureStyle(source:Object = null, width:Number = 0, height:Number = 0, xScale:Number = 1, yScale:Number = 1, xOffset:Number = 0, yOffset:Number = 0, alpha:Number = 1, angle:Number = 0, border:GisLinePredefinedStyle = null)
		{
			super();
			this.source = source;
			this.width = width;
			this.height = height;
			this.xOffset = xOffset;
			this.yOffset = yOffset;
			this.xScale = xScale;
			this.yScale = yScale;
		}
		override public function toString():String{
			return "source="+source+",width="+width+",height="+height+",pattern="+pattern+",alpha="+alpha+",angle="+angle+",xOffset="+xOffset+",xScale="+xScale+",yOffset="+yOffset+",yScale="+yScale;
		}
	}
}