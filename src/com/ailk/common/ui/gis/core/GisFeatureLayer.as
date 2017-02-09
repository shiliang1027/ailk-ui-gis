package com.ailk.common.ui.gis.core
{
	import com.ailk.common.ui.gis.core.styles.GisStyle;
	import com.ailk.common.ui.gis.core.task.GisQuery;

	/**
	 * GIS地图图层
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-5-3 下午02:05:11
	 * @category com.ailk.common.ui.gis.core
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisFeatureLayer extends BaseLayer
	{
		public static const SELECTION_ADD:String = "add";
		public static const SELECTION_NEW:String = "new";
		public static const SELECTION_SUBTRACT:String = "subtract";
		
		public static const QUERY_NEW:String = "new";
		public static const MODE_SNAPSHOT:String = "snapshot";
		public static const MODE_ON_DEMAND:String = "onDemand";
		public static const MODE_SELECTION:String = "selection";
		private var _url:String;
		
		private var _outField:Array;
		
		private var _mode:String="onDemand";
		
		private var _definitionExpression:String;
		
		private var _gisStyle:GisStyle;
		
		private var _query:GisQuery;
		
		private var _featureContextMenus:Array;
		private var _featureOnClick:Function;
		private var _featureOnMouseOver:Function;
		private var _featureOnMouseOut:Function;
		
		public function GisFeatureLayer(url:String=null,mode:String="onDemand",outField:Array=null,definitionExpression:String=null,gisStyle:GisStyle=null)
		{
			this.url = url;
			this.mode=mode;
			this.outField = outField;
			this.definitionExpression = definitionExpression;
			this.gisStyle = gisStyle;
			super();
		}

		
		public function selectFeatures(selectionMethod:String=SELECTION_NEW):void{
			if(map){
				map.selectFeaturesByLayerId(id,selectionMethod);
			}
		}
		
		public function clearSelection():void{
			if(map){
				map.clearSelectionByLayerId(id);
			}
			
		}
		
		public function queryFeatures(method:String=QUERY_NEW):void{
			if(map){
				map.queryFeaturesByLayerId(id,method);
			}
		}
		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get outField():Array
		{
			return _outField;
		}

		public function set outField(value:Array):void
		{
			_outField = value;
		}

		/**
		 * onDemand,selection,snapshot
		 */
		public function get mode():String
		{
			return _mode;
		}

		[Inspectable(category="General", enumeration="onDemand,selection,snapshot", defaultValue="onDemand")]
		public function set mode(value:String):void
		{
			_mode = value;
		}

		public function get definitionExpression():String
		{
			return _definitionExpression;
		}

		public function set definitionExpression(value:String):void
		{
			_definitionExpression = value;
		}

		public function get gisStyle():GisStyle
		{
			return _gisStyle;
		}

		public function set gisStyle(value:GisStyle):void
		{
			_gisStyle = value;
		}
		
		public function get query():GisQuery
		{
			return _query;
		}
		
		public function set query(value:GisQuery):void
		{
			_query = value;
		}
		
		public function get featureContextMenus():Array
		{
			return _featureContextMenus;
		}
		
		public function set featureContextMenus(value:Array):void
		{
			_featureContextMenus = value;
		}


		public function get featureOnClick():Function
		{
			return _featureOnClick;
		}

		public function set featureOnClick(value:Function):void
		{
			_featureOnClick = value;
		}

		public function get featureOnMouseOver():Function
		{
			return _featureOnMouseOver;
		}

		public function set featureOnMouseOver(value:Function):void
		{
			_featureOnMouseOver = value;
		}

		public function get featureOnMouseOut():Function
		{
			return _featureOnMouseOut;
		}

		public function set featureOnMouseOut(value:Function):void
		{
			_featureOnMouseOut = value;
		}

		
		override public function toString():String{
			return super.toString()+",url:"+this.url+",mode:"+this.mode+",outField:"+this.outField+",definitionExpression:"+definitionExpression+",gisStyle:"+this.gisStyle;
		}

	}
}