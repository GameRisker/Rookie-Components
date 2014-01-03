package com.gamerisker.containers
{
	import com.gamerisker.controls.ScrollBar;
	import com.gamerisker.controls.renders.IListCell;
	import com.gamerisker.core.Component;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * BaseScrollPane 类 处理基础的滚动功能
	 * @author YangDan
	 * 
	 */	
	public class BaseScrollPane extends Component
	{
		public static const INVALIDATION_FLAG_INIT : String = "init";
		
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT : String = "float";
		
		public static const SCROLL_BAR_DISPLAY_MODE_NONE : String = "none";
		
		protected const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[1, 1.33, 1.66, 2];
		
		protected const CURRENT_VELOCITY_WEIGHT : Number = 2.33;
		
		protected const MINIMUM_VELOCITY:Number = 0.02;
		
		protected const FRICTION:Number = 0.998;
		
		protected const EXTRA_FRICTION:Number = 0.95;
		
		protected const ELASTICITY : Number = 0.33;
		
		protected const ELASTICSNAPDURATION:Number = 0.5;

		protected const HELPER_POINT : Point = new Point;
		
		protected var INVALIDATION_FLAG_CREATE : String = "create";
		
		protected var m_verticalScrollBar : ScrollBar;
		
		protected var m_maxVerticalScrollPosition : Number;
		
		protected var m_minVerticalScrollPosition : Number;
		
		protected var m_verticalScrollPosition : Number = 0;
		
		protected var m_verticalAutoScrollTween : Tween;
		
		protected var m_scrollRect : Rectangle;											//可视范围的宽高
		
		protected var m_background : DisplayObjectContainer;
		
		protected var m_velocityY : Number;
		
		protected var m_previousTouchY : Number;
		
		protected var m_startTouchY : Number;
		
		protected var m_currentTouchY : Number;
		
		protected var m_startVerticalScrollPosition : Number;
		
		protected var m_previousTouchTime : int;
		
		protected var m_isTouching : Boolean;									//是否滑动
		
		protected var m_previousVelocityY : Vector.<Number> = new Vector.<Number>;

		protected var m_topViewPortOffset : Number = 0;
		
		protected var m_scrollBarDisplayMode : String;
		
		/**
		 *	容器的坐标 
		 * @return 
		 * 
		 */		
		public function get verticalScrollPosition():Number{return m_verticalScrollPosition;};
		public function set verticalScrollPosition(value:Number):void{m_verticalScrollPosition = value;};

		
		public function BaseScrollPane()
		{
		}
		
		override public function Destroy():void
		{
			m_background.removeEventListener(TouchEvent.TOUCH , onTouchEvent);
			removeChild(m_background);
			removeChild(m_verticalScrollBar);
			m_verticalScrollBar.Destroy();
			m_verticalScrollBar = null;
			m_verticalAutoScrollTween = null;
			
			m_background.dispose();
			m_background = null;
			m_scrollRect = null;
			super.Destroy();
		}
		
		/**
		 *	 设置滚动条显示状态
		 * @param value
		 * 
		 */		
		public function set scrollBarDisplayMode(value : String) : void{m_scrollBarDisplayMode = value;}
		public function get scrollBarDisplayMode():String{return m_scrollBarDisplayMode;}
		
		override protected function draw():void
		{
			const initInvalid : Boolean = isInvalid(INVALIDATION_FLAG_INIT);
			const createInvalid : Boolean = isInvalid(INVALIDATION_FLAG_CREATE);
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			
			if(initInvalid)
			{
				refreshInit();
			}
			
			if(sizeInvalid)
			{
				refreshSize();
			}
			
			if(createInvalid)
			{
				createScrollBars();
			}
		}
		
		protected function refreshSize():void
		{
			var isChange : Boolean;
			
			if(m_scrollRect.width != m_width)
			{
				m_scrollRect.width = m_width;
				isChange = true;
			}
			
			if(m_scrollRect.height != m_height)
			{
				m_scrollRect.height = m_height;
				isChange = true;
			}
			
			if(isChange)
			{
				this.clipRect = m_scrollRect;
			}
		}
		
		protected function refreshInit() : void
		{
			m_scrollBarDisplayMode = SCROLL_BAR_DISPLAY_MODE_FLOAT;
			m_minVerticalScrollPosition = 0;
			m_maxVerticalScrollPosition = 0;
			m_scrollRect = new Rectangle(0,0,100,100);		//默认宽100 ， 高100
			m_background.addEventListener(TouchEvent.TOUCH , onTouchEvent);
			addChild(m_background);
		}
		
		protected function createScrollBars() : void
		{
			if(m_scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_NONE)
			{
				if(!m_verticalScrollBar)
				{
					this.m_verticalScrollBar = new ScrollBar();
					this.m_verticalScrollBar.hideScrollBar();
					addChild(m_verticalScrollBar);
				}
				
				this.m_verticalScrollBar.minScrollPosition = m_minVerticalScrollPosition;
				this.m_verticalScrollBar.maxScrollPosition = m_maxVerticalScrollPosition;
				this.m_verticalScrollBar.height = m_scrollRect.height;
				this.m_verticalScrollBar.x = m_scrollRect.width - 10;
			}
		}
		
		/**
		 *	鼠标操作 
		 * @param event
		 * 
		 */		
		protected function onTouchEvent(event : TouchEvent) : void
		{
			var touch : Touch = event.getTouch(m_background);
			if(touch == null)return;
			
			touch.getLocation(this,HELPER_POINT);
			
			if(touch.phase == TouchPhase.BEGAN)
			{
				if(this.m_verticalAutoScrollTween)
				{
					Starling.juggler.remove(this.m_verticalAutoScrollTween);
					this.m_verticalAutoScrollTween = null;
				}
				
				m_velocityY = 0;
				m_previousTouchY = m_startTouchY = m_currentTouchY = HELPER_POINT.y;
				m_startVerticalScrollPosition = m_verticalScrollPosition;
				
				this.m_previousTouchTime = getTimer();
				
				this.addEventListener(Event.ENTER_FRAME , onEnterFrame);
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				m_currentTouchY = HELPER_POINT.y;
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this.removeEventListener(Event.ENTER_FRAME , onEnterFrame);
				
				if(this.m_verticalScrollPosition < this.m_minVerticalScrollPosition || this.m_verticalScrollPosition > this.m_maxVerticalScrollPosition)
				{
					this.finishScrollingVertically();
					return;
				}
				
				var sum : Number = m_velocityY * CURRENT_VELOCITY_WEIGHT;
				var velocityCount : int = m_previousVelocityY.length;
				var totalWeight : Number = CURRENT_VELOCITY_WEIGHT;
				for(var i:int = 0;i<velocityCount;i++)
				{
					var weight : Number = VELOCITY_WEIGHTS[i];
					sum += m_previousVelocityY.shift() * weight;
					totalWeight += weight;
				}
				this.throwVertically(sum / totalWeight);
			}
		}

		/**
		 *	 
		 * @param event
		 * 
		 */		
		protected function onEnterFrame(event : Event) : void
		{
			const now : int = getTimer();
			const timeOffset : int = now - this.m_previousTouchTime;
			if(timeOffset > 0)
			{
				this.m_velocityY = (this.m_currentTouchY - this.m_previousTouchY) / timeOffset;
				this.m_previousTouchTime = now;
				this.m_previousTouchY = this.m_currentTouchY;
			}
			
			if(!this.m_verticalAutoScrollTween)
			{
				updateVerticalScrollFromTouchPosition(m_currentTouchY);
			}
		}
		
		/**
		 * 判断是否超越范围、超越就恢复
		 * @private
		 */
		protected function finishScrollingVertically():void
		{
			var targetVerticalScrollPosition:Number = NaN;
			if(this.m_verticalScrollPosition < this.m_minVerticalScrollPosition)
			{
				targetVerticalScrollPosition = this.m_minVerticalScrollPosition;
			}
			else if(this.m_verticalScrollPosition > this.m_maxVerticalScrollPosition)
			{
				targetVerticalScrollPosition = this.m_maxVerticalScrollPosition;
			}
			this.throwTo(targetVerticalScrollPosition, ELASTICSNAPDURATION);
		}
		
		/**
		 *	更新		verticalScrollPosition 值 
		 * @param touchY
		 * 
		 */		
		protected function updateVerticalScrollFromTouchPosition(touchY : Number) : void
		{
			const offset:Number = m_startTouchY - touchY;
			
			if(offset != 0 )
			{
				var position:Number = m_startVerticalScrollPosition + offset;
				
				if(position < this.m_minVerticalScrollPosition)
				{
					position -= (position - this.m_minVerticalScrollPosition) * (1 - ELASTICITY);
				}
				else if(position > this.m_maxVerticalScrollPosition)
				{
					position -= (position - this.m_maxVerticalScrollPosition) * (1 - ELASTICITY);
				}
				
				this.m_verticalScrollPosition = position;
				
				onChangePosition();
			}
		}
		
		/**
		 *	获取缓动速度、目标坐标 
		 * @param pixelsPerMS
		 * 
		 */		
		protected function throwVertically(pixelsPerMS:Number):void
		{
			const absPixelsPerMS:Number = Math.abs(pixelsPerMS);
			
			if(absPixelsPerMS <= MINIMUM_VELOCITY)
			{
				scrollTweenComplete();
				return;
			}
			var targetVerticalScrollPosition:Number = m_verticalScrollPosition + (pixelsPerMS - MINIMUM_VELOCITY) / Math.log(FRICTION);
			if(targetVerticalScrollPosition < this.m_minVerticalScrollPosition || targetVerticalScrollPosition > this.m_maxVerticalScrollPosition)
			{
				var duration:Number = 0;
				targetVerticalScrollPosition = m_verticalScrollPosition;
				while(Math.abs(pixelsPerMS) > MINIMUM_VELOCITY)
				{
					targetVerticalScrollPosition -= pixelsPerMS;
					if(targetVerticalScrollPosition < this.m_minVerticalScrollPosition || targetVerticalScrollPosition > this.m_maxVerticalScrollPosition)
					{
						pixelsPerMS *= FRICTION * EXTRA_FRICTION;
					}
					duration++;
				}
			}
			else
			{
				duration = Math.log(MINIMUM_VELOCITY / absPixelsPerMS) / Math.log(FRICTION);
			}
			this.throwTo(targetVerticalScrollPosition,duration / 1000);
		}
		
		/**
		 *	缓动处理函数 
		 * @param targetVerticalScrollPosition
		 * @param duration
		 * 
		 */		
		protected function throwTo(targetVerticalScrollPosition:Number = NaN, duration:Number = 0.5) : void
		{
			if(!isNaN(targetVerticalScrollPosition))
			{
				if(this.m_verticalScrollPosition != targetVerticalScrollPosition)
				{
					this.m_verticalAutoScrollTween = new Tween(this, duration, Transitions.EASE_OUT);
					this.m_verticalAutoScrollTween.animate("verticalScrollPosition", targetVerticalScrollPosition);
//					this.m_verticalAutoScrollTween.onUpdate  = onChangePosition;
					this.m_verticalAutoScrollTween.onStart = onStartTween;
					this.m_verticalAutoScrollTween.onComplete = verticalAutoScrollTween_onComplete;
					Starling.juggler.add(this.m_verticalAutoScrollTween);
				}
				else
				{
					this.finishScrollingVertically();
				}
			}
		}
		
		/**
		 *	Tween 开始执行 
		 * 
		 */		
		protected function onStartTween() : void
		{
			this.addEventListener(Event.ENTER_FRAME , onEnterFrameTween);
		}
		
		/**
		 *	 更新坐标
		 * 
		 */		
		protected function onEnterFrameTween() : void
		{
			onChangePosition()
		}
		
		/**
		 *	操作完成 
		 * 
		 */		
		protected function scrollTweenComplete() : void
		{
			//滚动条透明度控制
			if(m_verticalScrollBar)
			{
				m_verticalScrollBar.hideScrollBar();
			}

			this.removeEventListener(Event.ENTER_FRAME,onEnterFrameTween);
			m_isTouching = false;
		}
		
		/**
		 *	缓动运行结束 
		 * 
		 */		
		protected function verticalAutoScrollTween_onComplete() : void
		{
			this.m_verticalAutoScrollTween = null;
			this.finishScrollingVertically();
			
			if(!this.m_verticalAutoScrollTween)
			{
				scrollTweenComplete();
			}
		}
		
		/**
		 *	verticalScrollPosition	值数据改变后调用该方法更新数据容器坐标
		 * 
		 */		
		protected function onChangePosition() : void
		{
			m_isTouching = true;
			updatePosition();
		}

		/**
		 *	更新滚动条坐标，显示容器坐标 
		 * 
		 */		
		protected function updatePosition() : void
		{

		}
		
	}
}