package com.ailk.common.ui.gis
{
	import com.ailk.common.ui.gis.core.gis_internal;

	use namespace gis_internal;
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
	public class Constants
	{
		gis_internal static const GisResource:String = "gisResource";
		/**
		 * 地图类型：ARCGIS 
		 */		
		gis_internal static const MAP_TYPE_ARCGIS:String = "arcgis";
		/**
		 * 地图类型：SuperMap 
		 */		
		gis_internal static const MAP_TYPE_SUPERMAP:String = "supermap";
		/**
		 * 地图类型：BaiduMap 
		 */		
		gis_internal static const MAP_TYPE_BAIDUMAP:String = "baidumap";
		/**
		 * 地图类型：GoogleMap 
		 */		
		gis_internal static const MAP_TYPE_GOOGLEMAP:String = "googlemap";
		
		gis_internal static const MAP_REST:String = "REST";
		
		gis_internal static const MAP_CACHE:String = "CACHE";
		
		public static var ConfigBaseUrl:String = "";
		
		public function Constants()
		{
		}
	}
}