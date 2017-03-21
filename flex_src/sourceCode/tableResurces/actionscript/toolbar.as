// ActionScript file
import common.actionscript.ModelLocator;

import mx.events.ItemClickEvent;

import sourceCode.tableResurces.Events.ToopEvent;

protected function toolbar_itemClickHandler(event:ItemClickEvent):void
{
	switch(event.label){
		case "添加":
			dispatchEvent(new ToopEvent("toolEventAdd"));
			break;
		case "修改":
			dispatchEvent(new ToopEvent("toolEventEdit"));
			break;
		case "删除":
			dispatchEvent(new ToopEvent("toolEventDelete"));
			break;
		case "查询":
			dispatchEvent(new ToopEvent("toolEventSearch"));
			break;
		case "导出Excel":
			dispatchEvent(new ToopEvent("toolEventEmpExcel"));
			break;
		case "导入数据":
			dispatchEvent(new ToopEvent("toolEventImpExcel"));
			break;
		case "添加快捷方式":
			dispatchEvent(new ToopEvent("toolEventAddShortcut"));
			break;
		case "删除快捷方式":
			dispatchEvent(new ToopEvent("toolEventDelShortcut"));
			break;
		default:
			break;
	}
	
	
}