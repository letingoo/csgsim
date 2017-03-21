// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.Registry;
import common.component.SI_Follower.Slot_Follower;
import common.component.SI_Follower.VC12_Follower;

import mx.collections.ArrayCollection;
import mx.core.Application;
import mx.rpc.events.ResultEvent;

import org.flexunit.runner.Result;

import twaver.Consts;
import twaver.DemoUtils;
import twaver.Element;
import twaver.Follower;
import twaver.Grid;
import twaver.ICollection;
import twaver.IElement;
import twaver.SelectionModel;
import twaver.Styles;
import twaver.Utils;

[Embed(source="assets/images/equipPack/bg_list.png")]
private static const bg_list:Class;
[Embed(source="assets/images/slotgraph/vc4_selected.png")]
private var vc4_selected:Class;
[Embed(source="assets/images/slotgraph/vc4_unselected.png")]
private var vc4_unselected:Class;
[Embed(source="assets/images/slotgraph/vc12_CC.png")]
private var vc12_CC:Class;
[Embed(source="assets/images/slotgraph/vc12_unCC.png")]
private var vc12_unCC:Class;
[Embed(source="assets/images/slotgraph/vc4_CC.png")]
private var vc4_CC:Class;
[Embed(source="assets/images/slotgraph/vc4_unCC.png")]
private var vc4_unCC:Class;


[bindable]
/**
 *复用段名称 
 */
public var SlotName:String = "";
/**
 *复用段id 
 */
public var topolinkid:String = "";
/**
 *时隙个数 
 */
public var size:int;

private var myruleCount:int=0;
/**
 *保存左侧vc4列表中上一次选中的元素 
 */
private var preSelected:Slot_Follower;
private var scoll:Number=0;
private function init():void
{
	Application.application.faultEventHandler(rt);	
	Utils.registerImageByClass("bg_list",bg_list);
	Utils.registerImageByClass("vc4_selected",vc4_selected);
	Utils.registerImageByClass("vc4_unselected",vc4_unselected);
	Utils.registerImageByClass("vc12_CC",vc12_CC);
	Utils.registerImageByClass("vc12_unCC",vc12_unCC);
	Utils.registerImageByClass("vc4_CC",vc4_CC);
	Utils.registerImageByClass("vc4_unCC",vc4_unCC);
	
	network.elementBox.setStyle(Styles.BACKGROUND_TYPE,Consts.BACKGROUND_TYPE_IMAGE);
	network.elementBox.setStyle(Styles.BACKGROUND_IMAGE_STRETCH,Consts.STRETCH_FILL);
	network.elementBox.setStyle(Styles.BACKGROUND_IMAGE,"bg_list");
	network.elementBox.layerBox.defaultLayer.movable=false;
	network.selectionModel.selectionMode=SelectionModel.SINGLE_SELECTION;
	network.selectionModel.filterFunction=function (data:Element):Boolean{
		if(data is Follower)
		{
			return true;
		}
		else{
			return false;
		}
	}
	
	rt.addEventListener(ResultEvent.RESULT,get_vc4_list);
	rt.getRoot(topolinkid,size);
	
	
	sub_network.elementBox.layerBox.defaultLayer.movable=false;
	sub_network.selectionModel.selectionMode=SelectionModel.SINGLE_SELECTION;
	sub_network_contextMenu();
	
}

private function sub_network_contextMenu():void{
	sub_network.contextMenu = new ContextMenu();
	sub_network.contextMenu.hideBuiltInItems();
	sub_network.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
		
		var p:Point = new Point(e.mouseTarget.mouseX / sub_network.zoom, e.mouseTarget.mouseY / sub_network.zoom);
		var datas:ICollection = sub_network.getElementsByLocalPoint(p);
		if (datas.count > 0) 
		{
			sub_network.selectionModel.setSelection(datas.getItemAt(0));
		}
		else
		{
			sub_network.selectionModel.clearSelection();
		}	
		//定制右键菜单
		var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		
		if(sub_network.selectionModel.count == 0){//选中元素个数
			sub_network.contextMenu.customItems = [flexVersion,playerVersion];
		}
		else{
			if(sub_network.elementBox.selectionModel.lastData is VC12_Follower 
				&& sub_network.elementBox.selectionModel.lastData.getClient("YEWU")!="无")
			{
				var item1 : ContextMenuItem = new ContextMenuItem("方式信息",true);
				item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, getCC);
				sub_network.contextMenu.customItems=[item1];
			}else
			{
				sub_network.contextMenu.customItems = [flexVersion,playerVersion];
			}
		}
	});	
}

