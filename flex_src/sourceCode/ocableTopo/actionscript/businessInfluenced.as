import com.adobe.serialization.json.JSON;

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import mx.charts.ChartItem;
import mx.charts.events.ChartItemEvent;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.graphics.IFill;
import mx.graphics.SolidColor;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

//import sourceCode.channelRoute.views.ViewChannelroute;
import sourceCode.tableResurces.model.ResultModel;
//import sourceCode.tableResurces.Events.topolinkSearchEvent;

import twaver.SequenceItemRenderer;


[Bindable]			
private var cm:ContextMenu;
private var pageIndex:int=0;
private var pageSize:int=50;
private var pageIndexInf:int=0;
private var pageSizeInf:int=50;
private var pageIndexInt:int=0;
private var pageSizeInt:int=50;
private var datanumbers:int;
private var datanumbersInf:int;
private var datanumbersInt:int;
private var indexRenderer:Class = SequenceItemRenderer;
private var code:String = "";
private var type:String = "";
private var winTitle:String = "N-1分析";
private var tabDealing:String = "";

/* setParameters的参数含义
* type为equip, 从设备查看N-1
* type为port, 从端口查看N-1
* type为topolink, 从复用段查看N-1
* type为ocable, 从光缆查看N-1
*/
public function setParameters(code:String, type:String):void
{
	this.code = code;
	this.type = type;
}

private function init():void
{
	var cmi_view:ContextMenuItem = new ContextMenuItem("方式信息", true);				
	cmi_view.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, viewChanelRoute);
	cm = new ContextMenu();
	cm.hideBuiltInItems();
	
	cm.customItems.push(cmi_view);				
	cm.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelect);
	var rt:RemoteObject = new RemoteObject("ocableTopology");
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.callProCircuitAnalyse(type,code);
	rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
		if(event.result!=null&&event.result.toString()=="true"){
		getCarryOperaN1(code, type, 0, pageSize);			//全部业务
		getCarryOperaN1Inf(code, type, 0, pageSizeInf);	//影响业务
		getCarryOperaN1Int(code, type, 0, pageSizeInt);	//中断业务
		drawCharts(code, type);
		}else{
		Alert.show("'N-1'分析失败！","提示");
		}
	});
	serverPagingBar1.addEventListener("returnALL", showAllDataHandler);
	serverPagingBar1.addEventListener("exportExcel", exportExcellHandler);
	serverPagingBarInf.addEventListener("returnALL", showAllDataHandler);
	serverPagingBarInf.addEventListener("exportExcel", exportExcellHandler);
	serverPagingBarInt.addEventListener("returnALL", showAllDataHandler);
	serverPagingBarInt.addEventListener("exportExcel", exportExcellHandler);
}

private function getCarryOperaN1(code:String, type:String, start:int, end:int):void
{
	if(code == null || code == "")
	{
		Alert.show("未获取到正确的编码");
		return;
	}
	
	switch(type)
	{
		case "equip": getCarryOperaByEquipCode(code, start, end); break;  //1, 从设备查看N-1
		case "port": getCarryOperaByPort(code, start, end); break;  //2, 从端口查看N-1
		case "topolink": getCarryOperaByTopolink(code, start, end); break;  //3, 从复用段查看N-1
		case "ocable": getCarryOperaByOcable(code, start, end); break;  //4, 从光缆查看N-1
		case "pack": getCarryOperaByPack(code, start, end); break;  //5, 从机盘查看N-1
		default: Alert.show("未获取到正确的参数"); break;
	}
}

private function getCarryOperaN1Inf(code:String, type:String, start:int, end:int):void
{
	if(code == null || code == "")
	{
//		Alert.show("未获取到正确的编码");
		return;
	}
	
	switch(type)
	{
		case "equip": getCarryOperaByEquipCodeInf(code, start, end); break;  //1, 从设备查看N-1
		case "port": getCarryOperaByPortInf(code, start, end); break;  //2, 从端口查看N-1
		case "topolink": getCarryOperaByTopolinkInf(code, start, end); break;  //3, 从复用段查看N-1
		case "ocable": getCarryOperaByOcableInf(code, start, end); break;  //4, 从光缆查看N-1
		case "pack": getCarryOperaByPackInf(code, start, end); break;  //5, 从机盘查看N-1
	}
}

