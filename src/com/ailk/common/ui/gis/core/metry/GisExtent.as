package com.ailk.common.ui.gis.core.metry
{
	/**
	 * 区域范围对象
	 * @author shiliang(6614) Tel:13770527121
	 * @version 1.0
	 * @since 2011-7-14 上午10:37:11
	 * @category com.linkage.gis.core.metry
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisExtent extends GisRectangle
	{
		public var xmin:Number;
		public var xmax:Number;
		public var ymin:Number;
		public var ymax:Number;
		public var center:GisPoint;
		public var type:String;
		public function GisExtent(type:String=null,width:Number=0,height:Number=0,xmin:Number=0,xmax:Number=0,ymin:Number=0,ymax:Number=0,center:GisPoint=null)
		{
			super(width,height);
			this.type = type;
			this.xmin = xmin;
			this.xmax = xmax;
			this.ymin = ymin;
			this.ymax = ymax;
			this.startPoint = new GisPoint(this.xmin,this.ymin);
			this.center = center;
			parts = new Array();
			parts.push(new GisPoint(this.xmin,this.ymin));
			parts.push(new GisPoint(this.xmax,this.ymin));
			parts.push(new GisPoint(this.xmax,this.ymax));
			parts.push(new GisPoint(this.xmin,this.ymax));
		}
		override public function toString():String{
			return "width="+width+",height="+height+",xmin="+xmin+",xmax="+xmax+",ymin="+ymin+",ymax="+ymax+",center="+center+",type="+type;
		}
	}
}