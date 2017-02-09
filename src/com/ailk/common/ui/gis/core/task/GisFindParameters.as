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
	public class GisFindParameters
	{
		public var returnGeometry:Boolean = false;
		public var layerDefinitions:Array;
		public var layerIds:Array;
		public var maxAllowableOffset:Number;
		public var searchFields:Array;
		public var searchText:String;
		public var contains:Boolean = true;
		
		public function GisFindParameters()
		{
		}
	}
}