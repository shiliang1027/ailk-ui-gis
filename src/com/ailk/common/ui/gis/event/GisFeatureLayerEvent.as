package com.ailk.common.ui.gis.event
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class GisFeatureLayerEvent extends Event
	{
		public static const QUERY_FEATURES_COMPLETE:String="QUERY_FEATURES_COMPLETE";
		public var gisFeatures:ArrayCollection = new ArrayCollection();
		public function GisFeatureLayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}