package sourceCode.alarmmgr.actionscript
{
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	
	import mx.controls.TextInput;
	import mx.core.IFlexDisplayObject;
	
	[Style(name="icon", type="Class", inherit="no")]
	
	public class SearchTextInput extends TextInput
	{
		private var _icon:IFlexDisplayObject;
		public function SearchTextInput()
		{
			super();
			this.setStyle("paddingTop", 2);
			this.filters = [new DropShadowFilter(2, 90, 0x000000, 0.6, 2, 2, 1, 1, true)];
		}
		
		override protected function createBorder():void{
		}
		
		override public function set height(value:Number):void{
			super.height = value;
			if(_icon){
				_icon.y = (this.height - _icon.height)/2;
			}
			if(textField){
				this.setStyle("paddingTop" , (this.height - textField.height)/2);
			}
		}
		
		override protected function createChildren() : void{
			super.createChildren();
			createIcon();
		}
		
		protected function createIcon():void{
			if(!_icon){
				var iconClass:Class = this.getStyle("icon");
				if(iconClass!=null){
					_icon = new iconClass();
					addChild(DisplayObject(_icon));
					_icon.y = (this.height - _icon.height)/2;
					invalidateDisplayList();
				}
			}
		}
		
		override public function getStyle(styleProp:String):*{
			var result:* = super.getStyle(styleProp);
			if(styleProp=="paddingLeft"){
				if(!result){
					return _icon ? _icon.width : super.getStyle("cornerRadius");
				}
			}
			if(styleProp=="paddingRight"){
				if(!result){
					return super.getStyle("cornerRadius");
				}
			}
			return result;
		}
		
		override public function styleChanged(styleProp:String):void{
			var allStyles:Boolean = (styleProp == null || styleProp == "styleName");
			super.styleChanged(styleProp);
			if(allStyles || styleProp == "icon"){
				if(_icon){
					removeChild(DisplayObject(_icon));
					_icon = null;
					createIcon();
				}
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var backgroundColor:uint = getStyle("backgroundColor");
			var backgroundAlpha:Number = getStyle("backgroundAlpha");
			var cornerRadius:Number = this.getStyle("cornerRadius");
			this.graphics.clear();
			this.graphics.lineStyle();
			this.graphics.beginFill(backgroundColor, backgroundAlpha);
			this.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, cornerRadius);
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}