package com.ailk.common.ui.gis.event
{
	import com.ailk.common.ui.gis.core.GisFeature;
	
	import flash.events.Event;
	
	/**
	 * 地图绘制事件
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-6-29 上午11:41:52
	 * @category com.ailk.common.ui.gis.event
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisDrawEvent extends MapEvent
	{
		public static const DRAW_CLICK:String = "draw_click";
		public static const DRAW_END:String = "draw_end";
		public static const DRAW_Back:String = "draw_back";
		public static const DRAW_Forward:String = "draw_forward";
		public static const DRAWPOINTSELECT:String = "drawPointSelect";
		public var gisFeature:GisFeature;
		public function GisDrawEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}