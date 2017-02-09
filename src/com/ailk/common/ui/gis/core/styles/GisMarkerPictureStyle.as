package com.ailk.common.ui.gis.core.styles
{
	
	/**
	 * 图片样式对象
	 * @author shiliang
	 * 
	 */	
	public class GisMarkerPictureStyle extends GisMarkerStyle
	{
		public var source:Object;
		public var width:Number;
		public var height:Number;
		public var alpha:Number;
		public function GisMarkerPictureStyle(source:Object = null, width:Number = 0, height:Number = 0, xoffset:Number = 0, yoffset:Number = 0, alpha:Number = 1, angle:Number = 0)
		{
			super();
			this.source = source;
			this.width = width;
			this.height = height;
			this.xOffset = xoffset;
			this.yOffset = yoffset;
			this.alpha = alpha;
			this.angle = angle;
		}
		override public function toString():String{
			return "source="+source+",width="+width+",height="+height+",alpha="+alpha;
		}
	}
}