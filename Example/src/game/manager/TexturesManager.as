package game.manager
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * 资源管理类
	 * @author YangDan
	 * 
	 */
	public class TexturesManager
	{
		private static var sTextures : Dictionary = new Dictionary;
		
		/**
		 * 添加资源
		 * @param name	资源注册名称
		 * @param xml	
		 * @param byte
		 * 
		 */		
		public static function add(name : String , xml : XML , byte : ByteArray) : void
		{
			var texture:Texture = Texture.fromAtfData(byte as ByteArray,1);
			
			instantiate(new TextureAtlas(texture,xml),name);
		}
		
		/**
		 *	获取背景资源 
		 * @return 
		 * 
		 */		
		public static function getAtlas(pngName : String) : TextureAtlas
		{
			var _texture : TextureAtlas = sTextures[pngName] as TextureAtlas;
			
			if(_texture == null)
				throw(new Error("not found textureAtlas : " + pngName));
			
			return _texture;
		}
		
		/**
		 * 清除所有资源 
		 * @param name	不需要清除资源名称(该参数不传，则清除所有资源)
		 * 
		 */
		public static function removeAll(notDelList : Array) : void
		{
			for (var name : String in sTextures)
			{
				if(notDelList.indexOf(name) == -1)
				{
					remove(name);
				}
			}
		}
		
		/**
		 *	清除指定资源 
		 * @param name
		 * 
		 */		
		public static function remove(name : String) : void
		{
			if(sTextures.hasOwnProperty(name))
			{
				(sTextures[name] as TextureAtlas).dispose();
				delete sTextures[name];
			}
		}
		
		/**
		 *	注册  
		 * @param _texture
		 * 
		 */		
		private static function instantiate(_texture : TextureAtlas , name : String) : void
		{
			if(sTextures[name] == undefined)
			{
				sTextures[name] = _texture;
			}
		}
	}
}