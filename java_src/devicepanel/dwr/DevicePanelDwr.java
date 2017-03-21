package devicepanel.dwr;

import java.io.*; 

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.tools.ant.util.DateUtils;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import sysManager.log.dao.LogDao;
import sysManager.user.model.UserModel;

import db.ForTimeBaseDAO;
import devicepanel.model.*;

import devicepanel.dao.*;
import flex.messaging.FlexContext;
import flex.messaging.io.ArrayCollection;


public class DevicePanelDwr {
	
	private DevicePanelDAO devicePanelDao;
			
	public DevicePanelDAO getDevicePanelDao() {
		return devicePanelDao;
	}

	public void setDevicePanelDao(DevicePanelDAO devicePanelDao) {
		this.devicePanelDao = devicePanelDao;
	}

	public String getDeviceTree(String pid,String type){
		String xml="";
		Map resultMap = new HashMap();
		if(type.equalsIgnoreCase("root")){
			xml+="<list>";
			List<HashMap> lstSystem=devicePanelDao.getTransSystem();
			for(HashMap system: lstSystem) {
				resultMap=system;
				String systemcode=system.get("SYSTEMCODE").toString();
				xml +=  "<system name=\""+resultMap.get("SYSNAME").toString()+"\" id=\""+resultMap.get("SYSTEMCODE").toString()+"\" isBranch=\"true\">";
				xml+="</system>";
			}
			xml+="</list>";
		}
		else if(type.equalsIgnoreCase("system")){
			List<HashMap> lstDevice=devicePanelDao.getEquipment(pid);
			for(HashMap device:lstDevice){
				resultMap=device;
				xml+="<device name=\""+resultMap.get("EQUIPNAME").toString()+"\" id=\""+resultMap.get("EQUIPCODE").toString()+"\" systemcode=\""+pid+"\" isBranch=\"false\" x_vendor=\""+resultMap.get("X_VENDOR")+"\" x_model=\""+resultMap.get("X_MODEL")+"\"></device>";
			}
		}
		return xml;
	}
	
	public String getPanelModel(String equipcode) {
		String x_model=devicePanelDao.getDeviceModel(equipcode);
		return x_model;
	}
	
	public List<CardModel> getCard(String equipcode,String flag){
		List<HashMap> lst=devicePanelDao.getCard(equipcode,flag);
		List<CardModel> lstCardInfo=new ArrayList<CardModel>();
		for(HashMap ci:lst){
			CardModel cardInfo=new CardModel();
			cardInfo.setCardcode(ci.get("PACKCODE").toString());
			cardInfo.setCardname(ci.get("S_PACKNAME").toString());
			cardInfo.setSlotserial(ci.get("SLOTSERIAL").toString());
			cardInfo.setFrameserial(ci.get("FRAMESERIAL").toString());
			cardInfo.setPortnum(Integer.parseInt(ci.get("NUM").toString()));
			if(ci.get("RATE")!=null){
				cardInfo.setRate(ci.get("RATE").toString());
			}
			if(ci.get("PACKLOGO")!=null){
				cardInfo.setPacklogo(ci.get("PACKLOGO").toString());
			}
//			if(ci.get("RATE")!=null&&!ci.get("RATE").toString().equalsIgnoreCase("")){
//				Map map=new HashMap();
//				map.put("equipcode", equipcode);
//				map.put("frameserial", ci.get("FRAMESERIAL").toString());
//				map.put("slotserial", ci.get("SLOTSERIAL").toString());
//				map.put("packserial", ci.get("PACKSERIAL").toString());
//
//				String tooltip="";//this.devicePanelDao.getNextPorts(ci.get("RATE").toString(), map);
//				cardInfo.setTooltip(tooltip);

			lstCardInfo.add(cardInfo);
		}
		return lstCardInfo;
	}
	
	public List getTooltip(ArrayList arraylist){
		String packcode = "";
		String equipcode = "";
		String frameserial = "";
		String slotserial = "";
		String packserial = "";
		String rate = "";
		String id = "";
		String tooltip = "";
		String id_tooltip = "";
		List<String> list2 = new ArrayList<String>();
		Map map = new HashMap();
		for(int i = 0;i<arraylist.size();i++){
			List<String> list = (ArrayList<String>)arraylist.get(i);
			packcode = list.get(0);
			rate = list.get(1);
			id = list.get(2);
            equipcode = packcode.split(",")[0];
            frameserial = packcode.split(",")[1];
            slotserial = packcode.split(",")[2];
            packserial = packcode.split(",")[3];
            map.put("equipcode", equipcode);
            map.put("frameserial", frameserial);
            map.put("slotserial", slotserial);
            map.put("packserial", packserial);
            tooltip = this.devicePanelDao.getNextPorts(rate, map);
            id_tooltip = id +"@@"+tooltip;
            list2.add(id_tooltip);
		}

		return list2;
	}
	
