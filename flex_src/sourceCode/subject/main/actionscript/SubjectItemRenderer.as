package com.metarnet.mnt.subject.main.actionscript
{
	import mx.controls.Label;
	
	public class SubjectItemRenderer extends Label
	{
		public function SubjectItemRenderer()
		{			
			this.setStyle("textAlign", "center");
			this.setStyle("fontWeight", "bold");
			this.setStyle("fontSize", "20");
			this.useHandCursor = true;
		}
		
		override public function set data(value:Object):void {		
			super.data = value;
			this.setStyle("backgroundColor", "green");
		}

	}
}