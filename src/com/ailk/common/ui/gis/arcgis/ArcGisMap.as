package com.ailk.common.ui.gis.arcgis
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.core.BaseMap;
	import com.ailk.common.ui.gis.core.GisContextMenuItem;
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
	import com.ailk.common.ui.gis.core.metry.GisExtent;
	import com.ailk.common.ui.gis.core.metry.GisLine;
	import com.ailk.common.ui.gis.core.metry.GisMetry;
	import com.ailk.common.ui.gis.core.metry.GisPoint;
	import com.ailk.common.ui.gis.core.metry.GisRectangle;
	import com.ailk.common.ui.gis.core.metry.GisRegion;
	import com.ailk.common.ui.gis.core.metry.GisSector;
	import com.ailk.common.ui.gis.core.styles.GisFillPictureStyle;
	import com.ailk.common.ui.gis.core.styles.GisFillPredefinedStyle;
	import com.ailk.common.ui.gis.core.styles.GisLinePredefinedStyle;
	import com.ailk.common.ui.gis.core.styles.GisMarkerPictureStyle;
	import com.ailk.common.ui.gis.core.styles.GisMarkerPredefinedStyle;
	import com.ailk.common.ui.gis.core.styles.GisMarkerStyle;
	import com.ailk.common.ui.gis.core.styles.GisStyle;
	import com.ailk.common.ui.gis.core.styles.GisTextStyle;
	import com.ailk.common.ui.gis.core.task.BaseTask;
	import com.ailk.common.ui.gis.core.task.GisFindTask;
	import com.ailk.common.ui.gis.core.task.GisIdentifyParameters;
	import com.ailk.common.ui.gis.core.task.GisIdentifyTask;
	import com.ailk.common.ui.gis.core.task.GisQuery;
	import com.ailk.common.ui.gis.core.task.GisQueryTask;
	import com.ailk.common.ui.gis.event.GisDrawEvent;
	import com.ailk.common.ui.gis.event.GisExtentEvent;
	import com.ailk.common.ui.gis.event.GisFeatureLayerEvent;
	import com.ailk.common.ui.gis.event.GisIdentifyEvent;
	import com.ailk.common.ui.gis.event.MapEvent;
	import com.ailk.common.ui.gis.tools.OverViewTool;
	import com.ailk.common.ui.gis.tools.PropertiesCompEvent;
	import com.ailk.common.ui.gis.tools.ScaleBar;
	import com.ailk.common.ui.gis.tools.ZoomSliderBar;
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.events.DrawEvent;
	import com.esri.ags.events.EditEvent;
	import com.esri.ags.events.ExtentEvent;
	import com.esri.ags.events.FeatureLayerEvent;
	import com.esri.ags.events.GeometryServiceEvent;
	import com.esri.ags.events.GraphicEvent;
	import com.esri.ags.events.IdentifyEvent;
	import com.esri.ags.events.LayerEvent;
	import com.esri.ags.events.MapMouseEvent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
	import com.esri.ags.layers.FeatureLayer;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.layers.Layer;
	import com.esri.ags.symbols.PictureFillSymbol;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.Symbol;
	import com.esri.ags.symbols.TextSymbol;
	import com.esri.ags.tasks.FindTask;
	import com.esri.ags.tasks.GeometryService;
	import com.esri.ags.tasks.IdentifyTask;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.FindParameters;
	import com.esri.ags.tasks.supportClasses.FindResult;
	import com.esri.ags.tasks.supportClasses.IdentifyParameters;
	import com.esri.ags.tasks.supportClasses.IdentifyResult;
	import com.esri.ags.tasks.supportClasses.LengthsParameters;
	import com.esri.ags.tasks.supportClasses.Query;
	import com.esri.ags.tools.DrawTool;
	import com.esri.ags.tools.EditTool;
	import com.esri.ags.tools.NavigationTool;
	
	import flash.display.BitmapData;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.effects.Glow;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.ResizeEvent;
	import mx.graphics.codec.PNGEncoder;
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	import spark.components.BorderContainer;

	use namespace gis_internal;

	/**
	 * ArcGis地图适配类
	 * @author shiliang
	 *
	 */
	public class ArcGisMap extends BaseMap
	{
		private static var log:ILogger=Log.getLoggerByClass(ArcGisMap);
		private var _map:Map;
		private var _extent:Extent;

		private var spatialReference:SpatialReference;
		private var _navTool:NavigationTool;

		private var drawTool:ArcGisDrawTool;

		private var editTool:EditTool;

		private var _glow:Glow=new Glow();

		private var extraLayerBaseUrl:String="http://10.40.4.111:8399/arcgis/rest/services/zhzx";
//		private var zhBTSExtraWMSLayer:ExtraWMSLayer;
//		private var zhNodeBExtraWMSLayer:ExtraWMSLayer;
//		private var zhAPExtraWMSLayer:ExtraWMSLayer;
//		private var zhCellExtraWMSLayer:ExtraWMSLayer;
//		private var zhExcuseWMSLayer:ExtraWMSLayer;
//		private var zhGimscustomerWMSLayer:ExtraWMSLayer;
//		private var zhMachineroomWMSLayer:ExtraWMSLayer;
//		private var zhUtrancellExtraWMSLayer:ExtraWMSLayer;

		private var zhBTSExtraWMSLayer:GisWMSLayer;
		private var zhNodeBExtraWMSLayer:GisWMSLayer;
		private var zhAPExtraWMSLayer:GisWMSLayer;
		private var zhCellExtraWMSLayer:GisWMSLayer;
		private var zhExcuseWMSLayer:GisWMSLayer;
		private var zhGimscustomerWMSLayer:GisWMSLayer;
		private var zhMachineroomWMSLayer:GisWMSLayer;
		private var zhUtrancellExtraWMSLayer:GisWMSLayer;

		private var geometryService:GeometryService;
		private var textMetric:String;

		private var graphic:Graphic;
		private var lastEditGraphic:Graphic;
		private var lastActiveEditTypes:String;
		private var lastEditGisFeature:GisFeature;

		public function ArcGisMap(config:IMapConfig, control:IMapControl)
		{
			super(config, control);
			_map=new Map();
			_map.panDuration=1;
			_map.panEasingFactor=1;
			_map.zoomDuration=1;
			_map.wrapAround180=false;
			_map.zoomSliderVisible=false;
			_map.logoVisible=false;
			_map.rubberbandZoomEnabled=false;
			_map.scaleBarVisible=false;
			_map.scrollWheelZoomEnabled=config.scrollWheelZoomEnabled;
			_map.doubleClickZoomEnabled=config.doubleClickZoomEnabled;
			_map.contextMenu=new ContextMenu();
			_map.contextMenu.hideBuiltInItems();
			_map.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, onMenuSelectHandler);

			_map.addEventListener(MapMouseEvent.MAP_CLICK, map_clickHandler);
			_map.addEventListener(MouseEvent.MOUSE_MOVE, map_MoveHandler);
			_map.addEventListener(com.esri.ags.events.MapEvent.LOAD, this.map_loadHandler, false, 0, true);
			_map.addEventListener(ResizeEvent.RESIZE, this.map_resizeHandler, false, 0, true);
			_map.addEventListener(ExtentEvent.EXTENT_CHANGE, this.map_extentChangeHandler, false, 0, true);
			_map.addEventListener(MapMouseEvent.MAP_MOUSE_DOWN, myMap_mapMouseDownHandler);
			_map.openHandCursorVisible=false;

			geometryService=new GeometryService();
			geometryService.concurrency="last";
			geometryService.addEventListener(GeometryServiceEvent.LENGTHS_COMPLETE, lengthsCompleteHandler);
			geometryService.addEventListener(GeometryServiceEvent.PROJECT_COMPLETE, onProjectCompleteHandler);
			geometryService.showBusyCursor=true;
			geometryService.url=String(mapConfig.mapUrl).substring(0, String(mapConfig.mapUrl).indexOf("/services/") + 10) + "Geometry/GeometryServer";
			log.debug("geometryService.url:{0}", geometryService.url);
			control.addMapEventListener(MapEvent.DRAWTOOL_CREATION_COMPLETE, onDrawToolCreationCompleteHandler);
		}

		private function onDrawToolCreationCompleteHandler(event:MapEvent):void
		{
			var markerSymbol:SimpleMarkerSymbol=new SimpleMarkerSymbol();
			markerSymbol.color=0x00FF00;
			markerSymbol.size=12;
			markerSymbol.style=GisMarkerStyle.STYLE_CIRCLE;
			var lineSymbol:SimpleLineSymbol=new SimpleLineSymbol();
			lineSymbol.width=3;
			lineSymbol.color=0x0ac1e6;
			var lineSymbol1:SimpleLineSymbol=new SimpleLineSymbol();
			lineSymbol1.width=2;
			lineSymbol1.color=0x0ac1e6;
			var fillSymbol:SimpleFillSymbol=new SimpleFillSymbol();
			fillSymbol.color=0xe3f8ff;
			fillSymbol.alpha=0.5;
			fillSymbol.style=SimpleFillSymbol.STYLE_SOLID;
			fillSymbol.outline=lineSymbol1;

			drawTool=new ArcGisDrawTool();
			drawTool.fillSymbol=fillSymbol;
			//			drawTool.graphicsLayer=GraphicsLayer(getLayer(defaultGisLayer.id));
			drawTool.graphicsLayer=GraphicsLayer(getLayer(drawToolGisLayer.id));
			drawTool.lineSymbol=lineSymbol;
			drawTool.map=_map;
			drawTool.markerSymbol=markerSymbol;
			drawTool.addEventListener(DrawEvent.DRAW_END, onDrawEndHandler);
		}

		private function map_loadHandler(event:com.esri.ags.events.MapEvent):void
		{
			this.dirty=true;
			invalidateProperties();
			control.dispatchMapEvent(new MapEvent(MapEvent.MAP_CREATION_COMPLETE));
		}

		private function map_resizeHandler(event:ResizeEvent):void
		{
			this.dirty=true;
			invalidateProperties();
		}

		private function map_extentChangeHandler(event:ExtentEvent):void
		{
			this.dirty=true;
			invalidateProperties();
		}


		override protected function commitProperties():void
		{
			if (this.dirty)
			{
				this.dirty=false;
				if (this._map.scale > 0)
				{
					resetMetersPerPixel();
				}
			}
			super.commitProperties();
		}

		private function resetMetersPerPixel():void
		{
			this.metersPerPixel=_map.scale * Math.cos(Math.PI / 180 * Math.min(89.999, Math.abs(this._map.extent.center.y))) / 3779.53;
		}

		private function myMap_mapMouseDownHandler(event:MapMouseEvent):void
		{
			event.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE, map_mouseMoveHandler);
			event.currentTarget.addEventListener(MouseEvent.MOUSE_UP, map_mouseUpHandler);
		}

		private function map_mouseMoveHandler(event:MouseEvent):void
		{
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, map_mouseMoveHandler);
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, map_mouseUpHandler);
		}

		private function map_mouseUpHandler(event:MouseEvent):void
		{
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, map_mouseMoveHandler);
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, map_mouseUpHandler);
			if (event.target is Graphic)
			{
				graphic=Graphic(event.target);
//				if (graphic.graphicsLayer != GraphicsLayer(getLayer(defaultGisLayer.id)))
//				{
//					return;
//				}
				if (lastEditGraphic !== graphic)
				{
					lastEditGraphic=graphic;
					lastActiveEditTypes="moveRotateScale"; // make sure move and edit vertices is the 1st mode
				}
				if(event.target is Graphic){
					graphic=Graphic(event.target);
					var gisFeature:GisFeature = parseGraphic(graphic);
					if(gisFeature.moveable){
						editTool.activate(EditTool.MOVE, [graphic]);
					}
				}else if(graphic.graphicsLayer == GraphicsLayer(getLayer(defaultGisLayer.id))){
					if (graphic.geometry is Polyline || graphic.geometry is Polygon)
					{
						if (lastActiveEditTypes == "moveEditVertices")
						{
							lastActiveEditTypes="moveRotateScale";
							editTool.activate(EditTool.MOVE | EditTool.SCALE | EditTool.ROTATE, [graphic]);
						}
						else
						{
							lastActiveEditTypes="moveEditVertices";
							editTool.activate(EditTool.MOVE | EditTool.EDIT_VERTICES, [graphic]);
						}
					}
					else if (graphic.geometry is Extent)
					{
						editTool.activate(EditTool.MOVE | EditTool.SCALE, [graphic]);
					}
					else if (graphic.graphicsLayer == GraphicsLayer(getLayer(defaultGisLayer.id)))
					{
						editTool.activate(EditTool.MOVE | EditTool.EDIT_VERTICES, [graphic]);
					}
				}
			}
			else
			{
				editTool.deactivate();
				lastActiveEditTypes="moveRotateScale"; // make sure move and edit vertices is the 1st mode
			}
		}

		private function onEditEndHandler(event:EditEvent):void
		{
			log.warn("onEditEndHandler====>{0}", lastEditGraphic);
			if (lastEditGraphic)
			{
				lastEditGisFeature=parseGraphic(lastEditGraphic);
				dispatchDrawEnd(lastEditGisFeature);
			}
		}

		private function onExTentChange(event:ExtentEvent):void
		{
			var gisExtentEvent:GisExtentEvent=new GisExtentEvent(GisExtentEvent.EXTENT_CHANGE);
			gisExtentEvent.levelChange=event.levelChange;
			gisExtentEvent.extent=parseExtent(event.extent);
			control.dispatchMapEvent(gisExtentEvent);
		}

		private function onDrawEndHandler(event:DrawEvent):void
		{
			var feature:Graphic=event.graphic;
			if (selectedable)
			{
				drawTool.deactivate();
				_map.extent=feature.geometry.extent;
				selectedable=false;
				GraphicsLayer(getLayer(drawToolGisLayer.id)).remove(feature);
				control.dispatchMapEvent(new MapEvent(MapEvent.MAP_SELECT_COMPLETE));
				return;
			}
			if (ruleable)
			{
				drawTool.deactivate();
//				var paths:Array=(feature.geometry as Polyline).paths;
				calculateRadius(event.graphic);
				GraphicsLayer(getLayer(drawToolGisLayer.id)).remove(feature);
				ruleable=false;

				return;
			}
			if (step != 0 && step < drawHis.length)
			{
				drawHis.splice(step, drawHis.length - step);
			}
			lastEditGraphic=feature;
			var gisFeature:GisFeature=parseGraphic(feature);
			GraphicsLayer(getLayer(drawToolGisLayer.id)).remove(feature);
			drawToolGisLayer.addGisFeature(gisFeature);
			drawHis.push(gisFeature);
			step=drawHis.length;
			drawTool.deactivate();
			feature.autoMoveToTop=false;
			lastEditGisFeature=gisFeature;
			dispatchDrawEnd(gisFeature);
		}

		private function dispatchDrawEnd(gisFeature:GisFeature):void
		{
			var drawEvent:GisDrawEvent=new GisDrawEvent(GisDrawEvent.DRAW_END);
			drawEvent.gisFeature=gisFeature;
			control.dispatchMapEvent(drawEvent);
		}

		/**
		 * 测量距离
		 * @param paths
		 *
		 */
		private function calculateRadius(feature:Graphic):void
		{
//			geometryService.project([feature.geometry],spatialReference);
			var paths:Array=(feature.geometry as Polyline).paths[0];
			if (paths.length >= 2)
			{
//				var sx:Number=96.49;
//				var sy:Number=110.85;
				var len:Number=0;
				for (var i:Number=0; i < paths.length; i++)
				{
					if (i < paths.length - 1)
					{
						var startPoint:MapPoint=paths[i];
						var endPoint:MapPoint=paths[i + 1];
						var start:Point=this._map.toScreen(startPoint);
						var end:Point=this._map.toScreen(endPoint);
						var x:Number=start.x - end.x;
						var y:Number=start.y - end.y;
						len+=Math.sqrt(x * x * this.metersPerPixel * this.metersPerPixel + y * y * this.metersPerPixel * this.metersPerPixel) / 1000;
//						len+=Math.sqrt(x * x + y * y);
					}
				}
				Alert.show("当前距离：" + len.toFixed(2) + "km");
			}
		}

		private function lengthsCompleteHandler(event:GeometryServiceEvent):void
		{
			// Report as meters if less than 3km, otherwise km
			var dist:Number=(event.result as Array)[0];
			var myAttributes:Object={};
			myAttributes.distance=Number(dist).toFixed(1) + " 千米";
			Alert.show("当前距离：" + myAttributes.distance);
			//var g:Graphic = new Graphic(latestEndpoint, new TextSymbol(null, "text3", 0, true, 0, true));
//			var g:Graphic = new Graphic(latestEndpoint, myInfoSymbol, myAttributes);
//			resultLayer.add(g);
		}

		private function onProjectCompleteHandler(event:GeometryServiceEvent):void
		{
			var drawnLine:Polyline=Polyline(event.result[0]);
			var lengthsParameters:LengthsParameters=new LengthsParameters();
			lengthsParameters.geodesic=true;
			lengthsParameters.polylines=[drawnLine];
			geometryService.lengths(lengthsParameters);
		}


		override protected function createChildren():void
		{
			super.createChildren();
			addChild(_map);

			addGisLayer(serviceGisLayer);
			addGisLayer(modelGisLayer);
			addGisLayer(defaultGisLayer);

			_navTool=new NavigationTool();
			_navTool.map=_map;

			editTool=new EditTool();
			editTool.map=this._map;
			editTool.addEventListener(EditEvent.GEOMETRY_UPDATE, onEditEndHandler);
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

		private function onLayerLoad(event:LayerEvent):void
		{

			_map.lods=ArcGISTiledMapServiceLayer(event.layer).tileInfo.lods;
			_map.extent=ArcGISTiledMapServiceLayer(event.layer).fullExtent;
			spatialReference=ArcGISTiledMapServiceLayer(event.layer).spatialReference;
			var time:Number=_map.panDuration > _map.zoomDuration ? _map.panDuration : _map.zoomDuration;
			setTimeout(loadEnd, time + 300);
		}

		private function loadEnd():void
		{
//			control.dispatchMapEvent(new MapEvent(MapEvent.MAP_CREATION_COMPLETE));
			_navTool.addEventListener(ExtentEvent.EXTENT_CHANGE, onExTentChange);
		}

		/**
		 * 右键菜单处理
		 * @param event
		 *
		 */
		private function onMenuSelectHandler(event:ContextMenuEvent):void
		{
			var target:Object=parseMapTarget(event.mouseTarget);
			log.debug("[右键菜单]" + event.target + "," + event.currentTarget + "," + event.contextMenuOwner + "," + event.mouseTarget + "," + target);
			ContextMenu(event.target).customItems.splice(0);
			if (target is GisFeature)
			{
				log.debug("[右键菜单]:{0}", GisFeature(target).contentMenus);
				for each (var menuItem:GisContextMenuItem in GisFeature(target).contentMenus)
				{
					var item:ContextMenuItem=new ContextMenuItem(menuItem.caption, menuItem.separatorBefore, menuItem.enabled, menuItem.visible);
					item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(evt:ContextMenuEvent):void
						{
							log.debug("[右键菜单项选择]target:" + target + ",Menu:" + evt.currentTarget.caption);
							var menu:GisContextMenuItem=getMenuItem(String(evt.currentTarget.caption), GisFeature(target).contentMenus);
							log.debug("[右键菜单项选择]menu:" + menu.caption + "," + menu.callback);
							if (menu.callback is Function)
							{
								if (!GisFeature(target).attributes)
								{
									GisFeature(target).attributes=new Object;
								}
								GisFeature(target).attributes.selectMenuName=String(evt.currentTarget.caption);
								log.debug("[右键菜单项选择]menuObj:" + GisFeature(target).attributes.selectMenuName);
								menu.callback.call(null, GisFeature(target));
							}
						});
					ContextMenu(event.target).customItems.push(item);
				}
			}
		}

		/**
		 * 地图MouseMove事件
		 * @param event
		 *
		 */
		private function map_MoveHandler(event:MouseEvent):void
		{
		}

		/**
		 * 地图Click事件
		 * @param event
		 *
		 */
		private function map_clickHandler(event:MapMouseEvent):void
		{
//			try
//			{
			var evt:MapEvent=new MapEvent(MapEvent.MAP_CLICK);
			//			var point:MapPoint =_map.toMap(new Point(event.localX,event.localY));
//				var point:MapPoint=_map.toMap(this.globalToLocal(new Point(event.stageX, event.stageY)));
			evt.mapPoint=new GisPoint(event.mapPoint.x, event.mapPoint.y);
			control.dispatchMapEvent(evt);
//			}
//			catch (e:Error)
//			{
//
//			}
			lastDrawPoint=new GisPoint(event.mapPoint.x, event.mapPoint.y);
			if (isLastDrawPointSet)
			{
				showPropComp();
				isLastDrawPointSet=false;
			}
		}

		/**
		 * 解析地图对象
		 * @param target
		 * @return
		 *
		 */
		private function parseMapTarget(target:Object):Object
		{
			if (!target)
			{
				return null;
			}
			else if (target is Map)
			{
				return this;
			}
			else if (target is Graphic)
			{
				return parseGraphic(Graphic(target));
			}
			else
			{
				return parseMapTarget(target.parent);
			}
		}


		private function onGraphicClickHandler(event:MouseEvent):void
		{
			log.debug("onGraphicClickHandler:" + event.target + "," + event.currentTarget + "," + event.target.parent);
			var graphic:Graphic=Graphic(event.currentTarget);
			if (graphic && graphic.graphicsLayer)
			{
				log.debug("onGraphicClickHandler:{0},{1},{2}", graphic, graphic.graphicsLayer.id, graphic.id);
				var gisFeature:GisFeature=getGisLayer(graphic.graphicsLayer.id).getGisFeatureByID(graphic.id);
				if (gisFeature && gisFeature.onClick is Function)
				{
					gisFeature.onClick.call(event, gisFeature, event);
				}
			}
		}

		private function onGraphicOverHandler(event:MouseEvent):void
		{
			log.debug("onGraphicOverHandler:" + event.target + "," + event.currentTarget + "," + event.target.parent);
			var graphic:Graphic=Graphic(event.currentTarget);
			if (graphic && graphic.graphicsLayer)
			{
				var gisFeature:GisFeature=getGisLayer(graphic.graphicsLayer.id).getGisFeatureByID(graphic.id);
				if (gisFeature && gisFeature.onMouseOver is Function)
				{
					gisFeature.onMouseOver.call(event, gisFeature, event);
				}
			}
		}

		private function onGraphicOutHandler(event:MouseEvent):void
		{
			log.debug("onGraphicOutHandler:" + event.target + "," + event.currentTarget + "," + event.target.parent);
			var graphic:Graphic=Graphic(event.currentTarget);
			if (graphic && graphic.graphicsLayer)
			{
				var gisFeature:GisFeature=getGisLayer(graphic.graphicsLayer.id).getGisFeatureByID(graphic.id);
				if (gisFeature && gisFeature.onMouseOut is Function)
				{
					gisFeature.onMouseOut.call(event, gisFeature, event);
				}
			}
		}

		/**
		 * 转换上层对象成底层地图对象
		 * @param gisFeature
		 * @return
		 *
		 */
		private function parseGisFeature(gisFeature:GisFeature):*
		{
			var symbol:Symbol=parseGisStyle(gisFeature.gisStyle);
			var graphic:Graphic;
			var gis_id:String;
			try
			{
				if (gisFeature.attributes && gisFeature.attributes.gis_id)
				{
					gis_id=String(gisFeature.attributes.gis_id);
					graphic=queryGisCache[gis_id];
					graphic.symbol=symbol;
				}
			}
			catch (e:Error)
			{
				log.error("从缓存中不存在{0}对象", gis_id);
			}
			if (gisFeature.gisLayerId)
			{
				try
				{
					log.debug("[parseGisFeature]gisFeature.gisLayerId:{0}", gisFeature.gisLayerId);
					graphic=Graphic((GraphicsLayer(getLayer(gisFeature.gisLayerId)).graphicProvider as ArrayCollection).getItemAt(getGisLayer(gisFeature.gisLayerId).gisFeatures.getItemIndex(gisFeature)));
				}
				catch (e:Error)
				{
					log.error("图层{0}中不存在{1}", gisFeature.gisLayerId,gisFeature);
				}
			}
			if (!graphic)
			{
				graphic=new Graphic(parseGisMetry(gisFeature.gisMetry), symbol);
				graphic.id=graphic.toString();
			}
			graphic.toolTip=gisFeature.toolTip;
			graphic.autoMoveToTop=gisFeature.autoMoveToTop;
			graphic.alpha=gisFeature.alpha;
			graphic.contextMenu=gisFeature.contextMenu;
			graphic.buttonMode=gisFeature.buttonMode;
			graphic.filters=gisFeature.filters;
			graphic.visible=gisFeature.visible;
//			log.debug("[parseGisFeature]graphic.id:"+graphic.id+",graphic:"+graphic);
			return graphic;
		}

		/**
		 * 转换上层点、线、面对象成底层地图点、线、面对象
		 * @param gisFeature
		 * @return
		 *
		 */
		private function parseGisMetry(gisMetry:GisMetry):Geometry
		{
			var geometry:Geometry=null;
			var parts:Array=null;
			if (gisMetry is GisPoint) //转换点
			{
				var gisPoint:GisPoint=gisMetry as GisPoint;
				geometry=new MapPoint(gisPoint.x, gisPoint.y, spatialReference);
			}
			else if (gisMetry is GisLine) //转换线
			{
				var gisLine:GisLine=gisMetry as GisLine;
				parts=new Array();
				for each (var gisLinePoint:GisPoint in gisLine.parts)
				{
					parts.push(new MapPoint(gisLinePoint.x, gisLinePoint.y));
				}
				geometry=new Polyline(null, spatialReference);
				(geometry as Polyline).addPath(parts);
			}
			else if (gisMetry is GisExtent) //转换区域与矩形类似
			{
				var gisExtent:GisExtent=gisMetry as GisExtent;
				geometry=new Extent(gisExtent.xmin, gisExtent.ymin, gisExtent.xmax, gisExtent.ymax);
			}
			else if (gisMetry is GisRectangle)
			{ //转换矩形
				var gisRect:GisRectangle=gisMetry as GisRectangle;
				var _w:Number=gisRect.width * 1000 / this.metersPerPixel;
				var _h:Number=gisRect.height * 1000 / this.metersPerPixel;
				var startPoint:Point;
				var endPoint:Point;
				if (gisRect.startPoint)
				{
					startPoint=this._map.toScreen(new MapPoint(gisRect.startPoint.x, gisRect.startPoint.y));
					endPoint=new Point(startPoint.x + _w, startPoint.y + _h);
				}
				else if (gisRect.centerPoint)
				{
					var center:Point=this._map.toScreen(new MapPoint(gisRect.centerPoint.x, gisRect.centerPoint.y));
					startPoint=new Point(center.x - _w / 2, center.y - _h / 2);
					endPoint=new Point(center.x + _w / 2, center.y + _h / 2);
					var start:MapPoint=this._map.toMap(startPoint);
					gisRect.startPoint=new GisPoint(start.x, start.y);
				}
				var end:MapPoint=this._map.toMap(endPoint);
				geometry=new Extent(gisRect.startPoint.x, gisRect.startPoint.y, end.x, end.y);
				parts=new Array();
				parts.push(new GisPoint(gisRect.startPoint.x, gisRect.startPoint.y));
				parts.push(new GisPoint(end.x, gisRect.startPoint.y));
				parts.push(new GisPoint(end.x, end.y));
				parts.push(new GisPoint(gisRect.startPoint.x, end.y));
//				parts.push(new GisPoint(gisRect.startPoint.x,gisRect.startPoint.y));
				gisRect.parts=parts;

			}
			else if (gisMetry is GisCircle) //转换圆
			{
				parts=createCirclePoints(gisMetry as GisCircle);
				geometry=new Polygon(null, spatialReference);
				(geometry as Polygon).addRing(parts);
			}
			else if (gisMetry is GisSector) //转换扇形
			{
				parts=createSectorPoints(gisMetry as GisSector);
				geometry=new Polygon(null, spatialReference);
				(geometry as Polygon).addRing(parts);
			}
			else if (gisMetry is GisRegion) //转换面
			{
				var gisRegion:GisRegion=gisMetry as GisRegion;
				parts=new Array();
				for each (var gisRegionPoint:GisPoint in gisRegion.parts)
				{
					parts.push(new MapPoint(gisRegionPoint.x, gisRegionPoint.y));
				}
				geometry=new Polygon(null, spatialReference);
				(geometry as Polygon).addRing(parts);
			}
			return geometry;
		}
		
		override public function getCirclePoints(centerPoint:GisPoint,radius:Number,sides:Number):Array
		{
			var points:Array=new Array();
			var i:Number;
			var sin:Number;
			var cos:Number;
			var x:Number;
			var y:Number;
			var point:Point=null;
			i=0;
			var mapCenterPoint:MapPoint=new MapPoint(centerPoint.x, centerPoint.y);
			if (this.metersPerPixel <= 0)
			{
				resetMetersPerPixel();
			}
			var rad:Number=radius * 1000 / this.metersPerPixel;
			var mapPoint:MapPoint;
			while (i < sides)
			{
				sin=Math.sin(Math.PI * 2 * i / sides);
				cos=Math.cos(Math.PI * 2 * i / sides);
				point=this._map.toScreen(mapCenterPoint);
				point.x=point.x + rad * cos;
				point.y=point.y + rad * sin;
				mapPoint=this._map.toMap(point);
				points[i]=new GisPoint(mapPoint.x, mapPoint.y);
				i++;
			}
			return points;
		}

		private function createCirclePoints(gisCircle:GisCircle):Array
		{
			var points:Array=new Array();
			var points1:Array=new Array();
			var i:Number;
			var sin:Number;
			var cos:Number;
			var x:Number;
			var y:Number;
			var point:Point=null;
			i=0;
			var centerPoint:MapPoint=new MapPoint(gisCircle.centerPoint.x, gisCircle.centerPoint.y);
			if (this.metersPerPixel <= 0)
			{
				resetMetersPerPixel();
			}
			var rad:Number=gisCircle.radius * 1000 / this.metersPerPixel;
//			log.debug("===>{0},{1}km,{2}",this._metersPerPixel,gisCircle.radius,rad);
			var mapPoint:MapPoint;
			while (i < gisCircle.sides)
			{
				sin=Math.sin(Math.PI * 2 * i / gisCircle.sides);
				cos=Math.cos(Math.PI * 2 * i / gisCircle.sides);
				point=this._map.toScreen(centerPoint);
				point.x=point.x + rad * cos;
				point.y=point.y + rad * sin;
				mapPoint=this._map.toMap(point);
				points[i]=mapPoint;
				points1[i]=new GisPoint(mapPoint.x, mapPoint.y);
				i++;
			}
			gisCircle.parts=points1;
			return points;
		}
		
		private function createSectorPoints(gisSector:GisSector):Array
		{
			var points:Array=new Array();
			var points1:Array=new Array();
			var i:Number;
			var sin:Number;
			var cos:Number;
			var x:Number;
			var y:Number;
			var point:Point=null;
			i=0;
			var centerPoint:MapPoint=new MapPoint(gisSector.centerPoint.x, gisSector.centerPoint.y);
			if (this.metersPerPixel <= 0)
			{
				resetMetersPerPixel();
			}
			var rad:Number=gisSector.radius * 1000 / this.metersPerPixel;
			//			log.debug("===>{0},{1}km,{2}",this._metersPerPixel,gisCircle.radius,rad);
			var mapPoint:MapPoint;
			points[0]=centerPoint;
			points1[0]=gisSector.centerPoint;
			if(gisSector.angleType==0){
				gisSector.startAngle = gisSector.startAngle*Math.PI/180;
				gisSector.endAngle = gisSector.endAngle*Math.PI/180;
			}
			var startIndex:Number = gisSector.startAngle/(Math.PI*2)*gisSector.sides;
			var endIndex:Number = gisSector.endAngle/(Math.PI*2)*gisSector.sides;
			log.warn("startIndex:{0},endIndex:{1},startAngle:{2},endAngle:{3}", startIndex, endIndex, gisSector.startAngle / (Math.PI * 2), gisSector.endAngle / (Math.PI * 2));
			i=startIndex;
			if(i>=endIndex){
				while (i <= gisSector.sides)
				{
					sin=Math.sin(-Math.PI * 2 * i / gisSector.sides);
					cos=Math.cos(-Math.PI * 2 * i / gisSector.sides);
					point=this._map.toScreen(centerPoint);
					point.x+=rad * cos;
					point.y+=rad * sin;
					mapPoint=this._map.toMap(point);
					points[i - startIndex + 1]=mapPoint;
					points1[i - startIndex + 1]=new GisPoint(mapPoint.x, mapPoint.y);
					i++;
				}
				i=0;
				while (i <= endIndex)
				{
					sin=Math.sin(-Math.PI * 2 * i / gisSector.sides);
					cos=Math.cos(-Math.PI * 2 * i / gisSector.sides);
					point=this._map.toScreen(centerPoint);
					point.x+=rad * cos;
					point.y+=rad * sin;
					mapPoint=this._map.toMap(point);
					points[gisSector.sides - startIndex + i + 1]=mapPoint;
					points1[gisSector.sides - startIndex + i + 1]=new GisPoint(mapPoint.x, mapPoint.y);
					i++;
				}
			}else{
				while (i <= endIndex)
				{
					sin=Math.sin(-Math.PI * 2 * i / gisSector.sides);
					cos=Math.cos(-Math.PI * 2 * i / gisSector.sides);
					point=this._map.toScreen(centerPoint);
					point.x+=rad * cos;
					point.y+=rad * sin;
					mapPoint=this._map.toMap(point);
					points[i - startIndex + 1]=mapPoint;
					points1[i - startIndex + 1]=new GisPoint(mapPoint.x, mapPoint.y);
					i++;
				}
			}
			gisSector.parts=points1;
			return points;
		}
		

		/**
		 * 转换上层样式对象成底层地图样式对象
		 * @param gisFeature
		 * @return
		 *
		 */
		private function parseGisStyle(gisStyle:GisStyle):Symbol
		{
			var symbol:Symbol=null;
			var borderStyle:SimpleLineSymbol=null;
			if (gisStyle is GisMarkerPredefinedStyle) //点样式
			{
				var markerPredefinedStyle:GisMarkerPredefinedStyle=gisStyle as GisMarkerPredefinedStyle;
				symbol=new SimpleMarkerSymbol(markerPredefinedStyle.symbol, markerPredefinedStyle.size, markerPredefinedStyle.color, markerPredefinedStyle.alpha, markerPredefinedStyle.xOffset, markerPredefinedStyle.yOffset, markerPredefinedStyle.angle, null);
			}
			else if (gisStyle is GisMarkerPictureStyle) //图片点样式
			{
				var markerPictureStyle:GisMarkerPictureStyle=gisStyle as GisMarkerPictureStyle;
				symbol=new PictureMarkerSymbol(markerPictureStyle.source, markerPictureStyle.width, markerPictureStyle.height, markerPictureStyle.xOffset, markerPictureStyle.yOffset, markerPictureStyle.angle);
			}
			else if (gisStyle is GisLinePredefinedStyle) //线样式
			{
				var linePredefinedStyle:GisLinePredefinedStyle=gisStyle as GisLinePredefinedStyle;
				symbol=new SimpleLineSymbol(linePredefinedStyle.symbol, linePredefinedStyle.color, linePredefinedStyle.alpha, linePredefinedStyle.weight);
			}
			else if (gisStyle is GisFillPredefinedStyle) //线填充样式
			{
				var fillPredefinedStyle:GisFillPredefinedStyle=gisStyle as GisFillPredefinedStyle;
				if (fillPredefinedStyle.border != null)
				{
					borderStyle=new SimpleLineSymbol(fillPredefinedStyle.border.symbol, fillPredefinedStyle.border.color, fillPredefinedStyle.border.alpha, fillPredefinedStyle.border.weight);
				}
				symbol=new SimpleFillSymbol(fillPredefinedStyle.symbol, fillPredefinedStyle.color, fillPredefinedStyle.alpha, borderStyle);

			}
			else if (gisStyle is GisFillPictureStyle) //图片填充样式
			{
				var fillPictureStyle:GisFillPictureStyle=gisStyle as GisFillPictureStyle;
				if (fillPictureStyle.border != null)
				{
					borderStyle=new SimpleLineSymbol(fillPictureStyle.border.symbol, fillPictureStyle.border.color, fillPictureStyle.border.alpha, fillPictureStyle.border.weight);
				}
				symbol=new PictureFillSymbol(fillPictureStyle.source, fillPictureStyle.width, fillPictureStyle.height, fillPictureStyle.xScale, fillPictureStyle.yScale, fillPictureStyle.xOffset, fillPictureStyle.yOffset, fillPictureStyle.angle, borderStyle);
			}
			else if (gisStyle is GisTextStyle) //文字样式
			{
				var textStyle:GisTextStyle=gisStyle as GisTextStyle;
				symbol=new TextSymbol(textStyle.text, textStyle.htmlText, textStyle.color, textStyle.border, textStyle.borderColor, textStyle.background, textStyle.backgroundColor, textStyle.placement, textStyle.angle, textStyle.xoffset, textStyle.yoffset, textStyle.textFormat, textStyle.textAttribute, textStyle.textFunction);
			}

			return symbol;
		}

		/**
		 * 转换底层对象成上层地图对象
		 * @param graphic
		 * @return
		 *
		 */
		private function parseGraphic(graphic:Graphic):GisFeature
		{
			var gisFeature:GisFeature;
			var gisLayer:ILayer;
			if (!gisFeature && graphic.id && graphic.graphicsLayer)
			{
				gisLayer=getGisLayer(graphic.graphicsLayer.id);
				if (gisLayer)
				{
					gisFeature=gisLayer.getGisFeatureByID(graphic.id);
				}
			}
			if (!gisFeature)
			{
				gisFeature=new GisFeature(parseMetry(graphic.geometry), parseStyle(graphic.symbol));
				if (graphic.id)
				{
					gisFeature.id=graphic.id;
				}
				if (graphic.attributes)
				{
					gisFeature.attributes=graphic.attributes;
				}
				if (!gisFeature.attributes)
				{
					gisFeature.attributes=new Object;
				}
				gisFeature.autoMoveToTop=graphic.autoMoveToTop;
				var extent:Extent=graphic.geometry.extent;
				if (!extent)
				{
					extent=new Extent((graphic.geometry as MapPoint).x, (graphic.geometry as MapPoint).y, (graphic.geometry as MapPoint).x, (graphic.geometry as MapPoint).y);
				}
				gisFeature.gisMetry.gisExtent=parseExtent(graphic.geometry.extent);
			}
			else
			{
				gisFeature.gisMetry=parseMetry(graphic.geometry);
				gisFeature.gisMetry.gisExtent=parseExtent(graphic.geometry.extent);
			}
//			log.debug("[parseGraphic]gisLayer:"+gisLayer+",gisFeature:"+gisFeature);
			return gisFeature;
		}

		/**
		 * 转换底层点、线、面对象为上层点线面对象
		 * @param feature
		 * @return
		 *
		 */
		private function parseMetry(geometry:Geometry):GisMetry
		{
			var parts:Array=null;
			var gisMetry:GisMetry=null;
			var key:*;
			if (geometry is MapPoint)
			{
				var mapPoint:MapPoint=geometry as MapPoint;
				gisMetry=new GisPoint(mapPoint.x, mapPoint.y);
			}
			else if (geometry is Polyline)
			{
				var geoLine:Polyline=geometry as Polyline;
				gisMetry=new GisLine();
				parts=new Array();
				for (key in Polyline(geometry).paths)
				{
					Polyline(geometry).paths[key].forEach(function cb(item:*, index:int, array:Array):void
						{
							parts.push(new GisPoint(MapPoint(item).x, MapPoint(item).y));
						});
				}
				GisLine(gisMetry).parts=parts;
			}
			else if (geometry is Polygon)
			{
				var geoRegion:Polygon=geometry as Polygon;
				gisMetry=new GisRegion();
				parts=new Array();
				for (key in Polygon(geometry).rings)
				{
					Polygon(geometry).rings[key].forEach(function cb(item:*, index:int, array:Array):void
						{
							parts.push(new GisPoint(MapPoint(item).x, MapPoint(item).y));
						});
				}
				GisRegion(gisMetry).parts=parts;
			}
			else if (geometry is Extent)
			{
				var extent:Extent=geometry as Extent;
				log.debug("extent.width:{0},height:{1}", extent.width, extent.height);
				gisMetry=new GisExtent(extent.type, extent.width, extent.height, extent.xmin, extent.xmax, extent.ymin, extent.ymax, new GisPoint(extent.center.x, extent.center.y));
//				gisMetry=new GisRegion();
//				parts=new Array();
//				parts.push(new GisPoint(extent.xmin, extent.ymin));
//				parts.push(new GisPoint(extent.xmax, extent.ymin));
//				parts.push(new GisPoint(extent.xmax, extent.ymax));
//				parts.push(new GisPoint(extent.xmin, extent.ymax));
//				parts.push(new GisPoint(extent.xmin, extent.ymin));
//				GisRegion(gisMetry).parts=parts;

//				var startPoint:Point = this._map.toScreen(new MapPoint(extent.xmin,extent.ymin));
//				var endPoint:Point = this._map.toScreen(new MapPoint(extent.xmax,extent.ymax));
//				var _w:Number = Math.abs(startPoint.x-endPoint.x)*this._metersPerPixel;
//				var _h:Number = Math.abs(startPoint.y-endPoint.y)*this._metersPerPixel;
//				log.warn("width:{0},height:{1}",extent.width/1e-007,extent.height/1e-007);
//				log.warn("width:{0},height:{1}",_w,_h);
			}
//			log.warn(geometry);
			return gisMetry;
		}

		private function parseStyle(style:Symbol):GisStyle
		{
			var gisStyle:GisStyle=null;
			var borderStyle:GisLinePredefinedStyle=null;
			if (style is SimpleMarkerSymbol) //点样式
			{
				var markerPredefinedStyle:SimpleMarkerSymbol=style as SimpleMarkerSymbol;
				gisStyle=new GisMarkerPredefinedStyle(markerPredefinedStyle.style, markerPredefinedStyle.size, markerPredefinedStyle.color, markerPredefinedStyle.alpha, markerPredefinedStyle.xoffset, markerPredefinedStyle.yoffset, markerPredefinedStyle.angle, null);
			}
			else if (style is PictureMarkerSymbol) //图片点样式
			{
				var markerPictureStyle:PictureMarkerSymbol=style as PictureMarkerSymbol;
				gisStyle=new GisMarkerPictureStyle(markerPictureStyle.source, markerPictureStyle.width, markerPictureStyle.height, markerPictureStyle.xoffset, markerPictureStyle.yoffset, markerPictureStyle.angle);
			}
			else if (style is SimpleLineSymbol) //线样式
			{
				var linePredefinedStyle:SimpleLineSymbol=style as SimpleLineSymbol;
				gisStyle=new GisLinePredefinedStyle(linePredefinedStyle.style, linePredefinedStyle.color, linePredefinedStyle.alpha, linePredefinedStyle.width);
			}
			else if (style is SimpleFillSymbol) //线填充样式
			{
				var fillPredefinedStyle:SimpleFillSymbol=style as SimpleFillSymbol;
				if (fillPredefinedStyle.outline != null)
				{
					borderStyle=new GisLinePredefinedStyle(fillPredefinedStyle.outline.style, fillPredefinedStyle.outline.color, fillPredefinedStyle.outline.alpha, fillPredefinedStyle.outline.width);
				}
				gisStyle=new GisFillPredefinedStyle(fillPredefinedStyle.style, fillPredefinedStyle.color, fillPredefinedStyle.alpha, borderStyle);

			}
			else if (style is PictureFillSymbol) //图片填充样式
			{
				var fillPictureStyle:PictureFillSymbol=style as PictureFillSymbol;
				if (fillPictureStyle.outline != null)
				{
					borderStyle=new GisLinePredefinedStyle(fillPictureStyle.outline.style, fillPictureStyle.outline.color, fillPictureStyle.outline.alpha, fillPictureStyle.outline.width);
				}
				gisStyle=new GisFillPictureStyle(fillPictureStyle.source, fillPictureStyle.width, fillPictureStyle.height, fillPictureStyle.xscale, fillPictureStyle.yscale, fillPictureStyle.xoffset, fillPictureStyle.yoffset, 1, fillPictureStyle.angle, borderStyle);
			}
			else if (style is TextSymbol) //文字样式
			{
				var textStyle:TextSymbol=style as TextSymbol;
				gisStyle=new GisTextStyle(textStyle.text, textStyle.color, textStyle.border, textStyle.borderColor, textStyle.background, textStyle.backgroundColor, textStyle.angle, textStyle.placement, textStyle.xoffset, textStyle.yoffset, textStyle.htmlText, textStyle.textFormat, textStyle.textAttribute, textStyle.textFunction);
			}
			return gisStyle;
		}

		/**
		 * 转换底层区域对象成上层区域对象
		 * @param extent
		 * @return
		 *
		 */
		private function parseExtent(extent:Extent):GisExtent
		{
			if (!extent)
			{
				return null;
			}
			var gisExtent:GisExtent=new GisExtent(extent.type, extent.width, extent.height, extent.xmin, extent.xmax, extent.ymin, extent.ymax, new GisPoint(extent.center.x, extent.center.y));
			return gisExtent;
		}

		/**
		 * 根据图层ID获取图层对象
		 * @param layerId
		 * @return
		 *
		 */
		private function getLayer(layerId:String):Layer
		{
			if (_map.getLayer(layerId) != null)
			{
				return _map.getLayer(layerId) as Layer;
			}
			return null;
		}

		/**
		 * 根据SQL从GIS服务查询地图对象
		 * @param sqlWhere
		 * @param outFields
		 * @param success
		 * @param failur
		 *
		 */
		private function queryFeaturesBySqlWhere(sqlWhere:String, outFields:Array, url:String, success:Function, failur:Function=null):void
		{
			var queryTask:QueryTask=new QueryTask();
			queryTask.showBusyCursor=true;
			queryTask.url=url;
			queryTask.useAMF=false;
			var query:Query=new Query();
			query.outFields=outFields;
			query.outSpatialReference=spatialReference;
			query.returnGeometry=true;
			query.where=sqlWhere;
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
			function onResult(featureSet:FeatureSet, token:Object=null):void
			{
				success.call(null, featureSet);
			}
			function onFault(info:Object, token:Object=null):void
			{
				if (failur != null)
				{
					failur.call(null);
				}
				log.error("Query Problem:" + info.toString());
			}
		}


		private function registerMouseEvent(graphic:Graphic):void
		{
			graphic.addEventListener(MouseEvent.CLICK, onGraphicClickHandler);
			graphic.addEventListener(MouseEvent.MOUSE_OVER, onGraphicOverHandler);
			graphic.addEventListener(MouseEvent.MOUSE_OUT, onGraphicOutHandler);
		}

		/**
		 * 平移
		 *
		 */
		override public function panMap():void
		{
			drawTool.deactivate();
			_navTool.activate(NavigationTool.PAN);
		}

		/**
		 * 测距
		 *
		 */
		override public function ruleMap():void
		{
			ruleable=true;
			drawLine();
		}

		/**
		 * 缩小
		 *
		 */
		override public function zoomInMap():void
		{
			_navTool.activate(NavigationTool.ZOOM_IN);
		}

		/**
		 * 放大
		 *
		 */
		override public function zoomOutMap():void
		{
			_navTool.activate(NavigationTool.ZOOM_OUT);
		}

		/**
		 * 全显
		 *
		 */
		override public function viewEntireMap():void
		{
			_map.zoomToInitialExtent();
		}

		/**
		 * 打印
		 *
		 */
		override public function printMap():void
		{
			var job:FlexPrintJob=new FlexPrintJob();
			if (job.start())
			{
				job.addObject(_map, FlexPrintJobScaleType.NONE);
				job.send();
			}
		}

		/**
		 * 导出
		 *
		 */
		override public function exportMap():void
		{
			var fr:Object=new FileReference();
			if (fr.hasOwnProperty("save"))
			{
				var bitmapData:BitmapData=exportAsBitmapData();
				var encoder:PNGEncoder=new PNGEncoder();
				var data:ByteArray=encoder.encode(bitmapData);
				fr.save(data, "map.png");
			}
			else
			{
				Alert.show("install Flash Player 10 to run this feature", "Not Supported");
			}
		}

		/**
		 * 定位
		 * @param point
		 *
		 */
		override public function panTo(point:GisPoint):void
		{
			_map.centerAt(new MapPoint(point.x, point.y));
		}

		/**
		 * 设置比例尺
		 * @param value
		 *
		 */
		override public function set scale(value:Number):void
		{
			_map.scale=value;
		}

		/**
		 * 获取比例尺
		 * @return
		 *
		 */
		override public function get scale():Number
		{
			return _map.scale;
		}

		/**
		 * 设置比例尺级别
		 * @param value
		 *
		 */
		override public function set level(value:Number):void
		{
			_map.level=value;
		}

		/**
		 * 获取比例尺级别
		 * @return
		 *
		 */
		override public function get level():Number
		{
			return _map.level;
		}

		/**
		 * 缩放比例尺且定位到指定点
		 * @param scale
		 * @param point
		 *
		 */
		override public function zoomToScale(scale:Number, point:GisPoint):void
		{
			panTo(point);
			_map.scale=scale;
		}

		/**
		 * 地图框选
		 *
		 */
		override public function selectMap():void
		{
			_navTool.deactivate();
			drawRectangle();
		}

		/**
		 * 将地图可视区域生成位图数据
		 * @return
		 *
		 */
		override public function exportAsBitmapData():BitmapData
		{
			var bmpData:BitmapData=new BitmapData(_map.width, _map.height, true, 0x00ffffff);
			var bounds:Object=_map.getBounds(_map);
			var matrix:Matrix=_map.transform.matrix.clone();
			bmpData.draw(_map, matrix);
			return bmpData;
		}

		/**
		 * 刷新地图有效可视区域
		 *
		 */
		override public function viewRefresh():void
		{
			minLeft=0;
			maxTop=0;
			minBottom=0;
			maxRight=0;
			for each (var layer:ILayer in layers)
			{
				for each (var feature:GisFeature in layer.gisFeatures)
				{
					if (!feature.visible)
					{
						continue;
					}
					if (minLeft == 0)
					{
						minLeft=feature.gisMetry.gisExtent.xmin;
					}
					if (maxTop == 0)
					{
						maxTop=feature.gisMetry.gisExtent.ymax;
					}
					if (minBottom == 0)
					{
						minBottom=feature.gisMetry.gisExtent.ymin;
					}
					if (maxRight == 0)
					{
						maxRight=feature.gisMetry.gisExtent.xmax;
					}

					if (minLeft > feature.gisMetry.gisExtent.xmin)
					{
						minLeft=feature.gisMetry.gisExtent.xmin;
					}
					if (maxTop < feature.gisMetry.gisExtent.ymax)
					{
						maxTop=feature.gisMetry.gisExtent.ymax;
					}
					if (minBottom > feature.gisMetry.gisExtent.ymin)
					{
						minBottom=feature.gisMetry.gisExtent.ymin;
					}
					if (maxRight < feature.gisMetry.gisExtent.xmax)
					{
						maxRight=feature.gisMetry.gisExtent.xmax;
					}
				}
			}
			log.debug("[viewRefresh]minLeft:" + minLeft + ",minBottom:" + minBottom + ",maxRight:" + maxRight + ",maxTop:" + maxTop);
			if (minLeft != 0 && minBottom != 0 && maxRight != 0 && maxTop != 0)
			{
				_map.extent=new Extent(minLeft, minBottom, maxRight, maxTop);
//					minLeft=minBottom=maxRight=maxTop=0;
			}
			resetMetersPerPixel();
			log.debug("[viewRefresh]{0},{1}", _map.scale, this.metersPerPixel);
		}

		/**
		 * 根据地图对象ID从GIS服务查询单个地图对象
		 * @param areaId
		 * @param success
		 * @param failur
		 *
		 */
		override public function queryGisFeatureByAreaId(areaId:String, success:Function, failur:Function=null):void
		{
			var outFields:Array=String(mapConfig.outFields).split(",");
			var sqlwhere:String=" " + outFields[0] + " = " + areaId;
			queryFeaturesBySqlWhere(sqlwhere, outFields, mapConfig.queryUrl, function(featureSet:FeatureSet):void
				{
					var features:Array=featureSet.features;
					if (features.length > 0)
					{
						var feature:Graphic=features[0] as Graphic;
						var gis_id:String=parseGisID(feature.attributes, outFields[0]);
						feature.id="featureOf" + gis_id;
						var gisFeature:GisFeature=parseGraphic(feature);
						gisFeature.attributes.gis_id=gis_id;
						queryGisCache[gis_id]=feature;
						success.call(null, gisFeature);
					}
				});

		}

		/**
		 * 根据地图对象ID数组从GIS服务查询地图对象集合
		 * @param areaIds
		 * @param success
		 * @param failur
		 *
		 */
		override public function queryGisFeaturesByAreaIds(areaIds:Array, success:Function, failur:Function=null):void
		{
			var outFields:Array=String(mapConfig.outFields).split(",");
			var sqlwhere:String=" " + outFields[0] + " in (" + areaIds.join(",") + ")";
			queryFeaturesBySqlWhere(sqlwhere, outFields, mapConfig.queryUrl, function(featureSet:FeatureSet):void
				{
					var features:Array=featureSet.features;
					if (features.length > 0)
					{
						var gisFeatures:Array=new Array();
						for each (var feature:Graphic in features)
						{
							var gis_id:String=parseGisID(feature.attributes, outFields[0]);
							feature.id="featureOf" + gis_id;
							var gisFeature:GisFeature=parseGraphic(feature);
							gisFeature.attributes.gis_id=gis_id;
							queryGisCache[gis_id]=feature;
							gisFeatures.push(gisFeature);
						}
						success.call(null, gisFeatures);
					}
				});

		}

		override public function queryGisFeaturesBySqlWhereForFields(sqlWhere:String, outFields:Array, success:Function, failur:Function=null):void
		{
			queryFeaturesBySqlWhere(sqlWhere, outFields, mapConfig.queryUrl, function(featureSet:FeatureSet):void
				{
					var features:Array=featureSet.features;
					if (features.length > 0)
					{
						var gisFeatures:Array=new Array();
						for each (var feature:Graphic in features)
						{
							var gis_id:String=parseGisID(feature.attributes, outFields[0]);
							feature.id="featureOf" + gis_id;
							var gisFeature:GisFeature=parseGraphic(feature);
							gisFeature.attributes.gis_id=gis_id;
							queryGisCache[gis_id]=feature;
							gisFeatures.push(gisFeature);
						}
						success.call(null, gisFeatures);
					}
				});
		}

		/**
		 * 根据SQL条件从GIS服务查询地图对象
		 * @param sqlWhere
		 * @param success
		 * @param failur
		 *
		 */
		override public function queryGisFeaturesBySqlWhere(sqlWhere:String, success:Function, failur:Function=null):void
		{
			var outFields:Array=String(mapConfig.outFields).split(",");
			queryFeaturesBySqlWhere(sqlWhere, outFields, mapConfig.queryUrl, function(featureSet:FeatureSet):void
				{
					var features:Array=featureSet.features;
					if (features.length > 0)
					{
						var gisFeatures:Array=new Array();
						for each (var feature:Graphic in features)
						{
							var gis_id:String=parseGisID(feature.attributes, outFields[0]);
							feature.id="featureOf" + gis_id;
							var gisFeature:GisFeature=parseGraphic(feature);
							gisFeature.attributes.gis_id=gis_id;
							queryGisCache[gis_id]=feature;
							gisFeatures.push(gisFeature);
						}
						success.call(null, gisFeatures);
					}
				});
		}


		private function doQueryBtsBySqlArray(sqls:Array, gisFeatures:Array, success:Function, failur:Function=null):void
		{
			log.warn("[doQueryBtsBySqlArray]sqls.length:{0}", sqls.length);
			if (sqls.length > 0)
			{
				var outFields:Array=String(mapConfig.outBTSFields).split(",");
				queryFeaturesBySqlWhere(String(sqls.shift()), outFields, mapConfig.queryBTSUrl, function(featureSet:FeatureSet):void
					{
						var features:Array=featureSet.features;
						if (features.length > 0)
						{
							for each (var feature:Graphic in features)
							{
								var gis_id:String=parseGisID(feature.attributes, outFields[0]);
								feature.id="featureOfBTS" + gis_id;
								var gisFeature:GisFeature=parseGraphic(feature);
								gisFeature.attributes.gis_id=gis_id;
								queryGisCache[gis_id]=feature;
								gisFeatures.push(gisFeature);
							}
								//					success.call(null,gisFeatures);
						}
						if (sqls.length > 0)
						{
							doQueryBtsBySqlArray(sqls, gisFeatures, success, failur);
						}
						else
						{
							success.call(null, gisFeatures);
						}

					}, failur);
			}

		}

		/**
		 * 根据地图对象ID数组从GIS服务查询BTS泰森多边形对象集合
		 * @param areaIds
		 * @param success
		 * @param failur
		 *
		 */
		override public function queryBTSGisFeaturesByAreaIds(areaIds:Array, success:Function, failur:Function=null):void
		{
			var pageSize:Number=200;
			var maxPage:Number=1;
			if (areaIds.length % pageSize == 0)
			{
				maxPage=areaIds.length / pageSize;
			}
			else
			{
				maxPage=Number(areaIds.length / pageSize) + 1;
			}
			var sqls:Array=new Array();
			var sql:String;
			var startNo:Number;
			var endNo:Number;
			var pageAreas:Array;
			for (var i:Number=1; i <= maxPage; i++)
			{
				startNo=(i - 1) * pageSize;
				endNo=startNo + pageSize;
				if (endNo > areaIds.length)
				{
					endNo=areaIds.length;
				}
				pageAreas=areaIds.slice(startNo, endNo);
				var outFields:Array=String(mapConfig.outBTSFields).split(",");
				sql=" " + outFields[0] + " in (" + pageAreas.join(",") + ")";
				log.warn("[queryBTSGisFeaturesByAreaIds]areaIds.length:{0},startNo:{1},endNo:{2},sql:{3}", areaIds.length, startNo, endNo, sql);
				sqls.push(sql);
			}
			var gisFeatures:Array=new Array();
			doQueryBtsBySqlArray(sqls, gisFeatures, success, failur);

		}

		private function doQueryNodeBBySqlArray(sqls:Array, gisFeatures:Array, success:Function, failur:Function=null):void
		{
			log.warn("[doQueryNodeBBySqlArray]sqls.length:{0}", sqls.length);
			if (sqls.length > 0)
			{
				var outFields:Array=String(mapConfig.outNodeBFields).split(",");
				queryFeaturesBySqlWhere(String(sqls.shift()), outFields, mapConfig.queryNodeBUrl, function(featureSet:FeatureSet):void
					{
						var features:Array=featureSet.features;
						if (features.length > 0)
						{
							for each (var feature:Graphic in features)
							{
								var gis_id:String=parseGisID(feature.attributes, outFields[0]);
								feature.id="featureOfNodeB" + gis_id;
								var gisFeature:GisFeature=parseGraphic(feature);
								gisFeature.attributes.gis_id=gis_id;
								queryGisCache[gis_id]=feature;
								gisFeatures.push(gisFeature);
							}
								//					success.call(null,gisFeatures);
						}
						if (sqls.length > 0)
						{
							doQueryNodeBBySqlArray(sqls, gisFeatures, success, failur);
						}
						else
						{
							success.call(null, gisFeatures);
						}
					}, failur);
			}
		}

		/**
		 * 根据地图对象ID数组从GIS服务查询NodeB泰森多边形对象集合
		 * @param areaIds
		 * @param success
		 * @param failur
		 *
		 */
		override public function queryNodeBGisFeaturesByAreaIds(areaIds:Array, success:Function, failur:Function=null):void
		{
			var pageSize:Number=200;
			var maxPage:Number=1;
			if (areaIds.length % pageSize == 0)
			{
				maxPage=areaIds.length / pageSize;
			}
			else
			{
				maxPage=Number(areaIds.length / pageSize) + 1;
			}
			var sqls:Array=new Array();
			var sql:String;
			var startNo:Number;
			var endNo:Number;
			var pageAreas:Array;
			for (var i:Number=1; i <= maxPage; i++)
			{
				startNo=(i - 1) * pageSize;
				endNo=startNo + pageSize;
				if (endNo > areaIds.length)
				{
					endNo=areaIds.length;
				}
				pageAreas=areaIds.slice(startNo, endNo);
				var outFields:Array=String(mapConfig.outNodeBFields).split(",");
				sql=" " + outFields[0] + " in (" + pageAreas.join(",") + ")";
				log.warn("[queryNodeBGisFeaturesByAreaIds]areaIds.length:{0},startNo:{1},endNo:{2},sql:{3}", areaIds.length, startNo, endNo, sql);
				sqls.push(sql);
			}
			var gisFeatures:Array=new Array();
			doQueryNodeBBySqlArray(sqls, gisFeatures, success, failur);
		}

		/**
		 * 根据SQL条件从GIS服务查询NodeB泰森多边形对象集合
		 * @param sqlWhere
		 * @param success
		 * @param failur
		 *
		 */
		override public function queryNodeBGisFeaturesBySqlWhere(sqlWhere:String, success:Function, failur:Function=null):void
		{
			var outFields:Array=String(mapConfig.outNodeBFields).split(",");
			queryFeaturesBySqlWhere(sqlWhere, outFields, mapConfig.queryNodeBUrl, function(featureSet:FeatureSet):void
				{
					var features:Array=featureSet.features;
					if (features.length > 0)
					{
						var gisFeatures:Array=new Array();
						for each (var feature:Graphic in features)
						{
							var gis_id:String=parseGisID(feature.attributes, outFields[0]);
							feature.id="featureOfNodeB" + gis_id;
							var gisFeature:GisFeature=parseGraphic(feature);
							gisFeature.attributes.gis_id=gis_id;
							queryGisCache[gis_id]=feature;
							gisFeatures.push(gisFeature);
						}
						success.call(null, gisFeatures);
					}
				});
		}

		/**
		 * 地图切换
		 * @param value
		 *
		 */
		override public function mapChange(value:String):void
		{
			mapConfig=config.getMapConfig(value);
			if (!mapConfig)
			{
				Alert.show("Map not Config of " + value, "ERROR");
				return;
			}
			try
			{
//				clearAll();
				clear();
			}
			catch (e:Error)
			{
				log.error("清空默认图层错误:{0}", e);
			}
			log.debug("[mapChange]serviceLayer:{0}", serviceGisLayer.id);
			var _serviceLayer:ArcGISTiledMapServiceLayer=getLayer(serviceGisLayer.id) as ArcGISTiledMapServiceLayer;
			if (_serviceLayer.url == mapConfig.mapUrl)
			{
				control.dispatchMapEvent(new MapEvent(MapEvent.MAP_CREATION_COMPLETE));
				return;
			}
			_serviceLayer.url=mapConfig.mapUrl;
		}

		/**
		 * 更新某地层对象样式
		 * @param layerId
		 * @param gisFeature
		 *
		 */
		override public function updateFeatureByLayerId(layerId:String, gisFeature:GisFeature):void
		{
			if (!gisFeature)
			{
				return;
			}
			var layer:GraphicsLayer=GraphicsLayer(getLayer(layerId));
			if (layer)
			{
				log.debug("[updateFeatureByLayerId]layerId:{0},gisFeature:{1}", layerId, gisFeature);
				var graphic:Graphic=Graphic((layer.graphicProvider as ArrayCollection).getItemAt(getGisLayer(layerId).gisFeatures.getItemIndex(gisFeature)));
				if (graphic)
				{
					graphic.geometry=parseGisMetry(gisFeature.gisMetry);
					graphic.symbol=parseGisStyle(gisFeature.gisStyle);
					graphic.filters=gisFeature.filters;
					graphic.visible=gisFeature.visible;
					graphic.toolTip=gisFeature.toolTip;
					graphic.autoMoveToTop=gisFeature.autoMoveToTop;
					graphic.alpha=gisFeature.alpha;
					graphic.buttonMode=gisFeature.buttonMode;
				}
			}
		}

		/**
		 * 画直线
		 *
		 */
		override public function drawLine():void
		{
			drawTool.activate(DrawTool.POLYLINE);
		}

		/**
		 * 画自由曲线
		 *
		 */
		override public function drawFreePolygon():void
		{
			drawTool.activate(DrawTool.POLYGON);
			control.dispatchMapEvent(new GisDrawEvent(GisDrawEvent.DRAW_CLICK));
		}

		/**
		 * 画矩形
		 *
		 */
		override public function drawRectangle():void
		{
			drawTool.activate(DrawTool.EXTENT);
			control.dispatchMapEvent(new GisDrawEvent(GisDrawEvent.DRAW_CLICK));
		}

		/**
		 * 画圆
		 *
		 */
		override public function drawCircle():void
		{
			drawTool.activate(DrawTool.CIRCLE);
			control.dispatchMapEvent(new GisDrawEvent(GisDrawEvent.DRAW_CLICK));
		}

		/**
		 * 画多边形
		 *
		 */
		override public function drawPolygon():void
		{
			drawTool.activate(DrawTool.POLYGON);
			control.dispatchMapEvent(new GisDrawEvent(GisDrawEvent.DRAW_CLICK));
		}

		/**
		 * 画正多边形
		 *
		 */
		override public function drawRegulPolyon():void
		{
			drawTool.activate(ArcGisDrawTool.REGULPOLYGON);
			control.dispatchMapEvent(new GisDrawEvent(GisDrawEvent.DRAW_CLICK));
		}

		/**
		 * 地图框选的后退
		 *
		 */
		override public function drawBack():void
		{
			if (step > 0)
			{
				step--;
				drawToolGisLayer.removeGisFeature(drawHis[step]);
				var drawEvent:GisDrawEvent=new GisDrawEvent(GisDrawEvent.DRAW_Back);
				drawEvent.gisFeature=drawHis[step];
				control.dispatchMapEvent(drawEvent);
			}
		}

		/**
		 * 地图框选的前进
		 *
		 */
		override public function drawForward():void
		{
			if (step < drawHis.length)
			{
				drawToolGisLayer.addGisFeature(drawHis[step]);
				var drawEvent:GisDrawEvent=new GisDrawEvent(GisDrawEvent.DRAW_Forward);
				drawEvent.gisFeature=drawHis[step];
				control.dispatchMapEvent(drawEvent);
				step++;
			}
		}

		private function onFeatureLayerGraphicAdd(event:GraphicEvent):void
		{
			log.debug("[onGraphicAdd]" + event.graphic + ",layerId:" + event.graphic.graphicsLayer.id);
			var layer:GisFeatureLayer=getGisLayer(event.graphic.graphicsLayer.id) as GisFeatureLayer;
			var gisFeature:GisFeature=parseGraphic(event.graphic);
			gisFeature.contentMenus=layer.featureContextMenus;
			gisFeature.onClick=layer.featureOnClick;
			gisFeature.onMouseOver=layer.featureOnMouseOver;
			gisFeature.onMouseOut=layer.featureOnMouseOut;
			layer.gisFeatures[event.graphic.id]=gisFeature;
			registerMouseEvent(event.graphic);
		}

		private function onFeatureLayerQueryComplete(event:FeatureLayerEvent):void
		{
			log.debug("[onFeatureLayerQueryComplete]layerID:{0},features:{1}", event.featureLayer.id, event.featureSet.features.length);
			var features:Array=event.featureSet.features;
			var gisLayer:GisFeatureLayer=getGisLayer(event.featureLayer.id) as GisFeatureLayer;
			var graphics:Array = new Array();
			var gisFeature:GisFeature;

			for each (var feature:Graphic in features)
			{
				log.debug("queryFeatures.feature:{0},gisLayer:{1}", feature, gisLayer);
				feature.symbol=parseGisStyle(gisLayer.gisStyle);
				feature.id=feature.toString();
//				graphics.push(feature);
				gisFeature=parseGraphic(feature);
				gisFeature.contentMenus=gisLayer.featureContextMenus;
				gisFeature.onClick=gisLayer.featureOnClick;
				gisFeature.onMouseOver=gisLayer.featureOnMouseOver;
				gisFeature.onMouseOut=gisLayer.featureOnMouseOut;
//				gisLayer.gisFeatures[feature.toString()]=gisFeature;
				registerMouseEvent(feature);
				gisLayer.addGisFeature(gisFeature);
//				event.featureLayer.add(feature);
//				GisFeature(gisLayer.gisFeatures[feature.id]).index=(event.featureLayer.graphicProvider as ArrayCollection).getItemIndex(feature);
			}
//			var gisFeatureLayerEvent:GisFeatureLayerEvent = new GisFeatureLayerEvent(GisFeatureLayerEvent.QUERY_FEATURES_COMPLETE);
//			for each (var feature:Graphic in features){
//				gisFeatureLayerEvent.gisFeatures.addItem(parseGraphic(feature));
//			}
//			gisLayer.query.dispatchEvent(gisFeatureLayerEvent);
//			gisLayer.dispatchEvent(gisFeatureLayerEvent);
		}

		private function onLayerUpDateEnd(event:LayerEvent):void
		{
			log.debug("[onLayerUpDateEnd]layerID:{0},numGraphics:{1}", event.layer.id, FeatureLayer(event.layer).numGraphics);
		}

		/**
		 * 在某图层增加对象
		 * @param layerId
		 * @param gisFeature
		 * @param index
		 * @return
		 *
		 */
		override public function addGisFeatureByLayerIdAt(layerId:String, gisFeature:GisFeature, index:int):String
		{
			var layer:GraphicsLayer=GraphicsLayer(getLayer(layerId));
			if (!layer)
			{
				return null;
			}
			var graphic:Graphic;
			if (gisFeature.contentMenus && gisFeature.contentMenus.length > 0)
			{

			}
			else
			{
				var gisLayer:GisLayer=GisLayer(getGisLayer(layerId));
				if (gisLayer.featureContextMenus && gisLayer.featureContextMenus.length > 0)
				{
					gisFeature.contentMenus=gisLayer.featureContextMenus;
				}
			}
			graphic=parseGisFeature(gisFeature);
			if (gisFeature.id)
			{
				graphic.id=gisFeature.id;
				if (index > 0)
				{
					(layer.graphicProvider as ArrayCollection).addItemAt(graphic, index);
				}
				else
				{
					(layer.graphicProvider as ArrayCollection).addItem(graphic);
				}
			}
			else
			{
				if (index > 0)
				{
					(layer.graphicProvider as ArrayCollection).addItemAt(graphic, index);
				}
				else
				{
					(layer.graphicProvider as ArrayCollection).addItem(graphic);
				}
				gisFeature.id=graphic.id;
			}
			gisFeature.gisLayerId=layerId;
			var extent:Extent=graphic.geometry.extent;
			if (!extent)
			{
				extent=new Extent((graphic.geometry as MapPoint).x, (graphic.geometry as MapPoint).y, (graphic.geometry as MapPoint).x, (graphic.geometry as MapPoint).y);
			}
			gisFeature.gisMetry.gisExtent=parseExtent(extent);
			registerMouseEvent(graphic);
			log.debug("[addGisFeatureByLayerIdAt]{0}", gisFeature);
			return gisFeature.id;
		}

		/**
		 * 删除某图层对象
		 * @param layerId
		 * @param gisFeature
		 *
		 */
		override public function removeGisFeatureByLayerId(layerId:String, gisFeature:GisFeature):void
		{
			gisFeature.gisLayerId=null;
			removeGisFeatureByLayerIdAt(layerId, getGisLayer(layerId).gisFeatures.getItemIndex(gisFeature));
		}

		/**
		 * 删除某图层对象
		 * @param layerId
		 * @param index
		 *
		 */
		override public function removeGisFeatureByLayerIdAt(layerId:String, index:int):void
		{
			var layer:GraphicsLayer=GraphicsLayer(getLayer(layerId));
			if (!layer || index < 0)
			{
				return;
			}
			var graphic:Graphic=Graphic((layer.graphicProvider as ArrayCollection).getItemAt(index));
			if (graphic)
			{
				layer.remove(graphic);
				log.debug("[removeGisFeatureByLayerIdAt]删除成功layerID:" + layerId + ",graphicID:" + graphic.id);
			}
		}

		/**
		 * 清空某图层对象
		 * @param layerId
		 *
		 */
		override public function clearGisFeatureByLayerId(layerId:String):void
		{
			var layer:GraphicsLayer=GraphicsLayer(getLayer(layerId));
			log.debug("[clearGisFeatureByLayerId]layerId:{0},layer:{1}", layerId, layer);
			if (layer)
			{
				layer.clear();
			}
		}


		override public function showZHBTSLayer(value:Boolean=false):void
		{
//			if (!zhBTSExtraWMSLayer)
//			{
//				zhBTSExtraWMSLayer=new ExtraWMSLayer(extraLayerBaseUrl + "/bts/MapServer/export?");
//				_map.addLayer(zhBTSExtraWMSLayer, 1);
//				addGisLayer(zhBTSExtraWMSLayer,1);
//			}
//			zhBTSExtraWMSLayer.visible=value;
			if (!zhBTSExtraWMSLayer)
			{
				zhBTSExtraWMSLayer=new GisWMSLayer(extraLayerBaseUrl + "/bts/MapServer");
			}
			value ? addGisLayer(zhBTSExtraWMSLayer, 1) : removeGisLayer(zhBTSExtraWMSLayer);
		}

		override public function showZHNodeBLayer(value:Boolean=false):void
		{
//			if (!zhNodeBExtraWMSLayer)
//			{
//				zhNodeBExtraWMSLayer=new ExtraWMSLayer(extraLayerBaseUrl + "/nodeb/MapServer/export?");
//				_map.addLayer(zhNodeBExtraWMSLayer, 1);
//			}
//			zhNodeBExtraWMSLayer.visible=value;
			if (!zhNodeBExtraWMSLayer)
			{
				zhNodeBExtraWMSLayer=new GisWMSLayer(extraLayerBaseUrl + "/nodeb/MapServer");
			}
			value ? addGisLayer(zhNodeBExtraWMSLayer, 1) : removeGisLayer(zhNodeBExtraWMSLayer);
		}

		override public function showZHAPLayer(value:Boolean=false):void
		{
//			if (!zhAPExtraWMSLayer)
//			{
//				zhAPExtraWMSLayer=new ExtraWMSLayer(extraLayerBaseUrl + "/ap/MapServer/export?");
//				_map.addLayer(zhAPExtraWMSLayer, 1);
//			}
//			zhAPExtraWMSLayer.visible=value;
			if (!zhAPExtraWMSLayer)
			{
				zhAPExtraWMSLayer=new GisWMSLayer(extraLayerBaseUrl + "/ap/MapServer");
			}
			value ? addGisLayer(zhAPExtraWMSLayer, 1) : removeGisLayer(zhAPExtraWMSLayer);
		}

		override public function showZHCellLayer(value:Boolean=false):void
		{
//			if (!zhCellExtraWMSLayer)
//			{
//				zhCellExtraWMSLayer=new ExtraWMSLayer(extraLayerBaseUrl + "/cell/MapServer/export?");
//				_map.addLayer(zhCellExtraWMSLayer, 1);
//			}
//			zhCellExtraWMSLayer.visible=value;
			if (!zhCellExtraWMSLayer)
			{
				zhCellExtraWMSLayer=new GisWMSLayer(extraLayerBaseUrl + "/cell/MapServer");
			}
			value ? addGisLayer(zhCellExtraWMSLayer, 1) : removeGisLayer(zhCellExtraWMSLayer);
		}

		override public function showZHExcuseLayer(value:Boolean=false):void
		{
//			if (!zhExcuseWMSLayer)
//			{
//				zhExcuseWMSLayer=new ExtraWMSLayer(extraLayerBaseUrl + "/excuse/MapServer/export?");
//				_map.addLayer(zhExcuseWMSLayer, 1);
//			}
//			zhExcuseWMSLayer.visible=value;
			if (!zhExcuseWMSLayer)
			{
				zhExcuseWMSLayer=new GisWMSLayer(extraLayerBaseUrl + "/excuse/MapServer");
			}
			value ? addGisLayer(zhExcuseWMSLayer, 1) : removeGisLayer(zhExcuseWMSLayer);
		}

		override public function showZHGimscustomerLayer(value:Boolean=false):void
		{
//			if (!zhGimscustomerWMSLayer)
//			{
//				zhGimscustomerWMSLayer=new ExtraWMSLayer(extraLayerBaseUrl + "/gimscustomer/MapServer/export?");
//				_map.addLayer(zhGimscustomerWMSLayer, 1);
//			}
//			zhGimscustomerWMSLayer.visible=value;
			if (!zhGimscustomerWMSLayer)
			{
				zhGimscustomerWMSLayer=new GisWMSLayer(extraLayerBaseUrl + "/gimscustomer/MapServer");
			}
			value ? addGisLayer(zhGimscustomerWMSLayer, 1) : removeGisLayer(zhGimscustomerWMSLayer);
		}

		override public function showZHMachineroomLayer(value:Boolean=false):void
		{
//			if (!zhMachineroomWMSLayer)
//			{
//				zhMachineroomWMSLayer=new ExtraWMSLayer(extraLayerBaseUrl + "/machineroom/MapServer/export?");
//				_map.addLayer(zhMachineroomWMSLayer, 1);
//			}
//			zhMachineroomWMSLayer.visible=value;
			if (!zhMachineroomWMSLayer)
			{
				zhMachineroomWMSLayer=new GisWMSLayer(extraLayerBaseUrl + "/machineroom/MapServer");
			}
			value ? addGisLayer(zhMachineroomWMSLayer, 1) : removeGisLayer(zhMachineroomWMSLayer);
		}

		override public function showZHUtrancellLayer(value:Boolean=false):void
		{
//			if (!zhUtrancellExtraWMSLayer)
//			{
//				zhUtrancellExtraWMSLayer=new ExtraWMSLayer(extraLayerBaseUrl + "/utrancell/MapServer/export?");
//				_map.addLayer(zhUtrancellExtraWMSLayer);
//			}
//			zhUtrancellExtraWMSLayer.visible=value;
			if (!zhUtrancellExtraWMSLayer)
			{
				zhUtrancellExtraWMSLayer=new GisWMSLayer(extraLayerBaseUrl + "/utrancell/MapServer");
			}
			value ? addGisLayer(zhUtrancellExtraWMSLayer, 1) : removeGisLayer(zhUtrancellExtraWMSLayer);
		}

		override public function get gisExtent():GisExtent
		{
			if (_map && _map.extent)
			{
				var extent:Extent=_map.extent;
				var gisExtent:GisExtent=new GisExtent(extent.type, extent.width, extent.height, extent.xmin, extent.xmax, extent.ymin, extent.ymax, new GisPoint(extent.center.x, extent.center.y));
				return gisExtent;
			}
			return null;
		}

		override public function set gisExtent(gisExtent:GisExtent):void
		{
			if (gisExtent)
			{
				var extent:Extent=new Extent(gisExtent.xmin, gisExtent.ymin, gisExtent.xmax, gisExtent.ymax);
				_map.extent=extent;

			}
		}

		/**
		 * 地图点与屏幕点转换
		 * @param gisPoint
		 * @return
		 *
		 */
		override public function mapToStage(gisPoint:GisPoint):Point
		{
			return _map.toScreen(new MapPoint(gisPoint.x, gisPoint.y));
		}

		/**
		 * 根据url显示图片图层
		 * @param url
		 *
		 */
		override public function showWMSLayer(url:String):void
		{
			var wmsLayer:ExtraWMSLayer=wmsLayers[url];
			if (!wmsLayer)
			{
				wmsLayer=new ExtraWMSLayer(url + "/export?");
				wmsLayers[url]=wmsLayer;
			}
			_map.addLayer(wmsLayer, 1);
		}

		/**
		 * 根据url隐藏图片图层
		 * @param url
		 */
		override public function hideWMSLayer(url:String):void
		{
			var wmsLayer:ExtraWMSLayer=wmsLayers[url];
			if (wmsLayer)
			{
				_map.removeLayer(wmsLayer);
				super.hideWMSLayer(url);
			}
		}

		override public function get mapUrl():String
		{
			return (getLayer(serviceGisLayer.id) as ArcGISTiledMapServiceLayer).url;
		}

		override public function selectFeaturesByLayerId(layerId:String, selectionMethod:String=GisFeatureLayer.SELECTION_NEW):void
		{

			var layer:Layer=getLayer(layerId);
			log.debug("selectFeaturesByLayerId:{0}", layer);
			if (layer is FeatureLayer)
			{
				log.debug("layer is FeatureLayer:{0}", (layer is FeatureLayer));
				var featureQuery:Query=new Query();
				featureQuery.geometry=parseGisMetry(GisFeatureLayer(getGisLayer(layerId)).query.gisMetry);
				FeatureLayer(layer).selectFeatures(featureQuery, selectionMethod);
			}
			else if (layer is GraphicsLayer)
			{
				log.debug("layer is GraphicsLayer:{0}", (layer is GraphicsLayer));
				var identifyParameters:IdentifyParameters=new IdentifyParameters();
				var gisLayer:GisLayer=getGisLayer(layerId) as GisLayer;
				var queryTask:GisIdentifyTask=gisLayer.queryTask as GisIdentifyTask;
				var queryParameter:GisIdentifyParameters=queryTask.identifyParameters;
				identifyParameters.width=queryParameter.width;
				identifyParameters.height=queryParameter.height;
				identifyParameters.geometry=parseGisMetry(queryParameter.gisMetry);
				identifyParameters.mapExtent=parseGisMetry(queryParameter.mapExtent) as Extent;
//				log.debug("parseGisMetry(queryParameter.mapExtent):{0}",parseGisMetry(queryParameter.mapExtent));
				identifyParameters.returnGeometry=queryParameter.returnGisMetry;
				identifyParameters.tolerance=queryParameter.tolerance;
				identifyParameters.layerIds=queryParameter.layerIds;
				identifyParameters.layerOption=queryParameter.layerOption;
				log.debug("identifyParameters:width={0},height:{1},geometry:{2},mapExtent:{3},tolerance:{4},layerIds:{5},layerOption:{6}", queryParameter.width, queryParameter.height, queryParameter.gisMetry, queryParameter.mapExtent, queryParameter.tolerance, queryParameter.layerIds, queryParameter.layerOption);


				var identifyTask:IdentifyTask=new IdentifyTask();
				identifyTask.showBusyCursor=queryTask.showBusyCursor;
				identifyTask.url=queryTask.url;
				identifyTask.addEventListener(IdentifyEvent.EXECUTE_COMPLETE, function(event:IdentifyEvent):void
					{
						log.debug("IdentifyEvent.EXECUTE_COMPLETE:{0}", event.identifyResults.length);
						gisLayer.clearSelection();
						gisLayer.clear();
						if (event.identifyResults.length > 0)
						{
//							var graphics:Array=new Array();
							var gisFeatures:ArrayCollection=new ArrayCollection();
							var gisFeature:GisFeature;
							var feature:Graphic;
							for each (var identifyResult:IdentifyResult in event.identifyResults)
							{
								feature=identifyResult.feature;
//								log.debug("identifyResult.feature:{0}", feature);
//								feature.symbol=parseGisStyle(gisLayer.gisStyle);
								feature.id=feature.toString();
//								graphics.push(feature);
								gisFeature=parseGraphic(feature);
								gisFeature.gisStyle=gisLayer.gisStyle;
								gisFeature.contentMenus=gisLayer.featureContextMenus;
								gisFeature.onClick=gisLayer.featureOnClick;
								gisFeature.onMouseOver=gisLayer.featureOnMouseOver;
								gisFeature.onMouseOut=gisLayer.featureOnMouseOut;
//								gisLayer.gisFeatures[feature.toString()]=gisFeature;
								gisLayer.addGisFeature(gisFeature);
//								gisFeatures.addItem(gisFeature);
								registerMouseEvent(feature);
							}
//							gisLayer.gisFeatures = gisFeatures;
//							for each (var g:Graphic in graphics)
//							{
//								GisFeature(gisLayer.gisFeatures[g.id]).index=(GraphicsLayer(layer).graphicProvider as ArrayCollection).getItemIndex(g);
//							}
						}

						queryTask.dispatchEvent(new GisIdentifyEvent(GisIdentifyEvent.EXECUTE_COMPLETE, gisLayer.gisFeatures));

					});
				log.debug("identifyTask:{0}", identifyTask);
				identifyTask.execute(identifyParameters);
			}

		}

		override public function getLayerInfosByLayerId(layerId:String):Array
		{
			var layer:Layer=getLayer(layerId);
			log.debug("getLayerInfosByLayerId:{0},{1}", layerId, layer);
			if (layer is ArcGISDynamicMapServiceLayer)
			{
				return ArcGISDynamicMapServiceLayer(layer).layerInfos;
			}
			return null;
		}

		override public function clearSelectionByLayerId(layerId:String):void
		{
			var layer:Layer=getLayer(layerId);
			log.debug("clearSelectionByLayerId:{0},{1}", layerId, layer);
			if (layer is FeatureLayer)
			{
				FeatureLayer(layer).clearSelection();
			}
			else if (layer is GraphicsLayer)
			{
				GraphicsLayer(layer).clear();
			}
		}

		override public function setVisibleLayersByLayerId(layerId:String):void
		{
			var layer:Layer=getLayer(layerId);
			if (layer is ArcGISDynamicMapServiceLayer)
			{
				ArcGISDynamicMapServiceLayer(layer).visibleLayers=GisDynamicServiceLayer(getGisLayer(layerId)).visibleLayers;
			}
		}


		override public function queryFeaturesByLayerId(layerId:String, method:String=GisFeatureLayer.QUERY_NEW):void
		{
			var layer:Layer=getLayer(layerId);
			log.debug("queryFeaturesByLayerId:{0}", layer);
			if (layer is FeatureLayer)
			{
				log.debug("layer is FeatureLayer:{0}", (layer is FeatureLayer));
				
				
//				var featureQuery:Query=new Query();
//				featureQuery.geometry=parseGisMetry(GisFeatureLayer(getGisLayer(layerId)).query.gisMetry);
//				FeatureLayer(layer).selectFeatures(featureQuery,selectionMethod);
//				FeatureLayer(layer).addEventListener(FeatureLayerEvent.QUERY_FEATURES_COMPLETE, onFeatureLayerQueryComplete);
//				FeatureLayer(layer).addEventListener(FeatureLayerEvent.QUERY_FEATURES_COMPLETE,function(event:FeatureLayerEvent):void
//				{
//					log.debug("[onFeatureLayerQueryComplete]layerID:{0},features:{1}", event.featureLayer.id, event.featureSet.features.length);
//					var features:Array=event.featureSet.features;
//					var gisLayer:GisFeatureLayer=getGisLayer(event.featureLayer.id) as GisFeatureLayer;
//					var graphics:Array = new Array();
//					var gisFeature:GisFeature;
//					
//					for each (var feature:Graphic in features)
//					{
//						log.debug("queryFeatures.feature:{0},gisLayer:{1}", feature, gisLayer);
//						feature.symbol=parseGisStyle(gisLayer.gisStyle);
//						feature.id=feature.toString();
//						//				graphics.push(feature);
//						gisFeature=parseGraphic(feature);
//						gisFeature.contentMenus=gisLayer.featureContextMenus;
//						gisFeature.onClick=gisLayer.featureOnClick;
//						gisFeature.onMouseOver=gisLayer.featureOnMouseOver;
//						gisFeature.onMouseOut=gisLayer.featureOnMouseOut;
//						//				gisLayer.gisFeatures[feature.toString()]=gisFeature;
//						registerMouseEvent(feature);
//						gisLayer.addGisFeature(gisFeature);
//						//				event.featureLayer.add(feature);
//						//				GisFeature(gisLayer.gisFeatures[feature.id]).index=(event.featureLayer.graphicProvider as ArrayCollection).getItemIndex(feature);
//					}
//					//			var gisFeatureLayerEvent:GisFeatureLayerEvent = new GisFeatureLayerEvent(GisFeatureLayerEvent.QUERY_FEATURES_COMPLETE);
//					//			for each (var feature:Graphic in features){
//					//				gisFeatureLayerEvent.gisFeatures.addItem(parseGraphic(feature));
//					//			}
//					//			gisLayer.query.dispatchEvent(gisFeatureLayerEvent);
//					//			gisLayer.dispatchEvent(gisFeatureLayerEvent);
//				});
//				FeatureLayer(layer).queryFeatures(featureQuery,new AsyncResponder(onResult, onFault));
//				function onResult(gisFeatures:Array, token:Object=null):void
//				{
//					var features:Array=featureSet.features;
//					var gisLayer:GisFeatureLayer=getGisLayer(layerId) as GisFeatureLayer;
//					var graphics:Array = new Array();
//					var gisFeature:GisFeature;
//					
//					for each (var feature:Graphic in features)
//					{
//						log.debug("queryFeatures.feature:{0},gisLayer:{1}", feature, gisLayer);
//						feature.symbol=parseGisStyle(gisLayer.gisStyle);
//						feature.id=feature.toString();
//						//				graphics.push(feature);
//						gisFeature=parseGraphic(feature);
//						gisFeature.contentMenus=gisLayer.featureContextMenus;
//						gisFeature.onClick=gisLayer.featureOnClick;
//						gisFeature.onMouseOver=gisLayer.featureOnMouseOver;
//						gisFeature.onMouseOut=gisLayer.featureOnMouseOut;
//						//				gisLayer.gisFeatures[feature.toString()]=gisFeature;
//						registerMouseEvent(feature);
//						gisLayer.addGisFeature(gisFeature);
//						//				event.featureLayer.add(feature);
//						//				GisFeature(gisLayer.gisFeatures[feature.id]).index=(event.featureLayer.graphicProvider as ArrayCollection).getItemIndex(feature);
//					}
					
					
//					Alert.show("--->", gisFeatures.length+".");
//				}
//				function onFault(info:Object, token:Object = null):void
//				{
//					Alert.show(info.toString(), "Query Problem");
//				}
			}
		}

		override public function updateLayer(layerId:String):void
		{
			var gisLayer:ILayer=getGisLayer(layerId);
			var layer:Layer=getLayer(layerId);
			layer.visible=gisLayer.visible;
		}

		private function addLayerAt(gisLayer:ILayer, index:int=-1):void
		{
			if (!gisLayer)
			{
				return;
			}
			if (_map && _map.getLayer(gisLayer.id))
			{
				return;
			}
			var layer:Layer;
			if (gisLayer is GisServiceLayer)
			{
				layer=new ArcGISTiledMapServiceLayer();
				ArcGISTiledMapServiceLayer(layer).url=mapConfig.mapUrl;
				ArcGISTiledMapServiceLayer(layer).alpha=mapConfig.serviceLayerAlpha;
				ArcGISTiledMapServiceLayer(layer).addEventListener(LayerEvent.LOAD, onLayerLoad);
			}
			else if (gisLayer is GisLayer)
			{
				layer=new GraphicsLayer();
			}
			else if (gisLayer is GisFeatureLayer)
			{
				layer=new FeatureLayer();
				FeatureLayer(layer).url=GisFeatureLayer(gisLayer).url;
				FeatureLayer(layer).outFields=GisFeatureLayer(gisLayer).outField;
//				FeatureLayer(layer).mode=GisFeatureLayer(gisLayer).mode;
//				FeatureLayer(layer).definitionExpression=GisFeatureLayer(gisLayer).definitionExpression;
				FeatureLayer(layer).symbol=parseGisStyle(GisFeatureLayer(gisLayer).gisStyle);
				FeatureLayer(layer).addEventListener(GraphicEvent.GRAPHIC_ADD, onFeatureLayerGraphicAdd);
				FeatureLayer(layer).addEventListener(LayerEvent.UPDATE_END, onLayerUpDateEnd);
			}
			else if (gisLayer is GisDynamicServiceLayer)
			{
				layer=new ArcGISDynamicMapServiceLayer();
				ArcGISDynamicMapServiceLayer(layer).url=GisDynamicServiceLayer(gisLayer).url;
				ArcGISDynamicMapServiceLayer(layer).visibleLayers=GisDynamicServiceLayer(gisLayer).visibleLayers;
			}
			else if (gisLayer is GisWMSLayer)
			{
				layer=new ExtraWMSLayer(GisWMSLayer(gisLayer).url + "/export?");
			}
			if (gisLayer.id)
			{
				layer.id=gisLayer.id;
				_map.addLayer(layer, index);
			}
			else
			{
				_map.addLayer(layer, index);
				gisLayer.id=layer.id;
			}
			if(gisLayer.alpha){
				layer.alpha = gisLayer.alpha;
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


		override public function execute(task:BaseTask, responder:IResponder=null):AsyncToken
		{
			log.debug("[execute task]{0}", typeof task);
			var arcTask:com.esri.ags.tasks.BaseTask;
			if (!task.url)
			{
				task.url=mapConfig.mapUrl;
			}
			if (task is GisQueryTask)
			{
				arcTask=new QueryTask();
				arcTask.url=task.url;
				arcTask.showBusyCursor=task.showBusyCursor;
				QueryTask(arcTask).useAMF=GisQueryTask(task).useAMF;
				var query:Query=new Query();
				query.objectIds=GisQueryTask(task).query.objectIds;
				query.outFields=GisQueryTask(task).query.outFields;
				query.returnGeometry=GisQueryTask(task).query.returnGeometry;
				query.text=GisQueryTask(task).query.text;
				query.maxAllowableOffset=GisQueryTask(task).query.maxAllowableOffset;
				query.where=GisQueryTask(task).query.where;
				query.relationParam=GisQueryTask(task).query.relationParam;
				return QueryTask(arcTask).execute(query, new AsyncResponder(function onResult(featureSet:FeatureSet, token:Object=null):void
					{
						var features:Array=featureSet.features;
						var gisFeatures:Array=new Array();
						features.forEach(function callback(item:*, index:int, array:Array):void
							{
								var gisFeature:GisFeature=parseGraphic(Graphic(item));
								gisFeatures.push(gisFeature);
							});
						GisQueryTask(task).executeLastResult=gisFeatures;
						if (responder)
						{
							responder.result(gisFeatures);
						}
					}, function onFault(info:Object, token:Object=null):void
					{
						if (responder)
						{
							responder.fault(info);
						}
					}));
			}
			else if (task is GisFindTask)
			{
				arcTask=new FindTask();
				arcTask.url=task.url;
				arcTask.showBusyCursor=task.showBusyCursor;
				var findParameters:FindParameters=new FindParameters();
				findParameters.contains=GisFindTask(task).findParameters.contains;
				findParameters.layerDefinitions=GisFindTask(task).findParameters.layerDefinitions;
				findParameters.layerIds=GisFindTask(task).findParameters.layerIds;
				findParameters.maxAllowableOffset=GisFindTask(task).findParameters.maxAllowableOffset;
				findParameters.returnGeometry=GisFindTask(task).findParameters.returnGeometry;
				findParameters.searchFields=GisFindTask(task).findParameters.searchFields;
				findParameters.searchText=GisFindTask(task).findParameters.searchText;
				findParameters.outSpatialReference=new SpatialReference();
				return FindTask(arcTask).execute(findParameters, new AsyncResponder(function onResult(features:Array, token:Object=null):void
					{
						var gisFeatures:Array=new Array();
						features.forEach(function callback(item:*, index:int, array:Array):void
							{
								var gisFeature:GisFeature=parseGraphic(FindResult(item).feature);
								gisFeatures.push(gisFeature);
							});
						GisFindTask(task).executeLastResult=gisFeatures;
						if (responder)
						{
							responder.result(gisFeatures);
						}
					}, function onFault(info:Object, token:Object=null):void
					{
						if (responder)
						{
							responder.fault(info);
						}
					}));
			}
			return null;
		}

		override public function queryFeaturesByTextLabel(text:String, success:Function=null, layer:int=25, failure:Function=null):void
		{
			var queryTask:GisQueryTask=new GisQueryTask();
			queryTask.showBusyCursor=true;
			queryTask.url=mapConfig.mapUrl + "/" + layer;
			var query:GisQuery=new GisQuery();
			query.text=text;
			query.returnGeometry=true;
			queryTask.query=query;
			execute(queryTask, new AsyncResponder(onResult, onFault));
			function onResult(gisFeatures:Array, token:Object=null):void
			{
				if (success != null && success is Function)
				{
					success.call(null, gisFeatures);
				}
			}
			function onFault(info:Object, token:Object=null):void
			{
				if (failure != null && failure is Function)
				{
					failure.call(null, info.toString());
				}
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
			if (_map)
			{
				for each (var layer:ILayer in event.items)
				{
					log.debug("[layer remove]layer:" + layer);
					if (layer)
					{
						_map.removeLayer(getLayer(layer.id));
					}
				}
			}
		}

		private function onCollectionRefreshAndResetHandler(event:CollectionEvent):void
		{
			log.debug("[layer reset or refresh]");
			if (_map)
			{
				_map.removeAllLayers();
				for each (var layer:ILayer in layers)
				{
					addLayerAt(layer, layers.getItemIndex(layer));
				}
			}
		}

		override public function updateScaleBarDisplay(scaleBar:com.ailk.common.ui.gis.tools.ScaleBar):void
		{
			super.updateScaleBarDisplay(scaleBar);
			_map.scaleBarVisible=true;
		}

		override public function updateZoomSliderDisplay(zoomSlider:ZoomSliderBar):void
		{
			super.updateZoomSliderDisplay(zoomSlider);
			_map.zoomSliderVisible=true;
		}

		override public function updateOverViewToolDisplay(overViewTool:OverViewTool):void
		{
			super.updateOverViewToolDisplay(overViewTool);
			var bc:BorderContainer=new BorderContainer();
			bc.minHeight=0;
			bc.minWidth=0;
			if (overViewTool.top)
			{
				bc.top=overViewTool.top;
			}
			if (overViewTool.right)
			{
				bc.right=overViewTool.right;
			}
			if (overViewTool.bottom)
			{
				bc.bottom=overViewTool.bottom;
			}
			if (overViewTool.left)
			{
				bc.left=overViewTool.left;
			}
			overViewGroup.addElement(bc);
		}

		override protected function onPropertiesChangeHandler(event:PropertiesCompEvent):void
		{
			super.onPropertiesChangeHandler(event);
			var gisFeature:GisFeature=new GisFeature(event.param as GisMetry, drawStyle);
			drawToolGisLayer.addGisFeature(gisFeature);
			drawHis.push(gisFeature);
			step=drawHis.length;
			drawTool.deactivate();
			panTo(gisFeature.gisMetry.gisExtent.center);
			lastEditGraphic=parseGisFeature(gisFeature);
			lastEditGisFeature=gisFeature;
			dispatchDrawEnd(gisFeature);

		}

	}
}