package com.gamerisker.controls
{
	import com.gamerisker.event.ComponentEvent;
	
	import starling.events.EventDispatcher;

	/**
	 *	 CheckBox	管理器
	 */	
	public class CheckBoxGroup extends EventDispatcher
	{
		private var m_group : Vector.<CheckBox> = new Vector.<CheckBox>;
		private static var m_instance : CheckBoxGroup;
		
		/**
		 *	构造函数 
		 * 
		 */		
		public function CheckBoxGroup(){}
		
		public static function getInstance() : CheckBoxGroup
		{
			if(m_instance)
				return m_instance;
			
			return m_instance = new CheckBoxGroup();
		}
		
		/**
		 *	CheckBox 添加 进 CheckBoxGroup 
		 * @param button
		 * 
		 */		
		public function addButton(button : CheckBox) : void
		{
			if(m_group.indexOf(button) > -1)
				return;
			
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
			var index : int = m_group.indexOf(button);
			
			if(index > -1)
			{
				m_group.splice(index,1);
			}
		}
		
		private function callFunction(button : CheckBox) : void
		{
			button.selected = !button.selected;
			dispatchEventWith(ComponentEvent.CHECKBOXCHANGE , false , button);
		}
	}
}