package game.manager
{	
	import flash.utils.ByteArray;
	
	import game.Interface.IDestroy;
	import game.common.Define;
	import game.view.ListExample;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class StageManager implements IDestroy
	{
		/**
		 *	游戏舞台 
		 */		
		public static var gameStage : starling.display.Stage;
		
		/**
		 *	游戏背景容器 
		 */		
		private var m_backgroundContainer : Sprite;
		
		public function StageManager(){}
						
		/**
		 *	开始游戏 
		 * 
		 */		
		public function startGame() : void
		{
			Starling.current.showStatsAt();

			var example : ListExample = new ListExample;
			
			addChild(example);
		}
		
		public function destroy() : void
		{
			
		}
		
		/**
		 *	游戏初始化 
		 * @param gamestage			舞台
		 * @param gamecontainer		游戏容器
		 * 
		 */		
		public function init(gamestage : starling.display.Stage , gamecontainer : Sprite) : void
		{
			gameStage = gamestage;
			m_backgroundContainer = gamecontainer;

			skinComplete(LoadManager.getSource(Define.SKIN_CONFIG));
			uiConfigComplete(LoadManager.getSource(Define.UI_CONFIG));
			sceneSourceComplete(LoadManager.getSource(Define.SCENE_SOURCE));
		}
		
		/**
		 *	场景资源配置文件加载完成 
		 * @param value
		 * 
		 */		
		private function sceneSourceComplete(value : String) : void
		{
			SceneSourceManager.init(value);
			
			var sceneUrl : Object = SceneSourceManager.getAllSourceInsUrl();
			
			for each(var items : Array in sceneUrl)
			{
				for each(var temp : Object in items)
				{
					LoadManager.add(temp["url"],temp["type"]);
				}
			}
			
			LoadManager.start(onTextureComplete);
		}
		
		private function onTextureComplete(value : Object = null) : void
		{
			var data : Object = SceneSourceManager.getAllData();
			
			for(var name : String in data)
			{
				handleSceneSource(name);
			}
			
			startGame();
		}
		
		/**
		 *	界面 文件加载完成时调用
		 * @param value	文件数据
		 * 
		 */
		private function uiConfigComplete(value : ByteArray) : void
		{
			UIConfigManager.init(value);
		}
				
		/**
		 *	 皮肤文件加载完成后调用
		 * @param value	文件数据
		 * 
		 */		
		private function skinComplete(value : String) : void
		{
			SkinManager.init(value);
		}
		
		/**
		 *	配置资源加载完成 
		 * 
		 */
		private function onSourceComplete() : void
		{
			MouseManager.init(gameStage);
			
			startGame();
		}

		/**
		 *	处理资源加载 
		 * @param param
		 * 
		 */		
		private function handleSceneSource(sceneName : String) : void
		{
			var allId : Array = SceneSourceManager.getSceneSourceId(sceneName);
			var data : Array;
			var xml : XML;
			var byte : ByteArray;
			var name : String;
			
			for(var i:int=0;i<allId.length;i++)
			{
				name = allId[i];
				data = SceneSourceManager.getSourceItem(sceneName,name);
				
				if(data[0]["type"] == 1)	//XML文件
				{
					xml = new XML(LoadManager.getSource((data[0]["url"])));
				}
				else if(data[0]["type"] == 2)	//二进制文件
				{
					byte = LoadManager.getSource((data[0]["url"])) as ByteArray;
				}
				
				if(data[1]["type"] == 1)
				{
					xml = new XML(LoadManager.getSource((data[1]["url"])));
				}
				else if(data[1]["type"] == 2)
				{
					byte = LoadManager.getSource((data[1]["url"])) as ByteArray;
				}
				
				TexturesManager.add(name,xml,byte);
			}
			
		}
		
		private function addChild(display : DisplayObject,x:Number=0,y:Number=0) : void
		{
			m_backgroundContainer.addChild(display);
			display.x = x;
			display.y = y;
		}
		
		
		private function removeChild(display : DisplayObject) : void
		{
			m_backgroundContainer.removeChild(display);
		}
					
	}
}