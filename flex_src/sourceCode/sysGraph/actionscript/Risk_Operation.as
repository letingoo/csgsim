// ActionScript file

import com.as3xls.xls.ExcelFile;
import com.as3xls.xls.Sheet;

import common.actionscript.ModelLocator;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Alert;

import sourceCode.packGraph.views.Color1;
import sourceCode.sysGraph.actionscript.DFloyd;
import sourceCode.sysGraph.actionscript.Effect_util;
import sourceCode.sysGraph.actionscript.Maintainence_recoverutil;
import sourceCode.sysGraph.actionscript.Risk_window_displayer;
import sourceCode.sysGraph.model.BusRouteModel;
import sourceCode.sysGraph.model.BussinessRoute;
import sourceCode.sysGraph.model.BusssinessRouteModel;
import sourceCode.sysGraph.model.EquipModel;
import sourceCode.sysGraph.model.FindNewRoute;
import sourceCode.sysGraph.model.Testmodel;
import sourceCode.sysGraph.model.TopoModel;
import sourceCode.sysGraph.model.UsrSelectEvent;
import sourceCode.sysGraph.views.troubleshoot_window;
import sourceCode.sysGraph.views.usrselect_window;

import twaver.Element;
import twaver.Node;


public static const Risk_check:int=1;
public static const Risk_estimate:int=2;
public static const color_invalid:Number=0xCD0000;
public static const color_checkable:Number=0x7CFC00;
public static const color_incheck:Number=0x191970;
public var mapobj:BussinessRoute;
private static var window_displayer:Risk_window_displayer;
private static var recover_util:Maintainence_recoverutil=new Maintainence_recoverutil();
private static var sprinkle_util:Effect_util=new Effect_util();
/**
 *业务权重类map对象 
 */
var business_2_val:Object=new Object;

/**
 *业务路由恢复记录，其中recv_list存储businessroute对象，count_list存储对应检修点对应修改业务数,info_array_log为邻接表记录
 */
var recv_log:Object={recv_list:new Array(),count_list:new Array(),info_array_log:new Array()};


/**
 *业务路由前后详细信息对比存储 
 */
var changelog_spec_old:Array=new Array();

var changelog_spec_new:Array=new Array();

/**
 *业务风险预警报告，包含id和不可检修点？ 
 */
var risk_estimate_list:Array=new Array();

var select_list:Object=new Object;
var element:IElement //当前选取元素
var auto_select_result:Array=new Array();//用户需要选择的主备路由切换
var usr_select_result:Array=new Array();//用户无需选择的业务路由切换
var PRI_old=-1;
var PRI_new:Number=0;


//网络分析相关
//	var Shared.equipnamelist:Array=new Array();//设备名称列表
	//邻接表依旧使用info_array 设备名称列表equipnamelist
var	info_array_backup:Array=new Array();

private function child_app(element:XML,node_content:String){
	var newNode:XML=<item/>;
	//tips:xml中保存 的书类型为对应类型,无需转换
	newNode.@name=node_content;
//	newNode.@position=pos;
	newNode.@type="equip";
	element.appendChild(newNode);
}

