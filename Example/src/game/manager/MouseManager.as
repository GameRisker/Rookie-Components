package game.manager
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	/**
	 *	鼠标管理器 习惯页游的写法了。
	 * @author YangDan
	 * 
	 */	
	public class MouseManager
	{		
		private static var starlingStage : starling.display.Stage;
		
		private static var eventList : Dictionary;
		private static var functionList : Dictionary;
		
		public function MouseManager()
		{
			
		}
		
		public static function init(starstg : starling.display.Stage) : void
		{
			eventList = new Dictionary(true);
			functionList = new Dictionary(true);
			
			starlingStage = starstg;
			starlingStage.addEventListener(TouchEvent.TOUCH , onStarlingClick);
		}
		
		public static function destroy() : void
		{
			starlingStage.removeEventListener(TouchEvent.TOUCH , onStarlingClick);
			
			eventList = null;
			functionList = null;
			starlingStage = null;
		}
		
		/**
		 *	释放所有时间监听 
		 * 
		 */		
		public static function removeAll() : void
		{
			var name : String = "";
			
			for(var child : * in functionList)
			{
				functionList[child] = null;
				eventList[child] = null;
				delete eventList[child];
				delete functionList[child];
			}
		}

		/**
		 *	添加Starling事件 
		 * @param EventType
		 * @param child
		 * @param fun
		 * 
		 */		
		public static function addTouch(EventType : String , child : starling.display.DisplayObject , fun : Function) : void
		{
			if(child == null)throw(new Error("child is null"));
			
			var list : Array = eventList[child];
			var funList : Array = functionList[child];
			
			if(list == null)
			{
				eventList[child] = [EventType];
				functionList[child] = [fun];
			}
			else if(list.indexOf(EventType) == -1)
			{
				list.push(EventType);
				funList.push(fun);
			}
			else
			{
				throw(new Error("添加TouchEvent出错:" + EventType + child));
			}
		}
		
		/**
		 *	移除Staring事件 
		 * @param EventType
		 * @param child
		 * 
		 */		
		public static function removeTouch(EventType : String , child : starling.display.DisplayObject) : void
		{
			if(child == null)
				throw(new Error("RemoveTouch child is null"));
			
			var list : Array = eventList[child];
			var funList : Array = functionList[child];
			var index : int;
			
			if(list != null)
			{
				index = list.indexOf(EventType);
				list.splice(index,1);
				funList.splice(index,1);
				
				if(list.length == 0)
				{
					eventList[child] = null;
					delete eventList[child];
				}
				
				if(funList.length == 0)
				{
					functionList[child] = null;
					delete functionList[child];
				}
			}
		}
		
		private static function onStarlingClick(event : starling.events.TouchEvent) : void
		{
			var touch : Touch;
			var eventType : String;
			
			var list : Array;
			var funList : Array;
			
			for(var child : * in functionList)
			{
				list = eventList[child];
				funList = functionList[child];
				
				for(var i:int=0;i<list.length;i++)
				{
					eventType = list[i];
					touch = event.getTouch(child,eventType);
					if(touch==null)continue;
					
					var childRect:Rectangle = child.getBounds(child.stage);
					
					if (touch.globalX > childRect.x &&
						touch.globalY > childRect.y &&
						touch.globalX < childRect.x + childRect.width &&
						touch.globalY < childRect.y + childRect.height)
					{
						funList[i](event,touch,child);
					}
				}
			}
		}
		
		private static function getChildEvent(target : DisplayObject) : DisplayObject
		{
			if(target && target.parent!=null)
			{
				for(var child : * in functionList)
				{
					if(child == target)
					{
						return child;
					}
				}
				return getChildEvent(target.parent);
			}
			else
			{
				return null;
			}
			
			return null;
		}
	}
}