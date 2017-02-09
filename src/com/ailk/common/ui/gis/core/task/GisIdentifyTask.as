package com.ailk.common.ui.gis.core.task
{
	/**
	 * 带参数的任务类
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-5-3 下午08:26:09
	 * @category com.linkage.gis.core.task
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisIdentifyTask extends BaseTask
	{
		private var _identifyParameters:GisIdentifyParameters;
		public function GisIdentifyTask(url:String=null)
		{
			super(url);
			
		}
		
		
		public function get identifyParameters():GisIdentifyParameters
		{
			return _identifyParameters;
		}

		public function set identifyParameters(value:GisIdentifyParameters):void
		{
			_identifyParameters = value;
		}

	}
}