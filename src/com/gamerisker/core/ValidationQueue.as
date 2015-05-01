package com.gamerisker.core
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	
	/**
	 * 核心渲染序列处理类
	 * @author GameRisker
	 * 
	 */	
	public class ValidationQueue implements IAnimatable
	{
		/** @private */	
		private var m_starling : Starling;
		
		/** @private */	
		private var m_isValidating : Boolean;
		
		/**
		 *	需要渲染队列 
		 */		
		private var m_queue : Vector.<IComponent> = new Vector.<IComponent>;
		
		/**
		 *	是否正在渲染 
		 */
		public function get isValidating():Boolean{return m_isValidating;}
		
		/**
		 *	构造函数 
		 * 
		 */		
		public function ValidationQueue()
		{
			m_starling = Starling.current;
		}
		
		/** @private */	
		public function advanceTime(time:Number):void
		{
			if(m_isValidating || m_queue.length == 0)
				return;

			m_isValidating = true;
			
			while(m_queue.length > 0)
			{
				var item : Component = m_queue.shift();
				item.validate();
			}
			
			m_isValidating = false;
		}
		
		/**
		 *	添加到渲染序列 
		 * @param control
		 * 
		 */		
		public function addControl(control : Component) : void
		{
			if(!m_starling.juggler.contains(this))
				m_starling.juggler.add(this);
			
			if(m_queue.indexOf(control) > -1)
			{
				return;
			}
			
			m_queue.push(control);
		}
	}
}
