package sourceCode.ocableResource.views.link
{
	import flash.events.MouseEvent;
	
	import twaver.*;
	import twaver.network.*;

	public class ElementCreator extends ActionTile implements  IElementCreator
	{
		private var _styles:Array;
		private var _elementClass:Class=Node;
		private var _stationType:String;
		private var _isTnode:String;
		
		public function get stationType():String{
			return _stationType;
		}
		
		public function set stationType(stationType:String):void{
			this._stationType=stationType;
		}
		
		public function get elementClass():Class{
			return this._elementClass;
		}
		
		public function set elementClass(elementClass:Class):void{
			this._elementClass=elementClass;
		}
		
		public function set styles(styles:Array):void{
			this._styles=styles;
		}
		
		public function get isTnode():String{
			return _isTnode;
		}
		
		public function set isTnode(isTnode:String):void{
			this._isTnode=isTnode;
		}
		
		
		public function addStyle(name:String,value:*):void{
			this._styles.push([name,value]);
		}
		
		public function createElement(evt:MouseEvent,network:Network):IElement{
			var element:IElement=new elementClass();
			element.name=label;
			element.icon=imageName;
			element.toolTip = label;
			
			if(shapeType){
				element.setStyle(Styles.CONTENT_TYPE,Consts.CONTENT_TYPE_VECTOR);
				element.setStyle(Styles.VECTOR_SHAPE,shapeType);
			}
			if(_styles){
				for each(var style:* in _styles){
					element.setStyle(style[0],style[1]);
				}
			}
			if(element is Node){
			(element as Node).image=imageName;
				if(network){
					(element as Node).setStyle("maintainAspectRatio",true);
					(element as Node).width = imageSizeforNode;
					(element as Node).height = imageSizeforNode;
					(element as Node).centerLocation=network.getLogicalPoint(evt);
				}
			}
			return element;
		}
	}
}