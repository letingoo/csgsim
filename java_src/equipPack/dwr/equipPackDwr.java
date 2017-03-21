package equipPack.dwr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import devicepanel.model.PortUseStatsModel;

import sysManager.log.dao.LogDao;
import sysManager.user.model.UserModel;
import twaver.Consts;
import twaver.ElementBox;
import twaver.Follower;
import twaver.Grid;
import twaver.IElement;
import twaver.Node;
import twaver.SerializationSettings;
import twaver.Styles;
import twaver.XMLSerializer;
import equipPack.dao.EquipPackDAO;
import equipPack.model.AlarmModel;
import equipPack.model.BusinessModel;
import equipPack.model.LogicPortModel;
import equipPack.model.OpticalPortDetailModel;
import equipPack.model.OpticalPortListModel;
import equipPack.model.OpticalPortStatusModel;
import equipPack.model.ParameterModel;
import equipPack.model.StatisModel;
import flex.messaging.FlexContext;

public class equipPackDwr {
	EquipPackDAO equipPackDao;

	public EquipPackDAO getEquipPackDao() {
		return equipPackDao;
	}

	public void setEquipPackDao(EquipPackDAO equipPackDao) {
		this.equipPackDao = equipPackDao;
	}


	public String getEquipName(String equipcode,String frameserial_,String slotserial_,String packserial_) {	
		String xml = "";
		boolean flag = false;
		List<HashMap> list = equipPackDao.getEquipList(equipcode);
		List<HashMap> leaflist = new ArrayList<HashMap>();
		try
		{
			for (HashMap lst : list) 
			{
				String equipname = (String) lst.get("EQUIPNAME");
			    equipcode = (String) lst.get("EQUIPCODE");
				xml += "\n" + "<folder state='0' label='" + equipname
						+ "' code = '" + equipcode
						+ "' leaf='true' root='1' enabled='false'>";
				Map paraMap = new HashMap();
				List<HashMap> childlist = equipPackDao.getPortDetail(equipcode);//获取设备的机盘信息
				for (HashMap clst : childlist)
				{
					String slotserial = (String) clst.get("SLOTSERIAL");
					String s_packname = (String) clst.get("S_PACKNAME");
					String packserial = (String) clst.get("PACKSERIAL");
					String frameserial = (String) clst.get("FRAMESERIAL");
	
					paraMap = new HashMap();
					if(slotserial.equalsIgnoreCase(slotserial_)){
//						paraMap.put("packserial", packserial_);
						paraMap.put("packserial", packserial);
						paraMap.put("slotserial", slotserial_);
						paraMap.put("frameserial", frameserial_);
						paraMap.put("equipcode", equipcode);
						leaflist = equipPackDao.getPackPortLabel(paraMap);
						flag = true;
					}
					if(leaflist.size()>0 && flag)
					{
						Map m = new HashMap();
						m = leaflist.get(0);
						xml += "\n" + "<folder state='0' label='"+frameserial+"框" + slotserial
						+ "槽" + s_packname + "' equipcode='"
						+ equipcode + "' code = '" + slotserial
						+ "' leaf='false'"+" frameserial='"+frameserial+"' packserial='"+packserial+"' launch='true' ck='true' rate='"+(String) m.get("X_CAPABILITY")+"'>";
						flag = false;
					}
					else
					{
						xml += "\n" + "<folder state='0' label='"+frameserial+"框" + slotserial
								+ "槽" + s_packname + "' equipcode='"
								+ equipcode + "' code = '" + slotserial
								+ "' frameserial='"+frameserial+"' packserial='"+packserial+"' leaf='false'    launch='false' ck='true' isBranch='true'>";
							
					}
					xml += "\n" + "</folder>";
				}

				xml += "\n" + "</folder>";
			
			}
		} 
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return xml;
	}
	
	
	public String getPackPort(String equipcode,String frameserial,String slotserial,String packserial) {
		String xml = "";
		Map paraMap = new HashMap();
		paraMap.put("packserial", packserial);
		paraMap.put("slotserial", slotserial);
		paraMap.put("frameserial", frameserial);
		paraMap.put("equipcode", equipcode);
		List<HashMap> leaflist = equipPackDao.getPackPortLabel(paraMap);
		if(leaflist.size()>0){
			for (HashMap llst : leaflist){
				String portlabel = (String) llst.get("PORTLABEL");
				String logicport = (String) llst.get("LOGICPORT");
				String x_capability = (String) llst.get("X_CAPABILITY");
				xml += "\n" + "<folder state='0' label='" + portlabel
						+ "' code = '" + logicport + "' leaf='true' rate='" + x_capability + "' enabled='false' />";
			}
		}
		return xml;
	}
	
	
//	public String getEquipDetailInfo(String equipcode,String frameserial,String slotserial,String packserial) {
//		String xml = "";
//		List<HashMap> list = equipPackDao.getEquipList(equipcode);
//		try {
//			for (HashMap lst : list) {
//				String equipname = (String) lst.get("EQUIPNAME");
//			    equipcode = (String) lst.get("EQUIPCODE");
//				xml += "\n" + "<folder state='0' label='" + equipname
//						+ "' code = '" + equipcode
//						+ "' leaf='false' root='1' >";
//				Map paraMap = new HashMap();
//				List<HashMap> childlist = equipPackDao.getPortDetail(equipcode);
//		
//				for (HashMap clst : childlist) {
//					
//					String slotserial = (String) clst.get("SLOTSERIAL");
//					String s_packname = (String) clst.get("S_PACKNAME");
//					String packserial = (String) clst.get("PACKSERIAL");
//					String frameserial = (String) clst.get("FRAMESERIAL");
//					xml += "\n" + "<folder state='0' label='" + slotserial
//							+ "槽" + s_packname + "' equipcode='"
//							+ equipcode + "' code = '" + slotserial
//							+ "' leaf='false' >";
//					
//					paraMap = new HashMap();
//					paraMap.put("packserial", packserial);
//					paraMap.put("slotserial", slotserial);
//					paraMap.put("frameserial", frameserial);
//					paraMap.put("equipcode", equipcode);
//					
//					List<HashMap> leaflist = equipPackDao.getPackPortLabel(paraMap);
//					for (HashMap llst : leaflist) {
//						String portlabel = (String) llst.get("PORTLABEL");
//						String logicport = (String) llst.get("LOGICPORT");
//						String x_capability = (String) llst.get("X_CAPABILITY");
//						xml += "\n" + "<folder state='0' label='" + portlabel
//								+ "' code = '" + logicport + "' leaf='true' rate='" + x_capability + "' enabled='false' />";
//					}
//					xml += "\n" + "</folder>";
//				}
//
//				xml += "\n" + "</folder>";
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	//	System.out.println(xml);
//		return xml;
//	}
	
