package sourceCode.alarmmgrGraph.actionscript
{
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	public class AlarmColorRenderer extends TextInput
	{
		public function AlarmColorRenderer(){
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
				if(data.alarmlevelname=="紧急告警"){
					this.setStyle("backgroundColor",0xFF0000); //红色
				}
				if(data.alarmlevelname=="主要告警"){   
					this.setStyle("backgroundColor",0xFFBF00);   //橙色  
				}   
				if(data.alarmlevelname=="次要告警"){   
					this.setStyle("backgroundColor",0xFFFF00);//黄色  
				}
				if(data.alarmlevelname=="提示告警"){
					this.setStyle("backgroundColor",0x00FFFF);//蓝色
				}
				if(data.alarmlevelname=="其他告警"){
					this.setStyle("backgroundColor",0xC800FF);//紫色
				}
			}   
		} 
	}
}