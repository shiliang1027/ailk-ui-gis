package com.ailk.common.ui.gis.core.task
{
	import flash.events.EventDispatcher;

	/**
	 * 任务基类
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-5-3 下午09:26:06
	 * @category com.linkage.gis.core.task
	 * @copyright 南京联创科技 网管开发部
	 */
	public class BaseTask extends EventDispatcher
	{
		private var _showBusyCursor:Boolean=false;
		
		private var _url:String;
		public function BaseTask(url:String=null)
		{
			this.url = url;
		}

		public function get showBusyCursor():Boolean
		{
			return _showBusyCursor;
		}

		public function set showBusyCursor(value:Boolean):void
		{
			_showBusyCursor = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}


	}
}