	public String getCarryOperaFlex(int pageIndex,int pageSize,String equipcode)
	{

		CarryOperaModel carryOperaModel=new CarryOperaModel();
		Map map=new HashMap();
		map.put("equipcode", equipcode);
	
		String xml = "<list>";
		
		try
		{
		List<CarryOperaModel> list=devicePanelDao.getCarryOperaFlex(map);

		for(int i = 0; i < list.size(); i++) {
			xml += "\n"+"<item carryoperaid=\""+list.get(i).getCarryoperaid()
			+"\" circuitcode=\""+list.get(i).getCircuitcode()
			+"\" rate=\""+list.get(i).getRate()
			+"\" portserialno1=\""+list.get(i).getPortserialno1()
			+"\" slot1=\""+list.get(i).getSlot1()
			+"\" portserialno2=\""+list.get(i).getPortserialno2()
			+"\" slot2=\""+list.get(i).getSlot2()			
			+"\"></item>";
		}
		
		xml += "</list>";
		
		}
		catch(Exception e)
		{
		 e.printStackTrace();
		}
		return xml;
	}
	
	public String getStatisInfoFlex(int pageIndex,int pageSize,String equipcode)
	{


		DevicePortStatsModel devicePortStatsModel=new DevicePortStatsModel();
		Map map=new HashMap();
		map.put("equipcode", equipcode);		
		String xml = "<list>";
		List<DevicePortStatsModel> list=devicePanelDao.getStatisInfoFlex(map);

		for(int i = 0; i < list.size(); i++) {
			xml += "\n"+"<item equipcode=\""+list.get(i).getEquipcode()
			+"\" logicport=\""+list.get(i).getLogicport()
			+"\" x_capability=\""+list.get(i).getX_capability()
			+"\" allvc4=\""+list.get(i).getAllvc4()
			+"\" usrvc4=\""+list.get(i).getUsrvc4()
			+"\" usrvc12=\""+list.get(i).getUsrvc12()
			+"\" freevc4=\""+list.get(i).getFreevc4()
			+"\" rate=\""+list.get(i).getRate()
			+"\"></item>";
		}
		
		xml += "</list>";
		
		return xml;
	}
	
	public String getStatisPieFlex(int pageIndex,int pageSize,String equipcode)
	{
		PortUseStatsModel portUseStatsModel=new PortUseStatsModel();
		Map map=new HashMap();
		map.put("equipcode", equipcode);
		
		String xml = "<list>";

		List<PortUseStatsModel> list=devicePanelDao.getStatisPieFlex(map);

		for(int i = 0; i < list.size(); i++) {
			xml += "\n"+"<item equipcode=\""+list.get(i).getEquipcode()
			+"\" portnum=\""+(int)list.get(i).getPortnum()
			+"\" portusenum=\""+(int)list.get(i).getPortusenum()
			+"\" rate=\""+list.get(i).getRate()
			+"\" portuserate=\""+list.get(i).getPortuserate()
			+"\"></item>";
		}
		
		xml += "</list>";
		return xml;
	}
	
