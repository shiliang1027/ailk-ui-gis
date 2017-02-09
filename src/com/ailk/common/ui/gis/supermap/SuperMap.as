package com.ailk.common.ui.gis.supermap
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.Constants;
	import com.ailk.common.ui.gis.core.BaseMap;
	import com.ailk.common.ui.gis.core.GisContextMenuItem;
	import com.ailk.common.ui.gis.core.GisDynamicServiceLayer;
	import com.ailk.common.ui.gis.core.GisFeature;
	import com.ailk.common.ui.gis.core.GisFeatureLayer;
	import com.ailk.common.ui.gis.core.GisLayer;
	import com.ailk.common.ui.gis.core.GisServiceLayer;
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
	import com.ailk.common.ui.gis.core.styles.GisStyle;
	import com.ailk.common.ui.gis.core.styles.GisTextStyle;
	import com.ailk.common.ui.gis.event.GisDrawEvent;
	import com.ailk.common.ui.gis.event.GisExtentEvent;
	import com.ailk.common.ui.gis.event.MapEvent;
	import com.ailk.common.ui.gis.tools.OverViewTool;
	import com.ailk.common.ui.gis.tools.PropertiesCompEvent;
	import com.ailk.common.ui.gis.tools.ScaleBar;
	import com.ailk.common.ui.gis.tools.ZoomSliderBar;
	import com.supermap.web.actions.DrawCircle;
	import com.supermap.web.actions.DrawFreeLine;
	import com.supermap.web.actions.DrawFreePolygon;
	import com.supermap.web.actions.DrawLine;
	import com.supermap.web.actions.DrawPoint;
	import com.supermap.web.actions.DrawPolygon;
	import com.supermap.web.actions.DrawRectangle;
	import com.supermap.web.actions.DrawText;
	import com.supermap.web.actions.Pan;
	import com.supermap.web.actions.ZoomIn;
	import com.supermap.web.actions.ZoomOut;
	import com.supermap.web.components.OverviewMap;
	import com.supermap.web.components.ZoomSlider;
	import com.supermap.web.core.Feature;
	import com.supermap.web.core.Point2D;
	import com.supermap.web.core.Rectangle2D;
	import com.supermap.web.core.geometry.GeoLine;
	import com.supermap.web.core.geometry.GeoPoint;
	import com.supermap.web.core.geometry.GeoRegion;
	import com.supermap.web.core.geometry.Geometry;
	import com.supermap.web.core.styles.PictureFillStyle;
	import com.supermap.web.core.styles.PictureMarkerStyle;
	import com.supermap.web.core.styles.PredefinedFillStyle;
	import com.supermap.web.core.styles.PredefinedLineStyle;
	import com.supermap.web.core.styles.PredefinedMarkerStyle;
	import com.supermap.web.core.styles.Style;
	import com.supermap.web.core.styles.TextStyle;
	import com.supermap.web.events.DrawEvent;
	import com.supermap.web.events.LayerEvent;
	import com.supermap.web.events.MapMouseEvent;
	import com.supermap.web.events.ViewBoundsEvent;
	import com.supermap.web.iServerJava2.ServerFeatureType;
	import com.supermap.web.iServerJava2.queryServices.QueryBySqlParameters;
	import com.supermap.web.iServerJava2.queryServices.QueryBySqlService;
	import com.supermap.web.iServerJava2.queryServices.QueryLayerParam;
	import com.supermap.web.iServerJava2.queryServices.QueryParam;
	import com.supermap.web.iServerJava2.queryServices.RecordSet;
	import com.supermap.web.iServerJava2.queryServices.ResultSet;
	import com.supermap.web.iServerJava2.queryServices.ReturnResultSetInfo;
	import com.supermap.web.iServerJava2.queryServices.SqlParam;
	import com.supermap.web.iServerJava6R.measureServices.MeasureParameters;
	import com.supermap.web.iServerJava6R.measureServices.MeasureResult;
	import com.supermap.web.iServerJava6R.measureServices.MeasureService;
	import com.supermap.web.mapping.FeaturesLayer;
	import com.supermap.web.mapping.Layer;
	import com.supermap.web.mapping.Map;
	import com.supermap.web.mapping.TiledCachedIServerLayer;
	import com.supermap.web.mapping.TiledDynamicIServerLayer;
	import com.supermap.web.mapping.TiledDynamicRESTLayer;
	
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
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.graphics.codec.PNGEncoder;
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;
	import mx.rpc.AsyncResponder;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.VGroup;
	import spark.layouts.HorizontalLayout;

	use namespace gis_internal;

	/**
	 * SuperMap地图适配类
	 * @author shiliang
	 *
	 */
	public class SuperMap extends BaseMap
	{

		private static var log:ILogger=Log.getLoggerByClass(SuperMap);
		/**
		 * SuperMap地图容器
		 */
		private var _map:Map;

//		private var _overviewServerLayer:TiledCachedIServerLayer;
//		private var _overviewServerLayer1:TiledDynamicIServerLayer;
//		private var _overviewServerLayer2:TiledDynamicRESTLayer;
		
		private var overviewMap:OverviewMap=new OverviewMap();
		private var _overviewLayer:Layer;
		private var sqlParam:SqlParam=new SqlParam();

		private var drawPointAction:DrawPoint;
		private var drawLineAction:DrawLine;
		private var drawPolygonAction:DrawPolygon;
		private var drawFreeLineAction:DrawFreeLine;
		private var drawFreePolygonAction:DrawFreePolygon;
		private var drawRectangleAction:DrawRectangle;
		private var drawTextAction:DrawText;
		private var drawCircleAction:DrawCircle;
		private var drawRegulPolyonAction:DrawRegulPolyon;

		private var minRectangle2D:Rectangle2D;

		private var borderStyle:PredefinedLineStyle=new PredefinedLineStyle(PredefinedLineStyle.SYMBOL_SOLID, 0x0ac1e6, 1, 2);
		private var polygonStyle:PredefinedFillStyle=new PredefinedFillStyle(PredefinedFillStyle.SYMBOL_SOLID, 0xe3f8ff, 0.5, borderStyle);

		private var lastEditGraphic:Feature;
		private var lastActiveEditTypes:String;
		private var lastEditGisFeature:GisFeature;

		public function SuperMap(config:IMapConfig, control:IMapControl)
		{
			super(config, control);
			_map=new Map();
			log.debug("[SuperMap]mapConfig:" + mapConfig.name + "," + mapConfig.scales);
			_map.panDuration=0;
			_map.zoomDuration=0;
			_map.scrollWheelZoomEnabled=config.scrollWheelZoomEnabled;
			_map.doubleClickZoomEnabled=config.doubleClickZoomEnabled;
			_map.contextMenu=new ContextMenu();
			_map.contextMenu.hideBuiltInItems();
			_map.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, onMenuSelectHandler);

//			_map.scales=mapConfig.scales;
			log.debug("[SuperMap]_map:" + _map);
//			this.addEventListener(FlexEvent.CREATION_COMPLETE, creation_completeHandler);
//			_map.addEventListener(MouseEvent.CLICK, map_clickHandler);
			_map.addEventListener(MouseEvent.MOUSE_MOVE, map_MoveHandler);

			_map.addEventListener(ViewBoundsEvent.VIEW_BOUNDS_CHANGE, onViewBoundsChange);

			_map.addEventListener(ResizeEvent.RESIZE, this.map_resizeHandler, false, 0, true);
			_map.addEventListener(ViewBoundsEvent.VIEW_BOUNDS_CHANGE, this.map_extentChangeHandler, false, 0, true);
			_map.addEventListener(MapMouseEvent.MAP_CLICK, map_clickHandler);


			drawPointAction=new DrawPoint(_map);
			drawPointAction.addEventListener(DrawEvent.DRAW_END, onDrawEndHandler);

			drawLineAction=new DrawLine(_map);
			drawLineAction.addEventListener(DrawEvent.DRAW_END, onDrawEndHandler);

			drawPolygonAction=new DrawPolygon(_map);
			drawPolygonAction.addEventListener(DrawEvent.DRAW_END, onDrawEndHandler);

			drawFreeLineAction=new DrawFreeLine(_map);
			drawFreeLineAction.addEventListener(DrawEvent.DRAW_END, onDrawEndHandler);

			drawFreePolygonAction=new DrawFreePolygon(_map);
			drawFreePolygonAction.addEventListener(DrawEvent.DRAW_END, onDrawEndHandler);

			drawRectangleAction=new DrawRectangle(_map);
			drawRectangleAction.addEventListener(DrawEvent.DRAW_END, onDrawEndHandler);

			drawTextAction=new DrawText(_map);
			drawTextAction.addEventListener(DrawEvent.DRAW_END, onDrawEndHandler);

			drawCircleAction=new DrawCircle(_map);
			drawCircleAction.addEventListener(DrawEvent.DRAW_END, onDrawEndHandler);

			drawRegulPolyonAction=new DrawRegulPolyon(_map);
			drawRegulPolyonAction.addEventListener(DrawEvent.DRAW_END, onDrawEndHandler);

		}

		private function onDrawEndHandler(event:DrawEvent):void
		{
			var feature:Feature=event.feature;
			log.debug("[addDrawFeature]feature:{0}", GeoRegion(feature.geometry).parts[0].length);
			if (selectedable)
			{
				_map.action=new Pan(_map);
				_map.viewBounds=feature.geometry.bounds;
				selectedable=false;
				control.dispatchMapEvent(new MapEvent(MapEvent.MAP_SELECT_COMPLETE));
				return;
			}
			if (ruleable)
			{
				ruleable=false;
//				var paths:Array=(feature.geometry as GeoLine).parts;
				calculateRadius(feature);
//				try{
//					getGraphicsLayer(drawToolGisLayer.id).removeFeature(feature);
//				}catch(e:Error){}
				return;
			}
			if (GeoRegion(feature.geometry).parts[0].length < 3)
			{
				return;
			}
			try
			{
				feature.autoMoveToTop=false;
				var gisFeature:GisFeature=parseGraphic(feature);
				drawToolGisLayer.addGisFeature(gisFeature);
				if (step != 0 && step < drawHis.length)
				{
					drawHis.splice(step, drawHis.length - step);
				}
				drawHis.push(gisFeature);
				step=drawHis.length;
				_map.action=new Pan(_map);
				dispatchDrawEnd(gisFeature);
			}
			catch (e:Error)
			{
				log.error("======>框选错误:{0}", e)
			}
		}

		private function dispatchDrawEnd(gisFeature:GisFeature):void
		{
			var drawEvent:GisDrawEvent=new GisDrawEvent(GisDrawEvent.DRAW_END);
			drawEvent.gisFeature=gisFeature;
			control.dispatchMapEvent(drawEvent);
		}


		private function calculateRadius(feature:Feature):void
		{
			var measureParam:MeasureParameters=new MeasureParameters(feature.geometry);
			var measureService:MeasureService=new MeasureService(SuperMapConfig(config).webUrl + mapConfig.name);
			measureService.processAsync(measureParam, new AsyncResponder(this.displayMeasureRecords, this.MeasureError, "distance"));

//			if (paths.length >= 2)
//			{
//				var sx:Number=96.49;
//				var sy:Number=110.85;
//				var len:Number=0;
//				for (var i:Number=0; i < paths.length; i++)
//				{
//					if (i < paths.length - 1)
//					{
//						var startPoint:Point2D=paths[i];
//						var endPoint:Point2D=paths[i + 1];
//						var x:Number=startPoint.x - endPoint.x;
//						var y:Number=startPoint.y - endPoint.y;
//						len+=Math.sqrt(x * x * sx * sx + y * y * sy * sy);
//					}
//				}
//				Alert.show("当前距离：" + len.toFixed(2) + "km");
//			}
		}

		private function MeasureError(object:Object, mark:Object=null):void
		{
			Alert.show("量算出错，请检查您的参数设置", "抱歉", 4);
		}

		//显示查询结果
		private function displayMeasureRecords(measureResult:MeasureResult, mark:Object=null):void
		{
			var info:String;
			var temp:Number
			if (mark == "distance")
			{
				temp=Number(measureResult.distance);
				temp/=1000;
				info=temp.toFixed(2);
				info+=" 千米";
			}
			else
			{
				temp=Number(measureResult.area);
				temp/=1000 * 1000;
				info=temp.toFixed(2);
				info+=" 平方千米";
			}
			Alert.show("当前距离：" + info);
		}

		private function onLayerLoad(event:LayerEvent):void
		{
			_map.viewBounds=event.layer.bounds;
			var time:Number=_map.panDuration > _map.zoomDuration ? _map.panDuration : _map.zoomDuration;
			setTimeout(loadEnd, 2000);
		}

		private function loadEnd():void
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

		private function map_extentChangeHandler(event:ViewBoundsEvent):void
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
					log.warn("commitProperties:{0}",this._map.scale);
					resetMetersPerPixel();
				}
			}
			super.commitProperties();
		}

		private const EarthCircumferenceInMeters:Number=4.0075e+007;
		private const HalfEarthCircumferenceInMeters:Number=2.00375e+007;
		private const EarthRadiusInMeters:Number=6.37814e+006;
		private const MercatorLatitudeLimit:Number=85.0511;

		private function resetMetersPerPixel():void
		{
//			log.warn("this._map.viewBounds.center:{0}",this._map.viewBounds.center);
			log.warn("this._map.viewBounds:{0}",this._map.viewBounds);
//			log.warn("this._map.width:{0}",this._map.width);
//			if(this._map.viewBounds){
//				this.metersPerPixel=_map.scale * Math.cos(Math.PI / 180 * Math.min(89.999, Math.abs(this._map.viewBounds.center.y))) / 3779.53;
				this.metersPerPixel=this._map.viewBounds.width / 360 * (Math.PI * 2 * Math.cos(Math.min(89.999, Math.abs(this._map.viewBounds.center.y)) * Math.PI / 180) * this.EarthRadiusInMeters) / this._map.width;
//			}
//			this.metersPerPixel=this._map.viewBounds.width / 360 * (Math.PI * 2 * Math.cos(Math.min(89.999, Math.abs(this._map.viewBounds.center.y)) * Math.PI / 180) * this.EarthRadiusInMeters) / this._map.width;
//			log.warn("[resetMetersPerPixel]scale:{0},_loc_2:{1}",_map.scale,_loc_2);
		}

		override protected function createChildren():void
		{
			log.debug("[createChildren]:{0}", config.cachedable);
			addChild(_map);
			addGisLayer(serviceGisLayer);
			addGisLayer(modelGisLayer);
			addGisLayer(defaultGisLayer);
//			mapChange(config.defaultMapId);
			super.createChildren();
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

		private function onMenuSelectHandler(event:ContextMenuEvent):void
		{
			log.debug("[右键菜单]" + event.target + "," + event.currentTarget + "," + event.contextMenuOwner + "," + event.mouseTarget);
			var target:Object=parseMapTarget(event.mouseTarget);
			ContextMenu(event.target).customItems.splice(0);
			if (target is GisFeature)
			{
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
								log.debug("[右键菜单项选择]menu:" + GisFeature(target).attributes.selectMenuName);
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
			var evt:MapEvent=new MapEvent(MapEvent.MAP_CLICK);
			evt.mapPoint=new GisPoint(event.mapPoint.x, event.mapPoint.y);
			control.dispatchMapEvent(evt);

			lastDrawPoint=new GisPoint(event.mapPoint.x, event.mapPoint.y);
			if (isLastDrawPointSet)
			{
				showPropComp();
				isLastDrawPointSet=false;
			}
		}

		private function parseMapTarget(target:Object):Object
		{
//			log.info("[parseMapTarget]target:"+target);
			if (!target)
			{
				return null;
			}
			else if (target is Map)
			{
				return this;
			}
			else if (target is Feature)
			{
				return parseGraphic(Feature(target));
			}
			else
			{
				return parseMapTarget(target.parent);
			}
		}


		private function onViewBoundsChange(event:ViewBoundsEvent):void
		{
			var gisExtentEvent:GisExtentEvent=new GisExtentEvent(GisExtentEvent.EXTENT_CHANGE);
			gisExtentEvent.levelChange=event.levelChange;
			gisExtentEvent.extent=parseExtent(event.viewBounds);
			control.dispatchMapEvent(gisExtentEvent);
		}

		/**
		 * 转换上层对象成底层地图对象
		 * @param gisFeature
		 *
		 */
		private function parseGisFeature(gisFeature:GisFeature):*
		{
			var style:Style=parseGisStyle(gisFeature.gisStyle);
			var feature:Feature;
			try
			{
				var gis_id:String=String(gisFeature.attributes.gis_id);
//				log.debug("[parseGisFeature]gisFeature:" + gisFeature + ",gis_id:" + gis_id);
				if (gis_id)
				{
					feature=queryGisCache[gis_id];
					feature.style=style;
				}
			}
			catch (e:Error)
			{
			}
			if (!feature)
			{
				feature=new Feature(parseGisMetry(gisFeature.gisMetry), style);
			}
			feature.autoMoveToTop=gisFeature.autoMoveToTop;
			feature.toolTip=gisFeature.toolTip;
			feature.contextMenu=gisFeature.contextMenu;
			feature.alpha=gisFeature.alpha;
			feature.buttonMode=gisFeature.buttonMode;
			feature.filters=gisFeature.filters;
			feature.visible=gisFeature.visible;
//			log.info("[parseGisFeature]feature.id:" + feature.id + ",feature:" + feature);
			return feature;
		}

		/**
		 * 转换上层点、线、面对象成底层地图点、线、面对象
		 * @param gisFeature
		 *
		 */
		private function parseGisMetry(gisMetry:GisMetry):Geometry
		{
			var parts:Array=null;
			var geometry:Geometry=null;
			if (gisMetry is GisPoint) //转换点
			{
				var gisPoint:GisPoint=gisMetry as GisPoint;
				geometry=new GeoPoint(gisPoint.x, gisPoint.y);
			}
			else if (gisMetry is GisLine) //转换线
			{
				var gisLine:GisLine=gisMetry as GisLine;
				geometry=new GeoLine();
				parts=new Array();
				for each (var gisLinePoint:GisPoint in gisLine.parts)
				{
					parts.push(new Point2D(gisLinePoint.x, gisLinePoint.y));
				}
				(geometry as GeoLine).addPart(parts);
			}
			else if (gisMetry is GisRectangle)
			{ //转换矩形
//				var gisRect:GisRectangle=gisMetry as GisRectangle;
//				geometry=new GeoRegion();
//				parts=new Array();
//				if (gisRect.startPoint)
//				{
//					//					var sc:Number = Number(1/_map.scale);
//					var sx:Number=96 * 1000;
//					var sy:Number=110.701 * 1000;
//					var startPoint:Point2D=new Point2D(gisRect.startPoint.x, gisRect.startPoint.y);
//					var endPoint:Point2D=new Point2D(gisRect.startPoint.x + gisRect.width / sx, gisRect.startPoint.y + gisRect.height / sy);
//					parts.push(new Point2D(startPoint.x, startPoint.y));
//					parts.push(new Point2D(endPoint.x, startPoint.y));
//					parts.push(new Point2D(endPoint.x, endPoint.y));
//					parts.push(new Point2D(startPoint.x, endPoint.y));
//					parts.push(new Point2D(startPoint.x, startPoint.y));
//				}
//				(geometry as GeoRegion).addPart(parts);

				var gisRect:GisRectangle=gisMetry as GisRectangle;
				var _w:Number=gisRect.width * 1000 / this.metersPerPixel;
				var _h:Number=gisRect.height * 1000 / this.metersPerPixel;
				var startPoint:Point;
				var endPoint:Point;
				if (gisRect.startPoint)
				{
					startPoint=this._map.mapToScreen(new Point2D(gisRect.startPoint.x, gisRect.startPoint.y));
					endPoint=new Point(startPoint.x + _w, startPoint.y + _h);
				}
				else if (gisRect.centerPoint)
				{
					var center:Point=this._map.mapToScreen(new Point2D(gisRect.centerPoint.x, gisRect.centerPoint.y));
					startPoint=new Point(center.x - _w / 2, center.y - _h / 2);
					endPoint=new Point(center.x + _w / 2, center.y + _h / 2);
					var start:Point2D=this._map.screenToMap(startPoint);
					gisRect.startPoint=new GisPoint(start.x, start.y);
				}
				var end:Point2D=this._map.screenToMap(endPoint);
				geometry=new GeoRegion();
				parts=new Array();
				parts.push(new Point2D(gisRect.startPoint.x, gisRect.startPoint.y));
				parts.push(new Point2D(end.x, gisRect.startPoint.y));
				parts.push(new Point2D(end.x, end.y));
				parts.push(new Point2D(gisRect.startPoint.x, end.y));
				(geometry as GeoRegion).addPart(parts);

				parts=new Array();
				parts.push(new GisPoint(gisRect.startPoint.x, gisRect.startPoint.y));
				parts.push(new GisPoint(end.x, gisRect.startPoint.y));
				parts.push(new GisPoint(end.x, end.y));
				parts.push(new GisPoint(gisRect.startPoint.x, end.y));
				//				parts.push(new GisPoint(gisRect.startPoint.x,gisRect.startPoint.y));
				gisRect.parts=parts;

			}
			else if (gisMetry is GisCircle)
			{
				geometry=new GeoRegion();
				parts=createCirclePoints(gisMetry as GisCircle);
				(geometry as GeoRegion).addPart(parts);
			}
			else if (gisMetry is GisSector)
			{
				geometry=new GeoRegion();
				parts=createSectorPoints(gisMetry as GisSector);
				(geometry as GeoRegion).addPart(parts);
			}
			else if (gisMetry is GisRegion) //转换面
			{
				var gisRegion:GisRegion=gisMetry as GisRegion;
				geometry=new GeoRegion();
				parts=new Array();
				for each (var gisRegionPoint:GisPoint in gisRegion.parts)
				{
					parts.push(new Point2D(gisRegionPoint.x, gisRegionPoint.y));
				}
				(geometry as GeoRegion).addPart(parts);
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
			var mapCenterPoint:Point2D=new Point2D(centerPoint.x, centerPoint.y);
			if (this.metersPerPixel <= 0)
			{
				resetMetersPerPixel();
			}
			var rad:Number=radius * 1000 / this.metersPerPixel;
			log.debug("===>{0},{1}km,{2}", this.metersPerPixel, radius, rad);
			var mapPoint:Point2D;
			while (i < sides)
			{
				sin=Math.sin(Math.PI * 2 * i / sides);
				cos=Math.cos(Math.PI * 2 * i / sides);
				point=this._map.mapToScreen(mapCenterPoint);
				point.x+=rad * cos;
				point.y+=rad * sin;
				mapPoint=this._map.screenToMap(point);
				points[i]=new GisPoint(mapPoint.x, mapPoint.y);
				i++;
			}
			return points;
		}
		private function createCirclePoints(gisCircle:GisCircle):Array
		{
//			var points:Array = new Array();
//			var i:Number;
//			var sin:Number;
//			var cos:Number;
//			var x:Number;
//			var y:Number;
//			var point:Point = null;
//			var centerPoint:Point2D = new Point2D(gisCircle.centerPoint.x,gisCircle.centerPoint.y);
//			i = 0;
//			while (i < gisCircle.sides)
//			{
//				
//				sin = Math.sin(Math.PI * 2 * i / gisCircle.sides);
//				cos = Math.cos(Math.PI * 2 * i / gisCircle.sides);
//				x = centerPoint.x + gisCircle.radius * cos;
//				y = centerPoint.y + gisCircle.radius * sin;
//				points[i] = new Point2D(x, y);
//				i++;
//			}
//			return points;

			var points:Array=new Array();
			var points1:Array=new Array();
			var i:Number;
			var sin:Number;
			var cos:Number;
			var x:Number;
			var y:Number;
			var point:Point=null;
			i=0;
			var centerPoint:Point2D=new Point2D(gisCircle.centerPoint.x, gisCircle.centerPoint.y);
			if (this.metersPerPixel <= 0)
			{
				resetMetersPerPixel();
			}
			var rad:Number=gisCircle.radius * 1000 / this.metersPerPixel;
			log.debug("===>{0},{1}km,{2}", this.metersPerPixel, gisCircle.radius, rad);
			var mapPoint:Point2D;
			while (i < gisCircle.sides)
			{
				sin=Math.sin(Math.PI * 2 * i / gisCircle.sides);
				cos=Math.cos(Math.PI * 2 * i / gisCircle.sides);
				point=this._map.mapToScreen(centerPoint);
				point.x+=rad * cos;
				point.y+=rad * sin;
				mapPoint=this._map.screenToMap(point);
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
			var i:int;
			var sin:Number;
			var cos:Number;
			var x:Number;
			var y:Number;
			var point:Point=null;
			i=0;
			var centerPoint:Point2D=new Point2D(gisSector.centerPoint.x, gisSector.centerPoint.y);
			if (this.metersPerPixel <= 0)
			{
				resetMetersPerPixel();
			}
			var rad:Number=gisSector.radius * 1000 / this.metersPerPixel;
			log.debug("===>{0},{1}km,{2}", this.metersPerPixel, gisSector.radius, rad);
			
			var mapPoint:Point2D;
			points[0]=centerPoint;
			points1[0]=gisSector.centerPoint;
			if(gisSector.angleType==0){
				gisSector.startAngle = gisSector.startAngle*Math.PI/180;
				gisSector.endAngle = gisSector.endAngle*Math.PI/180;
			}
			var startIndex:int = gisSector.startAngle/(Math.PI*2)*gisSector.sides;
			var endIndex:int = gisSector.endAngle/(Math.PI*2)*gisSector.sides;
			i=startIndex;
			if(i>=endIndex){
				while (i <= gisSector.sides)
				{
					sin=Math.sin(-Math.PI * 2 * i / gisSector.sides);
					cos=Math.cos(-Math.PI * 2 * i / gisSector.sides);
					point=this._map.mapToScreen(centerPoint);
					point.x+=rad * cos;
					point.y+=rad * sin;
					mapPoint=this._map.screenToMap(point);
					points[i - startIndex + 1]=mapPoint;
					points1[i - startIndex + 1]=new GisPoint(mapPoint.x, mapPoint.y);
					i++;
				}
				i=0;
				while (i <= endIndex)
				{
					sin=Math.sin(-Math.PI * 2 * i / gisSector.sides);
					cos=Math.cos(-Math.PI * 2 * i / gisSector.sides);
					point=this._map.mapToScreen(centerPoint);
					point.x+=rad * cos;
					point.y+=rad * sin;
					mapPoint=this._map.screenToMap(point);
					points[gisSector.sides - startIndex + i + 1]=mapPoint;
					points1[gisSector.sides - startIndex + i + 1]=new GisPoint(mapPoint.x, mapPoint.y);
					i++;
				}
			}else{
				while (i <= endIndex)
				{
					sin=Math.sin(-Math.PI * 2 * i / gisSector.sides);
					cos=Math.cos(-Math.PI * 2 * i / gisSector.sides);
					point=this._map.mapToScreen(centerPoint);
					point.x+=rad * cos;
					point.y+=rad * sin;
					mapPoint=this._map.screenToMap(point);
					points[i - startIndex + 1]=mapPoint;
					points1[i - startIndex + 1]=new GisPoint(mapPoint.x, mapPoint.y);
					i++;
				}
			}
			gisSector.parts=points1;
			log.warn(points);
			return points;
		}

		/**
		 * 转换上层样式对象成底层地图样式对象
		 * @param gisFeature
		 * @return
		 *
		 */
		private function parseGisStyle(gisStyle:GisStyle):Style
		{
			var borderStyle:PredefinedLineStyle=null;
			var style:Style=null;
			if (gisStyle is GisMarkerPredefinedStyle) //点样式
			{
				var markerPredefinedStyle:GisMarkerPredefinedStyle=gisStyle as GisMarkerPredefinedStyle;
				if (markerPredefinedStyle.border != null)
				{
					borderStyle=new PredefinedLineStyle(markerPredefinedStyle.border.symbol, markerPredefinedStyle.border.color, markerPredefinedStyle.border.alpha, markerPredefinedStyle.border.weight, markerPredefinedStyle.border.cap, markerPredefinedStyle.border.join, markerPredefinedStyle.border.miterLimit);
				}
				style=new PredefinedMarkerStyle(markerPredefinedStyle.symbol, markerPredefinedStyle.size, markerPredefinedStyle.color, markerPredefinedStyle.alpha, markerPredefinedStyle.xOffset, markerPredefinedStyle.yOffset, markerPredefinedStyle.angle, borderStyle);
			}
			else if (gisStyle is GisMarkerPictureStyle) //图片点样式
			{
				var markerPictureStyle:GisMarkerPictureStyle=gisStyle as GisMarkerPictureStyle;
				style=new PictureMarkerStyle(markerPictureStyle.source, markerPictureStyle.width, markerPictureStyle.height, markerPictureStyle.xOffset, markerPictureStyle.yOffset, markerPictureStyle.alpha, markerPictureStyle.angle);
			}
			else if (gisStyle is GisLinePredefinedStyle) //线样式
			{
				var linePredefinedStyle:GisLinePredefinedStyle=gisStyle as GisLinePredefinedStyle;
				style=new PredefinedLineStyle(linePredefinedStyle.symbol, linePredefinedStyle.color, linePredefinedStyle.alpha, linePredefinedStyle.weight, linePredefinedStyle.cap, linePredefinedStyle.join, linePredefinedStyle.miterLimit);
			}
			else if (gisStyle is GisFillPredefinedStyle) //线填充样式
			{
				var fillPredefinedStyle:GisFillPredefinedStyle=gisStyle as GisFillPredefinedStyle;
				if (fillPredefinedStyle.border != null)
				{
					borderStyle=new PredefinedLineStyle(fillPredefinedStyle.border.symbol, fillPredefinedStyle.border.color, fillPredefinedStyle.border.alpha, fillPredefinedStyle.border.weight, fillPredefinedStyle.border.cap, fillPredefinedStyle.border.join, fillPredefinedStyle.border.miterLimit);
				}

				style=new PredefinedFillStyle(fillPredefinedStyle.symbol, fillPredefinedStyle.color, fillPredefinedStyle.alpha, borderStyle);
			}
			else if (gisStyle is GisFillPictureStyle) //图片填充样式
			{
				var fillPictureStyle:GisFillPictureStyle=gisStyle as GisFillPictureStyle;
				if (fillPictureStyle.border != null)
				{
					borderStyle=new PredefinedLineStyle(fillPictureStyle.border.symbol, fillPictureStyle.border.color, fillPictureStyle.border.alpha, fillPictureStyle.border.weight, fillPictureStyle.border.cap, fillPictureStyle.border.join, fillPictureStyle.border.miterLimit);
				}
				style=new PictureFillStyle(fillPictureStyle.source, fillPictureStyle.width, fillPictureStyle.height, fillPictureStyle.xScale, fillPictureStyle.yScale, fillPictureStyle.xOffset, fillPictureStyle.yOffset, fillPictureStyle.alpha, fillPictureStyle.angle, borderStyle);
			}
			else if (gisStyle is GisTextStyle) //文字样式
			{
				var textStyle:GisTextStyle=gisStyle as GisTextStyle;
				style=new TextStyle(textStyle.text, textStyle.color, textStyle.border, textStyle.borderColor, textStyle.background, textStyle.backgroundColor, textStyle.angle, textStyle.placement, textStyle.xoffset, textStyle.yoffset, textStyle.htmlText, textStyle.textFormat, textStyle.textAttribute, textStyle.textFunction);
			}
			return style;
		}

		/**
		 * 转换底层对象成上层地图对象
		 * @param graphic
		 *
		 */
		private function parseGraphic(graphic:Feature):GisFeature
		{
			var gisFeature:GisFeature;
			var gisLayer:ILayer;
			if (!gisFeature && graphic.id && graphic.featuresLayer)
			{
				gisLayer=getGisLayer(graphic.featuresLayer.id);
				if (gisLayer)
				{
					gisFeature=gisLayer.getGisFeatureByID(graphic.id);
				}
			}
			if (!gisFeature)
			{
				gisFeature=new GisFeature(parseMetry(graphic.geometry), parseStyle(graphic.style));
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
				var extent:Rectangle2D=graphic.geometry.bounds;
				if (!extent)
				{
					extent=new Rectangle2D((graphic.geometry as GeoPoint).x, (graphic.geometry as GeoPoint).y, (graphic.geometry as GeoPoint).x, (graphic.geometry as GeoPoint).y);
				}
				gisFeature.gisMetry.gisExtent=parseExtent(graphic.geometry.bounds);
			}
			else
			{
				gisFeature.gisMetry=parseMetry(graphic.geometry);
				gisFeature.gisMetry.gisExtent=parseExtent(graphic.geometry.bounds);
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
			var key:Object;
			if (geometry is GeoPoint)
			{
				var geoPoint:GeoPoint=geometry as GeoPoint;
				gisMetry=new GisPoint(geoPoint.x, geoPoint.y);
			}
			else if (geometry is GeoLine)
			{
				var geoLine:GeoLine=geometry as GeoLine;
				gisMetry=new GisLine();
				parts=new Array();
				for (key in geoLine.parts)
				{
					for each (var geoLinePoint:Point2D in geoLine.parts[key])
					{
						parts.push(new GisPoint(geoLinePoint.x, geoLinePoint.y));
					}
				}
				(gisMetry as GisLine).parts=parts;
			}
			else if (geometry is GeoRegion)
			{
				var geoRegion:GeoRegion=geometry as GeoRegion;
				gisMetry=new GisRegion();
				parts=new Array();
				for (key in geoRegion.parts)
				{
					for each (var geoRegionPoint:Point2D in geoRegion.parts[key])
					{
						parts.push(new GisPoint(geoRegionPoint.x, geoRegionPoint.y));
					}
				}
				(gisMetry as GisRegion).parts=parts;
			}
			return gisMetry;
		}

		private function parseStyle(style:Style):GisStyle
		{
			var gisStyle:GisStyle=null;
			var borderStyle:GisLinePredefinedStyle=null;
			if (style is PredefinedMarkerStyle) //点样式
			{
				var markerPredefinedStyle:PredefinedMarkerStyle=style as PredefinedMarkerStyle;
				if (markerPredefinedStyle.border != null)
				{
					borderStyle=new GisLinePredefinedStyle(markerPredefinedStyle.border.symbol, markerPredefinedStyle.border.color, markerPredefinedStyle.border.alpha, markerPredefinedStyle.border.weight, markerPredefinedStyle.border.cap, markerPredefinedStyle.border.join, markerPredefinedStyle.border.miterLimit);
				}
				gisStyle=new GisMarkerPredefinedStyle(markerPredefinedStyle.symbol, markerPredefinedStyle.size, markerPredefinedStyle.color, markerPredefinedStyle.alpha, markerPredefinedStyle.xOffset, markerPredefinedStyle.yOffset, markerPredefinedStyle.angle, borderStyle);
			}
			else if (style is PictureMarkerStyle) //图片点样式
			{
				var markerPictureStyle:PictureMarkerStyle=style as PictureMarkerStyle;
				gisStyle=new GisMarkerPictureStyle(markerPictureStyle.source, markerPictureStyle.width, markerPictureStyle.height, markerPictureStyle.xOffset, markerPictureStyle.yOffset, markerPictureStyle.alpha, markerPictureStyle.angle);
			}
			else if (style is PredefinedLineStyle) //线样式
			{
				var linePredefinedStyle:PredefinedLineStyle=style as PredefinedLineStyle;
				gisStyle=new GisLinePredefinedStyle(linePredefinedStyle.symbol, linePredefinedStyle.color, linePredefinedStyle.alpha, linePredefinedStyle.weight, linePredefinedStyle.cap, linePredefinedStyle.join, linePredefinedStyle.miterLimit);
			}
			else if (style is PredefinedFillStyle) //线填充样式
			{
				var fillPredefinedStyle:PredefinedFillStyle=style as PredefinedFillStyle;
				if (fillPredefinedStyle.border != null)
				{
					borderStyle=new GisLinePredefinedStyle(fillPredefinedStyle.border.symbol, fillPredefinedStyle.border.color, fillPredefinedStyle.border.alpha, fillPredefinedStyle.border.weight, fillPredefinedStyle.border.cap, fillPredefinedStyle.border.join, fillPredefinedStyle.border.miterLimit);
				}

				gisStyle=new GisFillPredefinedStyle(fillPredefinedStyle.symbol, fillPredefinedStyle.color, fillPredefinedStyle.alpha, borderStyle);
			}
			else if (style is PictureFillStyle) //图片填充样式
			{
				var fillPictureStyle:PictureFillStyle=style as PictureFillStyle;
				if (fillPictureStyle.border != null)
				{
					borderStyle=new GisLinePredefinedStyle(fillPictureStyle.border.symbol, fillPictureStyle.border.color, fillPictureStyle.border.alpha, fillPictureStyle.border.weight, fillPictureStyle.border.cap, fillPictureStyle.border.join, fillPictureStyle.border.miterLimit);
				}
				gisStyle=new GisFillPictureStyle(fillPictureStyle.source, fillPictureStyle.width, fillPictureStyle.height, fillPictureStyle.xScale, fillPictureStyle.yScale, fillPictureStyle.xOffset, fillPictureStyle.yOffset, fillPictureStyle.alpha, fillPictureStyle.angle, borderStyle);
			}
			else if (style is TextStyle) //文字样式
			{
				var textStyle:TextStyle=style as TextStyle;
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
		private function parseExtent(extent:Rectangle2D):GisExtent
		{
			if (!extent)
			{
				return null;
			}
			var gisExtent:GisExtent=new GisExtent("superMapExtentChange", extent.width, extent.height, extent.left, extent.right, extent.bottom, extent.top, new GisPoint(extent.center.x, extent.center.y));
			if (minLeft == 0)
			{
				minLeft=extent.left;
			}
			if (maxTop == 0)
			{
				maxTop=extent.top;
			}
			if (minBottom == 0)
			{
				minBottom=extent.bottom;
			}
			if (maxRight == 0)
			{
				maxRight=extent.right;
			}

			if (minLeft > extent.left)
			{
				minLeft=extent.left;
			}
			if (maxTop < extent.top)
			{
				maxTop=extent.top;
			}
			if (minBottom > extent.bottom)
			{
				minBottom=extent.bottom;
			}
			if (maxRight < extent.right)
			{
				maxRight=extent.right;
			}

			return gisExtent;
		}


		private function getGraphicsLayer(layerId:String):FeaturesLayer
		{
			if (_map.getLayer(layerId))
			{
				return _map.getLayer(layerId) as FeaturesLayer;
			}
			return null;
		}

		override public function panMap():void
		{
			_map.action=new Pan(_map);
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

		override public function zoomInMap():void
		{
			_map.action=new ZoomIn(_map);
		}

		override public function zoomOutMap():void
		{
			_map.action=new ZoomOut(_map);
		}

		override public function viewEntireMap():void
		{
			_map.viewEntire();
		}

		override public function selectMap():void
		{
			_map.action=null;
			drawRectangle();
		}

		override public function printMap():void
		{
			_map.action=new Pan(_map);
			var job:FlexPrintJob=new FlexPrintJob();
			if (job.start())
			{
				job.addObject(_map, FlexPrintJobScaleType.NONE);
				job.send();
			}
		}

		override public function exportMap():void
		{
			_map.action=new Pan(_map);
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

		override public function panTo(point:GisPoint):void
		{
			_map.panTo(new Point2D(point.x, point.y));
		}

		override public function set scale(value:Number):void
		{
			_map.zoomToScale(value);
		}

		override public function get scale():Number
		{
			return _map.scale;
		}

		override public function set level(value:Number):void
		{
			_map.zoomToLevel(value);
		}

		override public function get level():Number
		{
			return _map.level;
		}

		override public function zoomToScale(scale:Number, point:GisPoint):void
		{
			_map.zoomToScale(scale, new Point2D(point.x, point.y));
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
				_map.viewBounds=new Rectangle2D(minLeft, minBottom, maxRight, maxTop);
					//					minLeft=minBottom=maxRight=maxTop=0;
			}
		}


		public function queryGisRegionByAreaId(areaId:String, success:Function, failur:Function=null):void
		{
			var outFields:Array=String(mapConfig.outFields).split(",");
			var sqlwhere:String=" " + outFields[0] + " = " + areaId;
			queryFeaturesBySqlWhere(sqlwhere, outFields, mapConfig.queryUrl, function(resultSet:ResultSet):void
				{
					var features:Array=(resultSet.recordSets[0] as RecordSet).toFeatureSet();
					if (features.length > 0)
					{
						var point2Ds:Object=resultSet.recordSets[0].records[0].shape.point2Ds;
						var points:Array=new Array();
						var point0:GisPoint=new GisPoint(point2Ds[0].x, point2Ds[0].y);
						for each (var point:Object in point2Ds)
						{
							points.push(new GisPoint(point.x, point.y));
						}
						if (points.length > 0)
						{
							points.push(point0);
							var gisRegion:GisRegion=new GisRegion(points);
							if (success != null)
							{
								success.call(null, gisRegion);
							}
						}
					}
				});
		}

		override public function queryGisFeatureByAreaId(areaId:String, success:Function, failur:Function=null):void
		{
			var outFields:Array=String(mapConfig.outFields).split(",");
			var sqlwhere:String=" " + outFields[0] + " = " + areaId;
			queryFeaturesBySqlWhere(sqlwhere, outFields, mapConfig.queryUrl, function(resultSet:ResultSet):void
				{
					var features:Array=(resultSet.recordSets[0] as RecordSet).toFeatureSet();
					if (features.length > 0)
					{
						var feature:Feature=features[0] as Feature;
						var gis_id:String=parseGisID(feature.attributes, outFields[0]);
						feature.id="featureOf" + gis_id;
						var gisFeature:GisFeature=parseGraphic(feature);
						gisFeature.attributes.gis_id=gis_id;
						queryGisCache[gis_id]=feature;
						success.call(null, gisFeature);
					}
				});

		}

		override public function queryGisFeaturesByAreaIds(areaIds:Array, success:Function, failur:Function=null):void
		{
			var outFields:Array=String(mapConfig.outFields).split(",");
			var sqlwhere:String=" " + outFields[0] + " in (" + areaIds.join(",") + ")";
			queryFeaturesBySqlWhere(sqlwhere, outFields, mapConfig.queryUrl, function(resultSet:ResultSet):void
				{
					var features:Array=(resultSet.recordSets[0] as RecordSet).toFeatureSet();
					if (features.length > 0)
					{
						var gisFeatures:Array=new Array();
						for each (var feature:Feature in features)
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

		override public function queryGisFeaturesBySqlWhere(sqlWhere:String, success:Function, failur:Function=null):void
		{
			var outFields:Array=String(mapConfig.outFields).split(",");
			queryFeaturesBySqlWhere(sqlWhere, outFields, mapConfig.queryUrl, function(resultSet:ResultSet):void
				{
					var features:Array=(resultSet.recordSets[0] as RecordSet).toFeatureSet();
					if (features.length > 0)
					{
						var gisFeatures:Array=new Array();
						for each (var feature:Feature in features)
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

		private function doQueryBtsBySqlArray(sqls:Array, gisFeatures:Array, success:Function, failur:Function=null):void
		{
			log.warn("[doQueryBtsBySqlArray]sqls.length:{0}", sqls.length);
			if (sqls.length > 0)
			{
				var outFields:Array=String(mapConfig.outBTSFields).split(",");
				queryFeaturesBySqlWhere(String(sqls.shift()), outFields, mapConfig.queryBTSUrl, function(resultSet:ResultSet):void
					{
						var features:Array=(resultSet.recordSets[0] as RecordSet).toFeatureSet();
						if (features.length > 0)
						{
							for each (var feature:Feature in features)
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

		private function doQueryNodeBBySqlArray(sqls:Array, gisFeatures:Array, success:Function, failur:Function=null):void
		{
			log.warn("[doQueryNodeBBySqlArray]sqls.length:{0}", sqls.length);
			if (sqls.length > 0)
			{
				var outFields:Array=String(mapConfig.outNodeBFields).split(",");
				queryFeaturesBySqlWhere(String(sqls.shift()), outFields, mapConfig.queryNodeBUrl, function(resultSet:ResultSet):void
					{
						var features:Array=(resultSet.recordSets[0] as RecordSet).toFeatureSet();
						if (features.length > 0)
						{
							for each (var feature:Feature in features)
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

		override public function queryNodeBGisFeaturesBySqlWhere(sqlWhere:String, success:Function, failur:Function=null):void
		{
			//TODO
			var outFields:Array=String(mapConfig.outNodeBFields).split(",");
			queryFeaturesBySqlWhere(sqlWhere, outFields, mapConfig.queryNodeBUrl, function(resultSet:ResultSet):void
				{
					var features:Array=(resultSet.recordSets[0] as RecordSet).toFeatureSet();
					if (features.length > 0)
					{
						var gisFeatures:Array=new Array();
						for each (var feature:Feature in features)
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


		private function queryFeaturesBySqlWhere(sqlWhere:String, outFields:Array, url:String, success:Function, failur:Function=null):void
		{
			sqlParam.whereClause=sqlWhere;
			sqlParam.returnFields=outFields;
			var queryLayerParam:QueryLayerParam=new QueryLayerParam(url, sqlParam);
			var queryParam:QueryParam=new QueryParam();
			queryParam.networkType=ServerFeatureType.POLYGON;
			queryParam.returnResultSetInfo=ReturnResultSetInfo.RETURN_RESULT_ATTRIBUTEANDGEOMETRY;
			queryParam.queryLayerParams=[queryLayerParam];
			var queryBySqlParameters:QueryBySqlParameters=new QueryBySqlParameters(mapConfig.name, queryParam);
			var sqlQuery:QueryBySqlService=new QueryBySqlService(SuperMapConfig(config).webUrl);
			sqlQuery.method="POST";
			sqlQuery.execute(new AsyncResponder(function(resultSet:ResultSet, token:Object=null):void
				{
					success.call(null, resultSet);
				}, function(object:Object, mark:Object=null):void
				{
					log.error("Query Problem:" + object.toString());
				}, null), queryBySqlParameters);
		}

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
				clearAll();
//				removeGisLayer(serviceGisLayer);
//				removeGisLayer(modelGisLayer);
//				removeGisLayer(defaultGisLayer);
			}
			catch (e:Error)
			{

			}
			
			
			var layer:Layer=getLayer(serviceGisLayer.id);
			switch(config.serviceType){
				case Constants.MAP_REST:
					if (serviceGisLayer.url == SuperMapConfig(config).webUrl + mapConfig.name)
					{
						control.dispatchMapEvent(new MapEvent(MapEvent.MAP_CREATION_COMPLETE));
					}
					else
					{
						serviceGisLayer.url=SuperMapConfig(config).webUrl + mapConfig.name;
						_overviewLayer=new TiledDynamicRESTLayer();
						_overviewLayer.url=SuperMapConfig(config).webUrl + mapConfig.name;
						TiledDynamicRESTLayer(_overviewLayer).transparent=true;
						TiledDynamicRESTLayer(_overviewLayer).enableServerCaching=false;
						_map.scales=mapConfig.scales;
					}
					if (serviceGisLayer.url == SuperMapConfig(config).webUrl + mapConfig.name)
					{
						control.dispatchMapEvent(new MapEvent(MapEvent.MAP_CREATION_COMPLETE));
					}
					else
					{
						serviceGisLayer.url=SuperMapConfig(config).webUrl + mapConfig.name;
						_overviewLayer=new TiledDynamicRESTLayer();
						_overviewLayer.url=SuperMapConfig(config).webUrl + mapConfig.name;
						TiledDynamicRESTLayer(_overviewLayer).transparent=true;
						TiledDynamicRESTLayer(_overviewLayer).enableServerCaching=false;
						_map.scales=mapConfig.scales;
					}
					break;
				default:
					if (config.cachedable)
					{
						if (TiledCachedIServerLayer(layer).mapName == mapConfig.name)
						{
							control.dispatchMapEvent(new MapEvent(MapEvent.MAP_CREATION_COMPLETE));
						}
						else
						{
							TiledCachedIServerLayer(layer).mapName=mapConfig.name;
							_map.scales=mapConfig.scales;
							TiledCachedIServerLayer(layer).scales=mapConfig.scales;
							TiledCachedIServerLayer(_overviewLayer).mapName=mapConfig.name;
							TiledCachedIServerLayer(_overviewLayer).scales=mapConfig.scales;
							
							_overviewLayer=new TiledCachedIServerLayer();
							TiledCachedIServerLayer(_overviewLayer).cachedUrl=SuperMapConfig(config).cacheUrl;
							TiledCachedIServerLayer(_overviewLayer).url=SuperMapConfig(config).webUrl;
							TiledCachedIServerLayer(_overviewLayer).mapName=mapConfig.name;
							TiledCachedIServerLayer(_overviewLayer).scales=mapConfig.scales;
							TiledCachedIServerLayer(_overviewLayer).mapServiceAddress=SuperMapConfig(config).gisUrl;
							TiledCachedIServerLayer(_overviewLayer).mapServicePort=String(SuperMapConfig(config).servicePort);
						}
					}
					else
					{
						TiledDynamicIServerLayer(layer).mapName=mapConfig.name;
						TiledDynamicIServerLayer(_overviewLayer).mapName=mapConfig.name;
						
						_overviewLayer=new TiledDynamicIServerLayer();
						TiledDynamicIServerLayer(_overviewLayer).mapName=mapConfig.name;
						TiledDynamicIServerLayer(_overviewLayer).url=SuperMapConfig(config).webUrl;
						TiledDynamicIServerLayer(_overviewLayer).mapServiceAddress=SuperMapConfig(config).gisUrl;
						TiledDynamicIServerLayer(_overviewLayer).mapServicePort=String(SuperMapConfig(config).servicePort);
					}
					break;
			}
			_map.scales=mapConfig.scales;
			overviewMap.layers = _overviewLayer;
			layers.refresh();
//			if (config.serviceType == "REST")
//			{
//				if (layer.url == SuperMapConfig(config).webUrl + mapConfig.name)
//				{
////					control.dispatchMapEvent(new MapEvent(MapEvent.MAP_CREATION_COMPLETE));
//				}
//				else
//				{
//					layer.url=SuperMapConfig(config).webUrl + mapConfig.name;
//					_overviewServerLayer2.url=SuperMapConfig(config).webUrl + mapConfig.name;
//					_map.scales=mapConfig.scales;
//				}
//			}
//			else
//			{
//				if (config.cachedable)
//				{
//					if (TiledCachedIServerLayer(layer).mapName == mapConfig.name)
//					{
//						control.dispatchMapEvent(new MapEvent(MapEvent.MAP_CREATION_COMPLETE));
//					}
//					else
//					{
//						TiledCachedIServerLayer(layer).mapName=mapConfig.name;
//
//
//						_map.scales=mapConfig.scales;
//						TiledCachedIServerLayer(layer).scales=mapConfig.scales;
//						_overviewServerLayer.mapName=mapConfig.name;
//						_overviewServerLayer.scales=mapConfig.scales;
//						_overviewServerLayer1.mapName=mapConfig.name;
//					}
//				}
//				else
//				{
//					TiledDynamicIServerLayer(layer).mapName=mapConfig.name;
//				}
//			}
			
			
		}

		override public function updateFeatureByLayerId(layerId:String, gisFeature:GisFeature):void
		{
			var layer:FeaturesLayer=FeaturesLayer(getLayer(layerId));
			if (layer)
			{
				log.debug("[updateFeatureByLayerId]layerId:{0},gisFeature:{1}", layerId, gisFeature);
				var graphic:Feature=Feature((layer.features as ArrayCollection).getItemAt(getGisLayer(layerId).gisFeatures.getItemIndex(gisFeature)));
				if (graphic)
				{
//					graphic.geometry=parseGisMetry(gisFeature.gisMetry);
					graphic.style=parseGisStyle(gisFeature.gisStyle);
					graphic.filters=gisFeature.filters;
					graphic.visible=gisFeature.visible;
					graphic.toolTip=gisFeature.toolTip;
					graphic.autoMoveToTop=gisFeature.autoMoveToTop;
					graphic.alpha=gisFeature.alpha;
					graphic.buttonMode=gisFeature.buttonMode;
				}
			}
			
		}

		override public function drawLine():void
		{
			drawLineAction.style=borderStyle;
			_map.action=drawLineAction;
		}

		override public function drawFreePolygon():void
		{
			drawPolygonAction.style=polygonStyle;
			_map.action=drawPolygonAction;
		}

		override public function drawRectangle():void
		{
			drawRectangleAction.style=polygonStyle;
			_map.action=drawRectangleAction;
		}

		override public function drawCircle():void
		{
			drawCircleAction.style=polygonStyle;
			_map.action=drawCircleAction;
		}

		override public function drawPolygon():void
		{
			drawFreePolygonAction.style=polygonStyle;
			_map.action=drawFreePolygonAction;
		}

		override public function drawRegulPolyon():void
		{
			drawRegulPolyonAction.fillStyle=polygonStyle;
			_map.action=drawRegulPolyonAction;
		}

		override public function drawBack():void
		{
			if (step > 0)
			{
				step--;
				drawToolGisLayer.removeGisFeature(drawHis[step]);
//				getGraphicsLayer(defaultGisLayer.id).removeFeature(drawHis[step]);
				var drawEvent:GisDrawEvent=new GisDrawEvent(GisDrawEvent.DRAW_Back);
				drawEvent.gisFeature=drawHis[step];
				control.dispatchMapEvent(drawEvent);
			}
		}

		override public function drawForward():void
		{
			if (step < drawHis.length)
			{
				drawToolGisLayer.addGisFeature(drawHis[step]);
//				getGraphicsLayer(defaultGisLayer.id).addFeature(drawHis[step]);
				var drawEvent:GisDrawEvent=new GisDrawEvent(GisDrawEvent.DRAW_Forward);
				drawEvent.gisFeature=drawHis[step];
				control.dispatchMapEvent(drawEvent);
				step++;
			}
		}

		private function registerMouseEvent(graphic:Feature):void
		{
			graphic.addEventListener(MouseEvent.CLICK, onGraphicClickHandler);
			graphic.addEventListener(MouseEvent.MOUSE_OVER, onGraphicOverHandler);
			graphic.addEventListener(MouseEvent.MOUSE_OUT, onGraphicOutHandler);
		}

		private function onGraphicClickHandler(event:MouseEvent):void
		{
			log.debug("onGraphicClickHandler:" + event.target + "," + event.currentTarget + "," + event.target.parent);
			var graphic:Feature=Feature(event.currentTarget);
			var gisFeature:GisFeature=getGisLayer(graphic.featuresLayer.id).getGisFeatureByID(graphic.id);
			if (gisFeature && gisFeature.onClick is Function)
			{
				gisFeature.onClick.call(event, gisFeature, event);
			}
		}

		private function onGraphicOverHandler(event:MouseEvent):void
		{
			log.debug("onGraphicOverHandler:" + event.target + "," + event.currentTarget + "," + event.target.parent);
			var graphic:Feature=Feature(event.currentTarget);
			var gisFeature:GisFeature=getGisLayer(graphic.featuresLayer.id).getGisFeatureByID(graphic.id);
			if (gisFeature && gisFeature.onMouseOver is Function)
			{
				gisFeature.onMouseOver.call(event, gisFeature, event);
			}
		}

		private function onGraphicOutHandler(event:MouseEvent):void
		{
			log.debug("onGraphicOutHandler:" + event.target + "," + event.currentTarget + "," + event.target.parent);
			var graphic:Feature=Feature(event.currentTarget);
			var gisFeature:GisFeature=getGisLayer(graphic.featuresLayer.id).getGisFeatureByID(graphic.id);
			if (gisFeature && gisFeature.onMouseOut is Function)
			{
				gisFeature.onMouseOut.call(event, gisFeature, event);
			}
		}

		override public function addGisFeatureByLayerIdAt(layerId:String, gisFeature:GisFeature, index:int):String
		{
			log.warn("addGisFeatureByLayerIdAt:{0}", index);
			var layer:FeaturesLayer=FeaturesLayer(getLayer(layerId));
			if (!layer)
			{
				return null;
			}
			var graphic:Feature;
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
				graphic.id=gisFeature.id;
				if (index > 0)
				{
					(layer.features as ArrayCollection).addItemAt(graphic, index);
				}
				else
				{
					(layer.features as ArrayCollection).addItem(graphic);
				}
			}
			else
			{
				if (index > 0)
				{
					(layer.features as ArrayCollection).addItemAt(graphic, index);
				}
				else
				{
					(layer.features as ArrayCollection).addItem(graphic);
				}
				gisFeature.id=graphic.id;
			}
			gisFeature.gisLayerId=layerId;

//			gisFeature.gisLayerId=layerId;
//			gisFeature.index=(layer.features as ArrayCollection).getItemIndex(graphic);
			var extent:Rectangle2D=graphic.geometry.bounds;
			if (!extent)
			{
				extent=new Rectangle2D((graphic.geometry as GeoPoint).x, (graphic.geometry as GeoPoint).y, (graphic.geometry as GeoPoint).x, (graphic.geometry as GeoPoint).y);
			}
			gisFeature.gisMetry.gisExtent=parseExtent(extent);
			registerMouseEvent(graphic);
			log.debug("[addGisFeatureByLayerIdAt]{0}", gisFeature);
			return gisFeature.id;
		}

		override public function removeGisFeatureByLayerId(layerId:String, gisFeature:GisFeature):void
		{
			removeGisFeatureByLayerIdAt(layerId, getGisLayer(layerId).gisFeatures.getItemIndex(gisFeature));
		}

		override public function removeGisFeatureByLayerIdAt(layerId:String, index:int):void
		{
			var layer:FeaturesLayer=FeaturesLayer(getLayer(layerId));
			if (!layer || index < 0)
			{
				return;
			}
			var graphic:Feature=Feature((layer.features as ArrayCollection).getItemAt(index));
			if (graphic)
			{
				layer.removeFeature(graphic);
				log.debug("[removeGisFeatureByLayerIdAt]删除成功layerID:" + layerId + ",graphicID:" + graphic.id);
			}
		}

		override public function clearGisFeatureByLayerId(layerId:String):void
		{
			var layer:FeaturesLayer=getGraphicsLayer(layerId);
			if (layer)
			{
				layer.clear();
			}
		}

		override public function showZHBTSLayer(value:Boolean=false):void
		{
			//TODO
		}

		override public function showZHNodeBLayer(value:Boolean=false):void
		{
			//TODO
		}

		override public function showZHAPLayer(value:Boolean=false):void
		{
		}

		override public function showZHCellLayer(value:Boolean=false):void
		{
		}

		override public function showZHExcuseLayer(value:Boolean=false):void
		{
		}

		override public function showZHGimscustomerLayer(value:Boolean=false):void
		{
		}

		override public function showZHMachineroomLayer(value:Boolean=false):void
		{
		}

		override public function showZHUtrancellLayer(value:Boolean=false):void
		{
		}


		override public function get gisExtent():GisExtent
		{
			if (_map && _map.bounds)
			{
				var extent:Rectangle2D=_map.viewBounds;
				var gisExtent:GisExtent=new GisExtent(null, extent.width, extent.height, extent.left, extent.right, extent.top, extent.bottom, new GisPoint(extent.center.x, extent.center.y));
				return gisExtent;
			}
			return null;
		}

		override public function set gisExtent(gisExtent:GisExtent):void
		{
			if (gisExtent)
			{
				var extent:Rectangle2D=new Rectangle2D(gisExtent.xmin, gisExtent.ymin, gisExtent.xmax, gisExtent.ymax);
				_map.viewBounds=extent;

			}
		}

		override public function mapToStage(gisPoint:GisPoint):Point
		{
			return _map.mapToStage(new Point2D(gisPoint.x, gisPoint.y));
		}

		/**
		 * 根据url显示图片图层
		 * @param url
		 *
		 */
		override public function showWMSLayer(url:String):void
		{
		}

		/**
		 * 根据url隐藏图片图层
		 * @param url
		 */
		override public function hideWMSLayer(url:String):void
		{
		}


		override public function get mapUrl():String
		{
			var layer:Layer=getLayer(serviceGisLayer.id);
			var url:String;
			switch(config.serviceType){
				case Constants.MAP_REST:
					url = SuperMapConfig(config).webUrl + mapConfig.name;
					break;
				default:
					if (config.cachedable)
					{
						url = SuperMapConfig(config).gisUrl + ":" + SuperMapConfig(config).servicePort + "/" + TiledCachedIServerLayer(layer).mapName;
					}
					else
					{
						url = SuperMapConfig(config).gisUrl + ":" + SuperMapConfig(config).servicePort + "/" + TiledDynamicIServerLayer(layer).mapName;
					}
				break;
			}
			return url;
		}

		override public function getLayerInfosByLayerId(layerId:String):Array
		{
			return null;
		}

		override public function clearSelectionByLayerId(layerId:String):void
		{

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

		private function addLayerAt(gisLayer:ILayer, index:int=-1):void
		{
			if (_map.getLayer(gisLayer.id))
			{
				return;
			}
			var layer:Layer;
			if (gisLayer is GisServiceLayer)
			{
				if (config.serviceType == "REST")
				{
					layer=new TiledDynamicRESTLayer();
					TiledDynamicRESTLayer(layer).url=SuperMapConfig(config).webUrl + mapConfig.name;
					TiledDynamicRESTLayer(layer).transparent=true;
					TiledDynamicRESTLayer(layer).enableServerCaching=true;
					TiledDynamicRESTLayer(layer).addEventListener(LayerEvent.LOAD, onLayerLoad);
				}
				else
				{
					if (config.cachedable)
					{
						layer=new TiledCachedIServerLayer();
						TiledCachedIServerLayer(layer).cachedUrl=SuperMapConfig(config).cacheUrl;
						TiledCachedIServerLayer(layer).url=SuperMapConfig(config).webUrl;
						TiledCachedIServerLayer(layer).mapName=mapConfig.name;
						TiledCachedIServerLayer(layer).scales=mapConfig.scales;
						TiledCachedIServerLayer(layer).mapServiceAddress=SuperMapConfig(config).gisUrl;
						TiledCachedIServerLayer(layer).mapServicePort=String(SuperMapConfig(config).servicePort);
						TiledCachedIServerLayer(layer).addEventListener(LayerEvent.LOAD, onLayerLoad);
					}
					else
					{
						layer=new TiledDynamicIServerLayer();
						TiledDynamicIServerLayer(layer).mapName=mapConfig.name;
						TiledDynamicIServerLayer(layer).url=SuperMapConfig(config).webUrl;
						TiledDynamicIServerLayer(layer).mapServiceAddress=SuperMapConfig(config).gisUrl;
						TiledDynamicIServerLayer(layer).mapServicePort=String(SuperMapConfig(config).servicePort);
					}
				}
			}
			else if (gisLayer is GisLayer)
			{
				layer=new FeaturesLayer();
			}
			else if (gisLayer is GisFeatureLayer)
			{
//				layer=new FeatureLayer();
//				FeatureLayer(layer).url=GisFeatureLayer(gisLayer).url;
//				FeatureLayer(layer).outFields=GisFeatureLayer(gisLayer).outField;
//				FeatureLayer(layer).mode=GisFeatureLayer(gisLayer).mode;
//				FeatureLayer(layer).definitionExpression=GisFeatureLayer(gisLayer).definitionExpression;
//				FeatureLayer(layer).symbol=parseGisStyle(GisFeatureLayer(gisLayer).gisStyle);
//				FeatureLayer(layer).addEventListener(GraphicEvent.GRAPHIC_ADD, onFeatureLayerGraphicAdd);
//				FeatureLayer(layer).addEventListener(LayerEvent.UPDATE_END, onLayerUpDateEnd);
			}
			else if (gisLayer is GisDynamicServiceLayer)
			{
//				layer=new ArcGISDynamicMapServiceLayer();
//				ArcGISDynamicMapServiceLayer(layer).url=GisDynamicServiceLayer(gisLayer).url;
//				ArcGISDynamicMapServiceLayer(layer).visibleLayers=GisDynamicServiceLayer(gisLayer).visibleLayers;
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
			_map.removeAllLayers();
			for each (var layer:ILayer in layers)
			{
				addLayerAt(layer, layers.getItemIndex(layer));
			}
		}

		override public function updateScaleBarDisplay(scaleBar:ScaleBar):void
		{
			super.updateScaleBarDisplay(scaleBar);
			var scale:com.supermap.web.components.ScaleBar=new com.supermap.web.components.ScaleBar();
			scale.map=_map;
			if (scaleBar.top)
			{
				scale.top=scaleBar.top;
			}
			if (scaleBar.right)
			{
				scale.right=scaleBar.right;
			}
			if (scaleBar.bottom)
			{
				scale.bottom=scaleBar.bottom;
			}
			if (scaleBar.left)
			{
				scale.left=scaleBar.left;
			}
			scaleBarGroup.addElement(scale);
		}

		override public function updateZoomSliderDisplay(zoomSlider:ZoomSliderBar):void
		{
			super.updateZoomSliderDisplay(zoomSlider);
			var _zoomSlider:ZoomSlider=new ZoomSlider();
			if (zoomSlider.top)
			{
				_zoomSlider.top=zoomSlider.top;
			}
			if (zoomSlider.right)
			{
				_zoomSlider.right=zoomSlider.right;
			}
			if (zoomSlider.bottom)
			{
				_zoomSlider.bottom=zoomSlider.bottom;
			}
			if (zoomSlider.left)
			{
				_zoomSlider.left=zoomSlider.left;
			}
			_zoomSlider.map=_map;
			zoomSliderGroup.addElement(_zoomSlider);
		}

		override public function updateOverViewToolDisplay(overViewTool:OverViewTool):void
		{
			super.updateOverViewToolDisplay(overViewTool);
			overviewMap.map=_map;
			overviewMap.overviewMode="rectangle";
			overviewMap.zoomMode="normal";
//			switch(config.serviceType){
//				case Constants.MAP_REST:
//					_overviewLayer=new TiledDynamicRESTLayer();
//					_overviewLayer.url=SuperMapConfig(config).webUrl + mapConfig.name;
//					break;
//				default:
//					if(config.cachedable){
//						_overviewLayer=new TiledCachedIServerLayer();
//						TiledCachedIServerLayer(_overviewLayer).cachedUrl=SuperMapConfig(config).cacheUrl;
//						TiledCachedIServerLayer(_overviewLayer).url=SuperMapConfig(config).webUrl;
//						TiledCachedIServerLayer(_overviewLayer).mapName=mapConfig.name;
//						TiledCachedIServerLayer(_overviewLayer).scales=mapConfig.scales;
//						TiledCachedIServerLayer(_overviewLayer).mapServiceAddress=SuperMapConfig(config).gisUrl;
//						TiledCachedIServerLayer(_overviewLayer).mapServicePort=String(SuperMapConfig(config).servicePort);
//					}else{
//						_overviewLayer=new TiledDynamicIServerLayer();
//						TiledDynamicIServerLayer(_overviewLayer).mapName=mapConfig.name;
//						TiledDynamicIServerLayer(_overviewLayer).url=SuperMapConfig(config).webUrl;
//						TiledDynamicIServerLayer(_overviewLayer).mapServiceAddress=SuperMapConfig(config).gisUrl;
//						TiledDynamicIServerLayer(_overviewLayer).mapServicePort=String(SuperMapConfig(config).servicePort);
//					}
//					break;
//			}
//			overviewMap.layers=config.serviceType == "REST" ? _overviewServerLayer2 : config.cachedable ? _overviewServerLayer : _overviewServerLayer1;
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
			bc.addElement(overviewMap);
			overViewGroup.addElement(bc);
		}

		override protected function onPropertiesChangeHandler(event:PropertiesCompEvent):void
		{
			super.onPropertiesChangeHandler(event);
			var gisFeature:GisFeature=new GisFeature(event.param as GisMetry, drawStyle);
			drawToolGisLayer.addGisFeature(gisFeature);
			drawHis.push(gisFeature);
			step=drawHis.length;
			_map.action=new Pan(_map);
			panTo(gisFeature.gisMetry.gisExtent.center);
			lastEditGraphic=parseGisFeature(gisFeature);
			lastEditGisFeature=gisFeature;
			dispatchDrawEnd(gisFeature);
		}
	}
}