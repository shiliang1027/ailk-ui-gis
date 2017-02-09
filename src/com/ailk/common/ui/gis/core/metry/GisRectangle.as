package com.ailk.common.ui.gis.core.metry
{
	/**
	 * 矩形对象
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-7-1 下午03:33:41
	 * @category com.linkage.gis.core.metry
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisRectangle extends GisRegion
	{
		[Bindable]
		public var startPoint:GisPoint;
		[Bindable]
		public var centerPoint:GisPoint;
		[Bindable]
		public var width:Number;
		[Bindable]
		public var height:Number;
		public function GisRectangle(width:Number=0,height:Number=0,startPoint:GisPoint=null,centerPoint:GisPoint=null,parts:Array=null)
		{
			super(parts);
			this.width=width;
			this.height=height;
			this.startPoint = startPoint;
			this.centerPoint = centerPoint;
		}
		override public function toString():String{
			return "起点["+this.startPoint+"],中心点["+this.centerPoint+"],长["+this.width+"],宽["+this.height+"]";
		}
	}
}