package com.gamerisker.controls
{
	import com.gamerisker.event.ComponentEvent;
	
	import starling.events.EventDispatcher;

	/**
	 *	 CheckBox	管理器
	 */	
	public class CheckBoxGroup extends EventDispatcher
	{
		private var m_group : Array;
		
		/**
		 *	构造函数 
		 * 
		 */		
		public function CheckBoxGroup()
		{
			m_group = new Array;
		}
		
		/**
		 *	CheckBox 添加 进 CheckBoxGroup 
		 * @param button
		 * 
		 */		
		public function addButton(button : CheckBox) : void
		{
			for(var i : int=0;i<m_group.length;i++)
			{
				if(m_group[i] == button)
					return;
			}
			button.checkBoxGroup = this;
			button.addListener(callFunction);
			m_group.push(button);
		}
		
		/**
		 *	从CheckBoxGroup 删除CheckBox
		 * @param button
		 * 
		 */		
		public function removeButton(button : CheckBox) : void
		{
			for(var i : int =0;i<m_group.length ; i++)
			{
				if(m_group[i]==button)
				{
					button.checkBoxGroup = null;
					m_group.splice(i,1);
				}
			}
		}
		
		private function callFunction(button : CheckBox) : void
		{
			button.selected = !button.selected;
			dispatchEventWith(ComponentEvent.CHECKBOXCHANGE , false , button);
		}
	}
}