package common.actionscript
{
	import flash.geom.Rectangle;
	import flash.utils.describeType;
	
	import mx.controls.Alert;
	import mx.controls.DateChooser;
	
	import twaver.Utils;
	
	public class AlarmImages
	{
		
		[Embed(source="./assets/images/toolbar/search.png")]
		public static const search:Class;
		[Embed(source="./assets/images/show.png")]
		public static const show:Class;	
		[Embed(source="./assets/images/hide.png")]
		public static const hide:Class;		
		
		[Embed(source="./assets/images/toolbar/select.png")]
		public static const select:Class;
		[Embed(source="./assets/images/toolbar/ascend.png")]
		public static const ascend:Class;
		[Embed(source="./assets/images/toolbar/descend.png")]
		public static const descend:Class;
		[Embed(source="./assets/images/toolbar/expand.png")]
		public static const expand:Class;
		[Embed(source="./assets/images/toolbar/collapse.png")]
		public static const collapse:Class;
		[Embed(source="./assets/images/toolbar/reset.png")]
		public static const reset:Class;	
		[Embed(source="./assets/images/toolbar/top.png")]
		public static const top:Class;
		[Embed(source="./assets/images/toolbar/up.png")]
		public static const up:Class;
		[Embed(source="./assets/images/toolbar/down.png")]
		public static const down:Class;		 
		[Embed(source="./assets/images/toolbar/bottom.png")]
		public static const bottom:Class;		
		
		[Embed(source="./assets/images/toolbar/zoomIn.png")]
		public static const zoomIn:Class;			
		[Embed(source="./assets/images/toolbar/zoomOut.png")]
		public static const zoomOut:Class;			
		[Embed(source="./assets/images/toolbar/zoomOverview.png")]
		public static const zoomOverview:Class;
		[Embed(source="./assets/images/toolbar/zoomReset.png")]
		public static const zoomReset:Class;
		[Embed(source="./assets/images/toolbar/magnify.png")]
		public static const magnify:Class;		
		[Embed(source="./assets/images/toolbar/print.png")]
		public static const print:Class;
		[Embed(source="./assets/images/toolbar/export.png")]
		public static const export:Class;		
		[Embed(source="./assets/images/toolbar/fullscreen.png")]
		public static const fullscreen:Class;
		
		public static function init():void{
			var classInfo:XML = describeType(AlarmImages);
			for each (var c:XML in classInfo..constant){
				var name:String = c.@name;
				Utils.registerImageByClass(name, AlarmImages[name]);
			}	
		}
		
		
	}
}