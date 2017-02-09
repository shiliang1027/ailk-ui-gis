package com.ailk.common.ui.gis.utils
{
	/**
	 * 
	 *
	 * @author shiliang (66614)
	 * @version 1.0
	 * @date 2012-12-28
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class IPUtil
	{
		public static const a1:Number = getIpNum("10.0.0.0");
		public static const a2:Number = getIpNum("10.255.255.255");
		public static const b1:Number = getIpNum("172.16.0.0");
		public static const b2:Number = getIpNum("172.31.255.255");
		public static const c1:Number = getIpNum("192.168.0.0");
		public static const c2:Number = getIpNum("192.168.255.255");
		public static const d1:Number = getIpNum("10.44.0.0");
		public static const d2:Number = getIpNum("10.69.0.255");

		public static function isInnerIP(ip:String):Boolean{
			var n:Number = getIpNum(ip);
			return (n >= a1 && n <= a2) || (n >= b1 && n <= b2) || (n >= c1 && n <= c2) || (n >= d1 && n <= d2);
		}
		
		public static function getIpNum(ipAddress:String):Number{
			var ip:Array = ipAddress.split(".");   
			var a:Number = Number(ip[0]);   
			var b:Number = Number(ip[1]);   
			var c:Number = Number(ip[2]);   
			var d:Number = Number(ip[3]);   
			return a * 256 * 256 * 256 + b * 256 * 256 + c * 256 + d;
		}
	}
}