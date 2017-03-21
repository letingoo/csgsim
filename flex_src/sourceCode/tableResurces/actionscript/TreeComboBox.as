package sourceCode.tableResurces.actionscript
{
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.DropdownEvent;
	import mx.events.ListEvent;
	import mx.utils.ObjectUtil;
	
	public class TreeComboBox extends ComboBox
	{
		
		[Bindable]public var elementcode:String="";
		[Bindable]public var elementlabel:String="";
		
		// ----------------------------
		// ddFactory
		// ----------------------------
		
		private var _ddFactory:ClassFactory;
		
		private function get ddFactory():ClassFactory
		{
			if (_ddFactory == null)
			{
				_ddFactory = new ClassFactory();
				_ddFactory.generator = TreeComboBoxRender;
				_ddFactory.properties = {
					width:this.width, 
						height:this._treeHeight,
						outerDocument:this
				};
			}
			return _ddFactory;		
		}	
		
		// ----------------------------
		// treeHeight
		// ----------------------------
		
		private var _treeHeight:Number;
		
		public function get treeHeight():Number
		{
			return _treeHeight;
		}
		
		public function set treeHeight(value:Number):void
		{
			this._treeHeight = value;
			ddFactory.properties["height"] = this._treeHeight;
		}
		
		private var _treeWidth:Number;
		
		public function get treeWidth():Number
		{
			return _treeWidth;
		}
		
		public function set treeWidth(value:Number):void
		{
			this._treeWidth = value;
			ddFactory.properties["treeWidth"] = this._treeWidth;
		}
		
		// ----------------------------
		// treeSelectedItem
		// ----------------------------
		
		public var treeSelectedItem:Object;
		
		// -------------------------------------------------------------------------
		//
		// Constructor 
		//			
		// -------------------------------------------------------------------------
		
		public function TreeComboBox()
		{
			super();
			
			this.dropdownFactory = ddFactory;
			
			this.addEventListener(DropdownEvent.OPEN, onComboOpen);
		}
		
		// -------------------------------------------------------------------------
		//
		// Handlers 
		//			
		// -------------------------------------------------------------------------
		
		private function onComboOpen(event:DropdownEvent):void
		{
			var tree:TreeComboBoxRender = dropdown as TreeComboBoxRender;
			if (treeSelectedItem)
			{
				tree.expandParents(treeSelectedItem);
				tree.selectNode(treeSelectedItem);
			}
			else
			{
				tree.expandItem(dataProvider.getItemAt(0), true);
			}
		}
		
		// -------------------------------------------------------------------------
		//
		// Overridden methods 
		//			
		// -------------------------------------------------------------------------
		
		/**
		 * Ovverride to avoid root node label being displayed as combo text when 
		 * closing the combo box. 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, 
													  unscaledHeight:Number):void 
		{ 
			super.updateDisplayList(unscaledWidth, unscaledHeight);   
			
			if(dropdown && treeSelectedItem && treeSelectedItem[labelField] != null)
			{   
				if(treeSelectedItem.@isBranch==false)
				{
					text = treeSelectedItem[labelField];
					dropdown.selectedItem = treeSelectedItem;
				}
			} 
		} 
		
		override protected function collectionChangeHandler(event:Event):void{

		}
		
		private function openTree():void{
			(TreeComboBoxRender)(dropdown).expandItem(treeSelectedItem,true);
		}
		// -------------------------------------------------------------------------
		//
		// Other functions 
		//			
		// -------------------------------------------------------------------------
		
		public function updateLabel(selectedItem:Object):void
		{
			if (selectedItem)
			{
				treeSelectedItem = selectedItem;
				var selecteditem:XML=selectedItem as XML;
				if(selecteditem.@isBranch==true)
				{
					if(selecteditem.children()==null||selecteditem.children().length()==0)
					{
						var event:TreeComboBoxItemChange=new TreeComboBoxItemChange("getChildNode",treeSelectedItem);
						parentDocument.dispatchEvent(event);
						dropdown.callLater(openTree);
					}
				}
				else
				{
					text = treeSelectedItem[labelField];
					this.elementcode=new String(treeSelectedItem.@id);
					this.elementlabel=new String(treeSelectedItem.@label);
				}
			}
			
		}
		
		public var b:Boolean=true;
		
		public function setValue(b:Boolean):void{
			this.b=b;
		}
		
		override public function close(trigger:Event=null):void
		{
			if(treeSelectedItem==null || treeSelectedItem.@isBranch==false ||b==false)
			{
				super.close(trigger);
			}
		}
		
		override public function set selectedIndex(value:int):void{
			if(treeSelectedItem){
				if(treeSelectedItem.@isBranch==false){
					super.selectedIndex = value;
					invalidateDisplayList();
				}
			}

		}
	}
}