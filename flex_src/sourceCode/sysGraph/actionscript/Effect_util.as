package sourceCode.sysGraph.actionscript
{
	
	import twaver.IElement;
	import twaver.Element;
	import twaver.Node;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import twaver.Styles;
	import mx.controls.Alert;


	public class Effect_util
	{	
		public static const color_invalid:Number=0xCD0000;
		public static const color_checkable:Number=0x7CFC00;
		public static const color_incheck:Number=0x191970;	
		private var color_single_start:Number;
		private var color_single_end:Number;
		private var single_element:IElement;
		private var sprinkle_list:Array;
		private var sprinkle_color_list:Array;
		private var color_flag:int;
		private var color_list_flag:int;
		public function Effect_util()
		{
			
		}
		/**
		 * 
		 * @param flag 
		 * 	select_element:选中单个元素
		 *  sp_list: 闪烁元素列表
		 * 	color_list:number array，存储元素初始的16进制元素值
		 * 	可以单个与多个同时启用，想要同时启动多个同种特效需要new多个对象
		 * 闪烁效果
		 * 
		 */
		public function sprinkle_effect(singleflag:int,selected_element:IElement,start:Number,end:Number,listflag:int,sp_list:Array,color_list:Array):void{
			if(singleflag==1){
				single_element=selected_element;
				var color_Timer_single:Timer = new Timer(500, 5);
				color_flag=1;
				color_Timer_single.addEventListener("timer", timerHandler_single);
				color_single_start=start;
				color_single_end=end;
				//	Alert.show(color_single.toString());
				color_Timer_single.start();	
			}
			if(listflag==1){	
				sprinkle_list=sp_list;
				sprinkle_color_list=color_list;
				var color_Timer_list:Timer=new Timer(500,6);
				color_list_flag=1;
				color_Timer_list.addEventListener("timer", timerHandler_list);
				color_Timer_list.start();	
				//Alert.show("1111");
				//	Alert.show("123");
			}
			
		}
		
		private function timerHandler_single(event:TimerEvent):void {
			//var color1:Number=0x191970;
			if(color_flag==1){
				single_element.setStyle(Styles.INNER_COLOR,color_single_end);
			}
			else{
				single_element.setStyle(Styles.INNER_COLOR, color_single_start);
			}
			
			color_flag=color_flag*(-1);
		}
		
		
		
		
		private function timerHandler_list(event:TimerEvent):void {
			for (var temp:int=0;temp<sprinkle_list.length;temp++)
			{
				var ele:Element=sprinkle_list[temp];
				if(sprinkle_color_list.length>0){
					if(color_list_flag==1)
						ele.setStyle(Styles.INNER_COLOR, color_incheck);
					else
						ele.setStyle(Styles.INNER_COLOR,sprinkle_color_list[temp]);
				}
			}
			color_list_flag=color_list_flag*(-1);
		}
	}
}