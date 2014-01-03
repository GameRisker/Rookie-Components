package com.gamerisker.containers
{
	import com.gamerisker.core.Component;
	import com.gamerisker.core.SkinnableContainer;
	
	import flash.geom.Rectangle;
	
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.textures.Scale9Textures;
	
	import starling.textures.Texture;
	
	/**
	 *	可缩放图片显示类	根据9宫格拉升
	 * @author YangDan
	 * 
	 */	
	public class SkinFrame extends SkinnableContainer
	{
		protected var m_background : Scale9Image;
		
		public function SkinFrame()
		{

		}
		
		override public function Destroy():void
		{
			if(m_background)
			{
				removeChild(m_background);
				m_background.dispose();
				m_background = null;
			}
			super.Destroy();
		}
		
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);

			if(skinInvalid)
			{
				refreshSkin();
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
		
		protected function refreshState() : void
		{
			if(touchable != m_enabled)
			{
				this.touchable = m_enabled;
			}
		}
		
		protected function refreshSkin() : void
		{
			const m_scale9Grid : Rectangle = m_skinInfo["scale9Grid"];
			if(m_background)
			{
				m_background.textures.dispose();
				m_background.textures = new Scale9Textures(m_skinInfo["skin"] , m_scale9Grid);
			}
			else
			{
				m_background =  new Scale9Image(new Scale9Textures(m_skinInfo["skin"] , m_scale9Grid));
				addChildAt(m_background,0);
			}
		}
		
		protected function refreshSize() : void
		{
			if(m_background.width != m_width)
				m_background.width = m_width;
			
			if(m_background.height != height)
				m_background.height = height;
		}
	}
}