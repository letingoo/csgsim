package sourceCode.rootalarm.actionscript
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	import common.actionscript.ModelLocator;
	public class RootAlarmMgrCombox
	{
		private var combox:ComboBox=null;
		
		private var param:ArrayCollection= new ArrayCollection();
		
		private var rtobj:RemoteObject;
		
		private var defaultValue:String="";
		
		public function setCombox(combox:ComboBox,xtype:String,dValue:String):void
		{
			this.combox=combox;
			
			defaultValue=dValue;
			
			rtobj= new RemoteObject("RootAlarmMgrDwr");
			rtobj.endpoint = ModelLocator.END_POINT;
			rtobj.showBusyCursor = true;
			rtobj.getComboxData(xtype);
			rtobj.addEventListener(ResultEvent.RESULT,setComboxValue);
			
		}
		
		private function setComboxValue(event:ResultEvent):void
		{
			
			if(event.result==null){
				Alert.show('获取数据失败'); return;
			}
			
			param.removeAll();
			var ts:ArrayCollection = new ArrayCollection();
			ts=event.result as ArrayCollection;
			param.addItem({label:"请选择",code:""});
			for each(var a : Object in ts){
				param.addItem({label:a.XTXX,code:a.XTBM});
			}
			combox.dataProvider=param;
			if (defaultValue==null && defaultValue==""){
				combox.selectedIndex=0;
				
			}
			else{
				setSelectItem(combox,defaultValue);
				rtobj.removeEventListener(ResultEvent.RESULT,setComboxValue);
			}
		}
		
		public function setSelectItem(combox:ComboBox,code:String):void
		{
			for(var i:int = 0;i<param.length;i++)
			{ 
				if(param[i].code==code)
				{
					combox.selectedIndex = i;
					break;
				}
			}  
			
		}
	}
}