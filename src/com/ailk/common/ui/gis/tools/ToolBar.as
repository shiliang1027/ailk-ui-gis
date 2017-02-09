package com.ailk.common.ui.gis.tools
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.ailk.common.ui.gis.MapWork;
	import com.ailk.common.ui.gis.core.gis_internal;
	import com.ailk.common.ui.gis.event.MapEvent;

	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;

	import mx.controls.Alert;

	import spark.components.BorderContainer;
	import spark.components.Button;

	use namespace gis_internal;

	/**
	 * 地图工具条
	 * @author shiliang
	 *
	 */
	public class ToolBar extends BorderContainer
	{
		[SkinPart(required="false")]
		public var pan:Button;
		[SkinPart(required="false")]
		public var eye:Button;
		[SkinPart(required="false")]
		public var zoomIn:Button;
		[SkinPart(required="false")]
		public var zoomOut:Button;
		[SkinPart(required="false")]
		public var print:Button;
		[SkinPart(required="false")]
		public var export:Button;

		[SkinPart(required="false")]
		public var select:Button;
		[SkinPart(required="false")]
		public var rule:Button;
		[SkinPart(required="false")]
		public var viewAll:Button;
		[SkinPart(required="false")]
		public var screeAll:Button;
		[SkinPart(required="false")]
		public var picLayer:Button;
		[SkinPart(required="false")]
		public var legend:Button;
		[SkinPart(required="false")]
		public var gotoBtn:Button;

		private var _mapWork:MapWork;

		private static var log:ILogger=Log.getLoggerByClass(ToolBar);

		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var panEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="false")]
		public var eyeEnabled:Boolean=false;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var ruleEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var zoomInEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var zoomOutEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var printEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var exportEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var selectEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var viewAllEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var screeAllEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var picLayerEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var legendEnabled:Boolean=true;
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public var gotoBtnEnabled:Boolean=true;

		public function ToolBar(mw:MapWork=null)
		{
			super();
			this.mapWork=mw;
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			if (instance == pan)
			{
				if (panEnabled)
				{
					pan.addEventListener(MouseEvent.CLICK, panHandler);
				}
				else
				{
					pan.visible=pan.includeInLayout=panEnabled;
				}

			}
			else if (instance == eye)
			{
				if (eyeEnabled)
				{
					eye.addEventListener(MouseEvent.CLICK, eyeHandler);
				}
				else
				{
					eye.visible=eye.includeInLayout=eyeEnabled;
				}
			}
			else if (instance == rule)
			{
				if (ruleEnabled)
				{
					rule.addEventListener(MouseEvent.CLICK, ruleHandler);
				}
				else
				{
					rule.visible=rule.includeInLayout=ruleEnabled;
				}
			}
			else if (instance == zoomIn)
			{
				if (zoomInEnabled)
				{
					zoomIn.addEventListener(MouseEvent.CLICK, zoomInHandler);
				}
				else
				{
					zoomIn.visible=zoomIn.includeInLayout=zoomInEnabled;
				}
			}
			else if (instance == zoomOut)
			{
				if (zoomOutEnabled)
				{
					zoomOut.addEventListener(MouseEvent.CLICK, zoomOutHandler);
				}
				else
				{
					zoomOut.visible=zoomOut.includeInLayout=zoomOutEnabled;
				}
			}
			else if (instance == print)
			{
				if (printEnabled)
				{
					print.addEventListener(MouseEvent.CLICK, printHandler);
				}
				else
				{
					print.visible=print.includeInLayout=printEnabled;
				}
			}
			else if (instance == export)
			{
				if (exportEnabled)
				{
					export.addEventListener(MouseEvent.CLICK, exportHandler);
				}
				else
				{
					export.visible=export.includeInLayout=exportEnabled;
				}
			}
			else if (instance == select)
			{
				if (selectEnabled)
				{
					select.addEventListener(MouseEvent.CLICK, selectHandler);
				}
				else
				{
					select.visible=select.includeInLayout=selectEnabled;
				}
			}
			else if (instance == viewAll)
			{
				if (viewAllEnabled)
				{
					viewAll.addEventListener(MouseEvent.CLICK, viewAllHandler);
				}
				else
				{
					viewAll.visible=viewAll.includeInLayout=viewAllEnabled;
				}
			}
			else if (instance == screeAll)
			{
				if (screeAllEnabled)
				{
					screeAll.addEventListener(MouseEvent.CLICK, screeAllHandler);
				}
				else
				{
					screeAll.visible=screeAll.includeInLayout=screeAllEnabled;
				}
			}
			else if (instance == picLayer)
			{
				if (picLayerEnabled)
				{
					picLayer.addEventListener(MouseEvent.CLICK, picLayerHandler);
				}
				else
				{
					picLayer.visible=picLayer.includeInLayout=picLayerEnabled;
				}
			}
			else if (instance == legend)
			{
				if (legendEnabled)
				{
					legend.addEventListener(MouseEvent.CLICK, legendHandler);
				}
				else
				{
					legend.visible=legend.includeInLayout=legendEnabled;
				}

			}
			else if (instance == gotoBtn)
			{
				if (gotoBtnEnabled)
				{
					gotoBtn.addEventListener(MouseEvent.CLICK, gotoHandler);
				}
				else
				{
					gotoBtn.visible=gotoBtn.includeInLayout=gotoBtnEnabled;
				}
			}
		}

		private function panHandler(event:MouseEvent):void
		{
			mapWork.map.panMap();
		}

		private function eyeHandler(event:MouseEvent):void
		{
			mapWork.map.eyeMap();
		}

		private function ruleHandler(event:MouseEvent):void
		{
			mapWork.map.ruleMap();
		}

		private function zoomInHandler(event:MouseEvent):void
		{
			mapWork.map.zoomInMap();
		}

		private function zoomOutHandler(event:MouseEvent):void
		{
			mapWork.map.zoomOutMap();
		}

		private function printHandler(event:MouseEvent):void
		{
			mapWork.map.printMap();
		}

		private function exportHandler(event:MouseEvent):void
		{
			mapWork.map.exportMap();
		}

		private function selectHandler(event:MouseEvent):void
		{
			mapWork.map.selectedable=true;
			mapWork.map.selectMap();
		}

		private function viewAllHandler(event:MouseEvent):void
		{
			mapWork.map.viewEntireMap();
		}

		private function screeAllHandler(event:MouseEvent):void
		{
			try
			{
				if (mapWork.stage.displayState == StageDisplayState.FULL_SCREEN)
				{
					mapWork.stage.displayState=StageDisplayState.NORMAL;
					screeAll.toolTip="全屏";
				}
				else
				{
					mapWork.stage.displayState=StageDisplayState.FULL_SCREEN;
					screeAll.toolTip="退出全屏";
				}
			}
			catch (e:*)
			{
				Alert.show(e, "Full Screen Error");
			}
		}

		private function picLayerHandler(event:MouseEvent):void
		{
			mapWork.dispatchEvent(new MapEvent(MapEvent.TOOLBAR_PICLAYER));
		}

		private function legendHandler(event:MouseEvent):void
		{
			mapWork.dispatchEvent(new MapEvent(MapEvent.TOOLBAR_LEGEND));
		}

		private function gotoHandler(event:MouseEvent):void
		{
			mapWork.dispatchEvent(new MapEvent(MapEvent.TOOLBAR_GOTO));
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