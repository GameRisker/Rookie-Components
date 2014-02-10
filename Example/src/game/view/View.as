package game.view
{
	import com.gamerisker.core.Component;
	
	import game.Interface.IDestroy;
	import game.manager.ComponentManager;
	import game.manager.UIConfigManager;
	
	import starling.display.Sprite;
	
	public class View extends Sprite implements IDestroy
	{
		protected static var createNum : int;		//记录整个程序创建了多少组件
		
		protected var m_component : Component;
		protected var m_collection : Object;
		
		public function View(xmlName : String)
		{
			m_collection = new Object;
			m_component = ComponentManager.setComponentContainerXML(UIConfigManager.getViewXML(xmlName), m_collection);
			m_component.x = 0;
			m_component.y = 0;
			addChild(m_component);
			
			name = "view" + (++createNum);
		}
		
		
		public function destroy() : void
		{
			while(m_component.numChildren>0)
				m_component.removeChildAt(0,true);
			
			while(this.numChildren > 0)
				this.removeChildAt(0,true);
			
			for each(var item : Object in m_collection)
			{
				if(item is Component)
					(item as Component).Destroy();
			}
			
			m_collection = null;
			m_component = null;
		}
	}
}