	//机盘属性
	@SuppressWarnings("unchecked")
	public PackInfoModel getPackInfo(String packcode){
		String[] codes=packcode.split(",");
		Map map = new HashMap();
		map.put("equipcode", codes[0]);
		map.put("frameserial", codes[1]);
		map.put("slotserial", codes[2]);
		map.put("packserial", codes[3]);
		PackInfoModel packinfo= devicePanelDao.getPackInfo(map);
		return packinfo;
	}	 
	//机盘属性更新
	public String updateEquipPack(PackInfoModel packInfo,String packcode){
		String[] codes=packcode.split(",");
		Map map=new HashMap();
		map.put("gb_equipcode", codes[0]);
		map.put("gb_frameserial", codes[1]);
		map.put("gb_slotserial", codes[2]);
		map.put("gb_packserial", codes[3]);
		map.put("frameserial", packInfo.getFrameserial());
		map.put("slotserial", packInfo.getSlotserial());
		map.put("packserial", packInfo.getPackserial());
		map.put("packmodel", packInfo.getPackmodel());
		map.put("remark", packInfo.getRemark());
		map.put("packsn", packInfo.getPacksn());
		map.put("software_version", packInfo.getSoftware_version());
		map.put("hardware_version", packInfo.getHardware_version());
		//如果未填写更新日期，则默认当前日期
		if(null == packInfo.getUpdatedate() || "".equals(packInfo.getUpdatedate().trim())){
			map.put("updatedate", DateUtils.format(new Date(), "yyyy-MM-dd"));
		}else{
		    map.put("updatedate", packInfo.getUpdatedate());
		}
		map.put("updateperson", packInfo.getUpdateperson());
		try{
			devicePanelDao.updateEquipPack(map);
			return "success";
		}catch(Exception e){
			return "failed";
		}
	}
	
	//模板列表
	public String getModelList(){
		String xml="";
		List<HashMap> lst=this.devicePanelDao.getModelList();
		String vendor= lst.get(0).get("XTXX").toString();
		xml+="<vendor id=\""+lst.get(0).get("X_VENDOR").toString()+"\" name=\""+vendor+"\" isBranch=\"true\">";
		for(HashMap map:lst){
			
			if(!map.get("XTXX").toString().equals(vendor)){
				xml+="</vendor>";
				vendor= map.get("XTXX").toString();
				xml+="<vendor id=\""+map.get("X_VENDOR").toString()+"\" name=\""+vendor+"\" isBranch=\"true\">";
			}
			xml+="<model id=\""+map.get("X_VENDOR")+"\" name=\""+map.get("MODEL_NAME")+"\" isBranch=\"false\"></model>";
		}
		xml+="</vendor>";
		return xml;
	}
	
	//模板信息
	public String getModelByName(String vendor,String model_name){
		Map map=new HashMap();
		map.put("vendor", vendor);
		map.put("model_name", model_name);
		return this.devicePanelDao.getModelByName(map);
	}
	
	//模板操作
	public String operModel(String vendor,String model_name,String model_context){
		String result;
		Map map=new HashMap();
		map.put("model_context", "empty_clob()");
		map.put("model_name", model_name);
		map.put("vendor", vendor);
		this.devicePanelDao.delModelByName(map);
		this.devicePanelDao.addModel(map);
		String sql = "select model_context from equip_panel_model where x_vendor='"+vendor+"' and model_name='" + model_name + "' for update";
		ForTimeBaseDAO dao = new ForTimeBaseDAO();
		Connection c = null;
	    Statement s = null;
	    ResultSet r = null;
	    try{
			c = dao.getConnection();
            c.setAutoCommit(false);
            s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            r = s.executeQuery(sql);
            oracle.sql.CLOB osc = null;
            if (r.next()) {
                osc = (oracle.sql.CLOB)r.getClob("model_context");
                Writer w = osc.getCharacterOutputStream();
                w.write(model_context);
                w.flush();
                w.close();
                c.commit(); 
            }
            result= "success";
		}catch (Exception e) {
			result="failed";
            e.printStackTrace();
        } finally {
            dao.closeConnection(c, s, r);
        }
        return result;
	}
	
	
	public String getModelContext(String vendor,String model_name){
		 String xml = "";
	     ForTimeBaseDAO dao = new ForTimeBaseDAO();
	     Connection c = null;
	     Statement s = null;
	     ResultSet r = null;
	     String sql = "select * from equip_panel_model where direction=0 and x_vendor='"+vendor+"' and model_name='" + model_name + "'";
	     try {
	            c = dao.getConnection();
	            s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
	                    ResultSet.CONCUR_READ_ONLY);
	            r = s.executeQuery(sql);
	            oracle.sql.CLOB osc = null;//初始化一个空的clob对象
	            if (r.next()) {
	                osc = (oracle.sql.CLOB) r.getClob("model_context");
	                xml = osc.getSubString((long) 1, (int) osc.length());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            dao.closeConnection(c, s, r);
	        }
	        return xml;
	}
	
