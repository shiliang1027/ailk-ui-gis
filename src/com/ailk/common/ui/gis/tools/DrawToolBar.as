package com.ailk.common.ui.gis.tools
{
	import com.ailk.common.ui.gis.MapWork;
	import com.ailk.common.ui.gis.core.GisLayer;
	import com.ailk.common.ui.gis.core.gis_internal;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	import spark.components.Button;

	use namespace gis_internal;

	/**
	 * 地图绘制框选工具条
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-6-28 上午10:20:05
	 * @category com.ailk.common.ui.gis.tools
	 * @copyright 南京联创科技 网管开发部
	 */
	public class DrawToolBar extends BorderContainer
	{

		[SkinPart(required="false")]
		public var pan:Button;
		[SkinPart(required="false")]
		public var zoom:Button;
		[SkinPart(required="false")]
		public var drawFreePolygon:Button;
		[SkinPart(required="false")]
		public var drawRectangle:Button;
		[SkinPart(required="false")]
		public var drawCircle:Button;
		[SkinPart(required="false")]
		public var drawPolygon:Button;
		[SkinPart(required="false")]
		public var drawRegulPolyon:Button;
		[SkinPart(required="false")]
		public var back:Button;
		[SkinPart(required="false")]
		public var forward:Button;
		
		[SkinPart(required="false")]
		public var config:Image;
		
		[SkinPart(required="false")]
		public var rectangleSetBtn:Button;
		
		[SkinPart(required="false")]
		public var circleSetBtn:Button;
		
		[SkinPart(required="false")]
		public var regulPolyonSetBtn:Button;
		
		
		private var _mapWork:MapWork;
		private var _configType:String;

		private var isZoom:Boolean;
		private var isShiftDown:Boolean;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var panEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var zoomEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var drawFreePolygonEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var drawRectangleEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var drawCircleEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var drawRegulPolyonEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="false")]
		public var drawPolygonEnabled:Boolean=false;
		
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var backEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var forwardEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var configEnabled:Boolean=true;
		
		public var gisLayer:GisLayer;
		
		public function DrawToolBar(mw:MapWork=null)
		{
			super();
			this.mapWork=mw;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}

		private function onCreationComplete(event:FlexEvent):void
		{
			mapWork.addEventListener(KeyboardEvent.KEY_DOWN, onKeybordDownHandler);
			mapWork.addEventListener(KeyboardEvent.KEY_UP, onKeybordUpHandler);
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			if (instance == pan)
			{
				if(panEnabled){
					pan.addEventListener(MouseEvent.CLICK, panHandler);
				}else{
					pan.visible=pan.includeInLayout=panEnabled;
				}
			}
			else if (instance == zoom)
			{
				if(zoomEnabled){
					zoom.addEventListener(MouseEvent.CLICK, zoomHandler);
				}else{
					zoom.visible=zoom.includeInLayout=zoomEnabled;
				}
				
			}
			else if (instance == drawFreePolygon)
			{
				if(drawFreePolygonEnabled){
					drawFreePolygon.addEventListener(MouseEvent.CLICK, drawFreePolygonHandler);
				}else{
					drawFreePolygon.visible=drawFreePolygon.includeInLayout=drawFreePolygonEnabled;
				}
			
			}
			else if (instance == drawRectangle)
			{
				if(drawRectangleEnabled){
					drawRectangle.addEventListener(MouseEvent.CLICK, drawRectangleHandler);
					drawRectangle.addEventListener(MouseEvent.MOUSE_OVER,drawBtnOverHandler);
					drawRectangle.addEventListener(MouseEvent.MOUSE_OUT,drawBtnOutHandler);
				}else{
					drawRectangle.visible=drawRectangle.includeInLayout=drawRectangleEnabled;
				}
			
			}
			else if (instance == drawCircle)
			{
				if(drawCircleEnabled){
					drawCircle.addEventListener(MouseEvent.CLICK, drawCircleHandler);
					drawCircle.addEventListener(MouseEvent.MOUSE_OVER,drawBtnOverHandler);
					drawCircle.addEventListener(MouseEvent.MOUSE_OUT,drawBtnOutHandler);
				}else{
					drawCircle.visible=drawCircle.includeInLayout=drawCircleEnabled;
				}
			}
			else if (instance == drawRegulPolyon)
			{
				if(drawRegulPolyonEnabled){
					drawRegulPolyon.addEventListener(MouseEvent.CLICK, drawRegulPolyonHandler);
					drawRegulPolyon.addEventListener(MouseEvent.MOUSE_OVER,drawBtnOverHandler);
					drawRegulPolyon.addEventListener(MouseEvent.MOUSE_OUT,drawBtnOutHandler);
				}else{
					drawRegulPolyon.visible=drawRegulPolyon.includeInLayout=drawRegulPolyonEnabled;
				}
			}
			else if (instance == drawPolygon)
			{
				if(drawPolygonEnabled){
					drawPolygon.addEventListener(MouseEvent.CLICK, drawPolygonHandler);
				}else{
					drawPolygon.visible=drawPolygon.includeInLayout=drawPolygonEnabled;
				}
			}
			else if (instance == back)
			{
				if(backEnabled){
					back.addEventListener(MouseEvent.CLICK, backHandler);
				}else{
					back.visible=back.includeInLayout=backEnabled;
				}
				
			}
			else if (instance == forward)
			{
				if(forwardEnabled){
					forward.addEventListener(MouseEvent.CLICK, forwardHandler);
				}else{
					forward.visible=forward.includeInLayout=forwardEnabled;
				}
				
			}
//			else if(instance == config){
//				if(configEnabled){
//					config.addEventListener(MouseEvent.CLICK,configHandler);
//					config.addEventListener(MouseEvent.MOUSE_OVER,configBtnOverHandler);
//					config.addEventListener(MouseEvent.MOUSE_OUT,configBtnOutHandler);
//				}else{
//					config.visible=config.includeInLayout = configEnabled;
//				}
//			}
			
			else if(instance == rectangleSetBtn){
				if(configEnabled){
					rectangleSetBtn.addEventListener(MouseEvent.CLICK,rectangleSetHandler);
				}else{
					rectangleSetBtn.visible=rectangleSetBtn.includeInLayout = configEnabled;
				}
			}
			
			else if(instance == circleSetBtn){
				if(configEnabled){
					circleSetBtn.addEventListener(MouseEvent.CLICK,circleSetHandler);
				}else{
					circleSetBtn.visible=circleSetBtn.includeInLayout = configEnabled;
				}
			}
			
			else if(instance == regulPolyonSetBtn){
				if(configEnabled){
					regulPolyonSetBtn.addEventListener(MouseEvent.CLICK,regulPolyonSetHandler);
				}else{
					regulPolyonSetBtn.visible=regulPolyonSetBtn.includeInLayout = configEnabled;
				}
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if (instance == pan)
			{
				if(panEnabled){
					pan.removeEventListener(MouseEvent.CLICK, panHandler);
				}
			}
			else if (instance == zoom)
			{
				if(zoomEnabled){
					zoom.removeEventListener(MouseEvent.CLICK, zoomHandler);
				}
			}
			else if (instance == drawFreePolygon)
			{
				if(drawFreePolygonEnabled){
					drawFreePolygon.removeEventListener(MouseEvent.CLICK, drawFreePolygonHandler);
				}
			}
			else if (instance == drawRectangle)
			{
				if(drawRectangleEnabled){
					drawRectangle.removeEventListener(MouseEvent.CLICK, drawRectangleHandler);
					drawRectangle.removeEventListener(MouseEvent.MOUSE_OVER,drawBtnOverHandler);
					drawRegulPolyon.removeEventListener(MouseEvent.MOUSE_OUT,drawBtnOutHandler);
				}
			}
			else if (instance == drawCircle)
			{
				if(drawCircleEnabled){
					drawCircle.removeEventListener(MouseEvent.CLICK, drawCircleHandler);
					drawCircle.removeEventListener(MouseEvent.MOUSE_OVER,drawBtnOverHandler);
					drawCircle.removeEventListener(MouseEvent.MOUSE_OUT,drawBtnOutHandler);
				}
			}
			else if (instance == drawRegulPolyon)
			{
				if(drawRegulPolyonEnabled){
					drawRegulPolyon.removeEventListener(MouseEvent.CLICK, drawRegulPolyonHandler);
					drawRegulPolyon.removeEventListener(MouseEvent.MOUSE_OVER,drawBtnOverHandler);
					drawRegulPolyon.removeEventListener(MouseEvent.MOUSE_OUT,drawBtnOutHandler);
				}
			}
			else if (instance == drawPolygon)
			{
				if(drawPolygonEnabled){
					drawPolygon.removeEventListener(MouseEvent.CLICK, drawPolygonHandler);
				}
			}
			else if (instance == back)
			{
				if(backEnabled){
					back.removeEventListener(MouseEvent.CLICK, backHandler);
				}
			}
			else if (instance == forward)
			{
				if(forwardEnabled){
					forward.removeEventListener(MouseEvent.CLICK, forwardHandler);
				}
			}
//			else if(instance == config){
//				if(configEnabled){
//					config.removeEventListener(MouseEvent.CLICK,configHandler);
//				}
//			}
			
			else if(instance == rectangleSetBtn){
				if(configEnabled){
					rectangleSetBtn.removeEventListener(MouseEvent.CLICK,rectangleSetHandler);
				}
			}
			else if(instance == circleSetBtn){
				if(configEnabled){
					circleSetBtn.removeEventListener(MouseEvent.CLICK,circleSetHandler);
				}
			}
				
			else if(instance == regulPolyonSetBtn){
				if(configEnabled){
					regulPolyonSetBtn.removeEventListener(MouseEvent.CLICK,regulPolyonSetHandler);
				}
			}
		}

		private function onKeybordDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == 16)
			{
				isShiftDown=true;
			}
		}

		private function onKeybordUpHandler(event:KeyboardEvent):void
		{
			isShiftDown=false;
		}

		private function panHandler(event:MouseEvent):void
		{
			mapWork.map.panMap();
		}

		private function zoomHandler(event:MouseEvent):void
		{
			if (isShiftDown)
			{
				mapWork.map.zoomOutMap();
			}
			else
			{
				mapWork.map.zoomInMap();
			}
		}

		private function drawFreePolygonHandler(event:MouseEvent):void
		{
			mapWork.map.panMap();
			mapWork.map.drawFreePolygon();
		}

		private function drawRectangleHandler(event:MouseEvent):void
		{
			mapWork.map.panMap();
			mapWork.map.drawRectangle();
		}

		private function drawCircleHandler(event:MouseEvent):void
		{
			mapWork.map.panMap();
			mapWork.map.drawCircle();
		}

		private function drawRegulPolyonHandler(event:MouseEvent):void
		{
			mapWork.map.panMap();
			mapWork.map.drawRegulPolyon();
		}

		private function drawPolygonHandler(event:MouseEvent):void
		{
			mapWork.map.panMap();
			mapWork.map.drawPolygon();
		}

		private function backHandler(event:MouseEvent):void
		{
			mapWork.map.drawBack();
		}

		private function forwardHandler(event:MouseEvent):void
		{
			mapWork.map.drawForward();
		}
		
		private function rectangleSetHandler(event:MouseEvent):void{
			mapWork.map.drawConfig("rectangle");
		}
		
		private function circleSetHandler(event:MouseEvent):void{
			mapWork.map.drawConfig("circle");
		}
		
		private function regulPolyonSetHandler(event:MouseEvent):void{
			mapWork.map.drawConfig("regulPolyon");
		}
		
		
		private function configHandler(event:MouseEvent):void{
			mapWork.map.drawConfig(_configType);
		}
		
		private function drawBtnOverHandler(event:MouseEvent):void{
//			if(configEnabled && !config.visible){
//				var button:Button = Button(event.currentTarget);
//				config.x = button.x+button.width;
//				config.y = button.y+5;
//				config.visible=true;
//				switch(button.id){
//					case "drawRectangle":
//						_configType = "rectangle";
//						break;
//					case "drawCircle":
//						_configType = "circle";
//						break;
//					case "drawRegulPolyon":
//						_configType = "regulPolyon";
//						break;
//					default:
//						_configType = "rectangle";
//				}
//			}
		}
		
		private function drawBtnOutHandler(event:MouseEvent):void{
//			if(configEnabled){
//				config.visible=false;
//			}
		}
		
		private function configBtnOverHandler(event:MouseEvent):void{
			config.visible=true;
		}
		
		private function configBtnOutHandler(event:MouseEvent):void{
		}

		public function get mapWork():MapWork
		{
			return this._mapWork;
		}

		public function set mapWork(value:MapWork):void
		{
			this._mapWork=value;
		}
	}
}