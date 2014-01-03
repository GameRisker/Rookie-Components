package com.gamerisker.controls
{
	import com.gamerisker.core.Component;
	import com.gamerisker.event.ComponentEvent;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;

	/**
	 *	图片显示方形 
	 * @author YangDan
	 * 
	 */	
	public class Tile extends Component
	{
		private var m_background : Image;
		private var m_data : Object;
		private var m_filter:ColorMatrixFilter;
		private var m_name : String;
		private var m_selected : Boolean = false;

		/**
		 *	设置或设置 是否为选中状态 
		 * @return 
		 * 
		 */		
		public function get selected():Boolean
		{
			return m_selected;
		}

		public function set selected(value:Boolean):void
		{
			if(m_selected != value)
			{
				m_selected = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}

		/**
		 *	获取ImageLoadBox 的数据 
		 * @return 
		 * 
		 */		
		public function get data() : Object{return m_data;}
		
		/**
		 *	设置数据对象 
		 * @param data	数据
		 * @param name	texture属性名
		 * @param reset 	是否根据素材尺寸显示	ImageLoadBox
		 */		
		public function setImageObject(data : Object , name : String , reset : Boolean = false) : void
		{
			if(m_data != data)
			{
				m_data = data;
				m_name = name;
				
				invalidate(INVALIDATION_FLAG_SKIN);
				
				if(reset)
				{
					invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
		}
		
		public function Tile()
		{
			addEventListener(TouchEvent.TOUCH , onTouchEvent);
		}
		
		override public function Destroy():void
		{
			if(m_background)
			{
				removeEventListener(TouchEvent.TOUCH , onTouchEvent);
				
				if(m_background.filter)m_background.filter.dispose();
				m_background.filter = null;
				
				m_background.texture.dispose();
				
				removeChild(m_background);
				m_background.dispose();
				
				m_background = null;
				m_filter = null;
				m_data = null;
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
			
			if(m_enabled)
				setFilter(m_selected);
		}
		
		protected function refreshSkin() : void
		{
			if(m_data.hasOwnProperty(m_name))
			{
				if(data.hasOwnProperty(m_name))
					setImageTexture(data[m_name]);
				else
					throw(new ArgumentError("not found property"));
			}
			else
			{
				if(m_background)
					m_background.texture.dispose();
			}
		}
		
		protected function refreshSize() : void
		{
			if(m_background.width != m_width)
				m_background.width = m_width;
			if(m_background.height != m_height)
				m_background.height = m_height;
		}
		
		/**
		 *	 设置ImageLoadBox texture;
		 * @param texture
		 */		
		private function setImageTexture(texture : Texture) : void
		{
			if(!m_background)
			{
				m_background = new Image(texture);
				addChildAt(m_background,0);
			}
			else
			{
				m_background.texture.dispose();
				m_background.texture = texture;
			}
		}
		
		private function onTouchEvent(event : TouchEvent) : void
		{
			var touch : Touch = event.getTouch(this);
			if(touch == null)return;
			
			if(touch.phase == TouchPhase.BEGAN)
			{
				m_selected = !m_selected;
				dispatchEventWith(ComponentEvent.IMAGELOADBOX_CLICK,false,this);
			}
		}
		
		private function setFilter(value : Boolean) : void
		{
			if(!m_background)
				return;
			
			if(value)
			{
				if(!m_filter)
				{
					m_filter = new ColorMatrixFilter();
					m_filter.adjustContrast(1);
				}
				m_background.filter = m_filter;
			}
			else
			{
				if(m_background.filter!=null)
				{
					m_background.filter = null;
				}
			}
		}

	}
}