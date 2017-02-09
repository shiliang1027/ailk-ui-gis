package com.ailk.common.ui.gis.core
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.core.metry.GisCircle;
	import com.ailk.common.ui.gis.core.metry.GisExtent;
	import com.ailk.common.ui.gis.core.metry.GisPoint;
	import com.ailk.common.ui.gis.core.styles.GisFillPredefinedStyle;
	import com.ailk.common.ui.gis.core.styles.GisLinePredefinedStyle;
	import com.ailk.common.ui.gis.core.styles.GisLineStyle;
	import com.ailk.common.ui.gis.core.task.BaseTask;
	import com.ailk.common.ui.gis.event.GisDrawEvent;
	import com.ailk.common.ui.gis.tools.OverViewTool;
	import com.ailk.common.ui.gis.tools.PropertiesComp;
	import com.ailk.common.ui.gis.tools.PropertiesCompEvent;
	import com.ailk.common.ui.gis.tools.ScaleBar;
	import com.ailk.common.ui.gis.tools.ZoomSliderBar;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	import spark.components.Group;

	use namespace gis_internal;
	/**
	 * 地图组件基类
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-4-26 下午04:02:29
	 * @category com.ailk.common.ui.gis.core
	 * @copyright 南京联创科技 网管开发部
	 */
	public class BaseMap extends UIComponent implements IMap
	{

		private static var log:ILogger=Log.getLoggerByClass(BaseMap);
		private var _config:IMapConfig;
		private var _control:IMapControl

		private var _layers:ArrayCollection=new ArrayCollection;
		private var _queryGisCache:Dictionary=new Dictionary;
		private var _selectedable:Boolean=false;
		private var _ruleable:Boolean=false;

		private var _serviceGisLayer:GisServiceLayer;
		private var _modelGisLayer:GisLayer;
		private var _defaultGisLayer:GisLayer;
		private var _drawToolGisLayer:GisLayer;

		private var _wmsLayers:Dictionary=new Dictionary;

		private var _minLeft:Number=0;
		private var _maxTop:Number=0;
		private var _maxRight:Number=0;
		private var _minBottom:Number=0;

		private var _step:Number=0;
		private var _drawHis:Array=new Array();
		private var _overTarget:Object;

		public var scaleBarGroup:Group;
		public var zoomSliderGroup:Group;
		public var overViewGroup:Group;
		
		private var _propComp:PropertiesComp;
		private var bord:GisLinePredefinedStyle=new GisLinePredefinedStyle(GisLineStyle.STYLE_SOLID, 0x0ac1e6, 1, 2);
		gis_internal var drawStyle:GisFillPredefinedStyle=new GisFillPredefinedStyle(GisLineStyle.STYLE_SOLID, 0xe3f8ff, 0.5,bord);

		private var _lastDrawPoint:GisPoint = new GisPoint(0,0);
		gis_internal var mapConfig:Object;
		gis_internal var isLastDrawPointSet:Boolean=false;
		gis_internal var drawType:String;
		
		private var _dirty:Boolean=false;
		private var _metersPerPixel:Number=0;
		
		public function BaseMap(config:IMapConfig, control:IMapControl)
		{
			mapConfig=config.getMapConfig(config.defaultMapId);
			this.config=config;
			this.control=control;
			percentHeight=100;
			percentWidth=100;
			serviceGisLayer=new GisServiceLayer();
			defaultGisLayer=new GisLayer();
			modelGisLayer=new GisLayer();
			layers.addEventListener(CollectionEvent.COLLECTION_CHANGE, onLayersChangeHandler);
			
			propComp = new PropertiesComp();
			propComp.addEventListener(PropertiesCompEvent.VIEW_SHOW,onPropertiesCompShowHandler);
			propComp.addEventListener(PropertiesCompEvent.VIEW_HIDE,onPropertiesCompHideHandler);
			propComp.addEventListener(PropertiesCompEvent.PROPERTIES_CHANGE,onPropertiesChangeHandler);
		}

		protected function onPropertiesCompShowHandler(event:PropertiesCompEvent):void{
			var parent:*=null;
			if (!parent)
			{
				var sm:ISystemManager=ISystemManager(FlexGlobals.topLevelApplication.systemManager);
				// no types so no dependencies
				var mp:Object=sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
				if (mp && mp.useSWFBridge())
					parent=Sprite(sm.getSandboxRoot());
				else
					parent=Sprite(FlexGlobals.topLevelApplication);
			}
			PopUpManager.addPopUp(propComp, parent,true);
			PopUpManager.centerPopUp(propComp);
//			_propComp.x=this.width-_propComp.width-20;
//			_propComp.y=this.height-_propComp.height;
		}
		
		protected function onPropertiesCompHideHandler(event:PropertiesCompEvent):void{
			PopUpManager.removePopUp(propComp);
		}
		
		protected function onPropertiesChangeHandler(event:PropertiesCompEvent):void{
			propComp.dispatchEvent(new PropertiesCompEvent(PropertiesCompEvent.VIEW_HIDE));
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (scaleBarGroup)
			{
				scaleBarGroup.width=unscaledWidth;
				scaleBarGroup.height=unscaledHeight;
			}
			if (zoomSliderGroup)
			{
				zoomSliderGroup.width=unscaledWidth;
				zoomSliderGroup.height=unscaledHeight;
			}
			if (overViewGroup)
			{
				overViewGroup.width=unscaledWidth;
				overViewGroup.height=unscaledHeight;
			}
		}

		protected function onLayersChangeHandler(event:CollectionEvent):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.onLayersChangeHandler]才能发挥作用");
		}

		private function isContainsMenu(menuName:String, menus:Array):Boolean
		{
			if (getMenuItem(menuName, menus))
			{
				return true;
			}
			return false;
		}

		public function getMenuItem(menuName:String, menus:Array):GisContextMenuItem
		{
			var menuItem:GisContextMenuItem;
			menus.forEach(function(item:*, index:int, array:Array):void
				{
					if (GisContextMenuItem(item).caption == menuName && !menuItem)
					{
						menuItem=GisContextMenuItem(item);
					}
				});
			return menuItem;
		}

		public function parseGisID(attributes:Object, gisKey:String):String
		{
			for (var key:String in attributes)
			{
				if (key.indexOf(gisKey) != -1)
				{
					return String(attributes[key]);
				}
			}
			return null;
		}

		public function addGisFeature(gisFeature:GisFeature, isModelLayer:Boolean=false):void
		{
			if (isModelLayer)
			{
				modelGisLayer.addGisFeature(gisFeature);
			}
			else
			{
				defaultGisLayer.addGisFeature(gisFeature);
			}
		}

		public function removeGisFeature(gisFeature:GisFeature):void
		{
			if (defaultGisLayer.gisFeatures.contains(gisFeature))
			{
				defaultGisLayer.removeGisFeature(gisFeature);
			}
			else if (modelGisLayer.gisFeatures.contains(gisFeature))
			{
				modelGisLayer.removeGisFeature(gisFeature);
			}
		}

		public function removeAllGisFeature():void
		{
			clear();
		}

		/**
		 * 画点、线、面
		 * @param gisFeature
		 *
		 */
		public function addGisFeatureAt(gisFeature:GisFeature, index:int=0, isModelLayer:Boolean=false):void
		{

			if (isModelLayer)
			{
				modelGisLayer.addGisFeatureAt(gisFeature, index);
			}
			else
			{
				defaultGisLayer.addGisFeatureAt(gisFeature, index);
			}
		}

		public function getAllGisFeature():Array
		{
			return defaultGisLayer.gisFeatures.toArray();
		}

		public function panMap():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.panMap]才能发挥作用");
		}

		public function eyeMap():void
		{
			overViewGroup.visible=!overViewGroup.visible;
		}

		public function zoomInMap():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.zoomInMap]才能发挥作用");
		}

		public function zoomOutMap():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.zoomOutMap]才能发挥作用");
		}

		public function viewEntireMap():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.viewEntireMap]才能发挥作用");
		}

		public function printMap():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.printMap]才能发挥作用");
		}

		public function exportMap():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.exportMap]才能发挥作用");
		}

		public function selectMap():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.selectMap]才能发挥作用");
		}

		public function exportAsBitmapData():BitmapData
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.exportAsBitmapData]才能发挥作用");
		}

		public function viewRefresh():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.viewRefresh]才能发挥作用");
		}

		public function queryGisFeatureByAreaId(areaId:String, success:Function, failur:Function=null):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.queryGisFeatureByAreaId]才能发挥作用");
		}

		public function queryGisFeaturesByAreaIds(areaIds:Array, success:Function, failur:Function=null):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.queryGisFeaturesByAreaIds]才能发挥作用");
		}

		public function queryGisFeaturesBySqlWhereForFields(sqlWhere:String, outFields:Array, success:Function, failur:Function=null):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.queryGisFeaturesBySqlWhereForFields]才能发挥作用");
		}

		public function queryGisFeaturesBySqlWhere(sqlWhere:String, success:Function, failur:Function=null):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.queryGisFeaturesBySqlWhere]才能发挥作用");
		}

		public function queryBTSGisFeaturesByAreaIds(areaIds:Array, success:Function, failur:Function=null):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.queryBTSGisFeaturesByAreaIds]才能发挥作用");
		}

		public function queryNodeBGisFeaturesByAreaIds(areaIds:Array, success:Function, failur:Function=null):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.queryNodeBGisFeaturesByAreaIds]才能发挥作用");
		}

		public function queryNodeBGisFeaturesBySqlWhere(sqlWhere:String, success:Function, failur:Function=null):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.queryNodeBGisFeaturesBySqlWhere]才能发挥作用");
		}

		public function panTo(point:GisPoint):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.panTo]才能发挥作用");
		}

		public function set scale(value:Number):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.set scale]才能发挥作用");
		}

		public function get scale():Number
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.get scale]才能发挥作用");
		}

		public function set level(value:Number):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.set level]才能发挥作用");
		}

		public function get level():Number
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.get level]才能发挥作用");
		}

		public function zoomToScale(scale:Number, point:GisPoint):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.zoomToScale]才能发挥作用");
		}

		public function clear():void
		{
			defaultGisLayer.clear();
		}

		public function clearAll():void
		{
//			clear();
//			clearModelLayerGisFeatures();
			removeAllGisLayers();
		}

		public function clearModelLayerGisFeatures():void
		{
			modelGisLayer.clear();
		}

		public function mapChange(value:String):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.mapChange]才能发挥作用");
		}

		public function updateFeature(gisFeature:GisFeature):void
		{
			defaultGisLayer.updateFeature(gisFeature);
		}

		public function updateFeatureByLayerId(layerId:String, gisFeature:GisFeature):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.updateFeatureByLayerId]才能发挥作用");
		}

		public function updateModelFeature(gisFeature:GisFeature):void
		{
			modelGisLayer.updateFeature(gisFeature);
		}

		public function getGisFeatureById(id:String):GisFeature
		{
			return defaultGisLayer.getGisFeatureByID(id);
		}

		public function getModelFeatureById(id:String):GisFeature
		{
			return modelGisLayer.getGisFeatureByID(id);
		}

		public function visiableGisFeature(gisFeature:GisFeature, flag:Boolean=true):void
		{
			gisFeature.visible=flag;
			updateFeature(gisFeature);
		}

		public function addGisFeatureMenu(gisFeature:GisFeature, menuName:String=null, callback:Function=null):void
		{
			if (menuName)
			{
				if (!gisFeature.contentMenus)
				{
					gisFeature.contentMenus=new Array;
				}

				if (!isContainsMenu(menuName, gisFeature.contentMenus))
				{
					gisFeature.contentMenus.push(new GisContextMenuItem(menuName, callback));
				}
			}
		}

		public function addGisFeatureMenuByLayerId(laeryId:String, gisFeature:GisFeature, menuName:String=null, callback:Function=null):void
		{
			addGisFeatureMenu(gisFeature, menuName, callback);
		}

		public function drawLine():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.drawLine]才能发挥作用");
		}

		public function drawFreePolygon():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.drawFreePolygon]才能发挥作用");
		}

		public function drawRectangle():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.drawRectangle]才能发挥作用");
		}

		public function drawCircle():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.drawCircle]才能发挥作用");
		}

		public function drawPolygon():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.drawPolygon]才能发挥作用");
		}

		public function drawRegulPolyon():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.drawRegulPolyon]才能发挥作用");
		}

		public function drawBack():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.drawBack]才能发挥作用");
		}

		public function drawForward():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.drawForward]才能发挥作用");
		}
		
		public function drawConfig(configType:String):void{
			drawType = configType;
			if(lastDrawPoint.x==0 && lastDrawPoint.y==0){
				Alert.show("未指定中心点位置，选“是”点击地图设置中心点位置", "提示", Alert.YES | Alert.NO, null, function (event:CloseEvent) : void
				{
					if (event.detail == Alert.NO)
					{
//						showPropComp();
					}else{
						isLastDrawPointSet=true;
						control.dispatchMapEvent(new GisDrawEvent(GisDrawEvent.DRAWPOINTSELECT));
					}
				})
			}else{
				showPropComp();
			}
		}
		
		gis_internal function showPropComp():void{
			propComp.type = drawType;
			propComp.defaultPoint = lastDrawPoint;
			propComp.dispatchEvent(new PropertiesCompEvent(PropertiesCompEvent.VIEW_SHOW));
		}

		public function addGisLayer(gisLayer:ILayer, index:int=-1):String
		{
			if (index > 0)
			{
				layers.addItemAt(gisLayer, index);
			}
			else
			{
				layers.addItem(gisLayer);
			}
			return gisLayer.id;
		}

		public function selectFeaturesByLayerId(layerId:String, selectionMethod:String=GisFeatureLayer.SELECTION_NEW):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.selectFeaturesByLayerId]才能发挥作用");
		}

		/**
		 * 根据图层ID获取图层
		 * @param layerId
		 * @return
		 *
		 */
		public function getGisLayer(layerId:String):ILayer
		{
			for each (var layer:ILayer in layers)
			{
				if (layer.id == layerId)
				{
					return layer;
				}
			}
			return null;
		}

		public function moveGisLayer(layerId:String, index:int):void
		{
			removeGisLayer(getGisLayer(layerId));
		}

		public function removeAllGisLayers():void
		{
			for each (var layer:ILayer in layers)
			{
				if (layer != serviceGisLayer && layer != modelGisLayer && layer != defaultGisLayer)
				{
					removeGisLayer(layer);
				}
				else if (layer == modelGisLayer || layer == defaultGisLayer)
				{
					GisLayer(layer).clear();
				}
			}
		}

		/**
		 * 移除图层
		 * @param layerId
		 * @param index
		 *
		 */
		public function removeGisLayer(layer:ILayer):void
		{
			layers.removeItemAt(layers.getItemIndex(layer));
		}

		/**
		 * 在某图层增加对象 
		 * @param layerId
		 * @param gisFeature
		 * @param isfront
		 * @return 
		 * 
		 */		
		public function addGisFeatureByLayerId(layerId:String, gisFeature:GisFeature, isfront:Boolean=true):String
		{
			return addGisFeatureByLayerIdAt(layerId,gisFeature,-1);
		}

		public function addGisFeatureByLayerIdAt(layerId:String, gisFeature:GisFeature, index:int):String
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.addGisFeatureByLayerIdAt]才能发挥作用");
		}

		public function removeGisFeatureByLayerId(layerId:String, gisFeature:GisFeature):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.removeGisFeatureByLayerId]才能发挥作用");
		}

		public function removeGisFeatureByLayerIdAt(layerId:String, index:int):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.removeGisFeatureByLayerIdAt]才能发挥作用");
		}

		public function clearGisFeatureByLayerId(layerId:String):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.clearGisFeatureByLayerId]才能发挥作用");
		}

		public function showZHAPLayer(visible:Boolean=false):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.showZHAPLayer]才能发挥作用");
		}

		public function showZHCellLayer(visible:Boolean=false):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.showZHCellLayer]才能发挥作用");
		}

		public function showZHExcuseLayer(visible:Boolean=false):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.showZHExcuseLayer]才能发挥作用");
		}

		public function showZHGimscustomerLayer(visible:Boolean=false):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.showZHGimscustomerLayer]才能发挥作用");
		}

		public function showZHMachineroomLayer(visible:Boolean=false):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.showZHMachineroomLayer]才能发挥作用");
		}

		public function showZHUtrancellLayer(visible:Boolean=false):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.showZHUtrancellLayer]才能发挥作用");
		}

		public function showZHBTSLayer(visible:Boolean=false):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.showZHBTSLayer]才能发挥作用");
		}

		public function showZHNodeBLayer(visible:Boolean=false):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.showZHNodeBLayer]才能发挥作用");
		}

		public function get selectedable():Boolean
		{
			return _selectedable;
		}

		public function set selectedable(value:Boolean):void
		{
			_selectedable=value;
		}

		public function ruleMap():void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.ruleMap]才能发挥作用");
		}

		public function get gisExtent():GisExtent
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.get gisExtent]才能发挥作用");
		}

		public function set gisExtent(value:GisExtent):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.set gisExtent]才能发挥作用");
		}

		public function mapToStage(gisPoint:GisPoint):Point
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.mapToStage]才能发挥作用");
		}

		public function showWMSLayer(url:String):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.showWMSLayer]才能发挥作用");
		}

		public function hideWMSLayer(url:String):void
		{
			delete wmsLayers[url];
		}

		public function get mapUrl():String
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.get mapUrl]才能发挥作用");
		}

		public function get defaultGisLayer():GisLayer
		{
			return _defaultGisLayer;
		}

		public function set defaultGisLayer(value:GisLayer):void
		{
			_defaultGisLayer=value;
		}

		public function get modelGisLayer():GisLayer
		{
			return _modelGisLayer;
		}

		public function set modelGisLayer(value:GisLayer):void
		{
			_modelGisLayer=value;
		}

		public function get queryGisCache():Dictionary
		{
			return _queryGisCache;
		}

		public function set queryGisCache(value:Dictionary):void
		{
			_queryGisCache=value;
		}

		public function get ruleable():Boolean
		{
			return _ruleable;
		}

		public function set ruleable(value:Boolean):void
		{
			_ruleable=value;
		}

		public function get wmsLayers():Dictionary
		{
			return _wmsLayers;
		}

		public function set wmsLayers(value:Dictionary):void
		{
			_wmsLayers=value;
		}

		public function get minLeft():Number
		{
			return _minLeft;
		}

		public function set minLeft(value:Number):void
		{
			_minLeft=value;
		}

		public function get maxTop():Number
		{
			return _maxTop;
		}

		public function set maxTop(value:Number):void
		{
			_maxTop=value;
		}

		public function get maxRight():Number
		{
			return _maxRight;
		}

		public function set maxRight(value:Number):void
		{
			_maxRight=value;
		}

		public function get minBottom():Number
		{
			return _minBottom;
		}

		public function set minBottom(value:Number):void
		{
			_minBottom=value;
		}

		public function get step():Number
		{
			return _step;
		}

		public function set step(value:Number):void
		{
			_step=value;
		}

		public function get drawHis():Array
		{
			return _drawHis;
		}

		public function set drawHis(value:Array):void
		{
			_drawHis=value;
		}

		public function get overTarget():Object
		{
			return _overTarget;
		}

		public function set overTarget(value:Object):void
		{
			_overTarget=value;
		}

		public function getLayerInfosByLayerId(layerId:String):Array
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.getLayerInfosByLayerId]才能发挥作用");
		}

		public function clearSelectionByLayerId(layerId:String):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.clearSelectionByLayerId]才能发挥作用");
		}

		public function setVisibleLayersByLayerId(layerId:String):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.setVisibleLayersByLayerId]才能发挥作用");
		}

		public function queryFeaturesByLayerId(layerId:String, method:String=GisFeatureLayer.QUERY_NEW):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.queryFeaturesByLayerId]才能发挥作用");
		}

		public function updateLayer(layerId:String):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.updateLayer]才能发挥作用");
		}

		public function execute(task:BaseTask, responder:IResponder=null):AsyncToken
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.execute]才能发挥作用");
		}

		public function queryFeaturesByTextLabel(text:String, success:Function=null, layer:int=25, failure:Function=null):void
		{
			throw new IllegalOperationError("子类必须实现[BaseMap.queryFeaturesByTextLabel]才能发挥作用");
		}

		public function updateScaleBarDisplay(scaleBar:ScaleBar):void
		{
			scaleBarGroup=new Group();
			addChild(scaleBarGroup);
		}

		public function updateZoomSliderDisplay(zoomSlider:ZoomSliderBar):void
		{
			zoomSliderGroup=new Group();
			addChild(zoomSliderGroup);
		}

		public function updateOverViewToolDisplay(overViewTool:OverViewTool):void
		{
			overViewGroup=new Group();
			addChild(overViewGroup);
		}

		public function get layers():ArrayCollection
		{
			return _layers;
		}

		public function set layers(value:ArrayCollection):void
		{
			_layers=value;
		}

		public function get serviceGisLayer():GisServiceLayer
		{
			return _serviceGisLayer;
		}

		public function set serviceGisLayer(value:GisServiceLayer):void
		{
			_serviceGisLayer=value;
		}

		public function get config():IMapConfig
		{
			return _config;
		}

		public function set config(value:IMapConfig):void
		{
			_config=value;
		}

		public function get control():IMapControl
		{
			return _control;
		}

		public function set control(value:IMapControl):void
		{
			_control=value;
		}

		public function get propComp():PropertiesComp
		{
			return _propComp;
		}

		public function set propComp(value:PropertiesComp):void
		{
			_propComp = value;
		}

		public function get lastDrawPoint():GisPoint
		{
			return _lastDrawPoint;
		}

		public function set lastDrawPoint(value:GisPoint):void
		{
			_lastDrawPoint = value;
		}

		public function get drawToolGisLayer():GisLayer
		{
			return _drawToolGisLayer;
		}

		public function set drawToolGisLayer(value:GisLayer):void
		{
			_drawToolGisLayer = value;
		}

		public function get dirty():Boolean
		{
			return _dirty;
		}

		public function set dirty(value:Boolean):void
		{
			_dirty = value;
		}

		public function get metersPerPixel():Number
		{
			return _metersPerPixel;
		}

		public function set metersPerPixel(value:Number):void
		{
			_metersPerPixel = value;
		}

		public function getCirclePoints(centerPoint:GisPoint,radius:Number,sides:Number):Array{
			throw new IllegalOperationError("子类必须实现[BaseMap.getCirclePoints]才能发挥作用");
		}
	}
}