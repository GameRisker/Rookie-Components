package com.gamerisker.core
{
	import com.gamerisker.event.ComponentEvent;
	
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	/**
	 * Component 类是所有可视组件的基类
	 * @author YangDan
	 */	
	public class Component extends Sprite implements IComponent
	{
		public const version : String = "1.0.0.0";
		
		/** @private */	
		protected static const VALIDATION_QUEUE : ValidationQueue = new ValidationQueue();
		
		/** @private */	
		protected static const INVALIDATION_FLAG_ALL : String = "all";
		
		/** @private */	
		protected static const INVALIDATION_FLAG_STATE : String = "state";
		
		/** @private */	
		protected static const INVALIDATION_FLAG_SIZE : String = "size";
		
		/** @private */	
		protected static const INVALIDATION_FLAG_SKIN : String = "skin";
		
		/** @private */	
		protected static const INVALIDATION_FLAG_DATA : String = "data";
		
		/** @private */	
		protected static const INVALIDATION_FLAG_SELECTED : String = "selected";
		
		/** @private */	
		protected static const INVALIDATION_FLAG_TEXT : String = "text";
		
		/** @private */	
		protected static const INVALIDATION_FLAG_INIT : String = "init";
		
		/** @private */	
		protected static const INVALIDATION_FLAG_LAYOUT : String = "layout";
		
		/** @private */	
		protected var m_invalidationFlags : Object = {"all" : true};	//默认设置all为true	第一次刷新所有方法
		
		/** @private */	
		protected var m_enabled : Boolean = true;
		
		/** @private */	
		protected var m_width : Number = 0;
		
		/** @private */	
		protected var m_height : Number = 0;
		
		/** @private */	
		protected var m_x : int;
		
		/** @private */	
		protected var m_y : int;
		
		/** @private */	
		protected function draw() : void{}
		
		/**
		 *	构造函数 
		 */		
		public function Component(){}
		
		/**
		 *	获取或设置 x 坐标，该坐标表示组件在其父容器内沿 x 轴的位置。 以像素为单位描述该值并且从顶部计算该值。 
		 *  <br>设置此属性将导致 move 事件被调度。
		 * @return 
		 * 
		 */		
		override public function get x() : Number{ return ( isNaN(m_x) )?super.x:m_x; }
		override public function set x(value : Number):void
		{
			if(m_x != value)
			{
				move(value,m_y);
			}
		}

		/**
		 *  获取或设置 y 坐标，该坐标表示组件在其父容器内沿 y 轴的位置。 以像素为单位描述该值并且从顶部计算该值。 
		 *  <br>设置此属性将导致 move 事件被调度。
		 * @return 
		 * 
		 */		
		override public function get y() : Number{return ( isNaN(m_y) )?super.y:m_y;}
		override public function set y(value : Number):void
		{
			if(m_y != value)
			{
				move(m_x,value);
			}
		}

		/**
		 *	将组件移动到其父项内的指定位置。 
		 * @param x : 指定组件在其父项内位置的 x 坐标值（以像素为单位）。 从左边计算该值。
		 * @param y : 指定组件在其父项内位置的 y 坐标值（以像素为单位）。 从顶部计算该值。  
		 */		
		public function move(x:Number , y : Number) : void
		{
			m_x = x;
			m_y = y;
			super.x = Math.round(x);
			super.y = Math.round(y);
		}
		
		/**
		 *	获取或设置一个值，该值指示组件是否可以接受用户交互。 
		 * @return 
		 * 
		 */		
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
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空
		 * 
		 */		
		public function Destroy() : void
		{
			dispose();
			m_invalidationFlags = null;
		}
		
		/**
		 *	 获取或设置组件的宽度（以像素为单位）。 
		 * @param value
		 * 
		 */		
		override public function get width() : Number{return m_width;}
		override public function set width(value : Number) : void
		{
			if(m_width == value || isNaN(value))
			{
				return;
			}
			
			m_width = Math.max(0,value);
			
			invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		/**
		 *	 获取或设置组件的高度，以像素为单位。 
		 * @return 
		 * 
		 */		
		override public function get height():Number{return m_height;}
		override public function set height(value : Number) : void
		{
			if(m_height == value || isNaN(value))
			{
				return;
			}
			
			m_height = Math.max(0,value);
			
			invalidate(INVALIDATION_FLAG_SIZE);
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
		 *	加入等待渲染序列 ，标记该组件属性已改变 ，等待下一帧渲染 
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
		 *	渲染序列内部调用方法。
		 *  <br>再调用invalidate()方法后，等待下一帧会调用该方法来进行渲染本身.
		 *  <br>组件再完成渲染后会触发 ComponentEvent.CREATEION_COMPLETE 事件
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