package com.ailk.common.ui.gis.core
{
	/**
	 * 地图对象右键菜单条目对象
	 * @author shiliang(66614) Tel:13770527121
	 * @version 1.0
	 * @since 2012-4-27 下午08:11:09
	 * @category com.linkage.gis.core
	 * @copyright 南京联创科技 网管开发部
	 */
	public class GisContextMenuItem
	{
		private var _caption:String;
		private var _callback:Function;
		private var _separatorBefore:Boolean;
		private var _enabled:Boolean;
		private var _visible:Boolean;
		
		public function GisContextMenuItem(caption:String,callback:Function=null, separatorBefore:Boolean = false, enabled:Boolean = true, visible:Boolean = true)
		{
			this.caption = caption;
			this.callback = callback;
			this.separatorBefore = separatorBefore;
			this.enabled = enabled;
			this.visible = visible;
		}
		public function get caption():String
		{
			return _caption;
		}
		
		public function set caption(value:String):void
		{
			_caption = value;
		}

		public function get callback():Function
		{
			return _callback;
		}

		public function set callback(value:Function):void
		{
			_callback = value;
		}

		public function get separatorBefore():Boolean
		{
			return _separatorBefore;
		}

		public function set separatorBefore(value:Boolean):void
		{
			_separatorBefore = value;
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
		}


	}
}