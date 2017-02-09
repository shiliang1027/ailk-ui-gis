package com.ailk.common.ui.gis.baidumap
{
	import baidu.map.basetype.LngLat;
	import baidu.map.basetype.Size;
	import baidu.map.control.Control;
	import baidu.map.control.base.MapType;
	import baidu.map.control.base.Navigator;
	import baidu.map.control.base.Overview;
	import baidu.map.control.base.Ruler;
	import baidu.map.control.base.Scaler;
	import baidu.map.core.Map;
	import baidu.map.layer.Layer;
	import baidu.map.layer.RasterLayer;
	import baidu.map.overlay.Geometry;
	import baidu.map.overlay.Marker;
	import baidu.map.overlay.Overlay;
	import baidu.map.symbol.PolylineSymbol;
	import baidu.map.symbol.Symbol;
	
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.core.BaseMap;
	import com.ailk.common.ui.gis.core.GisDynamicServiceLayer;
	import com.ailk.common.ui.gis.core.GisFeature;
	import com.ailk.common.ui.gis.core.GisFeatureLayer;
	import com.ailk.common.ui.gis.core.GisLayer;
	import com.ailk.common.ui.gis.core.GisServiceLayer;
	import com.ailk.common.ui.gis.core.GisWMSLayer;
	import com.ailk.common.ui.gis.core.ILayer;
	import com.ailk.common.ui.gis.core.IMapConfig;
	import com.ailk.common.ui.gis.core.IMapControl;
	import com.ailk.common.ui.gis.core.gis_internal;
	import com.ailk.common.ui.gis.core.metry.GisCircle;
	import com.ailk.common.ui.gis.core.metry.GisLine;
	import com.ailk.common.ui.gis.core.metry.GisMetry;
	import com.ailk.common.ui.gis.core.metry.GisPoint;
	import com.ailk.common.ui.gis.core.metry.GisRectangle;
	import com.ailk.common.ui.gis.core.metry.GisRegion;
	import com.ailk.common.ui.gis.core.metry.GisSector;
	import com.ailk.common.ui.gis.core.styles.GisFillPredefinedStyle;
	import com.ailk.common.ui.gis.core.styles.GisLinePredefinedStyle;
	import com.ailk.common.ui.gis.core.styles.GisMarkerPictureStyle;
	import com.ailk.common.ui.gis.core.styles.GisMarkerPredefinedStyle;
	import com.ailk.common.ui.gis.core.styles.GisStyle;
	import com.ailk.common.ui.gis.event.MapEvent;
	import com.ailk.common.ui.gis.tools.OverViewTool;
	import com.ailk.common.ui.gis.tools.ScaleBar;
	import com.ailk.common.ui.gis.tools.ZoomSliderBar;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
	import spark.primitives.BitmapImage;

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
	public class BaiduMap extends BaseMap
	{
		private static var log:ILogger=Log.getLoggerByClass(BaiduMap);
		private var _map:Map;

		public function BaiduMap(config:IMapConfig, control:IMapControl)
		{
			super(config, control);

			_map=new Map(new Size(600, 400));
			_map.centerAndZoom(new LngLat(116.404, 39.915), 12);
//			this.addEventListener(FlexEvent.CREATION_COMPLETE,onMapEnterFrameHandler);
			_map.addEventListener(Event.ADDED_TO_STAGE,onMapAddToStageHandler);
		}
		
		private function onMapAddToStageHandler(event:Event):void{
			control.dispatchMapEvent(new MapEvent(MapEvent.MAP_CREATION_COMPLETE));
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			addChild(_map);
			addGisLayer(serviceGisLayer);
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (_map)
			{
				_map.width=unscaledWidth;
				_map.height=unscaledHeight;
				
			}
		}

		override protected function onLayersChangeHandler(event:CollectionEvent):void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
					onCollectionAddHandler(event);
					break;
				case CollectionEventKind.REMOVE:
					onCollectionRemoveHandler(event);
					break;
				case CollectionEventKind.RESET:
				case CollectionEventKind.REFRESH:
					onCollectionRefreshAndResetHandler(event);
					break;
			}
		}

		private function onCollectionAddHandler(event:CollectionEvent):void
		{
			for each (var gisLayer:ILayer in event.items)
			{
				addLayerAt(gisLayer, event.location);
			}

		}

		private function onCollectionRemoveHandler(event:CollectionEvent):void
		{
			for each (var layer:ILayer in event.items)
			{
				log.debug("[layer remove]layer:" + layer);
				_map.removeLayer(getLayer(layer.id));
			}
		}

		private function onCollectionRefreshAndResetHandler(event:CollectionEvent):void
		{
			log.debug("[layer reset or refresh]");
			for each (var layer:ILayer in layers)
			{
				addLayerAt(layer, layers.getItemIndex(layer));
			}
		}

		private function addLayerAt(gisLayer:ILayer, index:int=-1):void
		{
			var layer:Layer;
			if (gisLayer is GisServiceLayer)
			{
				if (StringUtil.trim(GisServiceLayer(gisLayer).url) == "")
				{
					GisServiceLayer(gisLayer).url=mapConfig.name;
				}
				if (getLayer(GisServiceLayer(gisLayer).url))
				{
					return;
				}
				log.debug("[addLayerAt]{0},{1}", GisServiceLayer(gisLayer).url, _map);
				layer=new RasterLayer(GisServiceLayer(gisLayer).url, _map);
			}
			else if (gisLayer is GisLayer)
			{
//				layer=new RasterLayer();
			}
			else if (gisLayer is GisFeatureLayer)
			{
			}
			else if (gisLayer is GisDynamicServiceLayer)
			{
			}
			else if (gisLayer is GisWMSLayer)
			{
			}
			if (layer)
			{
//				layer.layerName=gisLayer.id;
				_map.addLayer(layer);
			}
			gisLayer.map=this;
			if (gisLayer.gisFeatures)
			{
				var gisFeature:GisFeature=null;
				for each (gisFeature in gisLayer.gisFeatures)
				{
					addGisFeatureByLayerId(gisLayer.id, gisFeature);
				}
			}
			log.debug("[layer add]{0}", gisLayer);
		}

		private function getLayer(layerId:String):Layer
		{
			if (_map.getLayerByName(layerId) != null)
			{
				return _map.getLayerByName(layerId) as Layer;
			}
			return null;
		}
		
		override public function updateScaleBarDisplay(scaleBar:ScaleBar):void{
			super.updateScaleBarDisplay(scaleBar);
			var ruler:Ruler = new Ruler(_map);
			ruler.offset = getOffsetSize(scaleBar,ruler);
			_map.addControl(ruler);
		}
		
		override public function updateZoomSliderDisplay(zoomSlider:ZoomSliderBar):void{
			super.updateZoomSliderDisplay(zoomSlider);
			var size:Size = getOffsetSize(zoomSlider,nav);
			var nav:Navigator = new Navigator(_map);
			nav.offset = size;
			_map.addControl(nav);
			var scaler:Scaler = new Scaler(_map);
			scaler.offset = new Size(size.width+9,size.height+60);
			_map.addControl(scaler);
			
			var maptype:MapType = new MapType(_map);
			_map.addControl(maptype);
		}
		
		override public function updateOverViewToolDisplay(overViewTool:OverViewTool):void{
			super.updateOverViewToolDisplay(overViewTool);
			var overview:Overview = new Overview(_map);
			overview.offset = getOffsetSize(overViewTool,overview);
			_map.addControl(overview);
		}
		
		private function getOffsetSize(view:UIComponent,control:Control):Size{
			var w:Number=0;
			var h:Number=0;
			if(view.x>0){
				w = view.x;
			}
			if(view.y>0){
				h = view.y;
			}
			if(view.left){
				w = Number(view.left);
			}
			if(view.top){
				h = Number(view.top);
			}
			if(view.right){
				w = this.width-Number(view.right)-20;
			}
			if(view.bottom){
				h = this.height-Number(view.bottom)-20;
			}
			log.debug("[getOffsetSize]{0},{1},{2},{3}",w,h,_map.width,_map.height);
			return new Size(w,h);
		}
		
		override public function panMap():void
		{
			
		}
		
		override public function addGisFeatureByLayerIdAt(layerId:String, gisFeature:GisFeature, index:int):String
		{
			log.warn("addGisFeatureByLayerIdAt:{0}",index);
//			var layer:FeaturesLayer=FeaturesLayer(getLayer(layerId));
//			if (!layer)
//			{
//				return null;
//			}
			var graphic:Overlay;
//			if (gisFeature.contentMenus && gisFeature.contentMenus.length > 0)
//			{
//				
//			}
//			else
//			{
//				var gisLayer:GisLayer=GisLayer(getGisLayer(layerId));
//				if (gisLayer.featureContextMenus && gisLayer.featureContextMenus.length > 0)
//				{
//					gisFeature.contentMenus=gisLayer.featureContextMenus;
//				}
//			}
			graphic=parseGisFeature(gisFeature);
			log.warn(graphic);
			//			if (gisFeature.id)
			//			{
			//				graphic.id=gisFeature.id;
			//				layer.addFeature(graphic);
			//			}
			//			else
			//			{
			//				gisFeature.id=layer.addFeature(graphic);
			//			}
			if (gisFeature.id)
			{
//				graphic.id=gisFeature.id;
//				if(index>0){
//					(layer.features as ArrayCollection).addItemAt(graphic,index);
//				}else{
//					(layer.features as ArrayCollection).addItem(graphic);
//				}
			}
			else
			{
//				if(index>0){
//					(layer.features as ArrayCollection).addItemAt(graphic,index);
//				}else{
//					(layer.features as ArrayCollection).addItem(graphic);
//				}
//				gisFeature.id = graphic.id;
				
//				gisFeature.id=graphic.name;
			}
			
//			gisFeature.gisLayerId=layerId;
			_map.addOverlay(graphic);
			//			gisFeature.gisLayerId=layerId;
			//			gisFeature.index=(layer.features as ArrayCollection).getItemIndex(graphic);
//			var extent:Rectangle2D=graphic.geometry.bounds;
//			if (!extent)
//			{
//				extent=new Rectangle2D((graphic.geometry as GeoPoint).x, (graphic.geometry as GeoPoint).y, (graphic.geometry as GeoPoint).x, (graphic.geometry as GeoPoint).y);
//			}
//			gisFeature.gisMetry.gisExtent=parseExtent(extent);
//			registerMouseEvent(graphic);
			log.warn("[addGisFeatureByLayerIdAt]{0}", gisFeature);
			return gisFeature.id;
		}
		
		
		/**
		 * 转换上层对象成底层地图对象
		 * @param gisFeature
		 *
		 */
		private function parseGisFeature(gisFeature:GisFeature):*
		{
			log.warn("【parseGisFeature】");
			var feature:Overlay;
			if (!feature)
			{
				if(gisFeature.gisMetry is GisPoint){
					feature = new Marker();
					Marker(feature).position = new LngLat(GisPoint(gisFeature.gisMetry).x,GisPoint(gisFeature.gisMetry).y);
					Marker(feature).enableDragging=true;
					if(gisFeature.gisStyle is GisMarkerPictureStyle){
//						Marker(feature).content = "测试Marker文本";
//						Marker(feature).contentStyle = new TextFormat("微软雅黑", 12, 0x0000ff, true);
					}
				}else if(gisFeature.gisMetry is GisLine){
					
				}else if(gisFeature.gisMetry is GisRectangle){
					
				}else if(gisFeature.gisMetry is GisCircle){
					
				}else if(gisFeature.gisMetry is GisSector){
					
				}else if(gisFeature.gisMetry is GisRegion){
					
				}
			}
//			if(feature){
//				feature.contextMenu=gisFeature.contextMenu;
//				feature.alpha=gisFeature.alpha;
//				feature.buttonMode=gisFeature.buttonMode;
//				feature.filters=gisFeature.filters;
//				feature.visible=gisFeature.visible;
//			}
//			log.info("[parseGisFeature]feature.id:" + feature.id + ",feature:" + feature);
			return feature;
		}
		
	}
}