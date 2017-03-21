// ActionScript file
import com.mechan.MecGrid.mecGridClasses.*;
import com.mechan.MecGrid.mecGridClasses.CellOp;
import com.mechan.export.MecExporter;

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.core.ClassFactory;
import mx.events.DataGridEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.*;

import sourceCode.indexEvaluation.model.IndexEvaluation;
import sourceCode.indexEvaluation.model.ResultModel;
import sourceCode.indexEvaluation.views.ShowCalculate;
import sourceCode.tableResurces.views.FileExportFirstStep;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var deptLst:XMLList;
[Bindable] public var dataLst:ArrayCollection;

public var indexModel:IndexEvaluation = new IndexEvaluation();
public var newstrs:String="";



public function init():void{
	
	var rtReport1:RemoteObject = new RemoteObject("indexEvaluation");
	rtReport1.showBusyCursor = true;
	rtReport1.endpoint = ModelLocator.END_POINT;
	rtReport1.addEventListener(ResultEvent.RESULT,getDataResult);
	Application.application.faultEventHandler(rtReport1);
	rtReport1.getQualityEvaluationData(indexModel);
}

public function myProject_changeHandler(event:String):void
{
//	Alert.show("---"+event);
	newstrs = event;
	Alert.show("---"+newstrs);
}

private function editHandle(event:DataGridEvent):void{  
	if(event.dataField=="score"){  
//		Alert.show("---");
		var cols:DataGridColumn=dg.columns[event.columnIndex];  
		var id:String=event.itemRenderer.data.id;  
		var name:String=event.itemRenderer.data.name;
		var first_level:String = event.itemRenderer.data.first_level;
		//编辑后新的值  
		var newValue:String=dg.itemEditorInstance[cols.editorDataField];
//		var newValue:String=newstrs;
//		newstrs="";//还原
//		var num:int=new int(newValue); 
//		Alert.show("---"+newValue);
		var pattern:RegExp=new RegExp("^[1-9]{1}$");
		if(!pattern.test(newValue)){ 
			event.preventDefault();//恢复本来数据
			tipShow.text = "得分值只能是1到9之间的整数值！";
		}
		else{  
			tipShow.text = "";
			var rtReport1:RemoteObject = new RemoteObject("indexEvaluation");
			rtReport1.showBusyCursor = true;
			rtReport1.endpoint = ModelLocator.END_POINT;
			rtReport1.addEventListener(ResultEvent.RESULT,setDataResult);
			Application.application.faultEventHandler(rtReport1);
			rtReport1.setQualityEvaluationData(id,first_level,name,newValue);
			/*=======操作数据和数据库打交道=========*/  
		}  
	}
}

private function setDataResult(event:ResultEvent):void
{
	calculateWeight();
}




private function getDataResult(event:ResultEvent):void{
	var arr:ArrayCollection = event.result as ArrayCollection;
	dataLst = event.result as ArrayCollection;

}



//计算权重
private function calculateWeight():void{
	var re:RemoteObject = new RemoteObject("indexEvaluation");
	re.showBusyCursor = true;
	re.endpoint = ModelLocator.END_POINT;
	re.addEventListener(ResultEvent.RESULT,calculateWeightResult);
	Application.application.faultEventHandler(re);
	re.calculateWeight();
}

private function calculateWeightResult(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	dataLst = result.orderList;
	txtFormula.text = String("电力通信网风险指标评估值=通信网络运行质量指标值V1*权重W1+通信网络运维质量指标V2*权重W2+业务支撑度指标V3*权重W3= "+result.score);
}

/**
 * 显示计算过程
 * 
 */ 
private function showCalculate(event:MouseEvent):void{
	var showCalculate:ShowCalculate = new ShowCalculate();
	PopUpManager.addPopUp(showCalculate,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(showCalculate);
	showCalculate.title="计算过程示例";
}


/**
 * 
 * 导出
 * 
 * */
protected function saveAsExcel():void
{
	
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	fefs.dataNumber = dataLst.length;	
	indexModel.end = dataLst.length.toString();				
	fefs.titles = new Array("序号","准则层名","网络名称","指标类别","指标名称","自愈值","得分值","权重值");				
	fefs.exportTypes = "电力通信网风险指标评估";
	fefs.labels = "电力通信网风险指标评估列表";
	fefs.selectItem = dataLst;
	MyPopupManager.addPopUp(fefs, this);
}
