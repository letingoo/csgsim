package common.actionscript
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.automation.codec.KeyCodePropertyCodec;
	import mx.controls.Alert;
	
	import twaver.IElement;
	import twaver.network.Network;
	import twaver.network.interaction.BasicInteractionHandler;
	
	public class CustomInteractionHandler extends BasicInteractionHandler
	{
		private var pressPoint:Point;  
		
		private var oldButtonMode:Boolean;  
		
		private var olduseHandCursor:Boolean;  
		private var keydown:Boolean ;

		public function CustomInteractionHandler(network:Network)
		{
			super(network);
			installListeners();  
			

		}
		override public function installListeners():void 
		{ 
			this.network.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);  
			
		 	this.network.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);  
			this.network.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			this.network.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
		 }  
		
		private function keyDownHandler(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.CONTROL)
				this.keydown = true;
		}
		
		private function keyUpHandler(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.CONTROL)
				this.keydown = false;
		}
		 /**  
		
		* @inheritDoc  
		
		 *  
		*/ 
		
		override public function uninstallListeners():void 
		{ 
			this.network.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);  
			
			this.network.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);  

			this.network.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			
			this.network.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			
		}  
		
		
		private function handleMouseDown(e:MouseEvent):void 
		{ 
			if (!this.network.isValidMouseEvent(e) || this.network.isMovingElement || this.network.isEditingElement)
			{  
				
				 return;
			 }  
			
			var element:IElement=network.getElementByMouseEvent(e);  
			
			if (element) 
			{  
				
			 	if (!this.network.selectionModel.contains(element))
				{  
					if(this.keydown){
						this.network.selectionModel.appendSelection(element);
					}else{
						this.network.selectionModel.setSelection(element);  
					}
					
				}  
				
			} 
			else
			{  
					
				this.network.selectionModel.clearSelection();  
				pressPoint=new Point(e.stageX, e.stageY);  
				this.network.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);  
				oldButtonMode=this.network.buttonMode;  
				olduseHandCursor=this.network.useHandCursor;  
				this.network.useHandCursor=true 
				this.network.buttonMode=true 
				this.network.cursorManager.removeAllCursors();  
			}  
			
		}  
		private function handleMouseUp(e:MouseEvent):void
		{ 
			if (pressPoint != null)
			{ 
				pressPoint=null;
				this.network.buttonMode=oldButtonMode;
				this.network.useHandCursor=olduseHandCursor;  
				this.network.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove); 
			}  
		}  
		private function handleMouseMove(e:MouseEvent):void 
		{  
			if (!e.buttonDown) 
			{  
				pressPoint=null;  
				
				this.network.buttonMode=oldButtonMode;  
				
				this.network.useHandCursor=olduseHandCursor;  
				
				this.network.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);  
				
				return;  
				
			}  
			if (this.network.verticalScrollBar == null && this.network.horizontalScrollBar == null)
			{ 
				return; 
			}  
			var xOffset:Number=pressPoint.x - e.stageX;  
			var yOffset:Number=pressPoint.y - e.stageY;  
			pressPoint.x-=xOffset;  
			pressPoint.y-=yOffset;  
			
			this.network.horizontalScrollPosition+=xOffset;  
			
			this.network.verticalScrollPosition+=yOffset;  
			
		}  
		

	}
}