	//查询业务
	public String getPackYewu(String equipcode, String frameserial,
			String slotserial, String packserial,String logicport) {
		String xml = "<list>";
		
		try {
			Map map = new HashMap();
			map.put("equipcode", equipcode);
			map.put("frameserial", frameserial);
			map.put("slotserial", slotserial);
			map.put("packserial", packserial);
			if (logicport == null || logicport.equals("")) {
				map.put("id", logicport);
			} else {
				map.put("id", logicport);
			}
			BusinessModel businessModel = new BusinessModel();
			// acBoardModel.setIndex(index);
			// acBoardModel.setEnd(end);
			// acBoardModel.setStationcode(stationcode);
			// int totalCount=equipPackDao.getPackYewu(map);
			List<BusinessModel> list = equipPackDao.getPackYewu(map);
			for (int i = 0; i < list.size(); i++) {
				xml += "\n" + "<item  circuitcode=\""
						+ list.get(i).getCircuitcode() + "\" rate=\""
						+ list.get(i).getRate() + "\" portserialno1=\""
						+ list.get(i).getPortserialno1() + "\" slot1=\""
						+ list.get(i).getSlot1() + "\" portserialno2=\""
						+ list.get(i).getPortserialno2() + "\" slot2=\""
						+ list.get(i).getSlot2() + "\"></item>";
			}
			xml += "</list>";
			HttpServletRequest request = FlexContext.getHttpRequest();			
			WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao)ctx.getBean("logDao");
			logDao.createLogEvent("查询", "机盘管理视图", "查询业务", "", request);			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return xml;
	}
    //查询告警
	public String getPackAlarm(String equipcode, String frameserial,
			String slotserial, String packserial,String logicport) {
	//	String equipcode = equipcode;
		int end = 50;
		int index = 0;
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		if (logicport == null||logicport.equals("")){
			map.put("id", logicport);
		}
		else{
			map.put("id", logicport);
		}
		map.put("end", end);
		map.put("index", index);
		AlarmModel alarmModel = new AlarmModel();
		String xml = "<list>";

		List<AlarmModel> list = equipPackDao.getPackAlarm(map);
		for (int i = 0; i < list.size(); i++) {
			xml += "\n" + "<item alarmlevel=\"" + list.get(i).getAlarmlevel()
					+ "\" objectinfo=\"" + list.get(i).getObjectinfo()
					+ "\" alarmdesc=\"" + list.get(i).getAlarmdesc()
					+ "\" alarmtext=\"" + list.get(i).getAlarmtext()
					+ "\" starttime=\"" + list.get(i).getStarttime()
					+ "\" isacked=\"" + list.get(i).getIsacked()
					+ "\" acktime=\"" + list.get(i).getAcktime()
					+ "\" ackperson=\"" + list.get(i).getAckperson()
					+ "\" arrivetime=\"" + list.get(i).getArrivetime()
					+ "\" alarmnumber=\"" + list.get(i).getAlarmnumber()
					+ "\"></item>";
		}
		xml += "</list>";
		HttpServletRequest request = FlexContext.getHttpRequest();			
		WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao)ctx.getBean("logDao");
		logDao.createLogEvent("查询", "机盘管理视图", "查询告警信息", "", request);
		return xml;
	}

	public String getPackStatis(String equipcode, String frameserial,
			String slotserial, String packserial) {
		//String equipcode = equipcode;
		
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		
		StatisModel statisModel = new StatisModel();
		String xml = "<list>";

		List<StatisModel> list = equipPackDao.getPackStatis(map);
		for (int i = 0; i < list.size(); i++) {
			String rate = (list.get(i).getRate()).replace("    ", "   0");

			xml += "\n" + "<item logicport=\"" + list.get(i).getLogicport()
					+ "\" x_capability=\"" + list.get(i).getX_capability()
					+ "\" allvc4=\"" + list.get(i).getAllvc4() + "\" usrvc4=\""
					+ list.get(i).getUsrvc4() + "\" usrvc12=\""
					+ list.get(i).getUsrvc12() + "\" freevc4=\""
					+ list.get(i).getFreevc4() + "\" rate=\""
					+ rate + "\"></item>";
		}

		xml += "</list>";

		return xml;
	}
	
	public String get2MPackStatus(String equipcode, String frameserial,
			String slotserial, String packserial) {

		int index = 0;
		int end = 50;
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		map.put("index", index);
		map.put("end", end);
		PortUseStatsModel portUseStatsModel=new PortUseStatsModel();
		String xml = "<list>";

		List<PortUseStatsModel> list = equipPackDao.get2MPackStatus(map);
		for (int i = 0; i < list.size(); i++) {
			xml += "\n"+"<item equipcode=\""+list.get(i).getEquipcode()
			+"\" portnum=\""+(int)list.get(i).getPortnum()
			+"\" portusenum=\""+(int)list.get(i).getPortusenum()
			+"\" rate=\""+list.get(i).getPortuserate()
			+"\"></item>";
		}

		xml += "</list>";

		return xml;
	}
	
	// 王讲斌 机盘信息  获取端口属性
	public  LogicPortModel  getPortProperty(String logicport) {
		HttpServletRequest request = FlexContext.getHttpRequest();			
		WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao)ctx.getBean("logDao");
		logDao.createLogEvent("查询", "机盘管理视图", "查询端口属性", "", request);
		return equipPackDao.getPortPropertyInfo(logicport);
    }
	public String getZPort(String a_port)
	{
		return equipPackDao.getZPort(a_port);//
	}
	// 王讲斌 获取端口属性上combobox值
	public String getFromXTBM(String xtbm){
		String xml = "<names>";
		HashMap<String,String> resultMap = new HashMap<String,String>();
		List list = equipPackDao.GetItemXTBM(xtbm);
		for(Iterator it = list.iterator();it.hasNext();){
			resultMap = (HashMap)it.next();
			String xtbm_t = (String)resultMap.get("XTBM") != null ? (String)resultMap.get("XTBM") : "";
			String xtxx = (String)resultMap.get("XTXX") != null ? (String)resultMap.get("XTXX") : "";
			xml +=  "<name label =\""+xtxx+"\"code=\""+xtbm_t+"\"/>";
		}
		xml +="</names>";
		return xml;
	}
	public boolean updatePortProperties(LogicPortModel logicPort){
		
		return equipPackDao.updatePortProperties(logicPort);
	}
	

	/**
	 * 查询端口是否占用
	 * @param portid 逻辑端口编号
	 * @return 返回值为0:未占用；返回值大于0:占用
	 */
	public int getPortStatusFlex(String portid){
		int totalCount = equipPackDao.getPortStatusFlex(portid);
		return totalCount;
	}
	//获取光口显示列表
	public List<OpticalPortListModel> getOpticalPortList(String equipcode, String frameserial, String slotserial,String packserial){
		ParameterModel model = new ParameterModel();
		model.setEquipcode(equipcode);
		model.setFrameserial(frameserial);
		model.setPackserial(packserial);
		model.setSlotserial(slotserial);
		List<OpticalPortListModel> qLst = new ArrayList<OpticalPortListModel>();  
		qLst = equipPackDao.getOpticalPortList(model);
		
		return qLst;
	}
	
	// 根据设备编码和逻辑端口编号查询光口详情
	public 	 OpticalPortDetailModel getOpticalPortDetail(String equipcode,String logicport){
		Map<String,String> map = new HashMap<String,String>();
		map.put("equipcode", equipcode);
		map.put("logicport", logicport);
		return equipPackDao.getOpticalPortDetail(map);
	}
	
	//获取光口占用状态
	public List<OpticalPortStatusModel> getOpticalPortStatus(String logicport){
		List<OpticalPortStatusModel> qLst = new ArrayList<OpticalPortStatusModel>();  
		qLst = equipPackDao.getOpticalPortStatus(logicport);
		return qLst;
		
	}
	
	//获取端口信息-显示端口图
	public List<LogicPortModel> getLogicPortFlex(String equipcode, String frameserial, String slotserial,String packserial){
	//public String getLogicPortFlex(){
		ParameterModel model = new ParameterModel();
		model.setEquipcode(equipcode);
		model.setFrameserial(frameserial);
		model.setPackserial(packserial);
		model.setSlotserial(slotserial);
		List<LogicPortModel> qLst_temp = new ArrayList<LogicPortModel>();  
		List<LogicPortModel> qLst = new ArrayList<LogicPortModel>(); 

		String portserial = "";
		try {
			qLst_temp = equipPackDao.getLogicPortFlex(model);
			for(LogicPortModel portModel:qLst_temp){
				portserial = portModel.getPortserial();
				if(portserial.contains("2M")){
					qLst = equipPackDao.getLogicPort2MFlex(model);
				}
				else if(portserial.matches("^[0-9]*$")){
					qLst = equipPackDao.getLogicPortNot2MFlex(model);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return qLst;	

	}
	//查询端口上承载业务的电路号
	public String getPortServiceFlex(String portserialno){
		String circuitcode = equipPackDao.getPortServiceFlex(portserialno);
		return circuitcode;
	}
	
	
	public List getPortAlarm(String equipcode, String frameserial, String slotserial,String packserial){
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
	    String user_id=null;
	    if(user!=null){
	    	user_id = user.getUser_id();
	    }
		
	    //根据设备编码、机框机槽序号查找机盘序号
	    String newPackserial = this.equipPackDao.getPackserialByIds(equipcode, frameserial, slotserial);
	    
		return this.equipPackDao.getEquipPortAlarm(equipcode, frameserial, slotserial, newPackserial,user_id);
	}
	//画电口图
	public List drawPort(String equipcode, String frameserial, String slotserial,String packserial){
		List<LogicPortModel> qLst = new ArrayList<LogicPortModel>(); 
		ParameterModel model = new ParameterModel();
		model.setEquipcode(equipcode);
		model.setFrameserial(frameserial);
		model.setPackserial(packserial);
		model.setSlotserial(slotserial);
		try
		{
			qLst = equipPackDao.getLogicPortFlex(model);		
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		return qLst;
	}
	
	public List getPackType(String equipcode,String frameserial,String slotserial,String packserial){
		List lst=new ArrayList();
		try{
			lst=this.equipPackDao.getPackType(equipcode, frameserial, slotserial, packserial);
		}catch(Exception ex){
			
		}
		return lst; 
	}
}
