package com.gamerisker.controls
{
	import com.gamerisker.core.Component;
	import com.gamerisker.core.SkinnableContainer;
	import com.gamerisker.event.ComponentEvent;
	
	import flash.geom.Point;
	
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.textures.Scale9Textures;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * <br>通过使用 Slider 组件，用户可以在滑块轨道的端点之间移动滑块来选择值。 
	 * Slider 组件的当前值由滑块端点之间滑块的相对位置确定，
	 * 端点对应于 Slider 组件的 minimum 和 maximum 值。 
	 * {
	 * 	 "skin": 皮肤名称
	 *   "upSkin" : 按钮弹起状态皮肤
	 *   "downSkin" : 按钮下去状态皮肤
	 *   "background" : 组件背景
	 *   "scale9GridX" :  9宫格X坐标, 
	 *   "scale9GridY" : 9宫格Y坐标,
	 *   "scale9GridWidth" : 9宫格宽度,
	 *   "scale9GridHeight" : 9宫格高度,
	 *   "skinParent" : 皮肤父纹理集合
	 * }
	 * @author GameRisker
	 * 
	 */	
	public class Slider extends SkinnableContainer
	{
		/** @private */	
		private var m_background : Scale9Image;
		
		/** @private */	
		private var m_thumb : Thumb;
		
		/** @private */	
		private var m_startPoint : Number;
		
		/** @private */	
		private var m_maximum : Number = 100;
		
		/** @private */	
		private var m_minimum : Number = 0;
		
		/** @private */	
		private var m_value : int;
		
		/**
		 *	构造函数 
		 */		
		public function Slider()
		{
			addEventListener(TouchEvent.TOUCH , onTouchEvent);
		}
		
		override public function destroy():void
		{
			removeChild(m_background);
			removeChild(m_thumb);
			
			removeEventListener(TouchEvent.TOUCH , onTouchEvent);
			
			m_background.dispose();
			m_thumb.Destroy();
			m_background = null;
			m_thumb = null;
			
			super.destroy();
		}
		
		/**
		 *	 height 高度无法设置，可获取高度
		 * @return 
		 * 
		 */		
		override public function set height(value:Number):void{}
		override public function get height():Number
		{
			if(m_background && m_thumb)
			{
				return Math.max(m_background.height , m_thumb.height);
			}
			return 0;
		}
		
		/**
		 *	获取或设置 Slider 组件的当前值。 
		 * @return 
		 * 
		 */		
		public function get value() : int{return m_value;}
		public function set value(val : int) : void
		{
			if(m_value != val)
			{
				m_value = val;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		/**
		 * 获取或设置 Slider 组件的当前值。
		 * @return 
		 * 
		 */		
		public function get maximum() : Number{return m_maximum;}
		public function set maximum(value : Number) : void{m_maximum = value;}
		
		/**
		 *	Slider 组件实例所允许的最小值。 
		 * @return 
		 * 
		 */		
		public function get minimum():Number{return m_minimum;}
		public function set minimum(value:Number):void{m_minimum = value;}


		/** @private */	
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid : Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);

			if(skinInvalid)
			{
				refreshSkin();
			}
			
			if(sizeInvalid)
			{
				refreshSize();	
			}
			
			if(dataInvalid)
			{
				refreshThumb();
			}
			
			if(stateInvalid)
			{
				refreshState();
			}
		}
		
		/**
		 *	刷新组件状态 
		 * 
		 */		
		protected function refreshState() : void
		{
			if(this.touchable != m_enabled)
			{
				this.touchable = m_enabled;
			}
		}
		
		/**
		 *	刷新组件皮肤 
		 * 
		 */		
		protected function refreshSkin() : void
		{
			if(m_background)
			{
				m_background.textures = new Scale9Textures(skinInfo["backtexture"] , skinInfo["scale9Grid"]);
				m_thumb.skinInfo = skinInfo;
			}
			else
			{
				m_background = new Scale9Image(new Scale9Textures(skinInfo["backtexture"] , skinInfo["scale9Grid"]));
				addChildAt(m_background,0);
				m_thumb = new Thumb(skinInfo["upSkin"] , skinInfo["downSkin"]);
				addChildAt(m_thumb,1);
			}
		}
		
		/**
		 *	刷新组件大小 
		 * 
		 */		
		protected function refreshSize() : void
		{
			if(m_background.width != m_width)
			{
				m_background.width = m_width;
			}
			
			if(m_background.height != m_height)
			{
				m_background.height = m_height;
			}
			
			m_background.x = 0;
			m_thumb.x = 0;
			m_background.y = (m_thumb.height - m_background.height) >> 1;
		}
		
		/**
		 *	组件内部交互处理函数 
		 * @param event
		 * 
		 */		
		private function onTouchEvent(event : TouchEvent) : void
		{
			var touch : Touch = event.getTouch(this);
			var point : Point = new Point;
			if(!touchable || touch == null)return;
		
			if(touch.phase == TouchPhase.BEGAN)
			{
				if(touch.target is Image)
				{
					m_startPoint = touch.globalX;
				}
				else if(touch.target is Scale9Image)
				{
					m_startPoint = m_thumb.x;
				}
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				setPosition(m_startPoint , touch.globalX);
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				if(touch.target is Scale9Image)
				{
					this.globalToLocal(new Point(touch.globalX , touch.globalY),point);
					setPosition(m_startPoint , (point.x - m_thumb.width/2));
				}
			}
		}

		/**
		 *	根据 thumb的位置 设置value值
		 * @param startPoint
		 * @param globalX
		 * 
		 */		
		private function setPosition(startPoint : Number , globalX : Number) : void
		{
			var endPoint : Number = globalX - startPoint;
			if((m_thumb.x + endPoint) < 0)
			{
				m_thumb.x = 0;
				m_value = m_minimum;
				dispatchEventWith(ComponentEvent.SLIDERCHANGE , false , this);
				return;
			}
			if((m_thumb.x + endPoint) > (m_width - m_thumb.width))
			{
				m_thumb.x = m_width - m_thumb.width;
				m_value = m_maximum;
				dispatchEventWith(ComponentEvent.SLIDERCHANGE , false , this);
				return;
			}
			
			m_thumb.x += endPoint;
			this.m_startPoint = globalX;
			m_value = int(m_minimum + (m_thumb.x / (m_width - m_thumb.width)) * (m_maximum - m_minimum));
			
			dispatchEventWith(ComponentEvent.SLIDERCHANGE , false , this);
		}
		
		/**
		 *	刷新 thumb的位置 
		 * 
		 */		
		private function refreshThumb() : void
		{
			m_thumb.x = (value-minimum)/(m_maximum-m_minimum)*(m_width - m_thumb.width);
		}
	}
}

