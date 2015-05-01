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
	 * @author GameRisker
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
		private var m_label : String;	
		
		/** @private */	
		private var m_isCreateLabel : Boolean = false;
		
		/** @private */	
		private var m_tfOffsetX : int;
		
		/** @private */	
		private var m_tfOffsetY : int;
		
		/**
		 * 设置文本的偏移坐标 默认是按钮内部的0 
		 */
		public function get tfOffsetY():int{return m_tfOffsetY;}
		public function set tfOffsetY(value:int):void
		{
			if(m_tfOffsetY != value)
			{
				m_tfOffsetY = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 * 设置文本的偏移坐标 默认是按钮内部的0
		 */
		public function get tfOffsetX():int{return m_tfOffsetX;}
		public function set tfOffsetX(value:int):void
		{
			if(m_tfOffsetX != value)
			{
				m_tfOffsetX = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}
		
		/**
		 *	构造函数 
		 * 
		 */		
		public function CheckBox(){}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空 
		 */		
		override public function destroy():void
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
			super.destroy();
		}
		
		/**
		 *	是否创建textField 显示 
		 * @return 
		 */		
		public function get isCreateLabel():Boolean{return m_isCreateLabel;}
		public function set isCreateLabel(value:Boolean):void
		{
			if(m_isCreateLabel != value)
			{
				m_isCreateLabel = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
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
			if(m_label == null)
				return;
			
			if(m_textField && m_label=="" || !m_isCreateLabel)
			{
				removeChild(m_textField,true);
				m_textField = null;
				return;
			}
			
			if(m_isCreateLabel)
			{
				if(m_textField==null)
				{
					m_textField = new TextField(m_width,m_height,m_label);
					m_textField.autoSize = TextFieldAutoSize.HORIZONTAL;
					m_textField.touchable = m_enabled;
					addChild(m_textField);
				}
				
				if(m_label != m_textField.text)
				{
					m_textField.text = m_label;
				}
				
				m_textField.x = m_tfOffsetX;
				m_textField.y = m_tfOffsetY;
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
