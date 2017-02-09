package com.ailk.common.ui.gis.core.metry
{
	/**
	 * 圆形对象
	 *
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2012-12-3
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class GisCircle extends GisRegion
	{
		/**
		 * 中心点 
		 */		
		public var centerPoint:GisPoint;
		/**
		 * 半径 
		 */		
		public var radius:Number=10;
		/**
		 * 圆周点总个数  
		 */		
		public var sides:Number=100;
		/**
		 * 圆形构造函数 
		 * @param centerPoint
		 * @param radius
		 * @param sides
		 * 
		 */		
		public function GisCircle(centerPoint:GisPoint,radius:Number=10,sides:uint=100)
		{
			this.centerPoint = centerPoint;
			this.radius = radius;
			this.sides = sides;
		}
		
		override public function toString():String{
			return "centerPoint["+centerPoint+"],radius["+radius+"],sides["+sides+"]";
		}
	}
}