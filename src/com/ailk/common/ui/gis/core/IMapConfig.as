package com.ailk.common.ui.gis.core
{
	/**
	 * 地图配置接口
	 * @author shiliang
	 * 
	 */	
	public interface IMapConfig
	{
		function init():void;
		function getMapConfig(mid:String):Object;
		function get configUrl():String;
		function set configUrl(value:String):void;
		function get cachedable():Boolean;
		function set cachedable(value:Boolean):void;
		
		function get showToolBar():Boolean;
		function set showToolBar(value:Boolean):void;
		
		function get showZoomSlider():Boolean;
		function set showZoomSlider(value:Boolean):void;
		
		function get showOverView():Boolean;
		function set showOverView(value:Boolean):void;
		
		function get showDrawToolBar():Boolean;
		function set showDrawToolBar(value:Boolean):void;
		
		function get defaultMapId():String;
		function set defaultMapId(value:String):void;
		
		function get serviceType():String;
		function set serviceType(value:String):void;
		
		function get serviceLayerAlpha():Number;
		function set serviceLayerAlpha(value:Number):void;
		
		/**
		 * 是否鼠标滚轮缩放地图 
		 * @return 
		 * 
		 */
		function get scrollWheelZoomEnabled():Boolean;
		function set scrollWheelZoomEnabled(value:Boolean):void;
		
		/**
		 * 是否鼠标双击缩放地图 
		 * @return 
		 * 
		 */
		function get doubleClickZoomEnabled():Boolean;
		function set doubleClickZoomEnabled(value:Boolean):void;
	}
}