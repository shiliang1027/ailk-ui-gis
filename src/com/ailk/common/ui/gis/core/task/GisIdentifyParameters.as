package com.ailk.common.ui.gis.core.task
{
	import com.ailk.common.ui.gis.core.metry.GisExtent;
	import com.ailk.common.ui.gis.core.metry.GisMetry;

	/**
	 * 查询参数对象
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-5-3 下午08:27:19
	 * @category com.ailk.common.ui.gis.core.task
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisIdentifyParameters
	{
		private var _width:Number;
		private var _height:Number;
		private var _gisMetry:GisMetry;
		private var _returnGisMetry:Boolean;
		private var _mapExtent:GisExtent;
		private var _tolerance:Number;
		private var _layerOption:String="top";
		private var _layerIds:Array;
		
		public static const LAYER_OPTION_ALL:String = "all";
		public static const LAYER_OPTION_TOP:String = "top";
		public static const LAYER_OPTION_VISIBLE:String = "visible";
		
		public function GisIdentifyParameters()
		{
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		public function get gisMetry():GisMetry
		{
			return _gisMetry;
		}

		public function set gisMetry(value:GisMetry):void
		{
			_gisMetry = value;
		}

		public function get returnGisMetry():Boolean
		{
			return _returnGisMetry;
		}

		public function set returnGisMetry(value:Boolean):void
		{
			_returnGisMetry = value;
		}

		public function get mapExtent():GisExtent
		{
			return _mapExtent;
		}

		public function set mapExtent(value:GisExtent):void
		{
			_mapExtent = value;
		}

		public function get tolerance():Number
		{
			return _tolerance;
		}

		public function set tolerance(value:Number):void
		{
			_tolerance = value;
		}

		public function get layerOption():String
		{
			return _layerOption;
		}

		[Inspectable(category="General", enumeration="all,top,visible", defaultValue="top")]
		public function set layerOption(value:String):void
		{
			_layerOption = value;
		}

		public function get layerIds():Array
		{
			return _layerIds;
		}

		public function set layerIds(value:Array):void
		{
			_layerIds = value;
		}


	}
}