package com.ailk.common.ui.gis.tools
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.MapWork;

	import mx.core.UIComponent;

	/**
	 *
	 *
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2012-12-21
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class ZoomSliderBar extends UIComponent
	{
		private static var log:ILogger=Log.getLoggerByClass(ZoomSliderBar);
		private var _mapWork:MapWork;

		public function ZoomSliderBar()
		{
			super();
		}

		override protected function createChildren():void
		{
			log.debug("[createChildren]{0}", _mapWork.map);
			super.createChildren();
			if(_mapWork.map){
				_mapWork.map.updateZoomSliderDisplay(this);
			}
		}

		public function get mapWork():MapWork
		{
			return _mapWork;
		}

		public function set mapWork(value:MapWork):void
		{
			_mapWork=value;
		}

	}
}