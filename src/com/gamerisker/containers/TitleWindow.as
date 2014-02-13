package com.gamerisker.containers
{
	import com.gamerisker.core.Component;
	import com.gamerisker.core.SkinnableContainer;
	import com.gamerisker.event.ComponentEvent;
	
	import flash.geom.Rectangle;
	
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.textures.Scale9Textures;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;

	/**
	 * 弹出框 
	 * 	{	
	 * 		"skin" : 皮肤名称,
	 * 		"scale9GridX" : 9宫格X坐标,
	 * 		"scale9GridY" : 9宫格Y坐标,
	 * 		"scale9GridWidth" : 9宫格宽度,
	 * 		"scale9GridHeight" : 9宫格高度,
	 * 		"textboundsX" : 弹出框title的X坐标,
	 * 		"textboundsY" : 弹出框title的Y坐标,
	 * 		"textboundsW" : 弹出框title的宽度,
	 * 		"textboundsH" : 弹出框title的高度,
	 * 		"skinParent" : 皮肤父纹理集合
	 *	}
	 * @author YangDan
	 */	
	public class TitleWindow extends SkinnableContainer
	{
		/**
		 * @private
		 *	弹出框	背景容器 
		 */		
		protected var m_background : Scale9Image;
		
		/**
		 * @private
		 *	弹出框	标题文本 
		 */		
		protected var m_textField : TextField;
		
		/**
		 * @private
		 *	弹出框	标题文本 属性 
		 */		
		protected var m_textBounds	: Rectangle;
		
		/**
		 * @private
		 *	弹出框	关闭按钮 
		 */		
		protected var m_closeButton : CloseButton;
		
		/**
		 * @private
		 *	弹出框	标题 
		 */		
		protected var m_title : String;
		
		/**
		 * @private
		 *	弹出框	标题字体大小 
		 */		
		protected var m_fontSize : int;
		
		/**
		 * @private
		 *	弹出框	标题文本 X 坐标 
		 */		
		protected var m_textX : int;
		
		/**
		 * @private
		 *	弹出框	标题文本 Y 坐标 
		 */		
		protected var m_textY : int;
		
		/**
		 * @private
		 *	弹出框	标题文本	宽度 
		 */		
		protected var m_textWidth : int;
		
		/**
		 * @private
		 *	弹出框	标题文本	高度 
		 */		
		protected var m_textHeight : int;
		
		/**
		 *	构造函数 
		 */		
		public function TitleWindow(){}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空  
		 */		
		override public function destroy():void
		{
			if(m_textField)
				removeChild(m_textField);
			
			removeChild(m_closeButton);
			m_closeButton.Destroy();
			
			removeChild(m_background);
			m_background.dispose();
			
			m_closeButton = null;
			m_background = null;
			m_textBounds = null;
			m_textField = null;
			super.destroy();
		}
		
		/**
		 *	标题字体大小 
		 * @return 
		 * 
		 */		
		public function get fontSize() : int{return m_fontSize;}		
		public function set fontSize(value : int) : void
		{
			if(m_fontSize != value)
			{
				m_fontSize = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	标题	X	坐标 
		 * @return 
		 * 
		 */		
		public function get textX():int{return m_textX;}
		public function set textX(value:int):void
		{
			if(m_textX != value)
			{
				m_textX = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	标题	Y	坐标 
		 * @return 
		 * 
		 */		
		public function get textY():int{return m_textY;}
		public function set textY(value:int):void
		{
			if(m_textY != value)
			{
				m_textY = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	标题		width 
		 * @return 
		 * 
		 */		
		public function get textWidth():int{return m_textWidth;}
		public function set textWidth(value:int):void
		{
			if(m_textWidth != value)
			{
				m_textWidth = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	标题		height 
		 * @return 
		 * 
		 */		
		public function get textHeight():int{	return m_textHeight;}
		public function set textHeight(value:int):void
		{
			if(m_textHeight != value)
			{
				m_textHeight = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	获取文本内容，如果没有文本类容 返回""; 
		 * @return 
		 * 
		 */	
		public function get title() : String{return m_title;}
		public function set title(value : String) : void
		{
			if(m_title != value)
			{
				m_title = value;
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
			
			if(textInvalid)
			{
				refreshText();
			}
			
			if(sizeInvalid)
			{
				refreshSize();
			}
			
			if(stateInvalid)
			{
				refreshState();
			}
		}
		
		/**
		 * @private
		 *	刷新状态 
		 * 
		 */		
		protected function refreshState() : void
		{
			if(touchable != m_enabled)
			{
				this.touchable = m_enabled;
			}
		}
		
		/**
		 * @private
		 *	刷新组建大小 
		 * 
		 */		
		protected function refreshSize() : void
		{
			if(m_background.width != m_width)
				m_background.width = m_width;
			
			if(m_background.height != m_height)
				m_background.height = m_height;
			
			var _x : int = m_width - m_closeButton.width + m_skinInfo["closeX"];
			var _y : int = m_skinInfo["closeY"];
			if(m_closeButton.x != _x)
			{
				m_closeButton.x = _x;
			}
			if(m_closeButton.y != _y)
			{
				m_closeButton.y = _y;
			}
		}
		
		/**
		 * @private
		 *	刷新TitleWindow	Title 
		 * 
		 */		
		protected function refreshText() : void
		{
			if(m_title == null || m_title == "")
				return;
			
			if(m_textField == null)
			{
				m_textField = new TextField(m_textBounds.width , m_textBounds.height , "","Verdana",12,0xffffff,true);
				m_textField.touchable = false;
				m_textField.autoSize = TextFieldAutoSize.HORIZONTAL;
				addChild(m_textField);
				m_textField.color = 0xffffff;
			}
			
			if(m_textBounds.width != textWidth)
			{
				m_textBounds.width = textWidth;
				m_textField.width = textWidth;
			}
			
			if(m_textBounds.height != textHeight)
			{
				m_textBounds.height = textHeight;
				m_textField.height = textHeight;
			}
			
			if(m_textBounds.x != textX)
			{
				m_textBounds.x = textX;
				m_textField.x = textX;
			}
			
			if(m_textBounds.y != textY)
			{
				m_textBounds.y = textY;
				m_textField.y = textY;
			}
			
			if(m_title != m_textField.text)
			{
				m_textField.text = m_title;
			}
			
			if(m_fontSize != m_textField.fontSize)
			{
				m_textField.fontSize = m_fontSize;
			}
		}
		
		/**
		 * @private
		 *	刷新TitleWindow	Skin 
		 * 
		 */		
		protected function refreshSkin() : void
		{
			const scale9Grid : Rectangle = m_skinInfo["scale9Grid"];
			m_textBounds = m_skinInfo["textBounds"];
			
			if(m_background)
			{
				m_background.textures.dispose();
				m_background.textures = new Scale9Textures(m_skinInfo["skin"] , scale9Grid);
			}
			else
			{
				m_background =  new Scale9Image(new Scale9Textures(m_skinInfo["skin"] , scale9Grid));
				addChildAt(m_background,0);
				m_closeButton = new CloseButton(m_skinInfo["closeUpSkin"],m_skinInfo["closeDownSkin"],onCloseEvent);
				addChildAt(m_closeButton,1);
			}
		}
		
		private function onCloseEvent(event : TouchEvent) : void
		{
			dispatchEventWith(ComponentEvent.CLOSEWINDOW);
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

class CloseButton extends Sprite
{
	private const MAX_DRAG_DIST:Number = 50;
	
	private var m_closeButton : Image;
	private var m_closeUpSkin : Texture;
	private var m_closeDownSkin : Texture;
	private var m_clickFun : Function;
	
	public function CloseButton(upSkin : Texture , downSkin : Texture , click : Function = null) : void
	{
		m_clickFun = click;
		
		m_closeUpSkin = upSkin;
		m_closeDownSkin = downSkin;
		
		m_closeButton = new Image(upSkin);
		m_closeButton.addEventListener(TouchEvent.TOUCH , onTouchEvent);
		addChild(m_closeButton);
	}
	
	public function Destroy() : void
	{
		m_closeUpSkin.dispose();
		m_closeDownSkin.dispose();
		m_closeButton.removeEventListener(TouchEvent.TOUCH , onTouchEvent);
		removeChild(m_closeButton,false);
		
		m_closeUpSkin = null;
		m_closeDownSkin = null;
	}
	
	private function onTouchEvent(event:TouchEvent):void
	{
		var touch : Touch = event.getTouch(this);
		if(touch == null)return;
		
		if(touch.phase == TouchPhase.BEGAN)
		{
			m_closeButton.texture = m_closeDownSkin;
		}
		else if(touch.phase == TouchPhase.MOVED)
		{
			var buttonRect:Rectangle = getBounds(stage);
			if (touch.globalX < buttonRect.x ||
				touch.globalY < buttonRect.y ||
				touch.globalX > buttonRect.x + buttonRect.width ||
				touch.globalY > buttonRect.y + buttonRect.height)
			{
				m_closeButton.texture = m_closeUpSkin;
			}
		}
		else if(touch.phase == TouchPhase.ENDED)
		{
			m_closeButton.texture = m_closeUpSkin;
			
			if(m_clickFun!=null)
				m_clickFun(event);
		}
	}
}