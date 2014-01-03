package com.gamerisker.controls
{
	import com.gamerisker.containers.BaseScrollPane;
	
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	/**
	 *	缓动文本组件 
	 * @author YangDan
	 * 
	 */	
	public class ScrollText extends BaseScrollPane
	{
		protected var m_text : String;
		protected var m_fontBold : Boolean = false;
		protected var m_fontSize : int = 12;
		protected var m_fontColor : uint = 0xffffff;
		protected var m_align : String = "left";
		protected var m_fontName : String = "Verdana";
		
		/**
		 *	设置文本 
		 * @return 
		 * 
		 */		
		public function get text():String{return m_text;}
		public function set text(value:String):void
		{
			m_text = value;
			invalidate(INVALIDATION_FLAG_STATE);
		}
		
		/**
		 *	设置文本加粗 
		 * @return 
		 * 
		 */		
		public function get fontBold():Boolean{return m_fontBold;}
		public function set fontBold(value:Boolean):void
		{
			if(m_fontBold != value)
			{
				m_fontBold = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}

		/**
		 *	设置文本颜色 
		 * @return 
		 * 
		 */		
		public function get fontColor():uint{return m_fontColor;}
		public function set fontColor(value:uint):void
		{
			if(m_fontColor != value)
			{
				m_fontColor = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}

		/**
		 *	设置文本对齐方式 
		 * @return 
		 * 
		 */		
		public function get align():String{return m_align;}
		public function set align(value:String):void
		{
			if(m_align != value)
			{
				m_align = value;
				invalidate(INVALIDATION_FLAG_STATE);
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
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}

		/**
		 *	设置文本大小 
		 * @return 
		 * 
		 */		
		public function get fontSize():int{return m_fontSize;}
		public function set fontSize(value:int):void
		{
			if(m_fontSize != value)
			{
				m_fontSize = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		public function ScrollText()
		{
			m_background = new TextField(10,10,"","Verdana",48,0xffffff);
			TextField(m_background).autoSize = TextFieldAutoSize.VERTICAL;
			TextField(m_background).hAlign = HAlign.LEFT;
		}
		
		override public function Destroy():void
		{
			super.Destroy();
		}
		
		override protected function draw():void
		{
			const initInvalid : Boolean = isInvalid(INVALIDATION_FLAG_INIT);
			const createInvalid : Boolean = isInvalid(INVALIDATION_FLAG_CREATE);
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid : Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			
			if(initInvalid)
			{
				refreshInit();
			}
			
			if(sizeInvalid)
			{
				refreshSize();
			}
			
			if(dataInvalid)
			{
				refreshData();
			}
			
			if(createInvalid)
			{
				createScrollBars();
			}
			
			if(stateInvalid)
			{
				refreshState();
			}
		}
		
		protected function refreshState() : void
		{
			(m_background as TextField).bold = m_fontBold;
			(m_background as TextField).color = m_fontColor;
			(m_background as TextField).hAlign = m_align;
			(m_background as TextField).fontName = m_fontName;
		}
		
		override protected function refreshSize() : void
		{
			super.refreshSize();
			
			(m_background as TextField).width = m_width - 10;
			(m_background as TextField).height = m_height;
			(m_background as TextField).fontSize = m_fontSize;
		}
		
		protected function refreshData() : void
		{
			var textField : TextField = TextField(m_background);
			
			textField.text = m_text;
			m_maxVerticalScrollPosition = Math.max(0,textField.height - m_scrollRect.height);
			
			this.finishScrollingVertically();
		}
		
		override protected function updatePosition():void
		{
			var _verticalScrollPosition : Number = m_topViewPortOffset - verticalScrollPosition;

			if(m_verticalScrollBar)
			{
				m_verticalScrollBar.showScrollBar();
				m_verticalScrollBar.scrollPosition = verticalScrollPosition;
			}
			
			m_background.y = _verticalScrollPosition;
		}
	}
}