private function getCarryOperaN1Int(code:String, type:String, start:int, end:int):void
{
	if(code == null || code == "")
	{
//		Alert.show("未获取到正确的编码");
		return;
	}
	
	switch(type)
	{
		case "equip": getCarryOperaByEquipCodeInt(code, start, end); break;  //1, 从设备查看N-1
		case "port": getCarryOperaByPortInt(code, start, end); break;  //2, 从端口查看N-1
		case "topolink": getCarryOperaByTopolinkInt(code, start, end); break;  //3, 从复用段查看N-1
		case "ocable": getCarryOperaByOcableInt(code, start, end); break;  //4, 从光缆查看N-1
		case "pack": getCarryOperaByPackInt(code, start, end); break;  //5, 从机盘查看N-1
	}
}

private function showAllDataHandler(event:Event):void
{
	var flag : String = tabnavigator.getTabAt(tabnavigator.selectedIndex).label;
	
	if (flag == vbAll.label)
	{
		getCarryOperaN1(code, type, 0, datanumbers);
	}
	else if (flag == vbInf.label)
	{
		getCarryOperaN1Inf(code, type, 0, datanumbersInf);
	}
	else if (flag == vbInt.label)
	{
		getCarryOperaN1Int(code, type, 0, datanumbersInt);
	}
}

private function exportExcellHandler(event:Event):void
{
	var flag : String = tabnavigator.getTabAt(tabnavigator.selectedIndex).label;
	
	if (flag == vbAll.label)
	{
		var titles:Array=new Array("影响程度", "电路号", "速率", "业务类型", "业务名称", "起始端口", "终止端口");
		var remote:RemoteObject=new RemoteObject("ocableTopology");
		remote.endpoint=ModelLocator.END_POINT;
		remote.showBusyCursor=true;
		remote.OperaN1ExportEXCEL(code, type, winTitle, titles, flag);
		remote.addEventListener(ResultEvent.RESULT, ExportResultHandler);
	}
	else if (flag == vbInf.label)
	{
		var titles:Array=new Array("电路号", "速率", "业务类型", "业务名称", "起始端口", "终止端口");
		var remote:RemoteObject=new RemoteObject("ocableTopology");
		remote.endpoint=ModelLocator.END_POINT;
		remote.showBusyCursor=true;
		remote.OperaN1ExportEXCEL(code, type, winTitle, titles, flag);
		remote.addEventListener(ResultEvent.RESULT, ExportResultHandler);
	}
	else if (flag == vbInt.label)
	{
		var titles:Array=new Array("电路号", "速率", "业务类型", "业务名称", "起始端口", "终止端口");
		var remote:RemoteObject=new RemoteObject("ocableTopology");
		remote.endpoint=ModelLocator.END_POINT;
		remote.showBusyCursor=true;
		remote.OperaN1ExportEXCEL(code, type, winTitle, titles, flag);
		remote.addEventListener(ResultEvent.RESULT, ExportResultHandler);
	}
}

private function ExportResultHandler(event:ResultEvent):void
{
	
	var url:String=ModelLocator.getURL();
	var path:String=url + event.result.toString();
	
	
	var request:URLRequest=new URLRequest(encodeURI(path));
	navigateToURL(request, "_blank");
}

private function contextMenu_menuSelect(evt:ContextMenuEvent):void 
{	
	var flag : String = tabnavigator.getTabAt(tabnavigator.selectedIndex).label;
	
	if (flag =='全部业务')
		dgAll.selectedIndex = lastRollOverIndex;
	else if (flag =='影响业务')
		dgInf.selectedIndex = lastRollOverIndex; 
	else if (flag =='中断业务')
		dgInt.selectedIndex = lastRollOverIndex;  
}

private function viewChanelRoute(evt:ContextMenuEvent):void
{
	var flag : String = tabnavigator.getTabAt(tabnavigator.selectedIndex).label;
	var c_circuitcode:String = "";
	if (flag =='全部业务')
		c_circuitcode =dgAll.selectedItem.circuitcode;
	else if (flag =='影响业务')
		c_circuitcode =dgInf.selectedItem.circuitcode;
	else if (flag =='中断业务')
		c_circuitcode =dgInt.selectedItem.circuitcode;

	Registry.register("para_circuitcode",c_circuitcode);
	Application.application.openModel("方式信息", false);
}

private function drawCharts(code:String, type:String):void
{
	if(code == null || code == "")
	{
//		Alert.show("未获取到正确的编码");
		return;
	}
	
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaCharts); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
	
	switch(type)
	{
		case "equip": rtobj.getChartsDataByEquipN1(code); break;  
		case "port": rtobj.getChartsDataByPortN1(code); break;  
		case "topolink": rtobj.getChartsDataByTopolinkN1(code); break;   
		case "ocable": rtobj.getChartsDataByOcableN1(code); break;  
		case "pack": rtobj.getChartsDataByPackN1(code); break;  
	}
}

