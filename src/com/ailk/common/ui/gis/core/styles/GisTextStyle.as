package com.ailk.common.ui.gis.core.styles
{
	import flash.text.TextFormat;
	/**
	 * 文本样式对象 
	 * @author shiliang
	 * 
	 */
	public class GisTextStyle extends GisStyle
	{
		public static const PLACEMENT_BOTTOM:String = "bottom";
		public static const PLACEMENT_LEFT:String = "left";
		public static const PLACEMENT_MIDDLE:String = "middle";
		public static const PLACEMENT_RIGHT:String = "right";
		public static const PLACEMENT_TOP:String = "top";
		public var alpha:Number;
		public var angle:Number;
		public var background:Boolean;
		public var backgroundColor:uint;
		public var border:Boolean;
		public var borderColor:uint;
		public var color:uint;
		public var htmlText:String;
		public var placement:String;
		public var text:String;
		public var textAttribute:String;
		public var textFormat:TextFormat;
		public var textFunction:Function;
		public var xoffset:Number;
		public var yoffset:Number;
		public function GisTextStyle(text:String = null, color:uint = 0, border:Boolean = false, borderColor:uint = 0, background:Boolean = false, backgroundColor:uint = 0xffffff, angle:Number = 0, placement:String = "middle", xoffset:Number = 0, yoffset:Number = 0, htmlText:String = null, textFormat:TextFormat = null, textAttribute:String = null, textFunction:Function = null)
		{
			super();
			this.text = text;
			this.color = color;
			this.border = border;
			this.borderColor = borderColor;
			this.background = background;
			this.backgroundColor = backgroundColor;
			this.angle = angle;
			this.placement = placement;
			this.xoffset = xoffset;
			this.yoffset = yoffset;
			this.htmlText = htmlText;
			this.textFormat = textFormat;
			this.textAttribute = textAttribute;
			this.textFunction = textFunction;
		}
	}
}