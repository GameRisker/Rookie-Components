package game.manager
{
	import flash.utils.ByteArray;

	public class UIConfigManager
	{
		private static var uiConfigCache : Object;
		
		public function UIConfigManager()
		{
			
		}
		
		public static function init(data : ByteArray) : void
		{
			var bytes : ByteArray = data;
			bytes.uncompress();
			uiConfigCache = bytes.readObject();
		}
		
		/**
		 *	获取界面的XML数据 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getViewXML(name : String) : XML
		{
			return uiConfigCache[name] as XML
		}
		
		public static function destroy() : void
		{
			uiConfigCache = null;
		}
	}
}