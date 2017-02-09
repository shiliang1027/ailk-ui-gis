package com.ailk.common.ui.gis.core
{
	import com.ailk.common.ui.gis.event.MapEvent;
	/**
	 * 地图控制接口
	 * @author shiliang
	 * 
	 */	
	public interface IMapControl
	{
		function addMapEventListener(type:String,instener:Function):void;
		function dispatchMapEvent(event:MapEvent):void;
	}
}