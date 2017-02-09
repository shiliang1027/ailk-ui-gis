package com.ailk.common.ui.gis.supermap
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.supermap.web.actions.DrawAction;
	import com.supermap.web.core.Feature;
	import com.supermap.web.core.Point2D;
	import com.supermap.web.core.geometry.GeoRegion;
	import com.supermap.web.core.styles.FillStyle;
	import com.supermap.web.core.styles.PredefinedFillStyle;
	import com.supermap.web.mapping.Map;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 绘制正多边形类
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-8-11 下午09:07:20
	 * @category com.linkage.gis.supermap
	 * @copyright 南京联创科技 网管开发部
	 */
	public class DrawRegulPolyon extends DrawAction
	{
		private static var log:ILogger=Log.getLoggerByClass(DrawRegulPolyon);
		/**
		 *正多边形半径 
		 */		
		private var m_regulPolygonRadius:Number;
		private var m_regulPolygonCenter:Point2D;
		private var _point2Ds:Array;
		private var _geoRegion:GeoRegion;
		private var _fillStyle:FillStyle;
		private var m_numberOfRegulPolygonPoints:Number=6;
		
		public function DrawRegulPolyon(map:Map)
		{
			this._point2Ds = [];
			super(map);
			this._fillStyle = new PredefinedFillStyle(PredefinedFillStyle.SYMBOL_SOLID, 16711680, 0.6);
			return;
		}
		
		public function get fillStyle() : FillStyle
		{
			return this._fillStyle;
		}
		
		public function set fillStyle(value:FillStyle) : void
		{
			this._fillStyle = value;
			return;
		}
		
		override protected function onMouseDown(event:MouseEvent) : void
		{
			if (this.actionStarted)
			{
				return;
			}
			this.actionStarted = true;
			this.map.setFocus();
			this.tempFeature = new Feature();
			startDraw();
			this._geoRegion = new GeoRegion();
			this.m_regulPolygonCenter = this.map.stageToMap(new Point(event.stageX, event.stageY));
			this._point2Ds.push(this.m_regulPolygonCenter);
			this._geoRegion.parts.push(this._point2Ds);
			this.m_regulPolygonRadius = 1;
			this.tempFeature.style = this._fillStyle;
			this.tempFeature.geometry = this._geoRegion;
			this.tempLayer.addFeature(this.tempFeature);
		}
		
		override protected function onMouseMove(event:MouseEvent) : void
		{
			if(!this.actionStarted){
				return;
			}
			var point:Point2D = this.map.stageToMap(new Point(event.stageX, event.stageY));
			this.m_regulPolygonRadius = this.calculateRadius(point);
			createRegulPolygonPoints();
			this.tempFeature.refresh();
		}
		
		override protected function onMouseUp(event:MouseEvent) : void
		{
			if (!this.actionStarted)
			{
				return;
			}
			this.endDraw();
			this.m_regulPolygonCenter = null;
			this._point2Ds = [];
			this.actionStarted = false;
			return;
		}
		
		
		private function calculateRadius(point:Point2D):Number{
			var x:Number = point.x - this.m_regulPolygonCenter.x;
			var y:Number = point.y - this.m_regulPolygonCenter.y;
			return Math.sqrt(x * x + y * y);
		}
		
		private function createRegulPolygonPoints():Array{
			var points:Array = new Array();
			var i:Number;
			var sin:Number;
			var cos:Number;
			var x:Number;
			var y:Number;
			var point:Point = null;
			if (this.actionStarted)
			{
				i = 0;
				while (i < this.m_numberOfRegulPolygonPoints)
				{
					
					sin = Math.sin(Math.PI * 2 * i / this.m_numberOfRegulPolygonPoints);
					cos = Math.cos(Math.PI * 2 * i / this.m_numberOfRegulPolygonPoints);
					x = this.m_regulPolygonCenter.x + this.m_regulPolygonRadius * cos;
					y = this.m_regulPolygonCenter.y + this.m_regulPolygonRadius * sin;
					this._point2Ds[i] = new Point2D(x, y);
					i++;
				}
			}
			else
			{
				i = 0;
				while (i < this.m_numberOfRegulPolygonPoints)
				{
					
					sin = Math.sin(Math.PI * 2 * i / this.m_numberOfRegulPolygonPoints);
					cos = Math.cos(Math.PI * 2 * i / this.m_numberOfRegulPolygonPoints);
					point = this.map.mapToScreen(this.m_regulPolygonCenter);
					point.x =  this.map.mapToScreen(this.m_regulPolygonCenter).x+ this.m_regulPolygonRadius * cos;
					point.y = this.map.mapToScreen(this.m_regulPolygonCenter).y + this.m_regulPolygonRadius * sin;
					this._point2Ds[i] = this.map.screenToMap(point);
					i++;
				}
			}
			return points;
		}
	}
}