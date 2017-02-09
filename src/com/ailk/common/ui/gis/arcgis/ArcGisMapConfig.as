package com.ailk.common.ui.gis.arcgis
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.Constants;
	import com.ailk.common.ui.gis.core.BaseConfig;
	import com.ailk.common.ui.gis.core.GisContextUtil;
	import com.ailk.common.ui.gis.core.GisDynamicServiceLayer;
	import com.ailk.common.ui.gis.core.GisFeatureLayer;
	import com.ailk.common.ui.gis.core.GisLayer;
	import com.ailk.common.ui.gis.core.GisWMSLayer;
	import com.ailk.common.ui.gis.core.ILayer;
	import com.ailk.common.ui.gis.core.IMapConfig;
	import com.ailk.common.ui.gis.core.IMapControl;
	import com.ailk.common.ui.gis.core.gis_internal;
	import com.ailk.common.ui.gis.event.MapEvent;
	import com.ailk.common.ui.gis.exception.GisException;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	use namespace gis_internal;
	/**
	 * Arcgis配置类
	 * @author shiliang
	 *
	 */
	public class ArcGisMapConfig extends BaseConfig
	{
		private static var log:ILogger=Log.getLoggerByClass(ArcGisMapConfig);

		public function ArcGisMapConfig(control:IMapControl)
		{
			super(control);
		}

		override protected function resultHandler(event:ResultEvent):void
		{
			super.resultHandler(event);
			var result:XML=event.result as XML;
			for each (var map:XML in result.maps.map)
			{
				mapArray[map.@mid]={mid: map.@mid, name: map.@name, mapUrl: map.@mapUrl, queryUrl: map.@queryUrl,outFields:map.@outFields, queryBTSUrl: map.@queryBTSUrl,outBTSFields:map.@outBTSFields, queryNodeBUrl: map.@queryNodeBUrl,outNodeBFields:map.@outNodeBFields};
			}
			var layerType:String;
			var gisLayer:ILayer;
			var visibleLayers:Array;
			for each (var layer:XML in result.layers.layer)
			{
				layerType=layer.@type;
				switch (layerType)
				{
					case "GisDynamicServiceLayer":
						visibleLayers=String(layer.@visibleLayers).split(",");
						gisLayer=new GisDynamicServiceLayer(layer.@url, new ArrayCollection(visibleLayers));
						break;
					case "GisFeatureLayer":
						gisLayer=new GisFeatureLayer(layer.@url, layer.@mode, String(layer.@outField).split(","), layer.@definitionExpression);
						break;
					case "GisLayer":
						gisLayer=new GisLayer(layer.@url, layer.@mode, String(layer.@layerIds).split(","), layer.@layerOption);
						break;
					case "GisWMSLayer":
						gisLayer=new GisWMSLayer(layer.@url);
						break;
				}
				gisLayer.id=layer.@id;
				GisContextUtil.setBean(String(gisLayer.id), gisLayer);
			}
			control.dispatchMapEvent(new MapEvent(MapEvent.MAP_PARAM_INIT_COMPLETE));
		}
	}
}