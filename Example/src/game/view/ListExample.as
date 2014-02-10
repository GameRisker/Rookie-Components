package game.view
{
	import com.gamerisker.containers.SkinFrame;
	import com.gamerisker.containers.SkinImage;
	import com.gamerisker.containers.TitleWindow;
	import com.gamerisker.controls.Button;
	import com.gamerisker.controls.List;
	import com.gamerisker.controls.ScrollText;
	import com.gamerisker.controls.Tile;
	import com.gamerisker.controls.TileGroup;
	import com.gamerisker.core.Component;
	import com.gamerisker.event.ComponentEvent;
	
	import flash.utils.setTimeout;
	
	import game.manager.MouseManager;
	import game.manager.TexturesManager;
	import game.view.cell.ListCell;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	/**
	 *	List 实例 
	 * @author YangDan
	 * 
	 */	
	public class ListExample extends View
	{
		private var m_listData : Array;
		private var m_list : com.gamerisker.controls.List;
		private var Index : int = 0;
		private var m_button : Button;
		
		public function ListExample()
		{
			super("TestList");
			
			m_list = m_collection["List"];
			m_list.x = m_list.y = 100;
			m_list.setCellRender(ListCell);
			m_list.rowHeight = 100;
			m_list.addEventListener(ComponentEvent.LIST_ITEM_SELECTED , onItemSelected);
			
			m_listData = [];
			
			while(Index < 100)
			{
				m_listData.push({"name":Index++});
			}
			
			m_list.dataProvider = m_listData;
			
			m_button = m_collection["Button"];
			MouseManager.addTouch(TouchPhase.ENDED , m_button , OnButtonClick);
		} 
		
		/**
		 *	释放界面资源，请务必实现该方法释放自己的资源 
		 * 
		 */		
		override public function destroy() : void
		{
			MouseManager.removeTouch(TouchPhase.ENDED , m_button);
			m_list.removeEventListener(ComponentEvent.LIST_ITEM_SELECTED , onItemSelected);
			m_listData = null;
			
			super.destroy();
		}
		
		private function OnButtonClick(event : TouchEvent , touch : Touch , component : Component) : void
		{
			trace(component);
		}
		
		private function onItemSelected(event : Event) : void
		{
			trace(event.data["name"])
		}
	}
}