package com.gamerisker.core
{
	/**
	 *	 SkinContainer : 含有skinInfo属性的显示对象基类
	 * @author YangDan
	 */	
	public class SkinnableContainer extends Component
	{
		protected var m_skinInfo : Object;
		
		public function SkinnableContainer()
		{
			super();
		}
		
		override public function Destroy():void
		{
			m_skinInfo = null;
			
			super.Destroy();
		}
		
		public function get skinInfo() : Object {return m_skinInfo;}
		public function set skinInfo(value : Object) : void
		{
			if(value==null)
			{
				m_skinInfo = null;
				return;
			}
			
			m_skinInfo = value;
			
			invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		public function get skin() : String
		{
			if(m_skinInfo && m_skinInfo.hasOwnProperty("name"))
				return m_skinInfo["name"];
			else
				return null;
		}
	}
}