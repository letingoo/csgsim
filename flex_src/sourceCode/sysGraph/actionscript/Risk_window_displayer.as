package sourceCode.sysGraph.actionscript
{
	import common.actionscript.MyPopupManager;
	
	import flash.display.DisplayObject;
	
	import mx.managers.PopUpManager;
	
	import sourceCode.sysGraph.views.troubleshoot_window;

	/**
	 * 
	 * @author yzl
	 *  全网风险预警信息查看
	 * 
	 */
	public class Risk_window_displayer
	{
		private static const Risk_check:int=1;
		private static const Risk_estimate:int=2;
		public function Risk_window_displayer(type:int,PRI_old:Number,PRI_new:Number,log_old:Array,log_new:Array,risk_estimate_list:Array,parent_window:DisplayObject)
		{
			var trouble:troubleshoot_window=new troubleshoot_window(); 
			//trouble.stp=route_log_new;
			trouble.PRI_old=PRI_old;
			trouble.PRI_new=PRI_new;
			trouble.spec_old=log_old;
			trouble.spec_new=log_new;
			trouble.risk_report_list=risk_estimate_list;
			switch(type){
				case  Risk_estimate:{
					trouble.title="业务风险评估信息查看";
					trouble.estimate_flag=1;
					break;
				}
				case  Risk_check:{
					trouble.title="全网风险预警信息查看";
					trouble.check_flag=1;
					break;
				}
					
			}
			
			PopUpManager.addPopUp(trouble,parent_window); 
			PopUpManager.centerPopUp(trouble); 
		}
	}
}