private function init_new_view(select_node:XML): void{
	var equiplist:Array=mapobj.topoEquip();
	var linklist:Array=mapobj.topoLink();
	//网络分析复用段变量init
	Shared.route_lst=linklist;

	nod.text=equiplist.length.toString();
	//添加点
	for each(var equip:EquipModel in equiplist){
		//网络分析设备相关init
		Shared.equip_idlist.push(equip.equipcode);
		Shared.equipnamelist.push(equip.equipname);
		child_app(select_node,equip.equipname);
		var node=new Node(equip.equipname);
		node.name=equip.equipname;
		node.setSize(30,30);
		node.image="twaverImages/device/xunishebei.png";
		node.icon="twaverImages/device/xunishebei.png";
		node.setClient("equipcode",equip.equipcode);
		node.setClient("NodeType","equipment");
		node.setClient("checkable",true);
		node.setClient("itemokval",0);
		node.setStyle(Styles.SELECT_COLOR,"0xFF6600");
		node.setCenterLocation(equip.X,equip.Y);
		systemorgmap.elementBox.add(node);
	}
	//添加连线
	var node_a:Node=null;
	var node_z:Node=null;
	for (var i:int=0;i<Shared.equipnamelist.length;i++)
	{	
		Shared.info_array[i] = new Array();
		for(var j:int = 0; j<Shared.equipnamelist.length; j++){
			Shared.info_array[i][j] = 0;
		}
	}
	for each (var routelink:TopoModel in linklist){
		var nodeaname:String,nodezname:String;
		systemorgmap.elementBox.forEach(function(element:IElement):void{
			if(element.elementUIClass.toString() == "[class NodeUI]"){
				if(element.getClient("equipcode")==routelink.Equip_a)
					node_a=Node(element);
				if(element.getClient("equipcode")==routelink.Equip_z)
					node_z=Node(element);
			}
		});
//		node_a=systemorgmap.elementBox.getDataByID(temp[0]) as Node;
//		node_z=systemorgmap.elementBox.getDataByID(temp[1]) as Node;
		if(node_a==null||node_z==null){
			nullflag=0;
		//	err_info=link_155[i];
			break;
		}
		//添加业务路由
		var id_1:int,id_2:int;
		var link:Link = new Link(node_a,node_z);
		link.setClient("equip_a",node_a.name);
		link.setStyle(Styles.LINK_COLOR, "0x000000");
		link.setClient("equip_z",node_z.name);
		link.setStyle(Styles.LINK_TYPE,Consts.LINK_TYPE_HORIZONTAL_VERTICAL);
		link.setStyle(Styles.LINK_BUNDLE_ID, "bundle_route");
		link.setStyle(Styles.LINK_WIDTH,2.5);
		link.setStyle(Styles.LINK_BUNDLE_OFFSET, 25);
		link.setStyle(Styles.LINK_BUNDLE_GAP,15);
		link.setStyle(Styles.LINK_BUNDLE_EXPANDED,false);
		systemorgmap.elementBox.add(link);
		
		//网络分析邻接表init

		for(j=0;j<Shared.equipnamelist.length;j++){
			if(node_a.name==Shared.equipnamelist[j])
				id_1=j;
			if(node_z.name==Shared.equipnamelist[j])
				id_2=j;
		}
		Shared.info_array[id_1][id_2] = 1;
		Shared.info_array[id_2][id_1] = 1;
	}
//	bus_ana_clickHandler();
	state_change_handler(false);
	//testsample(Shared.info_array);
}





/**
 *导入xls初始化 
 * 
 */
private function set_clear():void{
	id0=-1;id1=-1;id2=-1;id3=-1;id4=-1;id5=-1;id6=-1;
}
//加载业务类型权重excel
public function import_bus_val_clickHandler():void
{
	// TODO Auto-generated method stub
	refExcelFile = new  FileReference();
	var xlsFilter:FileFilter = new FileFilter("Excels", "*.xls");
	refExcelFile.browse([xlsFilter]);
	//Alert.show("请选择调度数据网文件");
	refExcelFile.addEventListener(Event.SELECT,onFileSelect2);	
}


//加载权重
public function onFileSelect2(event:Event):void {
	
	
	refExcelFile.load();
	refExcelFile.addEventListener(Event.COMPLETE,import_bus_val);
}

public function import_bus_val(event:Event):void // 导入业务权重
{
	set_clear();
	var data:ByteArray = new ByteArray();
	// 读 bytes放入bytearray变数
	refExcelFile.data.readBytes(data, 0, 0);
	// Load the Excel file
	xls=new ExcelFile();
	xls.loadFromByteArray(data);
	var sheet:Sheet = xls.sheets[0];
	var bus_type:String =new String();
	var bus_val:String =new String();
	
	id1=0;id2=0;
	if(sheet.values.length==0){
		Alert.show("表格导入出错或为空");
	}
	else{
		for(var i:int = 0;i<Number(sheet.cols.toString());i++){
			if(sheet.getCell(0,i).value=="具体类别")
				id1=i;
			else if(sheet.getCell(0,i).value=="重要度")
				id2=i;
		}
		for(var i:int=1;i<Number(sheet.rows.toString());i++){
			if(sheet.getCell(i,id1).toString()!=""&&sheet.getCell(i,id1).toString()!=null&&sheet.getCell(i,id1).toString()!="null")
				bus_type=sheet.getCell(i,id1).toString();
			if(sheet.getCell(i,id2).toString()!=""&&sheet.getCell(i,id2).toString()!=null&&sheet.getCell(i,id2).toString()!="null")
				bus_val=sheet.getCell(i,id2).toString();
			business_2_val[bus_type]=new String(bus_val);
		}
	//	Alert.show(business_2_val.toString(),"业务权重表");
		
	}
}


