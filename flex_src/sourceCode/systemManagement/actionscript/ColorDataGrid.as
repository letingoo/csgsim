package sourceCode.systemManagement.actionscript
{
	import mx.controls.DataGrid; 
	import mx.controls.*; 
	
	import flash.display.Shape; 
	
	import mx.core.FlexShape; 
	
	import flash.display.Graphics; 
	
	import flash.display.Sprite; 
	
	import mx.rpc.events.AbstractEvent; 
	
	import mx.collections.ArrayCollection; 
	
	import flash.events.Event; 
	
	public class ColorDataGrid extends DataGrid 
	{ 
		private var _rowColorFunction:Function; 
		
		public function ColorDataGrid() 
		{ 
			super(); 
		} 
		
		public function set rowColorFunction(f:Function):void 
		{ 
			
			this._rowColorFunction = f; 
		} 
		
		public function get rowColorFunction():Function 
		{ 
			
			return this._rowColorFunction; 
		} 
		
		override protected function drawRowBackground(s:Sprite,rowIndex:int,y:Number, height:Number, color:uint, dataIndex:int):void 
		{ 
			if(this.rowColorFunction != null ){ 
				if(dataProvider != null){
					if( dataIndex < this.dataProvider.length ){ 
						var item:Object = this.dataProvider.getItemAt(dataIndex); 
						color = this.rowColorFunction.call(this, item, color); 
					} 
				}
			}            
			super.drawRowBackground(s, rowIndex, y, height, color, dataIndex); 
		} 
	} 
}