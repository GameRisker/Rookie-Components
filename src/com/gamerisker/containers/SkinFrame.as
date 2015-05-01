package com.gamerisker.containers
{
	import com.gamerisker.core.SkinnableContainer;
	
	import flash.geom.Rectangle;
	
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.textures.Scale9Textures;
	
	/**
	 *	可缩放图片显示类	根据9宫格拉升
	 * {
	 * 		"skin" : 皮肤名称,
	 * 		"scale9GridX" : 9宫格X坐标,
	 * 		"scale9GridY" : 9宫格Y坐标,
	 * 		"scale9GridWidth" :  9宫格宽度,
	 * 		"scale9GridHeight" : 9宫格高度,
	 * 		"skinParent" : 皮肤父纹理集合
	 * }
	 * @author GameRisker
	 * 
	 */	
	public class SkinFrame extends SkinnableContainer
	{
		/** @private */	
		protected var m_background : Scale9Image;
		
		/**
		 *	构造函数 
		 * 
		 */		
		public function SkinFrame(){}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空 
		 * 
		 */		
		override public function destroy():void
		{
			if(m_background)
			{
				removeChild(m_background);
				m_background.dispose();
				m_background = null;
			}
			super.destroy();
		}
		
		/** @private */	
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
		
		/** @private */	
		protected function refreshState() : void
		{
			if(touchable != m_enabled)
			{
				this.touchable = m_enabled;
			}
		}
		
		/** @private */	
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
		
		/** @private */	
		protected function refreshSize() : void
		{
			if(m_background.width != m_width)
				m_background.width = m_width;
			
			if(m_background.height != height)
				m_background.height = height;
		}
	}
}