public function obj_handler():void
{
	var obj:Object=new Object;
	var x:String=new String("123456");
	obj.exp=new String("yyy");

	var obj2:Object=new Object;
	obj2[x]=new String("zzz");//like map
	var test:Array=new Array()
	test.push(obj,obj2);
	for each (var temp in test){
		for each(var tp1 in temp)
		Alert.show(tp1);
	}
	for (var temp in test){
		Alert.show(temp);
	}
	
	
	//	Alert.show(recv.a);
	//	remoteObject.addEventListener(ResultEvent.RESULT,modify_reuslt);
}




//加载业务路由excel
public function import_route_clickHandler():void
{
	// TODO Auto-generated method stub
	refExcelFile = new  FileReference();
	var xlsFilter:FileFilter = new FileFilter("Excels", "*.xls");
	refExcelFile.browse([xlsFilter]);
	//Alert.show("请选择调度数据网文件");
	refExcelFile.addEventListener(Event.SELECT,onFileSelect1);	
}


//加载业务路由
public function onFileSelect1(event:Event):void {
	refExcelFile.load();
	refExcelFile.addEventListener(Event.COMPLETE,import_route);
}

public function import_route(event:Event):void // 导入业务路由
{
	set_clear();
	var data:ByteArray = new ByteArray();
	// 读 bytes放入bytearray变数
	refExcelFile.data.readBytes(data, 0, 0);
	// Load the Excel file
	xls=new ExcelFile();
	xls.loadFromByteArray(data);
	var sheet:Sheet = xls.sheets[0];
	if(sheet.values.length==0){
		Alert.show("表格导入出错或为空");
	}
	else{
		for(var i:int = 0;i<Number(sheet.cols.toString());i++){
			if(sheet.getCell(0,i).value=="业务名称")
				id1=i;
			else if(sheet.getCell(0,i).value=="主用路由")
				id2=i;
			else if(sheet.getCell(0,i).value=="路由1")
				id3=i;
			else if(sheet.getCell(0,i).value=="路由2")
				id4=i;
		}
		
		for(var i:int=1;i<Number(sheet.rows.toString());i++){
			if(sheet.getCell(i,id1).toString()!=""&&sheet.getCell(i,id1).toString()!=null&&sheet.getCell(i,id1).toString()!="null")
				route_name[i]=sheet.getCell(i,id1).toString();
			if(sheet.getCell(i,id2).toString()!=""&&sheet.getCell(i,id2).toString()!=null&&sheet.getCell(i,id2).toString()!="null")
				route_main[i]=sheet.getCell(i,id2).toString();
			if(sheet.getCell(i,id3).toString()!=""&&sheet.getCell(i,id3).toString()!=null&&sheet.getCell(i,id3).toString()!="null")
				route_sub1[i]=sheet.getCell(i,id3).toString();
			if(sheet.getCell(i,id4).toString()!=""&&sheet.getCell(i,id4).toString()!=null&&sheet.getCell(i,id4).toString()!="null")
				route_sub2[i]=sheet.getCell(i,id4).toString();
			var routemodel:BusssinessRouteModel //=new BusssinessRouteModel(route_name[i],route_main[i],route_sub1[i],route_sub2[i]);
			mapobj.insertBusRoute(routemodel);
		}
		var xml :String = "<system code=\"全网\" name=\"全网\" x_coordinate=\"0\" y_coordinate=\"0\" itemShowCheckBox=\"false\" isBranch=\"true\" type=\"all\" checked=\"0\">";
		xml += "<system code=\"骨干网A平面\" name=\"华为\" x_coordinate=\"0\" y_coordinate=\"0\" isBranch=\"true\" type=\"system\" itemShowCheckBox=\"true\" checked=\"0\"></system>";
		xml += "<system code=\"骨干网B平面\" name=\"测试平面b\" x_coordinate=\"0\" y_coordinate=\"0\" isBranch=\"true\" type=\"system\" itemShowCheckBox=\"true\" checked=\"0\"></system>";
		xml += "</system>";
		result_pro(xml);
	}
}


