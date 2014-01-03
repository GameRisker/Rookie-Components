package com.gamerisker.controls
{
	import com.gamerisker.event.ComponentEvent;
	
	import starling.events.EventDispatcher;

	/**
	 * 	RadioButton	管理器
	 * @author YangDan
	 * 
	 */	
	public class RadioButtonGroup extends EventDispatcher
	{
		private static var EventHandler : EventDispatcher = new EventDispatcher();
		private var m_group : Array;
		private var m_currentbutton : RadioButton;
		protected var m_groupName : String = "defulatname";
		
		public function RadioButtonGroup()
		{
			m_group = new Array;	
		}
		
		public function addButton(button : RadioButton) : void
		{
			for(var i : int=0;i<m_group.length;i++)
			{
				if(m_group[i] == button)
					return;
			}
			button.radioButtonGroup = this;
			button.addListener(callFunction);
			m_group.push(button);
		}
		
		public function removeButton(button : RadioButton) : void
		{
			for(var i : int =0;i<m_group.length ; i++)
			{
				if(m_group[i]==button)
				{
					button.radioButtonGroup = null;
					m_group.splice(i,1);
				}
			}
		}

		private function callFunction(button : RadioButton) : void
		{
			for(var i:int=0;i<m_group.length;i++)
			{
				if(button == m_group[i])
				{
					if(!button.selected)
					{
						m_group[i].selected = true;
						
						dispatchEventWith(ComponentEvent.RADIOBUTTONCHANGE , false , button);
					}
				}
				else if(button.group == m_group[i].group)
				{
					m_group[i].selected = false;
				}
			}
			
			m_currentbutton = button;
		}
	}
}