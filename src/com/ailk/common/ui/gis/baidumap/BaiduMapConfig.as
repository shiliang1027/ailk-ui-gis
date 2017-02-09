package com.ailk.common.ui.gis.baidumap
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.core.BaseConfig;
	import com.ailk.common.ui.gis.core.IMapControl;
	import com.ailk.common.ui.gis.core.gis_internal;
	import com.ailk.common.ui.gis.event.MapEvent;

	import mx.rpc.events.ResultEvent;

	use namespace gis_internal;

	/**
	 *
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
	public class BaiduMapConfig extends BaseConfig
	{
		private static var log:ILogger=Log.getLoggerByClass(BaiduMapConfig);

		public function BaiduMapConfig(control:IMapControl)
		{
			super(control);
		}

		override protected function resultHandler(event:ResultEvent):void
		{
			super.resultHandler(event);
			var result:XML=event.result as XML;
			for each (var map:XML in result.maps.map)
			{
				var scalesArray:Array=new Array();
				mapArray[map.@mid]={mid: map.@mid, name: map.@name};
			}
			control.dispatchMapEvent(new MapEvent(MapEvent.MAP_PARAM_INIT_COMPLETE));
		}
	}
}