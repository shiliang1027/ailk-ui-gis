package com.ailk.common.ui.gis.core
{
	import com.ailk.common.ui.gis.core.styles.GisStyle;
	import com.ailk.common.ui.gis.core.task.BaseTask;
	import com.ailk.common.ui.gis.core.task.GisIdentifyParameters;
	import com.ailk.common.ui.gis.core.task.GisIdentifyTask;

	/**
	 * GIS图层
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-8-3 下午04:24:15
	 * @category com.ailk.common.ui.gis.core
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisLayer extends BaseLayer
	{
		public var isFeatureMouseOver:Boolean;
		public var isFront:Boolean;
		/**
		 * 获取或设置当地图可视范围发生变化时否实时更新要素图层 GisLayer。  
		 */		
		public var isRealtimeRefresh:Boolean;
		/**
		 * 是否对 GisLayer 上不在可视范围内的要素 gisFeatures 进行裁剪，即对不在可视范围内的要素不进行绘制 
		 */		
		public var isViewportClip:Boolean;
		public var numFeatures:int;
		
		private var _queryTask:BaseTask;
		private var _gisStyle:GisStyle;
		private var _featureContextMenus:Array;
		private var _featureOnClick:Function;
		private var _featureOnMouseOver:Function;
		private var _featureOnMouseOut:Function;
		
		public function GisLayer(url:String=null,mode:String="new",layerIds:Array=null,layerOption:String="all")
		{
			if(url){
				var gisQueryParam:GisIdentifyParameters = new GisIdentifyParameters();
				gisQueryParam.tolerance=3;
				gisQueryParam.returnGisMetry=true;
				gisQueryParam.layerIds = layerIds;
				gisQueryParam.layerOption = layerOption;
				
				queryTask = new GisIdentifyTask();
				queryTask.url = url;
				GisIdentifyTask(queryTask).identifyParameters = gisQueryParam;
			}
			super();
		}
		
		public function addGisFeatureAt(gisFeature:GisFeature, index:int):String{
			return addGisFeature(gisFeature);
		}
		
		public function removeGisFeatureAt(index:int):void{
			
		}
		
		
		public function getGisFeatureAt(index:int):GisFeature{
			return null;
		}
		
		public function getGisFeatureIndex(gisFeature:GisFeature):int{
			return gisFeature.index;
		}
		
		public function moveGisFeature(gisFeature:GisFeature, index:int):void{
		}
		
		public function moveGisFeatureAt(fromIndex:int, toIndex:int):void{
			
		}
		
		public function moveToTop(gisFeature:GisFeature):void{
			
		}
		
		public function selectFeatures(selectionMethod:String="new"):void{
			if(map){
				map.selectFeaturesByLayerId(id,selectionMethod);
			}
		}
		
		public function updateFeature(gisFeature:GisFeature):void{
			if(map){
				map.updateFeatureByLayerId(id,gisFeature);
			}
		}
		
		public function addGisFeatureMenu(gisFeature:GisFeature,menuName:String=null,callback:Function=null):void{
			if(map){
				map.addGisFeatureMenuByLayerId(id,gisFeature,menuName,callback);
			}
		}
		
		public function clearSelection():void{
			if(map){
				map.clearSelectionByLayerId(id);
//				for(var gisFeatureId:* in gisFeatures){
//					delete gisFeatures[gisFeatureId];
//				}
			}
		}
		
		public function get queryTask():BaseTask
		{
			return _queryTask;
		}

		public function set queryTask(value:BaseTask):void
		{
			_queryTask = value;
		}

		public function get gisStyle():GisStyle
		{
			return _gisStyle;
		}

		public function set gisStyle(value:GisStyle):void
		{
			_gisStyle = value;
		}

		public function get featureContextMenus():Array
		{
			return _featureContextMenus;
		}

		public function set featureContextMenus(value:Array):void
		{
			_featureContextMenus = value;
		}

		public function get featureOnClick():Function
		{
			return _featureOnClick;
		}

		public function set featureOnClick(value:Function):void
		{
			_featureOnClick = value;
		}

		public function get featureOnMouseOver():Function
		{
			return _featureOnMouseOver;
		}

		public function set featureOnMouseOver(value:Function):void
		{
			_featureOnMouseOver = value;
		}

		public function get featureOnMouseOut():Function
		{
			return _featureOnMouseOut;
		}

		public function set featureOnMouseOut(value:Function):void
		{
			_featureOnMouseOut = value;
		}
		
		override public function set visible(value:Boolean):void{
			super.visible = value;
			if(map){
				map.updateLayer(id);
			}
		}

	}
}