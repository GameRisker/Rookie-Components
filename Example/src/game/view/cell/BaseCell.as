package game.view.cell
{
	import com.gamerisker.controls.renders.IListCell;
	
	import game.view.View;
	
	public class BaseCell extends View implements IListCell
	{
		protected var m_data : Object;
		protected var m_selected : Boolean;

		public function BaseCell(xmlName:String)
		{
			super(xmlName);
		}
		
		override public function destroy():void
		{
			m_data = null;
			
			super.destroy();
		}
				
		public function get selected():Boolean
		{
			return m_selected;
		}
		
		public function set selected(value:Boolean):void
		{
			m_selected = value;
		}
		
		public function setData(value:Object):void
		{
			m_data = value;
		}
		
		public function get data():Object
		{
			return m_data;
		}
	}
}