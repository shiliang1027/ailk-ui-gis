package com.ailk.common.ui.gis.core.metry
{
	import com.ailk.common.ui.gis.core.styles.GisStyle;
	/**
	 * 地图基元对象
	 * @author shiliang
	 * 
	 */
	public class GisMetry
	{
		public var defaultStyle:GisStyle;
		public var gisExtent:GisExtent;
		public function GisMetry()
		{
		}
		
		public function toString():String{
			return "defaultStyle="+defaultStyle+",gisExtent="+gisExtent;
		}
	}
}