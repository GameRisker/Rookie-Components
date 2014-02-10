package game.manager
{
	import flash.geom.Rectangle;
	
	import game.utils.Tool;
	
	import starling.textures.SubTexture;
	import starling.textures.TextureAtlas;
	
	/**
	 *	皮肤管理器 
	 * @author YangDan
	 * 
	 */	
	public class SkinManager
	{		
		private static const s_buttonList : Object = new Object;
		private static const s_titleWindowList : Object = new Object;
		private static const s_imagebuttonList : Object = new Object;
		private static const s_checkBoxList : Object = new Object;
		private static const s_radiobuttonList : Object = new Object;
		private static const s_sliderList : Object = new Object;
		private static const s_uiframeList : Object = new Object;
		private static const s_uiimageList : Object = new Object;
		
		private static const s_curbuttonList : Object = new Object;
		private static const s_curtitleWindowList : Object = new Object;
		private static const s_curimagebuttonList : Object = new Object;
		private static const s_curcheckBoxList : Object = new Object;
		private static const s_curradiobuttonList : Object = new Object;
		private static const s_cursliderList : Object = new Object;
		private static const s_curuiframeList : Object = new Object;
		private static const s_curuiimageList : Object = new Object;
		
		public function SkinManager()
		{
			
		}
		
		public static function init(data : String) : void
		{
			onLoadConfigComplete(data);
		}
		
		/**
		 *	清除皮肤池里面的皮肤 
		 * 
		 */		
		public static function removeAll() : void
		{
			removePropertyDispose(s_curbuttonList);
			removePropertyDispose(s_curtitleWindowList);
			removePropertyDispose(s_curimagebuttonList);
			removePropertyDispose(s_curcheckBoxList);
			removePropertyDispose(s_curradiobuttonList);
			removePropertyDispose(s_cursliderList);
			removePropertyDispose(s_curuiframeList);
			removePropertyDispose(s_curuiimageList);
		}
				
		private static function onLoadConfigComplete(data : String) : void
		{
			var configXML : XML = new XML(data);
			var skinInfo : Object;
			var skinName : String;
			var skinXml : XML
			for each(skinXml in configXML.elements("Button"))
			{
				skinInfo = new Object;
				skinName = skinXml.@skin.toString();
				skinInfo["name"] = skinName;
				skinInfo["skinParent"] = skinXml.@skinParent.toString();
				skinInfo["upSkin"] = skinXml.@upSkin.toString();
				skinInfo["downSkin"] = skinXml.@downSkin.toString();
				skinInfo["disabledSkin"] = skinXml.@disabledSkin.toString();
				skinInfo["scale9Grid"] = new Rectangle(int(skinXml.@scale9GridX), 
					int(skinXml.@scale9GridY), int(skinXml.@scale9GridWidth), 
					int(skinXml.@scale9GridHeight));
				
				if(s_buttonList.hasOwnProperty(skinName))
					throw(new Error("Repeated skin:" + skinName))
				s_buttonList[skinName] = skinInfo;
			}
			
			skinXml = null;
			for each(skinXml in configXML.elements("TitleWindow"))
			{
				skinInfo = new Object;
				skinName = skinXml.@skin.toString();
				skinInfo["name"] = skinName;
				skinInfo["skinParent"] = skinXml.@skinParent.toString();
				skinInfo["skin"] = skinXml.@skin.toString();
				skinInfo["closeUpSkin"] = skinXml.@closeUpSkin.toString();
				skinInfo["closeDownSkin"] = skinXml.@closeDownSkin.toString();
				skinInfo["closeX"] = int(skinXml.@closeX);
				skinInfo["closeY"] = int(skinXml.@closeY);
				skinInfo["scale9Grid"] = new Rectangle(int(skinXml.@scale9GridX), 
					int(skinXml.@scale9GridY), int(skinXml.@scale9GridWidth), 
					int(skinXml.@scale9GridHeight));
				skinInfo["textBounds"] = new Rectangle(int(skinXml.@textboundsX), 
					int(skinXml.@textboundsY), int(skinXml.@textboundsW), 
					int(skinXml.@textboundsH));
				
				if(s_titleWindowList.hasOwnProperty(skinName))
					throw("PopupWindow Repeated skin : " + skinName);
				s_titleWindowList[skinName] = skinInfo;
			}
			
			skinXml = null;
			for each(skinXml in configXML.elements("ImageButton"))
			{
				skinInfo = new Object;
				skinName = skinXml.@skin.toString();
				skinInfo["name"] = skinName;
				skinInfo["skinParent"] = skinXml.@skinParent.toString();
				skinInfo["upSkin"] = skinXml.@upSkin.toString();
				skinInfo["downSkin"] = skinXml.@downSkin.toString();
				skinInfo["disabledSkin"] = skinXml.@disabledSkin.toString();
				
				if(s_imagebuttonList.hasOwnProperty(skinName))
					throw(new Error("Repeated skin:" + skinName))
				s_imagebuttonList[skinName] = skinInfo;
			}
			
			skinXml = null;
			for each(skinXml in configXML.elements("CheckBox"))
			{
				skinInfo = new Object;
				skinName = skinXml.@skin.toString();
				skinInfo["name"] = skinName;
				skinInfo["skinParent"] = skinXml.@skinParent.toString();
				skinInfo["upSkin"] = skinXml.@upSkin.toString();
				skinInfo["downSkin"] = skinXml.@downSkin.toString();
				
				if(s_checkBoxList.hasOwnProperty(skinName))
					throw(new Error("Repeated skin:" + skinName))
				s_checkBoxList[skinName] = skinInfo;
			}
			
			skinXml = null;
			for each(skinXml in configXML.elements("RadioButton"))
			{
				skinInfo = new Object;
				skinName = skinXml.@skin.toString();
				skinInfo["name"] = skinName;
				skinInfo["skinParent"] = skinXml.@skinParent.toString();
				skinInfo["upSkin"] = skinXml.@upSkin.toString();
				skinInfo["downSkin"] = skinXml.@downSkin.toString();
				
				if(s_radiobuttonList.hasOwnProperty(skinName))
					throw(new Error("Repeated skin:" + skinName))
				s_radiobuttonList[skinName] = skinInfo;
			}
			
			skinXml = null;
			for each(skinXml in configXML.elements("Slider"))
			{
				skinInfo = new Object;
				skinName = skinXml.@skin.toString();			
				skinInfo["name"] = skinName;
				skinInfo["skinParent"] = skinXml.@skinParent.toString();
				skinInfo["upSkin"] = skinXml.@upSkin.toString();
				skinInfo["downSkin"] = skinXml.@downSkin.toString();
				skinInfo["backtexture"] = skinXml.@background.toString();
				skinInfo["scale9Grid"] = new Rectangle(int(skinXml.@scale9GridX), 
					int(skinXml.@scale9GridY), int(skinXml.@scale9GridWidth), 
					int(skinXml.@scale9GridHeight));
				
				if(s_sliderList.hasOwnProperty(skinName))
					throw(new Error("Repeated skin:" + skinName))
				s_sliderList[skinName] = skinInfo;
			}
			
			skinXml = null;
			for each(skinXml in configXML.elements("SkinFrame"))
			{
				skinInfo = new Object;
				skinName = skinXml.@skin.toString();			
				skinInfo["name"] = skinName;
				skinInfo["skinParent"] = skinXml.@skinParent.toString();
				skinInfo["skin"] = skinXml.@skin.toString();
				skinInfo["scale9Grid"] = new Rectangle(int(skinXml.@scale9GridX), 
					int(skinXml.@scale9GridY), int(skinXml.@scale9GridWidth), 
					int(skinXml.@scale9GridHeight));
				
				if(s_uiframeList.hasOwnProperty(skinName))
					throw(new Error("Repeated skin:" + skinName))
				s_uiframeList[skinName] = skinInfo;
			}
			
			skinXml = null;
			for each(skinXml in configXML.elements("SkinImage"))
			{
				skinInfo = new Object;
				skinName = skinXml.@skin.toString();			
				skinInfo["name"] = skinName;
				skinInfo["skinParent"] = skinXml.@skinParent.toString();
				skinInfo["skin"] = skinXml.@skin.toString();
				
				if(s_uiimageList.hasOwnProperty(skinName))
					throw(new Error("Repeated skin:" + skinName))
				s_uiimageList[skinName] = skinInfo;
			}
		}
		
		public static function getSkin(name : String , skinName : String) : Object
		{
			switch(name)
			{
				case "Button" : 
					return getButtonSkin(skinName);
				case "TitleWindow" : 
					return getTitleWindowSkin(skinName);
				case "ImageButton" : 
					return getImageButtonSkin(skinName);
				case "CheckBox" : 
					return getCheckBox(skinName);
				case "RadioButton" : 
					return getRadioButton(skinName);
				case "Slider" : 
					return getSlider(skinName);
				case "SkinFrame" : 
					return getSkinFrame(skinName);
				case "SkinImage" : 
					return getSkinImage(skinName);
			}
			throw(new Error("SkinManager.GetSkin exit Skin"));
		}
		
		public static function getButtonSkin(name : String) : Object
		{
			if(s_curbuttonList.hasOwnProperty(name))
			{
				return s_curbuttonList[name];
			}
			
			var skinInfo : Object = Tool.copyObject(s_buttonList[name]);
			if(skinInfo==null)
				throw(new Error("Button not found :" + name));
			var atlas : TextureAtlas = TexturesManager.getAtlas(skinInfo["skinParent"]);

			skinInfo["upSkin"] = atlas.getTexture(skinInfo["upSkin"]);
			skinInfo["downSkin"] = atlas.getTexture(skinInfo["downSkin"]);
			skinInfo["disabledSkin"] = atlas.getTexture(skinInfo["disabledSkin"]);

			s_curbuttonList[name] = skinInfo;
			
			return skinInfo;
		}
		
		public static function getTitleWindowSkin(name : String) : Object
		{
			if(s_curtitleWindowList.hasOwnProperty(name))
			{
				return s_curtitleWindowList[name];
			}
			
			var skinInfo : Object = Tool.copyObject(s_titleWindowList[name]);
			if(skinInfo==null)
				throw("TitleWindow not found :" + name);
			var atlas : TextureAtlas = TexturesManager.getAtlas(skinInfo["skinParent"]);
			
			skinInfo["skin"] = atlas.getTexture(skinInfo["skin"]);
			skinInfo["closeUpSkin"] = atlas.getTexture(skinInfo["closeUpSkin"]);
			skinInfo["closeDownSkin"] = atlas.getTexture(skinInfo["closeDownSkin"]);
			
			
			s_curtitleWindowList[name] = skinInfo;
			
			return skinInfo;
		}
		
		public static function getImageButtonSkin(name : String) : Object
		{
			if(s_curimagebuttonList.hasOwnProperty(name))
			{
				return s_curimagebuttonList[name];
			}
			
			var skinInfo : Object = Tool.copyObject(s_imagebuttonList[name]);
			if(skinInfo==null)
				throw(new Error("ImageButton not found :" + name));
			var atlas : TextureAtlas = TexturesManager.getAtlas(skinInfo["skinParent"]);
			
			skinInfo["upSkin"] = atlas.getTexture(skinInfo["upSkin"]);
			skinInfo["downSkin"] = atlas.getTexture(skinInfo["downSkin"]);
			skinInfo["disabledSkin"] = atlas.getTexture(skinInfo["disabledSkin"]);
			
			s_curimagebuttonList[name] = skinInfo;
			
			return skinInfo;
		}
		
		public static function getCheckBox(name : String) : Object
		{
			if(s_curcheckBoxList.hasOwnProperty(name))
			{
				return s_curcheckBoxList[name];
			}
			
			var skinInfo : Object = Tool.copyObject(s_checkBoxList[name]);
			if(skinInfo==null)
				throw(new Error("CheckBox not found :" + name));
			var atlas : TextureAtlas = TexturesManager.getAtlas(skinInfo["skinParent"]);
			
			skinInfo["upSkin"] = atlas.getTexture(skinInfo["upSkin"]);
			skinInfo["downSkin"] = atlas.getTexture(skinInfo["downSkin"]);

			s_curcheckBoxList[name] = skinInfo;
			
			return skinInfo;
		}
		
		public static function getRadioButton(name : String) : Object
		{
			if(s_curradiobuttonList.hasOwnProperty(name))
			{
				return s_curradiobuttonList[name];
			}
			
			var skinInfo : Object = Tool.copyObject(s_radiobuttonList[name]);
			if(skinInfo==null)
				throw(new Error("RadioButton not found :" + name));
			var atlas : TextureAtlas = TexturesManager.getAtlas(skinInfo["skinParent"]);
			
			skinInfo["upSkin"] = atlas.getTexture(skinInfo["upSkin"]);
			skinInfo["downSkin"] = atlas.getTexture(skinInfo["downSkin"]);

			s_curradiobuttonList[name] = skinInfo;
			
			return skinInfo
		}
		
		public static function getSlider(name : String) : Object
		{
			if(s_cursliderList.hasOwnProperty(name))
			{
				return s_cursliderList[name];
			}
			
			var skinInfo : Object = Tool.copyObject(s_sliderList[name]);
			if(skinInfo==null)
				throw(new Error("Slider not found :" + name));
			var atlas : TextureAtlas = TexturesManager.getAtlas(skinInfo["skinParent"]);
			
			skinInfo["upSkin"] = atlas.getTexture(skinInfo["upSkin"]);
			skinInfo["downSkin"] = atlas.getTexture(skinInfo["downSkin"]);
			skinInfo["backtexture"] = atlas.getTexture(skinInfo["backtexture"]);
			
			s_cursliderList[name] = skinInfo;
			
			return skinInfo;
			
		}
		
		public static function getSkinFrame(name : String) : Object
		{
			if(s_curuiframeList.hasOwnProperty(name))
			{
				return s_curuiframeList[name];
			}
			
			var skinInfo : Object = Tool.copyObject(s_uiframeList[name]);
			if(skinInfo==null)
				throw(new Error("SkinFrame not found :" + name));
			var atlas : TextureAtlas = TexturesManager.getAtlas(skinInfo["skinParent"]);
			
			skinInfo["skin"] = atlas.getTexture(skinInfo["skin"]);
			
			s_curuiframeList[name] = skinInfo;
			
			return skinInfo;
			
		}
		
		public static function getSkinImage(name : String) : Object
		{
			if(s_curuiimageList.hasOwnProperty(name))
			{
				return s_curuiimageList[name];
			}
			
			var skinInfo : Object = Tool.copyObject(s_uiimageList[name]);
			if(skinInfo==null)
				throw(new Error("SkinImage not found :" + name));
			var atlas : TextureAtlas = TexturesManager.getAtlas(skinInfo["skinParent"]);
			
			skinInfo["skin"] = atlas.getTexture(skinInfo["skin"]);
			
			s_curuiimageList[name] = skinInfo;
			
			return skinInfo;
			
		}
		
		/**
		 *	删除参数所携带的所有引用，切执行dispose方法 
		 * @param value
		 * 
		 */
		private static function removePropertyDispose(value : Object) : void
		{
			var temp : Object;
			
			for(var name : String in value)
			{
				temp = value[name]
				for(var item : String in  temp)
				{
					if(temp[item] is SubTexture)
						(temp[item] as SubTexture).dispose();
					
					delete temp[item];
				}
				delete value[name];
			}
		}
	}
}