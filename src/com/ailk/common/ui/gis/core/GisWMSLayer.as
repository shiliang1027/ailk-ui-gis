package com.ailk.common.ui.gis.core
{
	/**
	 * 
	 * GIS地图图层，图片图层，根据图层地址生成图片方式展示
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2013-1-4
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class GisWMSLayer extends BaseLayer
	{
		public var url:String;
		public function GisWMSLayer(url:String=null)
		{
			super();
			this.url = url;
		}
	}
}