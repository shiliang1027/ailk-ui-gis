package com.ailk.common.ui.gis.supermap
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.Constants;
	import com.ailk.common.ui.gis.core.BaseConfig;
	import com.ailk.common.ui.gis.core.IMapConfig;
	import com.ailk.common.ui.gis.core.IMapControl;
	import com.ailk.common.ui.gis.core.gis_internal;
	import com.ailk.common.ui.gis.event.MapEvent;
	import com.ailk.common.ui.gis.exception.GisException;

	import flashx.textLayout.events.DamageEvent;

	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;

	use namespace gis_internal;

	/**
	 * supermap地图参数配置类
	 * @author shiliang
	 *
	 */
	public class SuperMapConfig extends BaseConfig
	{
		gis_internal var webUrl:String;
		gis_internal var gisUrl:String;
		gis_internal var cacheUrl:String;
		gis_internal var extendServiceUrl:String;
		gis_internal var servicePort:uint;
		private static var log:ILogger=Log.getLoggerByClass(SuperMapConfig)

		public function SuperMapConfig(control:IMapControl)
		{
			super(control);
		}

		override protected function resultHandler(event:ResultEvent):void
		{
			super.resultHandler(event);
			var result:XML=event.result as XML;
			webUrl=result.url[0].@value;
			gisUrl=result.url[1].@value;
			cacheUrl=result.url[2].@value;
			extendServiceUrl=result.url[3].@value;
			servicePort=result.url[4].@value;
			for each (var map:XML in result.maps.map)
			{
				var scalesArray:Array=new Array();
				for each (var scale:String in String(map.@scales).split(","))
				{
					if (scale.indexOf("/") != -1)
					{
						scalesArray.push(Number(StringUtil.trim(scale.substr(0, scale.indexOf("/")))) / Number(StringUtil.trim(scale.substr(scale.indexOf("/") + 1))));
					}
					else
					{
						scalesArray.push(Number(scale));
					}
				}
				mapArray[map.@mid]={mid: map.@mid, name: map.@name, scales: scalesArray, queryUrl: map.@queryUrl, outFields: map.@outFields, queryBTSUrl: map.@queryBTSUrl, outBTSFields: map.@outBTSFields, queryNodeBUrl: map.@queryNodeBUrl, outNodeBFields: map.@outNodeBFields};
			}
			control.dispatchMapEvent(new MapEvent(MapEvent.MAP_PARAM_INIT_COMPLETE));
		}
	}
}