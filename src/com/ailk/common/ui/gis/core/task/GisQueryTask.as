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
	public class GisQueryTask extends BaseTask
	{
		private var _executeLastResult:Array;
		private var _query:GisQuery; 
		private var _useAMF:Boolean = false;
		public function GisQueryTask(url:String=null)
		{
			super(url);
		}

		public function get query():GisQuery
		{
			return _query;
		}

		public function set query(value:GisQuery):void
		{
			_query = value;
		}

		public function get executeLastResult():Array
		{
			return _executeLastResult;
		}

		public function set executeLastResult(value:Array):void
		{
			_executeLastResult = value;
		}

		public function get useAMF():Boolean
		{
			return _useAMF;
		}

		public function set useAMF(value:Boolean):void
		{
			_useAMF = value;
		}


	}
}