private function get_vc4_list(e:ResultEvent):void{
	rt.removeEventListener(ResultEvent.RESULT,get_vc4_list);
	var array:ArrayCollection=e.result as ArrayCollection; 
	var vc4Count:int=array.length;
	var grid:Grid=new Grid();
	grid.width=network.width;
	grid.height=vc4Count*40;
	grid.setStyle(Styles.GRID_ROW_COUNT,vc4Count);
	grid.setStyle(Styles.GRID_COLUMN_COUNT,1);
	grid.setStyle(Styles.GRID_BORDER,0);
	grid.setStyle(Styles.GRID_PADDING,0);
	grid.setLocation(0,0);
	network.elementBox.add(grid);
	for(var i:int=0;i<vc4Count;i++)
	{
		
		var f:Slot_Follower=new Slot_Follower();
		f.setStyle(Styles.LABEL_POSITION,Consts.POSITION_CENTER);
		f.setStyle(Styles.LABEL_XOFFSET,-40);
		f.setStyle(Styles.LABEL_COLOR,0xFFFFFF);
		f.setStyle(Styles.LABEL_SIZE,14);
		f.setStyle(Styles.FOLLOWER_ROW_INDEX,i);
		f.setStyle(Styles.FOLLOWER_COLUMN_INDEX,0);
		f.host=grid;
		f.image="vc4_unselected";
		f.name="VC4-"+(i+1).toString();
		f.setClient("innerid",i+1);
		f.setClient("rate",array[i].GETUSEINFOBYPORT);
		f.setClient("child_vc",array[i].GETVCBYPORT);
		var circuit:String=array[i].GETCIRCUITBYPORT;
		if(circuit!=null)
		{
			circuit=circuit.substr(0,circuit.length-1);
		}
//		f.toolTip=circuit;
		network.elementBox.add(f);
		if(i==0)
		{
			network.selectionModel.setSelection(f);
			showVC();
		}
	}
}

private function showVC():void
{
	for(;myruleCount>0;myruleCount--)
	{
		sub_network.removeChild(sub_network.getChildByName("myrule"+(myruleCount-1).toString()));
	}
	sub_network.elementBox.clear();
	
	if(preSelected!=null){
		preSelected.image="vc4_unselected";
	}
	preSelected=network.selectionModel.lastData as Slot_Follower;
	sub_title.text=preSelected.name+"承载业务";
	preSelected.image="vc4_selected";
	var child_vc:String=(network.selectionModel.lastData as Slot_Follower).getClient("child_vc").toString();
	if(child_vc=="VC4"){
		showVC4();
	}else if(child_vc=="VC12"){
		showVC12();
	}
}

/**
 *按vc4呈现时隙分布图 
 * 
 */
private function showVC4():void{
	var f:VC12_Follower=new VC12_Follower();
	f.setLocation(50,10);
	f.setSize(44,44);
	f.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
	f.setStyle(Styles.LABEL_POSITION,Consts.POSITION_BOTTOM_TOP);
	f.setStyle(Styles.LABEL_SIZE,16);
	f.setStyle(Styles.LABEL_YOFFSET,-3);
	f.setStyle(Styles.LABEL_BOLD,true);
	f.name="";
	var yw:String=(network.selectionModel.lastData as Slot_Follower).toolTip;
	if(yw!=null&&yw!="")//存在承载业务
	{
		f.setClient("YEWU",yw);
		f.image="vc4_CC";
	}
	else
	{
		f.setClient("YEWU","无");
		f.image="vc4_unCC";
	}
	
	sub_network.elementBox.add(f);
}
/**
 *当vc4被打散，则以vc12方式呈现 
 * 
 */
private function showVC12():void{
	var inner_id:int=network.selectionModel.lastData.getClient("innerid");
	if(network.selectionModel.lastData.getClient("rate")=="0.00%")
	{
		
	}
	else
	{
		rt.addEventListener(ResultEvent.RESULT,getSlot); 
		rt.getSlot(topolinkid,inner_id);//获取当前vc4下的vc12的各自的业务
	}
}