import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

class Thumb extends Sprite
{
	private const MAX_DRAG_DIST:Number = 50;
	
	private var m_thumbButton : Image;
	private var m_thumbUpSkin : Texture;
	private var m_thumbDownSkin : Texture;
	
	public function Thumb(upSkin : Texture , downSkin : Texture) : void
	{
		m_thumbUpSkin = upSkin;
		m_thumbDownSkin = downSkin;
		
		m_thumbButton = new Image(upSkin);
		m_thumbButton.addEventListener(TouchEvent.TOUCH , onTouchEvent);
		addChild(m_thumbButton);
	}
	
	public function set skinInfo(value : Object) : void
	{
		m_thumbUpSkin = value["upSkin"];
		m_thumbDownSkin = value["downSkin"];
	}
	
	public function Destroy() : void
	{
		m_thumbUpSkin.dispose();
		m_thumbDownSkin.dispose();
		m_thumbButton.removeEventListener(TouchEvent.TOUCH , onTouchEvent);
		removeChild(m_thumbButton,false);
		
		m_thumbUpSkin = null;
		m_thumbDownSkin = null;
	}
	
	private function onTouchEvent(event:TouchEvent):void
	{
		var touch : Touch = event.getTouch(this);
		if(touch == null)return;
		
		if(touch.phase == TouchPhase.BEGAN)
		{
			m_thumbButton.texture = m_thumbDownSkin;
		}
		else if(touch.phase == TouchPhase.MOVED)
		{
			var buttonRect:Rectangle = getBounds(stage);
			if (touch.globalX < buttonRect.x ||
				touch.globalY < buttonRect.y ||
				touch.globalX > buttonRect.x + buttonRect.width ||
				touch.globalY > buttonRect.y + buttonRect.height)
			{
				m_thumbButton.texture = m_thumbUpSkin;
			}
		}
		else if(touch.phase == TouchPhase.ENDED)
		{
			m_thumbButton.texture = m_thumbUpSkin;
		}
	}
}
