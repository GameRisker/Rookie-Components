package com.gamerisker.containers
{
	import com.gamerisker.core.Component;
	import com.gamerisker.core.SkinnableContainer;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 *	 静态图片显示类	不可以设置宽度高度，显示的高度宽度为纹理的高宽度
	 * @author YangDan
	 * 
	 */	
	public class SkinImage extends SkinnableContainer
	{
		protected var m_background : Image;
		
		public function SkinImage()
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
		
		override public function get width():Number{	return m_width;}
		override public function set width(w:Number):void{}
		
		override public function get height():Number{return m_height;}
		override public function set height(h:Number):void{}
		
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);

			if(skinInvalid)
			{
				refreshSkin();
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
			var texture : Texture = skinInfo["skin"];
			if(m_background)
			{
				m_background.texture.dispose();
				m_background.texture = texture;
			}
			else
			{
				m_background = new Image(texture);
				addChildAt(m_background,0);
			}
			m_background.readjustSize();
			
			m_width = m_background.width;
			m_height = m_background.height;
		}
		
	}
}