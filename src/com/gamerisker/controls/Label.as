package com.gamerisker.controls
{
	import com.gamerisker.core.Component;
	
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	/**
	 *	Label 组件将显示一行或多行纯文本，这些文本的对齐和大小格式可进行设置。 
	 * @author YangDan
	 * 
	 */	
	public class Label extends Component
	{
		protected var m_tf : TextField;
		protected var m_lable : String;
		protected var m_fontBold : Boolean = false;
		protected var m_fontColor : uint = 0xffffff;
		protected var m_align : String = "left";
		protected var m_fontName : String = "Verdana";
		protected var m_fontSize : int = 12;
		
		public function Label(){}
		
		override public function Destroy():void
		{
			if(m_tf)
			{				
				while(m_tf.numChildren>0)					
					m_tf.removeChildAt(0,true);								
				removeChild(m_tf);				
				m_tf.dispose();			
			}			
			m_tf = null;
		}
		
		/**
		 *	对 Label 组件的内部文本字段的引用。 
		 * @return 
		 * 
		 */		
		public function get textField() : TextField{return m_tf;}
		
		/**
		 *	获取或设置由 Label 组件显示的纯文本。 
		 * @return 
		 * 
		 */		
		public function get label():String{return m_lable;}
		public function set label(value:String):void
		{
			if(m_lable != value)
			{
				m_lable = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	获取或设置文本字体加粗
		 * @return 
		 * 
		 */		
		public function get bold():Boolean{return m_fontBold;}
		public function set bold(value:Boolean):void
		{
			if(m_fontBold != value)
			{
				m_fontBold = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	设置或设置文本颜色 
		 * @return 
		 * 
		 */		
		public function get color():uint{return m_fontColor;}
		public function set color(value:uint):void
		{
			if(m_fontColor != value)
			{
				m_fontColor = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	设置 文本的对齐方式：HAlign.CENTER;HAlign.LEFT;HAlign.RIGHT 
		 * @return 
		 * 
		 */		
		public function get align():String{return m_align;}
		public function set align(value:String):void
		{
			if(m_align != value)
			{
				m_align = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	设置文本字体 
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
		 *	设置文本字体大小 
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
		
		override protected function draw():void
		{
			const textInvalid : Boolean = isInvalid(INVALIDATION_FLAG_TEXT);
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
		    const layoutInvalid : Boolean = isInvalid(INVALIDATION_FLAG_LAYOUT);
			
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
			
			if(layoutInvalid)
			{
				refreshLayout();
			}
		}
		
		protected function refreshLayout() : void
		{
			if(m_tf.hAlign != m_align)
			{
				m_tf.hAlign = m_align;
			}
		}
		
		protected function refreshState() : void
		{
			if(m_tf.touchable != m_enabled)
			{
				m_tf.touchable = m_enabled;
			}
		}
		
		protected function refreshSize() : void
		{
			if(m_tf.width != m_width)
			{
				m_tf.width = m_width;
			}
			
			if(m_tf.height != m_height)
			{
				m_tf.height = m_height;
			}
		}
		
		protected function refreshText() : void
		{
			if(m_tf == null)
			{
				m_tf = new TextField(m_width,m_height,"");
				m_tf.autoSize = TextFieldAutoSize.VERTICAL;
				addChildAt(m_tf,0);
			}
						
			if(m_tf.text != m_lable)
			{
				m_tf.text = m_lable;
			}
			
			if(m_tf.bold != m_fontBold)
			{
				m_tf.bold = m_fontBold;
			}
			
			if(m_tf.color != m_fontColor)
			{
				m_tf.color = m_fontColor;
			}
			
			if(m_tf.fontName != m_fontName)
			{
				m_tf.fontName = m_fontName;
			}
			
			if(m_tf.fontSize != m_fontSize)
			{
				m_tf.fontSize = m_fontSize;
			}
		}		
	}
}