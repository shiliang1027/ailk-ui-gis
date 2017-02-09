package com.ailk.common.ui.gis
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.core.gis_internal;
	import com.ailk.common.ui.gis.event.MapEvent;
	import com.ailk.common.ui.gis.exception.GisException;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectProxy;

	use namespace gis_internal;
	/**
	 * 读取地图配置类
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-7-2 上午10:00:33
	 * @category com.linkage.gis
	 * @copyright 南京联创科技 网管开发部
	 */
	public class ViewConfig
	{
		private static var log:ILogger = Log.getLoggerByClass(ViewConfig);
		gis_internal var config:Object;
		private var mw:MapWork;
		public function ViewConfig(mw:MapWork)
		{
			config = new Object;
			this.mw = mw;
		}
		gis_internal function readConfig():void{
			var service:HTTPService = new HTTPService();
			service.url = "xml/map_config.xml";
			service.method="POST";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void{
				var result:XML=event.result as XML;
				if(result.hasOwnProperty("@def")){
					for each(var map:XML in result.map){
						if(map.@type == result.@def){
							Constants.ConfigBaseUrl = String(map.@configBaseUrl);
						}
					}
					readGisConfig();
				}
			});
			service.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
				throw new GisException(ResourceManager.getInstance().getString(Constants.GisResource,"ERROR_MAPCONFIG"));
			});
			service.send();
		}
		
		
		private function readGisConfig():void{
			var service:HTTPService = new HTTPService();
			service.url = Constants.ConfigBaseUrl+"gis_config.xml";
			service.method="POST";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void{
				var result:XML=event.result as XML;
				if(!result.hasOwnProperty("@def")){
					throw new GisException(ResourceManager.getInstance().getString(Constants.GisResource, "ERROR_GISID"));
				}
				//			log.debug("【viewConfig】result:{0},def:{1}",result,result.@def);
				config.type=result.@def;
				var configUrl:Object=new Object();
				var isExist:Boolean=false;
				
				for each(var map:XML in result.map){
					configUrl[map.@type]=map.@configUrl;
					//				log.debug("【viewConfig】map.@type:{0},map.@configUrl:{1}",map.@type,map.@configUrl);
					if(map.@type == config.type){
						isExist=true;
					}
				}
				if(!isExist){
					throw new GisException(ResourceManager.getInstance().getString(Constants.GisResource, "ERROR_GISIDEXIST",[config.type]));
				}
				config.configUrl=configUrl;
				mw.dispatchEvent(new MapEvent(MapEvent.MAP_VIEWCONFIG_INIT_COMPLETE));
			});
			service.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{
				log.error(event);
				throw new GisException(ResourceManager.getInstance().getString(Constants.GisResource,"ERROR_GISCONFIG"));
			});
			service.send();
		}
//		private function resultHandler(event:ResultEvent):void
//		{
//			var result:XML=event.result as XML;
//			if(!result.hasOwnProperty("@def")){
//				throw new GisException(ResourceManager.getInstance().getString(Constants.GisResource, "ERROR_GISID"));
//			}
////			log.debug("【viewConfig】result:{0},def:{1}",result,result.@def);
//			config.type=result.@def;
//			var configUrl:Object=new Object();
//			var isExist:Boolean=false;
//
//			for each(var map:XML in result.map){
//				configUrl[map.@type]=Constants.ConfigBaseUrl+map.@configUrl;
////				log.debug("【viewConfig】map.@type:{0},map.@configUrl:{1}",map.@type,map.@configUrl);
//				if(map.@type == config.type){
//					isExist=true;
//				}
//			}
//			if(!isExist){
//				throw new GisException(ResourceManager.getInstance().getString(Constants.GisResource, "ERROR_GISIDEXIST",[config.type]));
//			}
//			config.configUrl=configUrl;
//			mw.dispatchEvent(new MapEvent(MapEvent.MAP_VIEWCONFIG_INIT_COMPLETE));
//		}
//		
//		private function faultHandler(event:FaultEvent):void{
//			log.error(event);
//			throw new GisException(ResourceManager.getInstance().getString(Constants.GisResource,"ERROR_GISCONFIG"));
//		}
	}
}