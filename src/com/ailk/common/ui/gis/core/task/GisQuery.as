package com.ailk.common.ui.gis.core.task
{
	import com.ailk.common.ui.gis.core.metry.GisMetry;
	
	import flash.events.EventDispatcher;

	/**
	 * 查询类
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-5-3 下午03:56:04
	 * @category com.ailk.common.ui.gis.core.task
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisQuery
	{
		private var _gisMetry:GisMetry;
		private var _maxAllowableOffset:Number;
		private var _objectIds:Array;
		private var _outFields:Array;
		private var _relationParam:String;
		private var _returnGeometry:Boolean=false;
		private var _where:String;
		private var _text:String;
		public function GisQuery()
		{
		}

		public function get gisMetry():GisMetry
		{
			return _gisMetry;
		}

		public function set gisMetry(value:GisMetry):void
		{
			_gisMetry = value;
		}

		public function get maxAllowableOffset():Number
		{
			return _maxAllowableOffset;
		}

		public function set maxAllowableOffset(value:Number):void
		{
			_maxAllowableOffset = value;
		}

		public function get objectIds():Array
		{
			return _objectIds;
		}

		public function set objectIds(value:Array):void
		{
			_objectIds = value;
		}

		public function get outFields():Array
		{
			return _outFields;
		}

		public function set outFields(value:Array):void
		{
			_outFields = value;
		}

		public function get relationParam():String
		{
			return _relationParam;
		}

		public function set relationParam(value:String):void
		{
			_relationParam = value;
		}

		public function get returnGeometry():Boolean
		{
			return _returnGeometry;
		}

		public function set returnGeometry(value:Boolean):void
		{
			_returnGeometry = value;
		}

		public function get where():String
		{
			return _where;
		}

		public function set where(value:String):void
		{
			_where = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}


	}
}