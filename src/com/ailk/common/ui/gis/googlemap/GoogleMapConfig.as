package com.ailk.common.ui.gis.googlemap
{
	import com.ailk.common.ui.gis.core.BaseConfig;
	import com.ailk.common.ui.gis.core.IMapConfig;
	import com.ailk.common.ui.gis.core.IMapControl;

	/**
	 * Google地图参数配置类
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
	public class GoogleMapConfig extends BaseConfig
	{
		private var _serviceType:String;

		public function GoogleMapConfig(control:IMapControl)
		{
			super(control);
		}
	}
}