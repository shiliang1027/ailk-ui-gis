package com.ailk.common.ui.gis.core
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	/**
	 * 图层接口
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-8-3 上午10:41:52
	 * @category com.linkage.gis.core
	 * @copyright 南京联创科技 网管开发部
	 */
	public interface ILayer
	{
		function get id():String;
		function set id(value:String):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get map():IMap;
		function set map(value:IMap):void;
		
		function getGisFeatureByID(id:String):GisFeature;
		
		function get gisFeatures():ArrayCollection;
		
		function get alpha():Number;
		function set alpha(value:Number):void;
	}
}