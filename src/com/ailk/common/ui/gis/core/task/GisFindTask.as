package com.ailk.common.ui.gis.core.task
{
	/**
	 * 
	 *
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2012-12-13
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class GisFindTask extends BaseTask
	{
		private var _findParameters:GisFindParameters;
		private var _executeLastResult:Array;
		public function GisFindTask(url:String=null)
		{
			super(url);
		}

		public function get findParameters():GisFindParameters
		{
			return _findParameters;
		}

		public function set findParameters(value:GisFindParameters):void
		{
			_findParameters = value;
		}

		public function get executeLastResult():Array
		{
			return _executeLastResult;
		}

		public function set executeLastResult(value:Array):void
		{
			_executeLastResult = value;
		}


	}
}