private function getCarryOperaByEquipCode(equipcode:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByEquipN1(equipcode, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaData); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByEquipCodeInf(equipcode:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByEquipN1Inf(equipcode, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaDataInf); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByEquipCodeInt(equipcode:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByEquipN1Int(equipcode, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaDataInt); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByTopolink(label:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByTopolinkN1(label, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaData); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByTopolinkInf(label:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByTopolinkN1Inf(label, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaDataInf); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByTopolinkInt(label:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByTopolinkN1Int(label, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaDataInt); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByPort(logicport:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByPortN1(logicport, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaData); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByPortInt(logicport:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByPortN1Int(logicport, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaDataInt); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByPortInf(logicport:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByPortN1Inf(logicport, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaDataInf); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByPack(packcode:String, start:int, end:int):void
{	
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByPackN1(packcode, start, end);//查询插槽信息
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaData); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByPackInf(packcode:String, start:int, end:int):void
{	
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByPackN1Inf(packcode, start, end);//查询插槽信息
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaDataInf); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}
public function getCarryOperaByPackInt(packcode:String, start:int, end:int):void
{	
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByPackN1Int(packcode, start, end);//查询插槽信息
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaDataInt); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByOcable(ocablecode:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByOcableN1(ocablecode, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaData); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByOcableInt(ocablecode:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByOcableN1Int(ocablecode, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaDataInt); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

public function getCarryOperaByOcableInf(ocablecode:String, start:int, end:int):void
{
	var rtobj:RemoteObject = new RemoteObject("ocableTopology");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.getCarryOperaByOcableN1Inf(ocablecode, start, end);
	rtobj.addEventListener(ResultEvent.RESULT, generateCarryOperaDataInf); 
	rtobj.addEventListener(FaultEvent.FAULT,faultGetOpera);
}

private function generateCarryOperaCharts(event:ResultEvent):void 
{
	var XMLData:XML = new XML(event.result.toString());		
	var usernames:Array = new Array();
	var transrates:Array = new Array();
	var usernamesInf:Array = new Array();
	var transratesInf:Array = new Array();
	var usernamesInt:Array = new Array();
	var transratesInt:Array = new Array();
	var transratesOrder:Array = ["64Kb/s", "2Mb/s", "155Mb/s", "622Mb/s", "2.5Gb/s", "无类型"];
	
	for each(var arrxml:XML in XMLData.children())
	{		
		var username:String = arrxml.@username;
		var transrate:String = arrxml.@transrate;
		var inflevel:String = arrxml.@inflevel;
		
		if(username == null || username == "")
			username = "无类型";
		if(transrate == null || transrate == "")
			transrate = "无类型";
		
		for (var i:int = 0; i < usernames.length; i++)
		{
			if(usernames[i][0] == username)
			{
				usernames[i][1]++;
				break;
			}	
		}
		if(i == usernames.length)
			usernames.push([username, 1]);
		
		for (var i:int = 0; i < transrates.length; i++)
		{
			if(transrates[i][0] == transrate)
			{
				transrates[i][1]++;
				break;
			}	
		}
		if(i == transrates.length)
			transrates.push([transrate, 1]);
		
		if (inflevel == "影响")
		{
			for (var i:int = 0; i < usernamesInf.length; i++)
			{
				if(usernamesInf[i][0] == username)
				{
					usernamesInf[i][1]++;
					break;
				}	
			}
			if(i == usernamesInf.length)
				usernamesInf.push([username, 1]);
			
			for (var i:int = 0; i < transratesInf.length; i++)
			{
				if(transratesInf[i][0] == transrate)
				{
					transratesInf[i][1]++;
					break;
				}	
			}
			if(i == transratesInf.length)
				transratesInf.push([transrate, 1]);
		}
		else if (inflevel == "中断")
		{
			for (var i:int = 0; i < usernamesInt.length; i++)
			{
				if(usernamesInt[i][0] == username)
				{
					usernamesInt[i][1]++;
					break;
				}	
			}
			if(i == usernamesInt.length)
				usernamesInt.push([username, 1]);
			
			for (var i:int = 0; i < transratesInt.length; i++)
			{
				if(transratesInt[i][0] == transrate)
				{
					transratesInt[i][1]++;
					break;
				}	
			}
			if(i == transratesInt.length)
				transratesInt.push([transrate, 1]);
		}
	}
	
	// 绘制全部业务统计图
	if (usernames.length > 0)
	{
		var strPieChartData:String = "[";
		var arrPieChartData:Array;
		
		for (var i:int = 0; i < usernames.length; i++)
		{
			strPieChartData += "{";
			strPieChartData += "\"name\":\"" + usernames[i][0] + "\"";
			strPieChartData += ",";
			strPieChartData += "\"value\":\"" + usernames[i][1] + "\"";        
			strPieChartData += "},";
		}
		strPieChartData = strPieChartData.substr(0, strPieChartData.length - 1);
		strPieChartData += "]";
		arrPieChartData = JSON.decode(strPieChartData) as Array;
		this.pieChart.dataProvider = arrPieChartData;
	}
	else 
	{
		this.pieChart.visible=false;
		this.pieChart.dataProvider=null;
		pie_nodata.visible=true;
	}
	
	if (transrates.length > 0)
	{
		var strBarChartData:String = "[";
		var arrBarChartData:Array;
		
		for (var j:int = 0; j < transratesOrder.length; j++)
		{
			for (var i:int = 0; i < transrates.length; i++)
			{
				if (transratesOrder[j] == transrates[i][0])
				{
					strBarChartData += "{";
					strBarChartData += "\"name\":\"" + transrates[i][0] + "\"";
					strBarChartData += ",";
					strBarChartData += "\"value\":\"" + transrates[i][1] + "\"";        
					strBarChartData += "},";
					
					break;
				}
			}
		}
		
		strBarChartData = strBarChartData.substr(0, strBarChartData.length - 1);
		strBarChartData += "]";
		arrBarChartData = JSON.decode(strBarChartData) as Array;
		this.columnChart.dataProvider = arrBarChartData;
	}
	else 
	{
		this.columnChart.visible=false;
		this.columnChart.dataProvider=null;
		column_nodata.visible=true;
	}
	
	// 绘制影响业务统计图
	if (usernamesInf.length > 0)
	{
		var strPieChartData:String = "[";
		var arrPieChartData:Array;
		
		for (var i:int = 0; i < usernamesInf.length; i++)
		{
			strPieChartData += "{";
			strPieChartData += "\"name\":\"" + usernamesInf[i][0] + "\"";
			strPieChartData += ",";
			strPieChartData += "\"value\":\"" + usernamesInf[i][1] + "\"";        
			strPieChartData += "},";
		}
		strPieChartData = strPieChartData.substr(0, strPieChartData.length - 1);
		strPieChartData += "]";
		arrPieChartData = JSON.decode(strPieChartData) as Array;
		this.pieChartInf.dataProvider = arrPieChartData;
	}
	else 
	{
		this.pieChartInf.visible=false;
		this.pieChartInf.dataProvider=null;
		pie_nodatainf.visible=true;
	}
	
	if (transratesInf.length > 0)
	{
		var strBarChartData:String = "[";
		var arrBarChartData:Array;
		
		for (var j:int = 0; j < transratesOrder.length; j++)
		{
			for (var i:int = 0; i < transratesInf.length; i++)
			{
				if (transratesOrder[j] == transratesInf[i][0])
				{
					strBarChartData += "{";
					strBarChartData += "\"name\":\"" + transratesInf[i][0] + "\"";
					strBarChartData += ",";
					strBarChartData += "\"value\":\"" + transratesInf[i][1] + "\"";        
					strBarChartData += "},";
					
					break;
				}
			}
		}
		
		strBarChartData = strBarChartData.substr(0, strBarChartData.length - 1);
		strBarChartData += "]";
		arrBarChartData = JSON.decode(strBarChartData) as Array;
		this.columnChartInf.dataProvider = arrBarChartData;
	}
	else 
	{
		this.columnChartInf.visible=false;
		this.columnChartInf.dataProvider=null;
		column_nodatainf.visible=true;
	}
	
	// 绘制中断业务统计图
	if (usernamesInt.length > 0)
	{
		var strPieChartData:String = "[";
		var arrPieChartData:Array;
		
		for (var i:int = 0; i < usernamesInt.length; i++)
		{
			strPieChartData += "{";
			strPieChartData += "\"name\":\"" + usernamesInt[i][0] + "\"";
			strPieChartData += ",";
			strPieChartData += "\"value\":\"" + usernamesInt[i][1] + "\"";        
			strPieChartData += "},";
		}
		strPieChartData = strPieChartData.substr(0, strPieChartData.length - 1);
		strPieChartData += "]";
		arrPieChartData = JSON.decode(strPieChartData) as Array;
		this.pieChartInt.dataProvider = arrPieChartData;
	}
	else 
	{
		this.pieChartInt.visible=false;
		this.pieChartInt.dataProvider=null;
		pie_nodataint.visible=true;
	}
	
	if (transratesInt.length > 0)
	{
		var strBarChartData:String = "[";
		var arrBarChartData:Array;
		
		for (var j:int = 0; j < transratesOrder.length; j++)
		{
			for (var i:int = 0; i < transratesInt.length; i++)
			{
				if (transratesOrder[j] == transratesInt[i][0])
				{
					strBarChartData += "{";
					strBarChartData += "\"name\":\"" + transratesInt[i][0] + "\"";
					strBarChartData += ",";
					strBarChartData += "\"value\":\"" + transratesInt[i][1] + "\"";        
					strBarChartData += "},";
					
					break;
				}
			}
		}
		
		strBarChartData = strBarChartData.substr(0, strBarChartData.length - 1);
		strBarChartData += "]";
		arrBarChartData = JSON.decode(strBarChartData) as Array;
		this.columnChartInt.dataProvider = arrBarChartData;
	}
	else 
	{
		this.columnChartInt.visible=false;
		this.columnChartInt.dataProvider=null;
		column_nodataint.visible=true;
	}
}

private function generateCarryOperaData(event:ResultEvent):void
{
	var result:ResultModel = event.result as ResultModel;
	
	this.datanumbers = result.totalCount;
	onResultAll(result);	
}

private function generateCarryOperaDataInf(event:ResultEvent):void
{
	var result:ResultModel = event.result as ResultModel;
	
	this.datanumbersInf = result.totalCount;
	onResultInf(result);	
}

private function generateCarryOperaDataInt(event:ResultEvent):void
{
	var result:ResultModel = event.result as ResultModel;
	
	this.datanumbersInt = result.totalCount;
	onResultInt(result);	
}

public function onResultAll(result:ResultModel):void
{
		serverPagingBar1.orgData = result.orderList;
		serverPagingBar1.totalRecord = result.totalCount;
		serverPagingBar1.dataBind(true);
}


public function onResultInf(result:ResultModel):void
{
		serverPagingBarInf.orgData = result.orderList;
		serverPagingBarInf.totalRecord = result.totalCount;
		serverPagingBarInf.dataBind(true);
}


public function onResultInt(result:ResultModel):void
{
		serverPagingBarInt.orgData = result.orderList;
		serverPagingBarInt.totalRecord = result.totalCount;
		serverPagingBarInt.dataBind(true);
}

private function faultGetOpera(event:FaultEvent):void
{
	Alert.show("获取业务信息失败！","提示");
	
}

private function close():void  
{  
	PopUpManager.removePopUp(this);  
} 

private function explode(event:ChartItemEvent):void
{
	var array:Array=new Array();
	var flag : String = tabnavigator.getTabAt(tabnavigator.selectedIndex).label;
	
	if (flag == vbAll.label)
	{
		array[pieSeries.selectedIndex]=0.2;
		pieSeries.perWedgeExplodeRadius=array;
	}
	else if (flag == vbInf.label)
	{
		array[pieSeriesInf.selectedIndex]=0.2;
		pieSeriesInf.perWedgeExplodeRadius=array;
	}
	else if (flag == vbInt.label)
	{
		array[pieSeriesInt.selectedIndex]=0.2;
		pieSeriesInt.perWedgeExplodeRadius=array;
	}
}

private function pagingFunction(pageIndex:int, pageSize:int):void
{
	getCarryOperaN1(this.code, this.type, (pageIndex * pageSize), (pageIndex * pageSize + pageSize));
}

private function pagingFunctionInf(pageIndexInf:int, pageSizeInf:int):void
{
	getCarryOperaN1Inf(this.code, this.type, (pageIndexInf * pageSizeInf), (pageIndexInf * pageSizeInf + pageSizeInf));
}

private function pagingFunctionInt(pageIndexInt:int, pageSizeInt:int):void
{
	getCarryOperaN1Int(this.code, this.type, (pageIndexInt * pageSizeInt), (pageIndexInt * pageSizeInt + pageSizeInt));
}
