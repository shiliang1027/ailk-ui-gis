package com.ailk.common.ui.gis.core
{
	import com.ailk.common.ui.gis.event.MapEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 基本控制类
	 *
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2013-1-4
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class BaseControl extends EventDispatcher implements IMapControl
	{
		public function BaseControl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function addMapEventListener(type:String, instener:Function):void
		{
			addEventListener(type,instener);
		}
		
		public function dispatchMapEvent(event:MapEvent):void
		{
			dispatchEvent(event);
		}
	}
}