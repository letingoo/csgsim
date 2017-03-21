package com.metarnet.mnt.alarmmgr.dwr;

//import java.io.File;
//import java.io.IOException;
import indexEvaluation.model.DateUtil;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;
//import java.util.Date;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ZipExcel;

import sysManager.log.dao.LogDao;
import sysManager.user.model.UserModel;

//import javax.servlet.ServletConfig;
//import javax.servlet.http.HttpServletRequest;

//import jxl.write.WriteException;


//import mapResourcesInfo.component.FiberCustomizedExcel;
//import mapResourcesInfo.component.ZipExcel;
//import mapResourcesInfo.model.FiberDetailsModel;

import com.client.VerticallyImpl;
import com.client.model.ConditionAlarm;
import com.client.model.DataBaseConf;
import com.metarnet.mnt.alarmmgr.dao.AlarmManagerDAO;
import com.metarnet.mnt.alarmmgr.model.AlarmInfos;
import com.metarnet.mnt.alarmmgr.model.AlarmLevelCount;
import com.metarnet.mnt.alarmmgr.model.AlarmResult;


import db.ForTimeBaseDAO;
import flex.messaging.FlexContext;


//import flex.messaging.FlexContext;

public class AlarmManagerDwr {
	HttpServletRequest request = FlexContext.getHttpRequest();
	WebApplicationContext ctx = WebApplicationContextUtils
			.getWebApplicationContext(FlexContext.getServletContext());
	
	private AlarmManagerDAO alarmManagerDao;

	public AlarmManagerDAO getAlarmManagerDao() {
		return alarmManagerDao;
	}

	public void setAlarmManagerDao(AlarmManagerDAO alarmManagerDao) {
		this.alarmManagerDao = alarmManagerDao;
	}

	public List getTranssysName(String xtype) {
		return alarmManagerDao.getTranssysName(xtype);
	}

