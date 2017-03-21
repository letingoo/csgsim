package sourceCode.ocableResource.actionscript
{
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	public class InfluenceColorRenderer extends TextInput
	{
		public function InfluenceColorRenderer(){
			this.setStyle("borderStyle", "none");
			this.setStyle("textAlign", "center");
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		override public function set data(value:Object):void {		
			super.data = value;
			var label:String = null;
			var color:Object = null;
			if(data){   
				if(data.inflevel=="中断"){
					this.setStyle("backgroundColor",0xFF0000); //红色
				}
				if(data.inflevel=="影响"){   
					this.setStyle("backgroundColor",0xFFBF00);   //橙色  
				}   
				
			}   
		} 
	}
}