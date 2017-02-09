package com.ailk.common.ui.gis.core
{
	import com.ailk.common.ui.gis.core.metry.GisMetry;
	import com.ailk.common.ui.gis.core.styles.GisStyle;
	
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenu;
	
	import mx.utils.UIDUtil;

	/**
	 * 地图对象类
	 * @author shiliang
	 * 
	 */
	public class GisFeature
	{
		public var id:String;
		public var gisMetry:GisMetry;
		public var gisStyle:GisStyle;
		public var gisLayerId:String;
		public var autoMoveToTop:Boolean;
		public var moveable:Boolean=false;
		public var toolTip:String;
		public var attributes:Object;
		public var alpha:Number=1;
		public var contextMenu:ContextMenu;
		public var buttonMode:Boolean;
		public var visible:Boolean=true;
		public var filters:Array;
		public var onClick:Function;
		public var onMouseOver:Function;
		public var onMouseOut:Function;
		public var contentMenus:Array;
		public var index:int=-1;
		public function GisFeature(gisMetry:GisMetry=null,gisStyle:GisStyle=null)
		{
			this.id = UIDUtil.createUID();
			this.gisMetry = gisMetry;
			this.gisStyle = gisStyle;
		}
		
		public function toString():String{
			return "id="+id+",index="+index+",gisMetry["+gisMetry+"],gisStyle["+gisStyle+"],autoMoveToTop="+autoMoveToTop+",moveable="+moveable+",toolTip="+toolTip+",attributes="+attributes+",alpha="+alpha+",contextMenu="+contextMenu+",buttonMode="+buttonMode+",visible="+visible+",filters="+filters+",onClick="+onClick+",onMouseOver="+onMouseOver+",onMouseOut="+onMouseOut;
		}
	}
}