	public AlarmLevelCount getcount(String dealperson, String isAck,
			String alarmlevel, String alarmdesc, String alarmObj,
			String ackperson, String belongportcode, String belongportobject,
			String belongpackobject, String iscleared, String belongshelfcode,
			String belongequip, String vendor, String beginTime,
			String endTime, String isRootAlarm,String table,String belongtransys,String alarmman,String queryFlag,String interposename) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
		String query="";
	    String user_id=null;
	    if(user!=null){
	    	user_id = user.getUser_id();
	    }
	    if("1".equals(queryFlag)){//queryFlag 中增加了其他查询条件 割接告警查询中 为了最小修改代码   在queryFlag中新增其他属性， 在impl文件中进行拆分
			query="";
	    }else{
	    	query="1";
	    }
		if("1".equals(iscleared)){
			query="";
			queryFlag="";
		}
		return this.alarmManagerDao.getcount(dealperson, isAck, alarmlevel,
				alarmdesc, alarmObj, ackperson, belongportcode,
				belongportobject, belongpackobject, iscleared, belongshelfcode,
				belongequip, vendor, beginTime, endTime, isRootAlarm,table,belongtransys,user_id,queryFlag,query,interposename);
	}
	public AlarmLevelCount getcountBySearch(AlarmInfos info) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
		String alarm_man ="root";
		String query="";
		if(user !=null){
			alarm_man=user.getUser_id();
		}
		if("1".equals(info.getQueryFlag())){
			query="";
	    }else{
	    	query="1";
	    }
		if("1".equals(info.getIscleared())){
			query="";
			info.setQueryFlag("");
		}
		info.setQuery(query);
		info.setAlarmman(alarm_man);
		return this.alarmManagerDao.getcountBySearch(info);
	}

	public AlarmResult getAlarmInfos(AlarmInfos info) {
		AlarmResult ars = new AlarmResult();
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
		String alarm_man ="root";
		String query="";
		if(user !=null){
			alarm_man=user.getUser_id();
		}
		if("1".equals(info.getQueryFlag())){
			query="";
	    }else{
	    	query="1";
	    }
		info.setQuery(query);
		info.setAlarmman(alarm_man);
		if("1".equals(info.getIscleared())){
			//历史告警查询不按人员
			info.setQuery("");
			info.setQueryFlag("");
		}
		
		ars.setList(this.alarmManagerDao.getAlarms(info));
		ars.setAlarmcount(this.alarmManagerDao.getAlarmCount(info));
		// ars.setInitGridMenu(this.alarmManagerDao.getMenu());
		return ars;
	}
	public AlarmResult getAlarmDutyid(AlarmInfos info) {
		AlarmResult ars = new AlarmResult();
		ars.setList(this.alarmManagerDao.getAlarmsDutyid(info));
		ars.setAlarmcount(this.alarmManagerDao.getAlarmDutyidCount(info));
		// ars.setInitGridMenu(this.alarmManagerDao.getMenu());
		return ars;
	}

	public AlarmResult getKeyBusiness(String alarmnumber, String circuitname,
			String isacked, String start, String end) {

		AlarmResult ars = new AlarmResult();
		ars.setGetKeyBusinessList(this.alarmManagerDao.getKeyBusiness(
				alarmnumber, circuitname, isacked, start, end));
		ars.setGetKeyBusinessCount(this.alarmManagerDao.getKeyBusinessCount(
				alarmnumber, circuitname, isacked));
		return ars;
	}

	public AlarmResult getKeyBusiness_hz(String circuitname, String station1,
			String station2, String type, String powerline, String start,
			String end) {

		AlarmResult ars = new AlarmResult();
		try {
			if (type.equalsIgnoreCase("opera")) {
				ars.setGetKeyBusinessList(this.alarmManagerDao
						.getKeyBusiness_hz1(circuitname, station1, station2,
								powerline, start, end));
				ars.setGetKeyBusinessCount(this.alarmManagerDao
						.getKeyBusinessCount_hz1(circuitname, station1,
								station2, powerline));
			} else if (type.equalsIgnoreCase("operatype")) {
				ars.setGetKeyBusinessList(this.alarmManagerDao
						.getKeyBusiness_hz_OperaType(circuitname, station1,
								station2, powerline, start, end));
				ars.setGetKeyBusinessCount(this.alarmManagerDao
						.getKeyBusinessCount_hz_OperaType(circuitname,
								station1, station2, powerline));
			} else {
				ars.setGetKeyBusinessList(this.alarmManagerDao
						.getKeyBusiness_hz(circuitname, station1, station2,
								powerline, start, end));
				ars.setGetKeyBusinessCount(this.alarmManagerDao
						.getKeyBusinessCount_hz(circuitname, station1,
								station2, powerline));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ars;
	}

	public String getCircuitCount(String alarmnu) {

		String str = this.alarmManagerDao.getCircuitCount(alarmnu);
		if(str==null||"".equals(str)){
			str="0";
		}
		return str;
	}

	public List getAlarmConfirm(String alarmid) {
		return alarmManagerDao.getAlarmConfirm(alarmid);
	}

	public String updateAlarmConfirm(String alarmid, String operPerson,
			String ackcontent) {
		return alarmManagerDao.updateAlarmConfirm(alarmid, operPerson,
				ackcontent);
	}

//	public String ExportExcel(String labels, String titles[],
//			String circuitname, String station1, String station2, String type,
//			String powerline) {
//		String str = null;
//		str = new ExportExcel(this.alarmManagerDao).ExportEXCEL(labels, titles,
//				circuitname, station1, station2, powerline, "中断电路信息");
//		return str;
//	}
	
	public String delAlarmInfos(String alarmnumber){
		String result ="fail";
		try {
			this.alarmManagerDao.deleteAlarmByAlarmNumber(alarmnumber);
			result = "SUCCESS";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public List getQueryVisiable(String tablename){
		
		
		List list = alarmManagerDao.queryVisiable(tablename);
		
		return list;
	}
	
	//告警查询导出（选择列导出）  add by hf
	@SuppressWarnings("unchecked")
	public String AlarmManageResSelectExportEXCEL(String labels, String[] titles , String types,ArrayList al){
		String path = null;// 返回到前台的路径
		List<String> AlarmManage = new ArrayList<String>();
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
//		String filename = types + "-" + date + ".xls";
		String filename = date + ".xls";
	
		for(int i = 0;i<al.size();i++){
			Map<String, String> map = (HashMap<String, String>) al.get(i);
			String str = "";
			str += map.get("alarmlevelname") == null? " ##":map.get("alarmlevelname")+"##";
			str += map.get("firststarttime") == null ?" ##":map.get("firststarttime").toString()+"##";
			str += map.get("endtime")==null? " ##":map.get("endtime").toString()+"##";
			str += map.get("belongstation")==null? " ##":map.get("belongstation").toString()+"##";
			str += map.get("alarmdesc") == null? " ##":map.get("alarmdesc")+"##";
			str += map.get("alarmobjdesc") == null? " ##":map.get("alarmobjdesc")+"##";
			str += map.get("carrycircuit") == null? " ##":map.get("carrycircuit")+"##";
			str += map.get("vendorzh") == null? " ##":map.get("vendorzh")+"##";
			str += map.get("belongtransys") == null? " ##":map.get("belongtransys")+"##";
			str += map.get("area") == null? " ##":map.get("area")+"##";
			str += map.get("flashcount") == null? " ##":map.get("flashcount")+"##";
			str += map.get("acktime") == null? " ##":map.get("acktime")+"##";
			str += map.get("ackperson") == null? " ##":map.get("ackperson")+"##";
			str += map.get("isworkcase") == null? " ##":map.get("isworkcase")+"##";
			str += map.get("isbugno") == null? " ##":map.get("isbugno")+"##";
			str += map.get("ackcontent") == null? " ##":map.get("ackcontent")+"##";
//			str += map.get("isackedzh") == null? " ##":map.get("isackedzh")+"##";
			str += map.get("dealresult") == null? " ##":map.get("dealresult")+"##";
			str += map.get("isfilter") == null? " ##":map.get("isfilter")+"##";
			str += map.get("unit") == null? " ##":map.get("unit")+"##";
			str += map.get("dealperson") == null? " ##":map.get("dealperson")+"##";
//			str += map.get("isrootalarmzh") == null? " ##":map.get("isrootalarmzh")+"##";
//			str += map.get("laststarttime") == null? " ##":map.get("laststarttime").toString().substring(0,map.get("laststarttime").toString().length()-2)+"##";
//			str += map.get("endtime") == null ?" ##":map.get("endtime").toString()+"##";
			AlarmManage.add(str);
		}
		
		CustomizedExcel oe = new CustomizedExcel(servletConfig);
		try {
			RealPath = this.getRealPath();
			File f = new File(RealPath);
			if (!f.exists()) {
				f.mkdir();
			}
			oe.WriteExcel_Alarm(RealPath + filename, labels, titles,
					AlarmManage);
		} catch (Exception e) {
			e.printStackTrace();
		}
		path = "exportExcel/" + filename;
	
		return path;
	}
	//告警查询导出（当前页） 
	public String AlarmManageResExportEXCEL(String labels, String[] titles,
			String types,AlarmInfos model){
		
		String path = null;// 返回到前台的路径
		List<String> AlarmManage = new ArrayList<String>();
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
//		String filename = types + "-" + date + ".xls";
		String filename = date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
//		int size = mt.getAlarmInfoCount(model);
		int size = Integer.parseInt(model.end) - Integer.parseInt(model.start) ;
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
		String alarm_man ="root";
		String query="";
		if(user !=null){
			alarm_man=user.getUser_id();
		}
		if("1".equals(model.getQueryFlag())){
			query="";
	    }else{
	    	query="1";
	    }
		model.setQuery(query);
		model.setAlarmman(alarm_man);
		List<HashMap> items = this.alarmManagerDao.getAlarms(model);
		try {
			for (int i = 0; i < size; i++) {
				HashMap map = items.get(i);
				String str = "";
				str += map.get("ALARMLEVELNAME") == null? " ##":map.get("ALARMLEVELNAME")+"##";
				str += map.get("FIRSTSTARTTIME") == null ?" ##":map.get("FIRSTSTARTTIME").toString()+"##";
				str += map.get("ALARMTYPE")==null? " ##":map.get("ALARMTYPE").toString()+"##";
				str += map.get("INTERPOSENAME")==null? " ##":map.get("INTERPOSENAME").toString()+"##";
				str += map.get("ALARMOBJDESC") == null? " ##":map.get("ALARMOBJDESC")+"##";
				str += map.get("ALARMDESC") == null? " ##":map.get("ALARMDESC")+"##";
				str += map.get("VENDORZH") == null? " ##":map.get("VENDORZH")+"##";
				str += map.get("BELONGTRANSYS") == null? " ##":map.get("BELONGTRANSYS")+"##";
				str += map.get("BELONGSTATION")==null? " ##":map.get("BELONGSTATION").toString()+"##";
				str += map.get("AREA") == null? " ##":map.get("AREA")+"##";
				str += map.get("FLASHCOUNT") == null? " ##":map.get("FLASHCOUNT")+"##";
				str += map.get("ISWORKCASE") == null? " ##":map.get("ISWORKCASE")+"##";
				str += map.get("UNIT") == null? " ##":map.get("UNIT")+"##";
				str += map.get("ENDTIME")==null? " ##":map.get("ENDTIME")+"##";
				str += map.get("ACKPERSON") == null? " ##":map.get("ACKPERSON")+"##";
				str += map.get("ACKTIME") == null? " ##":map.get("ACKTIME")+"##";
				
				AlarmManage.add(str);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
//		if (size > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[size % 20000 == 0 ? size / 20000 + 1
//						: size / 20000 + 2];
//				for (int i = 0; i < list.length - 1; i++) {
//					CustomizedExcel ce = new CustomizedExcel(servletConfig);
//					list[i] = AlarmManage
//							.subList(
//									i * 20000 + 1,
//									(i + 1) * 20000 > AlarmManage.size() ? AlarmManage
//											.size()
//											: (i + 1) * 20000);
//					ce.WriteExcel_Alarm(RealPath + date + "-part" + i + ".xls",
//							labels, titles, list[i]);
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			ZipExcel zip = new ZipExcel();
//			try {
//				zip.zip(zipfilePath, zipfilePath + ".zip", "");
//			} catch (Exception e) {
//				
//				e.printStackTrace();
//			}
//			path = "exportExcel/"+ date + ".zip";
//		} else {
			CustomizedExcel oe = new CustomizedExcel(servletConfig);
			try {
				RealPath = this.getRealPath();
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				oe.WriteExcel_Alarm(RealPath + filename, labels, titles,
						AlarmManage);
			} catch (Exception e) {
				e.printStackTrace();
			}
			path = "exportExcel/" + filename;
//		}
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "告警模块", "告警管理导出", "", request);
		return path;
		
	}
	public static String getName() {
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd HH.mm.ss");
		return sDateFormat.format(new java.util.Date().getTime());
	}
	
	public String getRealPath() {
		String RealPath = null;// 绝对路径
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
			RealPath = fullPath.substring(0, fullPath.indexOf("WEB-INF"));//linux下的情况	

		RealPath += "exportExcel/";
		return RealPath;
	}
	public String queryAlarmWebService(String type){
		Boolean b=false;
		try{
			VerticallyImpl impl = VerticallyImpl.getInstance();
	        String namespace="http://metarnet";
	        String endpoint="http://10.50.15.99:80/SimWebservice/services/ServiceImp?wsdl";
	        String receiver="010201";
			/*设备*/ 
	        List<ConditionAlarm> List = new ArrayList<ConditionAlarm>();
		    ConditionAlarm con = new ConditionAlarm();
		    
		    DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			long now = System.currentTimeMillis();
			long newnow = now+30*24*60*60*1000;
			if("0".equals(type)){
				newnow= now-24*60*60*1000;
			}
			
			Calendar calendar = Calendar.getInstance();
			calendar.setTimeInMillis(newnow);
			
		    if("0".equals(type)){
		    	con.setVar_0(formatter.format(calendar.getTime()));
			    con.setVar_1(DateUtil.getDateString(new Date(), "yyyy-MM-dd HH:mm:ss"));
		    }
		    else{
		    	con.setVar_2("1");
		    }
		    List.add(con);
		    
		    HttpServletRequest request = FlexContext.getHttpRequest();
			HttpSession session = request.getSession();
			String username = (String) session.getAttribute("currversion");
		    
		    DataBaseConf base = new DataBaseConf();
			base.setHost("127.0.0.1");
			base.setPort("1521");
			base.setSid("orcl");
			base.setUser(username);
			base.setPwd(username);
			b =  impl.RequestGetAlarm(namespace, endpoint, receiver, List,base);
//		    b = impl.RequestGetAlarm(namespace, endpoint, receiver, List);
		}catch(Exception e){
			e.printStackTrace();
		}
	    return b+"";
	}
	
//	public static void main(String[] args){
//		 VerticallyImpl impl = VerticallyImpl.getInstance();
//	        String namespace="http://metarnet";
//	        String endpoint="http://10.50.15.99/SimWebservice/services/ServiceImp?wsdl";
//			String receiver="010201";
//			/*设备*/ 
//		    List<Condition> List = new ArrayList<Condition>();
//		    Condition con = new Condition();
//		    con.setVar_0("2013-09-11 00:00:00");
//		    con.setVar_1("2013-09-12 00:00:00");
//		   
//		    List.add(con);
//		    
//		    impl.RequestGetAlarm(namespace, endpoint, receiver, List);
//   }

	public AlarmResult  getAlarmInfoLst(AlarmInfos model){
		AlarmResult result = new AlarmResult();
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
		String alarm_man ="root";
		String query="";
		if(user !=null){
			alarm_man=user.getUser_id();
		}
		if("1".equals(model.getQueryFlag())){
			query="";
	    }else{
	    	query="1";
	    }
		model.setQuery(query);
		model.setAlarmman(alarm_man);
		if("1".equals(model.getIscleared())){
			//历史告警查询不按人员
			model.setQuery("");
			model.setQueryFlag("");
		}
		result.setAlarmcount(this.alarmManagerDao.getAllRootAlarmInfoLstCount(model));
		result.setList(this.alarmManagerDao.getAllRootAlarmInfosLst(model));
		
		return result;
	}
	
	public String updateAlarmAckStatus(String alarmid){
		String result="";
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
		String ackman="root";
		if(user!=null){
			ackman = user.getUser_id();
		}
		String acktime = DateUtil.getDateString(new Date(), "yyyy-MM-dd HH:mm:ss");
		Map<String,String> map = new HashMap<String,String>();
		map.put("acktime", acktime);
		map.put("ackperson", ackman);
		map.put("alarmnumber", alarmid);
		try {
			this.alarmManagerDao.updateAlarmAckStatus(map);
			result="suc";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result="fail";
		}
		return result;
	}
	
}
