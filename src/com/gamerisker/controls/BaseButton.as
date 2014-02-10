package com.gamerisker.controls
{
	import com.gamerisker.core.Component;
	import com.gamerisker.core.SkinnableContainer;
	
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	/**
	 *	Button	基础类 
	 * <br>纹理集合{	"skin" : 皮肤名称,
	 * 				"upSkin" : 按钮弹起皮肤,
	 * 			   	"downSkin" : 按钮按下皮肤,
	 *             	"disabledSkin" : 按钮禁用皮肤,
	 * 				"scale9GridX" : 9宫格X坐标,
	 * 				"scale9GridY" : 9宫格Y坐标,
	 * 				"scale9GridWidth" : 9宫格宽度,
	 * 				"scale9GridHeight" : 9宫格高度,
	 * 				"skinParent" : 皮肤父纹理集合
	 * 				}
	 * @author YangDan
	 * 
	 */	
	public class BaseButton extends SkinnableContainer
	{
		/** @private */	
		protected static const MAX_DRAG_DIST	: Number = 0;
		
		/** @private */	
		protected var m_upState 				: Texture;
		
		/** @private */	
		protected var m_downState 				: Texture;
		
		/** @private */	
		protected var m_disabledState 			: Texture;
		
		/** @private */	
		protected var m_isToggle 				: Boolean;
		
		/** @private */	
		protected var m_isDown 				: Boolean;
		
		/** @private */	
		protected var m_selected 				: Boolean = false;

		/**
		 *	获取或设置一个布尔值，指示切换按钮是否处于选中状态。
		 * @return 
		 * 
		 */		
		public function get selected():Boolean{return m_selected;}
		public function set selected(value:Boolean):void
		{
			if(m_selected != value)
			{
				m_selected = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		/**
		 *	设置组件的纹理集合 
		 * @param value
		 * 
		 */		
		override public function set skinInfo(value:Object):void
		{
			if(value == null)
			{
				m_skinInfo = null;
				return;
			}
			
			m_skinInfo = value;
			m_upState = skinInfo["upSkin"];
			m_downState = skinInfo["downSkin"];
			m_disabledState = skinInfo["disabledSkin"];
			
			invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		/**
		 *	按钮未激活状态纹理 
		 * @param value
		 * 
		 */		
		public function get disabledState():Texture{return m_disabledState;}
		public function set disabledState(value:Texture):void
		{
			if(m_disabledState != value)
			{
				m_disabledState = value;
				invalidate(INVALIDATION_FLAG_SKIN);
			}
		}
		
		/**
		 * 文本弹起状态纹理 
		 * @return 
		 * 
		 */		
		public function get upState() : Texture{return m_upState;}
		public function set upState(value : Texture) : void
		{
			if(m_upState != value)
			{
				m_upState = value;
				invalidate(INVALIDATION_FLAG_SKIN);
			}
		}
		
		/**
		 *	文本按下纹理 
		 * @return 
		 * 
		 */		
		public function get downState() : Texture{return m_downState;}	
		public function set downState(value : Texture) : void
		{
			if(m_downState != value)
			{
				m_downState = value;
				invalidate(INVALIDATION_FLAG_SKIN);
			}
		}
		
		/**
		 *	获取或设置一个布尔值，指示按钮能否进行切换。
		 * @param value	true : 是 false : 否
		 * 
		 */		
		public function set toggle(value : Boolean) : void{m_isToggle = value;}
		public function get toggle() : Boolean{return m_isToggle;}
		
		/**
		 *	构造函数 
		 */		
		public function BaseButton()
		{
			this.addEventListener(TouchEvent.TOUCH , onTouchEvent);
		}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空 
		 */		
		override public function Destroy():void
		{
			this.removeEventListener(TouchEvent.TOUCH , onTouchEvent);
			
			if(m_upState)m_upState.dispose();
			if(m_downState)m_downState.dispose();
			if(m_disabledState)m_disabledState.dispose();
			
			m_upState = null;
			m_downState = null;
			m_disabledState = null;
			
			super.Destroy();
		}
		
		/** @private */	
		protected function onTouchEvent(event : TouchEvent) : void{}
	}
}