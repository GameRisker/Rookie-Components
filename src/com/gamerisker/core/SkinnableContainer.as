package com.gamerisker.core
{
	/**
	 * SkinnableContainer 类是具有可视内容的可设置外观容器的基类
	 * @author YangDan
	 */	
	public class SkinnableContainer extends Component
	{
		/** @private */	
		protected var m_skinInfo : Object;
		
		public function SkinnableContainer(){}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空 
		 */		
		override public function destroy():void
		{
			m_skinInfo = null;
			
			super.destroy();
		}
		
		/**
		 *	设置皮肤内容
		 * @return 
		 * 
		 */		
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
		
		/**
		 *	获取当前皮肤名称,如果皮肤为设置则为null； 
		 * @return 
		 * 
		 */		
		public function get skin() : String
		{
			if(m_skinInfo && m_skinInfo.hasOwnProperty("name"))
				return m_skinInfo["name"];
			else
				return null;
		}
	}
}