	public String getModelContextNew(String vendor,String model_name,String flag){
		 String xml = "";
	     ForTimeBaseDAO dao = new ForTimeBaseDAO();
	     Connection c = null;
	     Statement s = null;
	     ResultSet r = null;
	     String sql = "select * from equip_panel_model where x_vendor='"+vendor+"' and direction='"+flag+"' and model_name='" + model_name + "'";
	     try {
	            c = dao.getConnection();
	            s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
	                    ResultSet.CONCUR_READ_ONLY);
	            r = s.executeQuery(sql);
	            oracle.sql.CLOB osc = null;//初始化一个空的clob对象
	            if (r.next()) {
	                osc = (oracle.sql.CLOB) r.getClob("model_context");
	                xml = osc.getSubString((long) 1, (int) osc.length());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            dao.closeConnection(c, s, r);
	        }
	        return xml;
	}
	
	public String getSlotDirectionByIds(String codes){
		String result="fail";
		String[] arr;
		String equipcode="0",frameserial="0",slotserial="0";
		if(codes.indexOf("=")!=-1){
			arr = codes.split("=");
		}else if(codes.indexOf(",")!=-1){
			arr = codes.split(",");
		}else{
			arr = new String[]{codes};
		}
		if(arr.length==4){
			equipcode=arr[0];
			frameserial=arr[1];
			slotserial=arr[2];
		}
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		String dir = this.devicePanelDao.getSlotDirectionByIds(map);
		if("1".equals(dir)){
			result = "success";
		}
		return result;
	}

	public String delModelByName(String vendor,String model_name){
		try{
			Map map=new HashMap();
			map.put("vendor", vendor);
			map.put("model_name", model_name);
			this.devicePanelDao.delModelByName(map);
			return "success";
		}catch(Exception e){
			return "failed";
		}
	}
	
	public String getVendor(){
		String xml="";
		List<HashMap> lst=this.devicePanelDao.getVendor();
		for(HashMap map:lst){
			xml+="<vendor id=\""+map.get("XTBM").toString()+"\" vendor=\""+map.get("XTXX").toString()+"\"></vendor>";
		}
		return xml;
	}
	
	public List getSlotInfo(String equipcode,String frameserial,String slotserial,String packserial,String circuitcode){
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		map.put("circuitcode", circuitcode);
		List<SlotInfoModel> list = this.devicePanelDao.getSlotInfo(map);
		return list;
	}
	
	public String getCarryOperaByPack(String equipcode,String frameserial,String slotserial,String packserial,String circuitcode){
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		map.put("circuitcode", circuitcode);
		List<HashMap> list = this.devicePanelDao.getCarryOperaByPack(map);
		
		String xml = "<list>";
		try {			
			for(int i=0;i<list.size();i++){
				map = list.get(i);
				xml += "\n"+"<item  circuitcode=\""+map.get("CIRCUITCODE")
				+"\" portserialno1=\""+map.get("PORTSERIALNO1")+"\" slot1=\""+map.get("SLOT1")
				+"\" portserialno2=\""+map.get("PORTSERIALNO2")+"\" slot2=\""+map.get("SLOT2")
				+"\" rate=\""+map.get("RATE")
				+"\" username=\""+map.get("USERNAME")
				+"\" transrate=\""+map.get("TRANSRATE")
				+"\" remark=\""+map.get("REMARK")+"\"></item>";
			}
		
			xml += "</list>";
			HttpServletRequest request = FlexContext.getHttpRequest();			
			WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao)ctx.getBean("logDao");
			logDao.createLogEvent("查询", "设备面板图", "查询设备业务信息", "", request);
			return xml;
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 根据设备类型从equippack_model表中获取机盘类型
	 * @param equipModel
	 * @return 机盘型号列表
	 *@author xiezhikui
	 */
	public List getEquipTypeByEquipCode(String equipModel){
		List list = (List)this.devicePanelDao.getEquipTypeByEquipCode(equipModel);
		return list;
	}
	
	public String getFrameserialByEquipCode(String equipCode,String slotserial){
		Map map = new HashMap();
		map.put("equipCode", equipCode);
		map.put("slotserial", slotserial);
		return this.devicePanelDao.getFrameserialByEquipCode(map);
	}
	
	public String addPack(PackInfoModel model){
		try{
			this.devicePanelDao.addPack(model);
			return "success";
		}catch(Exception e){
			e.printStackTrace();
			return "failed";
		}
	}
	
	public List getEquipPackAlarm(String equipcode){
		Map map  = new HashMap();
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
		map.put("equipcode", equipcode);
		map.put("alarmman", user.getUser_id());
		return this.devicePanelDao.getEquipPackAlarm(map);
	}
}
