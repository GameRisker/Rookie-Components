package com.gamerisker.controls
{
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 *	图片按钮 	该组件不能设置 宽度 高度。按钮未设置纹理前，宽度，高度均为0
	 * <br>纹理集合{	"upSkin" : 按钮弹起皮肤
	 * 			   	"downSkin" : 按钮按下皮肤
	 *             	"disabledSkin" : 按钮禁用皮肤
	 * 				"skinParent" : 皮肤父纹理集合		
	 * 				}
	 * @author GameRisker
	 * 
	 */	
	public class ImageButton extends BaseButton
	{
		/** @private */	
		protected var m_background : Image;
		
		/**
		 *	构造函数 
		 * 
		 */		
		public function ImageButton(){}
		
		/**
		 *	无法设置宽度，可以获取宽度 
		 * @return 
		 * 
		 */		
		override public function get width():Number{return m_width;}
		override public function set width(w:Number):void{}
		
		/**
		 *	无法设置高度，可以获取高度 
		 * @return 
		 * 
		 */		
		override public function get height():Number{return m_height;}
		override public function set height(h:Number):void{}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空  
		 */		
		override public function destroy():void
		{
			if(m_background)
			{
				removeChild(m_background);
				m_background.dispose();
			}
			super.destroy();
		}
		
		/** @private */	
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			
			if(skinInvalid)
			{
				refreshSkin();
			}
			
			if(stateInvalid)
			{
				refreshState();	
			}
		}
		
		/** @private */	
		protected function refreshSkin() : void
		{
			if(m_background)
			{
				m_isDown = false;
				m_background.texture.dispose();
				m_background.texture = m_upState;
			}
			else
			{
				m_background = new Image(m_upState);
				addChildAt(m_background,0);
			}
			m_background.readjustSize();
			
			m_width = m_background.width;
			m_height = m_background.height;
		}
		
		/** @private */	
		protected function refreshState() : void
		{
			if(m_background.touchable != m_enabled)
			{
				if(m_enabled)
					m_background.texture = m_upState;
				else 
					m_background.texture = m_disabledState;
				
				m_background.touchable = m_enabled;
			}
		}
		
		/** @private */	
		override protected function onTouchEvent(event:TouchEvent):void
		{
			var touch : Touch = event.getTouch(this);
			if(!m_enabled || touch == null)return;
			
			if(touch.phase == TouchPhase.BEGAN && !m_isDown)
			{
				if(m_isToggle)
				{
					if(m_background.texture == m_downState)
						m_background.texture = m_upState;
					else
						m_background.texture = m_downState;
				}
				else
				{
					m_background.texture = m_downState;
					m_isDown = true;
				}
			}
			else if(touch.phase == TouchPhase.MOVED && m_isDown)
			{
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
					touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
					touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
					touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
				{
					reset();
				}
			}
			else if(touch.phase == TouchPhase.ENDED && m_isDown && !m_isToggle)
			{
				reset();
			}
		}
		
		/** @private */	
		protected function reset():void
		{
			m_isDown = false;
			m_background.texture = m_upState;
		}
	}
}