private function result_pro(xml:String):void//向树中添加业务路由节点
{    
	//  tree.dataProvider=null;
	XMLData=new XMLList(xml.toString());
	testtree.dataProvider=XMLData;
	var xmllist:*=testtree.dataProvider;
	var xmlcollection:XMLListCollection=xmllist;	
	for each (var element:XML in xmlcollection.children())
	{ 
		if (element.@name ==  "测试平面a")
		{
			for(var temp:int =1;temp<route_name.length;temp++){
				child_app(element,route_name[temp]);
			}
		}
		if (element.@name ==  "测试平面b")
		{
			for(var temp:int =1;temp<route_name.length;temp++){
				child_app(element,route_name[temp]);
			}
		}
	}
}

/**
 *全网检修状态查看 
 * by yzl
 */
public function bus_ana_clickHandler():void{
	var bus_equip:Array=mapobj.itemList();
	Shared.ana_flag=1;
//	Alert.show(bus_equip.toString(),"bus_equip");
	var err:String=new String("errlist:");
	var verify:String=new String("vlist:");	
	systemorgmap.elementBox.forEach(function(element:Element):void{
		element.setClient("checkable",true);
	});
	for(var temp:int =0;temp<bus_equip.length;temp++){	
		if(mapobj.isItemOK(bus_equip[temp])!=0){
			mark_fal(bus_equip[temp]);
			err+=bus_equip[temp];
		}
		else{
			verify+=bus_equip[temp];
			mark_true(bus_equip[temp]);
		}
	}
//	state_change_handler(false);
	mark_node();
}

/**
 * 
 * @param flag 判断是否需要闪烁效果
 * 	控制检修/恢复时影响的点
 * 
 */
public function state_change_handler(flag:Boolean):void{
	if(flag==true){
		Shared.sprinkle_list.splice(0);
		Shared.sprinkle_color_list.splice(0);
	}
	var bus_equip:Array=mapobj.itemList();
	var node_a:Node=null;
	for(var temp:int =0;temp<bus_equip.length;temp++){
		var tempval:int=mapobj.isItemOK(bus_equip[temp]);
		node_a=systemorgmap.elementBox.getDataByID(bus_equip[temp]) as Node;
		if((tempval*node_a.getClient("itemokval")==0)&&(tempval+node_a.getClient("itemokval")!=0)){
			if(flag==true){
				if(element.getClient("equipcode")!=node_a.getClient("equipcode")){
						Shared.sprinkle_list.push(node_a);
						if(node_a.getClient("checkable")==true){
								Shared.sprinkle_color_list.push(color_checkable);
						}
						
						else{
								Shared.sprinkle_color_list.push(color_invalid);
								//Alert.show("!");
						}
						
				}
			}

		}		
		node_a.setClient("itemokval",mapobj.isItemOK(bus_equip[temp]));

				
	}	

	if(flag==true)	{
		//Alert.show(Shared.sprinkle_list.length.toString());
	//	sprinkle_effect(0,0,0,1);
		sprinkle_util.sprinkle_effect(0,null,0,0,1,Shared.sprinkle_list,Shared.sprinkle_color_list);
	}
}


/**
 * 
 * 全网风险预警信息查看
 */
public function risk_check_handler():void{
	//window_generator(Risk_check);
	window_displayer=new Risk_window_displayer(Risk_check,PRI_old,PRI_new,changelog_spec_old,changelog_spec_new,risk_estimate_list,this);
}

/**
 *业务风险评估信息查看 
 * 
 */
public function risk_estimate_handler():void{
	//window_generator(Risk_estimate);
	window_displayer=new Risk_window_displayer(Risk_estimate,PRI_old,PRI_new,changelog_spec_old,changelog_spec_new,risk_estimate_list,this);
	
}

public function mark_fal(node:String):void{
	var node_a:Node=null;
	node_a=systemorgmap.elementBox.getDataByID(node) as Node;
	if(node_a!=null)
		node_a.setClient("checkable",false); 
}

public function mark_true(node:String):void{
//	var node_a:Node=null;
////	node_a=systemorgmap.elementBox.getDataByID(node) as Node;
////	if(node_a!=null&&node_a.getClient("checkable")!=false)
////		node_a.setClient("checkable",true); //填充颜色
	
}



public function mark_node():void  {
	systemorgmap.elementBox.forEach(function(element:IElement):void{
		if(element.elementUIClass.toString() == "[class NodeUI]"){
			if(element.getClient("incheck")==true){
				element.setStyle(Styles.INNER_COLOR, 0x191970);
			}
			else{
				if(element.getClient("checkable")==true){
					element.setStyle(Styles.INNER_COLOR, 0x7CFC00);
				}
				else
					element.setStyle(Styles.INNER_COLOR, 0xCD0000);
			}

		}
	});
}




