package com.ailk.common.ui.gis.core
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	
	import flash.utils.Dictionary;

	/**
	 * 上下文工具类
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-5-9 下午06:24:11
	 * @category com.ailk.common.ui.gis.core
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisContextUtil
	{
		
		private static var log:ILogger = Log.getLogger("com.ailk.common.ui.gis.core.ContextUtil");
		private static var contextMap:Dictionary = new Dictionary();
		public function GisContextUtil()
		{
		}
		
		public static function getBean(beanId:String):*{
			return contextMap[beanId];
		}
		
		public static function setBean(beanId:String,bean:*):void{
			contextMap[beanId]=bean;
			log.debug("ContextUtil.setBean,beanId:{0},bean:{1},contextMap[{2}]:{3}",beanId,bean,beanId,contextMap[beanId]);
		}
	}
}