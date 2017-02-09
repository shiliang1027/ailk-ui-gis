package com.ailk.common.ui.gis.exception
{
	/**
	 * 
	 *
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2012-8-21
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class GisException extends Error
	{
		public function GisException(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}