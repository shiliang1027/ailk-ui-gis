package com.ailk.common.ui.gis.core.metry
{
	/**
	 * 扇形对象
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
	public class GisSector extends GisRegion
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
		 * 开始角度（如180或Math.PI）
		 */		
		public var startAngle:Number;
		/**
		 * 结束角度（如360或Math.PI*2）
		 */		
		public var endAngle:Number;
		/**
		 *  度数类型（0-角度，1-弧度）
		 */		
		public var angleType:uint;
		/**
		 * 圆周点总个数 
		 */		
		public var sides:Number=360;
		/**
		 * 扇形构造函数 
		 * @param centerPoint
		 * @param startAngle 默认0
		 * @param endAngle 默认360即Math.PI*2
		 * @param radius 默认10KM
		 * @param angleType 默认0(0-角度，1-弧度)
		 */		
		public function GisSector(centerPoint:GisPoint,startAngle:Number=0,endAngle:Number=360,radius:Number=10,angleType:uint=0)
		{
			this.centerPoint = centerPoint;
			this.startAngle = startAngle;
			this.endAngle = endAngle;
			this.radius = radius;
			this.angleType = angleType;
		}
		
		override public function toString():String{
			return "centerPoint["+centerPoint+"],radius["+radius+"],startAngle["+startAngle+"],endAngle["+endAngle+"],angleType["+angleType+"]";
		}
	}
}