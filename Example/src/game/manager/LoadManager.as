package game.manager
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 *	资源管理类、提供加载服务。 目前支持0：图片，1：xml,2：二进制文件 
	 * @author GameRisker
	 * 
	 */	
	public class LoadManager
	{
		/**
		 *	文本文件加载器 
		 */		
		private static var textLoader : URLLoader = new URLLoader;	
		
		/**
		 *	图片加载器 
		 */		
		private static var imgLoader : Loader = new Loader;
		
		/**
		 *	资源路径集合 
		 */
		private static var urlGroup : Vector.<String> = new Vector.<String>;
		
		/**
		 *	回调函数集合 
		 */		
		private static var funGroup : Object = new Object;	
		
		/**
		 *	所有加载完成后回调函数 
		 */		
		private static var callFunction : Function;
		
		/**
		 * 进度条函数
		 */		
		private static var m_progressFun : Function;
		
		/**
		 *	设置TIP 
		 */		
		private static var m_tipFun : Function;
		
		/**
		 *	加载完成数据的集合 
		 */		
		private static var dataGroup : Object = new Object;
		
		/**
		 *	文件类型 
		 */
		private static var typeGroup : Object = new Object;
		
		/**
		 *	文件名称 
		 */
		private static var nameGroup : Object = new Object;
		
		/**
		 *	当前正在加载的文件路径 
		 */
		private static var curUrl : String;
		
		/**
		 *	当前加载文件的类型 
		 */		
		private static var curType : int;
		
		/**
		 *	当前加载文件的TIP 
		 */		
		private static var curName : String;
		
		/**
		 *	加载文件的总数 
		 */
		private static var loadTotal : int;
		
		/**
		 *	进度值 
		 */
		private static var progressTotal : int;

		private static var m_param : *;
		
		public function LoadManager()
		{
			
		}
		
		public static function init() : void
		{
			textLoader.addEventListener(Event.COMPLETE , onComplete);
			textLoader.addEventListener(ProgressEvent.PROGRESS , onProgress);
			textLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onComplete);
			imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS , onProgress);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
		}
		
		public static function destory() : void
		{
			textLoader.removeEventListener(Event.COMPLETE , onComplete);
			textLoader.removeEventListener(ProgressEvent.PROGRESS , onProgress);
			textLoader.removeEventListener(IOErrorEvent.IO_ERROR , onIoError);
		
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onComplete);
			imgLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS , onProgress);
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			imgLoader.unload();
			
			imgLoader = null;
			textLoader = null;
			dataGroup = null;
			callFunction = null;
			funGroup = null;
			urlGroup = null;
		}
		
		public static function removeAll() : void
		{
			urlGroup.length = 0;
		}
		
		/**
		 *	获取指定资源 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getSource(name : String) : *
		{
			if(dataGroup.hasOwnProperty(name))
			{
				return dataGroup[name];
			}
			return null;
		}
		
		/**
		 *	设置进度条调用方法 
		 * @param fun
		 * 
		 */		
		public static function setLoading(fun : Function) : void
		{
			m_progressFun = fun;
		}
		
		/**
		 *	设置TIP 
		 * 
		 */		
		public static function setTip(tip : Function) : void
		{
			m_tipFun = tip
		}
		
		/**
		 * 开始加载资源
		 * @param fun	所有加载完成后调用
		 * 
		 */
		public static function start(fun : Function,param : * = null) : void
		{
			callFunction = fun;
			
			m_param = param;
			
			curUrl = "";
			curType = -1;
			curName = "";
			
			loadTotal = urlGroup.length;
			
			if(loadTotal<=0)
			{
				if(callFunction!=null)callFunction(m_param);
				return;
			}
			
			onLoader(urlGroup.shift());
		}
		
		/**
		 *	开始加载资源 
		 * @param value				当前场景需要加载的资源总合
		 * @param fun				资源加载完成回调函数
		 * @param param				回调函数参数
		 * 
		 */		
		public static function startScene(value : Array , fun : Function,param : Object) : void
		{
			for each(var item : Object in value)
			{
				add(item["url"],item["type"],item["name"]);
			}
			
			start(fun,param);
		}

		/**
		 *	添加加载资源 
		 * @param url	资源路径
		 * @param type	资源类型	0:图片 1： xml 2:二进制
		 * @param id	资源ID
		 * @param callfunction	资源回调函数
		 * 
		 */
		public static function add(url : String , type : int ,name : String = "",callfunction : Function = null) : void
		{
			if(!dataGroup.hasOwnProperty(url))
			{
				urlGroup.push(url);
				nameGroup[url] = name;
				typeGroup[url] = type;
				if(callfunction!=null)
				{
					funGroup[url] = callfunction;
				}
			}
		}
		
		/**
		 *	加载资源 
		 * @param url
		 * 
		 */
		private static function onLoader(url : String) : void
		{
			curType = typeGroup[url];
			curName = nameGroup[url];
			
			if(m_tipFun!=null)m_tipFun(curName);
			
			var loader : * = getLoader(curType);
			
			curUrl = url;
			
			loader.load(new URLRequest(curUrl));
		}
		
		private static function getLoader(type : int) : *
		{
			switch(type)
			{
				case 0 :	//图片文件
					return imgLoader;
				case 1 :	//xml
					textLoader.dataFormat = URLLoaderDataFormat.TEXT;
					return textLoader;
				case 2 :	//二进制
					textLoader.dataFormat = URLLoaderDataFormat.BINARY;
					return textLoader;
			}
			return null;
		}
		
		/**
		 * 加载完成 
		 * @param event
		 * 
		 */		
		protected static function onComplete(event : Event) : void
		{
			if(curType == 0)
				dataGroup[curUrl] = event.target.content;
			else if(curType == 1 || curType == 2)
				dataGroup[curUrl] = event.target.data;
			
			var fun : Function = funGroup[curUrl];
			
			if(fun!=null)
			{
				fun(dataGroup[curUrl]);
			}
			
			curUrl = "";
			curType = -1;
			
			if(urlGroup.length > 0)
			{
				onLoader(urlGroup.shift());
			}
			else
			{
				if(callFunction!=null)
					callFunction(m_param);
				
				progressTotal = 0;
			}
		}
		
		/**
		 * 加载进度 
		 * @param event
		 * 
		 */
		private static function onProgress(event : ProgressEvent) : void
		{
			var radio : Number = 100 / loadTotal; 
			var curRadio : Number = Math.ceil((event.bytesLoaded / event.bytesTotal)*radio);
			
			progressTotal += curRadio;
			
			if(m_progressFun!=null)
				m_progressFun(Math.min(100,progressTotal));
		}
		
		/**
		 * 路径错误 
		 * @param event
		 * 
		 */		
		protected static function onIoError(event : Event) : void
		{
			trace(curUrl)
		}
	}
}