//展示数据相关处理
private function select_result_handler(event:UsrSelectEvent):void {
	//新老pri计算
	changelog_spec_old=new Array();
	changelog_spec_new=new Array();
	PRI_old=cal_PRI_sum(changelog_spec_old,risk_estimate_list);

	//用户选择更新map
	usr_select_result=event.select_result;
	UpdateRoutemap(usr_select_result,auto_select_result);
	element.setClient("incheck",true);
	//sprinkle_effect(incheck_color);
	//sprinkle_effect(1,color_checkable,color_incheck,0);
	
	sprinkle_util.sprinkle_effect(1,element,color_checkable,color_incheck,0,null,null);
	PRI_new=cal_PRI_sum(changelog_spec_new,risk_estimate_list);
	bus_ana_clickHandler();
	state_change_handler(true);
	modify_info_array();
	

}

/**
 * 
 * 每次检修后修改邻接表
 */
private function modify_info_array():void {
	var pos:int;
	for(var i:int=0;i<Shared.equipnamelist.length;i++){
		if(element.name==Shared.equipnamelist[i])
			pos=i;
	}
	for(var i:int=0;i<Shared.equipnamelist.length;i++){
		Shared.info_array[i][pos]=0;
		Shared.info_array[pos][i]=0;
	}
}


function clone(source:Object):*
{
	var myBA:ByteArray = new ByteArray();
	myBA.writeObject(source);
	myBA.position = 0;
	return(myBA.readObject());
}

/**
 * 
 * 检修点右键点击故障检修事件
 * 
 */
private function BusinesscheckHandler(e:ContextMenuEvent):void
{
	
	var route_log_old:Array=new Array();
	var route_log_new:Array=new Array();
	usr_select_result=new Array();
	auto_select_result=new Array();
	
	element=(Element)(systemorgmap.selectionModel.lastData);
//	if (element is Node) //判断选中的元素是不是结点
//	{
//		Alert.show(element.name);
//		var trouble:troubleshoot_window=new troubleshoot_window(); 
//		var par_business:Array=getBusrouteByItem(element.name);
//		Alert.show(par_business.toString());
//		PopUpManager.addPopUp(trouble,this); 
//		PopUpManager.centerPopUp(trouble); 
//		trouble.addEventListener("ModifyEvent",troubleshoot_handler);
//	
//	}
	if (element is Node) {
		if(element.getClient("incheck")==true){
			ModelLocator.showErrorMessage("当前设备/复用段已经处于检修状态",this);
		}
		else if(mapobj.isItemOK(element.name)>0){
			///element.getClient("checkable")==false){
			ModelLocator.showConfimMessage("当前设备/复用段不可检修，是否通过策略生成新路由",this,Route_generate_Handler);
		}
		else{
			var par_business:Array=mapobj.getBusrouteByItem(element.name);
//			Alert.show(par_business.toString());
			if(par_business.length==0){
				ModelLocator.showErrorMessage("当前节点上没有承载业务,无需检修",this);
			}
			else{
				var usr_select_bus_list:Array=new Array();
				select_list=new Object;
				//恢复条数记录
				var count_obj:Object=new Object;
				count_obj.count=par_business.length;
				count_obj.node=element.name;
				var info_temp:Array=new Array();
				copyarr(info_temp);
				recover_util.add_log(par_business,count_obj,info_temp,mapobj);//恢复记录存储
				for(var temp:int =0;temp<par_business.length;temp++){
					if(par_business[temp]!=""){
						manual_route_process(par_business[temp],route_log_old,route_log_new,usr_select_bus_list);
						
					}
				}
				if(usr_select_bus_list.length!=0){
					var manual_select_window:usrselect_window=new usrselect_window(); 
					manual_select_window.select_list=select_list;
					manual_select_window.bus_list=usr_select_bus_list;
					PopUpManager.addPopUp(manual_select_window,this); 
					PopUpManager.centerPopUp(manual_select_window); 
					manual_select_window.addEventListener("UsrSelectEvent",select_result_handler);
				}
				else{
					select_result_handler(new UsrSelectEvent("UsrSelectEvent",new Array()));
					
				}
			}
		

			
			

			}

	}


	
}

