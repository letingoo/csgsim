package common.actionscript
{
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.core.*;
	import flash.text.TextFieldAutoSize;
	public class MyLabel extends Label
	{
		public function MyLabel()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			textField.multiline = true;
			textField.wordWrap = true;
			textField.autoSize = TextFieldAutoSize.CENTER;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			textField.y = (this.height - textField.height) >> 1;
			
			height = textField.height + getStyle("paddingTop") + getStyle("paddingBottom");
		}
		
	}
}