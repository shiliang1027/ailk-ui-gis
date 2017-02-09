package com.ailk.common.ui.gis.googlemap
{
	import com.ailk.common.ui.gis.core.BaseMap;
	import com.ailk.common.ui.gis.core.IMapConfig;
	import com.ailk.common.ui.gis.core.IMapControl;
	
	/**
	 * google地图适配类
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
	public class GoogleMap extends BaseMap
	{
		public function GoogleMap(config:IMapConfig, control:IMapControl)
		{
			super(config,control);
		}
	}
}