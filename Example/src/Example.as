package
{
	import com.gamerisker.controls.CheckBox;
	import com.gamerisker.controls.CheckBoxGroup;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import game.GameMain;
	import game.common.Define;
	import game.manager.LoadManager;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class Example extends Sprite
	{
		private var GameStarling : Starling;
		
		public function Example()
		{
			if(stage)
			{
				Init();
			}
			else
			{
				addEventListener(starling.events.Event.ADDED_TO_STAGE , Init);	
			}
		}
		
		private function Init(event : starling.events.Event = null) : void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 24;
			stage.color = 0x000000;
			
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			
			SetSystem();
			
			LoadManager.init();
			LoadManager.add(Define.SKIN_CONFIG,1,"");
			LoadManager.add(Define.SCENE_SOURCE , 1,"");
			LoadManager.add(Define.UI_CONFIG,2,"");
						
			LoadManager.start(StarlingInit);
		}
		
		private function SetSystem() : void
		{
			//璁惧涓嶄紤鐪�
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function StarlingInit(value : Object = null) : void
		{
			var screenWidth : int = stage.fullScreenWidth;
			var screenHeight : int = stage.fullScreenHeight;

			Starling.multitouchEnabled = false;
			Starling.handleLostContext = true;
			
			
			GameStarling = new Starling(GameMain , stage , null,null,"auto","baseline");

			GameStarling.start();
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, 
				function (e:flash.events.Event):void { GameStarling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, 
				function (e:flash.events.Event):void { GameStarling.stop(); });
			
		}
	}
}
