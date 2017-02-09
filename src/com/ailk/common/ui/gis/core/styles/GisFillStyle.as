package com.ailk.common.ui.gis.core.styles
{
	/**
	 * 背景填充样式对象
	 * @author shiliang
	 * 
	 */	
	public class GisFillStyle extends GisStyle
	{
		public var border:GisLinePredefinedStyle;
		public function GisFillStyle()
		{
			super();
		}
		override public function toString():String{
			return "border="+border;
		}
	}
}