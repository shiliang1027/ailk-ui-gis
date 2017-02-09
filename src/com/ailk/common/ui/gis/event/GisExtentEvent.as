package com.ailk.common.ui.gis.event
{
	import com.ailk.common.ui.gis.core.metry.GisExtent;

	/**
	 * 地图区域变化事件
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-8-26 下午02:25:26
	 * @category com.ailk.common.ui.gis.event
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisExtentEvent extends MapEvent
	{
		public static const EXTENT_CHANGE:String = "extent_change";
		public var extent:GisExtent;
		public var levelChange:Boolean;
		public function GisExtentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}