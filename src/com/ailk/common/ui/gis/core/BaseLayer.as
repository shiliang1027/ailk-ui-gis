package com.ailk.common.ui.gis.core
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.utils.UIDUtil;

	[DefaultProperty("id")]
	[DefaultProperty("gisFeatures")]
	/**
	 * 图层基础类
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-5-3 下午02:07:12
	 * @category com.linkage.gis.core
	 * @copyright 南京联创科技 网管开发部
	 */
	public class BaseLayer implements ILayer
	{
		private static var log:ILogger=Log.getLoggerByClass(BaseLayer);
		private var _id:String;
		private var _map:IMap;
		private var _visible:Boolean=true;
		private var _alpha:Number=1;

		private var _gisFeatures:ArrayCollection=new ArrayCollection();

		public function BaseLayer()
		{
			if(!id){
				id=UIDUtil.createUID();
			}
			gisFeatures.addEventListener(CollectionEvent.COLLECTION_CHANGE, onGisFeatureChangeHandler);
		}

		protected function onGisFeatureChangeHandler(event:CollectionEvent):void
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
				case CollectionEventKind.REPLACE:
					log.debug("[onGisFeatureChangeHandler]REPLACE");
					break;
			}
		}

		protected function onCollectionAddHandler(event:CollectionEvent):void
		{
			if (map)
			{
				for each (var gisFeature:GisFeature in event.items)
				{
					map.addGisFeatureByLayerIdAt(id, gisFeature, event.location);
				}
			}
		}

		protected function onCollectionRemoveHandler(event:CollectionEvent):void
		{
			if (map)
			{
				for each (var gisFeature:GisFeature in event.items)
				{
					map.removeGisFeatureByLayerIdAt(id, event.location);
				}
			}
		}

		private function onCollectionRefreshAndResetHandler(event:CollectionEvent):void
		{
			if (map)
			{
				map.clearGisFeatureByLayerId(id);
				for each (var gisFeature:GisFeature in gisFeatures)
				{
					map.addGisFeatureByLayerIdAt(id, gisFeature, gisFeatures.getItemIndex(gisFeature));
				}
			}
		}

		public function getGisFeatureByID(id:String):GisFeature
		{
			for each (var gisFeature:GisFeature in gisFeatures)
			{
				if (gisFeature.id == id)
				{
					return gisFeature;
				}
			}
			return null;
		}

		public function addGisFeature(gisFeature:GisFeature, isfront:Boolean=true):String
		{
			if (!gisFeatures.contains(gisFeature))
			{
				gisFeatures.addItem(gisFeature);
			}
			return gisFeature.id;
		}

		public function removeGisFeature(gisFeature:GisFeature):GisFeature
		{
			if (gisFeatures.contains(gisFeature))
			{
				gisFeatures.removeItemAt(gisFeatures.getItemIndex(gisFeature));
			}
			return gisFeature;
		}

		public function clear():void
		{
			gisFeatures.removeAll();
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id=value;
		}

		public function get map():IMap
		{
			return _map;
		}

		public function set map(value:IMap):void
		{
			_map=value;
		}

		public function get gisFeatures():ArrayCollection
		{
			return _gisFeatures;
		}
		[Inspectable(category="General", arrayType="com.ailk.common.ui.gis.core.GisFeature")]
		public function set gisFeatures(value:ArrayCollection):void
		{
			log.debug("[gisFeatures]{0}",value);
			_gisFeatures.removeEventListener(CollectionEvent.COLLECTION_CHANGE,onGisFeatureChangeHandler);
			_gisFeatures=value;
			_gisFeatures.addEventListener(CollectionEvent.COLLECTION_CHANGE, onGisFeatureChangeHandler);
			var evt:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			evt.kind = CollectionEventKind.RESET;
			_gisFeatures.dispatchEvent(evt);
		}

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible=value;
		}
		
		public function get alpha():Number{
			return this._alpha;
		}
		public function set alpha(value:Number):void{
			this._alpha = value;
		}

		public function toString():String
		{
			var str:String="id=" + id + ",map=" + map + "gisFeatures[";
			for each (var gisFeature:GisFeature in gisFeatures)
			{
				str+=gisFeature.id;
			}
			str+="]";
			return str;
		}


	}
}