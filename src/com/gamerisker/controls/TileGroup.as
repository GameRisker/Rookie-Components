package com.gamerisker.controls
{
	import com.gamerisker.core.Component;
	import com.gamerisker.event.ComponentEvent;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 *	ImageLoadBox 组件 集合 
	 * @author YangDan
	 * 
	 */
	public class TileGroup extends Component
	{
		/** @private */	
		protected var m_imgList : Vector.<Tile>;
		
		/** @private */	
		protected var m_boxWidth : int;
		
		/** @private */	
		protected var m_boxHeight : int;
		
		/** @private */	
		protected var m_hSpacing : int;
		
		/** @private */	
		protected var m_vSpacing : int;
		
		/** @private */	
		protected var m_hCount : int;
		
		/** @private */	
		protected var m_vCount : int;
		
		/** @private */	
		protected var m_list : Array;
		
		/** @private */	
		protected var m_property : String;								//访问文理对象属性名
		
		/** @private */	
		protected var m_count : int;
		
		/** @private */	
		protected var m_selectedIndex : int = -1;
		
		/** @private */	
		protected var m_selected : Boolean = true;					//获取或设置一个布尔值，指示列表中的项目是否可选。
		
		/**
		 *	获取或设置列表中的选定项目的索引。
		 * @return 
		 * 
		 */		
		public function get selectedIndex():int{return m_selectedIndex;}
		public function set selectedIndex(value:int):void
		{
			if(m_selectedIndex != value)
			{
				m_selectedIndex = value;
			}
			invalidate(INVALIDATION_FLAG_STATE);
		}

		/**
		 *	获取或设置从单选列表中选择的项目。 
		 * @param value
		 * 
		 */		
		public function set selectedItem(value : Object) : void{m_selectedIndex = m_list.indexOf(value);}
		public function get selectedItem() : Object
		{
			if(m_selectedIndex < 0 || m_selectedIndex > m_imgList.length)
				return null;
			
			return m_list[m_selectedIndex];
		}
		
		/**
		 *	获取或设置一个布尔值，指示表格中的项目是否可选。 
		 * @return 
		 * 
		 */		
		public function get selected() : Boolean{return m_selected;}
		public function set selected(value : Boolean) : void
		{
			if(m_selected != value)
			{
				m_selected = value;
			}
		}
		
		/**
		 *	构造函数
		 */		
		public function TileGroup()
		{
			m_imgList = new Vector.<Tile>;
		}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空 
		 */		
		override public function destroy():void
		{
			var box : Tile;
			for(var i:int=0;i<m_imgList.length;i++)
			{
				box = m_imgList[i];
				box.removeEventListener(ComponentEvent.IMAGELOADBOX_CLICK , onItemClick);
				removeChild(box);
				box.destroy();
			}
			m_imgList.length = 0;
			
			m_imgList = null;
			m_list = null;
			
			super.destroy();
		}
				
		/**
		 *	单元格数量 不要频繁更新count 影响性能
		 * @return 
		 * 
		 */		
		public function get count():int{return m_count;}
		public function set count(value:int):void
		{
			if(m_count != value)
			{
				m_count = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		/**
		 *	无法设置宽度，该组件的宽度是内部 Tile 的宽度 计算出来 
		 * @return 
		 * 
		 */		
		override public function get width():Number{return (m_hCount * m_boxWidth) + (m_hSpacing * (m_hCount -1))};
		override public function set width(w:Number):void{};
		
		/**
		 *	无法设置高度，该组件的高度是内部 Tile 的高度 计算出来 
		 * @return 
		 * 
		 */	
		override public function get height():Number{return (m_vCount * m_boxHeight) + (m_vSpacing * (m_hCount -1))};
		override public function set height(h:Number):void{};
		
		/**
		 *	竖向间距 
		 * @return 
		 * 
		 */		
		public function get rowSpacing():int{return m_hSpacing;}
		public function set rowSpacing(value:int):void
		{
			if(m_hSpacing != value)
			{
				m_hSpacing = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		/**
		 *	横向间距 
		 * @return 
		 * 
		 */		
		public function get colSpacing():int{return m_vSpacing;}
		public function set colSpacing(value:int):void
		{
			if(m_vSpacing != value)
			{
				m_vSpacing = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		/**
		 *	横向单元格数目 
		 * @return 
		 * 
		 */		
		public function get row():int{return m_hCount;}
		public function set row(value:int):void
		{
			if(m_hCount != value)
			{
				m_hCount = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}
		
		/**
		 *	竖向单元格数目 
		 * @return 
		 * 
		 */		
		public function get col():int{return m_vCount;}
		public function set col(value:int):void
		{
			if(m_vCount != value)
			{
				m_vCount = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		/**
		 *	单元格宽度 
		 * @return 
		 * 
		 */		
		public function get boxHeight():int{return m_boxHeight;}
		public function set boxHeight(value:int):void
		{
			if(m_boxHeight != value)
			{
				m_boxHeight = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		/**
		 *	单元格宽度 
		 * @return 
		 * 
		 */		
		public function get boxWidth():int{return m_boxWidth;};
		public function set boxWidth(value:int):void
		{
			if(m_boxWidth != value)
			{
				m_boxWidth = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}
		
		/**
		 *	设置数据数组 
		 * @param list
		 * @param name
		 * 
		 */		
		public function setListTexture(list : Array , name : String = "Icon") : void
		{
			if(list==null)
			{
				return;
			}

			m_property = name;
			m_list = list;
			
			invalidate(INVALIDATION_FLAG_DATA);
		}		
		
		/** @private */	
		override protected function draw():void
		{
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid : Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			const layoutInvalid : Boolean = isInvalid(INVALIDATION_FLAG_LAYOUT);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			
			if(m_list)
			{
				if(dataInvalid)
				{
					refreshData();
				}
				
				if(sizeInvalid || dataInvalid)
				{
					refreshSize();
				}
				
				if(layoutInvalid || dataInvalid || sizeInvalid)
				{
					refreshLayout();
				}
				
				if(stateInvalid)
				{
					refreshState();
				}
			}
		}
		
		/** @private */	
		protected function refreshState() : void
		{
			var box : Tile;
			var i : int;
			
			if(touchable != m_enabled)
			{
				touchable = m_enabled;
				if(!m_enabled)m_selected = m_enabled;
			}
			
			if(m_selected)
			{
				for(i=0;i<m_imgList.length;i++)
				{
					box = m_imgList[i];
					box.selected = (i == m_selectedIndex);
				}
			}
			else
			{
				clearSelected();
			}
		}
		
		/** @private */	
		protected function refreshSize() : void
		{
			var image : Tile;
			if(!m_imgList)
				return;
			
			image = m_imgList[0];
			for(var i:int=0;i<m_imgList.length;i++)
			{
				image = m_imgList[i];
				if(image)
				{
					if(image.width != m_boxWidth)
						image.width = m_boxWidth;
					if(image.height != m_boxHeight)
						image.height = m_boxHeight;
				}
			}
		}
		
		/** @private */	
		protected function refreshLayout() : void
		{
			var leng : int = m_imgList.length;
			var _changeX : int;
			var _changeY : int;
			var image : Tile;
			
			var i : int = 0;
			for(var _y :int=0;_y<m_vCount;_y++)
			{
				for(var _x:int=0;_x<m_hCount;_x++)
				{
					if(i<leng)
					{
						image = m_imgList[i];
						if(image)
						{
							_changeX = _x * (m_boxWidth + m_hSpacing);
							_changeY = _y * (m_boxHeight + m_vSpacing);
							
							if(_changeX != image.x)
								image.x = _changeX;
							if(_changeY != image.y)
								image.y = _changeY;
						}
					}
					i++;
				}
			}
		}
		
		/** @private */	
		protected function refreshData() : void
		{
			var image : Tile;
			var item : Object;
			var data : Object;
			
			removeBox(m_imgList.length - m_count);
			
			for(var i:int=0;i<m_imgList.length;i++)
			{
				image = m_imgList[i];
				data = m_list[i];
				
				if(!image)
				{
					image = new Tile();
					image.addEventListener(ComponentEvent.IMAGELOADBOX_CLICK , onItemClick);
					m_imgList[i] = addChildAt(image,i) as Tile;
				}
				
				image.setImageObject(data,m_property);
			}
		}

		/** @private */	
		private function clearSelected() : void
		{
			for(var i:int=0;i<m_imgList.length;i++)
				m_imgList[i].selected = false;
		}
		
		/**
		 *	移除多余的box 
		 * @param	num	: 多余的box数量
		 */
		private function removeBox(num : int) : void
		{
			var image : Tile;
			while(num > 0)
			{
				image = m_imgList.pop();
				image.removeEventListener(ComponentEvent.IMAGELOADBOX_CLICK , onItemClick);
				removeChild(image);
				image.destroy();
				num--;
			}
			
			m_imgList.length = m_count;
		}
				
		/**
		 *	点击单元格触发 
		 * @param event
		 * 
		 */		
		private function onItemClick(event : Event) : void
		{
			clearSelected();
			
			var item : Object = (event.data as Tile).data;
			m_selectedIndex = m_list.indexOf(item);
			
			dispatchEventWith(ComponentEvent.IMAGELOADGRID_ITEMCLICK,false,item);
			
			invalidate(INVALIDATION_FLAG_STATE);
		}
	}
}