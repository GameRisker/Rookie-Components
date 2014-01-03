package com.gamerisker.controls
{
	import com.gamerisker.core.Component;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 *	滚动条  
	 * @author YangDan
	 * 
	 */	
	public class ScrollBar extends Component
	{
		public static const HORIZONTAL : String = "horizontal";
		
		public static const VERTICAL : String = "vertical";
		
		private static const DEFAULT_RADIUS : int = 6;
		
		private static const DEFAULT_ALPHA : Number = 0.8;
		
		private static const DEFAULT_COLOR : int = 0x666666;
			
		protected var m_background : Image;
		
		protected var m_scrollbarSize : int;							//滚动条大小
		
		protected var m_direction : String = "vertical";

		protected var m_maxScrollPosition : Number = 0;

		protected var m_minScrollPosition : Number = 0;

		protected var m_scrollPosition : Number;

		protected var m_scrollbarTween : Tween;
		
		/**
		 *	获取或设置当前滚动位置并更新滑块的位置。 
		 */
		public function get scrollPosition():Number{return m_scrollPosition;}
		public function set scrollPosition(value:Number):void
		{
			if(m_scrollPosition != value)
			{
				m_scrollPosition = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		/**
		 * 获取或设置表示最高滚动位置的数字。 
		 * @return 
		 * 
		 */		
		public function get maxScrollPosition():Number{return m_maxScrollPosition;}
		public function set maxScrollPosition(value:Number):void
		{
			if(m_maxScrollPosition != value)
			{
				m_maxScrollPosition = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}
		
		/**
		 *	获取或设置表示最低滚动位置的数字。 
		 * @return 
		 * 
		 */		
		public function get minScrollPosition():Number{return m_minScrollPosition;}
		public function set minScrollPosition(value:Number):void
		{
			if(m_minScrollPosition != value)
			{
				m_minScrollPosition = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}
		
		/**
		 *	获取或设置一个值，该值指示滚动条是水平滚动还是垂直滚动。 
		 * @return 
		 * 
		 */		
		public function get direction():String{return m_direction;}
		public function set direction(value:String):void
		{
			if(m_direction != value)
			{
				m_direction = value;
				invalidate(INVALIDATION_FLAG_SKIN);
			}
		}
		
		/**
		 *	显示滚动条 
		 * 
		 */		
		public function showScrollBar() : void
		{
			this.alpha = 1;
		}
		
		/**
		 *	隐藏滚动条 
		 * 
		 */		
		public function hideScrollBar() : void
		{
			if(!m_scrollbarTween)
			{
				m_scrollbarTween = new Tween(this,0.25);
				m_scrollbarTween.fadeTo(0);
				m_scrollbarTween.onComplete = function():void{m_scrollbarTween = null;};
				Starling.juggler.add(m_scrollbarTween);
			}
		}
		
		public function ScrollBar(){}
		
		override public function Destroy():void
		{
			removeChild(m_background);
			m_background = null;
			m_scrollbarTween = null;
			
			super.Destroy();
		}
		
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			
			if(sizeInvalid)
			{
				if(maxScrollPosition != 0)
				{
					m_scrollbarSize = Math.max(DEFAULT_RADIUS,(m_height / (maxScrollPosition + m_height) * m_height));
				}
			}
			
			if(sizeInvalid || skinInvalid)
			{
				createScrollBar();
			}
			
			if(stateInvalid)
			{
				refreshState();	
			}
		}
		
		private function refreshState() : void
		{	
			if(m_maxScrollPosition > 0)
			{
				if(m_scrollPosition > m_maxScrollPosition)
				{
					m_scrollbarSize = Math.max(DEFAULT_RADIUS,(m_height / (m_scrollPosition + m_height) * m_height));
					createScrollBar();
					this.y = m_height - m_scrollbarSize;
					return;
				}
				else if(m_scrollPosition < m_minScrollPosition)
				{
					m_scrollbarSize = Math.max(DEFAULT_RADIUS,(m_height / (maxScrollPosition + m_height + Math.abs(m_minScrollPosition - m_scrollPosition)) * m_height));
					createScrollBar();			
					this.y = 0;
					return;
				}
				
				switch(m_direction)
				{
					case HORIZONTAL :
						this.x = m_width * Math.min(1,(m_scrollPosition / (maxScrollPosition + m_height)));
						break
					case VERTICAL :
						this.y = m_height * Math.min(1,(m_scrollPosition / (maxScrollPosition + m_height)));
						break
				}
			}
		}
		
		/**
		 *	创建	ScrollBar 
		 * 
		 */		
		private function createScrollBar():void
		{
			if(!m_background)
			{
				m_background = new Image(getScrollBarBitmap(m_direction , m_scrollbarSize , DEFAULT_RADIUS));
				addChildAt(m_background , 0);
			}
			else
			{
				if(m_scrollbarSize != 0 && m_background.width != m_scrollbarSize)
				{
					m_background.texture.dispose();
					m_background.texture = getScrollBarBitmap(m_direction , m_scrollbarSize , DEFAULT_RADIUS);
				}
			}
			m_background.readjustSize();
		}
		
		/**
		 *	获取 ScrollBar	 
		 * @param dire			方向
		 * @param value			高度 或 宽度
		 * @param radius		圆角
		 * @return 
		 * 
		 */		
		private function getScrollBarBitmap(dire : String, value : int , radius : int) : Texture
		{
			var shape : Shape = new Shape;
			shape.graphics.beginFill(DEFAULT_COLOR, DEFAULT_ALPHA);
			
			var bitdata : BitmapData;
			
			switch(dire)
			{
				case HORIZONTAL :
					bitdata = new BitmapData(value , radius , true , 0x0);
					shape.graphics.drawRoundRect(0, 0, value, radius, radius);
					break
				case VERTICAL :
					bitdata = new BitmapData(radius,value, true, 0x0);
					shape.graphics.drawRoundRect(0, 0, radius, value, radius);
					break
			}
			
			shape.graphics.endFill();
			bitdata.draw(shape);
			var texture : Texture = Texture.fromBitmapData(bitdata) as Texture;
			bitdata.dispose();
			return texture;
		}
	}
}