private function copyarr(arr:Array){
	for(var x:int=0;x<Shared.equipnamelist.length;x++){
		arr[x]=new Array();
		for(var x1:int=0;x1<Shared.equipnamelist.length;x1++){
			arr[x][x1]=Shared.info_array[x][x1];
		}
	}
}

/**
 * 
 * 检修点恢复
 * 
 */
private function Recover_hanlder(event:CloseEvent):void {
	if (event.detail == Alert.YES){
		var recovered_log:Array=recover_util.Recover_process(element.name,mapobj);
		for(var tp:int=0;tp<recovered_log.length;tp++){
			var temp_node:Node=systemorgmap.elementBox.getDataByID(recovered_log[tp]) as Node;
			temp_node.setClient("incheck",false);
		}
	//	sprinkle_effect(1,color_incheck,color_checkable,0);		
		sprinkle_util.sprinkle_effect(1,element,color_incheck,color_checkable,0,null,null);
		bus_ana_clickHandler();
		state_change_handler(true);

	}
}

private function CheckRecoverHandler(e:ContextMenuEvent):void
{
	
	element=(Element)(systemorgmap.selectionModel.lastData);
	if(element.getClient("incheck")==true){
		ModelLocator.showConfimMessage("是否确定恢复该节点及相关业务路由",this,Recover_hanlder);
	}
	else {
		ModelLocator.showErrorMessage("该设备未处于检修状态，不可被检修",this);
	}
	
}



private function UpdateRoutemap(usr_select_result,auto_select_result):Boolean{
	var count:int=0
	for each(var temp:BusssinessRouteModel in usr_select_result){
		mapobj.updateBusroute(temp);
			count++;
	}
	for each(var temp:BusssinessRouteModel in auto_select_result){
		mapobj.updateBusroute(temp);
		count++;
	}
	return true;
}



private function manual_route_process(unprocessed_business_id:String,log_old:Array,log_new:Array,usr_select_bus_list:Array):Boolean{
	
	var bus_id:String=unprocessed_business_id.slice(3);
	var tpobj:BusssinessRouteModel=mapobj.getBusrouteByID(bus_id);
	var init_route:Array=tpobj.toString().split("//");
	
	var changed_route:Array=new Array();
	log_old.push(mapobj.getBusrouteByID(bus_id).toString());
	if(unprocessed_business_id.charAt(0)=='1'){
		usr_select_bus_list.push(bus_id);
		select_list[bus_id]=new Array();
		for(var temp:int=1;temp<3;temp++){
			if(unprocessed_business_id.charAt(temp)=='0'){
				var ob:Object=new Object;
				ob.route=init_route[temp+1];
				ob.bus_id=bus_id;
				ob.type=tpobj.getbustype();
				ob.name=tpobj.getbusname();
				select_list[bus_id].push(ob);
			}
		}		
	}
	else{
		route_process(unprocessed_business_id,log_old,log_new,auto_select_result);
	}
	return true;
}

//原先运行在备用路上的路由，不经过选择，切换成主用路由
private function route_process(unprocessed_business_id:String,log_old:Array,log_new:Array,updata_route_arr:Array):Boolean{
	
	var bus_id:String=unprocessed_business_id.slice(3);
	var tpobj:BusssinessRouteModel=mapobj.getBusrouteByID(bus_id);
	var init_route:Array=tpobj.toString().split("//");
	var changed_route:Array=new Array();
	log_old.push(tpobj.toString());
	for(var temp:int=0;temp<3;temp++){
		if(unprocessed_business_id.charAt(temp)=='0'){
			changed_route.push(init_route[temp+1]);
		}
	}		
	for(var count:uint=changed_route.length;count<3;count++)
	{
		changed_route.push("");
	}
	updata_route_arr.push(new BusssinessRouteModel(bus_id,tpobj.getbusname(),tpobj.getbustype(),changed_route[0],changed_route[1],changed_route[2]));
		return true;
	
}



/**
 * 
 * 不可检修点进行新备用路由生成
 * 
 */
private function Route_generate_Handler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		//Alert.show(equipname.toString(),link_155.toString());	
		var recover_comp:FindNewRoute=new FindNewRoute(mapobj.topoEquip(),mapobj.topoLink(),mapobj);
		if(element as Node!=null){
			recover_comp.findRouteHandler(element as Node);
	//		Alert.show("1111");
			
		}
			
	}

	bus_ana_clickHandler();
	state_change_handler(true);
	
}


