package com.gamerisker.controls
{
	import com.gamerisker.core.Component;
	import com.gamerisker.core.SkinnableContainer;
	
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 *	图片数字 
	 * 皮肤设置
	 * @author GameRisker
	 * {
	 *  	"skin" : 皮肤名称 （是一个数字集合）
	 *      "skinParent" : 皮肤父纹理集合
	 */	
	public class ImageNumber extends SkinnableContainer
	{
		/** @private */	
		private var m_Textures : Vector.<Texture>;
		
		/** @private */	
		private var m_imageList : Vector.<Image>;				//位图资源存储器
		
		/** @private */	
		private var m_totalWidth : int;
		
		/** @private */	
		private var m_distance : int;
		
		/** @private */	
		private var m_digit : int;
		
		/** @private */	
		private var m_num : int;
		
		/** @private */	
		private var m_isBool : Boolean = true;				//是否数字前显示 0
		
		/** @private */	
		private var m_numString : String;						//数字转换为最后显示字符串
		
		/**
		 *	构造函数 
		 * 
		 */		
		public function ImageNumber(){}
		
		/**
		 *	清除组件纹理。包括销毁纹理本身,不能销毁原始纹理集，否则会报空   
		 */		
		override public function destroy():void
		{
			var i:int;
			
			for(i=0;i<m_imageList.length;i++)
			{
				this.contains(m_imageList[i])
				{
					removeChild(m_imageList[i]);
				}
				m_imageList[i].dispose();
				m_imageList[i] = null;
			}
			
			m_imageList.length = 0;
			m_imageList = null;
			m_Textures = null;
			
			super.destroy();
		}
		
		/**
		 *	数字前是否显示 0 
		 * @return 
		 * 
		 */		
		public function get isShow():Boolean{return m_isBool;}
		public function set isShow(value:Boolean):void
		{
			if(m_isBool != value)
			{
				m_isBool = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		/**
		 *	没有设置素材前,没有宽度.无法设置宽度 
		 * @param value
		 * 
		 */		
		override public function set width(value:Number):void{};
		override public function get width():Number{return m_totalWidth}
		
		/**
		 *	 没有设置素材前,没有高度.无法设置高度 
		 * @param value
		 * 
		 */		
		override public function set height(value:Number):void{};
		override public function get height():Number{return m_height}
		
		/**
		 *	当前数字 
		 * @return 
		 * 
		 */		
		public function get value():int{return m_num;}
		public function set value(value:int):void
		{
			if(m_num!=value)
			{
				m_num = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		/**
		 *	位数 
		 * @return 
		 * 
		 */		
		public function get digit():int{return m_digit;}
		public function set digit(value:int):void
		{
			if(m_digit != value)
			{
				m_digit = value;
				invalidate(INVALIDATION_FLAG_DATA);
			}
		}
		
		/**
		 *	两个数字之间的间隔 
		 * @return 
		 * 
		 */		
		public function get distance():int{return m_distance;}
		public function set distance(value:int):void
		{
			if(m_distance != value)
			{
				m_distance = value;
				invalidate(INVALIDATION_FLAG_SIZE);
			}
		}
		
		/**
		 *	设置组件的纹理集 
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
			m_Textures = m_skinInfo["skin"];
			
			invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		/** @private */	
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const dataInvalid : Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			
			if(dataInvalid)
			{
				refreshData();
			}
			
			if(skinInvalid || dataInvalid || sizeInvalid)
			{
				refreshSkin();
			}
			
			if(sizeInvalid || dataInvalid)
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
				touchable = m_enabled;
			}
		}
		
		/** @private */	
		protected function refreshData() : void
		{
			m_numString  = String(m_num);
			var strLeng : int = m_numString.length;
			//是否不足设置位数时，填充 0 
			if(m_isBool)
			{
				var zore : String = "";
				var i : int;
				
				if(m_digit > strLeng)
				{
					i = m_digit - strLeng;
					
					while(i > 0)
					{
						zore = zore.concat("0");
						i--;
					}
					m_numString = zore + m_numString;
				}
			}
			
			strLeng = m_numString.length;
			
			if(m_imageList)
			{
				removeNum(m_imageList.length - Math.min(m_digit , strLeng) , Math.min(m_digit , strLeng));
			}
			else
			{
				m_imageList = new Vector.<Image>(strLeng);
			}
		}
		
		/** @private */	
		protected function refreshSkin() : void
		{
			var numString : String = m_numString;
			var strLeng : int = m_numString.length;
			var index : int;
			var i : int = 0;
			
			while(i < strLeng && i < m_digit)
			{
				index = int(numString.charAt(i));
				
				if(m_imageList[i])
				{
					m_imageList[i].texture.dispose();
					m_imageList[i].texture = m_Textures[index];
				}
				else
				{
					m_imageList[i] = new Image(m_Textures[index]);
					addChildAt(m_imageList[i],i);
				}
				
				m_imageList[i].readjustSize();
				
				i++;
			}
		}
		
		/** @private */	
		protected function refreshSize() : void
		{
			m_totalWidth = 0;
			
			for(var i:int=0;i<m_imageList.length;i++)
			{
				m_imageList[i].x = m_totalWidth;
				m_totalWidth += (m_imageList[i].width + m_distance);
			}
			
			m_height = m_imageList[0].height;
		}
		
		/** @private */	
		protected function removeNum(num : int , leng : int) : void
		{
			var image : Image;
			while(num > 0)
			{
				image = m_imageList.pop();
				removeChild(image);
				image.dispose();
				num--;
			}
			
			m_imageList.length = leng;
		}

	}
}
