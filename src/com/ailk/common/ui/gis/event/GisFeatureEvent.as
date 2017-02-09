package com.ailk.common.ui.gis.event
{
	import com.ailk.common.ui.gis.core.GisFeature;
	
	import flash.events.Event;
	/**
	 * 地图点、线、面对象点击，悬浮，移出事件
	 * @author shiliang
	 * 
	 */	
	public class GisFeatureEvent extends Event
	{
		public var targetEvent:Event;
		public var gisFeature:GisFeature;
		public static const GISFEATURE_CLICK:String="gisFeature_click";
		public static const GISFEATURE_OVER:String="gisFeature_over";
		public static const GISFEATURE_OUT:String="gisFeature_out";
		public function GisFeatureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}