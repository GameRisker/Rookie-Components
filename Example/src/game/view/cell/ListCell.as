package game.view.cell
{
	import com.gamerisker.containers.SkinImage;
	import com.gamerisker.controls.Label;
	
	import starling.filters.BlurFilter;

	/**
	 *	在线用户渲染器 
	 * @author GameRisker
	 * 
	 */	
	public class ListCell extends BaseCell
	{
		private var m_labName : Label;
		private var m_labLevel : Label;
		private var m_labSex : Label;
		private var m_imgDaoju : SkinImage;
		
		public function ListCell()
		{
			super("ListCell");
			
			m_labName = m_collection["Instante5"];//Instante5 是界面编辑器中的 id
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override public function setData(value:Object):void
		{
			super.setData(value);
			
			m_labName.label = value["name"];
		}		
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			
			if(value)
			{
				this.filter = BlurFilter.createGlow(0xffffff,1,5,1);
			}
			else
			{
				this.filter = null;	
			}
		}
	}
}
