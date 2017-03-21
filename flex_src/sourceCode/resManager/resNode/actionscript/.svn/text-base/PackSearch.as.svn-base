// ActionScript file
import sourceCode.resManager.resNode.Events.PackSearchEvent;
import sourceCode.resManager.resNode.model.Pack;
import common.actionscript.MyPopupManager;
import mx.managers.PopUpManager;
import sourceCode.resManager.resNode.Titles.SearchEquipTitle;//新加的byxujiao


public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	
/**
 *重置 
 * @param event
 * 
 */
protected function button1_clickHandler(event:MouseEvent):void
{
	cmbEquipment.text="";
	txtEquipframe.text="";
	txtEquipslot.text="";
	txtEquippack.text="";
	txtPackmodel.text="";
	dfstartUpdateDate.text = "";
	dfendUpdateDate.text = "";
	
}

/**
 *查询操作 
 * @param event
 * 
 */
protected function searchClickHandler(event:MouseEvent):void
{
	var pack:Pack = new Pack();
	pack.equipname=cmbEquipment.text;
	pack.frameserial = txtEquipframe.text;
	pack.slotserial= txtEquipslot.text;
	pack.packserial = txtEquippack.text;
	pack.packmodel = txtPackmodel.text;
	pack.updatedate_start = dfstartUpdateDate.text;
	pack.updatedate_end = dfendUpdateDate.text;
	
	this.dispatchEvent(new PackSearchEvent("packSearchEvent",pack));
	MyPopupManager.removePopUp(this);
}

/**
 *点击选择设备弹出的框 ，可进行模糊查询
 * @param event
 * 
 */
private function eqsearchHandler(event:MouseEvent):void{ /*,flag:String*/
	var packeqsearch:SearchEquipTitle=new SearchEquipTitle();
	packeqsearch.page_parent=this;
	/*if(flag=="packeqsearch"){
		packeqsearch.flog=true;
	}*/
	PopUpManager.addPopUp(packeqsearch,this,true);
	PopUpManager.centerPopUp(packeqsearch);
	
}