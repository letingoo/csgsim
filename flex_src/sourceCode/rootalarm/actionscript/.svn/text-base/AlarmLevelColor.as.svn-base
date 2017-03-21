package sourceCode.rootalarm.actionscript
{
	import mx.controls.TextInput;

	public class AlarmLevelColor extends TextInput
	{
		
			public function AlarmLevelColor()
			{
				this.setStyle("borderStyle", "none");
				this.setStyle("textAlign", "center");
				this.mouseEnabled = false;
				this.mouseChildren = false;
			}
			
			
			override public function set data(obj:Object):void{
				super.data=obj;
				if(obj){
					if(obj.alarmlevelname=="紧急告警"){
						this.setStyle("backgroundColor",0xFF0000); //红色
					}
					if(obj.alarmlevelname=="主要告警"){
						this.setStyle("backgroundColor",0xFFBF00);   //橙色  	
					}
					if(obj.alarmlevelname=="次要告警"){
						this.setStyle("backgroundColor",0xFFFF00);//黄色  
					}
					if(obj.alarmlevelname=="提示告警"){
						this.setStyle("backgroundColor",0x00FFFF);//蓝色
					}
				}
			}  
		}

		
	
}