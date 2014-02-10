package game.manager
{
	import com.gamerisker.containers.SkinFrame;
	import com.gamerisker.containers.SkinImage;
	import com.gamerisker.containers.TitleWindow;
	import com.gamerisker.controls.Button;
	import com.gamerisker.controls.CheckBox;
	import com.gamerisker.controls.CheckBoxGroup;
	import com.gamerisker.controls.ImageButton;
	import com.gamerisker.controls.Label;
	import com.gamerisker.controls.List;
	import com.gamerisker.controls.RadioButton;
	import com.gamerisker.controls.RadioButtonGroup;
	import com.gamerisker.controls.Slider;
	import com.gamerisker.controls.Tile;
	import com.gamerisker.controls.TileGroup;
	import com.gamerisker.core.Component;
	import com.gamerisker.core.SkinnableContainer;
	
	/**
	 *	组件管理器 
	 * <br>主要功能：根据界面编辑器XML 生成相应的界面
	 * @author YangDan
	 * 
	 */	
	public class ComponentManager
	{
		
		public function ComponentManager(){}


		/**
		 *	根据XML生成对应界面 
		 * @param xml
		 * 
		 */		
		public static function setComponentContainerXML(xml : XML , collection : Object) : Component
		{
			var component : Component = parseProperty(ComponentManager.getComponent(xml.localName()) , xml);
		
			collection[String(xml.@id)] = component;

			var child : Component;
			for each(var item : XML in xml.elements())
			{
				child = setComponentContainerXML(item , collection);
				if(child!=null)
				{
					component.addChild(child);
				}
			}

			return component;
		}	
		
		/**
		 *	根据名称获取对应的组件 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getComponent(name : String) : Component
		{
			switch(name)
			{
				case "Button" : 
					return getButton();
				case "TitleWindow" : 
					return getTitleWindow();
				case "ImageButton" :
					return getImageButton();
				case "CheckBox" :
					return getCheckBox();
				case "RadioButton" : 
					return getRadioButton();
				case "Label" : 
					return getLabel();
				case "Slider" : 
					return getSlider();
				case "SkinFrame" : 
					return getSkinFrame();
				case "SkinImage" : 
					return getSkinImage();
				case "List" :
					return getList();
				case "Tile" :
					return getImageLoadBox();
				case "TileGroup" :
					return getImageLoadGrid();
			}
			
			throw(new Error("not to exist" , name));
		}
			
		private static function getButton() : Button
		{
			return new Button();
		}
		
		private static function getTitleWindow() : TitleWindow
		{
			return new TitleWindow();
		}
		
		private static function getImageButton() : ImageButton
		{
			return new ImageButton();
		}
		
		private static function getCheckBox() : CheckBox
		{
			var checkBox : CheckBox = new CheckBox();
			CheckBoxGroup.getInstance().addButton(checkBox);
			return checkBox;
		}
		
		private static function getRadioButton() : RadioButton
		{
			var radio : RadioButton = new RadioButton();
			RadioButtonGroup.getInstance().addButton(radio)
			return radio;
		}
		
		private static function getLabel() : Label
		{
			return new Label();
		}
		
		private static function getSlider() : Slider
		{
			return new Slider();
		}
		
		private static function getSkinFrame() : SkinFrame
		{
			return new SkinFrame();
		}
		
		private static function getSkinImage() : SkinImage
		{
			return new SkinImage();
		}
		
		private static function getList() : com.gamerisker.controls.List
		{
			return new List();
		}
		
		private static function getImageLoadBox() : Tile
		{
			return new Tile();
		}
		
		private static function getImageLoadGrid() : TileGroup
		{
			return new TileGroup();
		}
		
		private static function parseProperty(component : Component , xml : XML) : Component
		{
			var attrs:XMLList = xml.attributes();
			var name : String;
			var value : *;
			for each (var attr:XML in attrs)
			{
				name = attr.localName();
				value = attr.toString();
				if(component.hasOwnProperty(name))
				{
					if(name=="skin")
					{
						SkinnableContainer(component).skinInfo = SkinManager.getSkin(xml.localName(),value);
					}
					else
					{
						component[name] = getProperty(value);
					}
				}
			}
			
			return component;
		}
		
		private static function getProperty(value : *) : *
		{
			if(value == "false")return false;
			if(value == "true") return true
			return value;
		}
	}
}