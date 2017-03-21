package twaver.common
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import mx.containers.Canvas;
	
	
	[Style(name="backgroundGradientAlphas", type="Array", arrayType="Number", inherit="no")]
	[Style(name="backgroundGradientColors", type="Array", arrayType="uint", format="Color", inherit="no")]
	[Style(name="backgroundGradientRotation", type="Number", inherit="no")]
	[Style(name="position", type="String",enumeration="top,bottom" )]
	
	public class GradientCanvas extends Canvas
	{
		public function GradientCanvas()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var position:* = this.getStyle("position");
			var backgroundGradientColors:Array = this.getStyle("backgroundGradientColors");
			var backgroundGradientAlphas:Array = this.getStyle("backgroundGradientAlphas");
			var backgroundGradientRotation:Number = this.getStyle("backgroundGradientRotation");
			this.graphics.lineStyle();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(unscaledWidth, unscaledHeight, backgroundGradientRotation*Math.PI/180); 
			drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 0, backgroundGradientColors, backgroundGradientAlphas, matrix, GradientType.LINEAR);
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(position){
				var isTop:Boolean = ("top" == position);
				this.graphics.lineStyle(1, 0x515151);
				if(isTop){
					this.graphics.moveTo(0, unscaledHeight-1);
					this.graphics.lineTo(unscaledWidth, unscaledHeight-1);
					this.graphics.lineStyle(1, 0xB9B9B9);
					this.graphics.moveTo(0,0);
					this.graphics.lineTo(unscaledWidth, 0);
					this.graphics.lineStyle(1, 0xE2E2E2);
					this.graphics.moveTo(0,1);
					this.graphics.lineTo(unscaledWidth, 1);
					
				}else{
					this.graphics.moveTo(0, 0);
					this.graphics.lineTo(unscaledWidth, 0);
				}
			}
		}
	}
}