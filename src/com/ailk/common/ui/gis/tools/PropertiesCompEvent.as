package com.ailk.common.ui.gis.tools
{
	import flash.events.Event;
	
	/**
	 * 
	 *
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2013-1-9
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class PropertiesCompEvent extends Event
	{
		public static const VIEW_SHOW:String = "VIEW_SHOW";
		public static const VIEW_HIDE:String = "VIEW_HIDE";
		public static const PROPERTIES_CHANGE:String = "PROPERTIES_CHANGE";
		public var param:Object;
		public function PropertiesCompEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}