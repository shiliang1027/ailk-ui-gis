package com.ailk.common.ui.gis.core
{
	import com.ailk.common.ui.gis.Constants;
	import com.ailk.common.ui.gis.exception.GisException;
	
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	use namespace gis_internal;
	/**
	 * 基本配置读取类
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
	public class BaseConfig implements IMapConfig
	{
		private var _configUrl:String;
		private var _cachedable:Boolean;
		private var _showToolBar:Boolean;
		private var _showZoomSlider:Boolean;
		private var _showOverView:Boolean;
		private var _showDrawToolBar:Boolean;
		private var _defaultMapId:String;
		private var _control:IMapControl;
		private var _scrollWheelZoomEnabled:Boolean;
		private var _doubleClickZoomEnabled:Boolean;
		private var _serviceType:String;
		private var _serviceLayerAlpha:Number;
		private var _mapArray:Array=new Array();
		
		public function BaseConfig(control:IMapControl)
		{
			this.control = control;
		}
		
		public function init():void
		{
			var service:HTTPService=new HTTPService();
			service.url=configUrl;
			service.method="POST";
			service.resultFormat="e4x";
			service.addEventListener(ResultEvent.RESULT, resultHandler);
			service.addEventListener(FaultEvent.FAULT, faultHandler);
			service.send();
		}
		protected function resultHandler(event:ResultEvent):void
		{
			var result:XML=event.result as XML;
			if((result.maps as XMLList).hasOwnProperty("@def")){
				_defaultMapId=result.maps.@def;
			}else{
				throw new GisException(ResourceManager.getInstance().getString(Constants.GisResource, "ERROR_MAPID",[configUrl]));
			}
		}
		
		protected function faultHandler(event:FaultEvent):void
		{
			throw new GisException(ResourceManager.getInstance().getString(Constants.GisResource, "ERROR_MAPURLCONFIG", [configUrl]));
		}
		
		public function getMapConfig(id:String):Object
		{
			return mapArray[id];
		}
		
		public function get configUrl():String
		{
			return this._configUrl;
		}
		
		public function set configUrl(value:String):void
		{
			this._configUrl = value;
		}
		
		public function get cachedable():Boolean
		{
			return this._cachedable;
		}
		
		public function set cachedable(value:Boolean):void
		{
			this._cachedable = value;
		}
		
		public function get showToolBar():Boolean
		{
			return this._showToolBar;
		}
		
		public function set showToolBar(value:Boolean):void
		{
			this._showToolBar=value;
		}
		
		public function get showZoomSlider():Boolean
		{
			return this._showZoomSlider;
		}
		
		public function set showZoomSlider(value:Boolean):void
		{
			this._showZoomSlider = value;
		}
		
		public function get showOverView():Boolean
		{
			return this._showOverView;
		}
		
		public function set showOverView(value:Boolean):void
		{
			this._showOverView = value;
		}
		
		public function get showDrawToolBar():Boolean
		{
			return this._showDrawToolBar;
		}
		
		public function set showDrawToolBar(value:Boolean):void
		{
			this._showDrawToolBar = value;
		}
		
		public function get defaultMapId():String
		{
			return this._defaultMapId;
		}
		
		public function set defaultMapId(value:String):void
		{
			this._defaultMapId=value;
		}
		
		public function get serviceType():String
		{
			return this._serviceType;
		}
		
		public function set serviceType(value:String):void
		{
			this._serviceType=value;
		}
		
		public function get scrollWheelZoomEnabled():Boolean
		{
			return this._scrollWheelZoomEnabled;
		}
		
		public function set scrollWheelZoomEnabled(value:Boolean):void
		{
			this._scrollWheelZoomEnabled=value;
		}
		
		public function get doubleClickZoomEnabled():Boolean
		{
			return this._doubleClickZoomEnabled;
		}
		
		public function set doubleClickZoomEnabled(value:Boolean):void
		{
			this._doubleClickZoomEnabled=value;
		}

		public function get mapArray():Array
		{
			return _mapArray;
		}

		public function set mapArray(value:Array):void
		{
			_mapArray = value;
		}

		public function get control():IMapControl
		{
			return _control;
		}

		public function set control(value:IMapControl):void
		{
			_control = value;
		}

		public function get serviceLayerAlpha():Number{
			return this._serviceLayerAlpha;
		}
		public function set serviceLayerAlpha(value:Number):void{
			this._serviceLayerAlpha=value;
		}

	}
}