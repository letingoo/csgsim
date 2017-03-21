package common.actionscript
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Menu;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.menuClasses.IMenuItemRenderer;
	import mx.core.Application;
	import mx.core.ScrollPolicy;
	import mx.core.mx_internal;
	import mx.managers.PopUpManager;
	
	use namespace mx_internal;
	
	public class CustomMenu extends Menu
	{
		private var xpos:Object = 0;
		private var ypos:Object = 0;
		private var ErrHeight:Number = 0;
		private var isDirectionLeft:Boolean = false;
		
		private const END_OF_SCREEN_MENU_PADDING:Number = 5;
		
		public function CustomMenu()
		{
			super();
		}
		
		public static function createMenu(parent:DisplayObjectContainer, mdp:Object, showRoot:Boolean=true):CustomMenu
		{
			var menu:CustomMenu = new CustomMenu();
			menu.tabEnabled = false;
			menu.owner = DisplayObjectContainer(Application.application);
			menu.showRoot = showRoot;
			
			popUpMenu(menu, parent, mdp);
			
			return menu;
		}
		
		override mx_internal function openSubMenu(row:IListItemRenderer):void
		{
			supposedToLoseFocus = true;
			
			var r:Menu = getRootMenu();
			var menu:Menu;
			
			if (!IMenuItemRenderer(row).menu)
			{
				menu = new CustomMenu();
				menu.parentMenu = this;
				menu.owner = this;
				menu.showRoot = showRoot;
				menu.dataDescriptor = r.dataDescriptor;
				menu.styleName = r;
				menu.labelField = r.labelField;
				menu.labelFunction = r.labelFunction;
				menu.iconField = r.iconField;
				menu.iconFunction = r.iconFunction;
				menu.itemRenderer = r.itemRenderer;
				menu.rowHeight = r.rowHeight;
				menu.scaleY = r.scaleY;
				menu.scaleX = r.scaleX;
				
				if (row.data &&
					_dataDescriptor.isBranch(row.data) &&
					_dataDescriptor.hasChildren(row.data))
				{
					menu.dataProvider = _dataDescriptor.getChildren(row.data);
				}
				
				menu.sourceMenuBar = sourceMenuBar;
				menu.sourceMenuBarItem = sourceMenuBarItem;
				
				IMenuItemRenderer(row).menu = menu;
				PopUpManager.addPopUp(menu, r, false);
			}
			else
			{
				menu = IMenuItemRenderer(row).menu;
			}
			
			var _do:DisplayObject = DisplayObject(row);
			var sandBoxRootPoint:Point = new Point(0,0);
			sandBoxRootPoint = _do.localToGlobal(sandBoxRootPoint);
			if (_do.root)   
				sandBoxRootPoint = _do.root.globalToLocal(sandBoxRootPoint);
			var showY:Number = sandBoxRootPoint.y;
			var showX:Number = sandBoxRootPoint.x + row.width;
			var screen:Rectangle = systemManager.getVisibleApplicationRect();
			var sbRoot:DisplayObject = systemManager.getSandboxRoot();
			
			var screenPoint:Point = sbRoot.localToGlobal(new Point(showX, showY));
			
			var shift:Number = screenPoint.y + height - screen.bottom;
			super.openSubMenu(row);
			if (shift > 0){
				if(screenPoint.y + menu.height - screen.bottom > 0)
					IMenuItemRenderer(row).menu.move(menu.x,showY - screenPoint.y - menu.height + screen.bottom);
				else IMenuItemRenderer(row).menu.move(menu.x,showY);
			}
		}
		
	}
}