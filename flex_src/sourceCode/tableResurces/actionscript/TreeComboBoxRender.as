package sourceCode.tableResurces.actionscript
{
	import flash.events.MouseEvent;
	
	import mx.controls.Tree;
	import mx.events.ListEvent;
	
	public class TreeComboBoxRender extends Tree
	{
		// -------------------------------------------------------------------------
		//
		// Properties 
		//			
		// -------------------------------------------------------------------------
		
		[Bindable]
		public var outerDocument:TreeComboBox;
		
		// -------------------------------------------------------------------------
		//
		// Constructor 
		//			
		// -------------------------------------------------------------------------
		
		public function TreeComboBoxRender()
		{
			super();
			this.addEventListener(ListEvent.CHANGE, onSelectionChanged);
			this.addEventListener(MouseEvent.MOUSE_OUT,onSetValue0);
			this.addEventListener(MouseEvent.MOUSE_OVER,onSetValue1);
		}
		
		// -------------------------------------------------------------------------
		//
		// Handlers 
		//			
		// -------------------------------------------------------------------------
		
		private function onSelectionChanged(event:ListEvent):void
		{
			outerDocument.updateLabel(event.currentTarget.selectedItem);
		}
		
		private function onSetValue0(event:MouseEvent):void
		{
			outerDocument.setValue(false);
		}
		
		private function onSetValue1(event:MouseEvent):void
		{
			outerDocument.setValue(true);
		}
		// -------------------------------------------------------------------------
		//
		// Other methods 
		//			
		// -------------------------------------------------------------------------
		
		public function expandParents(node:Object):void
		{
			if (node && !isItemOpen(node))
			{
				expandItem(node, true);
				expandParents(node.parent());
			}		
		}
		
		public function selectNode(node:Object):void
		{
			selectedItem = node;
			var idx:int = getItemIndex(selectedItem);
			scrollToIndex(idx);
		}
	}
}