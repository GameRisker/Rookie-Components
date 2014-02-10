package game.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class Tool
	{
		public function Tool(){}
		
		/**
		 *	浅复制一个目标对象 
		 * @param _arg1		目标对象
		 * @return 			复制对象
		 * 
		 */		
		public static function copyObject(target:Object) : Object
		{
			var name:String;
			var copy : Object;
			if (target == null)
			{
				return target;
			}
			
			copy = new Object;
			for (name in target)
			{
				copy[name] = target[name];
			}
			
			return copy;
		}
		
		public static function cleanObjectProperty(target:Object):void
		{
			var name:String;
			if (target == null)
			{
				return;
			}
			for (name in target)
			{
				delete target[name];
			}
		}
	}
}