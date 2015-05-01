package com.gamerisker.event
{
	
	/**
	 *	组件事件 
	 * @author GameRisker
	 * 
	 */
	public class ComponentEvent
	{
		/**
		 * TitleWindow		关闭窗口
		 */		
		public static const CLOSEWINDOW : String = "CloseWindow";
		
		/**
		 * CheckBoxGroup	点击CheckBox
		 */		
		public static const CHECKBOXCHANGE : String = "CheckBoxChange";
		
		/**
		 * List				List Item 内部抛出的事件
		 */		
		public static const ITEM_SELECTED : String = "Item_Selected";
		
		/**
		 * RadioButton		点击RadioButton
		 */		
		public static const RADIOBUTTONCHANGE : String = "RadioButtonChange";
		
		/**
		 * Slider			value值改变
		 */		
		public static const SLIDERCHANGE : String = "SliderChange";
		
		/**
		 *	组件创建完成 
		 */		
		public static const CREATION_COMPLETE : String = "Create_Complete";
		
		/**
		 *	该事件包含data属性 ： 所点击的 ImageLoadBox 所存储的 data 对象 
		 */		
		public static const IMAGELOADGRID_ITEMCLICK : String = "ImageLoadGrid_ItemClick";
		
		/**
		 *	点击ImageLoadBox Click 
		 */		
		public static const IMAGELOADBOX_CLICK : String = "ImageLoadBox_Click";
		
		/**
		 *	List 选中事件 
		 */		
		public static const LIST_ITEM_SELECTED : String = "List_Item_Selected";
	}
}
