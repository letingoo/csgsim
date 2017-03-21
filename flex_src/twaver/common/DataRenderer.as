package twaver.common
{
	import mx.containers.HBox;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	
	import twaver.IData;
	import twaver.IElement;
	import twaver.Utils;
	import twaver.controls.Table;

	public class DataRenderer extends HBox
	{
		public static const size:Number = 18;
		private var image:UIComponent = new UIComponent();
		private var textInput:TextInput = new TextInput();
		
		public function DataRenderer()
		{
			textInput.percentWidth = 100;
			this.addChild(image);
			this.addChild(textInput);
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.textInput.mouseEnabled = false;
			this.textInput.mouseChildren = false;	
			this.textInput.setStyle("borderStyle", "none");
			this.textInput.setStyle("backgroundAlpha", 0);
			this.setStyle("paddingLeft", 3);
			this.setStyle("paddingRight", 3);	
			this.setStyle("horizontalGap", 2);	
		}

		override public function set data(value:Object):void {		
			super.data = value;
			var d:IData = null;
			if(this.data is IData){
				d = this.data as IData;
			}
			else if(this.data && this.owner is Table){
				d = Table(this.owner).dataBox.getDataByID(this.data.id);
			}
			image.graphics.clear();
			if(d != null){
				this.textInput.text = Utils.getQualifiedClassName(d);
				var color:* = null;
				if(d is IElement){
					var element:IElement = IElement(d);
					if(element.alarmState.highestNativeAlarmSeverity != null){
						color = element.alarmState.highestNativeAlarmSeverity.color;
					}
				} 
				Utils.drawImage(image.graphics, d.icon, 0, 0, size, size, color);   	
				image.width = size;
				image.height = size;					
			}else{
				this.textInput.text = label;
				image.width = 0;
				image.height = 0;
			}		
			
		}		
	}
}