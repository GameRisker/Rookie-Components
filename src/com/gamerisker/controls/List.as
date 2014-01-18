package com.gamerisker.controls
{
	import com.gamerisker.containers.BaseScrollPane;
	import com.gamerisker.controls.renders.IListCell;
	import com.gamerisker.event.ComponentEvent;
	
	import flash.geom.Rectangle;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 *  List 组件将显示基于列表的信息，并且是适合显示信息数组的理想选择。 
	 *  该组件必须调用setCellRender方法设置List的渲染器<br> 
	 * @author YangDan
	 * 
	 */	
	public class List extends BaseScrollPane
	{
		/** @private */	
		protected static const INVALIDATION_FLAG_SCROLLBAR : String = "scrollbar";
		
		/** @private */	
		protected var m_activeCellRenderers : Vector.<IListCell>;							//活动的渲染器数组
		
		/** @private */	
		protected var m_rowHeight : Number = 20;											//Cell的高度	本身高度加间隔高度
		
		/** @private */	
		protected var m_rowCount : int;													//最少可见列数
		
		/** @private */	
		protected var m_hCount : int;
		
		/** @private */	
		private var m_cellClass : Class;
		
		/** @private */	
		private var m_listData : Array;
		
		/** @private */	
		private var m_maxCount : int;														//LIST最大保存数据条数
			
		/** @private */	
		private var m_preciousTouchTime : Number;
		
		/** @private */	
		private var m_selectedIndex : int = -1;
		
		/** @private */	
		private var m_selected : Boolean = true;

		/**
		 *	构造函数 
		 * 
		 */		
		public function List()
		{
			m_maxCount = int.MAX_VALUE;
			m_activeCellRenderers = new Vector.<IListCell>;
			m_background = new Sprite;
		}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空 
		 */		
		override public function Destroy():void
		{
			clearCell();

			m_listData = null;
			m_cellClass = null;
			m_activeCellRenderers = null;
			m_previousVelocityY = null;
			
			super.Destroy();
		}
		
		/**
		 *	获取或设置一个布尔值，指示列表中的项目是否可选。 
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
		 *	获取或设置列表中每一行的高度，以像素为单位。
		 * @return 
		 * 
		 */		
		public function get rowHeight():Number{return m_rowHeight;}
		public function set rowHeight(value:Number):void{m_rowHeight = value;}
		
		/**
		 *	List的总列数 
		 * @return 
		 * 
		 */		
		public function get length() : int{return m_hCount;}
		
		/**
		 *	设置List 最大显示列 	如果不设置，就没有限制
		 * @param value
		 * 
		 */		
		public function set maxLength(value : int) : void
		{
			m_maxCount = value;
		}
		
		/**
		 *	获取或设置单选列表中的选定项目的索引。 
		 * @return 
		 * 
		 */		
		public function get selectedIndex():int{return m_selectedIndex;};
		public function set selectedIndex(value:int):void
		{
			m_selectedIndex = value;
		}
		
		/**
		 * 获取或设置从单选列表中选择的项目。 
		 * @return 
		 * 
		 */		
		public function get selectedItem() : Object
		{
			if(m_selectedIndex > m_listData.length)
				return m_listData[m_selectedIndex];
			else
				return null;
		}
		
		public function set selectedItem(value : Object) : void
		{
			var index : int = m_listData.indexOf(value);
			if(index > -1)
				selectedIndex = index;
		}
				
		/**
		 * 设置渲染器
		 * @param cellRender	渲染器(渲染器必须实现Destroy、setData方法)
		 * 
		 */
		public function setCellRender(cellRender : Class) : void
		{
			if(m_cellClass != cellRender)
			{
				m_cellClass = cellRender;
				invalidate(INVALIDATION_FLAG_SKIN);
			}
		}
		
		/**
		 *	设置List数据 
		 * @param value
		 * @param reset	滑动条是否归位	false:不归位
		 */		
		public function get dataProvider() : Array{return m_listData;}
		public function set dataProvider(value : Array) : void
		{
			if(value == null)return;
			
			m_listData = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 *	将列表滚动至位于指定索引处的项目。 
		 * @param newCaretIndex
		 * 
		 */		
		public function scrollToIndex(newCaretIndex : int) : void
		{
			var lastVisibleItemIndex:uint = Math.floor((verticalScrollPosition + m_height) / rowHeight) - 1;
			var firstVisibleItemIndex:uint = Math.ceil(verticalScrollPosition / rowHeight);
			if(newCaretIndex < firstVisibleItemIndex) 
			{
				verticalScrollPosition = newCaretIndex * rowHeight;
			} 
			else if(newCaretIndex > lastVisibleItemIndex) 
			{
				verticalScrollPosition = (newCaretIndex + 1) * rowHeight - m_height;
			}
		}
		
		/** @private */	
		override protected function draw():void
		{
			super.draw();
			
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const layoutInvalid : Boolean = isInvalid(INVALIDATION_FLAG_LAYOUT);
			const dataInvalid : Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			const scrollbarInvalid : Boolean = isInvalid(INVALIDATION_FLAG_CREATE);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			
			var isReturn : Boolean;
			
			if(skinInvalid)
			{
				isReturn = refreshSkin();
				if(isReturn)return;
			}
			
			if(layoutInvalid || sizeInvalid)
			{
				refreshLayout();
			}
			
			if(dataInvalid)
			{
				refreshData();
			}
			
			if(scrollbarInvalid || sizeInvalid || dataInvalid)
			{
				createScrollBars();
			}
			
			if(stateInvalid)
			{
				refreshState();
			}
		}
		
		/** @private */	
		protected function refreshState() : void
		{
			var index: int = -1;
			var cell : *;
			for each(cell in m_activeCellRenderers)
			{
				if(cell.data != null)
				{
					index = m_listData.indexOf(cell.data);
					cell.selected = m_selected && (index == m_selectedIndex);
				}
			}
			
			dispatchEventWith(ComponentEvent.LIST_ITEM_SELECTED , false , cell.data);
		}
		
		/** @private */	
		override protected function refreshSize():void
		{
			super.refreshSize();
			
			m_rowCount = Math.ceil(m_scrollRect.height / m_rowHeight);
		}
		
		/** @private */	
		protected function refreshSkin() : Boolean
		{
			var startIndex : int = Math.floor(0 / m_rowHeight);
			var endIndex : int = m_rowCount + 1;
			var index : int = 0;
			
			if(!m_cellClass)
				return true;
			
			var cell : * ;
			for(index;index<endIndex;index++)
			{
				cell = new m_cellClass;
				cell.name = "cellRender" + String(index);
				cell.addEventListener(TouchEvent.TOUCH , onItemSelected);
				m_activeCellRenderers.push(cell);
			}
			
			return false;
		}
		
		/** @private */	
		protected function refreshLayout() : void
		{
			var cell : *;
			for(var i:int=0;i<m_activeCellRenderers.length;i++)
			{
				cell = m_activeCellRenderers[i];
				cell.y = m_rowHeight * i;
			}
		}
		
		/** @private */	
		protected function refreshData() : void
		{
			m_hCount = m_listData.length;
			const heightTotal : int = m_rowHeight * m_hCount;
			
			if(m_rowCount<m_hCount)
			{
				m_maxVerticalScrollPosition = Math.max(0,heightTotal - m_scrollRect.height);
			}
			else 
			{
				m_maxVerticalScrollPosition = 0;
			}
						
			updatePosition();
			updateCell();
			
			this.finishScrollingVertically();
		}
		
		/** @private */	
		override protected function onChangePosition():void
		{
			super.onChangePosition();
			
			updateCell();
		}
		
		/** @private */	
		override protected function updatePosition():void
		{
			var _verticalScrollPosition : Number = m_topViewPortOffset - verticalScrollPosition;
			var position : Number = Math.max(Math.abs(_verticalScrollPosition),0);
			
			if(m_verticalScrollBar)
			{
				if(m_rowCount<m_hCount && m_isTouching)
					m_verticalScrollBar.showScrollBar();
				else
					m_verticalScrollBar.hideScrollBar();
				
				m_verticalScrollBar.scrollPosition = verticalScrollPosition;
			}
			
			if(verticalScrollPosition < m_minVerticalScrollPosition)
			{
				m_background.y = _verticalScrollPosition;
				return;
			}
			
			if(_verticalScrollPosition > 0)
				m_background.y = Math.floor(position) % m_rowHeight;
			else
				m_background.y = -(Math.floor(position) % m_rowHeight);
		}
		
		/**
		 *	更新Cell 内容 
		 * 
		 */		
		private function updateCell() : void
		{
			var cell : *;
			
			var _ver : Number = Math.max(verticalScrollPosition,0);
			
			var startIndex : int = Math.floor(_ver/m_rowHeight);
			var endIndex : int = Math.min(m_hCount,startIndex + m_rowCount+1);

			for each(cell in m_activeCellRenderers)
				m_background.removeChild(cell);

			var i : int = startIndex;
			var index : int = 0;
			for(i;i<endIndex;i++)
			{
				cell = m_activeCellRenderers[index];
				cell.setData(m_listData[i]);
				cell.selected = m_selected && (i == m_selectedIndex);
				cell.y = m_rowHeight*(i-startIndex);
				m_background.addChild(cell);
				index++;
			}
		}
		
		/**
		 *	清理Cell 
		 */		
		private function clearCell() : void
		{
			var cell : *;
			while(m_background.numChildren > 0)
			{
				cell = m_background.removeChildAt(0);
				cell = null;
			}
			
			for(var i:int=0;i<m_activeCellRenderers.length;i++)
			{
				cell = m_activeCellRenderers[i];
				cell.removeEventListener(TouchEvent.TOUCH , onItemSelected);
				cell.Destroy();
			}
			
			m_activeCellRenderers.length = 0;
		}
		
		/**
		 *	选中		Item  
		 * @param event
		 * 
		 */		
		private function onItemSelected(event : TouchEvent) : void
		{
			if(!m_isTouching)
			{
				var touch : Touch = event.getTouch(this,TouchPhase.ENDED);
				
				if(!touch)
					return;
				
				m_selectedIndex = m_listData.indexOf(event.currentTarget["data"]);
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
	}
}
