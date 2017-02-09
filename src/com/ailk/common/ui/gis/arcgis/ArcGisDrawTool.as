package com.ailk.common.ui.gis.arcgis
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.events.DrawEvent;
	import com.esri.ags.events.MapMouseEvent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.Symbol;
	import com.esri.ags.tools.DrawTool;
	import com.esri.ags.utils.GeometryUtil;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import mx.controls.Alert;
	import mx.core.IToolTip;
	import mx.managers.ToolTipManager;

	/**
	 * 绘制正多边形
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-7-29 下午01:57:38
	 * @category com.linkage.gis.arcgis
	 * @copyright 南京联创科技 网管开发部
	 */
	public class ArcGisDrawTool extends DrawTool
	{
		/**
		 * 正多边形
		 */
		public static const REGULPOLYGON:String="regulPolyon";
		/**
		 * 正多边形半径
		 */
		private var m_regulPolygonRadius:Number;
		private var m_tempLayer:GraphicsLayer;
		private var m_graphic:Graphic;
		private var regulPolygon:Polygon;
		private var m_regulPolygonCenter:MapPoint;
		private var m_toolTip:IToolTip;
		private var m_toolTipText:String;
		private var m_showDrawTips:Boolean=true;
		private var m_mouseMove:Boolean=false;
		private var _m_numberOfRegulPolygonPoints:Number=6;

		public function ArcGisDrawTool(map:Map=null)
		{
			super(map);
			this.m_tempLayer=new GraphicsLayer();
		}

		override public function activate(drawType:String, enableGraphicsLayerMouseEvents:Boolean=false):void
		{
			if (drawType == REGULPOLYGON)
			{
				deactivate();
				this.m_toolTipText="按下后开始并直到完成";
				this.map.panEnabled=false;
				this.map.rubberbandZoomEnabled=false;
				this.map.addLayer(m_tempLayer);
				this.map.addEventListener(MapMouseEvent.MAP_MOUSE_DOWN, map_mouseDownHandler);
				this.map.addEventListener(MouseEvent.ROLL_OVER, map_rollOverHandler, false, -1, true);
				this.map.addEventListener(MouseEvent.ROLL_OUT, map_rollOutHandler, false, -1, true);
			}
			else
			{
				super.activate(drawType, enableGraphicsLayerMouseEvents);
			}
		}

		override public function deactivate():void
		{
			super.deactivate();
			if (this.m_toolTip)
			{
				ToolTipManager.destroyToolTip(this.m_toolTip);
				this.m_toolTip=null;
			}
			this.map.removeEventListener(MouseEvent.ROLL_OVER, this.map_rollOverHandler);
			this.map.removeEventListener(MouseEvent.ROLL_OUT, this.map_rollOutHandler);
			this.map.removeEventListener(MapMouseEvent.MAP_MOUSE_DOWN, this.map_mouseDownHandler);
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
			this.map.removeEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
			this.map.panEnabled=true;
			this.map.rubberbandZoomEnabled=true;
		}

		private function map_rollOverHandler(event:MouseEvent):void
		{
			if (this.m_showDrawTips)
			{
				if (!this.m_toolTip)
				{
					this.m_toolTip=ToolTipManager.createToolTip(this.m_toolTipText, event.stageX + 10, event.stageY - 10);
				}
				else
				{
					this.m_toolTip.visible=true;
					this.m_toolTip.text=this.m_toolTipText;
				}
			}
			this.map.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
		} // end function

		private function map_rollOutHandler(event:MouseEvent):void
		{
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			if (this.m_toolTip)
			{
				this.m_toolTip.visible=false;
			}
			return;
		} // end function

		private function mouseMoveHandler(event:MouseEvent):void
		{
			if (this.m_toolTip)
			{
				this.m_toolTip.text=this.m_toolTipText;
				this.m_toolTip.x=event.stageX + 10;
				this.m_toolTip.y=event.stageY - 10;
			}
			return;
		} // end function

		private function map_mouseDownHandler(event:MapMouseEvent):void
		{
			this.m_mouseMove=false;
			if (this.m_toolTip)
			{
				this.m_toolTip.visible=false;
			}
			this.m_graphic=new Graphic();
			dispatchEvent(new DrawEvent(DrawEvent.DRAW_START, this.m_graphic));
			map.removeEventListener(MapMouseEvent.MAP_MOUSE_DOWN, this.map_mouseDownHandler);
			map.addEventListener(MouseEvent.MOUSE_MOVE, map_mouseMoveHandler);
			map.addEventListener(MouseEvent.MOUSE_UP, map_mouseUpHandler);
			this.regulPolygon=new Polygon();
			this.regulPolygon.spatialReference=this.map.spatialReference;
			this.m_regulPolygonCenter=this.map.toMapFromStage(event.stageX, event.stageY);
			this.m_regulPolygonRadius=1;
			this.m_graphic.geometry=this.regulPolygon;
			this.m_graphic.symbol=this.fillSymbol;
			this.addGraphic(this.m_graphic);
		}

		private function addGraphic(graphic:Graphic):void
		{
			if (this.graphicsLayer)
			{
				this.graphicsLayer.add(graphic);
			}
			else
			{
				this.m_tempLayer.clear();
				this.m_tempLayer.add(graphic);
				this.map.addLayer(this.m_tempLayer);
			}
			return;
		}

		private function map_mouseMoveHandler(event:MouseEvent):void
		{
			this.m_mouseMove=true;
			this.m_regulPolygonRadius=this.calculateRadius(this.map.toMapFromStage(event.stageX, event.stageY));
			this.updateRegulPolygon();
			this.m_graphic.refresh();
		}

		private function map_mouseUpHandler(event:MouseEvent):void
		{
			if (this.m_toolTip)
			{
				this.m_toolTip.visible=true;
			}
			this.m_toolTipText="按下后开始并直到完成";
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE, this.map_mouseMoveHandler);
			this.map.removeEventListener(MouseEvent.MOUSE_UP, this.map_mouseUpHandler);
			this.map.removeEventListener(MapMouseEvent.MAP_MOUSE_DOWN, this.map_mouseDownHandler);
			this.map.addEventListener(MapMouseEvent.MAP_MOUSE_DOWN, this.map_mouseDownHandler, false, -1, true);
			if (!this.m_mouseMove)
			{
				this.m_regulPolygonRadius=defaultDrawSize / 2;
				this.updateRegulPolygon();
				this.m_graphic.refresh();
			}
			this.removeLayerEndDraw();
		}

		private function calculateRadius(point:MapPoint):Number
		{
			var x:Number=point.x - this.m_regulPolygonCenter.x;
			var y:Number=point.y - this.m_regulPolygonCenter.y;
			return Math.sqrt(x * x + y * y);
		}

		private function createRegulPolygonPoints():Array
		{
			var points:Array=new Array();
			var i:Number;
			var sin:Number;
			var cos:Number;
			var x:Number;
			var y:Number;
			var point:Point=null;
			if (this.m_mouseMove)
			{
				i=0;
				while (i < this.m_numberOfRegulPolygonPoints)
				{

					sin=Math.sin(Math.PI * 2 * i / this.m_numberOfRegulPolygonPoints);
					cos=Math.cos(Math.PI * 2 * i / this.m_numberOfRegulPolygonPoints);
					x=this.m_regulPolygonCenter.x + this.m_regulPolygonRadius * cos;
					y=this.m_regulPolygonCenter.y + this.m_regulPolygonRadius * sin;
					points[i]=new MapPoint(x, y);
					i++;
				}
			}
			else
			{
				i=0;
				while (i < this.m_numberOfRegulPolygonPoints)
				{

					sin=Math.sin(Math.PI * 2 * i / this.m_numberOfRegulPolygonPoints);
					cos=Math.cos(Math.PI * 2 * i / this.m_numberOfRegulPolygonPoints);
					point=this.map.toScreen(this.m_regulPolygonCenter);
					point.x=point.x + this.m_regulPolygonRadius * cos;
					point.y=point.y + this.m_regulPolygonRadius * sin;
					points[i]=this.map.toMap(point);
					i++;
				}
			}
			points.push(points[0]);
			return points;
		}

		private function updateRegulPolygon():void
		{
			if (this.regulPolygon.rings != null && this.regulPolygon.rings.length > 0)
			{
				this.regulPolygon.removeRing(0);
			}
			this.regulPolygon.addRing(this.createRegulPolygonPoints());
			return;
		}

		private function removeLayerEndDraw():void
		{
			if (this.m_tempLayer)
			{
				this.map.removeLayer(this.m_tempLayer);
			}
			dispatchEvent(new DrawEvent(DrawEvent.DRAW_END, this.m_graphic));
			return;
		}

		public function get m_numberOfRegulPolygonPoints():Number
		{
			return _m_numberOfRegulPolygonPoints;
		}

		public function set m_numberOfRegulPolygonPoints(value:Number):void
		{
			_m_numberOfRegulPolygonPoints=value;
		}


	}
}