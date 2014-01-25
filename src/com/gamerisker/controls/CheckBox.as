package com.gamerisker.controls
{
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 *	CheckBox : 
	 * 皮肤设置 继承ImageButton;
	 * @author YangDan
	 */	
	public class CheckBox extends ImageButton
	{
		/** @private */	
		private var m_textField : TextField;
		
		/** @private */	
		private var m_callfunction : Function;
		
		/** @private */	
		private var m_data : Object;
		
		/** @private */	
		private var m_group : String = "CheckBoxGroup";
				
		/** @private */	
		private var m_lable : String;	
		
		/** @private */	
		private var m_isCreateLabel : Boolean = false;
		
		/**
		 *	构造函数 
		 * 
		 */		
		public function CheckBox(){}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空 
		 */		
		override public function Destroy():void
		{
			if(m_textField)
			{
				removeChild(m_textField);
				m_textField.dispose();
			}
			
			CheckBoxGroup.getInstance().removeButton(this);
			
			m_callfunction = null;
			m_data = null;
			m_textField = null;
			super.Destroy();
		}
		
		/**
		 *	是否创建textField 显示 
		 * @return 
		 */		
		public function get isCreateLabel():Boolean{return m_isCreateLabel;}
		public function set isCreateLabel(value:Boolean):void
		{
			m_isCreateLabel = value;
			invalidate(INVALIDATION_FLAG_TEXT);
		}
		
		/**
		 *	用于设置CheckBoxGroup的处理函数 
		 * @param fun
		 */		
		public function addListener(fun : Function) : void{m_callfunction = fun;}
		
		/**
		 *	设置CheckBox 的数据 
		 * @return 
		 */		
		public function get data():Object{return m_data;}
		public function set data(value:Object):void{m_data = value;}
		
		/**
		 *	设置label内容 
		 * @return 
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
		 *	设置checkbox的组标示 
		 * @return 
		 */		
		public function get group():String{return m_group;}
		public function set group(value:String):void{m_group = value;}
		
		
		/** @private */	
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			const textInvalid : Boolean = isInvalid(INVALIDATION_FLAG_TEXT);
			
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
		}
		
		/** @private */	
		override protected function refreshState():void
		{
			if(m_selected)
				m_background.texture = m_downState;
			else
				m_background.texture = m_upState;
			
			if(touchable != m_enabled)
			{
				this.touchable = m_enabled;
			}
		}
		
		/** @private */	
		protected function refreshText() : void
		{
			if(m_lable != null)
			{
				if(m_isCreateLabel)
				{
					if(m_textField==null)
					{
						m_textField = new TextField(m_width,m_height,m_lable);
						m_textField.autoSize = TextFieldAutoSize.HORIZONTAL;
						m_textField.touchable = m_enabled;
						addChild(m_textField);
					}
					
					m_textField.x = 30;
					m_textField.y = 10;
				}
				else if(m_textField)
				{
					removeChild(m_textField);
					m_textField = null;
				}
			}
		}
		
		/** @private */	
		override protected function onTouchEvent(event:TouchEvent):void
		{
			var touch : Touch = event.getTouch(this);
			if(!enabled || touch == null)return;
			
			if(touch.phase == TouchPhase.ENDED && m_callfunction!=null)
			{
				m_callfunction(this);
			}
		}
		
	}
}