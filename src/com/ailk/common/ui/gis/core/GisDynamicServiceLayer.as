package com.ailk.common.ui.gis.core
{
	import mx.collections.ArrayCollection;

	/**
	 * 图层对象
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-5-3 下午03:36:50
	 * @category com.linkage.gis.core
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisDynamicServiceLayer extends BaseLayer
	{
		private var _url:String;
		private var _visibleLayers:ArrayCollection;
		private var _layerInfos:Array;
		
		public function GisDynamicServiceLayer(url:String=null,visibleLayers:ArrayCollection=null)
		{
			this.url = url;
			this.visibleLayers = visibleLayers;
			super();
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}
		
		public function get visibleLayers():ArrayCollection
		{
			return _visibleLayers;
		}
		
		public function set visibleLayers(value:ArrayCollection):void
		{
			_visibleLayers = value;
			if(map){
				try{
					map.setVisibleLayersByLayerId(id);
				}catch(e:Error){}
				
			}
			
		}

		
		[Bindable]
		public function get layerInfos():Array
		{
			if(map){
				return map.getLayerInfosByLayerId(id);
			}
			return null
		}
		
		public function set layerInfos(value:Array):void
		{
			_layerInfos = value;
		}

		override public function toString():String{
			return super.toString()+",url:"+this.url+",visibleLayers:"+visibleLayers;
		}

	}
}