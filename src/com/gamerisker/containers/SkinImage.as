package com.gamerisker.containers
{
	import com.gamerisker.core.SkinnableContainer;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 *	 静态图片显示类	不可以设置宽度高度，显示的高度宽度为纹理的高宽度
	 * @author YangDan
	 * 	{	
	 * 		"skin" : 皮肤名称,
	 * 		"skinParent" : 皮肤父纹理集合
	 *	}
	 */	
	public class SkinImage extends SkinnableContainer
	{
		/** @private */	
		protected var m_background : Image;
		
		/** @private */
		protected var m_rotation : Number = 0;
		
		/**
		 *	构造函数 
		 */		
		public function SkinImage(){}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空 
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
		
		/**
		 *	设置图片角度 
		 * @return 
		 * 
		 */		
		override public function get rotation():Number{return m_rotation;}
		override public function set rotation(value:Number):void
		{
			if(value != m_rotation)
			{
				m_rotation = value;
				invalidate(INVALIDATION_FLAG_LAYOUT);
			}
		}
		
		/**
		 *	 无法设置宽度,可获得宽度
		 * @return 
		 */		
		override public function get width():Number{	return m_width;}
		override public function set width(w:Number):void{}
		
		/**
		 *	 无法设置高度,可获得高度
		 * @return 
		 */		
		override public function get height():Number{return m_height;}
		override public function set height(h:Number):void{}
		
		override public function set skinInfo(value:Object):void
		{
			if(value==null)
			{
				m_skinInfo = null;
				return;
			}
			
			m_skinInfo = value;
			
			var texture : Texture = m_skinInfo["skin"] as Texture;
			if(texture)
			{
				m_width = texture.width;
				m_height = texture.height;
			}
			
			invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		/** @private */	
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			const layoutInvalid : Boolean = isInvalid(INVALIDATION_FLAG_LAYOUT);

			if(skinInvalid)
			{
				refreshSkin();
			}
			
			if(stateInvalid)
			{
				refreshState();
			}
			
			if(layoutInvalid)
			{
				refreshLayout();
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
		}
		
		private function refreshLayout() : void
		{
			if(m_rotation != m_background.rotation)
			{
				m_background.rotation = m_rotation;
			}
		}
	}
}