package game.manager
{
	/**
	 *	场景需要加载的文件
	 * @author YangDan
	 * 
	 */	
	public class SceneSourceManager
	{
		
		/**
		 *	场景XML文件的所有信息 
		 */		
		private static var m_sceneData : Object;
		
		/**
		 *	保存场景下所有资源路径 
		 */
		private static var m_sceneUrl : Object;
		
		/**
		 *	保存场景下所有资源的id  
		 */		
		private static var m_sceneUrlId : Object;
		
		/**
		 *	所有id资源保存对象 
		 */		
		private static var m_allPngId : Object;
		private static var m_allXmlId : Object;
		
		/**
		 *	单例路径存储池 
		 */		
		private static var m_instanteUrl : Object;
		
		public function SceneSourceManager()
		{
			
		}
		
		public static function init(data : String) : void
		{
			m_sceneData = new Object;
			m_sceneUrl = new Object;
			m_sceneUrlId = new Object;
			m_instanteUrl = new Object;
			m_allPngId = new Object;
			m_allXmlId = new Object;
			
			var xml : XML = new XML(data);
			var scene : XML;
			var temp : Object;
			var items : XML;
			var list : Array;
			var itemsData : Object;
			var item : XML;
			var urlList : Array;
			var idList : Array;
			var url : String;
			var xmlurl : String;
			
			for each(scene in xml.elements("Scene"))
			{
				itemsData = new Object;
				urlList = new Array;
				idList = new Array;
				
				for each(items in scene.elements("Items"))
				{
					list = new Array;
					
					for each(item in items.elements("Item"))
					{
						temp = new Object;
						
						temp["type"] = int(item.@type);
						temp["url"] = item.@url.toString();
						
						if(temp["type"] == 2)
							url = String(item.@url).replace("atf","png");
						if(temp["type"] == 1)
							xmlurl = temp["url"];
						
						list.push(temp);
						urlList.push(temp);
					}
					
					m_allXmlId[items.@id.toString()] = xmlurl;
					m_allPngId[items.@id.toString()] = url;
					idList.push(items.@id.toString());
					itemsData[items.@id.toString()] = list;
					m_instanteUrl[items.@id.toString()] = list;
				}
				
				m_sceneUrlId[scene.@Name.toString()] = idList;
				m_sceneUrl[scene.@Name.toString()] = urlList;
				m_sceneData[scene.@Name.toString()] = itemsData;
			}

		}
		
		/**
		 *	根据id获取资源路径
		 * @param  
		 * @return 
		 * 
		 */		
		public static function getSourceId(id : String) : String
		{
			return String(m_allPngId[id]).replace("atf","png");
		}
		
		public static function getSourceIdXml(id : String) : String
		{
			return String(m_allXmlId[id]);
		}
		
		/**
		 *	获取所有id资源 
		 * @return 
		 * 
		 */
		public static function getSourceIdAll() : Object
		{
			return m_allPngId;
		}
		
		/**
		 *	根据场景名称获取该场景下所有资源路径
		 * @param name
		 * @return 
		 * 
		 */
		public static function getSourceUrl(name : String) : Array
		{
			return m_sceneUrl[name]
		}
		
		/**
		 *	获取所有资源路径 
		 * @return 
		 * 
		 */		
		public static function getAllSourceUrl() : Object
		{
			return m_sceneUrl;
		}
		
		/**
		 *	获取所有资源路径，没有重复 
		 * @return 
		 * 
		 */		
		public static function getAllSourceInsUrl() : Object
		{
			return m_instanteUrl;
		}
		
		/**
		 *	根据场景名称获取 该场景下的所有资源id 
		 * @param name
		 * @return 
		 * 
		 */
		public static function getSceneSourceId(name : String) : Array
		{
			return m_sceneUrlId[name];
		}
		
		/**
		 *	获取所有id 
		 * @return 
		 * 
		 */		
		public static function getAllSourceId() : Object
		{
			return m_sceneUrlId
		}
		
		public static function getAllData() : Object
		{
			return m_sceneData;
		}
		
		/**
		 *	根据场景名称获取场景对象 
		 * @param sceneName
		 * @return 
		 * 
		 */
		public static function getData(sceneName : String) : Object
		{
			return m_sceneData[sceneName];
		}
		
		/**
		 *	根据ID获取相应的对象数据
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getSourceItem(sceneName : String,id : String) : Array
		{
			var data : Object = getData(sceneName);
			return data[id];
		}
	}
}