package sourceCode.sysGraph.actionscript
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.ResizeEvent;
	
	import twaver.IElement;
	import twaver.IImageAsset;
	import twaver.Node;
	import twaver.Styles;
	import twaver.Utils;
	import twaver.network.Network;
	import twaver.network.layout.CloudLayouter;

	public class StoryLayouter extends CloudLayouter
	{
		private var part:int;
		private var lastElement:IElement = null;
		
		public function StoryLayouter(network:Network, part:int)
		{
			super(network);
			this.part = part;
			this.elliptical = true;
			this.ceaseRate = 1;
			this.timerDelay = 100;
			this.moveSpeed = 1;
		}
		
		override public function isLayoutable(node:Node):Boolean{
			return node.getClient("part") == this.part;
		}
		
		override public function get layoutRect():Rectangle{
			var w:Number = this.network.width/this.network.zoom;
			var h:Number = this.network.height/this.network.zoom;			
//			if(this.network.name != "sysNetwork"){
				return new Rectangle(w*2/8, h*1.8/8, (w+800)/4, (h+800)/4);
//			}else{
//				return new Rectangle(w*2/8, h/8, (w+500)/5, (h+500)/5);
//			}
//			if(this.part == 2){
//				return new Rectangle(w/8, h*5/8, w/4, h/4);
//			}
//			if(this.part == 3){
//				return new Rectangle(w*5/8, h*5/8, w/4, h/4);
//			}
			throw new Error("can not come here!");
		}
		
		override protected function updateNode(node:Node, zIndex:int, count:int, alpha:Number):void{
			node.setStyle(Styles.BODY_ALPHA, 0.3 + alpha * 0.7);
			var point:Point = node.centerLocation;
			var image:IImageAsset = Utils.getImageAsset(node.image);
			node.width = image.width * (0.1 + alpha * 0.4);
			node.height = image.height * (0.1 + alpha * 0.4);
			node.centerLocation = point;		
		}
		
		override protected function handleMouseMove(e:MouseEvent):void{
			super.handleMouseMove(e);
			this.handleMouseEvent(e);
		}		
		
		override protected function handleMouseOver(e:MouseEvent):void{
			super.handleMouseOver(e);
			this.handleMouseEvent(e);
		}

		private function handleMouseEvent(e:MouseEvent):void{
			var element:IElement = network.getElementByMouseEvent(e);
			if(element != lastElement){
				if(lastElement != null){
					lastElement.setStyle(Styles.VECTOR_OUTLINE_WIDTH, -1);
				}
				lastElement = element;
				if(lastElement != null){
					lastElement.setStyle(Styles.VECTOR_OUTLINE_WIDTH, 1);
				}
			}			
			
			var point:Point = network.globalToLocal(new Point(e.stageX, e.stageY));
			point.x /= this.network.zoom;
			point.y /= this.network.zoom;
			var activeRect:Rectangle = this.layoutRect;
			activeRect.inflate(activeRect.width/2, activeRect.height/2);
			if(activeRect.containsPoint(point)){
				this.timer.start();
			}else{
				this.timer.stop();
			}	
		}

		override protected function handleRollOut(e:MouseEvent):void{
			super.handleRollOut(e);
			this.timer.stop();
		}	
		
		override protected function handleResize(e:ResizeEvent):void{
			super.handleResize(e);
			this.updateLayoutRect();
		}	
	}
}