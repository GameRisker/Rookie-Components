package com.gamerisker.core
{
	import com.gamerisker.event.ComponentEvent;
	
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	/**
	 * Component类是所有可视组件的基类
	 * @author YangDan
	 */	
	public class Component extends Sprite implements IComponent
	{
		public const version : String = "1.0.0.0";
		
		protected static const VALIDATION_QUEUE : ValidationQueue = new ValidationQueue();
		
		protected static const INVALIDATION_FLAG_ALL : String = "all";
		
		protected static const INVALIDATION_FLAG_STATE : String = "state";
		
		protected static const INVALIDATION_FLAG_SIZE : String = "size";
		
		protected static const INVALIDATION_FLAG_SKIN : String = "skin";
		
		protected static const INVALIDATION_FLAG_DATA : String = "data";
		
		protected static const INVALIDATION_FLAG_SELECTED : String = "selected";
		
		protected static const INVALIDATION_FLAG_TEXT : String = "text";
		
		protected static const INVALIDATION_FLAG_LAYOUT : String = "layout";
		
		protected var m_invalidationFlags : Object = {"all" : true};	//默认设置all为true	第一次刷新所有方法
		
		protected var m_width : Number = 0;
		
		protected var m_height : Number = 0;
		
		protected var m_x : int
		override public function get x() : Number{ return ( isNaN(m_x) )?super.x:m_x; }
		override public function set x(value : Number):void
		{
			if(m_x != value)
			{
				move(value,m_y);
			}
		}

		protected var m_y : int;
		override public function get y() : Number{return ( isNaN(m_y) )?super.y:m_y;}
		override public function set y(value : Number):void
		{
			if(m_y != value)
			{
				move(m_x,value);
			}
		}

		public function move(x:Number , y : Number) : void
		{
			m_x = x;
			m_y = y;
			super.x = Math.round(x);
			super.y = Math.round(y);
		}
		
		protected var m_enabled : Boolean = true;
		public function get enabled():Boolean{return m_enabled;}
		public function set enabled(value:Boolean):void
		{
			if(m_enabled != value)
			{
				m_enabled = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}

		/**
		 *	验证并更新此对象的属性和布局，如果需要的话重绘对象。 
		 * 
		 */		
		public function validateNow() : void
		{
			invalidate(INVALIDATION_FLAG_ALL);
			draw();
		}
		
		public function Component(){}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空
		 * 
		 */		
		public function Destroy() : void
		{
			dispose();
			m_invalidationFlags = null;
		}

		protected var m_id : String;	
		public function get id():String{return m_id;}
		public function set id(value:String):void{m_id = value;}

		
		override public function set width(value : Number) : void
		{
			if(m_width == value || isNaN(value))
			{
				return;
			}
			
			m_width = Math.max(0,value);
			
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		override public function get width() : Number
		{
			return m_width;
		}
		
		override public function set height(value : Number) : void
		{
			if(m_height == value || isNaN(value))
			{
				return;
			}
			
			m_height = Math.max(0,value);
			
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		override public function get height():Number 
		{
			return m_height;
		}
		
		protected function draw() : void
		{

		}
		

		
		/**
		 *	检查是否正在等待
		 * @param flag
		 * @return 
		 * 
		 */		
		public function isInvalid(flag : String = null) : Boolean
		{
			if(!m_invalidationFlags)
			{
				return false;
			}
			if(m_invalidationFlags.hasOwnProperty(INVALIDATION_FLAG_ALL) && m_invalidationFlags[INVALIDATION_FLAG_ALL])
			{
				return true;
			}
			if(!flag)
			{
				for(flag in m_invalidationFlags)
				{
					return true;
				}
				return false;
			}
			return m_invalidationFlags[flag];
		}
		
		/**
		 *	加入等待序列 
		 * @param flag	修改值
		 * 
		 */		
		public function invalidate(flag : String = INVALIDATION_FLAG_ALL):void
		{
			if(!m_invalidationFlags.hasOwnProperty(flag))
			{
				m_invalidationFlags[flag] = true;
				VALIDATION_QUEUE.addControl(this);
			}			
		}
		
		/**
		 *	序列调用 
		 * 
		 */		
		public function validate() : void
		{
			if(isInvalid())
			{
				this.draw();
				
				for(var flag : String in m_invalidationFlags)
					delete m_invalidationFlags[flag];
				
				dispatchEventWith(ComponentEvent.CREATION_COMPLETE , false);
			}
		}
	}
}