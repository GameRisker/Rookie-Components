package game
{
	import game.common.Define;
	import game.manager.MouseManager;
	import game.manager.StageManager;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	public class GameMain extends Sprite
	{
		private var GameStage : StageManager;
		
		public function GameMain()
		{
			if(stage)
				Init();
			else
				addEventListener(Event.ADDED_TO_STAGE , Init);
		}
		
		private function Init(event : Event = null) : void
		{
			trace("Rookie Framework version :" , Define.VERSION);
			
			GameStage = new StageManager();
			GameStage.init(stage,this);
			MouseManager.init(stage);
			
//			stage.addEventListener(TouchEvent.TOUCH , OnTouchEvent);
		}
		
		private function OnTouchEvent(event : TouchEvent) : void
		{
//			var touch : Touch = event.getTouch(stage,TouchPhase.ENDED);
//			
//			if(touch)
//			{
//				trace(touch);
//			}
		}
	}
}