package com.ailk.common.ui.gis.event
{
	import com.ailk.common.ui.gis.core.metry.GisPoint;
	
	import flash.events.Event;

	/**
	 * 地图事件
	 * @author shiliang
	 * 
	 */	
	public class MapEvent extends Event
	{
		public static const MAP_VIEWCONFIG_INIT:String="map_viewConfig_init";
		public static const MAP_VIEWCONFIG_INIT_COMPLETE:String="map_viewConfig_init_complete";
		public static const MAP_PARAM_INIT:String="map_param_init";
		public static const MAP_PARAM_INIT_COMPLETE:String="map_param_init_complete";
		public static const MAP_CREATION_COMPLETE:String = "mapCreationComplete";
		public static const MAP_SELECT_COMPLETE:String = "mapSelectComplete";
		public static const TOOLBAR_PICLAYER:String="toolbar_picLayer";
		public static const TOOLBAR_LEGEND:String="toolbar_legend";
		public static const TOOLBAR_GOTO:String="toolbar_goto";
		public static const MAP_CLICK:String = "map_click";
		
		public static const DRAWTOOL_CREATION_COMPLETE:String = "drawTool_creation_complete";
		public var mapPoint:GisPoint;
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}