package com.ailk.common.ui.gis.core
{
	import com.ailk.common.ui.gis.core.metry.GisCircle;
	import com.ailk.common.ui.gis.core.metry.GisExtent;
	import com.ailk.common.ui.gis.core.metry.GisPoint;
	import com.ailk.common.ui.gis.core.task.BaseTask;
	import com.ailk.common.ui.gis.tools.OverViewTool;
	import com.ailk.common.ui.gis.tools.ScaleBar;
	import com.ailk.common.ui.gis.tools.ZoomSliderBar;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	/**
	 * 地图接口
	 * @author shiliang
	 *
	 */
	public interface IMap
	{
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 绘制点、线、面
		 * @param gisFeature
		 *
		 */
		function addGisFeature(gisFeature:GisFeature, isModelLayer:Boolean=false):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 删除点、线、面
		 * @param gisFeature
		 *
		 */
		function removeGisFeature(gisFeature:GisFeature):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 删除所有点、线、面
		 *
		 */
		function removeAllGisFeature():void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 *
		 * @param gisFeature
		 * @param index
		 *
		 */
		function addGisFeatureAt(gisFeature:GisFeature, index:int=0, inModelLayer:Boolean=false):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 返回所有点线面数组
		 * @return
		 *
		 */
		function getAllGisFeature():Array;
		/**
		 * 移动地图
		 *
		 */
		function panMap():void;
		/**
		 * 打开关闭按钮
		 *
		 */
		function eyeMap():void;
		/**
		 * 缩小
		 *
		 */
		function zoomInMap():void;
		/**
		 * 放大
		 *
		 */
		function zoomOutMap():void;
		/**
		 * 全显
		 *
		 */
		function viewEntireMap():void;
		/**
		 * 打印
		 *
		 */
		function printMap():void;
		/**
		 * 导出
		 *
		 */
		function exportMap():void;
		/**
		 *
		 *
		 */
		function selectMap():void;
		/**
		 * 获取地图位图数据
		 * @return
		 *
		 */
		function exportAsBitmapData():BitmapData;
		/**
		 * 刷新地图视图区域，自动展示地图要素区域
		 *
		 */
		function viewRefresh():void;
		/**
		 * 根据区域ID取面对象
		 * @param areaId
		 * @param success
		 * @param failur
		 *
		 */
		function queryGisFeatureByAreaId(areaId:String, success:Function, failur:Function=null):void;
		/**
		 * 根据区域ID数组取区域对象 集合
		 * @param areaIds
		 * @param success
		 * @param failur
		 *
		 */
		function queryGisFeaturesByAreaIds(areaIds:Array, success:Function, failur:Function=null):void;
		/**
		 * 根据SQL条件查询区域对象集合
		 * @param sqlWhere
		 * @param success
		 * @param failur
		 *
		 */
		function queryGisFeaturesBySqlWhere(sqlWhere:String, success:Function, failur:Function=null):void;
		/**
		 * 根据SQL条件查询区域对象集合
		 * @param sqlWhere
		 * @param success
		 * @param failur
		 *
		 */
		function queryGisFeaturesBySqlWhereForFields(sqlWhere:String, outFields:Array, success:Function, failur:Function=null):void;
		/**
		 * 根据GisID查询BTS泰森多边形对象
		 * @param areaIds
		 * @param success
		 * @param failur
		 *
		 */
		function queryBTSGisFeaturesByAreaIds(areaIds:Array, success:Function, failur:Function=null):void;
		/**
		 * 根据GisID查询NodeB泰森多边形对象
		 * @param areaIds
		 * @param success
		 * @param failur
		 *
		 */
		function queryNodeBGisFeaturesByAreaIds(areaIds:Array, success:Function, failur:Function=null):void;
		/**
		 * 根据SQL条件查询NodeB泰森多边形对象
		 * @param sqlWhere
		 * @param success
		 * @param failur
		 *
		 */
		function queryNodeBGisFeaturesBySqlWhere(sqlWhere:String, success:Function, failur:Function=null):void;
		/**
		 * 移动到指定点
		 * @param point
		 *
		 */
		function panTo(point:GisPoint):void;
		/**
		 * 设置比例尺
		 * @param value
		 *
		 */
		function set scale(value:Number):void;
		/**
		 * 获取比例尺
		 * @return
		 *
		 */
		function get scale():Number;
		/**
		 * 设置比例度
		 * @param value
		 *
		 */
		function set level(value:Number):void;
		/**
		 * 获取比例度
		 * @return
		 *
		 */
		function get level():Number;
		/**
		 * 以指定点缩放比例尺
		 * @param scale
		 * @param point
		 *
		 */
		function zoomToScale(scale:Number, point:GisPoint):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 清空默认图层中对象
		 *
		 */
		function clear():void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 清空所有图层中对象
		 *
		 */
		function clearAll():void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 删除蒙版层上所有对象
		 *
		 */
		function clearModelLayerGisFeatures():void;
		/**
		 * 地图切换
		 * @param value
		 *
		 */
		function mapChange(value:String):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 更新点、线、面
		 * @param gisFeature
		 *
		 */
		function updateFeature(gisFeature:GisFeature):void;
		/**
		 * 根据图层ID更新该图层中点、线、面对象
		 * @param layerId
		 * @param gisFeature
		 *
		 */
		function updateFeatureByLayerId(layerId:String, gisFeature:GisFeature):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 更新蒙版层点、线、面
		 * @param gisFeature
		 *
		 */
		function updateModelFeature(gisFeature:GisFeature):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 根据对象ID得到该对象
		 * @param id
		 * @return
		 *
		 */
		function getGisFeatureById(id:String):GisFeature;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 *  根据对象ID得到蒙版层中该对象
		 * @param id
		 * @return
		 *
		 */
		function getModelFeatureById(id:String):GisFeature;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 显隐点、线、面对象
		 * @param gisFeature
		 * @param flag
		 *
		 */
		function visiableGisFeature(gisFeature:GisFeature, flag:Boolean=true):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * GisFeature添加右键菜单
		 * @param gisFeature
		 * @param menuName
		 * @param callback
		 *
		 */
		function addGisFeatureMenu(gisFeature:GisFeature, menuName:String=null, callback:Function=null):void;
		/**
		 * 给某图层中GisFeature添加右键菜单
		 * @param laeryId
		 * @param gisFeature
		 * @param menuName
		 * @param callback
		 *
		 */
		function addGisFeatureMenuByLayerId(laeryId:String, gisFeature:GisFeature, menuName:String=null, callback:Function=null):void;
		/**
		 * 绘制线
		 *
		 */
		function drawLine():void;
		/**
		 * 绘制自由多边形
		 *
		 */
		function drawFreePolygon():void;
		/**
		 * 绘制矩形
		 *
		 */
		function drawRectangle():void;
		/**
		 * 绘制圆
		 *
		 */
		function drawCircle():void;
		/**
		 * 绘制面
		 *
		 */
		function drawPolygon():void;
		/**
		 * 绘制正多边形
		 *
		 */
		function drawRegulPolyon():void;
		/**
		 * 后退绘制操作
		 *
		 */
		function drawBack():void;
		/**
		 * 前进绘制操作
		 *
		 */
		function drawForward():void;
		/**
		 * 设置绘制参数 
		 * 
		 */		
		function drawConfig(configType:String):void;
		/**
		 * 添加图层
		 * @param gisLayer
		 * @param index
		 * @return
		 *
		 */
		function addGisLayer(gisLayer:ILayer, index:int=-1):String;
		/**
		 * 获取图层
		 * @param layerId
		 * @return
		 *
		 */
		function getGisLayer(layerId:String):ILayer;
		/**
		 * 移动图层
		 * @param layerId
		 * @param index
		 *
		 */
		function moveGisLayer(layerId:String, index:int):void;
		/**
		 * 删除所有图层
		 *
		 */
		function removeAllGisLayers():void;
		/**
		 * 删除某图层
		 * @param layer
		 *
		 */
		function removeGisLayer(layer:ILayer):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 给某图层添加对象
		 * @param layerId
		 * @param gisFeature
		 * @param isfront
		 * @return
		 *
		 */
		function addGisFeatureByLayerId(layerId:String, gisFeature:GisFeature, isfront:Boolean=true):String;
		/**
		 * 给某图层在某位置添加对象
		 * @param layerId
		 * @param gisFeature
		 * @param index
		 * @return
		 *
		 */
		function addGisFeatureByLayerIdAt(layerId:String, gisFeature:GisFeature, index:int):String;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisLayer")]
		/**
		 * 删除某图层对象
		 * @param layerId
		 * @param gisFeature
		 *
		 */
		function removeGisFeatureByLayerId(layerId:String, gisFeature:GisFeature):void;
		/**
		 * 根据某位置删除某图层对象
		 * @param layerId
		 * @param index
		 *
		 */
		function removeGisFeatureByLayerIdAt(layerId:String, index:int):void;
		/**
		 * 清空某图层对象
		 * @param layerId
		 *
		 */
		function clearGisFeatureByLayerId(layerId:String):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisWMSLayer")]
		function showZHAPLayer(visible:Boolean=false):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisWMSLayer")]
		function showZHCellLayer(visible:Boolean=false):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisWMSLayer")]
		function showZHExcuseLayer(visible:Boolean=false):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisWMSLayer")]
		function showZHGimscustomerLayer(visible:Boolean=false):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisWMSLayer")]
		function showZHMachineroomLayer(visible:Boolean=false):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisWMSLayer")]
		function showZHUtrancellLayer(visible:Boolean=false):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisWMSLayer")]
		/**
		 * 显示综合呈现的BTS图层
		 * @param visible
		 *
		 */
		function showZHBTSLayer(visible:Boolean=false):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisWMSLayer")]
		/**
		 * 显示综合呈现的NodeB图层
		 * @param visible
		 *
		 */
		function showZHNodeBLayer(visible:Boolean=false):void;

		function get selectedable():Boolean;

		function set selectedable(value:Boolean):void;

		function ruleMap():void;

		function get gisExtent():GisExtent;

		function set gisExtent(value:GisExtent):void;

		function mapToStage(gisPoint:GisPoint):Point;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisWMSLayer")]
		/**
		 * 根据url显示图片图层
		 * @param url
		 *
		 */
		function showWMSLayer(url:String):void;
		[Deprecated(replacement="com.ailk.common.ui.gis.core.GisWMSLayer")]
		/**
		 * 根据url隐藏图片图层
		 * @param url
		 *
		 */
		function hideWMSLayer(url:String):void;

		function get mapUrl():String;

		/**
		 *
		 * @param layerId
		 * @param query
		 *
		 */
		function selectFeaturesByLayerId(layerId:String, selectionMethod:String="new"):void;
		/**
		 *
		 * @param layerId
		 * @return
		 *
		 */
		function getLayerInfosByLayerId(layerId:String):Array;
		/**
		 *
		 * @param layerId
		 *
		 */
		function clearSelectionByLayerId(layerId:String):void;

		function setVisibleLayersByLayerId(layerId:String):void;

		function queryFeaturesByLayerId(layerId:String, method:String="new"):void;

		function updateLayer(layerId:String):void;

		/**
		 * 执行任务
		 * @param task
		 * @param responder
		 * @return
		 *
		 */
		function execute(task:BaseTask, responder:IResponder=null):AsyncToken;
		/**
		 * 根据名称查询GIS元素
		 * @param text
		 * @param success 成功回调
		 * @param layer 默认25为地名层
		 * @param failure 失败回调
		 *
		 */
		function queryFeaturesByTextLabel(text:String, success:Function=null, layer:int=25, failure:Function=null):void;
	
		function updateScaleBarDisplay(scaleBar:ScaleBar):void;
		
		function updateZoomSliderDisplay(zoomSlider:ZoomSliderBar):void;
		
		function updateOverViewToolDisplay(overViewTool:OverViewTool):void;
		
		function get lastDrawPoint():GisPoint;
		
		function set lastDrawPoint(value:GisPoint):void;
		
		function get defaultGisLayer():GisLayer;
		
		function set drawToolGisLayer(value:GisLayer):void;
		
		function getCirclePoints(centerPoint:GisPoint,radius:Number,sides:Number):Array
	}
}