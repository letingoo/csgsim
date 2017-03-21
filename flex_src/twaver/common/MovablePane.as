package twaver.common
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.containers.Panel;

	public class MovablePane extends Panel
	{
			      
		public function MovablePane(){
			//#00ccff, #0066ff
 			this.setStyle("headerColors", [0x0066ff, 0x00ccff]);		
 			this.setStyle("dropShadowColor", 0x00ccff);
 			this.setStyle("backgroundAlpha", 0.5);
 			this.setStyle("headerHeight", 20);
 			this.setStyle("borderThicknessLeft", 5); 
 			this.setStyle("borderThicknessRight", 5);
 			this.setStyle("borderThicknessBottom", 5);
 			this.setStyle("paddingBottom", 0); 
 			this.setStyle("paddingTop", 0);
		}
			          
		override protected function createChildren():void{
			super.createChildren();        	
			this.titleBar.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        	this.titleBar.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp); 
		}			          
			            
        private function handleMouseDown( evt:MouseEvent ):void
        {
        	this.setStyle("left", null);
        	this.setStyle("right", null);
        	this.setStyle("top", null);
        	this.setStyle("bottom", null);
           	var limitdrag:Rectangle = new Rectangle(0, 0, this.parent.width-this.width, this.parent.height-this.height);
            this.startDrag(false, limitdrag);
        }	
        
       	private function handleMouseUp( evt:MouseEvent ):void
       	{
       		this.stopDrag();
       	}    		
	}
}