package com.ailk.common.ui.gis
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.arcgis.ArcGisMap;
	import com.ailk.common.ui.gis.arcgis.ArcGisMapConfig;
	import com.ailk.common.ui.gis.baidumap.BaiduMap;
	import com.ailk.common.ui.gis.baidumap.BaiduMapConfig;
	import com.ailk.common.ui.gis.core.BaseControl;
	import com.ailk.common.ui.gis.core.ILayer;
	import com.ailk.common.ui.gis.core.IMap;
	import com.ailk.common.ui.gis.core.IMapConfig;
	import com.ailk.common.ui.gis.core.IMapControl;
	import com.ailk.common.ui.gis.core.gis_internal;
	import com.ailk.common.ui.gis.event.GisDrawEvent;
	import com.ailk.common.ui.gis.event.GisExtentEvent;
	import com.ailk.common.ui.gis.event.MapEvent;
	import com.ailk.common.ui.gis.exception.GisException;
	import com.ailk.common.ui.gis.googlemap.GoogleMap;
	import com.ailk.common.ui.gis.googlemap.GoogleMapConfig;
	import com.ailk.common.ui.gis.supermap.SuperMap;
	import com.ailk.common.ui.gis.supermap.SuperMapConfig;
	import com.ailk.common.ui.gis.tools.DrawToolBar;
	import com.ailk.common.ui.gis.tools.OverViewTool;
	import com.ailk.common.ui.gis.tools.ScaleBar;
	import com.ailk.common.ui.gis.tools.ToolBar;
	import com.ailk.common.ui.gis.tools.ZoomSliderBar;
	import com.ailk.common.ui.gis.utils.IPUtil;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.URLUtil;
	
	import spark.components.Group;

	use namespace gis_internal;

	[ResourceBundle("gisResource")]

	[Style(name="toolBarSkin", type="Class")]

	[Style(name="toolBarColor", type="uint", format="Color", inherit="no")]

	[Style(name="toolBarBackgroundColor", type="uint", format="Color", inherit="no")]

	[Style(name="toolBarBackgroundAlpha", type="Number", inherit="no")]

	[Style(name="toolBarBorderColor", type="uint", format="Color", inherit="no")]

	[Style(name="toolBarBorderAlpha", type="Number", inherit="no")]



	[Style(name="drawToolBarSkin", type="Class")]

	[Style(name="drawToolBarColor", type="uint", format="Color", inherit="no")]

	[Style(name="drawToolBarBackgroundColor", type="uint", format="Color", inherit="no")]

	[Style(name="drawToolBarBackgroundAlpha", type="Number", inherit="no")]

	[Style(name="drawToolBarBorderColor", type="uint", format="Color", inherit="no")]

	[Style(name="drawToolBarBorderAlpha", type="Number", inherit="no")]

	/**
	 * 地图创建完成事件
	 */
	[Event(name="mapCreationComplete", type="com.ailk.common.ui.gis.event.MapEvent")]
	/**
	 * 地图选择事件
	 */
	[Event(name="mapSelectComplete", type="com.ailk.common.ui.gis.event.MapEvent")]
	/**
	 * 地图工具条图层按钮点击事件
	 */
	[Event(name="toolbar_picLayer", type="com.ailk.common.ui.gis.event.MapEvent")]
	/**
	 * 地图工具条图例按钮点击事件
	 */
	[Event(name="toolbar_legend", type="com.ailk.common.ui.gis.event.MapEvent")]
	/**
	 * 地图工具条定位按钮点击事件
	 */
	[Event(name="toolbar_goto", type="com.ailk.common.ui.gis.event.MapEvent")]
	/**
	 * 地图点击事件
	 */
	[Event(name="map_click", type="com.ailk.common.ui.gis.event.MapEvent")]
	/**
	 * 地图绘制工具条绘制结束事件
	 */
	[Event(name="draw_click", type="com.ailk.common.ui.gis.event.GisDrawEvent")]
	/**
	 * 地图绘制工具条绘制结束事件
	 */
	[Event(name="draw_end", type="com.ailk.common.ui.gis.event.GisDrawEvent")]
	/**
	 * 地图绘制工具条后退事件
	 */
	[Event(name="draw_back", type="com.ailk.common.ui.gis.event.GisDrawEvent")]
	/**
	 * 地图绘制工具条前进事件
	 */
	[Event(name="draw_forward", type="com.ailk.common.ui.gis.event.GisDrawEvent")]
	/**
	 * 地图绘制工具条设置绘制点事件
	 */
	[Event(name="drawPointSelect", type="com.ailk.common.ui.gis.event.GisDrawEvent")]
	/**
	 * 地图区域变化事件
	 */
	[Event(name="extent_change", type="com.ailk.common.ui.gis.event.GisExtentEvent")]
	/**
	 *	GIS地图容器类
	 * @author shiliang
	 *
	 */
	public class MapWork extends UIComponent
	{

		private static var log:ILogger=Log.getLoggerByClass(MapWork);
		/**
		 * 地图选择配置类，对应读取gis_config.xml配置文件
		 */
		gis_internal var viewConfig:ViewConfig;
		/**
		 * 地图路径信息等配置类，对应读取gis_config.xml中的configUrl属性对应的配置文件
		 */
		gis_internal var mapConfig:IMapConfig;
		/**
		 * 地图控制类
		 */
		gis_internal var mapControl:IMapControl;
		/**
		 * 地图对象类
		 */
		public var map:IMap;
		/**
		 * 地图类型（supermap,arcgis），默认为arcgis
		 */
		[Inspectable(category="General", enumeration="supermap,arcgis,baidumap,googlemap", defaultValue="arcgis")]
		public var mapType:String=Constants.MAP_TYPE_SUPERMAP;
		/**
		 * 地图是否缓存，若为true，则地图使用缓存图层， 默认为true
		 */
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var cachedable:Boolean=true;
		/**
		 * 是否显示工具条，若为true，则显示工具条，默认为true
		 */
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var showToolBar:Boolean=true;
		/**
		 * 是否显示比例标尺，若为true,则显示比例标尺，默认为true
		 */
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var showZoomSlider:Boolean=true;
		/**
		 * 是否显示比例，若为true,则显示比例，默认为false
		 */
		[Inspectable(category="General", enumeration="false,true", defaultValue="false")]
		public var showScaleBar:Boolean=false;
		/**
		 * 是否显示鹰眼，若为true，则显示鹰眼，默认为true(Arcgis不支持鹰眼)
		 */
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var showOverView:Boolean=true;
		/**
		 * 是否显示绘制工具条，若为true,则显示绘制工具条，默认为false
		 */
		[Inspectable(category="General", enumeration="false,true", defaultValue="false")]
		public var showDrawToolBar:Boolean=false;
		/**
		 * 是否支持鼠标滚轮进行放大缩小地图，若为true，则根据鼠标滚轮事件进行放大缩小，默认为true
		 */
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var scrollWheelZoomEnabled:Boolean=true;
		/**
		 * 是否支持鼠标双击进行放大缩小地图，若为true，则根据鼠标双击事件进行放大缩小，默认为true
		 */
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var doubleClickZoomEnabled:Boolean=true;
		/**
		 * 地图服务类型
		 */
		[Inspectable(category="General", enumeration="REST,CACHE", defaultValue="REST")]
		public var serviceType:String="REST";
		
		/**
		 * 地图服务图层透明度
		 */
		[Inspectable(defaultValue="1.0", category="General", verbose="1")]
		public var serviceLayerAlpha:Number=1;
		
		/**
		 * 初始地市地图ID，与配置文件中mid对应，默认显示的地市地图ID
		 */
		public var defaultMapId:String;

		private var staticLayer:Group=new Group();

		private var toolBarChanged:Boolean=false;
		private var _toolBar:ToolBar;
		private var drawToolBarChanged:Boolean=false;
		private var _drawToolBar:DrawToolBar;
		private var _zoomSliderBar:ZoomSliderBar;
		private var zoomSliderBarChanged:Boolean=false;
		private var _scaleBar:ScaleBar;
		private var scaleBarChanged:Boolean=false;
		private var _layers:Array;
		private var layersChanged:Boolean=false;

		private var _overViewTool:OverViewTool;
		private var overViewToolChanged:Boolean=false;

		public function MapWork()
		{
			this.addEventListener(MapEvent.MAP_VIEWCONFIG_INIT_COMPLETE, viewConfigInitComplete);
			if (!viewConfig)
			{
				viewConfig=new ViewConfig(this);
			}
			init();
		}

		/**
		 * 地图容器初始化
		 * @param event
		 *
		 */
		private function init(event:FlexEvent=null):void
		{
			viewConfig.readConfig();
		}

		/**
		 * 地图选择配置类初始化完成
		 * @param event
		 *
		 */
		private function viewConfigInitComplete(event:MapEvent):void
		{
			mapType=String(viewConfig.config.type);
			mapControl=new BaseControl();
			switch (mapType)
			{
				case Constants.MAP_TYPE_ARCGIS:
					mapConfig=new ArcGisMapConfig(mapControl);
					break;
				case Constants.MAP_TYPE_SUPERMAP:
					mapConfig=new SuperMapConfig(mapControl);
					break;
				case Constants.MAP_TYPE_BAIDUMAP:
					mapConfig=new BaiduMapConfig(mapControl);
					break;
				case Constants.MAP_TYPE_GOOGLEMAP:
					mapConfig=new GoogleMapConfig(mapControl);
					break;
				default:
					throw new GisException(resourceManager.getString(Constants.GisResource, "ERROR_MAPTYPE"));
			}
			var url:String=FlexGlobals.topLevelApplication.url;
			var serverName:String=URLUtil.getServerName(url);
			if (!IPUtil.isInnerIP(serverName))
			{
				mapConfig.configUrl=Constants.ConfigBaseUrl+"outer_" + String(viewConfig.config.configUrl[mapType]);
			}
			else
			{
				mapConfig.configUrl=Constants.ConfigBaseUrl+String(viewConfig.config.configUrl[mapType]);
			}
			mapConfig.cachedable=cachedable;
			mapConfig.showToolBar=showToolBar;
			mapConfig.showZoomSlider=showZoomSlider;
			mapConfig.showOverView=showOverView;
			mapConfig.showDrawToolBar=showDrawToolBar;
			mapConfig.defaultMapId=defaultMapId;
			mapConfig.scrollWheelZoomEnabled=scrollWheelZoomEnabled;
			mapConfig.doubleClickZoomEnabled=doubleClickZoomEnabled;
			mapConfig.serviceType=serviceType;
			mapConfig.serviceLayerAlpha=serviceLayerAlpha;
			mapControl.addMapEventListener(MapEvent.MAP_PARAM_INIT_COMPLETE, paramInitHandler);
			mapControl.addMapEventListener(MapEvent.MAP_CREATION_COMPLETE, mapCreationCompleteHandler);
			mapControl.addMapEventListener(MapEvent.MAP_CLICK, map_clickHandler);
			mapControl.addMapEventListener(MapEvent.MAP_SELECT_COMPLETE, mapSelectCompleteHandler);
			mapControl.addMapEventListener(GisDrawEvent.DRAW_CLICK, gisDrawClickEventHandler);
			mapControl.addMapEventListener(GisDrawEvent.DRAW_END, gisDrawEventHandler);
			mapControl.addMapEventListener(GisDrawEvent.DRAW_Back, gisDrawEventHandler);
			mapControl.addMapEventListener(GisDrawEvent.DRAW_Forward, gisDrawEventHandler);
			mapControl.addMapEventListener(GisDrawEvent.DRAWPOINTSELECT, gisDrawEventHandler);
			mapControl.addMapEventListener(GisExtentEvent.EXTENT_CHANGE, gisExtentEventHandler);
			mapConfig.init();
		}

		/**
		 * 地图参数初始化完成处理
		 * @param event
		 *
		 */
		private function paramInitHandler(event:MapEvent):void
		{
			switch (mapType)
			{
				case Constants.MAP_TYPE_ARCGIS:
					map=new ArcGisMap(mapConfig, mapControl);
					break;
				case Constants.MAP_TYPE_SUPERMAP:
					map=new SuperMap(mapConfig, mapControl);
					break;
				case Constants.MAP_TYPE_BAIDUMAP:
					map=new BaiduMap(mapConfig, mapControl);
					break;
				case Constants.MAP_TYPE_GOOGLEMAP:
					map=new GoogleMap(mapConfig, mapControl);
					break;
				default:
					throw new GisException(resourceManager.getString(Constants.GisResource, "ERROR_MAPTYPE"));

			}
			addChildAt(map as UIComponent, 0);
			addChildAt(staticLayer, 1);
			log.debug("[paramInitHandler]");
		}

		override protected function createChildren():void
		{
			log.debug("[createChildren]");
			super.createChildren();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			try
			{
				(map as UIComponent).width=unscaledWidth;
				(map as UIComponent).height=unscaledHeight;
				this.staticLayer.setActualSize(unscaledWidth, unscaledHeight);
				invalidateProperties();
				buildTools();
			}
			catch (e:Error)
			{
				log.error(e)
			}
			if (moduleFactory)
			{
				log.debug("validateSkinChange");
				validateSkinChange();
			}
		}

		private function validateSkinChange():void
		{
			if (_toolBar)
			{
				if (getStyle("toolBarSkin"))
				{
					_toolBar.setStyle("skinClass", getStyle("toolBarSkin"));
				}
				if (getStyle("toolBarColor"))
				{
					_toolBar.setStyle("color", getStyle("toolBarColor"));
				}
				if (getStyle("toolBarBackgroundColor"))
				{
					_toolBar.setStyle("backgroundColor", getStyle("toolBarBackgroundColor"));
				}
				if (getStyle("toolBarBackgroundAlpha"))
				{
					_toolBar.setStyle("backgroundAlpha", getStyle("toolBarBackgroundAlpha"));
				}
				if (getStyle("toolBarBorderColor"))
				{
					_toolBar.setStyle("borderColor", getStyle("toolBarBorderColor"));
				}
				if (getStyle("toolBarBorderAlpha"))
				{
					_toolBar.setStyle("borderAlpha", getStyle("toolBarBorderAlpha"));
				}
			}

			if (_drawToolBar)
			{
				if (getStyle("drawToolBarSkin"))
				{
					_drawToolBar.setStyle("skinClass", getStyle("drawToolBarSkin"));
				}
				if (getStyle("drawToolBarColor"))
				{
					_drawToolBar.setStyle("color", getStyle("drawToolBarColor"));
				}
				if (getStyle("drawToolBarBackgroundColor"))
				{
					_drawToolBar.setStyle("backgroundColor", getStyle("drawToolBarBackgroundColor"));
				}
				if (getStyle("drawToolBarBackgroundAlpha"))
				{
					_drawToolBar.setStyle("backgroundAlpha", getStyle("drawToolBarBackgroundAlpha"));
				}
				if (getStyle("drawToolBarBorderColor"))
				{
					_drawToolBar.setStyle("borderColor", getStyle("drawToolBarBorderColor"));
				}
				if (getStyle("drawToolBarBorderAlpha"))
				{
					_drawToolBar.setStyle("borderAlpha", getStyle("drawToolBarBorderAlpha"));
				}
			}

		}


		override protected function commitProperties():void
		{

			if (layersChanged)
			{
				if (map)
				{
					log.debug("[layersChanged]{0}", layersChanged);
					map.removeAllGisLayers();
					layers.forEach(function callback(item:*, index:int, array:Array):void
						{
//							log.debug(item);
							map.addGisLayer(item as ILayer);
						});
					layersChanged=false;
				}
			}
			if (toolBarChanged)
			{
				log.debug("[toolBarChanged]{0}", toolBarChanged);
				staticLayer.addElement(toolBar);
				toolBarChanged=false;
			}
			if (drawToolBarChanged)
			{
				if(map){
					log.debug("[drawToolBarChanged]{0},{1}", drawToolBarChanged,map);
					staticLayer.addElement(drawToolBar);
					drawToolBarChanged=false;
					if (!_drawToolBar.gisLayer)
					{
						_drawToolBar.gisLayer=this.map.defaultGisLayer;
					}
					this.map.drawToolGisLayer=_drawToolBar.gisLayer;
					mapControl.dispatchMapEvent(new MapEvent(MapEvent.DRAWTOOL_CREATION_COMPLETE));
				}
			}
			if (zoomSliderBarChanged)
			{
				log.debug("[zoomSliderBarChanged]{0}", zoomSliderBarChanged);
				staticLayer.addElement(zoomSliderBar);
				zoomSliderBarChanged=false;
			}
			if (scaleBarChanged)
			{
				log.debug("[scaleBarChanged]{0}", scaleBarChanged);
				staticLayer.addElement(scaleBar);
				scaleBarChanged=false;
			}
			if (overViewToolChanged)
			{
				staticLayer.addElement(overViewTool);
				overViewToolChanged=false;
			}
			super.commitProperties();
		}

		/**
		 * 创建地图工具条
		 *
		 */
		private function buildTools():void
		{
			if (showToolBar && !toolBar)
			{
				toolBar=new ToolBar();
				toolBar.top=20;
				toolBar.left=50;
//				log.debug("[build toolBar]");
			}
			if (showDrawToolBar && !drawToolBar)
			{
				drawToolBar=new DrawToolBar();
				drawToolBar.bottom=-2;
				drawToolBar.horizontalCenter=0;
//				log.debug("[build drawToolBar]");
			}
			if (showZoomSlider && !zoomSliderBar)
			{
				zoomSliderBar=new ZoomSliderBar();
				zoomSliderBar.left=20;
				zoomSliderBar.top=20;
//				log.debug("[build zoomSliderBar]");
			}
			if (showScaleBar && !scaleBar)
			{
				scaleBar=new ScaleBar();
				scaleBar.bottom=10;
				scaleBar.left=10;
//				log.debug("[build scaleBar]");
			}
			if (showOverView && !overViewTool)
			{
				overViewTool=new OverViewTool();
				overViewTool.bottom=10;
				overViewTool.right=10;
//				log.debug("[build overViewTool]");
			}
		}

		/**
		 * 地图组件创建完成处理
		 * @param event
		 *
		 */
		private function mapCreationCompleteHandler(event:MapEvent):void
		{
//			invalidateProperties();
//			buildTools();
			this.dispatchEvent(new MapEvent(MapEvent.MAP_CREATION_COMPLETE));
		}

		/**
		 * 地图选择处理
		 * @param event
		 *
		 */
		private function mapSelectCompleteHandler(event:MapEvent):void
		{
			this.dispatchEvent(new MapEvent(MapEvent.MAP_SELECT_COMPLETE));
		}

		/**
		 * 地图点击处理
		 * @param event
		 *
		 */
		private function map_clickHandler(event:MapEvent):void
		{
			var evt:MapEvent=new MapEvent(MapEvent.MAP_CLICK);
			evt.mapPoint=event.mapPoint;
			this.dispatchEvent(evt);
		}

		private function gisDrawClickEventHandler(event:GisDrawEvent):void
		{
			this.dispatchEvent(new GisDrawEvent(event.type));
		}

		/**
		 * 地图绘制处理
		 * @param event
		 *
		 */
		private function gisDrawEventHandler(event:GisDrawEvent):void
		{
			var evt:GisDrawEvent=new GisDrawEvent(event.type);
			evt.gisFeature=event.gisFeature;
			this.dispatchEvent(evt);
		}

		/**
		 * 地图区域变化处理
		 * @param event
		 *
		 */
		private function gisExtentEventHandler(event:GisExtentEvent):void
		{
			var evt:GisExtentEvent=new GisExtentEvent(event.type);
			evt.levelChange=event.levelChange;
			evt.extent=event.extent;
			this.dispatchEvent(evt);
		}

		public function get layers():Array
		{
			return _layers;
		}

		[Inspectable(category="General", arrayType="com.ailk.common.ui.gis.core.ILayer")]
		public function set layers(value:Array):void
		{
			_layers=value;
			layersChanged=true;
			invalidateProperties();
		}

		public function get toolBar():ToolBar
		{
			return this._toolBar;
		}

		[Inspectable(category="General", arrayType="com.ailk.common.ui.gis.tools.ToolBar")]
		public function set toolBar(value:ToolBar):void
		{
			_toolBar=value;
			if (!_toolBar.mapWork)
			{
				_toolBar.mapWork=this;
			}
			toolBarChanged=true;
			invalidateProperties();
		}

		public function get drawToolBar():DrawToolBar
		{
			return this._drawToolBar;
		}

		[Inspectable(category="General", arrayType="com.ailk.common.ui.gis.tools.DrawToolBar")]
		public function set drawToolBar(value:DrawToolBar):void
		{
			_drawToolBar=value;
			if (!_drawToolBar.mapWork)
			{
				_drawToolBar.mapWork=this;
			}
			drawToolBarChanged=true;
			invalidateProperties();
		}

		public function get zoomSliderBar():ZoomSliderBar
		{
			return _zoomSliderBar;
		}

		[Inspectable(category="General", arrayType="com.ailk.common.ui.gis.tools.ZoomSliderBar")]
		public function set zoomSliderBar(value:ZoomSliderBar):void
		{
			_zoomSliderBar=value;
			if (!_zoomSliderBar.mapWork)
			{
				_zoomSliderBar.mapWork=this;
			}
			zoomSliderBarChanged=true;
			invalidateProperties();
		}

		public function get scaleBar():ScaleBar
		{
			return _scaleBar;
		}

		[Inspectable(category="General", arrayType="com.ailk.common.ui.gis.tools.ScaleBar")]
		public function set scaleBar(value:ScaleBar):void
		{
			_scaleBar=value;
			if (!_scaleBar.mapWork)
			{
				_scaleBar.mapWork=this;
			}
			scaleBarChanged=true;
			invalidateProperties();
		}

		public function get overViewTool():OverViewTool
		{
			return _overViewTool;
		}

		[Inspectable(category="General", arrayType="com.ailk.common.ui.gis.tools.OverViewTool")]
		public function set overViewTool(value:OverViewTool):void
		{
			_overViewTool=value;
			if (!_overViewTool.mapWork)
			{
				_overViewTool.mapWork=this;
			}
			overViewToolChanged=true;
			invalidateProperties();
		}

	}
}