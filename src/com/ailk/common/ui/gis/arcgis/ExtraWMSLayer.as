package com.ailk.common.ui.gis.arcgis
{
	import com.esri.ags.Units;
	import com.esri.ags.layers.DynamicMapServiceLayer;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	/**
	 * 扩展图层,可根据可视区域生成相应图层图片
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-8-26 下午04:30:57
	 * @category com.linkage.gis.arcgis
	 * @copyright 南京联创科技 网管开发部
	 */
	public class ExtraWMSLayer extends DynamicMapServiceLayer
	{
		
		private var _params:URLVariables;
		private var _urlRequest:URLRequest;
		private var _url:String;
		
		public function ExtraWMSLayer(url:String)
		{
			super();
			setLoaded(true);
			_params = new URLVariables();
			_params.transparent = true;
			_params.format = "png8";
			if(url){
				this._url = url;
				_urlRequest = new URLRequest(this._url);
				_urlRequest.data = _params;
			}
		}
		
		override public function get units():String
		{
			return Units.DECIMAL_DEGREES;
		}
		
		override protected function loadMapImage(loader:Loader):void
		{
			// update changing values
			_params.bbox = map.extent.xmin + "," + map.extent.ymin + "," + map.extent.xmax + "," + map.extent.ymax;
			_params.size=map.width+","+map.height;
			_params.f="image";
			_params.bboxSR = map.spatialReference.wkid;
			_params.imageSR = map.spatialReference.wkid;
			_params.layerDefs = "0";
			loader.load(_urlRequest);
		}
	}
}