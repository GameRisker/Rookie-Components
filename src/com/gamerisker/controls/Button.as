package com.gamerisker.controls
{
	import flash.geom.Rectangle;
	
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.textures.Scale9Textures;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	/**
	 * <p>按钮的实现，包含一张背景图片，一个文本，该按钮类，大多是参考的Starling里的Button,
	 * 你可以在实例化的时候给按钮传入两个纹理， 按钮弹起时的纹理、按钮按下时的纹理,可以实现按钮基于九宫格的宽度，高度设置</p>
	 * <br>纹理集合{	"skin" : 皮肤名称
	 * 				"upSkin" : 按钮弹起皮肤
	 * 			   	"downSkin" : 按钮按下皮肤
	 *             	"disabledSkin" : 按钮禁用皮肤
	 * 				"scale9GridX" : 9宫格X坐标
	 * 				"scale9GridY" : 9宫格Y坐标
	 * 				"scale9GridWidth" : 9宫格宽度
	 * 				"scale9GridHeight" : 9宫格高度
	 * 				"skinParent" : 皮肤父纹理集合		
	 * 				}
	 * @author GameRisker
	 */	
	public class Button extends BaseButton
	{
		/** @private */	
		protected var m_background		: Scale9Image;
		
		/** @private */	
		protected var m_textField 		: TextField;
		
		/** @private */	
		protected var m_scale9Grid		: Rectangle;
		
		/** @private */	
		protected var m_fontName		: String;
		
		/** @private */	
		protected var m_fontSize		: int = 12;
		
		/** @private */	
		protected var m_fontColor		: uint;
		
		/** @private */	
		protected var m_fontBold		: Boolean;
		
		/** @private */	
		protected var m_label 			: String;
		
		/**
		 *	构造函数 
		 */		
		public function Button(){}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空 
		 */		
		override public function destroy():void
		{
			removeChild(m_background);
			m_background.dispose();
			
			if(m_textField)
			{
				removeChild(m_textField);
				m_textField.dispose();
			}
			
			m_scale9Grid = null;
			m_textField = null;
			super.destroy();
		}
		
		/**
		 *	文本内容 
		 * @return 
		 * 
		 */	
		public function get label():String{return m_label;}
		public function set label(value:String):void
		{
			if(m_label != value)
			{
				m_label = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	设置字体 
		 * @return 
		 * 
		 */		
		public function get fontName():String{return m_fontName;}
		public function set fontName(value:String):void
		{
			if(m_fontName != value)
			{
				m_fontName = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	设置字体大小 
		 * @return 
		 * 
		 */		
		public function get fontSize():int{return m_fontSize;}
		public function set fontSize(value:int):void
		{
			if(m_fontSize != value)
			{
				m_fontSize = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	设置字体颜色 
		 * @return 
		 * 
		 */		
		public function get fontColor():uint{return m_fontColor;}
		public function set fontColor(value:uint):void
		{
			if(m_fontColor != value)
			{
				m_fontColor = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	设置字体是否加粗 
		 * @return 
		 * 
		 */		
		public function get fontBold():Boolean{return m_fontBold;}
		public function set fontBold(value:Boolean):void
		{
			if(m_fontBold != value)
			{
				m_fontBold = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/** @private */	
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			const textInvalid : Boolean = isInvalid(INVALIDATION_FLAG_TEXT);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			
			if(skinInvalid)
			{
				refreshSkin();	
			}
			
			if(stateInvalid)
			{
				refreshState();
			}
			
			if(textInvalid)
			{
				refreshText();	
			}
			
			if(textInvalid || sizeInvalid || skinInvalid || stateInvalid)
			{
				refreshSize();	
			}
		}
		
		/** @private */	
		protected function refreshState() : void
		{
			if(touchable != m_enabled)
			{
				if(m_enabled)
					m_background.textures = new Scale9Textures(upState , m_scale9Grid);
				else
					m_background.textures = new Scale9Textures(m_disabledState , m_scale9Grid);
				
				this.touchable = m_enabled;
			}
		}
		
		/** @private */	
		protected function refreshSkin() : void
		{
			m_scale9Grid = skinInfo["scale9Grid"];
			if(m_background==null && upState != null)
			{
				m_background = new Scale9Image(new Scale9Textures(upState , m_scale9Grid));
				m_background.readjustSize();
				addChildAt(m_background,0);
			}
			else
			{
				m_background.textures.dispose();
				m_background.textures = new Scale9Textures(upState , m_scale9Grid);
				m_background.readjustSize();
			}
		}
		
		/** @private */	
		protected function refreshText() : void
		{
			if(m_label == null)
				return;
			
			if(m_textField && m_label=="")
			{
				removeChild(m_textField,true);
				m_textField = null;
				return;
			}
			
			if(m_textField == null)
			{
				m_textField = new TextField(width , height , "");
				m_textField.autoSize = TextFieldAutoSize.HORIZONTAL;
				m_textField.touchable = false;
				addChild(m_textField);
			}
						
			if(m_label != m_textField.text)
			{
				m_textField.text = m_label;
			}
			
			if(m_fontName &&m_fontName != m_textField.fontName)
			{
				m_textField.fontName = m_fontName;
			}
			
			if(m_fontSize != m_textField.fontSize)
			{
				m_textField.fontSize = m_fontSize;
			}
			
			if(m_fontColor != m_textField.color)
			{
				m_textField.color = m_fontColor;
			}
			
			if(m_textField.bold != m_fontBold)
			{
				m_textField.bold = m_fontBold;
			}
		}
		
		/** @private */	
		protected function refreshSize() : void
		{
			if(m_background.width != m_width)
				m_background.width = m_width;
			
			if(m_background.height != m_height)
				m_background.height = m_height;

			if(m_textField)
			{
				var _x : int = (m_width - m_textField.width) >> 1;
				var _y : int = (m_height - m_textField.height) >> 1;
				
				if(m_textField.x != _x)
				{
					m_textField.x = _x;
				}
				
				if(m_textField.y != _y)
				{
					m_textField.y = _y;	
				}
			}
		}

		/** @private */	
		override protected function onTouchEvent(event : TouchEvent) : void
		{
			var touch : Touch = event.getTouch(this);
			if(!m_enabled || touch == null)return;
			
			if(touch.phase == TouchPhase.BEGAN && !m_isDown)
			{
				m_background.textures = new Scale9Textures(m_downState , m_scale9Grid);
				m_isDown = true;
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
			else if(touch.phase == TouchPhase.ENDED && m_isDown)
			{
				reset();
			}
		}
		
		/** @private */	
		private function reset():void
		{
			m_isDown = false;
			m_background.textures = new Scale9Textures(m_upState , m_scale9Grid);
		}
		
	}
}
