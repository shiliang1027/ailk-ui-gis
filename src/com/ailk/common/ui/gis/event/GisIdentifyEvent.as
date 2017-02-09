package com.ailk.common.ui.gis.event
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 任务事件
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-5-4 下午02:41:24
	 * @category com.linkage.gis.event
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisIdentifyEvent extends Event
	{
		public static const EXECUTE_COMPLETE:String="execute_complete";
		
		public var gisFeatures:ArrayCollection;
		public function GisIdentifyEvent(type:String,gisFeatures:ArrayCollection, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.gisFeatures = gisFeatures;
		}
	}
}