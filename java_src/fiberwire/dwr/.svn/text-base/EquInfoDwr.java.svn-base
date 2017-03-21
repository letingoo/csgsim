package fiberwire.dwr;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;

import jxl.write.WriteException;
import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ZipExcel;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import sysManager.log.dao.LogDao;
import carryOpera.model.ResultModel;
import db.BaseDAO;
import fiberwire.dao.EquInfoDAO;
import fiberwire.model.EquInfoModel;
import flex.messaging.FlexContext;
//网络拓扑图，供设备信息处理ActionScript直接调用的java类
/**
 * @author yangzhong
 * @time 2013-7-15
 * 
 */

public class EquInfoDwr {
	private EquInfoDAO equInfoDao;
	public EquInfoDAO getEquInfoDao() {
		return equInfoDao;
	}

	public void setEquInfoDao(EquInfoDAO equInfoDao) {
		this.equInfoDao = equInfoDao; 
		
	}

	
	public EquInfoModel getEquInfoByEquCode(String equCode)
	{
        return this.equInfoDao.getEquInfoByEquCode(equCode);
        
	}
	
	
	public void saveEquInfo(EquInfoModel model)
	{
		try
		{
			
				this.equInfoDao.updateEquInfo(model);
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	public String insertEquInfo(EquInfoModel model)
	{
		return this.equInfoDao.insertEquInfo(model);
	}

	public String getFromXTBM(String xtbm){
		return equInfoDao.getFromXTBM(xtbm);
	}
	
	public String getSystems(){
		return equInfoDao.getSystems();
	}
	
	//查看站内设备列表
	public ResultModel getDeviceByStationCode(String stationcode,int start,int end)
	{
		ResultModel result =new ResultModel();
		
		try
		{
			result.setTotalCount(this.equInfoDao.getDeviceCountByStationcode(stationcode));
			result.setOrderList(this.equInfoDao.getDeviceList_Flex(stationcode,start,end));
		} 
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return result;
	}
	
	
	
	public String getCarryOperaN1(String equipcode){
		
		String xml = "<list>";
		HashMap map = new HashMap();
		try {			
			List<HashMap> qLst = equInfoDao.getCarryOperaN1(equipcode);
			for(int i=0;i<qLst.size();i++){
				map = qLst.get(i);
				xml += "\n"+"<item  circuitcode=\""+map.get("CIRCUITCODE")
				+"\" portserialno1=\""+map.get("PORTSERIALNO1")+"\" slot1=\""+map.get("SLOT1")
				+"\" portserialno2=\""+map.get("PORTSERIALNO2")+"\" slot2=\""+map.get("SLOT2")
				+"\" rate=\""+map.get("RATE")
				+"\" username=\""+map.get("USERNAME")
				+"\" transrate=\""+map.get("TRANSRATE")
				+"\" remark=\""+map.get("REMARK")
				+"\"></item>";
			}
		
			xml += "</list>";
			HttpServletRequest request = FlexContext.getHttpRequest();			
			WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao)ctx.getBean("logDao");
			logDao.createLogEvent("查询", "系统组织图", "查询设备业务信息", "", request);
			return xml;
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return null;
		
	}

	
	public String getDeviceSummaryByVendorAndType(String stationcode)
	{		  
		String xml="";
		xml=getDeviceSummaryByVendor(stationcode)+"#"+getDeviceSummaryByType(stationcode);
		return xml;
    }	
	
	
	//设备按厂家进行统计分析
	public String getDeviceSummaryByVendor(String stationcode)
	{
		String xml="";
		List<HashMap> list=this.equInfoDao.getDeviceSummaryByVendor(stationcode);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"vendor\":\""+map.get("VENDOR")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	
	//设备按设备类型进行统计分析
	public String getDeviceSummaryByType(String stationcode)
	{
		String xml="";
		List<HashMap> list=this.equInfoDao.getDeviceSummaryByType(stationcode);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"type\":\""+map.get("EQUIPTYPE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	
	
	
	public String getCarryOperaByPortN1(String logicport)
	{
		String xml = "<list>";
		HashMap map = new HashMap();
		try {			
			List<HashMap> qLst = equInfoDao.getCarryOperaByLogicPortN1(logicport);
			for(int i=0;i<qLst.size();i++){
				map = qLst.get(i);
				xml += "\n"+"<item circuitcode=\""+map.get("CIRCUITCODE")
				+"\" portserialno1=\""+map.get("PORTSERIALNO1")+"\" slot1=\""+map.get("SLOT1")
				+"\" portserialno2=\""+map.get("PORTSERIALNO2")+"\" slot2=\""+map.get("SLOT2")
				+"\" rate=\""+map.get("RATE")
				+"\" username=\""+map.get("USERNAME")
				+"\" transrate=\""+map.get("TRANSRATE")
				+"\" remark=\""+map.get("REMARK")+"\"></item>";
			}
		
			xml += "</list>";
			return xml;
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return null;
		
	}


	public String getCarryOperaByTopolinkN1(String label)
	{
		String xml = "<list>";
		HashMap map = new HashMap();
		try {			
			List<HashMap> qLst = equInfoDao.getCarryOperaByTopolinkN1(label);
			for(int i=0;i<qLst.size();i++){
				map = qLst.get(i);
				xml += "\n"+"<item circuitcode=\""+map.get("CIRCUITCODE")
				+"\" portserialno1=\""+map.get("PORTSERIALNO1")+"\" slot1=\""+map.get("SLOT1")
				+"\" portserialno2=\""+map.get("PORTSERIALNO2")+"\" slot2=\""+map.get("SLOT2")
				+"\" rate=\""+map.get("RATE")
				+"\" username=\""+map.get("USERNAME")
				+"\" transrate=\""+map.get("TRANSRATE")
				+"\" remark=\""+map.get("REMARK")+"\"></item>";
			}
		
			xml += "</list>";
			return xml;
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	

	public Boolean hasEquipPack(String equipcode){
		List<HashMap> list = this.equInfoDao.hasEquipPack(equipcode);
		if(list.size() > 0)
			return true;
		return false;
	}
	
	public void delEquip(String equipcode){
		this.equInfoDao.delEquip(equipcode);
	}
	public String getPort(String equipcode, String textname, String rate,
			String parentnode, String nodeid, String tree) {

		String parentID = parentnode;
		String xml;
		Map portRate2Field = new HashMap();
		Map tsRateMap;
		String slotRate;
		boolean isLeaf = false;
		portRate2Field.put("ZY070101", "RATE2M");
		portRate2Field.put("ZY070103", "RATE45M");
		portRate2Field.put("ZY070105", "RATE155M");
		portRate2Field.put("ZY070106", "RATE622M");
		portRate2Field.put("ZY070107", "RATE2DOT5G");
		portRate2Field.put("ZY070108", "RATE10G");
		Map rate2Field = new HashMap();
		rate2Field.put("YW010201", "RATE2M");
		rate2Field.put("YW010202", "RATE45M");
		rate2Field.put("YW010203", "RATE155M");
		rate2Field.put("YW010204", "RATE622M");
		rate2Field.put("YW010205", "RATE2DOT5G");
		rate2Field.put("YW010206", "RATE10G");
		
		rate2Field.put("ZY110601", "RATE155M");
		rate2Field.put("ZY110602", "RATE622M");
		rate2Field.put("ZY110603", "RATE2DOT5G");
		rate2Field.put("ZY110604", "RATE10G");
//		rate2TsStatus.put("ZY110699", "YW010299");
		rate2Field.put("ZY110612", "RATE2M");
//		rate2Field.put("ZY110613", "TS45MSTATUS");
		
		Map rate2Capacode = new HashMap();
		rate2Capacode.put("YW010201", "ZY070101");
		rate2Capacode.put("YW010202", "ZY070103");
		rate2Capacode.put("YW010203", "ZY070105");
		rate2Capacode.put("YW010204", "ZY070106");
		rate2Capacode.put("YW010205", "ZY070107");
		rate2Capacode.put("YW010206", "ZY070108");
		
		rate2Capacode.put("ZY110601", "YW010203");
		rate2Capacode.put("ZY110602", "YW010204");
		rate2Capacode.put("ZY110603", "YW010205");
		rate2Capacode.put("ZY110604", "YW010206");
		rate2Capacode.put("ZY110699", "YW010299");
		rate2Capacode.put("ZY110612", "YW010201");
		rate2Capacode.put("ZY110613", "YW010210");
		
		Map rate2TsStatus = new HashMap();
		rate2TsStatus.put("YW010201", "TS2MSTATUS");
		rate2TsStatus.put("YW010202", "TS45MSTATUS");
		rate2TsStatus.put("YW010203", "TS155MSTATUS");
		rate2TsStatus.put("YW010204", "TS622MSTATUS");
		rate2TsStatus.put("YW010205", "TS2DOT5GSTATUS");
		rate2TsStatus.put("YW010206", "TS10GSTATUS");
		
//		rate2TsStatus.put("ZY110601", "TS155MSTATUS");
//		rate2TsStatus.put("ZY110602", "TS622MSTATUS");
//		rate2TsStatus.put("ZY110603", "TS2DOT5GSTATUS");
//		rate2TsStatus.put("ZY110604", "TS10GSTATUS");
////		rate2TsStatus.put("ZY110699", "YW010299");
//		rate2TsStatus.put("ZY110612", "TS2MSTATUS");
////		rate2TsStatus.put("ZY110613", "TS45MSTATUS");
		
		// 初始化资源数的第一层节点（端口类型：线路口，支路口
		if (tree.equalsIgnoreCase("root")) {
			xml = executeRootForPortType(equipcode, rate2Capacode.get(rate)
					.toString());
			return xml;
		}
		// added by slzh at 20091217 for 初始化树的第二层节点（按端口的速率类型�?
		if (tree.equalsIgnoreCase("1") && !nodeid.startsWith("VC4-")) {
			xml = executeGetEquipPort(equipcode, nodeid, rate2Capacode
					.get(rate).toString());
			return xml;
		}
		// added by slzh at 20091217 for 初始化树的第三层节点（端口信息）
		if (tree.equalsIgnoreCase("2") && !nodeid.startsWith("VC4-")) {
			xml = executeGetPortInfo(equipcode, nodeid, rate2Capacode.get(rate)
					.toString());
			return xml;
		}

		return null;
	}
	public String executeRootForPortType(String equipcode, String rate) {
		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		String xml = "";
		try {
			String sql = "select * from (select distinct porttypecode,porttypename from v_selectts$oc v where v.equipcode=lpad('"
					+ equipcode
					+ "',20,'0') and v.capacode>'"
					+ rate
					+ "'  and v.capacode<>'ZY070112'"
					+ "union select distinct l.y_porttype porttypecode,x.xtxx porttypename from equiplogicport l,xtbm x where "
					+ "l.equipcode=lpad('"
					+ equipcode
					+ "',20,'0') and  x.xtbm=l.y_porttype "
					+ "and l.x_capability='"
					+ rate
					+ "' and l.x_capability<>'ZY070112' and l.logicport not in"
					+ "(select aptp portcode from cc where pid='"
					+ equipcode
					+ "' union select zptp portcode from cc where pid='"
					+ equipcode + "')) order by porttypecode";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);

			while (rs.next()) {
				xml += "<folder state='0' label='"
						+ rs.getString("porttypename")
						+ "' id='"
						+ rs.getString("porttypecode")
						+ "' disabled=\"true\" tree='1'  isBranch=\"true\" leaf='false' >";
				xml += "</folder>";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.closeConnection(c, s, rs);
		}

		return xml;

	}
	
	public String executeGetEquipPort(String equipcode, String nodeType,
			String rate) {
		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		String xml = "";
		try {
			String sql = "select * from (select distinct capacode,capaname from v_selectts$oc v where v.equipcode=lpad('"
					+ equipcode
					+ "',20,'0') and porttypecode='"
					+ nodeType
					+ "' and capacode>'"
					+ rate
					+ "' union "
					+ "select distinct l.x_capability capacode,x.xtxx capaname from equiplogicport l,xtbm x where "
					+ "l.equipcode=lpad('"
					+ equipcode
					+ "',20,'0') and l.y_porttype='"
					+ nodeType
					+ "' and l.x_capability=x.xtbm "
					+ "and l.x_capability='"
					+ rate
					+ "' and l.x_capability<>'ZY070112' and l.logicport not in (select aptp portcode from cc where pid='"
					+ equipcode
					+ "' union select zptp portcode from cc where pid='"
					+ equipcode + "'))order by capacode desc";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);

			while (rs.next()) {
				xml += "<folder state='0' label='"
						+ rs.getString("capaname")
						+ "' id='"
						+ rs.getString("capacode")
						+ "' disabled=\"true\"  isBranch=\"true\" leaf='false' tree='2' >";
				xml += "</folder>";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.closeConnection(c, s, rs);
		}

		return xml;
	}
	
	public String executeGetPortInfo(String equipCode, String nodeType,
			String rate) {

		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		Map rate2Capacode = new HashMap();
		rate2Capacode.put("YW010201", "ZY070101");
		rate2Capacode.put("YW010202", "ZY070103");
		rate2Capacode.put("YW010203", "ZY070105");
		rate2Capacode.put("YW010204", "ZY070106");
		rate2Capacode.put("YW010205", "ZY070107");
		rate2Capacode.put("YW010206", "ZY070108");
		
		rate2Capacode.put("ZY110601", "YW010203");
		rate2Capacode.put("ZY110602", "YW010204");
		rate2Capacode.put("ZY110603", "YW010205");
		rate2Capacode.put("ZY110604", "YW010206");
		rate2Capacode.put("ZY110699", "YW010299");
		rate2Capacode.put("ZY110612", "YW010201");
		rate2Capacode.put("ZY110613", "YW010210");
		String xml = "";
		try {
			String sql = "select * from (select distinct logicport,getportlabelnew(logicport) portname,capacode from v_selectts$oc v where v.equipcode=lpad('"
					+ equipCode
					+ "',20,'0') and capacode='"
					+ nodeType
					+ "' minus select distinct logicport,getportlabelnew(logicport) portname,x_capability capacode from equiplogicport "
					+ "where equipcode=lpad('"
					+ equipCode
					+ "',20,'0') and x_capability='"
					+ rate
					+ "' and logicport in(select aptp portcode from cc "
					+ "where pid='"
					+ equipCode
					+ "' union select zptp portcode from cc where pid='"
					+ equipCode + "'))order by getportlabelnew(logicport)";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);

			while (rs.next()) {

				if (rs.getString("capacode").equalsIgnoreCase(rate)) {
					xml += "<folder state='0' label='"
							+ rs.getString("portname")
							+ "' id='port"
							+ rs.getString("logicport")
							+ "' portcode='"
							+ rs.getString("logicport")
							+ "' disabled=\"true\"  isBranch=\"false\" leaf='true' >";
					xml += "</folder>";
				} else if (rate.equalsIgnoreCase("port")) {
					xml += "<folder state='0' label='"
							+ rs.getString("portname")
							+ "' id='port"
							+ rs.getString("logicport")
							+ "' portcode='"
							+ rs.getString("logicport")
							+ "' disabled=\"true\"  isBranch=\"false\" leaf='true' >";
					xml += "</folder>";
				} else {
					xml += "<folder state='0' label='"
							+ rs.getString("portname")
							+ "' id='port"
							+ rs.getString("logicport")
							+ "' portcode='"
							+ rs.getString("logicport")
							+ "' disabled=\"true\"  isBranch=\"fasle\" leaf='true' >";
					xml += "</folder>";
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.closeConnection(c, s, rs);
		}

		return xml;
	}
	public String DeviceListExportEXCEL(String stationcode,String labels,String[]titles){
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", labels, "设备列表导出", "", request);
		
		Date d = new Date();
		String path = null;// 返回到前台的路径
		List content=new ArrayList();
	
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String date = sDateFormat.format(new java.util.Date());
		String filename = date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
		int count=0;
		List<EquInfoModel> deviceList = null;
		try
		{
			count=this.equInfoDao.getDeviceCountByStationcode(stationcode);
			deviceList=this.equInfoDao.getDeviceList_Flex(stationcode,0,count);	
		for (int i = 0; i < count; i++) 
		{
			List newcolmn = new ArrayList();
			newcolmn.add(deviceList.get(i).getEquipname());
			newcolmn.add(deviceList.get(i).getX_vendor());
			newcolmn.add(deviceList.get(i).getX_model());
			newcolmn.add(deviceList.get(i).getEquiptype());
			newcolmn.add(deviceList.get(i).getNename());
			content.add(newcolmn);
		}
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
		RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));
		RealPath += "exportExcel/";				
		zipfilePath = RealPath;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		if (count > 20000)// 每20000条数据写一个EXCEL
		{
			try {
				zipfilePath = RealPath+ date;
				RealPath += date + "/";
			
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				List list[] = new List[count % 20000 == 0 ? count / 20000 + 1
						: count / 20000 + 2];
				for (int i = 0; i < list.length - 1; i++) {
					CustomizedExcel ce = new CustomizedExcel(servletConfig);
					list[i] = content.subList(i * 20000 + 1,
							(i + 1) * 20000 > content.size() ? content.size()
									: (i + 1) * 20000);
					ce.WriteExcel(RealPath + date + "-part" + i + ".xls",
							labels, titles, list[i]);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			ZipExcel zip = new ZipExcel();
			try {
				zip.zip(zipfilePath, zipfilePath + ".zip", "");
			} catch (Exception e) {
				e.printStackTrace();
			}
			path = "exportExcel/" + date + ".zip";
		} 
		else
		{
			CustomizedExcel ce = new CustomizedExcel(servletConfig);		
			File f = new File(RealPath);
			if (!f.exists()) {
				f.mkdir();
			}
			try {
				ce.WriteExcel(RealPath + filename, labels, titles, content);
			} catch (WriteException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			path = "exportExcel/" + filename;
		}
		
		return path;
	}
	
	public String getProvince() {
		String xml = "<names>";
		try
		{
			List lst =this.equInfoDao.getProvince();
			for (Object data : lst) {
				Map m= (Map)data;
				String xtbm_t = m.get("PROVINCE")!= null ? m.get("PROVINCE").toString(): "";
				String xtxx = m.get("PROVINCENAME")!= null ?m.get("PROVINCENAME").toString() : "";
				xml +=  "<name label =\""+xtxx+"\"code=\""+xtbm_t+"\"/>";
			}
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			xml +="</names>";
		}
		
		return xml;
	}
	//获取当前电路编号最大值
	public String getMaxCircuitcode(){
		String result="";
		result = this.equInfoDao.getMaxCircuitcode();
		return result;
	}

}