private var ac:ArrayCollection = new ArrayCollection();

private function getSlot(event:ResultEvent):void{
	rt.removeEventListener(ResultEvent.RESULT,getSlot);
	var array:ArrayCollection=event.result as ArrayCollection;
	var count:int=array.length;	
	var cols:int=sub_network.width/245;
	var rows:int=count/cols+1;
	for(var i:int=0;i<rows;i++)
	{
		for(var j:int=0;j<cols;j++)
		{
			var m:int=i*cols+j;
			if(m>=count)
			{
				break;
			}
			var slot:int = array[m].NUM;
			var timeslot:String = ModelLocator.timeslotTo373(slot);
			if(timeslot!=null&&timeslot!=""&&timeslot.indexOf(".")!=-1)
			{
				timeslot = timeslot.split(".")[1];
			}
			var yw:String=array[m].YEWU;//业务名称
			var f:VC12_Follower=new VC12_Follower();
			f.setLocation(50+245*j,10+64*i);
			f.setSize(44,44);
			f.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
			f.setStyle(Styles.LABEL_POSITION,Consts.POSITION_BOTTOM_TOP);
			f.setStyle(Styles.LABEL_SIZE,16);
			f.setStyle(Styles.LABEL_YOFFSET,-3);
			f.setStyle(Styles.LABEL_BOLD,true);
			f.name=timeslot.charAt(0)+"-"+timeslot.charAt(1)+"-"+timeslot.charAt(2);
			f.toolTip = "";
			
			if(yw!=null&&yw!=""){
				f.setClient("YEWU",yw.substr(0,yw.length-1));
				f.image="vc12_CC";
				ac.addItem(f.id +"@@"+yw.substr(0,yw.length-1));
			}else{
				f.setClient("YEWU","无");
				f.image="vc12_unCC";
			}
			
			sub_network.elementBox.add(f);
		}
		var rule:HRule=new HRule();
		rule.name="myrule"+i.toString();
		rule.setStyle("alpha",0.5);
		rule.percentWidth=100;
		rule.y=(i+1)*64;
		myruleCount++;
		sub_network.addChild(rule);
		
	}

	rt.addEventListener(ResultEvent.RESULT,getTooltip);
	rt.getUsernamesByCircuitcodes(ac);
}

private function getTooltip(event:ResultEvent):void{
	rt.removeEventListener(ResultEvent.RESULT,getTooltip);
	if(event.result){
		var ac2:ArrayCollection = event.result as ArrayCollection;
		for(var i:int=0;i<ac2.length;i++){
			var s:String = ac2.getItemAt(i).toString();
			var id:String = s.split("@@")[0];
			var tooltip:String = s.split("@@")[1];
			var ele:IElement = sub_network.elementBox.getElementByID(id);
			if(ele is Follower){
				ele.toolTip = tooltip;
			}
		}
	}
}


private function getCC(event:Event=null):void{
	
	if(sub_network.selectionModel.count>0){
		if(sub_network.selectionModel.lastData.getClient("YEWU")!=null&&sub_network.selectionModel.lastData.getClient("YEWU")!='无'){
			var rtobj1:RemoteObject=new RemoteObject("fiberWire");
			rtobj1.endpoint=ModelLocator.END_POINT;
			rtobj1.showBusyCursor=true;
			var str:String=sub_network.selectionModel.lastData.getClient("YEWU");
			rtobj1.getTypeBycircuitCode(str);
			rtobj1.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
			{
				if(event.result){
					Registry.register("para_circuitcode", str);
					Registry.register("para_circuitype", event.result.toString());
					Application.application.openModel("方式信息", false);
					
				}
			});
		}
	}
}

private function move_below():void{
	if(scoll<network.maxVerticalScrollPosition){
		scoll+=100;
		network.verticalScrollPosition=scoll;
		btn1.enabled=true;
	}else{
		btn2.enabled=false;
	}
}
private function move_above():void{
	
	if(scoll>0){
		scoll-=100;
		network.verticalScrollPosition=scoll;
		btn2.enabled=true;
	}else{
		btn1.enabled=false;
	}
}
private function move_scroll(e:MouseEvent):void{
	if(e.delta>0){
		move_above();
	}else{
		move_below();
	}
}