package com.montage.controls.contexMenuManager
{
	import flash.display.InteractiveObject;
	import flash.events.*;
	import flash.errors.IllegalOperationError;
	import flash.ui.*;
	import flash.utils.getQualifiedClassName;
	public class ContextMenuManager extends EventDispatcher
	{
		protected var menu:ContextMenu;
		protected var target:InteractiveObject;
		
		public function ContextMenuManager(target:InteractiveObject,hideBuiltInItems:Boolean=true)
		{
			this.target=target;
			menu=new ContextMenu();
			if(hideBuiltInItems)
			{
				menu.hideBuiltInItems();
			}
			this.target.contextMenu=menu;
			menu.addEventListener(ContextMenuEvent.MENU_SELECT,passEvent);
		}
		
		public function add(caption:String,handler:Function,separatorBefore:Boolean=false,enabled:Boolean=true,visible:Boolean=true):ContextMenuItem
		{
			var result:ContextMenuItem=createItem(caption,handler,separatorBefore,enabled,visible);
			menu.customItems.push(result);
			return result;
		}
		
		
		public function insert(id:*,caption:String,handler:Function,separatorBefore:Boolean=false,enabled:Boolean=true,visible:Boolean=true):ContextMenuItem
		{
			var result:ContextMenuItem=createItem(caption,handler,separatorBefore,enabled,visible);
			var index:int=id is String?getIndexByCaption(id):id as int;
			(menu.customItems as Array).splice(index,0,result);
			return result;
		}
		
		public function remove(id:*):void
		{
			if(id is String)
			{
				id=getIndexByCaption(id);
			}
			customItems.splice(id as Number,1);
		}
		
		
		public function hideBuiltInItems():void
		{
			menu.hideBuiltInItems();
		}
		
		
		public function getItem(id:*):ContextMenuItem
		{
			if(id is String)
			{
				id=getIndexByCaption(id);
			}
			return menu.customItems[id];
		}
		
		
		public function get customItems():Array
		{
			return menu.customItems;
		}
		
		
		
		public function get builtInItems():ContextMenuBuiltInItems
		{
			return menu.builtInItems;
		}
		
		
		public function get contextMenu():ContextMenu
		{
			return menu;
		}
		
		/**         *@private         */
		
		protected function createItem(caption:String,handler:Function,separatorBefore:Boolean=false,enabled:Boolean=true,visible:Boolean=true):ContextMenuItem
		{
			var result:ContextMenuItem=new ContextMenuItem(caption,separatorBefore,enabled,visible);
			result.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,handler);
			result.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,passEvent);
			return result;
		}
		
		/**         *@private         */
		
		protected function getIndexByCaption(caption:String):int
		{
			for(var i:uint=0;i<menu.customItems.length;i++)
			{
				if(menu.customItems[i].caption==caption)
				{
					return i;
				}
			}
			return-1;
		}
		
		/**         * @private         */
		
		protected function passEvent(event:ContextMenuEvent):void
		{
			dispatchEvent(new ContextMenuEvent(event.type,event.bubbles,event.cancelable,event.mouseTarget,event.contextMenuOwner));
		}
	}
}
