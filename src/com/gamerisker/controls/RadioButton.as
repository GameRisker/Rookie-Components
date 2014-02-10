package com.gamerisker.controls
{
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 *	使用 RadioButton 组件可以强制用户只能从一组选项中选择一项。 
	 *  该组件必须用于至少有两个 RadioButton 实例的组。 
	 *  在任何给定的时刻，都只有一个组成员被选中。 
	 *  选择组中的一个单选按钮将取消选择组内当前选定的单选按钮。 
	 *  您可以设置 group 参数，以指示单选按钮属于哪个组。  
	 * <br>皮肤设置继承ImageButton
	 * @author YangDan
	 * 
	 */	
	public class RadioButton extends ImageButton
	{
		/** @private */	
		private var m_data : Object;
		
		/** @private */	
		private var m_callfunction : Function;
		
		/** @private */	
		private var m_textField : TextField;
		
		/** @private */	
		private var m_group : String;
		
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
		 *	是否创建Label 
		 * @return 
		 * 
		 */		
		public function get isCreateLabel():Boolean{return m_isCreateLabel;}
		public function set isCreateLabel(value:Boolean) : void
		{
			if(m_isCreateLabel != value)
			{
				m_isCreateLabel = value;
				invalidate(INVALIDATION_FLAG_TEXT);
			}
		}

		/**
		 *	构造函数 
		 */		
		public function RadioButton()
		{
			m_width = 100;
			m_height = 20;
			group = "RadioButtonGroup";
		}
		
		override public function get width():Number
		{
			if(m_textField)
				return m_width + m_textField.width;
			
			return m_width;
		}
		
		override public function get height():Number
		{
			if(m_textField)
				return Math.max(m_textField.height , m_height);
			
			return m_height;
		}
		
		/**
		 *	 获取或设置 单选按钮实例或组的组名
		 * @return 
		 * 
		 */		
		public function get group():String{return m_group;}
		public function set group(value:String):void{m_group = value;}
		
		/**
		 *	 设置按钮的显示文本内容
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
		 *	该方法提供给 RadioButtonGroup调用，用来设置按钮属性 
		 * @param fun
		 * 
		 */		
		public function addListener(fun : Function) : void{m_callfunction = fun;}
		
		/**
		 *	设置或获取 数据 
		 * @return 
		 * 
		 */		
		public function get data():Object{return m_data;}
		public function set data(value:Object):void{m_data = value;}
		
		/**
		 *	指示单选按钮当前处于选中状态 (true) 还是取消选中状态 (false)。 
		 * @return 
		 * 
		 */		
		override public function get selected():Boolean{return m_selected;}
		override public function set selected(value:Boolean):void
		{
			if(m_selected != value)
			{
				m_selected = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空 
		 */		
		override public function Destroy():void
		{
			RadioButtonGroup.getInstance().removeButton(this);
			m_callfunction = null;
			m_data = null;
			if(m_textField)
			{
				removeChild(m_textField);
				m_textField.dispose();
				m_textField = null;
			}
			super.Destroy();
		}
		
		/** @private */	
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const textInvalid : Boolean = isInvalid(INVALIDATION_FLAG_TEXT);
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
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
		
		/** @private */	
		override protected function refreshState() : void
		{
			if(m_selected && m_background.texture != m_downState)
			{
				m_background.texture = m_downState;
			}
			else if(m_background.texture != m_upState)
			{
				m_background.texture = m_upState;
			}
			
			if(this.touchable != m_enabled)
			{
				this.touchable = m_enabled;
			}
		}
		
		/** @private */	
		protected function refreshSize() : void
		{
			if(m_textField)
			{
				if(m_textField.width != m_width)
				{
					m_textField.width = m_width;
				}
				
				if(m_textField.height != m_height)
				{
					m_textField.height != m_height;
				}
			}
		}
		
		/** @private */	
		protected function refreshText() : void
		{
			if(m_label==null)
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
					m_textField.touchable = true;
					addChildAt(m_textField,0);
				}
				
				if(m_textField.text != m_label)
				{
					m_textField.text = m_label;
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
			
			if(touch.phase == TouchPhase.ENDED&&m_callfunction!=null)
			{
				m_callfunction(this);
			}
		}
	}
}