package common.other.SuperPanelControl.nl.wv.extenders.panel
{
	import common.other.SuperPanelControl.WindowContainer;
	import common.other.SuperPanelControl.nl.PanelIcon;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.effects.Move;
	import mx.effects.Resize;
	import mx.events.CloseEvent;
	import mx.events.MoveEvent;
	import mx.managers.CursorManager;
	
	public class PanelWindow extends TitleWindow
	{
		private var oW:Number;
		private var oH:Number;
		private var oX:Number;
		private var oY:Number;
		public var isFlag:Boolean = false;
		
		[Bindable] public var showControls:Boolean = true;
		[Bindable] public var enableResize:Boolean = true;
		[Bindable] public var showMinAndMaxButtions:Boolean = true;
		
		public var normalMaxButton:Button	= new Button();
		public  var closeButton:Button		= new Button();
		public var minimizeButton:Button	= new Button();
		//private var resizeHandler:Button	= new Button();
		
		private var upMotion:Resize			= new Resize();
		private var downMotion:Resize		= new Resize();
		
		private var oPoint:Point 			= new Point();
		private var resizeCur:Number		= 0;
		
		public  var isMinimized:Boolean		= false;
		public  var isMaximumed:Boolean     = false;
		
		public  var windowContainer:WindowContainer;
		public  var panelIcon:PanelIcon;	
//		[Embed(source="assets/images/panelIcon/resizeCursor.png")]
//		private static var resizeCursor:Class;
		
		public function PanelWindow(){
			super();
			this.showCloseButton=false;
//			this.setStyle("horizontalAlign","center");
//			this.setStyle("paddingTop",0);
//			this.setStyle("paddingLeft",0);
//			this.setStyle("paddingRight",0);
//			this.setStyle("paddingBottom",0);
//			this.setStyle("dropShadowEnabled",false);
//			this.setStyle("borderAlpha",1);
//			this.setStyle("borderColor","#CCDDEE");
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if (enableResize) {
				//this.resizeHandler.width     = 12;
				//this.resizeHandler.height    = 12;
				//this.resizeHandler.styleName = "resizeHndlr";
				//this.rawChildren.addChild(resizeHandler);
				this.initPos();
			}
			
			if (showControls) {
				this.minimizeButton.width		= 25;
				this.minimizeButton.height		= 18;
				this.minimizeButton.styleName	= "minimizeBtn";
				this.normalMaxButton.width     	= 25;
				this.normalMaxButton.height    	= 18;
				this.normalMaxButton.styleName 	= "increaseBtn";
				this.closeButton.width     		= 43;
				this.closeButton.height    		= 18;
				this.closeButton.styleName 		= "closeBtn";
				if(showMinAndMaxButtions){
					super.titleBar.addChild(this.minimizeButton);
					
					
					super.titleBar.addChild(this.normalMaxButton);
				}
				super.titleBar.addChild(this.closeButton);
			}
			
			this.positionChildren();	
			this.addListeners();
			if (windowContainer != null) 
				this.createContainerIcon();
//			super.parent.visible=false;
		}
		
		public function addListeners():void {
			if (showControls) {
				this.closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler);
				this.normalMaxButton.addEventListener(MouseEvent.CLICK, normalMaxClickHandler);
				this.minimizeButton.addEventListener(MouseEvent.CLICK, minimizeClickHandler);
				this.addEventListener(MouseEvent.CLICK,panlClickHandler);
				
				this.addEventListener(MoveEvent.MOVE,mouseMoveHandler);
		
			}
			
//			if (enableResize) {
//				//this.resizeHandler.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
//				//this.resizeHandler.addEventListener(MouseEvent.MOUSE_OUT, resizeOutHandler);
//				//this.resizeHandler.addEventListener(MouseEvent.MOUSE_DOWN, resizeDownHandler);
//			}
		}
		private function mouseMoveHandler(event:MoveEvent):void
		{
//			if(panelIcon.label == "报表门户")
//			{	
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "设备台账统计" ){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "板卡台账统计"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "光缆台账统计"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "方式按类型统计报表"){
//				
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "方式趋势分析"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "设备趋势统计"){
//				
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "方式电路分析"){
//				
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "根告警趋势分析"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//				
//			}
//			else if(panelIcon.label == "返修件汇总报表"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "厂家库存统计"){
//				parentApplication.reportDoor.iFrame..moveIFrame();
//			}
//			else if(panelIcon.label == "备件中心库存统计"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "故障信息统计"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "故障趋势统计"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "检修统计"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "电源监控统计一"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
//			else if(panelIcon.label == "电源监控统计二"){
//				parentApplication.reportDoor.iFrame.moveIFrame();
//			}
		}
		private function panlClickHandler(event:MouseEvent):void{
			parentApplication.isShow = true;
			parentApplication.showMenu();
		}
		
		public function createContainerIcon():void
		{
			windowContainer.createPanelIcon(this);
		}
		
		public function positionChildren():void {
			if (showControls) {
				this.minimizeButton.buttonMode = true;
				this.minimizeButton.useHandCursor = true;
				this.minimizeButton.x = this.unscaledWidth - this.minimizeButton.width - 68;
				this.minimizeButton.y = 6;
				this.normalMaxButton.buttonMode    = true;
				this.normalMaxButton.useHandCursor = true;
				this.normalMaxButton.x = this.unscaledWidth - this.normalMaxButton.width - 44;
				this.normalMaxButton.y = 6;
				this.closeButton.buttonMode	   = true;
				this.closeButton.useHandCursor = true;
				this.closeButton.x = this.unscaledWidth - this.closeButton.width - 3;
				this.closeButton.y = 6;
			}
			
//			if (enableResize) {
//				//this.resizeHandler.y = this.unscaledHeight - resizeHandler.height - 1;
//				//this.resizeHandler.x = this.unscaledWidth - resizeHandler.width - 1;
//			}
		}		
		
		public function initPos():void {				
			this.oW = this.width;
			this.oH = this.height;
			this.oX = this.x;
			this.oY = this.y;	
		}
		
		public function restore():void
		{
			if (this.normalMaxButton.styleName == "increaseBtn") {
				setNormalSize();
			} else {
				this.width = parentApplication.workspace.width;
				this.height = parentApplication.workspace.height+70;
				this.x = 0;
				this.y = 0;
				this.setStyle("horizontalAlign","center");
				this.positionChildren();
				this.isMaximumed=true;
			}
			isMinimized = false;
		}

		public function normalMaxClickHandler(event:MouseEvent):void {
			if (this.normalMaxButton.styleName == "increaseBtn") {
				setMaxSize();
			} else {
				setNormalSize();
			}
		}
		
		public function setMaxSize():void
		{
			this.initPos();
			this.x = 0;
			this.y = 0;
			this.width = parentDocument.workspace.width;
			this.height = parentDocument.workspace.height + 70;
			this.normalMaxButton.styleName = "decreaseBtn";
			this.isMaximumed=true;
			this.positionChildren();
		}
		
		public function setNormalSize():void
		{
			this.x = this.oX;
			this.y = this.oY;
			this.width = this.oW;
			this.height = this.oH;
			this.normalMaxButton.styleName = "increaseBtn";
			this.isMaximumed=false;
			this.positionChildren();
		}
		
		public function minimizeClickHandler(event:MouseEvent):void
		{
			if(!isMaximumed)
				this.initPos();
			this.width = 0;
			this.height = 0;
			this.x = 0;
			this.y = screen.height;
			this.isMaximumed=false;
			this.isMinimized = true;
			/*var flag:Boolean = false;
			for(var i:int=0;i<parentApplication.windowContainer.mWindowContainer.getChildren().length;i++){
				if((PanelIcon)(parentApplication.windowContainer.mWindowContainer.getChildAt(i)).pnl.isMaximumed)
					flag = true;
			}*/
		}
		
		private function closeClickHandler(event:MouseEvent=null):void {
			if(panelIcon != null) windowContainer.closeWindow(panelIcon);
			this.parent.removeChild(this);
			if(panelIcon.label == "设备趋势统计"){
				parentApplication.reportDoor.iFrame.visible=false;
			}
			else if(panelIcon.label == "电源监控统计一"){
				parentApplication.reportDoor.iFrame.visible=false;
			}
			else if(panelIcon.label == "电源监控统计二"){
				parentApplication.reportDoor.iFrame.visible=false;
			}
		}

		public function closeWindow():void{
			if(panelIcon != null) windowContainer.closeWindow(panelIcon);
			this.parent.removeChild(this);
			if(panelIcon.label == "设备趋势统计"){
				parentApplication.reportDoor.iFrame.visible=false;
			}
			else if(panelIcon.label == "电源监控统计一"){
				parentApplication.reportDoor.iFrame.visible=false;
			}
			else if(panelIcon.label == "电源监控统计二"){
				parentApplication.reportDoor.iFrame.visible=false;
			}		
		}
		
		
		public function resizeOverHandler(event:MouseEvent):void {
//			this.resizeCur = CursorManager.setCursor(resizeCursor);
		}
		
		public function resizeOutHandler(event:MouseEvent):void {
			CursorManager.removeCursor(CursorManager.currentCursorID);
		}
		
		public function resizeDownHandler(event:MouseEvent):void {
			parentApplication.parent.addEventListener(MouseEvent.MOUSE_MOVE, resizeMoveHandler);
			parentApplication.parent.addEventListener(MouseEvent.MOUSE_UP, resizeUpHandler);
			//this.resizeHandler.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
//			this.resizeCur = CursorManager.setCursor(resizeCursor);
			this.oPoint.x = mouseX;
			this.oPoint.y = mouseY;
			this.oPoint = this.localToGlobal(oPoint);		
		}
		
		public function resizeMoveHandler(event:MouseEvent):void {
			this.stopDragging();
			var xPlus:Number = parentApplication.parent.mouseX - this.oPoint.x;			
			var yPlus:Number = parentApplication.parent.mouseY - this.oPoint.y;
			
			if(this.isMaximumed){
				this.oW=this.width;
				this.oH=this.height;
				this.isMaximumed=false;
			}
			
			if (this.oW + xPlus > 140) {
				this.width = this.oW + xPlus;
			}
			 
			if (this.oH + yPlus > 80) {
				this.height = this.oH + yPlus;
			} 
			this.normalMaxButton.styleName = "increaseBtn";
			
			this.positionChildren();
		}
		
		public function resizeUpHandler(event:MouseEvent):void {
			parentApplication.parent.removeEventListener(MouseEvent.MOUSE_MOVE, resizeMoveHandler);
			parentApplication.parent.removeEventListener(MouseEvent.MOUSE_UP, resizeUpHandler);
			CursorManager.removeCursor(CursorManager.currentCursorID);
			//this.resizeHandler.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
			this.initPos();
		}
		
		public function setPanelFocus():void{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
	}
}