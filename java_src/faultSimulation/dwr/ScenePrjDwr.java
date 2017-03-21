/**
 * @author xgyin
 * @time 2013-11-12
 * 
 */
package faultSimulation.dwr;

import indexEvaluation.model.DateUtil;

import java.awt.EventQueue;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.TimeZone;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import jxl.write.WriteException;
import login.dwr.LoginDwr;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import ScreenVideo.ScreenVideo;

import com.metarnet.mnt.alarmmgr.model.AlarmInfos;

import carryOpera.dao.CarryOperaDao;
import channelroute.model.CircuitroutModel;
import cn.swjtu.multisource.tools.ConstArgs;

import resManager.resBusiness.model.Circuit;
import resManager.resBusiness.model.CircuitChannel;
import resManager.resNet.model.Equipment;
import resManager.resNet.model.LogicPort;
import resManager.resNet.model.TopoLink;
import resManager.resNode.model.EquipPack;
import sysManager.function.model.OperationModel;
import sysManager.log.dao.LogDao;
import sysManager.user.model.UserModel;

import db.ForTimeBaseDAO;
import flex.messaging.FlexContext;

import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ZipExcel;
import netres.model.ComboxDataModel;
import netres.model.ResultModel;
import faultSimulation.dao.*;
import faultSimulation.model.ClassicFaultAlarmModel;
import faultSimulation.model.InterposeLogModel;
import faultSimulation.model.InterposeLogResult;
import faultSimulation.model.InterposeModel;
import faultSimulation.model.OperateList;
import faultSimulation.model.StdMaintainProModel;

public class ScenePrjDwr{
	private final static Log log = LogFactory.getLog(ScenePrjDwr.class);
	ApplicationContext ctx = WebApplicationContextUtils
			.getWebApplicationContext(FlexContext.getServletContext());
	private SceneMgrDAO sceneMgrDao;
	private CarryOperaDao carryOperaDao = (CarryOperaDao) ctx
			.getBean("carryOperaDao");

	public SceneMgrDAO getSceneMgrDao() {
		return sceneMgrDao;
	}

	public void setSceneMgrDao(SceneMgrDAO sceneMgrDao) {
		this.sceneMgrDao = sceneMgrDao;
	}

	public String getUserInfoByeqsearch(String user_name) {
		String result = "";
		List<ComboxDataModel> list = sceneMgrDao
				.getUserInfoByeqsearch(user_name);
		for (ComboxDataModel data : list) {
			result += "<userinfo id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"userinfo\" isBranch=\"false\"></userinfo>";
		}

		return result;
	}

	/**
	 * @author xgyin
	 * @name getAlarmInfoByeqsearch
	 * @use 获取告警信息
	 */
	public String getAlarmInfoByeqsearch(String user_name, String x_vendor) {
		String result = "";
		Map map = new HashMap();
		map.put("user_name", user_name);
		map.put("x_vendor", x_vendor);
		List<ComboxDataModel> list = sceneMgrDao.getAlarmInfoByeqsearch(map);
		for (ComboxDataModel data : list) {
			result += "<alarminfo id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"alarminfo\" isBranch=\"false\"></alarminfo>";
		}

		return result;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @name getAllInterpose
	 * @return ResultModel
	 */
	public List<HashMap<Object,Object>> getAllInterpose(InterposeModel model){
		return sceneMgrDao.getAllInterposeList(model);
	}
	public ResultModel getAllInterpose1(InterposeModel model) {
		ResultModel result = new ResultModel();
		try {
			result.setTotalCount(sceneMgrDao.getAllInterposeCount(model));
			result.setOrderList(sceneMgrDao.getAllInterposeList1(model));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "仿真模块", "查询事件干预", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("getAllInterpose", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param String
	 * @return string
	 * @name getFaultTypeByInterposeType
	 */
	public String getFaultTypeByInterposeType(String objid) {
		String result = "";
		List<ComboxDataModel> list = this.sceneMgrDao
				.getFaultTypeByInterposeType(objid);
		for (ComboxDataModel data : list) {
			result += "<faulttype id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"faulttype\" isBranch=\"false\"></faulttype>";
		}
		return result;
	}

	/**
	 * 
	 * @param objstr
	 * @returnobjid中若以";" 分组 则传入两个参数，在impl中进行分组 并取值， 如没有 则取本身值查询 用于查询故障类型；以干预类型
	 *                    （设备故障） 和资源类型 查询
	 */
	public String getFaultTypeInfoByInterposeType(String objstr,String sourceocde) {
		String result = "";
		List<ComboxDataModel> list = this.sceneMgrDao
				.getFaultTypeInfoByInterposeType(objstr,sourceocde);
		for (ComboxDataModel data : list) {
			result += "<faulttype id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"faulttype\" isBranch=\"false\"></faulttype>";
		}
		return result;
	}
	
	/**
	 * @author 尹显贵
	 * @name getEquipModelBySysCode
	 * @param String syscode
	 */
	public String getEquipModelBySysCode(String syscode){
		String result="";
		List<ComboxDataModel> list = this.sceneMgrDao
		.getEquipModelBySysCode(syscode);
		for (ComboxDataModel data : list) {
			result += "<equipmodel id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"equipmodel\" isBranch=\"false\"></equipmodel>";
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return string
	 * @name getInterposeType
	 */
	public String getInterposeType() {
		String result = "";
		List<ComboxDataModel> list = this.sceneMgrDao.getInterposeType();
		for (ComboxDataModel data : list) {
			result += "<interposetype id=\""
					+ data.getId()
					+ "\"label=\""
					+ data.getLabel()
					+ "\" name=\"interposetype\" isBranch=\"false\"></interposetype>";
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return String
	 * @name addInterpose
	 */
	public String addInterpose(InterposeModel model) {
		String result = "failed";
		try {
			// 往参演人员表中插入数据

			String interpose_id = sceneMgrDao.addInterpose(model);
			result = "success" + ";" + interpose_id;
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "故障仿真模块", "添加干预事件", "", request);
		} catch (Exception e) {
			result = "failed";
			e.printStackTrace();
			log.error("addInterpose", e);
		}
		return result;
	}
	
	/**
	 * @author 尹显贵
	 * @param InterposeModel
	 * @return string
	 **/
	public String addInterposePortCut(InterposeModel model){
		String result = "failed";
		try {
			// 往参演人员表中插入数据

			String interpose_id = sceneMgrDao.addInterposePortCut(model);
			result = "success" + ";" + interpose_id;
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "故障仿真模块", "添加干预事件", "", request);
		} catch (Exception e) {
			result = "failed";
			e.printStackTrace();
			log.error("addInterpose", e);
		}
		return result;
	}
	
	/**
	 * @name:autoAddInterpose
	 * param:InterposeModel
	 * @author 尹显贵
	 * 
	 */
	public String autoAddInterpose(InterposeModel model){
		String result = "failed";
		try {

			int faultNum = Integer.parseInt(model.getFaultNum());
			String equiptype = model.getEquiptype();
			//查找所有传输设备
			List<Equipment> equiplst = this.sceneMgrDao.getAllEquipment();
			
			
			model.setRemark("");
			model.setIsmaininterpose("");
			model.setUser_id(model.getUpdateperson());
			Random rand = new Random();
			int k = Math.abs(rand.nextInt(equiplst.size()-20));
			int akind=Math.abs(rand.nextInt(faultNum));//
			int zkind=faultNum-akind;
			if("设备".equals(equiptype)){
				//查找所有故障列表
				String type="设备";
				List<InterposeModel> faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				
				for(int p=0;p<faultNum;p++){
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setEquipcode(equiplst.get(k+p).getEquipcode());
					model.setResourcecode(equiplst.get(k+p).getEquipcode());
					model.setResourcename(equiplst.get(k+p).getEquiplabel());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"_"+p);
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				
			}else if("机盘".equals(equiptype)){
				String type="机盘";
				List<InterposeModel> faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				
				for(int p=0;p<faultNum;p++){
					String equipcode = equiplst.get(k+p).getEquipcode();
					//根据设备ID查找机盘
					model.setEquipcode(equipcode);
					//查找所有机盘
					List<EquipPack> packlst = this.sceneMgrDao.getAllEquippack(equipcode);
					int l = Math.abs(rand.nextInt(packlst.size()));
					model.setResourcecode(packlst.get(l).getSlotserial()+","+equipcode);
					model.setResourcename(packlst.get(l).getEquipname());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"_"+p);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				
			}else if("端口".equals(equiptype)){
				String type="端口";
				List<InterposeModel> faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				
				for(int p=0;p<faultNum;p++){
					String equipcode = equiplst.get(k+p).getEquipcode();
					//根据设备ID查找端口
					model.setEquipcode(equipcode);
					//查找所有端口
					List<LogicPort> portlst = this.sceneMgrDao.getAllLogicport(equipcode);
					int l = Math.abs(rand.nextInt(portlst.size()));
					model.setResourcecode(portlst.get(l).getEquipcode());
					model.setResourcename(portlst.get(l).getEquipname());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"_"+p);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				
			}else if("复用段".equals(equiptype)){
				String type="复用段";
				List<InterposeModel> faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				
				for(int p=0;p<faultNum;p++){
					String equipcode = equiplst.get(k+p).getEquipcode();
					//根据设备ID查找端口
						model.setEquipcode("");
					//复用段
					//查找设备对应所有复用段
					List<TopoLink> linklst = this.sceneMgrDao.getAllTopLink(equipcode);
					int l =0;
					if(linklst.size()==0){
						faultNum+=1;
						continue;
					}else{
						l= Math.abs(rand.nextInt(linklst.size()));
						model.setResourcecode(linklst.get(l).getLabel());
						model.setResourcename(linklst.get(l).getAlabel()+"-"+linklst.get(l).getZlabel());
						model.setInterposename("自动生成故障"+model.getUpdatetime()+"_"+p);
						int m = Math.abs(rand.nextInt(faultlst.size()));
						model.setFaulttype(faultlst.get(m).getFaulttypeid());
						model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
						model.setInterposetype(faultlst.get(m).getInterposetypeid());
						model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
						this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
						//激活故障
						result = this.setEventIsActive1(model);
						if("failed".equals(result)){
							return result;
						}
					}
				}
			}else if("设备+机盘".equals(equiptype)){
				String type="设备";
				List<InterposeModel> faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				model.setEquiptype("设备");
				for(int t=0;t<akind;t++){
					model.setEquipcode(equiplst.get(k+t).getEquipcode());
					model.setResourcecode(equiplst.get(k+t).getEquipcode());
					model.setResourcename(equiplst.get(k+t).getEquiplabel());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"设备_"+t);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				type="机盘";
				faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				model.setEquiptype("机盘");
				for(int s=0;s<zkind;s++){
					String equipcode = equiplst.get(k+s).getEquipcode();
					//根据设备ID查找机盘
					model.setEquipcode(equipcode);
					//查找所有机盘
					List<EquipPack> packlst = this.sceneMgrDao.getAllEquippack(equipcode);
					int l = Math.abs(rand.nextInt(packlst.size()));
					model.setResourcecode(packlst.get(l).getSlotserial()+","+equipcode);
					model.setResourcename(packlst.get(l).getEquipname());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"机盘_"+s);
					int m = Math.abs(rand.nextInt(faultlst.size()-20));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				
			}else if("设备+端口".equals(equiptype)){
				String type="设备";
				List<InterposeModel> faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				model.setEquiptype("设备");
				for(int t=0;t<akind;t++){
					model.setEquipcode(equiplst.get(k+t).getEquipcode());
					model.setResourcecode(equiplst.get(k+t).getEquipcode());
					model.setResourcename(equiplst.get(k+t).getEquiplabel());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"设备_"+t);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				type="端口";
				faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				model.setEquiptype("端口");
				for(int s=0;s<zkind;s++){
					String equipcode = equiplst.get(k+s).getEquipcode();
					//根据设备ID查找端口
					model.setEquipcode(equipcode);
					//查找所有端口
					List<LogicPort> portlst = this.sceneMgrDao.getAllLogicport(equipcode);
					int l = Math.abs(rand.nextInt(portlst.size()));
					model.setResourcecode(portlst.get(l).getEquipcode());
					model.setResourcename(portlst.get(l).getEquipname());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"端口_"+s);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				
			}else if("设备+复用段".equals(equiptype)){
				String type="设备";
				List<InterposeModel> faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				model.setEquiptype("设备");
				for(int t=0;t<akind;t++){
					model.setEquipcode(equiplst.get(k+t).getEquipcode());
					model.setResourcecode(equiplst.get(k+t).getEquipcode());
					model.setResourcename(equiplst.get(k+t).getEquiplabel());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"设备_"+t);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				type="复用段";
				model.setEquiptype("复用段");
				faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				for(int p=0;p<zkind;p++){
					String equipcode = equiplst.get(k+p).getEquipcode();
					//根据设备ID查找端口
						model.setEquipcode("");
					//复用段
					//查找设备对应所有复用段
					List<TopoLink> linklst = this.sceneMgrDao.getAllTopLink(equipcode);
					if(linklst.size()==0){
						zkind+=1;
						continue;
					}else{
						int l = Math.abs(rand.nextInt(linklst.size()));
						model.setResourcecode(linklst.get(l).getLabel());
						model.setResourcename(linklst.get(l).getAlabel()+"-"+linklst.get(l).getZlabel());
						model.setInterposename("自动生成故障"+model.getUpdatetime()+"复用段_"+p);
						int m = Math.abs(rand.nextInt(faultlst.size()));
						model.setFaulttype(faultlst.get(m).getFaulttypeid());
						model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
						model.setInterposetype(faultlst.get(m).getInterposetypeid());
						model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
						this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
						//激活故障
						result = this.setEventIsActive1(model);
						if("failed".equals(result)){
							return result;
						}
					}
				}
				
			}else if("机盘+端口".equals(equiptype)){
				String type="机盘";
				model.setEquiptype("机盘");
				List<InterposeModel> faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				for(int s=0;s<akind;s++){
					String equipcode = equiplst.get(k+s).getEquipcode();
					//根据设备ID查找机盘
					model.setEquipcode(equipcode);
					//查找所有机盘
					List<EquipPack> packlst = this.sceneMgrDao.getAllEquippack(equipcode);
					int l = Math.abs(rand.nextInt(packlst.size()));
					model.setResourcecode(packlst.get(l).getSlotserial()+","+equipcode);
					model.setResourcename(packlst.get(l).getEquipname());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"机盘_"+s);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				type="端口";
				model.setEquiptype("端口");
				faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				for(int s=0;s<zkind;s++){
					String equipcode = equiplst.get(k+s).getEquipcode();
					//根据设备ID查找端口
					model.setEquipcode(equipcode);
					//查找所有端口
					List<LogicPort> portlst = this.sceneMgrDao.getAllLogicport(equipcode);
					int l = Math.abs(rand.nextInt(portlst.size()));
					model.setResourcecode(portlst.get(l).getEquipcode());
					model.setResourcename(portlst.get(l).getEquipname());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"端口_"+s);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				
			}else if("机盘+复用段".equals(equiptype)){
				String type="机盘";
				model.setEquiptype("机盘");
				List<InterposeModel> faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				for(int s=0;s<akind;s++){
					String equipcode = equiplst.get(k+s).getEquipcode();
					//根据设备ID查找机盘
					model.setEquipcode(equipcode);
					//查找所有机盘
					List<EquipPack> packlst = this.sceneMgrDao.getAllEquippack(equipcode);
					int l = Math.abs(rand.nextInt(packlst.size()));
					model.setResourcecode(packlst.get(l).getSlotserial()+","+equipcode);
					model.setResourcename(packlst.get(l).getEquipname());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"机盘_"+s);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				type="复用段";
				model.setEquiptype("复用段");
				faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				for(int p=0;p<zkind;p++){
					String equipcode = equiplst.get(k+p).getEquipcode();
					//根据设备ID查找端口
						model.setEquipcode("");
					//复用段
					//查找设备对应所有复用段
					List<TopoLink> linklst = this.sceneMgrDao.getAllTopLink(equipcode);
					if(linklst.size()==0){
						zkind+=1;
						continue;
					}else{
						int l = Math.abs(rand.nextInt(linklst.size()));
						model.setResourcecode(linklst.get(l).getLabel());
						model.setResourcename(linklst.get(l).getAlabel()+"-"+linklst.get(l).getZlabel());
						model.setInterposename("自动生成故障"+model.getUpdatetime()+"复用段_"+p);
						int m = Math.abs(rand.nextInt(faultlst.size()));
						model.setFaulttype(faultlst.get(m).getFaulttypeid());
						model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
						model.setInterposetype(faultlst.get(m).getInterposetypeid());
						model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
						this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
						//激活故障
						result = this.setEventIsActive1(model);
						if("failed".equals(result)){
							return result;
						}
					}
				}
			}else{
				//端口+复用段
				String type="端口";
				model.setEquiptype("端口");
				List<InterposeModel> faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				for(int s=0;s<akind;s++){
					String equipcode = equiplst.get(k+s).getEquipcode();
					//根据设备ID查找端口
					model.setEquipcode(equipcode);
					//查找所有端口
					List<LogicPort> portlst = this.sceneMgrDao.getAllLogicport(equipcode);
					int l = Math.abs(rand.nextInt(portlst.size()));
					model.setResourcecode(portlst.get(l).getEquipcode());
					model.setResourcename(portlst.get(l).getEquipname());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"端口_"+s);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive(model);
					if("failed".equals(result)){
						return result;
					}
				}
				type="复用段";
				model.setEquiptype("复用段");
				faultlst = this.sceneMgrDao.getAllInterposeFaultList(type);
				for(int p=0;p<zkind;p++){
					String equipcode = equiplst.get(k+p).getEquipcode();
					//根据设备ID查找端口
						model.setEquipcode("");
					//复用段
					//查找设备对应所有复用段
					List<TopoLink> linklst = this.sceneMgrDao.getAllTopLink(equipcode);
					if(linklst.size()==0){
						zkind+=1;
						continue;
					}
					int l = Math.abs(rand.nextInt(linklst.size()));
					model.setResourcecode(linklst.get(l).getLabel());
					model.setResourcename(linklst.get(l).getAlabel()+"-"+linklst.get(l).getZlabel());
					model.setInterposename("自动生成故障"+model.getUpdatetime()+"复用段_"+p);
					int m = Math.abs(rand.nextInt(faultlst.size()));
					model.setFaulttype(faultlst.get(m).getFaulttypeid());
					model.setFaulttypeid(faultlst.get(m).getFaulttypeid());
					model.setInterposetype(faultlst.get(m).getInterposetypeid());
					model.setInterposetypeid(faultlst.get(m).getInterposetypeid());
					this.sceneMgrDao.autoAddInterpose(model);//插入故障和人员
					//激活故障
					result = this.setEventIsActive1(model);
					if("failed".equals(result)){
						return result;
					}
				}
			}
			
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "故障仿真模块", "自动生成故障事件", "", request);
		} catch (Exception e) {
			result = "failed";
			e.printStackTrace();
			log.error("addInterpose", e);
		}
		return result;
	}

	/**
	 *@author 尹显贵 
	 *割接---设备修改（单板和端口）
	 * @param Interposemodel
	 * @return string
	 **/
	public String addCutInterposeEquipModify(InterposeModel model){
		String result="";
		String interpose_id="";
		//1、插入科目
		//2、如果是机盘，修改机盘下所有端口业务关系（电路下端口字段、端口下电路编号、路由下端口编号、交叉、复用段）
		//3、如果是端口，修改该端口业务关系（电路下端口字段、端口下电路编号、路由下端口编号、交叉、复用段）
		try {
			model.setCutport(model.getResourcecode());//割接前的端口编号
			model.setCutportcode(model.getCutResource());//割接后的端口编号
			if("修改端口".equals(model.getModifylocation())){
				interpose_id = sceneMgrDao.addInterposePortCut(model);
				
				result = "success" + ";" + interpose_id;
			}
			else{//单板
				//直接循环激活生成告警
				String oldpackid = model.getResourcecode();//旧单板资源ID
				String newpackid = model.getCutResource();//新单板资源ID
				//在这里插入科目
				interpose_id = sceneMgrDao.addInterpose(model);
				//更新告警
				EquipPack ep1 = this.sceneMgrDao.getEquipPackInfoNew(oldpackid);
				EquipPack ep2 = this.sceneMgrDao.getEquipPackInfoNew(newpackid);
				//查找机盘的名称
				Map m = new HashMap();
				m.put("newframserial", ep2.getFrameserial());
				m.put("newslotserial", ep2.getSlotserial());
				m.put("newpackserial", ep2.getPackserial());
				m.put("framserial", ep1.getFrameserial());
				m.put("slotserial", ep1.getSlotserial());
				m.put("packserial", ep1.getPackserial());
				String alarmobjnew = this.sceneMgrDao.getAlarmobjByMap(m);
				m.put("alarmobjnew", alarmobjnew==null?"":alarmobjnew);
				this.sceneMgrDao.updateAlarmInfosBySerials(m);//这里是更新机盘上的告警
				
				//根据旧机盘ID查找业务端口列表
				Map map =new HashMap();
				map.put("equipcode", model.getEquipcode());
				map.put("packcode", oldpackid);
				map.put("newid", newpackid);
				List<String> list = this.sceneMgrDao.getPortInUseByPack(map);
				List<String> newlst = this.sceneMgrDao.getLogicPortNotUseByMap(map);
				for(int i=0;i<list.size();i++){
					model.setCutport(list.get(i));
					model.setCutportcode(newlst.get(i));//新的ID
					//修改告警位置
					m.put("newPortCode", model.getCutportcode());
					m.put("oldPortCode", model.getCutport());
					//端口序号也要改
					String newportserial = this.sceneMgrDao.getPortSerialById(model.getCutportcode());
					String serial = this.sceneMgrDao.getPortSerialById(model.getCutport());
					//告警位置要改，根据端口编号查找设备
					String alarmobj = this.sceneMgrDao.getAlarmObjByPortcode(model.getCutportcode());
					//框、盘、槽序号也要改
					m.put("alarmobj", alarmobj);
					m.put("newportserial", newportserial);
					m.put("serial", serial);
					this.sceneMgrDao.updateAlarmInfosByPortcode1(m);
					
					//在这里修改业务配置
					this.sceneMgrDao.updatePortBusinessConfig(model);
					model.setEquiptype("割接");
					String rel = this.setEventIsActive(model);
					if(!"success".equals(rel)){
						result=rel;
						break;
					}
				}
				result="suc";
			}
			
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "故障仿真模块", "添加干预事件", "", request);
		} catch (BeansException e) {
			result = "failed";
			e.printStackTrace();
			log.error("addInterpose", e);
		}
		return result;
	}
	
	/**
	 *@author 尹显贵 
	 * @param InterposeModel
	 * @return string
	 * ---机盘割接
	 **/
	public String addInterposePackCut(InterposeModel model){
		String result="";
		//在这里插入科目
		sceneMgrDao.addInterpose(model);
		String oldpackid = model.getCutport();//旧单板资源ID
		String newpackid = model.getCutportcode();//新单板资源ID
		EquipPack ep1 = this.sceneMgrDao.getEquipPackInfoNew(oldpackid);
		EquipPack ep2 = this.sceneMgrDao.getEquipPackInfoNew(newpackid);
		//查找机盘的名称
		Map m = new HashMap();
		m.put("newframserial", ep2.getFrameserial());
		m.put("newslotserial", ep2.getSlotserial());
		m.put("newpackserial", ep2.getPackserial());
		m.put("framserial", ep1.getFrameserial());
		m.put("slotserial", ep1.getSlotserial());
		m.put("packserial", ep1.getPackserial());
		String alarmobjnew = this.sceneMgrDao.getAlarmobjByMap(m);
		m.put("alarmobjnew", alarmobjnew==null?"":alarmobjnew);
		this.sceneMgrDao.updateAlarmInfosBySerials(m);//这里是更新机盘上的告警
		
		//根据旧机盘ID查找业务端口列表
		Map map =new HashMap();
		map.put("equipcode", model.getEquipcode());
		map.put("packcode", model.getCutport());
		map.put("newid", model.getCutportcode());
		List<String> list = this.sceneMgrDao.getPortInUseByPack(map);
		List<String> newlst = this.sceneMgrDao.getLogicPortNotUseByMap(map);
		for(int i=0;i<list.size();i++){
			model.setCutport(list.get(i));
			model.setCutportcode(newlst.get(i));//新的ID
			
			//修改告警位置
			m.put("newPortCode", model.getCutportcode());
			m.put("oldPortCode", model.getCutport());
			//端口序号也要改
			String newportserial = this.sceneMgrDao.getPortSerialById(model.getCutportcode());
			String serial = this.sceneMgrDao.getPortSerialById(model.getCutport());
			//告警位置要改，根据端口编号查找设备
			String alarmobj = this.sceneMgrDao.getAlarmObjByPortcode(model.getCutportcode());
			//框、盘、槽序号也要改
			m.put("alarmobj", alarmobj);
			m.put("newportserial", newportserial);
			m.put("serial", serial);
			this.sceneMgrDao.updateAlarmInfosByPortcode1(m);
			
			//在这里修改业务配置
			this.sceneMgrDao.updatePortBusinessConfig(model);
			model.setEquiptype("割接");
			String rel = this.setEventIsActive(model);
			if(!"success".equals(rel)){
				result=rel;
				break;
			}
		}
		result = "success";
		return result;
	}
	
	
	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return String
	 * @name addInterposeCutFault
	 */
	public String addInterposeCutFault(InterposeModel model) {
		String result = "failed";
		try {
			String interpose_id = sceneMgrDao.addInterpose(model);
			//查询设备连接的复用段对端的设备编号和端口编号
			List<InterposeModel> lst = this.sceneMgrDao.getToplinkRateAndPortAndEquipzByEquipcode(model.getEquipcode());
			//插入新的复用段
			if(lst.size()==2){
				model.setToplinkid(lst.get(0).getPorta()+"#"+lst.get(1).getPorta());
				model.setPorta(lst.get(0).getPorta());
				model.setPortz(lst.get(1).getPorta());
				model.setEquipa(lst.get(0).getEquipa());
				model.setEquipz(lst.get(1).getEquipa());
				model.setToplinkrate(lst.get(0).getToplinkrate());
				//插入之前先删除
				this.sceneMgrDao.deleteEn_toplinkByID(model.getToplinkid());
				this.sceneMgrDao.insertToplinkByModel(model);
			}
			//重新串接路由
//			this.sceneMgrDao.restructCircuitRoute(lst.get(0).getPorta(),lst.get(1).getPorta());
			
			result = "success" + ";" + interpose_id;
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "故障仿真模块", "添加干预事件", "", request);
		} catch (Exception e) {
			result = "failed";
			e.printStackTrace();
			log.error("addInterpose", e);
		}
		return result;
	}
	
	
	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return String
	 * @name modifyInterpose
	 */
	public String modifyInterpose(InterposeModel model) {
		try {
			List<InterposeModel> eventLst = new ArrayList<InterposeModel>();
			// 查询state=1,2
			Map map = new HashMap();
			map.put("interposeid", model.getInterposeid());
			map.put("isactive", "1");
			eventLst = sceneMgrDao.getEventInterposeIsActive(map);
			if (eventLst.size() > 0) {
				return "failed";// 激活
			} else {
				sceneMgrDao.modifyInterpose(model);
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("修改", "故障仿真模块", "修改事件干预", "", request);
				return "success";
			}
		} catch (Exception e) {
			log.error("modifyInterpose", e);
			return "error";
		}
	}

	/**
	 * @author xgyin
	 * @param String
	 * @return string
	 * @name delEventInterpose
	 */
	public String delEventInterpose(String interposeid) {
		String result;
		try {
			List<InterposeModel> eventLst = new ArrayList<InterposeModel>();
			// 查询state=1,2
			Map map = new HashMap();
			map.put("interposeid", interposeid);
			map.put("isactive", "1");
			eventLst = sceneMgrDao.getEventInterposeIsActive(map);
			if (eventLst.size() > 0) {
				sceneMgrDao.delEventInterposeCascade(interposeid);
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "故障仿真模块", "级联删除事件干预", "", request);
				result = "success";
//				return "failed";// 激活
			} else {
				sceneMgrDao.delEventInterpose(interposeid);
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "故障仿真模块", "删除事件干预", "", request);
				result = "success";
			}
		} catch (Exception e) {
			log.error("delEventInterpose", e);
			result = "error";
		}
		return result;
	}
	
	/**
	 * 批量激活
	 */
	public String setEventIsActive2(String ids){
		String result = "success";
		String id[];
		if(ids.indexOf(";")!=-1){
			id = ids.split(";");
		}else{
			id = new String[]{ids};
		}
		//根据资源编码字段查找两端端口和设备组
		//割接时，不能使用ccid查，因为复用段已删掉
		for(int i=0;i<id.length;i++){
			String []arr;
			InterposeModel model = this.sceneMgrDao.getInterposeModelByID(id[i]);
			//首先验证是否已激活
			if("激活".equals(model.getIsactive())){
				//已激活
				continue;
			}
			String rel = "failed";
			if("复用段".equals(model.getEquiptype())){
				if(model.getResourcecode().indexOf("#")!=-1){
					arr = model.getResourcecode().split("#");
				}else{
					arr = new String[]{model.getResourcecode()};
				}
				for(int j=0;j<arr.length;j++){
					//根据端口编号查找槽位和设备编号
					ComboxDataModel cmb = this.sceneMgrDao.getSlotSerialByPortCode(arr[j]);
					model.setResourcecode(cmb.getLabel()+","+arr[j]);
					model.setEquipcode(cmb.getId());
					rel=this.setEventIsActive(model);
				}
			}else{
				rel=this.setEventIsActive(model);
			}
			if("failed".equals(rel)){
				result=rel;
			}
		}
		
		return result;
	}
	
	/**
	 * 复用段故障告警,割接告警
	 * setEventIsActive1
	 */
	public String setEventIsActive1(InterposeModel model){
		String result = "failed";
		//根据资源编码字段查找两端端口和设备组
		//割接时，不能使用ccid查，因为复用段已删掉
		String []arr;
		if(model.getResourcecode().indexOf("#")!=-1){
			arr = model.getResourcecode().split("#");
		}else{
			arr = new String[]{model.getResourcecode()};
		}
		for(int i=0;i<arr.length;i++){
			//根据端口编号查找槽位和设备编号
			ComboxDataModel cmb = this.sceneMgrDao.getSlotSerialByPortCode(arr[i]);
			if(cmb==null){
				continue;
			}
			model.setResourcecode(cmb.getLabel()+","+arr[i]);
			model.setEquipcode(cmb.getId());
			result=this.setEventIsActive(model);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return string
	 * @name setEventIsActive
	 */
	@SuppressWarnings("unchecked")
	public String setEventIsActive(InterposeModel model) {
		String result = "failed";
		try {
			// 用户id数组
			String[] arr;
			if (model.getUser_id().indexOf(",") != -1) {
				arr = model.getUser_id().split(",");
			} else {
				arr = new String[] { model.getUser_id() };
			}
			// 上传告警。1、查询告警列表，2、每条告警配置场景ID和干预ID，3.插入到告警列表中。
			Map map = new HashMap();
			map.put("interposetypeid", model.getInterposetypeid());
			map.put("faulttypeid", model.getFaulttypeid());
			map.put("equiptype", model.getEquiptype());
			map.put("x_vendor", this.sceneMgrDao.getX_vendorByEquipcode(model
					.getEquipcode()));
			List<InterposeModel> alarmLst = this.sceneMgrDao
					.getInterposeAlarmList(map);
			if("割接".equals(model.getEquiptype())&&("AT10000001".equals(model.getFaulttypeid())||"AT10000022".equals(model.getFaulttypeid())||"AT10000051".equals(model.getFaulttypeid()))){
				model.setEquiptype("端口");
			}
			if("修改端口".equals(model.getModifylocation()) ){
				model.setCutportcode(model.getCutResource());
			}
			Set<String> carryList = new HashSet<String>();// 伴随告警ID列表
			ComboxDataModel cm0 = new ComboxDataModel();// 所属传输系统
			String stationName;// 站点名称
			String objClass = "";
			String objAlarmDes = "";
			String portSerial;// 端口序号
			ComboxDataModel serial = new ComboxDataModel();// 机框序号和机盘序号
			String[] arr1;// 资源数组
			if (model.getResourcecode().indexOf(",") != -1) {
				arr1 = model.getResourcecode().split(",");
			} else {
				arr1 = new String[] { model.getResourcecode() };
			}

			for (int i = 0; i < alarmLst.size(); i++) {
				InterposeModel key = alarmLst.get(i);
				String alarmIds = key.getAlarmid();
				String alarmId[];
				if (alarmIds.indexOf(";") != -1) {
					alarmId = alarmIds.split(";");
				} else {
					alarmId = new String[] { alarmIds };
				}
				// 根据position的位置确定是本端还是对端
				if ("本端".equals(key.getPosition())) {
					// 配置本端参数
					ComboxDataModel cm2 = this.sceneMgrDao
							.getTransystemByEquipCode(model.getEquipcode());
					if (cm2 != null) {
						cm0 = cm2;
					}
					ComboxDataModel cm1 = this.sceneMgrDao
							.getStationByEquipCode(model.getEquipcode());
					if (cm1 != null) {
						stationName = cm1.getLabel();
					} else {
						stationName = this.sceneMgrDao
								.getEquipNameByEquipcode(model.getEquipcode());
					}
					if ("端口".equals(model.getEquiptype())||"复用段".equals(model.getEquiptype())||"AT10000020".equals(model.getFaulttype())) {
						objClass = "port";
						if("AT10000001".equals(model.getFaulttypeid())||"AT10000022".equals(model.getFaulttypeid())||"AT10000051".equals(model.getFaulttypeid())){
							arr1[1]=model.getCutport();
							arr1[0] = ((ComboxDataModel)this.sceneMgrDao.getSlotSerialByPortCode(arr1[1])).getLabel();
						}
						serial = this.sceneMgrDao.getSerialsByCodes(arr1[1],
								"logicport", "equiplogicport");
						// 根据端口查盘名称
						// 获取端口序号
						portSerial = this.sceneMgrDao
								.getPortSerialById(arr1[1]);
						objAlarmDes = cm0.getLabel() + "/" + stationName + "."
								+ serial.getId() + "框." + serial.getLabel()
								+ "盘" +arr1[0]+"槽"+ portSerial + "端口";
					}
					if ("机盘".equals(model.getEquiptype())) {
						objClass = "circuitPack";
						serial = this.sceneMgrDao.getSerialsByCodes(arr1[1],
								"id", "equippack");
						objAlarmDes = cm0.getLabel() + "/" + stationName + "."
								+ serial.getId() + "框." + serial.getLabel()
								+ "盘"+arr1[0]+"槽";
					}
					if ("设备".equals(model.getEquiptype())||"AT10000021".equals(model.getFaulttype())) {
						objClass = "managedElement";
						objAlarmDes = cm0.getLabel() + "/" + stationName;
					}

					for (int k = 0; k < alarmId.length; k++) {
						Set<String> set = this.ForEachAlarm(
								new HashSet<String>(), alarmId[k]);
						carryList.addAll(set);
						AlarmInfos alarmModel = new AlarmInfos();
						alarmModel.setInterposeid(model.getInterposeid());//科目ID
						//根据科目ID查询告警来源
						String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
						alarmModel.setAlarmlevel(this.sceneMgrDao
								.getAlarmLevelById(alarmId[k]));
						alarmModel.setBeginTime(this
								.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
						if (cm1 != null) {
							alarmModel.setBelongstation(cm1.getId());
						} else {
							alarmModel.setBelongstation("");
						}

						alarmModel.setProbablecause(alarmId[k]);
						// 查询告警名称
						alarmModel.setAlarmdesc(this.sceneMgrDao
								.getAlarmNameByAlarmId(alarmId[k]));
						alarmModel.setAlarmobjdesc(objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙

						alarmModel.setBelongequip(model.getEquipcode());
						alarmModel.setBelongframe(serial.getId());

						if ("端口".equals(model.getEquiptype())||"复用段".equals(model.getEquiptype())||"AT10000020".equals(model.getFaulttype())) {
							// 获取端口序号
							alarmModel.setBelongpack(serial.getLabel());
							alarmModel.setBelongport(this.sceneMgrDao
									.getPortSerialById(arr1[1]));
							// 根据端口查询承载业务
							alarmModel.setCarrycircuit(""
									+ this.carryOperaDao
											.getCarryOperaCountByLogicPort(
													arr1[1], 0));
							alarmModel.setBelongslot(arr1[0]);//槽位
							alarmModel.setBelongportcode(arr1[1]);
						} else if ("机盘".equals(model.getEquiptype())) {
							alarmModel.setBelongpack(serial.getLabel());
							alarmModel.setBelongport("");
							alarmModel.setBelongslot(arr1[0]);
							alarmModel.setBelongportcode("");
							alarmModel.setCarrycircuit(""
									+ this.carryOperaDao
											.getCarryOperaCountByEquipPack(
													model.getEquipcode(),
													serial.getId(), arr1[0],
													serial.getLabel(), 0));
						} else {
							alarmModel.setBelongpack("");
							alarmModel.setBelongport("");
							alarmModel.setBelongslot("");
							alarmModel.setBelongportcode("");
							alarmModel.setCarrycircuit(""
									+ this.carryOperaDao
											.getCarryOperaCountByEquipcode(
													model.getEquipcode(), 0));
						}

						alarmModel.setVendor(key.getX_vendor());
						alarmModel.setBelongtransys(cm0.getId());
						alarmModel.setIscleared("0");
						alarmModel.setObjClass(objClass);
						alarmModel.setIsAck("0");
						alarmModel.setIsfilter("0");
						alarmModel.setTriggeredhour("12");
						
						DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						long now = System.currentTimeMillis();
						long newnow = now-10*60*1000;
						Calendar calendar = Calendar.getInstance();
						calendar.setTimeInMillis(newnow);
						// 设置一个告警标识，区分跟告警和伴随告警
						alarmModel.setIsRootAlarm("1");
						//添加字段 告警来源
						alarmModel.setAlarmType(alarmtype);
						//根据设备编码查找站点所属区域
						alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
						// 按用户插入
						int p=0;
						for (int j = 0; j < arr.length; j++) {
							alarmModel.setAlarmman(arr[j]);
							//插入前判断该告警是否存在
							alarmModel.setEndTime(formatter.format(calendar.getTime()));
							List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
							if(info.size()==0){
								this.sceneMgrDao.insertAlarmInfo(alarmModel);
								p++;
							}
							
						}
						if(p>0){
							//插入仿真日志
							this.insertInterposeLog(alarmModel,model);
						}
						
					}

				} else {
					// 对端
					List<String> idLst = new ArrayList<String>();
					Map mp = new HashMap();
					mp.put("equipA", model.getEquipcode());
					if ("设备".equals(model.getEquiptype())||"AT10000021".equals(model.getFaulttype())) {
						// 查找对端端口，通过复用段找
						idLst = this.sceneMgrDao
								.getZPortCodeListByEquipcode(model
										.getEquipcode());
					}

					else if ("端口".equals(model.getEquiptype())||"复用段".equals(model.getEquiptype())||"AT10000020".equals(model.getFaulttype())) {
						// 端口对端,通过交叉来找，告警的产生根据端口类型和电路交叉来找
						if("AT10000001".equals(model.getFaulttypeid())||"AT10000022".equals(model.getFaulttypeid())||"AT10000051".equals(model.getFaulttypeid())){
							mp.put("code", model.getCutportcode());
						}else{
							mp.put("code", arr1[1]);
						}
						
						String ratecode = this.sceneMgrDao.getPortrateByPortcode(mp); 
						if("ZY070101".equals(ratecode)){//根据速率判断
							//电口通过复用段查找对端
							idLst = this.sceneMgrDao.getZportCodeListByToplink(mp);
						}else{
							//光口通过交叉
							idLst = this.sceneMgrDao
							.getZportCodeListByAportcode(mp);
						}
					} else {
						// 机盘对端，通过交叉来查
						mp.put("code", arr1[1]);
						idLst = this.sceneMgrDao.getZportCodeListByPackcode(mp);
					}

					for (int j = 0; j < idLst.size(); j++) {
						String Z_equipcode = this.sceneMgrDao
								.getZ_EquipcodeByPortCode(idLst.get(j));
						if (Z_equipcode != null) {
							ComboxDataModel zcm0 = this.sceneMgrDao
									.getTransystemByEquipCode(Z_equipcode);
							if (zcm0 == null) {
								zcm0 = new ComboxDataModel();
							}
							ComboxDataModel zcm1 = this.sceneMgrDao
									.getStationByEquipCode(Z_equipcode);
							String z_stationName;
							if (zcm1 != null) {
								z_stationName = zcm1.getLabel();
							} else {
								z_stationName = this.sceneMgrDao
										.getEquipNameByEquipcode(Z_equipcode);
							}
							String z_objAlarmDes = "";
							ComboxDataModel z_serial = new ComboxDataModel();

							objClass = "port";
							z_serial = this.sceneMgrDao.getSerialsByCodes(idLst
									.get(j), "logicport", "equiplogicport");
							// 根据端口查盘名称
							// 获取端口序号
							portSerial = this.sceneMgrDao
									.getPortSerialById(idLst.get(j));
							z_objAlarmDes = zcm0.getLabel() + "/"
									+ z_stationName + "." + z_serial.getId()
									+ "框." + z_serial.getLabel() + "盘"
									+this.sceneMgrDao
									.getPortSerialById(idLst.get(j))+"槽"+ portSerial + "端口";
							serial = z_serial;
							for (int k = 0; k < alarmId.length; k++) {
								Set<String> set = this.ForEachAlarm(
										new HashSet<String>(), alarmId[k]);
								carryList.addAll(set);

								AlarmInfos alarmModel = new AlarmInfos();
								alarmModel.setInterposeid(model
										.getInterposeid());
								alarmModel.setAlarmlevel(this.sceneMgrDao
										.getAlarmLevelById(alarmId[k]));
								alarmModel
										.setBeginTime(this
												.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
								if (zcm1 != null) {
									alarmModel.setBelongstation(zcm1.getId());
								} else {
									alarmModel.setBelongstation("");
								}

								alarmModel.setProbablecause(alarmId[k]);
								alarmModel.setAlarmdesc(this.sceneMgrDao
										.getAlarmNameByAlarmId(alarmId[k]));
								alarmModel.setAlarmobjdesc(z_objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙

								alarmModel.setBelongequip(Z_equipcode);
								alarmModel.setBelongframe(z_serial.getId());

								// 获取端口序号
								alarmModel.setBelongpack(z_serial.getLabel());
								alarmModel.setBelongport(this.sceneMgrDao
										.getPortSerialById(idLst.get(j)));
								// 根据端口查询承载业务
								alarmModel.setCarrycircuit(""
										+ this.carryOperaDao
												.getCarryOperaCountByLogicPort(
														idLst.get(j), 0));
								alarmModel.setBelongslot(this.sceneMgrDao
										.getEquipSlotSerialById(idLst.get(j)));
								alarmModel.setBelongportcode(idLst.get(j));

								alarmModel.setVendor(key.getX_vendor());
								alarmModel.setBelongtransys(zcm0.getId());
								alarmModel.setIscleared("0");
								alarmModel.setObjClass(objClass);
								alarmModel.setIsAck("0");
								alarmModel.setIsfilter("0");
								alarmModel.setTriggeredhour("12");
								// alarmModel.setVersion(version);
								alarmModel.setIsRootAlarm("1");
								String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
								alarmModel.setAlarmType(alarmtype);
								alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
								
								DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
								long now = System.currentTimeMillis();
								long newnow = now-10*60*1000;
								Calendar calendar = Calendar.getInstance();
								calendar.setTimeInMillis(newnow);
								
								// 按用户插入
								int p=0;
								for (int t = 0; t < arr.length; t++) {
									alarmModel.setAlarmman(arr[t]);
									alarmModel.setEndTime(formatter.format(calendar.getTime()));
									List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
									if(info.size()==0){
										this.sceneMgrDao.insertAlarmInfo(alarmModel);
										p++;
									}
								}
								if(p>0){
									//插入仿真日志
									this.insertInterposeLog(alarmModel,model);
								}
							}
						}
					}
				}
			}

			// 插入伴随告警
			if (carryList.size() > 0) {
				this.insertAlarmTransmit(carryList, model);
			}

			//插入业务告警，alarmLst，carryList
			//1、设备，端口，机盘，复用段下的所有业务查询
			
//			Set<String> circuitcodeLst = new HashSet<String>();
//			List<String> circuitcodeLstTemp = this.sceneMgrDao.getAllBusinessRelateCircuitcode();
//			for(int i=0;i<circuitcodeLstTemp.size();i++){
//				String strs = circuitcodeLstTemp.get(i);
//				if(strs.indexOf(",")!=-1){
//					String code[] = strs.split(",");
//					for(int j=0;j<code.length;j++){
//						circuitcodeLst.add(code[j]);
//					}
//				}else{
//					circuitcodeLst.add(strs);
//				}
//			}
//			Iterator<String> clistit = circuitcodeLst.iterator();
//			List<String> ccodeLst = new ArrayList<String>();
//			while(clistit.hasNext()){
//				ccodeLst.add(clistit.next());
//			}
//			List<String> codeLst= new ArrayList<String>();//当前资源关联的电路编号
//			Map m = new HashMap();
//			String equip = "";
//			if(!"".equals(model.getEquipcode())&&model.getEquipcode()!=null){
//				equip = model.getEquipcode();
//			}
//			m.put("equipcode", equip);
////			m.put("circuitcodeLst", ccodeLst);
//			String portcode = "";
//			if("设备".equals(model.getEquiptype())||"AT10000021".equals(model.getFaulttype())){
//				portcode = "";
//				m.put("portcode", portcode);
//				//查找当前设备所跑的业务关联的电路编号
//				codeLst = this.sceneMgrDao.getAllRelatedCircuitCode(m);
//			}
//			
//			if("端口".equals(model.getEquiptype())){
//				portcode = this.sceneMgrDao
//				.getPortSerialById(arr1[1]);
//				m.put("portcode", portcode);
//				codeLst = this.sceneMgrDao.getAllRelatedCircuitCode(m);
//			}
//			
//			String packserial="";
//			String slotserial = "";
//			String frameserial = "";
//			if("机盘".equals(model.getEquiptype())){
//				packserial = serial.getLabel();
//				slotserial = arr1[0];
//				frameserial= serial.getId();
//				m.put("packserial", packserial==null?"":packserial);
//				m.put("slotserial", slotserial);
//				m.put("frameserial", frameserial==null?"":frameserial);
//				//根据机盘序号、机槽序号和设备编号查找端口集合
//				List<String> a_portLst = this.sceneMgrDao.getPortcodesByMap(m);
//				//循环端口编号查找电路编号
//				Set<String> codeset = new HashSet<String>();
//				for(int t=0;t<a_portLst.size();t++){
//					m.put("portcode", a_portLst.get(t));
//					List<String> codeLsttemp = this.sceneMgrDao.getAllRelatedCircuitCode(m);
//					codeset.addAll(codeLsttemp);
//				}
//				Iterator<String> iterator = codeset.iterator();
//				while(iterator.hasNext()){
//					codeLst.add(iterator.next());
//				}
//			}
//			String ccid = "";
//			Set<InterposeModel> inter = new HashSet<InterposeModel>();//设备编码和名称
//			if("复用段".equals(model.getEquiptype())||("AT10000020".equals(model.getFaulttype())&&!"".equals(model.getEquipmodel())&&model.getEquipmodel()!=null)){
//				//复用段和割接--添加设备
//				ccid = model.getToplinkid();
//				String []lst;
//				if(ccid.indexOf("#")!=-1){
//					lst = ccid.split("#");
//				}else{
//					lst = new String[]{ccid};
//				}
//				Set<String> codeset = new HashSet<String>();
//				for(int k=0;k<lst.length;k++){
//					m.put("portcode", lst[k]);
//					//根据端口查找设备名称和编号
//					InterposeModel interpose = this.sceneMgrDao.getEquipcodeAndEquipName(lst[k]);
//					inter.add(interpose);
//					List<String> codeLsttemp = this.sceneMgrDao.getAllRelatedCircuitCode(m);
//					codeset.addAll(codeLsttemp);
//				}
//				Iterator<String> iterator = codeset.iterator();
//				while(iterator.hasNext()){
//					codeLst.add(iterator.next());
//				}
//				
//			}
//			//去掉没有承载业务的电路
//			for(int r=0;r<codeLst.size();r++){
//				if(!ccodeLst.contains(codeLst.get(r))){
//					codeLst.remove(r);
//				}
//			}
//			//2、去掉有备用路由的业务,如果是起止端，需加上
//			for(int s=0;s<codeLst.size();s++){
//				Circuit cir = this.sceneMgrDao.getCircuitByCircuitcode(codeLst.get(s));
//				if(cir!=null){
//					String paths = cir.getPath();
//					if(paths==null){
//						paths="";
//					}
//					String path[] ;
//					if(paths.indexOf("->")!=-1){
//						path = paths.split("->");
//					}else{
//						path = new String[]{paths};
//					}
//					List<Circuit> cirlst = this.sceneMgrDao.getEquipcodeAndCounts(codeLst.get(s));
//					int k=0;
//					List<String> cirtempLst = new ArrayList<String>();
//					for(int l=0;l<cirlst.size();l++){
//						Circuit c = cirlst.get(l);
//						if(Integer.parseInt(c.getNo())>=2){
//							k++;
//							if(!cirtempLst.contains(c.getUsername())){
//								cirtempLst.add(c.getUsername());//主备路由均通过的设备
//							}
//						}
//					}
//					if(!cirtempLst.contains(path[0])){
//						cirtempLst.add(path[0]);
//					}
//					if(!cirtempLst.contains(path[path.length-1])){
//						cirtempLst.add(path[path.length-1]);
//					}
//					if("复用段".equals(model.getEquiptype())||"AT10000020".equals(model.getFaulttype())){
//						//没有备用路由会影响，起止端会影响
//						if(k==0){
//							//当前设备的前一个设备和后面所有设备均产生告警
//							Iterator<InterposeModel> iterator = inter.iterator();
//							Set<String> equipset = new HashSet<String>();
//							while(iterator.hasNext()){
//								if(iterator.next()!=null){
//									String equipname = iterator.next().getEquipname();
//									int j=0;
//									for(int i=0;i<path.length;i++){
//										if(equipname!=null&&equipname.equals(path[i])){
//											j=i;
//											break;
//										}
//									}
//									if(j>0){
//										j=j-1;
//									}
//									for(int q=j;q<path.length;q++){
//										equipset.add(path[q]);
//									}
//								}
//							}
//							Iterator<String> it = equipset.iterator();
//							while(it.hasNext()){
//								//在端口上插入告警
//								//查询设备编号
//								String equipname = it.next();
//								if(!"".equals(equipname)&&equipname!=null){
//									String equipcode = this.sceneMgrDao.getEquipcodeByEquipName(equipname);
//									//根据设备编号和电路编号查找端口
//									if(equipcode!=null&&!"".equals(equipcode)){
//										List<String> portcodeLst =this.sceneMgrDao.getAllPortcodeLstByID(equipcode,codeLst.get(s));
//										insertAlarmInfos(alarmLst,equipcode,model,arr,portcodeLst);
//										//插入伴随告警
//										if(carryList.size()>0){
//											insertCarryAlarmInfos(carryList,equipcode,model,arr,portcodeLst);
//										}
//									}
//								}
//							}
//							
//						}
//						else{//
//							Iterator<InterposeModel> iterator = inter.iterator();
//							while(iterator.hasNext()){
//								InterposeModel key = iterator.next();
//								if(key!=null){
//									String equipname = key.getEquipname();
//									Set<String> equips = new HashSet<String>();
//									int t=-1;
//									for(int r=0;r<cirtempLst.size();r++){
//										if(equipname!=null&&equipname.equals(cirtempLst.get(r))){
//											//前设备影响主备路由
//											t=r;
//											break;//跳出内循环
//										}
//									}
//									
//									if(t>=0){//说明当前设备影响主备路由
//										String remarks = cir.getRemark();
//										String remark[] ;
//										if(remarks==null){
//											remarks="";
//										}
//										if(remarks.indexOf("->")!=-1){
//											remark = remarks.split("->");
//										}else{
//											remark = new String[]{remarks};
//										}
//										int i=0,j=0;
//										for(int p=0;p<path.length;p++){
//											if(equipname!=null&&equipname.equals(path[p])){
//												i=p;
//												break;
//											}
//										}
//										if(i>0){
//											i=i-1;
//										}
//										for(int e=i;e<path.length;e++){
//											equips.add(path[e]);
//										}
//										for(int x=0;x<remark.length;x++){
//											if(equipname!=null&&equipname.equals(path[x])){
//												j=x;
//												break;
//											}
//										}
//										if(j>0){
//											j=j-1;
//										}
//										for(int a=j;a<remark.length;a++){
//											equips.add(remark[a]);
//										}
//										Iterator<String> it = equips.iterator();
//										while(it.hasNext()){
//											String name = it.next();
//											if(!"".equals(name)&&name!=null){
//												String equipcode = this.sceneMgrDao.getEquipcodeByEquipName(name);
//												if(equipcode!=null&&!"".equals(equipcode)){
//												//插入告警
//													List<String> portcodeLst =this.sceneMgrDao.getAllPortcodeLstByID(equipcode,codeLst.get(s));
//													insertAlarmInfos(alarmLst,equipcode,model,arr,portcodeLst);
//													
//													//插入伴随告警
//													if(carryList.size()>0){
//														insertCarryAlarmInfos(carryList,equipcode,model,arr,portcodeLst);
//													}
//												}
//											}
//										}
//									}
//								}
//							}
//						}
//					}else{
//						//设备、机盘和端口情形,都应该呈现在端口上
////						if("设备".equals(model.getEquiptype())||"AT10000021".equals(model.getFaulttype())){
//							//当前设备model.getEquipcode();
//							if(k==0){
//								//只有主路由
//								//查找路由表中对应电路编号的路由信息
//								List<CircuitChannel> lst = this.sceneMgrDao.getAllRouteInfosByID(codeLst.get(s));
//								int p=0;
//								for(int i=0;i<lst.size();i++){
//									if(model.getEquipcode().equals(lst.get(i).getChannelcode())){
//										p=i;
//										break;
//									}
//								}
//								if(p>0){
//									p=p-1;
//								}
//								for(int j=p;j<lst.size();j++){
//									List<String> portlst = new ArrayList<String>();
//									portlst.add(lst.get(j).getPortcode1());
//									portlst.add(lst.get(j).getPortcode2());
//									insertAlarmInfos(alarmLst,lst.get(j).getChannelcode(),model,arr,portlst);
//									//插入伴随告警
//									if(carryList.size()>0){
//										insertCarryAlarmInfos(carryList,lst.get(j).getChannelcode(),model,arr,portlst);
//									}
//								}
//								
//							}else{
//								//有备用路由
//								int t=-1;
//								for(int r=0;r<cirtempLst.size();r++){
//									if(cirtempLst.get(r)!=null){
//										String code = this.sceneMgrDao.getEquipcodeByEquipName(cirtempLst.get(r));
//										if(model.getEquipcode().equals(code)){
//											//当前设备影响主备路由
//											t=r;
//											break;//跳出内循环
//										}
//									}
//								}
//								if(t>=0){//当前设备影响主备路由
//									String remarks = cir.getRemark();
//									String remark[] ;
//									if(remarks==null){
//										remarks="";
//									}
//									Set<String> equips = new HashSet<String>();
//									if(remarks.indexOf("->")!=-1){
//										remark = remarks.split("->");
//									}else{
//										remark = new String[]{remarks};
//									}
//									int i=0,j=0;
//									for(int p=0;p<path.length;p++){
//										String code = this.sceneMgrDao.getEquipcodeByEquipName(path[p]);
//										if(model.getEquipcode().equals(code)){
//											i=p;
//											break;
//										}
//									}
//									if(i>0){
//										i=i-1;
//									}
//									for(int e=i;e<path.length;e++){
//										equips.add(path[e]);
//									}
//									for(int x=0;x<remark.length;x++){
//										String code = this.sceneMgrDao.getEquipcodeByEquipName(remark[x]);
//										if(model.getEquipcode().equals(code)){
//											j=x;
//											break;
//										}
//									}
//									if(j>0){
//										j=j-1;
//									}
//									for(int a=j;a<remark.length;a++){
//										equips.add(remark[a]);
//									}
//									
//									Iterator<String> it = equips.iterator();
//									while(it.hasNext()){
//										String name = it.next();
//										if(!"".equals(name)&&name!=null){
//											String equipcode = this.sceneMgrDao.getEquipcodeByEquipName(name);
//											if(equipcode!=null&&!"".equals(equipcode)){
//												//插入告警
//												List<String> portcodeLst =this.sceneMgrDao.getAllPortcodeLstByID(equipcode,codeLst.get(s));
//												insertAlarmInfos(alarmLst,equipcode,model,arr,portcodeLst);
//												//插入伴随告警
//												if(carryList.size()>0){
//													insertCarryAlarmInfos(carryList,equipcode,model,arr,portcodeLst);
//												}
//											}
//										}
//									}
//								}
//							}
//						}
////					}
//				}
//			}
			//3、受影响业务上所有设备相应端口均产生告警
			//4、交叉配置时，如果影响业务，应生成告警，配置正确时，告警消失
			if("AT10000021".equals(model.getFaulttype())){
				//更改当前演习id对应的所有告警等级为根告警，避免删除设备后，没有根告警
				this.sceneMgrDao.updateAlarmInfosByInterposeid(model.getInterposeid());
				//删除当前设备下的所有告警
				this.sceneMgrDao.deleteAlarmByEquipcode(model.getEquipcode());
				//删除当前设备上的交叉和复用段
				
				this.sceneMgrDao.deleteEquipmentCCByEquipcode(model.getEquipcode());
			}
			
			this.sceneMgrDao.setEventIsActive(model);
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("设置激活", "故障仿真模块", "事件干预激活", "", request);
			result = "success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("setEventIsActive", e);
		}
		return result;
	}

	private void insertInterposeLog(AlarmInfos alarmModel, InterposeModel model) {

		Map logMap = new HashMap();
		logMap.put("logid", alarmModel.getProbablecause());//告警ID
		logMap.put("eventname", alarmModel.getAlarmdesc());//告警名称
		logMap.put("logtype", model.getS_event_title());//事件类别
		logMap.put("logtime", alarmModel.getBeginTime());
		String name = model.getResourcename();
		if(!"".equals(model.getEquipcode())&&!"设备".equals(model.getEquiptype())){
			name = this.sceneMgrDao
			.getEquipNameByEquipcode(model.getEquipcode())+"/"+name;
		}
		logMap.put("sourceobj", name);
		logMap.put("accessobj", alarmModel.getAlarmobjdesc());
		logMap.put("eventtype", model.getInterposename());
		this.sceneMgrDao.addInterposeLogEvent(logMap);
	}

	private void insertCarryAlarmInfos(Set<String> carryList, String equipcode,
			InterposeModel model, String[] arr, List<String> portcodeLst) {
		try {
			Iterator<String> iterator = carryList.iterator();
			ComboxDataModel cm0 = this.sceneMgrDao
			.getTransystemByEquipCode(equipcode);
			if (cm0 == null) {
				cm0 = new ComboxDataModel();
			}
			ComboxDataModel cm1 = this.sceneMgrDao.getStationByEquipCode(equipcode);
			String stationName;
			if (cm1 != null) {
				stationName = cm1.getLabel();
			} else {
				stationName = this.sceneMgrDao.getEquipNameByEquipcode(equipcode);
			}
			String objClass = "port";
			String objAlarmDes = "";
			Set<String> set = new HashSet<String>();// 避免重复
			while (iterator.hasNext()) {
				List<OperateList> operList = this.sceneMgrDao
						.getAlarmTransmitByAlarmId(iterator.next());
				// 插入伴随告警
				for (int t = 0; t < operList.size(); t++) {
					OperateList oper = operList.get(t);
					if ("本端".equals(oper.getOper_desc())) {
						AlarmInfos alarmModel = new AlarmInfos();
						alarmModel.setInterposeid(model.getInterposeid());
						alarmModel.setAlarmlevel(this.sceneMgrDao
								.getAlarmLevelById(oper.getAlarm_id()));
						alarmModel.setBeginTime(this
								.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
						if (cm1 != null) {
							alarmModel.setBelongstation(cm1.getId());
						} else {
							alarmModel.setBelongstation("");
						}
	
						alarmModel.setProbablecause(oper.getAlarm_id());
						alarmModel.setAlarmdesc(oper.getAlarm_name());
						alarmModel.setBelongequip(equipcode);
						alarmModel.setVendor(oper.getVendercode());
						alarmModel.setBelongtransys(cm0.getId());
						alarmModel.setIscleared("0");
						alarmModel.setObjClass(objClass);
						alarmModel.setIsAck("0");
						alarmModel.setIsfilter("0");
						alarmModel.setTriggeredhour("12");
						String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
						alarmModel.setAlarmType(alarmtype);
						alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
						// 设置一个告警标识，区分跟告警和伴随告警
						alarmModel.setIsRootAlarm("0");
						for(int k=0;k<portcodeLst.size();k++){
							String strs = portcodeLst.get(k);
							String[] str;
							if(strs.indexOf(";")!=-1){
								str = strs.split(";");
							}else{
								str = new String[]{strs};
							}
							for(int s=0;s<str.length;s++){
								//根据端口编号查找框、盘、槽信息
								LogicPort lport = this.sceneMgrDao.getLogicPortInfos(str[s]);
								objAlarmDes = cm0.getLabel() + "/" + stationName+"."+
								lport.getFrameserial()+"框."+lport.getPackserial()+"盘"+
								lport.getSlotserial()+"槽"+lport.getPortserial()+"端口";
								alarmModel.setAlarmobjdesc(objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙
								alarmModel.setBelongframe(lport.getFrameserial());
								alarmModel.setBelongpack(lport.getPackserial());
								alarmModel.setBelongport(lport.getPortserial());
								alarmModel.setBelongslot(lport.getSlotserial());
								alarmModel.setBelongportcode(str[s]);
								alarmModel.setCarrycircuit(""
										+ this.carryOperaDao
												.getCarryOperaCountByLogicPort(
														str[s], 0));
								
								// 按用户插入
								DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
								long now = System.currentTimeMillis();
								long newnow = now-10*60*1000;
								Calendar calendar = Calendar.getInstance();
								calendar.setTimeInMillis(newnow);
								
								// 按用户插入
								int p=0;
								for (int a = 0; a < arr.length; a++) {
									alarmModel.setAlarmman(arr[a]);
									alarmModel.setEndTime(formatter.format(calendar.getTime()));
									List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
									if(info.size()==0){
										this.sceneMgrDao.insertAlarmInfo(alarmModel);
										p++;
									}
								}
								if(p>0){
									//插入仿真日志
									this.insertInterposeLog(alarmModel,model);
								}
							}
						}
						Set<String> set1 = this.ForEachAlarm(
								new HashSet<String>(), oper.getAlarm_id());
						set.addAll(set1);
					}else{
						//对端
						for(int k=0;k<portcodeLst.size();k++){
							String strs = portcodeLst.get(k);
							String[] str;
							if(strs.indexOf(";")!=-1){
								str = strs.split(";");
							}else{
								str = new String[]{strs};
							}
							for(int s=0;s<str.length;s++){
								//查找对端端口和设备
								List<String> idLst = new ArrayList<String>();
								Map map = new HashMap();
								map.put("equipA", equipcode);
								map.put("code", str[s]);
//								if("AT10000001".equals(model.getFaulttypeid())||"AT10000022".equals(model.getFaulttypeid())||"AT10000051".equals(model.getFaulttypeid())){
//									map.put("code", model.getCutportcode());
//								}else{
//									map.put("code", str[s]);
//								}
//								idLst = this.sceneMgrDao
//										.getZportCodeListByAportcode(map);
								String ratecode = this.sceneMgrDao.getPortrateByPortcode(map); 
								if("ZY070101".equals(ratecode)){//根据速率判断
									//电口通过复用段查找对端
									idLst = this.sceneMgrDao.getZportCodeListByToplink(map);
								}else{
									//光口通过交叉
									idLst = this.sceneMgrDao
									.getZportCodeListByAportcode(map);
								}
								for (int i = 0; i < idLst.size(); i++) {
									String Z_equipcode = this.sceneMgrDao
											.getZ_EquipcodeByPortCode(idLst.get(i));
									if (Z_equipcode != null) {
										ComboxDataModel zcm0 = this.sceneMgrDao
												.getTransystemByEquipCode(Z_equipcode);
										if (zcm0 == null) {
											zcm0 = new ComboxDataModel();
										}
										ComboxDataModel zcm1 = this.sceneMgrDao
												.getStationByEquipCode(Z_equipcode);
										String z_stationName;
										if (zcm1 != null) {
											z_stationName = zcm1.getLabel();
										} else {
											z_stationName = this.sceneMgrDao
													.getEquipNameByEquipcode(Z_equipcode);
										}
										String z_objAlarmDes = "";
										ComboxDataModel z_serial = new ComboxDataModel();
	
										objClass = "port";
										z_serial = this.sceneMgrDao.getSerialsByCodes(
												idLst.get(i), "logicport",
												"equiplogicport");
										// 根据端口查盘名称
										// 获取端口序号
										String portSerial = this.sceneMgrDao
												.getPortSerialById(idLst.get(i));
										z_objAlarmDes = zcm0.getLabel() + "/"
												+ z_stationName + "."
												+ z_serial.getId() + "框."
												+ z_serial.getLabel() + "盘"
												+this.sceneMgrDao
												.getEquipSlotSerialById(idLst.get(i))+"槽"+ portSerial + "端口";
	
										AlarmInfos alarmModel = new AlarmInfos();
										alarmModel.setInterposeid(model
												.getInterposeid());
										alarmModel.setAlarmlevel(this.sceneMgrDao
												.getAlarmLevelById(oper.getAlarm_id()));
										alarmModel
												.setBeginTime(this
														.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
										if (zcm1 != null) {
											alarmModel.setBelongstation(zcm1.getId());
										} else {
											alarmModel.setBelongstation("");
										}
	
										alarmModel.setProbablecause(oper.getAlarm_id());
										alarmModel.setAlarmdesc(oper.getAlarm_name());
										alarmModel.setAlarmobjdesc(z_objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙
	
										alarmModel.setBelongequip(Z_equipcode);
										alarmModel.setBelongframe(z_serial.getId());
	
										// 获取端口序号
										alarmModel.setBelongpack(z_serial.getLabel());
										alarmModel.setBelongport(this.sceneMgrDao
												.getPortSerialById(idLst.get(i)));
										// 根据端口查询承载业务
										alarmModel.setCarrycircuit(""
												+ this.carryOperaDao
														.getCarryOperaCountByLogicPort(
																idLst.get(i), 0));
										alarmModel.setBelongslot(this.sceneMgrDao
												.getEquipSlotSerialById(idLst.get(i)));
										alarmModel.setBelongportcode(idLst.get(i));
	
										alarmModel.setVendor(oper.getVendercode());
										alarmModel.setBelongtransys(zcm0.getId());
										alarmModel.setIscleared("0");
										alarmModel.setObjClass(objClass);
										alarmModel.setIsAck("0");
										alarmModel.setIsfilter("0");
										alarmModel.setTriggeredhour("12");
										// alarmModel.setVersion(version);
										alarmModel.setIsRootAlarm("0");
										String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
										alarmModel.setAlarmType(alarmtype);
										alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
										
										// 按用户插入
										DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
										long now = System.currentTimeMillis();
										long newnow = now-10*60*1000;
										Calendar calendar = Calendar.getInstance();
										calendar.setTimeInMillis(newnow);
										
										// 按用户插入
										int p=0;
										for (int j = 0; j < arr.length; j++) {
											alarmModel.setAlarmman(arr[j]);
											alarmModel.setEndTime(formatter.format(calendar.getTime()));
											List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
											if(info.size()==0){
												this.sceneMgrDao.insertAlarmInfo(alarmModel);
												p++;
											}
										}
										if(p>0){
											//插入仿真日志
											this.insertInterposeLog(alarmModel,model);
										}
									}
								}
								// 插入对端端口的伴随告警
								if (idLst.size() > 0) {
									Set<String> setZ1 = this.ForEachAlarm(
											new HashSet<String>(), oper.getAlarm_id());
									if (setZ1.size() > 0) {
										for (int j = 0; j < idLst.size(); j++) {
											this.insertEachAlarmTransmit(setZ1, model,
													idLst.get(j));
										}
									}
								}
							}
							
						}
					}
				}
			}
			if (set.size() > 0) {// 本端伴随告警
				this.insertCarryAlarmInfos(set,equipcode, model,arr,portcodeLst);
			}
		} catch (Exception e) {
			log.error("insertAlarmTransmit", e);
			e.printStackTrace();
		}
	}

	private void insertAlarmInfos(List<InterposeModel> alarmLst,
			String equipcode,InterposeModel model ,String[] arr,List<String> portcodeLst) {
		try{
			for (int i = 0; i < alarmLst.size(); i++) {
				InterposeModel key = alarmLst.get(i);
				String alarmIds = key.getAlarmid();
				String alarmId[];
				if (alarmIds.indexOf(";") != -1) {
					alarmId = alarmIds.split(";");
				} else {
					alarmId = new String[] { alarmIds };
				}
				for (int j = 0; j < alarmId.length; j++) {
					AlarmInfos alarmModel = new AlarmInfos();
					alarmModel.setInterposeid(model.getInterposeid());
					alarmModel.setAlarmlevel(this.sceneMgrDao
							.getAlarmLevelById(alarmId[j]));
					alarmModel.setBeginTime(this
							.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
					ComboxDataModel cm1 = this.sceneMgrDao
					.getStationByEquipCode(equipcode);
					if (cm1 != null) {
						alarmModel.setBelongstation(cm1.getId());
					} else {
						alarmModel.setBelongstation("");
					}
					ComboxDataModel cm0 = new ComboxDataModel();
					ComboxDataModel cm2 = this.sceneMgrDao
							.getTransystemByEquipCode(equipcode);
					if (cm2 != null) {
						cm0 = cm2;
					}
					String stationName="";
					if (cm1 != null) {
						stationName = cm1.getLabel();
					} else {
						stationName = this.sceneMgrDao
								.getEquipNameByEquipcode(equipcode);
					}
					
					String objClass = "port";
					alarmModel.setProbablecause(alarmId[j]);
					alarmModel.setBelongequip(equipcode);
					alarmModel.setVendor(key.getX_vendor());
					alarmModel.setBelongtransys(cm0.getId());
					alarmModel.setIscleared("0");
					alarmModel.setObjClass(objClass);
					alarmModel.setIsAck("0");
					alarmModel.setIsfilter("0");
					alarmModel.setTriggeredhour("12");
					String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
					alarmModel.setAlarmType(alarmtype);
					// 设置一个告警标识，区分跟告警和伴随告警
					alarmModel.setIsRootAlarm("0");
					// 查询告警名称
					alarmModel.setAlarmdesc(this.sceneMgrDao
							.getAlarmNameByAlarmId(alarmId[j]));
					alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
					
					for(int k=0;k<portcodeLst.size();k++){
						String strs = portcodeLst.get(k);
						String[] str;
						if(strs.indexOf(";")!=-1){
							str = strs.split(";");
						}else{
							str = new String[]{strs};
						}
						for(int s=0;s<str.length;s++){
							//根据端口编号查找框、盘、槽信息
							LogicPort lport = this.sceneMgrDao.getLogicPortInfos(str[s]);
							String objAlarmDes = cm0.getLabel() + "/" + stationName+"."+
							lport.getFrameserial()+"框."+lport.getPackserial()+"盘"+
							lport.getSlotserial()+"槽"+lport.getPortserial()+"端口";
							alarmModel.setAlarmobjdesc(objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙
							alarmModel.setBelongframe(lport.getFrameserial());
							alarmModel.setBelongpack(lport.getPackserial());
							alarmModel.setBelongport(lport.getPortserial());
							alarmModel.setBelongslot(lport.getSlotserial());
							alarmModel.setBelongportcode(str[s]);
							alarmModel.setCarrycircuit(""
									+ this.carryOperaDao
											.getCarryOperaCountByLogicPort(
													str[s], 0));
							
							// 按用户插入
							DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							long now = System.currentTimeMillis();
							long newnow = now-10*60*1000;
							Calendar calendar = Calendar.getInstance();
							calendar.setTimeInMillis(newnow);
							
							// 按用户插入
							int p=0;
							for (int t = 0; t < arr.length; t++) {
								alarmModel.setAlarmman(arr[t]);
								alarmModel.setEndTime(formatter.format(calendar.getTime()));
								List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
								if(info.size()==0){
									this.sceneMgrDao.insertAlarmInfo(alarmModel);
									p++;
								}
							}
							if(p>0){
								//插入仿真日志
								this.insertInterposeLog(alarmModel,model);
							}
						}
					}
				}
			}
		} catch (Exception e) {
			log.error("insertAlarmTransmit", e);
			e.printStackTrace();
		}
	}

	/**
	 * @author xgyin
	 * @param carryList
	 * @param model
	 */
	public void insertAlarmTransmit(Set<String> carryList, InterposeModel model) {
		try {
			Iterator<String> iterator = carryList.iterator();
			String[] arr;
			if (model.getUser_id().indexOf(",") != -1) {
				arr = model.getUser_id().split(",");
			} else {
				arr = new String[] { model.getUser_id() };
			}

			// String version =
			// this.sceneMgrDao.getVersionByProjectId(model.getProjectid());
			ComboxDataModel cm0 = this.sceneMgrDao
					.getTransystemByEquipCode(model.getEquipcode());
			if (cm0 == null) {
				cm0 = new ComboxDataModel();
			}
			ComboxDataModel cm1 = this.sceneMgrDao.getStationByEquipCode(model
					.getEquipcode());
			String stationName;
			if (cm1 != null) {
				stationName = cm1.getLabel();
			} else {
				stationName = this.sceneMgrDao.getEquipNameByEquipcode(model
						.getEquipcode());
			}
			String objClass = "";
			String objAlarmDes = "";
			ComboxDataModel serial = new ComboxDataModel();
			String[] arr1;
			if (model.getResourcecode().indexOf(",") != -1) {
				arr1 = model.getResourcecode().split(",");
			} else {
				arr1 = new String[] { model.getResourcecode() };
			}
			Set<String> set = new HashSet<String>();// 避免重复
			while (iterator.hasNext()) {
				List<OperateList> operList = this.sceneMgrDao
						.getAlarmTransmitByAlarmId(iterator.next());
				// 插入伴随告警
				for (int t = 0; t < operList.size(); t++) {
					OperateList oper = operList.get(t);
					if ("本端".equals(oper.getOper_desc())) {
						AlarmInfos alarmModel = new AlarmInfos();
						alarmModel.setInterposeid(model.getInterposeid());
						alarmModel.setAlarmlevel(this.sceneMgrDao
								.getAlarmLevelById(oper.getAlarm_id()));
						alarmModel.setBeginTime(this
								.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
						if (cm1 != null) {
							alarmModel.setBelongstation(cm1.getId());
						} else {
							alarmModel.setBelongstation("");
						}

						alarmModel.setProbablecause(oper.getAlarm_id());
						alarmModel.setAlarmdesc(oper.getAlarm_name());

						alarmModel.setBelongequip(model.getEquipcode());

						if ("端口".equals(model.getEquiptype())||"复用段".equals(model.getEquiptype())||"AT10000020".equals(model.getFaulttype())) {
							// objClass="port";
							if("AT10000001".equals(model.getFaulttypeid())||"AT10000022".equals(model.getFaulttypeid())||"AT10000051".equals(model.getFaulttypeid())){
								arr1[1]=model.getCutport();
								arr1[0] = ((ComboxDataModel)this.sceneMgrDao.getSlotSerialByPortCode(arr1[1])).getLabel();
							}
							serial = this.sceneMgrDao.getSerialsByCodes(
									arr1[1], "logicport", "equiplogicport");
							// 根据端口查盘名称
							// 获取端口序号
							String portSerial = this.sceneMgrDao
									.getPortSerialById(arr1[1]);
							objAlarmDes = cm0.getLabel() + "/" + stationName
									+ "." + serial.getId() + "框."
									+ serial.getLabel() + "盘" +arr1[0]+"槽"+ portSerial
									+ "端口";
							alarmModel.setAlarmobjdesc(objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙
							// 获取端口序号
							alarmModel.setBelongpack(serial.getLabel());
							alarmModel.setBelongport(this.sceneMgrDao
									.getPortSerialById(arr1[1]));
							// 根据端口查询承载业务
							alarmModel.setCarrycircuit(""
									+ this.carryOperaDao
											.getCarryOperaCountByLogicPort(
													arr1[1], 0));
							alarmModel.setBelongslot(arr1[0]);
							alarmModel.setBelongportcode(arr1[1]);
							alarmModel.setObjClass("port");
						} else if ("机盘".equals(model.getEquiptype())) {
							objClass = "circuitPack";
							serial = this.sceneMgrDao.getSerialsByCodes(
									arr1[1], "id", "equippack");
							objAlarmDes = cm0.getLabel() + "/" + stationName
									+ "." + serial.getId() + "框."
									+ serial.getLabel() + "盘"+arr1[0]+"槽";
							alarmModel.setAlarmobjdesc(objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙

							alarmModel.setBelongpack(serial.getLabel());
							alarmModel.setBelongport("");
							alarmModel.setBelongslot(arr1[0]);
							alarmModel.setBelongportcode("");
							alarmModel.setObjClass("circuitPack");
							alarmModel.setCarrycircuit(""
									+ this.carryOperaDao
											.getCarryOperaCountByEquipPack(
													model.getEquipcode(),
													serial.getId(), arr1[0],
													serial.getLabel(), 0));
						} else {
							objClass = "managedElement";
							objAlarmDes = cm0.getLabel() + "/" + stationName;
							alarmModel.setAlarmobjdesc(objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙

							alarmModel.setBelongpack("");
							alarmModel.setBelongport("");
							alarmModel.setBelongslot("");
							alarmModel.setBelongportcode("");
							alarmModel.setObjClass("managedElement");
							alarmModel.setCarrycircuit(""
									+ this.carryOperaDao
											.getCarryOperaCountByEquipcode(
													model.getEquipcode(), 0));
						}

						alarmModel.setVendor(oper.getVendercode());
						alarmModel.setBelongtransys(cm0.getId());
						alarmModel.setIscleared("0");
						alarmModel.setBelongframe(serial.getId());
						alarmModel.setIsAck("0");
						alarmModel.setIsfilter("0");
						alarmModel.setTriggeredhour("12");
						String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
						alarmModel.setAlarmType(alarmtype);
						// alarmModel.setVersion(version);
						alarmModel.setIsRootAlarm("0");
						alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
						// 按用户插入
						DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						long now = System.currentTimeMillis();
						long newnow = now-10*60*1000;
						Calendar calendar = Calendar.getInstance();
						calendar.setTimeInMillis(newnow);
						
						// 按用户插入
						int p=0;
						for (int j = 0; j < arr.length; j++) {
							alarmModel.setAlarmman(arr[j]);
							alarmModel.setEndTime(formatter.format(calendar.getTime()));
							List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
							if(info.size()==0){
								this.sceneMgrDao.insertAlarmInfo(alarmModel);
								p++;
							}
						}
						if(p>0){
							//插入仿真日志
							this.insertInterposeLog(alarmModel,model);
						}
						// 插入本端端口的伴随告警
						Set<String> set1 = this.ForEachAlarm(
								new HashSet<String>(), oper.getAlarm_id());
						set.addAll(set1);
					}
					if ("对端".equals(oper.getOper_desc())) {
						List<String> idLst = new ArrayList<String>();
						Map map = new HashMap();
						map.put("equipA", model.getEquipcode());
						if ("设备".equals(model.getEquiptype())||"AT10000021".equals(model.getFaulttype())) {
							// 查找对端端口
							idLst = this.sceneMgrDao
									.getZPortCodeListByEquipcode(model
											.getEquipcode());
						}

						else if ("端口".equals(model.getEquiptype())||"复用段".equals(model.getEquiptype())||"AT10000020".equals(model.getFaulttype())) {
							// 端口对端伴随告警
//							map.put("code", arr1[1]);
							if("AT10000001".equals(model.getFaulttypeid())||"AT10000022".equals(model.getFaulttypeid())||"AT10000051".equals(model.getFaulttypeid())){
								map.put("code", model.getCutportcode());
							}else{
								map.put("code", arr1[1]);
							}
//							idLst = this.sceneMgrDao
//									.getZportCodeListByAportcode(map);
							String ratecode = this.sceneMgrDao.getPortrateByPortcode(map); 
							if("ZY070101".equals(ratecode)){//根据速率判断
								//电口通过复用段查找对端
								idLst = this.sceneMgrDao.getZportCodeListByToplink(map);
							}else{
								//光口通过交叉
								idLst = this.sceneMgrDao
								.getZportCodeListByAportcode(map);
							}
						} else {
							// 机盘对端伴随告警
							map.put("code", arr1[1]);
							idLst = this.sceneMgrDao
									.getZportCodeListByPackcode(map);
						}
						// 根据端口插入告警
						String alarmId = oper.getAlarm_id();

						for (int i = 0; i < idLst.size(); i++) {
							String Z_equipcode = this.sceneMgrDao
									.getZ_EquipcodeByPortCode(idLst.get(i));
							if (Z_equipcode != null) {
								ComboxDataModel zcm0 = this.sceneMgrDao
										.getTransystemByEquipCode(Z_equipcode);
								if (zcm0 == null) {
									zcm0 = new ComboxDataModel();
								}
								ComboxDataModel zcm1 = this.sceneMgrDao
										.getStationByEquipCode(Z_equipcode);
								String z_stationName;
								if (zcm1 != null) {
									z_stationName = zcm1.getLabel();
								} else {
									z_stationName = this.sceneMgrDao
											.getEquipNameByEquipcode(Z_equipcode);
								}
								String z_objAlarmDes = "";
								ComboxDataModel z_serial = new ComboxDataModel();

								objClass = "port";
								z_serial = this.sceneMgrDao.getSerialsByCodes(
										idLst.get(i), "logicport",
										"equiplogicport");
								// 根据端口查盘名称
								// 获取端口序号
								String portSerial = this.sceneMgrDao
										.getPortSerialById(idLst.get(i));
								z_objAlarmDes = zcm0.getLabel() + "/"
										+ z_stationName + "."
										+ z_serial.getId() + "框."
										+ z_serial.getLabel() + "盘"
										+this.sceneMgrDao
										.getEquipSlotSerialById(idLst.get(i))+"槽"+ portSerial + "端口";

								AlarmInfos alarmModel = new AlarmInfos();
								alarmModel.setInterposeid(model
										.getInterposeid());
								alarmModel.setAlarmlevel(this.sceneMgrDao
										.getAlarmLevelById(alarmId));
								alarmModel
										.setBeginTime(this
												.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
								if (zcm1 != null) {
									alarmModel.setBelongstation(zcm1.getId());
								} else {
									alarmModel.setBelongstation("");
								}

								alarmModel.setProbablecause(alarmId);
								alarmModel.setAlarmdesc(oper.getAlarm_name());
								alarmModel.setAlarmobjdesc(z_objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙

								alarmModel.setBelongequip(Z_equipcode);
								alarmModel.setBelongframe(z_serial.getId());

								// 获取端口序号
								alarmModel.setBelongpack(z_serial.getLabel());
								alarmModel.setBelongport(this.sceneMgrDao
										.getPortSerialById(idLst.get(i)));
								// 根据端口查询承载业务
								alarmModel.setCarrycircuit(""
										+ this.carryOperaDao
												.getCarryOperaCountByLogicPort(
														idLst.get(i), 0));
								alarmModel.setBelongslot(this.sceneMgrDao
										.getEquipSlotSerialById(idLst.get(i)));
								alarmModel.setBelongportcode(idLst.get(i));

								alarmModel.setVendor(oper.getVendercode());
								alarmModel.setBelongtransys(zcm0.getId());
								alarmModel.setIscleared("0");
								alarmModel.setObjClass(objClass);
								alarmModel.setIsAck("0");
								alarmModel.setIsfilter("0");
								alarmModel.setTriggeredhour("12");
								String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
								alarmModel.setAlarmType(alarmtype);
								// alarmModel.setVersion(version);
								alarmModel.setIsRootAlarm("0");
								alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
								// 按用户插入
								DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
								long now = System.currentTimeMillis();
								long newnow = now-10*60*1000;
								Calendar calendar = Calendar.getInstance();
								calendar.setTimeInMillis(newnow);
								
								// 按用户插入
								int p=0;
								for (int j = 0; j < arr.length; j++) {
									alarmModel.setAlarmman(arr[j]);
									alarmModel.setEndTime(formatter.format(calendar.getTime()));
									List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
									if(info.size()==0){
										this.sceneMgrDao.insertAlarmInfo(alarmModel);
										p++;
									}
								}
								if(p>0){
									//插入仿真日志
									this.insertInterposeLog(alarmModel,model);
								}
							}
						}
						// 插入对端端口的伴随告警
						if (idLst.size() > 0) {
							Set<String> setZ1 = this.ForEachAlarm(
									new HashSet<String>(), alarmId);
							if (setZ1.size() > 0) {
								for (int j = 0; j < idLst.size(); j++) {
									this.insertEachAlarmTransmit(setZ1, model,
											idLst.get(j));
								}
							}
						}
					}
				}

			}

			if (set.size() > 0) {// 本端伴随告警
				this.insertAlarmTransmit(set, model);
			}
		} catch (Exception e) {
			log.error("insertAlarmTransmit", e);
			e.printStackTrace();
		}
	}

	/**
	 * @author xgyin
	 * @param set
	 * @param model
	 * @param portcode
	 */
	public void insertEachAlarmTransmit(Set<String> set, InterposeModel model,
			String portcode) {
		try {
			// 插入端口的伴随告警
			String[] arr;
			if (model.getUser_id().indexOf(",") != -1) {
				arr = model.getUser_id().split(",");
			} else {
				arr = new String[] { model.getUser_id() };
			}
			String equipcode;
			// String version =
			// this.sceneMgrDao.getVersionByProjectId(model.getProjectid());
			String objClass = "port";
			ComboxDataModel serial = new ComboxDataModel();

			String code = portcode;

			Iterator<String> iterator = set.iterator();
			while (iterator.hasNext()) {
				String alarmid = iterator.next();
				List<OperateList> operList = this.sceneMgrDao
						.getAlarmTransmitByAlarmId(alarmid);
				String objAlarmDes = "";

				for (int t = 0; t < operList.size(); t++) {
					OperateList oper = operList.get(t);
					if ("对端".equals(oper.getOper_desc())) {
						portcode = this.sceneMgrDao
								.getPortcode2ByPortCode1(code);
					}
					if (portcode != null) {
						equipcode = this.sceneMgrDao
								.getZ_EquipcodeByPortCode(portcode);
						if (equipcode != null) {
							ComboxDataModel cm0 = this.sceneMgrDao
									.getTransystemByEquipCode(equipcode);
							if (cm0 == null) {
								cm0 = new ComboxDataModel();
							}
							ComboxDataModel cm1 = this.sceneMgrDao
									.getStationByEquipCode(equipcode);
							String stationName;
							if (cm1 != null) {
								stationName = cm1.getLabel();
							} else {
								stationName = this.sceneMgrDao
										.getEquipNameByEquipcode(equipcode);
							}
							serial = this.sceneMgrDao.getSerialsByCodes(
									portcode, "logicport", "equiplogicport");
							// 根据端口查盘名称
							// 获取端口序号
							String portSerial = this.sceneMgrDao
									.getPortSerialById(portcode);
							objAlarmDes = cm0.getLabel() + "/" + stationName
									+ "." + serial.getId() + "框."
									+ serial.getLabel() + "盘" +this.sceneMgrDao
									.getEquipSlotSerialById(portcode)+"槽"+ portSerial
									+ "端口";
							AlarmInfos alarmModel = new AlarmInfos();
							alarmModel.setInterposeid(model.getInterposeid());
							alarmModel.setAlarmlevel(this.sceneMgrDao
									.getAlarmLevelById(oper.getAlarm_id()));
							alarmModel
									.setBeginTime(this
											.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
							if (cm1 != null) {
								alarmModel.setBelongstation(cm1.getId());
							} else {
								alarmModel.setBelongstation("");
							}

							alarmModel.setProbablecause(oper.getAlarm_id());
							alarmModel.setAlarmdesc(oper.getAlarm_name());
							alarmModel.setAlarmobjdesc(objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙

							alarmModel.setBelongequip(equipcode);
							alarmModel.setBelongframe(serial.getId());

							// 获取端口序号
							alarmModel.setBelongpack(serial.getLabel());
							alarmModel.setBelongport(this.sceneMgrDao
									.getPortSerialById(portcode));
							// 根据端口查询承载业务
							alarmModel.setCarrycircuit(""
									+ this.carryOperaDao
											.getCarryOperaCountByLogicPort(
													portcode, 0));
							alarmModel.setBelongslot(this.sceneMgrDao
									.getEquipSlotSerialById(portcode));
							alarmModel.setBelongportcode(portcode);

							alarmModel.setVendor(oper.getVendercode());
							alarmModel.setBelongtransys(cm0.getId());
							alarmModel.setIscleared("0");
							alarmModel.setObjClass(objClass);
							alarmModel.setIsAck("0");
							alarmModel.setIsfilter("0");
							alarmModel.setTriggeredhour("12");
							// alarmModel.setVersion(version);
							String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
							alarmModel.setAlarmType(alarmtype);
							alarmModel.setIsRootAlarm("0");
							alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
							// 按用户插入
							DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							long now = System.currentTimeMillis();
							long newnow = now-10*60*1000;
							Calendar calendar = Calendar.getInstance();
							calendar.setTimeInMillis(newnow);
							
							// 按用户插入
							int p=0;
							for (int j = 0; j < arr.length; j++) {
								alarmModel.setAlarmman(arr[j]);
								alarmModel.setEndTime(formatter.format(calendar.getTime()));
								List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
								if(info.size()==0){
									this.sceneMgrDao.insertAlarmInfo(alarmModel);
									p++;
								}
							}
							if(p>0){
								//插入仿真日志
								this.insertInterposeLog(alarmModel,model);
							}

						}
						Set<String> hashSet = this.ForEachAlarm(
								new HashSet<String>(), alarmid);
						if (hashSet.size() > 0) {
							this.insertEachAlarmTransmit(hashSet, model,
									portcode);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("insertEachAlarmTransmit", e);
		}
	}

	/**
	 * @author xgyin
	 * @param alarmid
	 * @return set<String>
	 * 
	 */
	public Set<String> ForEachAlarm(Set<String> set, String alarmid) {
		String alarmIds = this.sceneMgrDao.getAlarmIdsByAlarmId(alarmid);
		if (alarmIds != null) {
			String arr[];
			if (alarmIds.indexOf(",") != -1) {
				arr = alarmIds.split(",");
			} else {
				arr = new String[] { alarmIds };
			}
			set.add(arr[0]);
			for (int i = 0; i < arr.length; i++) {
				set.add(arr[i]);
			}
		}
		return set;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return ResultModel
	 * @name getAllInterposeConfig
	 */
	public ResultModel getAllInterposeConfig(InterposeModel model) {
		ResultModel result = new ResultModel();
		try {
			result.setTotalCount(sceneMgrDao.getAllInterposeConfigCount(model));
			result.setOrderList(sceneMgrDao.getAllInterposeConfigList(model));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "仿真模块", "查询干预配置", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("getAllInterposeConfig", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return String
	 * @name delInterposeConfig
	 */
	public String delInterposeConfig(InterposeModel model) {
		String str;
		try {
			sceneMgrDao.delInterposeConfig(model);
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("删除", "故障仿真模块", "删除干预配置", "", request);
			str = "success";
		} catch (Exception e) {
			str = "error";
			log.error("delInterposeConfig", e);
		}
		return str;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return String
	 * @name addInterposeConfig
	 */
	public String addInterposeConfig(InterposeModel model) {
		String result = "failed";
		try {
			sceneMgrDao.addInterposeConfig(model);
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "故障仿真模块", "添加干预配置", "", request);
		} catch (Exception e) {
			result = "failed";
			e.printStackTrace();
			log.error("addInterposeConfig", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return String
	 * @name addInterposeConfig
	 */
	public String modifyInterposeConfig(InterposeModel model) {
		String result = "failed";
		try {
			sceneMgrDao.modifyInterposeConfig(model);
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "修改仿真模块", "添加干预配置", "", request);
		} catch (Exception e) {
			result = "failed";
			e.printStackTrace();
			log.error("modifyInterposeConfig", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return ResultModel
	 * @name getAllInterposeAlarmConfig
	 */
	public ResultModel getAllInterposeAlarmConfig(InterposeModel model) {
		ResultModel result = new ResultModel();
		try {
			result.setTotalCount(sceneMgrDao
					.getAllInterposeAlarmConfigCount(model));
			result.setOrderList(sceneMgrDao
					.getAllInterposeAlarmConfigList(model));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "仿真模块", "查询干预告警信息", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("getAllInterposeAlarmConfig", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return String
	 * @name delInterposeAlarmConfig
	 */
	public String delInterposeAlarmConfig(InterposeModel model) {
		String result = "failed";
		try {
			sceneMgrDao.delInterposeAlarmConfig(model.getAlarmconfid());
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("删除", "仿真模块", "删除干预告警信息", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("delInterposeAlarmConfig", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return String
	 * @name addInterposeAlarmConfig
	 */
	public String addInterposeAlarmConfig(InterposeModel model) {
		String result = "failed";
		try {
			sceneMgrDao.addInterposeAlarmConfig(model);
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "故障仿真模块", "添加干预告警配置", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("addInterposeAlarmConfig", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return String
	 * @name modifyInterposeAlarmConfig
	 * 
	 */
	public String modifyInterposeAlarmConfig(InterposeModel model) {
		String result = "failed";
		try {
			sceneMgrDao.modifyInterposeAlarmConfig(model);
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("修改", "故障仿真模块", "修改干预告警配置", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("modifyInterposeAlarmConfig", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return ResultModel
	 * @param StdMaintainProModel
	 * @name getAllInterposeStdMaintain
	 */
	public ResultModel getAllInterposeStdMaintain(StdMaintainProModel model) {
		ResultModel result = new ResultModel();
		try {
			result.setTotalCount(sceneMgrDao
					.getAllInterposeStdMaintainCount(model));
			result.setOrderList(sceneMgrDao
					.getAllInterposeStdMaintainList(model));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "仿真模块", "查询干预维护过程信息", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("getAllInterposeStdMaintain", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return String
	 * @param StdMaintainProModel
	 * @name addInterposeMaintainProc
	 */
	public String addInterposeMaintainProc(StdMaintainProModel model) {
		String result = "failed";
		try {
			sceneMgrDao.addInterposeMaintainProc(model);
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "故障仿真模块", "添加干预标准维护过程", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("addInterposeMaintainProc", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return String
	 * @param StdMaintainProModel
	 * @name modifyInterposeMaintainProc
	 */
	public String modifyInterposeMaintainProc(StdMaintainProModel model) {
		String result = "failed";
		try {
			sceneMgrDao.modifyInterposeMaintainProc(model);
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("修改", "故障仿真模块", "修改干预标准维护过程", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("modifyInterposeMaintainProc", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param StdMaintainProModel
	 * @return String
	 * @name delInterposeMaintainProc
	 */
	public String delInterposeMaintainProc(StdMaintainProModel model) {
		String result = "failed";
		try {
			sceneMgrDao.delInterposeMaintainProc(model.getMaintainprocid());
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("删除", "仿真模块", "删除干预标准维护过程", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("delInterposeMaintainProc", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return String
	 * @param string
	 *            ,string,string
	 * @name checkOperateOrder
	 */
	public String checkOperateOrder(String order, String interposetypeid,
			String faulttypeid) {
		String result = "success";
		Map map = new HashMap();
		map.put("order", order);
		map.put("interposetypeid", interposetypeid);
		map.put("faulttypeid", faulttypeid);
		try {
			List<StdMaintainProModel> model = sceneMgrDao
					.selectOperateOrderByMap(map);
			if (model.size() > 0) {
				result = "fialed";
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("checkOperateOrder", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return String
	 * @param String
	 * @name getOperateTypeByeqsearch
	 */
	public String getOperateTypeByeqsearch(String cond) {
		String result = "";
		List<ComboxDataModel> list = sceneMgrDao.getOperateTypeByeqsearch(cond);
		for (ComboxDataModel data : list) {
			result += "<operatetype id=\""
					+ data.getId()
					+ "\"label=\""
					+ data.getLabel()
					+ "\" name=\"operatetype\" isBranch=\"false\"></operatetype>";
		}
		return result;
	}
	
	/**
	 * @author 尹显贵
	 * @param string
	 * @return string
	 **/
	public String getCutPortResourceByrsearch(String equipcode,String restype,String rescode,String cond){
		String result="";
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("cond", cond);
		if("单板".equals(restype)){
			if(rescode.indexOf(",")!=-1&&rescode.split(",").length==2){
				rescode = rescode.split(",")[1];
			}
			map.put("packcode", rescode);//机盘ID
			//选择单板，要求和当前选的单板型号、端口速率一样，而且未被占用，且所选的单板端口数目要和未被占用的端口数目一样
			//1、查找当前机盘下端口的速率、型号，有业务的端口数目
			EquipPack model = this.sceneMgrDao.getEquipPackInfo(rescode);
			if(model!=null){
				map.put("portrate", model.getPortrate());
				map.put("packmodel", model.getPackmodel());
				List<String> circuitportLst = this.sceneMgrDao.getPortInUseByPack(map);
				if(circuitportLst.size()>0){
					map.put("portnum", circuitportLst.size());
					//根据设备端口类型、速率查找机盘（不包含当前盘）；
					List<String> lst = this.sceneMgrDao.getPackListByTypeAndRate(map);
					//查找机盘列表中未被占用端口数大于等于portnum的机盘
					if(lst.size()>0){
						List<String> packLst = new ArrayList<String>();
						for(int j=0;j<lst.size();j++){
							map.put("newid", lst.get(j));
							List<String> portlst = this.sceneMgrDao.getLogicPortNotUseByMap(map);
							if(portlst.size()>=circuitportLst.size()&&!rescode.equals(lst.get(j))){
								packLst.add(lst.get(j));
							}
						}
						if(packLst.size()>0){
							map.put("packlst", packLst);
							map.put("labelname", "t.s_packname||'-'||t.frameserial||'框'||t.slotserial||'槽'");
							List<HashMap> list = sceneMgrDao.getCutPackResourceByrsearch(map);
							for (HashMap data : list) {
								result += "<pack id=\""
										+ (String)data.get("ID")
										+ "\"label=\""
										+ (String)data.get("LABEL")
										+ "\" name=\"pack\" isBranch=\"false\"></pack>";
							}
						}
					}
				}
			}
		}else{
			map.put("portcode", rescode);
			//端口列表，要求端口速率、类型一样且未被占用
			LogicPort port = this.sceneMgrDao.getLogicPortInfos(rescode);
			if(port!=null){
				map.put("portrate", port.getX_capability());
				map.put("porttype", port.getY_porttype());
				map.put("frameserial", port.getFrameserial());
				map.put("slotserial", port.getSlotserial());
				map.put("packserial", port.getPackserial());
				List<ComboxDataModel> list = sceneMgrDao.getCutPortResourceByrsearch(map);
				for (ComboxDataModel data : list) {
					result += "<port id=\""
							+ data.getId()
							+ "\"label=\""
							+ data.getLabel()
							+ "\" name=\"port\" isBranch=\"false\"></port>";
				}
			}
			
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param StdMaintainProModel
	 * @return ResultModel
	 * @name getAllEventMaintainProc
	 */
	public ResultModel getAllEventMaintainProc(StdMaintainProModel model) {
		ResultModel result = new ResultModel();
		try {
			result.setTotalCount(sceneMgrDao
					.getAllEventMaintainProcCount(model));
			result.setOrderList(sceneMgrDao.getAllEventMaintainProcList(model));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "仿真模块", "查询维护过程配置信息", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("getAllEventMaintainProc", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param StdMaintainProModel
	 * @return String
	 * @name delEventMaintainProc
	 */
	public String delEventMaintainProc(StdMaintainProModel model) {
		String result = "failed";
		try {
			sceneMgrDao.delEventMaintainProc(model.getOperatetypeid());
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("删除", "仿真模块", "删除维护过程配置信息", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("delEventMaintainProc", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return String
	 * @param StdMaintainProModel
	 * @name addEventMaintainProc
	 */
	public String addEventMaintainProc(StdMaintainProModel model) {
		String result = "failed";
		try {
			sceneMgrDao.addEventMaintainProc(model);
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "仿真模块", "新增维护过程配置信息", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("addEventMaintainProc", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return String
	 * @param StdMaintainProModel
	 * @name addEventMaintainProc
	 */
	public String modifyEventMaintainProc(StdMaintainProModel model) {
		String result = "failed";
		try {
			sceneMgrDao.modifyEventMaintainProc(model);
			result = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("修改", "仿真模块", "修改维护过程配置信息", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("modifyEventMaintainProc", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return String
	 * @param string
	 * @name checkOperateType
	 */
	public String checkOperateType(String operatetype) {
		String result = "success";
		try {
			List<StdMaintainProModel> model = sceneMgrDao
					.selectOperateTypeByName(operatetype);
			if (model.size() > 0) {
				result = "fialed";
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("checkOperateType", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @param InterposeModel
	 * @return string
	 * @name checkEventHasSolution
	 */
	public String checkEventHasSolution(InterposeModel model) {
		String result = "failed";
		try {
			List<StdMaintainProModel> list = this.sceneMgrDao
					.getEventSolutionLst(model);
			List<InterposeModel> list1 = this.sceneMgrDao
					.getInterposeAlarmConfigListByModel(model);
			if (list.size() > 0 && list1.size() > 0) {
				result = "success";
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("checkEventHasSolution", e);
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return ResultModel
	 * @param OperateList
	 *            name getAllOperateListByUser
	 */
	public ResultModel getAllOperateListByUser(OperateList model) {
		ResultModel result = new ResultModel();
		try {
			result.setTotalCount(sceneMgrDao
					.getAllOperateListByUserCount(model));
			result.setOrderList(sceneMgrDao.getAllOperateListByUserList(model));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "仿真模块", "查询仿真操作记录", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("getAllOperateListByUser", e);
		}
		return result;
	}

	// 获取干预用户树
	public String getOperateUserIdByID(String pid, String userid, String type) {
		String xml = "";
		Map resultMap = new HashMap();
		if (type.equalsIgnoreCase("root")) {// 查询科目名称
			xml += "<list>";
			List<HashMap> interposename = sceneMgrDao.getInterposeNameById(pid);
			for (int i = 0; i < interposename.size(); i++) {
				resultMap = interposename.get(i);
				xml += "<interpose name=\""
						+ resultMap.get("INTERPOSENAME").toString()
						+ "\" id=\"" + resultMap.get("INTERPOSEID").toString()
						+ "\" isBranch=\"true\"></interpose>";
			}
			xml += "</list>";
		} else if (type.equalsIgnoreCase("userid")) {
			Map map = new HashMap();
			map.put("interposeid", pid);
			// 查询科目下的用户
			List<HashMap> lstInterpose = sceneMgrDao
					.getInterposeUserListById(map);
			for (int i = 0; i < lstInterpose.size(); i++) {
				resultMap = lstInterpose.get(i);
				xml += "<userinfo name=\""
						+ resultMap.get("USERNAME").toString() + "\" id=\""
						+ resultMap.get("USERID").toString()
						+ "\" interposeid=\"" + pid
						+ "\" isBranch=\"false\" checked=\"0\">";
				xml += "</userinfo>";
			}
		}
		return xml;
	}

	/**
	 * @author xgyin
	 * @param string
	 * @return string
	 * @name getX_VendorByEquipcode
	 */
	public String getX_VendorByEquipcode(String equipcode) {
		String result = "";
		result = sceneMgrDao.getX_vendorByEquipcode(equipcode);
		result = result + ":" + sceneMgrDao.getX_vendorNameById(result);
		return result;
	}

	// 获取设备类型列表

	public String getEquiptypeLst(String type) {
		String result = "";
		List<ComboxDataModel> list = sceneMgrDao.getEquiptypeLst(type);
		for (ComboxDataModel data : list) {
			result += "<equiptype id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"equiptype\" isBranch=\"false\"></equiptype>";
		}
		return result;
	}
	
	public String getFaultTypelst(){
		String result="";
		List<ComboxDataModel> list = sceneMgrDao.getFaultTypelst();
		for (ComboxDataModel data : list) {
			result += "<faulttype id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"faulttype\" isBranch=\"false\"></faulttype>";
		}
		return result;
	}
	
	public String getFaulttypeLst(String interposetypeid,String equiptype){
		String result="";
		Map map = new HashMap();
		map.put("interposetypeid", interposetypeid);
		if("ocable".equals(equiptype)){
			map.put("equiptype", "光缆");
		}else{
			map.put("equiptype", "光纤");
		}
		
		List<ComboxDataModel> list = sceneMgrDao.getFaultTypelstByMap(map);
		for (ComboxDataModel data : list) {
			result += "<faulttype id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"faulttype\" isBranch=\"false\"></faulttype>";
		}
		return result;
	}

	/**
	 * 
	 * @Title: getVersionXml
	 * @Description: 获取资源版本的信息
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @author mawj
	 * @throws
	 */
	public String getVersionXml() {
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "仿真模块", "查询资源版本信息", "", request);
		StringBuilder versionXml = new StringBuilder();
		versionXml.append("<names>");
		ForTimeBaseDAO dao = new ForTimeBaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet r = null;
		c = dao.getConnection();
		try {
			String currVersion = LoginDwr.getCurrVersionByUser();
			// 查询默认资源版本下的版本信息
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			String sql = "select vid as code,vname as vname from "
					+ ConstArgs.DEFAULT_DATABASE + ".version where vid='"
					+ currVersion + "' order by vcode";
			System.out.println(sql);
			r = s.executeQuery(sql);
			while (r.next()) {
				versionXml.append("<name code=\"").append(r.getString("code"))
						.append("\" label=\"").append(r.getString("vname"))
						.append("\"/>");
			}
			versionXml.append("</names>");
		} catch (Exception e) {
			e.printStackTrace();
			log.error("getVersionXml", e);
		} finally {
			dao.closeConnection(c, s, r);
		}
		return versionXml.toString();
	}

	/**
	 * 
	 * @Title: getUserInfoByeqsearch
	 * @Description: 获取用户，并初始化已选择内容
	 * @param @param user_name
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @author mawj
	 * @throws
	 */
	public String getUserInfoByUser(String user_name, String userids) {
		String result = "";
		List<ComboxDataModel> list = sceneMgrDao
				.getUserInfoByeqsearch(user_name);
		for (ComboxDataModel data : list) {
			String checked = "0";
			if (userids != null && !"".equals(userids)
					&& userids.indexOf(data.getId()) >= 0) {
				checked = "1";
			}
			result += "<userinfo id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"userinfo\" isBranch=\"false\" checked=\""
					+ checked + "\"></userinfo>";
		}

		return result;
	}

	/**
	 * @param string
	 * @author xgyin
	 * @return ResultModel
	 * @name getStdFlowByID
	 */
	@SuppressWarnings("unchecked")
	public ResultModel getStdFlowByID(String interposeid) {
		ResultModel result = new ResultModel();
		List<StdMaintainProModel> list = new ArrayList();
		list = this.sceneMgrDao.getStdFlowByID(interposeid);
		result.setOrderList(list);
		return result;
	}

	/**
	 * @param string
	 *            ,string
	 * @return ResultModel
	 * @author xgyin
	 * @name getUserFlowByID
	 */
	public ResultModel getUserFlowByID(String interposeid, String userid) {
		ResultModel result = new ResultModel();
		Map map = new HashMap();
		map.put("interposeid", interposeid);
		map.put("updateperson", userid);
		List<OperateList> list = new ArrayList();
		list = this.sceneMgrDao.getUserFlowByID(map);
		result.setOrderList(list);
		return result;
	}

	/**
	 * 
	 * @Title: getResourceByrsearch
	 * @Description: 查询场景所对应的资源版本数据里的资源信息
	 * @param @param eqcode
	 * @param @param restype
	 * @param @param projectid
	 * @param @param rsearch
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @author mawj
	 * @throws
	 */
	public String getResourceByrsearch(String eqcode, String restype,
			String rsearch) {
		StringBuffer result = new StringBuffer();
		String tablename = "equipment";
		String idname = "equipcode";
		String labelname = "s_sbmc";
		String eqcodename = "equipcode";
		String sortid="";
		if ("端口".equals(restype)) {
			tablename = "equiplogicport";
			idname = "slotserial||','||logicport";
			labelname = "frameserial || '框' || slotserial || '槽' ||'-'||getpackmodelbylogicport(logicport)||'-'|| portserial || '端口'";
			eqcodename = "equipcode";
			sortid = "to_number(frameserial),to_number(slotserial),to_number(portserial)";
		} else if ("复用段".equals(restype)) {
//			tablename = "en_topolink";
//			idname = "label";
//			labelname = "s_sbmc";
//			eqcodename = "equipcode";
			//根据设备编号查找所有的复用段编号，起止端口
			List<String> list = this.sceneMgrDao.getEn_toplinkAndPortsByEquipcode(eqcode);
			for(int i=0;i<list.size();i++){
				String[] arr = list.get(i).split(";");
				String id = "";
				String label1 = "";
				String label2 = "";
				if(arr.length==3){
					id=arr[0];
					label1 = this.sceneMgrDao.getToplinkLabelByPortcode(arr[1]);
					label2 = this.sceneMgrDao.getToplinkLabelByPortcode(arr[2]);
					result.append("<equip id=\"" + id + "\"label=\""
							+ label1+"--"+label2
							+ "\" name=\"equip\" isBranch=\"false\"></equip>");
					return result.toString();
				}
			}
			
		} 
		else if("修改单板".equals(restype)){
			//查找设备下所有有端口的单板、且端口上需有业务
			Map map = new HashMap();
			map.put("equipcode", eqcode);
			map.put("cond", rsearch);
			map.put("labelname", "t.frameserial||'框'||t.slotserial||'槽'||'-'||t.s_packname");
			List<HashMap> list = sceneMgrDao.getPackResourceByrsearch(map);
			
			for (HashMap data : list) {
				result.append("<pack id=\"" + (String)data.get("ID") + "\"label=\""
						+ (String)data.get("LABEL")
						+ "\" name=\"pack\" isBranch=\"false\"></pack>");
			}
			return result.toString();
		}
		else if ("机盘".equals(restype)) {
			tablename = "equippack";
			idname = "slotserial||','||id";
			labelname = "s_packname||'-'||frameserial||'框'||slotserial||'槽'";
			eqcodename = "equipcode";
			sortid = "to_number(frameserial),to_number(slotserial)";
		}
		Map map = new HashMap();
		map.put("eqcode", eqcode);//设备编码
		map.put("rsearch", rsearch);
		map.put("tablename", tablename);
		map.put("idname", idname);
		map.put("labelname", labelname);
		map.put("eqcodename", eqcodename);
		map.put("sortid", sortid);
		List<ComboxDataModel> list = sceneMgrDao.getResourceByrsearch(map);
		for (ComboxDataModel data : list) {
			result.append("<equip id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"equip\" isBranch=\"false\"></equip>");
		}
		return result.toString();
	}

	/**
	 * 
	 * @Title: getResourceNameAndID
	 * @Description: 从机盘上初始化所对应的资源版本数据里的资源信息
	 * @param @param eqcode
	 * @param @param frameserial
	 * @param @param slotserial
	 * @param @param packserial
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @author lsyu
	 * @throws
	 */
	public String getResourceNameAndID(String eqcode, String frameserial,
			String slotserial, String packserial) {
		StringBuffer result = new StringBuffer();
		Map map = new HashMap();
		map.put("equipcode", eqcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		List<ComboxDataModel> list = sceneMgrDao.getResourceNameAndID(map);
		for (ComboxDataModel data : list) {
			result.append(data.getId() + ":" + data.getLabel());
		}
		return result.toString();
	}

	/**
	 * 
	 * @Title: getResourceNameAndID
	 * @Description: 从端口上初始化所对应的资源版本数据里的资源信息
	 * @param @param eqcode
	 * @param @param frameserial
	 * @param @param slotserial
	 * @param @param packserial
	 * @param @param portserial
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @author lsyu
	 * @throws
	 */
	public String getResourceNameAndID(String eqcode, String frameserial,
			String slotserial, String packserial, String portserial) {
		StringBuffer result = new StringBuffer();
		Map map = new HashMap();
		map.put("equipcode", eqcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		map.put("portserial", portserial);
		List<ComboxDataModel> list = sceneMgrDao
				.getResourceOfportNameAndID(map);
		for (ComboxDataModel data : list) {
			result.append(data.getId() + ":" + data.getLabel());
		}
		return result.toString();
	}

	public String getCurrentDateString(String dateFormat) {
		Calendar cal = Calendar.getInstance(TimeZone.getDefault());
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
		sdf.setTimeZone(TimeZone.getDefault());

		return sdf.format(cal.getTime());
	}

	// 台账-机框的选择设备，处理函数
	public String getEquipNameByEquipcode(String paraValue) {
		String paraName = sceneMgrDao.getEquipNameByEquipcode(paraValue);
		return paraName;
	}

	/**
	 * @author xgyin
	 * @return string
	 * @param
	 * 要去掉割接类型的演习，割接不需要处理
	 */
	public String getInterposeIdsByAlarmModel(AlarmInfos alarmModel) {
		String result = "";
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel) session.getAttribute((String) session
				.getAttribute("userid"));
		String alarmman = "root";
		if (user != null) {
			alarmman = user.getUser_id();
		}
		alarmModel.setAlarmman(alarmman);
//		String port = alarmModel.getBelongport();
		String type="";
		String name="";
		if(!"".equals(alarmModel.getBelongport())&&alarmModel.getBelongport()!=null){
			type="端口";
			name = alarmModel.getBelongslot()+"槽"+alarmModel.getBelongport();
		}else if(!"".equals(alarmModel.getBelongpack())&&alarmModel.getBelongpack()!=null){
			type="机盘,端口";
			name = this.sceneMgrDao.getEquippackModelByMap(alarmModel.getBelongequip(),alarmModel.getBelongframe(),alarmModel.getBelongslot(),
					alarmModel.getBelongpack())+"-"+alarmModel.getBelongframe()+"框"+alarmModel.getBelongslot()+"槽"+alarmModel.getBelongpack()+"盘";
		}
		Map mp = new HashMap();
		mp.put("equipcode", alarmModel.getBelongequip());
		mp.put("type", type);
		mp.put("name", name);
		// 1.根据设备编号，查找演习科目id
		List<String> interposelst = this.sceneMgrDao
				.getInterposeIdsByEquipcode(mp);
		if (interposelst.size() > 0) {// 设备上有演习
			// 2.在告警列表中查找存在上述演习ID的告警，并返回演习ID
			Map map = new HashMap();
			map.put("iscleared", alarmModel.getIscleared());
			map.put("alarmman", alarmman);
			map.put("interposelst", interposelst);
			result = this.sceneMgrDao.getInterposeIdsByMap(map);
			if(result==null){
				result = this.sceneMgrDao.getInterposeIdsByAlarmModel(alarmModel);
			}
		} else {// 设备上无演习
			// 查询该设备对应的告警中的演习ID
			result = this.sceneMgrDao.getInterposeIdsByAlarmModel(alarmModel);
		}

		if (result == null) {
			result = "";
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return string
	 * @param string
	 * @name getInterposeTypeIds
	 */
	public String getInterposeTypeIds(String interposeid) {
		String result = "";
		InterposeModel model = this.sceneMgrDao
				.getInterposeTypeIds(interposeid);
		if (model != null) {
			result = model.getInterposetypeid() + ":"
					+ model.getInterposetype() + ":" + model.getFaulttypeid()
					+ ":" + model.getFaulttype();
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @return String
	 * @param 1.维护过程模型，2.演习科目编号串
	 * @name saveUserOperate
	 */

	@SuppressWarnings("unchecked")
	public String saveUserOperate(StdMaintainProModel model,String str){
	String result = "";String other="";
	if("环回(内环)".equals(model.getOperatedes())||"环回(外环)".equals(model.getOperatedes())){
		other="==环回状态正常";//用于环回的处理 如果环回 初始值为正常
	}
	try {
		// 如果是测试两端端口，需要查询对端端口
		String[] arr;
		if (model.getA_equipcode().indexOf("=") != -1) {
			arr = model.getA_equipcode().split("=");
		} else {
			arr = new String[] { model.getA_equipcode() };
		}
		model.setA_equipcode(arr[0]);
		List<String> idList = new ArrayList<String>();// 只包含跟告警的演习ID列表

		Map map = new HashMap();

		if (arr.length == 5) {
			model.setFrameserial(arr[1]);
			model.setSlotserial(arr[2]);
			model.setPackserial(arr[3]);
			model.setPortserial(arr[4]);

			map.put("equipcode", arr[0]);
			map.put("frameserial", arr[1]);
			map.put("slotserial", arr[2]);
			map.put("packserial", arr[3]);
			map.put("portserial", arr[4]);
			map.put("alarmman", model.getUpdateperson());

			String portcode1 = this.sceneMgrDao.getPortCodeByMap(map);// 获取本端端口
			String portcode2 = this.sceneMgrDao
					.getPortcode2ByPortCode1(portcode1);// 获取对端端口编号
			if (portcode2 != null && !"".equals(portcode2)) {
				String equipcode2 = this.sceneMgrDao
						.getEquipcodeByPortCode(portcode2);// 获取对端设备编号
				model.setZ_equipcode(equipcode2);
			}
		}

		if (arr.length == 1) {
			model.setFrameserial("");
			model.setSlotserial("");
			model.setPackserial("");
			model.setPortserial("");
		}
		if (arr.length == 4) {
			model.setFrameserial(arr[1]);
			model.setSlotserial(arr[2]);
			model.setPackserial(arr[3]);
			model.setPortserial("");
		}
		String[] arrlist;// 包含跟告警和伴随告警的演习ID列表
		if (str.indexOf(",") != -1) {
			arrlist = str.split(",");
		} else {
			arrlist = new String[] { str };
		}
		List<String> templst = new ArrayList<String>();
		for (int t = 0; t < arrlist.length; t++) {
			if (!templst.contains(arrlist[t])) {
				templst.add(arrlist[t]);
			}
		}

		// 查询该设备上的跟告警列表
		if (templst.size() > 0) {
			map.put("alarmman", model.getUpdateperson());
			map.put("templst", templst);
			idList = this.sceneMgrDao.getInterposeIdsByAlarmMap(map);
		}

		if (idList.size() > 0) {// 跟告警列表不为空
			int j = 0;
			List<String> listKey = new ArrayList<String>();// 存放操作成功的演习id

			for (int i = 0; i < idList.size(); i++) {// 循环取演习id,如果有操作步骤匹配，则将演习id存放listKey中。
				// 1.判断当前设备上的告警在对应的演习科目里面的设备编号是否匹配
				InterposeModel key = this.sceneMgrDao
						.getInterposeTypeIds(idList.get(i));
				//复用段
				List<String> links = new ArrayList();
				if("".equals(key.getEquipcode())||key.getEquipcode()==null){
					
					if("光缆".equals(key.getEquiptype())||"光纤".equals(key.getEquiptype())){
						//光缆
						links.add(key.getResourcecode());
					}else{
						//根据当前复用段和设备编号，查找复用段，如果存在则往下执行
						Map mp = new HashMap();
						mp.put("equipcode", model.getA_equipcode());
						mp.put("label", key.getResourcecode());
						links = this.sceneMgrDao.getTopLinksByMap(mp);
					}
				}
				if (model.getA_equipcode().equals(key.getEquipcode())||links.size()>0||"AT10000020".equals(key.getFaulttypeid())||"AT10000021".equals(key.getFaulttypeid())) {
					if("环回(内环)".equals(model.getOperatedes())){//||"环回(外环)".equals(model.getOperatedes())
						other="==环回状态不正常";//用于环回的处理 如果环回的设备为发生故障的设备 则环回(内环)结果为不正常
					}
					// 2.判断故障类型的解决方法是否包含当前操作方法
					Map map2 = new HashMap();
					map2.put("interposetypeid", key.getInterposetypeid());
					map2.put("faulttypeid", key.getFaulttypeid());
					String operatetype = this.sceneMgrDao
							.getOperateTypeByMap(map2);
					if (operatetype != null
							&& (operatetype
									.contains(model.getOperatetype()))) {
						// 清除告警
						Map map3 = new HashMap();
						map3.put("iscleared", "1");
						map3.put("alarmman", model.getUpdateperson());
						map3.put("interposeid", idList.get(i));
						this.sceneMgrDao.deleteAlarmByMap(map3);
						listKey.add(j, idList.get(i));
						j++;
					}
				}else{
				if("环回(外环)".equals(model.getOperatedes())){
					other="==环回状态不正常";//用于环回的处理 如果环回的设备不是发生故障的设备 则环回(外环)结果为不正常
					}
				}
			}
			if (j > 0) {
				// 操作保存
				for (int k = 0; k < listKey.size(); k++) {// 只插入匹配的演习
					InterposeModel key = this.sceneMgrDao
							.getInterposeTypeIds(listKey.get(k));
					// 查找维护过程表
					StdMaintainProModel smpmodel = this.sceneMgrDao
							.getStdMaintainProModelByType(model
									.getOperatetype());
					String strs[];
					if(!"".equals(smpmodel.getIsinterposeoperate())&&smpmodel.getIsinterposeoperate()!=null){
						if(smpmodel.getIsinterposeoperate().indexOf(";")!=-1){
							strs = smpmodel.getIsinterposeoperate().split(";");
						}else{
							strs = new String[]{smpmodel.getIsinterposeoperate()};
						}
					}else{
						strs = new String[]{};
					}
					List<String> lst = new ArrayList<String>();
					for(int t=0;t<strs.length;t++){
						lst.add(strs[t]);
					}
					List<String> links = new ArrayList();
					if("".equals(key.getEquipcode())||key.getEquipcode()==null){
						//根据当前复用段和设备编号，查找复用段，如果存在则往下执行
						Map mp = new HashMap();
						mp.put("equipcode", model.getA_equipcode());
						mp.put("label", key.getResourcecode());
						links = this.sceneMgrDao.getTopLinksByMap(mp);
						
					}
					if (lst.contains(key.getFaulttypeid())
							&& (model.getA_equipcode().equals(
									key.getEquipcode()))||links.size()>0||"AT10000020".equals(key.getFaulttypeid())||"AT10000021".equals(key.getFaulttypeid())) {
						result = smpmodel.getOperatedes();
					} else {
						result = smpmodel.getExpectedresult();
					}
					model.setExpectedresult(result);
					model.setInterposeid(listKey.get(k));
					this.sceneMgrDao.saveUserOperate(model);
					result += "==SUCCESS";
				}
			} else {// 每条干预都插入一个步骤
				for (int i = 0; i < idList.size(); i++) {
					InterposeModel key = this.sceneMgrDao
							.getInterposeTypeIds(idList.get(i));
					// 查找维护过程表
					StdMaintainProModel smpmodel = this.sceneMgrDao
							.getStdMaintainProModelByType(model
									.getOperatetype());
					List<String> links = new ArrayList();
					if("".equals(key.getEquipcode())||key.getEquipcode()==null){
						if("光缆".equals(key.getEquiptype())||"光纤".equals(key.getEquiptype())){
							links.add(key.getResourcecode());
						}else{
							//根据当前复用段和设备编号，查找复用段，如果存在则往下执行
							Map mp = new HashMap();
							mp.put("equipcode", model.getA_equipcode());
							mp.put("label", key.getResourcecode());
							links = this.sceneMgrDao.getTopLinksByMap(mp);
						}
					}
					String strs[];
					if(!"".equals(smpmodel.getIsinterposeoperate())&&smpmodel.getIsinterposeoperate()!=null){
						if(smpmodel.getIsinterposeoperate().indexOf(";")!=-1){
							strs = smpmodel.getIsinterposeoperate().split(";");
						}else{
							strs = new String[]{smpmodel.getIsinterposeoperate()};
						}
					}else{
						strs = new String[]{};
					}
					List<String> lst = new ArrayList<String>();
					for(int t=0;t<strs.length;t++){
						lst.add(strs[t]);
					}
					if (lst.contains(key.getFaulttypeid())
							&&( model.getA_equipcode().equals(
									key.getEquipcode()))||links.size()>0||"AT10000020".equals(key.getFaulttypeid())||"AT10000021".equals(key.getFaulttypeid())) {
						result = smpmodel.getOperatedes();
					} else {
						result = smpmodel.getExpectedresult();
					}
					//判断当前设备上是否有网元托管的故障，有，如果当前操作是ping网元，则应提示ping不通
					if("PING网元".equals(model.getOperatedes())){
						//1、查找当前设备上网元托管的故障列表
						Map map2 = new HashMap();
						map2.put("equipcode", model.getA_equipcode());
						map2.put("idList", idList);
						List<String> eventids = this.sceneMgrDao.getEventIdListByEquipcode(model.getA_equipcode());
						List<String> idlst = this.sceneMgrDao.getInterposeIdsByMap2(map2);
						boolean flag = false;
						for(int k=0;k<eventids.size();k++){
							if(idlst.contains(eventids.get(k))){
								flag=true;
								break;
							}
						}
						if(flag){
							result = "PING不通";
						}else{
							result = "可PING通";
						}
					}
					
					model.setExpectedresult(result);
					model.setInterposeid(idList.get(i));
					this.sceneMgrDao.saveUserOperate(model);
					result += "==fail";
				}
			}
		} else {
			for (int i = 0; i < arrlist.length; i++) {
				InterposeModel key = this.sceneMgrDao
						.getInterposeTypeIds(arrlist[i]);
				// 查找维护过程表
				StdMaintainProModel smpmodel = this.sceneMgrDao
						.getStdMaintainProModelByType(model
								.getOperatetype());
				List<String> links = new ArrayList();
				if("".equals(key.getEquipcode())||key.getEquipcode()==null){
					if("光缆".equals(key.getEquiptype())||"光纤".equals(key.getEquiptype())){
						links.add(key.getResourcecode());
					}else{
						//根据当前复用段和设备编号，查找复用段，如果存在则往下执行
						Map mp = new HashMap();
						mp.put("equipcode", model.getA_equipcode());
						mp.put("label", key.getResourcecode());
						links = this.sceneMgrDao.getTopLinksByMap(mp);
					}
				}
				String strs[];
				if(!"".equals(smpmodel.getIsinterposeoperate())&&smpmodel.getIsinterposeoperate()!=null){
					if(smpmodel.getIsinterposeoperate().indexOf(";")!=-1){
						strs = smpmodel.getIsinterposeoperate().split(";");
					}else{
						strs = new String[]{smpmodel.getIsinterposeoperate()};
					}
				}else{
					strs = new String[]{};
				}
				List<String> lst = new ArrayList<String>();
				for(int t=0;t<strs.length;t++){
					lst.add(strs[t]);
				}
				if (lst.contains(key.getFaulttypeid())
						&& (model.getA_equipcode()
								.equals(key.getEquipcode()))||links.size()>0||"AT10000020".equals(key.getFaulttypeid())||"AT10000021".equals(key.getFaulttypeid())) {
					result = smpmodel.getOperatedes();
				} else {
					result = smpmodel.getExpectedresult();
				}
				
				model.setExpectedresult(result);
				model.setInterposeid(arrlist[i]);
				this.sceneMgrDao.saveUserOperate(model);
				result += "==fail";
			}
		}
		// 操作后的分析
	} catch (Exception e) {
		log.error("saveUserOperate", e);
		e.printStackTrace();
	}
	return result+other;
	}

	/**
	 * @author xgyin
	 * @param String
	 * @return String
	 * @name getInterposeNameByeqsearch
	 */
	public String getInterposeNameByeqsearch(String projectname) {
		String result = "";
		List<ComboxDataModel> list = sceneMgrDao
				.getInterposeNameByeqsearch(projectname);
		for (ComboxDataModel data : list) {
			result += "<projectname id=\""
					+ data.getId()
					+ "\" label=\""
					+ data.getLabel()
					+ "\" name=\"projectname\" isBranch=\"false\"></projectname>";
		}

		return result;
	}

	/**
	 * @Title: getOperateByeqsearch
	 * @Description: 获取用户，并初始化已选择内容
	 * @param @param user_name
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @author mawj
	 * @throws
	 */
	public String getOperateByeqsearch(String names, String ids) {
		String result = "";
		List<ComboxDataModel> list = sceneMgrDao.getOperateTypeByeqsearch("");
		for (ComboxDataModel data : list) {
			String checked = "0";
			if (ids != null && !"".equals(ids)
					&& ids.indexOf(data.getId()) >= 0) {
				checked = "1";
			}
			result += "<userinfo id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"userinfo\" isBranch=\"false\" checked=\""
					+ checked + "\"></userinfo>";
		}

		return result;
	}

	/**
	 * 告警传递规则管理
	 * 
	 * @return
	 */
	public String getAllFunctions() {
		List<OperateList> opers = null;
		opers = (ArrayList) sceneMgrDao.getAlarmOperations("0");
		StringBuffer sb = new StringBuffer("<node id='0' name='告警传递' icon=''>");
		forEachOper(sb, opers);
		sb.append("</node>");
		return sb.toString();
	}

	private void forEachOper(StringBuffer str, List<OperateList> opers) {
		for (OperateList oper : opers) {
			str
					.append("<node id='"
							+ oper.getOper_id()
							+ "' name='"
							+ oper.getAlarm_name()
							+ "' alarm_id='"
							+ oper.getAlarm_id()
							+ "' oper_type='"
							+ oper.getOper_type()
							+ "' vendercode='"
							+ oper.getVendercode()
							+ "' vender='"
							+ oper.getVender()
							+ "' parentid='"
							+ oper.getParent_id()
							+ "' oper_desc='"
							+ oper.getOper_desc()
							+ "' checked='0' icon='assets/images/sysManager/plugin.gif'>");
			List<OperateList> childOpers = (ArrayList) sceneMgrDao
					.getAlarmOperations(oper.getOper_id());
			if (childOpers.size() > 0) {
				forEachOper(str, childOpers);
			}
			str.append("</node>");
		}
	}

	public void delAlarmOperation(String oper_id) {
		sceneMgrDao.delAlarmOperation(oper_id);
		List<OperateList> opers = (ArrayList) sceneMgrDao
				.getAlarmOperations(oper_id);
		for (OperateList operModel : opers) {
			sceneMgrDao.delAlarmOperation(operModel.getOper_id());
			List<OperateList> subOpers = (ArrayList) sceneMgrDao
					.getAlarmOperations(operModel.getOper_id());
			for (OperateList subOperModel : subOpers) {
				sceneMgrDao.delAlarmOperation(subOperModel.getOper_id());
			}
		}
	}

	public void updateAlarmOperationByOperId(OperateList oform) {
		sceneMgrDao.updateAlarmOperationByOperId(oform);
	}
	
	/**
	 * @author 尹显贵
	 * @name getToplinkRateByCode
	 * @param String 
	 * @return String 
	 */
	public String getToplinkRateByCode(String toplinkid){
		String result="Fail";
		String rate="";
		String strs = this.sceneMgrDao.getToplinkRateByCode(toplinkid);
		if(strs!=null&&strs.indexOf(";")!=-1&&strs.split(";").length==4){
			rate = strs.split(";")[2];
		}
		if("155M".equals(rate)||"622M".equals(rate)||"2.5G".equals(rate)||"10G".equals(rate)){
			result="SUCCESS";
		}
		return result;
	}

	/**
	 * 导出全部操作步骤
	 * 
	 * @author xgyin
	 */
	public String exportExcelOperate(String labels, String[] titles,
			String types, OperateList model){
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		String path = null;// 返回到前台的路径
		List content = null;
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
//		String filename = types + "-" + date + ".xls";
		String filename = date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
		List<OperateList> operList = this.sceneMgrDao.getAllOperateListByUserList(model);
		int count = operList.size();
		content = new ArrayList();
		for (int i = 0; i < count; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i + 1);// 序号
			newcolmn.add(operList.get(i).getOperatetype() == null ? ""
					: operList.get(i).getOperatetype());
			newcolmn.add(operList.get(i).getOperateresult() == null ? ""
					: operList.get(i).getOperateresult());
			newcolmn.add(operList.get(i).getProjectname() == null ? ""
					: operList.get(i).getProjectname());
			newcolmn.add(operList.get(i).getA_equiptype() == null ? ""
					: operList.get(i).getA_equiptype());
			
			newcolmn.add(operList.get(i).getA_equipname() == null ? ""
					: operList.get(i).getA_equipname());
			newcolmn.add(operList.get(i).getZ_equiptype() == null ? ""
					: operList.get(i).getZ_equiptype());
			
			newcolmn.add(operList.get(i).getZ_equipname() == null ? ""
					: operList.get(i).getZ_equipname());
			newcolmn.add(operList.get(i).getUpdateperson() == null ? ""
					: operList.get(i).getUpdateperson());
			newcolmn.add(operList.get(i).getUpdatetime() == null ? ""
					: operList.get(i).getUpdatetime());
			newcolmn.add(operList.get(i).getRemark() == null ? "" : operList
					.get(i).getRemark());
			content.add(newcolmn);
		}
//		if (count > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[count % 20000 == 0 ? count / 20000 + 1
//						: count / 20000 + 2];
//				for (int i = 0; i < list.length - 1; i++) {
//					CustomizedExcel ce = new CustomizedExcel(servletConfig);
//					list[i] = content.subList(i * 20000 + 1,
//							(i + 1) * 20000 > content.size() ? content.size()
//									: (i + 1) * 20000);
//					ce.WriteExcel(RealPath + date + "-part" + i + ".xls",
//							labels, titles, list[i]);
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			ZipExcel zip = new ZipExcel();
//			try {
//				zip.zip(zipfilePath, zipfilePath + ".zip", "");
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			path = "exportExcel/"+ date + ".zip";
//		} else {
			CustomizedExcel ce = new CustomizedExcel(servletConfig);
			RealPath = this.getRealPath();
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
//		}

		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "故障仿真模块", "用户维护操作", "", request);
		return path;
	}

	/**
	 * 导出全部科目
	 * 
	 * @author xgyin
	 */
	public String exportExcelInterpose(String labels, String[] titles,
			String types, InterposeModel model) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		String path = null;// 返回到前台的路径
		List content = null;
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
		String filename = date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
		List<InterposeModel> operList = this.sceneMgrDao
				.getAllInterposeList1(model);
		
		int count = operList.size();
		content = new ArrayList();
		for (int i = 0; i < count; i++) {
			List newcolmn = new ArrayList();
			InterposeModel key = operList.get(i);
			newcolmn.add(i + 1);// 序号
			newcolmn.add(key.getInterposename() == null ? "" : key
					.getInterposename());
			newcolmn.add(key.getUser_name() == null ? "" : key.getUser_name().replace(",", ";"));
			
			newcolmn.add(key.getInterposetype() == null ? "" : key
					.getInterposetype());
			newcolmn.add(key.getFaulttype() == null ? "" : key.getFaulttype());
			newcolmn.add(key.getIsactive() == null ? "" : key.getIsactive());
			newcolmn.add(key.getEquiptype() == null ? "" : key.getEquiptype());
			
			newcolmn.add(key.getEquipname() == null ? "" : key.getEquipname());
			newcolmn.add(key.getResourcename() == null ? "" : key
					.getResourcename());
			newcolmn.add(key.getUpdateperson() == null ? "" : key
					.getUpdateperson());
			newcolmn
					.add(key.getUpdatetime() == null ? "" : key.getUpdatetime());
			newcolmn.add(key.getRemark() == null ? "" : key.getRemark());
			content.add(newcolmn);
		}
//		if (count > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[count % 20000 == 0 ? count / 20000 + 1
//						: count / 20000 + 2];
//				for (int i = 0; i < list.length - 1; i++) {
//					CustomizedExcel ce = new CustomizedExcel(servletConfig);
//					list[i] = content.subList(i * 20000 + 1,
//							(i + 1) * 20000 > content.size() ? content.size()
//									: (i + 1) * 20000);
//					ce.WriteExcel(RealPath + date + "-part" + i + ".xls",
//							labels, titles, list[i]);
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			ZipExcel zip = new ZipExcel();
//			try {
//				zip.zip(zipfilePath, zipfilePath + ".zip", "");
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			path = "exportExcel/"+ date + ".zip";
//		} else {
			CustomizedExcel ce = new CustomizedExcel(servletConfig);
			RealPath = this.getRealPath();
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
//		}

		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "故障仿真模块", "科目管理", "", request);
		return path;
	}

	/**
	 * 导出仿真日志
	 * exportInterposeLogExcel
	 */
	public String exportInterposeLogExcel(String labels, String[] titles,
			String types, InterposeLogModel model) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		String path = null;// 返回到前台的路径
		List content = null;
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
		String filename = date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
		List<InterposeLogModel> operList = this.sceneMgrDao
				.getAllInterposeLogListExcel(model);
		int count = operList.size();
		content = new ArrayList();
		for (int i = 0; i < count; i++) {
			List newcolmn = new ArrayList();
			InterposeLogModel key = operList.get(i);
			newcolmn.add(i + 1);// 序号
			newcolmn.add(key.getLogid() == null ? "" : key
					.getLogid());
			newcolmn
					.add(key.getEventname() == null ? "" : key.getEventname());
			newcolmn.add(key.getLogtype() == null ? "" : key
					.getLogtype());
			newcolmn
					.add(key.getLogtime() == null ? "" : key.getLogtime());
			newcolmn.add(key.getSourceobj() == null ? "" : key
					.getSourceobj());
			newcolmn.add(key.getAccessobj() == null ? "" : key
					.getAccessobj());
			newcolmn
					.add(key.getEventtype() == null ? "" : key.getEventtype());
			content.add(newcolmn);
		}
//		if (count > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[count % 20000 == 0 ? count / 20000 + 1
//						: count / 20000 + 2];
//				for (int i = 0; i < list.length - 1; i++) {
//					CustomizedExcel ce = new CustomizedExcel(servletConfig);
//					list[i] = content.subList(i * 20000 + 1,
//							(i + 1) * 20000 > content.size() ? content.size()
//									: (i + 1) * 20000);
//					ce.WriteExcel(RealPath + date + "-part" + i + ".xls",
//							labels, titles, list[i]);
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			ZipExcel zip = new ZipExcel();
//			try {
//				zip.zip(zipfilePath, zipfilePath + ".zip", "");
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			path = "exportExcel/"+ date + ".zip";
//		} else {
			CustomizedExcel ce = new CustomizedExcel(servletConfig);
			RealPath = this.getRealPath();
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
//		}

		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "故障仿真模块", "仿真日志管理", "", request);
		return path;
	}
	
	/**
	 * 导出全部操作方法
	 * 
	 * @author xgyin
	 */
	public String exportExcelMantain(String labels, String[] titles,
			String types, StdMaintainProModel model) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		String path = null;// 返回到前台的路径
		List content = null;
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
		String filename = date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
		List<StdMaintainProModel> operList = this.sceneMgrDao
				.getAllMantainListExcel();
		int count = operList.size();
		content = new ArrayList();
		for (int i = 0; i < count; i++) {
			List newcolmn = new ArrayList();
			StdMaintainProModel key = operList.get(i);
			newcolmn.add(i + 1);// 序号
			newcolmn.add(key.getOperatetype() == null ? "" : key
					.getOperatetype());
			newcolmn
					.add(key.getHasA_equip() == null ? "" : key.getHasA_equip());
			newcolmn.add(key.getA_equiptype() == null ? "" : key
					.getA_equiptype());
			newcolmn
					.add(key.getHasZ_equip() == null ? "" : key.getHasZ_equip());
			newcolmn.add(key.getZ_equiptype() == null ? "" : key
					.getZ_equiptype());
//			newcolmn.add(key.getIsinterposeoperate() == null ? "" : key
//					.getIsinterposeoperate());
			newcolmn
					.add(key.getOperatedes() == null ? "" : key.getOperatedes());
			newcolmn.add(key.getExpectedresult() == null ? "" : key
					.getExpectedresult());
			newcolmn.add(key.getUpdateperson() == null ? "" : key
					.getUpdateperson());
			newcolmn
					.add(key.getUpdatetime() == null ? "" : key.getUpdatetime());
			newcolmn.add(key.getRemark() == null ? "" : key.getRemark());
			content.add(newcolmn);
		}
//		if (count > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[count % 20000 == 0 ? count / 20000 + 1
//						: count / 20000 + 2];
//				for (int i = 0; i < list.length - 1; i++) {
//					CustomizedExcel ce = new CustomizedExcel(servletConfig);
//					list[i] = content.subList(i * 20000 + 1,
//							(i + 1) * 20000 > content.size() ? content.size()
//									: (i + 1) * 20000);
//					ce.WriteExcel(RealPath + date + "-part" + i + ".xls",
//							labels, titles, list[i]);
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			ZipExcel zip = new ZipExcel();
//			try {
//				zip.zip(zipfilePath, zipfilePath + ".zip", "");
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			path = "exportExcel/"+ date + ".zip";
//		} else {
			CustomizedExcel ce = new CustomizedExcel(servletConfig);
			RealPath = this.getRealPath();
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
//		}

		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "故障仿真模块", "操作方法管理", "", request);
		return path;
	}

	/**
	 * 获取时间的函数
	 * */
	public static String getName() {
		SimpleDateFormat sDateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH.mm.ss");
		return sDateFormat.format(new java.util.Date().getTime());
	}

	/**
	 * 获取文件路径
	 * */
	public String getRealPath() {
		String RealPath = null;// 绝对路径
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
		fullPath= fullPath .replaceAll("%20", " "); 
		RealPath = fullPath.substring(0, fullPath.indexOf("WEB-INF"));// linux下的情况
		RealPath += "exportExcel/";
		return RealPath;
	}

	public void insertAlarmOper(OperateList oform) {
		sceneMgrDao.insertAlarmOper(oform);
	}

	public String isCruFaluter(String userid) {
		Map map = new HashMap();
		map.put("user_id", userid);
		List list = sceneMgrDao.getCruFaulterFlag(map);
		if (list == null || list.size() == 0) {
			return "0";
		} else {
			return "1";
		}
	}

	/**
	 * 故障类型管理
	 * 
	 * @return
	 */
	public String getAllFaultFunctions() {
		List<OperateList> opers = null;
		opers = (ArrayList) sceneMgrDao.getAllFaultFunctions("0");
		StringBuffer sb = new StringBuffer("<node id='0' name='故障类型' icon=''>");
		forEachFaultOper(sb, opers);
		sb.append("</node>");
		return sb.toString();
	}

	private void forEachFaultOper(StringBuffer str, List<OperateList> opers) {
		for (OperateList oper : opers) {
			str
					.append("<node id='"
							+ oper.getProjectid()
							+ "' name='"
							+ oper.getProjectname()
							+ "' operatetypeid='"
							+ oper.getOperatetypeid()
							+ "' operatetype='"
							+ oper.getOperatetype()
							+ "' parentid='"
							+ oper.getParent_id()
							+ "' checked='0' icon='assets/images/sysManager/plugin.gif'>");
			List<OperateList> childOpers = (ArrayList) sceneMgrDao
					.getAllFaultFunctions(oper.getProjectid());
			if (childOpers.size() > 0) {
				forEachFaultOper(str, childOpers);
			}
			str.append("</node>");
		}
	}

	public void delFaultType(String oper_id) {
		sceneMgrDao.delFaultType(oper_id);
		List<OperateList> opers = (ArrayList) sceneMgrDao
				.getAllFaultFunctions(oper_id);
		for (OperateList operModel : opers) {
			sceneMgrDao.delFaultType(operModel.getProjectid());
			List<OperateList> subOpers = (ArrayList) sceneMgrDao
					.getAllFaultFunctions(operModel.getProjectid());
			for (OperateList subOperModel : subOpers) {
				sceneMgrDao.delFaultType(subOperModel.getProjectid());
			}
		}
	}

	public void updateFaultTypeByOperId(OperateList oform) {
		sceneMgrDao.updateFaultTypeByOperId(oform);
	}

	public void insertFaultType(OperateList oform) {
		sceneMgrDao.insertFaultType(oform);
	}
	
	public String checkToplinkrateDiff(String equipcode){
		String result="suc";
		List<InterposeModel> list = this.sceneMgrDao.getToplinkLstByEquipcode(equipcode);
		if(list.size()==2){
			if(list.get(0).getToplinkrate().equals(list.get(1).getToplinkrate())){
				result="fail";
			}
		}
		return result;
	}
	
	public InterposeLogResult getInterposeLogInfos(InterposeLogModel model){
		InterposeLogResult result = new InterposeLogResult();
		result.setTotalCount(sceneMgrDao.getInterposeLogCount(model));
		result.setLogList((ArrayList)sceneMgrDao.getInterposeLogList(model));
		return result;
	}
	
	public String callScreanVideo(){
		String result="success";
		EventQueue.invokeLater(new Runnable() {
		   public void run() {
		        new ScreenVideo().setVisible(true);
		      }
		     });
		return result;
	}
	//
	public String modifyCircuitInfo(){
		String result="suc";
//		List<String> codelst = this.sceneMgrDao.getAllCircuitCode();
//		for(int m=0;m<codelst.size();m++){
//			String circuitcode = codelst.get(m);
//			List<CircuitroutModel> routlst = this.sceneMgrDao.selectCircuitroutLstByCircuitcode(circuitcode );
//			List<Integer> lst = new ArrayList<Integer>();//发散端点
//			List<Integer> lst1 = new ArrayList<Integer>();//收端点
//			for(int i=0;i<routlst.size();i++){
//				for(int j=i+1;j<routlst.size();j++){
//					if(routlst.get(i).getA_portcode().equals(routlst.get(j).getA_portcode())&&routlst.get(i).getA_slot().equals(routlst.get(j).getA_slot())){
//						//说明有2条或以上路由
//						lst.add(i);
//						lst.add(j);
//					}
//					if(routlst.get(i).getZ_portcode().equals(routlst.get(i).getZ_portcode())&&routlst.get(i).getZ_slot().equals(routlst.get(j).getZ_slot())){
//						lst1.add(i);
//						lst1.add(j);
//					}
//				}
//			}
//			String path = ""; //主用路由
//			String remark = "";//备用路由
//			if(lst.size()==0){
//				//只有一条路径的情况
//				for(int i=0;i<routlst.size();i++){
//					path += routlst.get(i).getEquipname()+"->";
//				}
//			}
//			else if(lst.size()>0&&lst.size()<3){
//				//目前只对2个路由的做处理
//				if(lst.get(0)>0){
//					//前面有尾巴
//					for(int k=0;k<lst.get(0);k++){
//						path+=routlst.get(k).getEquipname()+"->";
//						remark+=routlst.get(k).getEquipname()+"->";
//					}
//					for(int t=lst.get(0);t<lst.get(1);t++){
//						path+=routlst.get(t).getEquipname()+"->";
//					}
//					for(int p=lst.get(1);p<routlst.size();p++){
//						remark+=routlst.get(p).getEquipname()+"->";
//					}
//					if(!routlst.get(lst.get(1)-1).equals(routlst.get(lst1.get(1)))){
//						//后面有尾巴
//						for(int s=lst1.get(0)+1;s<lst.get(1);s++){
//							remark += routlst.get(s).getEquipname()+"->";
//						}
//					}
//				}else{
//					for(int k=0;k<lst.get(1);k++){
//						path+=routlst.get(k).getEquipname()+"->";
//					}
//					for(int t=lst.get(1);t<routlst.size();t++){
//						remark+=routlst.get(t).getEquipname()+"->";
//					}
//					if(!routlst.get(lst.get(1)-1).equals(routlst.get(lst1.get(1)))){
//						//后面有尾巴
//						for(int s=lst1.get(0)+1;s<lst.get(1);s++){
//							remark += routlst.get(s).getEquipname()+"->";
//						}
//					}
//				}
//				if(path.split("->").length>remark.split("->").length){
//					String temp = path;
//					path = remark;
//					remark = temp;
//				}
//			}else{
//				//
//				
//			}
//			if(path.length()>0){
//				path = path.substring(0, path.length()-2);
//			}
//			if(remark.length()>0){
//				remark = remark.substring(0, remark.length()-2);
//			}
//			//修改电路表中，主备字段
//			Map map = new HashMap();
//			map.put("path", path);
//			map.put("remark", remark);
//			map.put("circuitcode", circuitcode);
//			this.sceneMgrDao.updateCircuitRouteByMap(map);
//		}
	return result;
	}
	
	/**
	 * 修改当前科目为已处理
	 * modifyInterposeInfo
	 * @param interposeid
	 * @author 尹显贵
	 **/
	public String modifyInterposeInfo(String interposeid){
		String result = "fail";
		try {
			this.sceneMgrDao.modifyInterposeInfo(interposeid);
			result = "SUCCESS";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * @author 尹显贵
	 * @param string
	 * @return string
	 **/
	public String checkPackPort(String codevalue){
		String result="";
		
		if(codevalue!=null&&codevalue.indexOf(",")!=-1){
			if(codevalue.split(",").length==4){
				Map map = new HashMap();
				map.put("equipcode",codevalue.split(",")[0] );
				map.put("frameserial", codevalue.split(",")[1]);
				map.put("slotserial", codevalue.split(",")[2]);
				map.put("packserial",codevalue.split(",")[3] );
				List<String> portlst = this.sceneMgrDao.getUsePortcodesByMap(map);
				if(portlst.size()==0){
					result="fail";
				}else{
					result=this.sceneMgrDao.getPackcodeByMap(map);
				}
			}
		}
		//
		return result;
	}
	
	/**
	 * @author 尹显贵
	 * @param codes
	 * @return  string
	 * selectPortCutLst
	 **/
	public String selectPortCutLst(String cond,String paramvalue){
		String result="";
		if(paramvalue!=null&&!"".equals(paramvalue)){
			if(paramvalue.indexOf("=")!=-1&&paramvalue.split("=").length==5){
				Map map = new HashMap();
				map.put("equipcode", paramvalue.split("=")[0]);
				map.put("frameserial", paramvalue.split("=")[1]);
				map.put("slotserial", paramvalue.split("=")[2]);
				map.put("packserial", paramvalue.split("=")[3]);
				map.put("cond", cond);
				List<ComboxDataModel> list = sceneMgrDao.selectPortCutLst(map);
				for (ComboxDataModel data : list) {
					result += "<port id=\""
							+ data.getId()
							+ "\"label=\""
							+ data.getLabel()
							+ "\" name=\"port\" isBranch=\"false\"></port>";
				}
			}else{
				Map map = new HashMap();
				map.put("equipcode", paramvalue);
				map.put("cond", cond);
				List<HashMap> list = sceneMgrDao.selectEquipPortCutLst(map);
				for (HashMap data : list) {
					result += "<port id=\""
							+ (String)data.get("ID")
							+ "\"label=\""
							+ (String)data.get("LABEL")
							+ "\" name=\"port\" isBranch=\"false\"></port>";
				}
			}
			
		}
		
		return result;
	}
	
	/**
	 * @author 尹显贵
	 * @param string
	 * @return string
	 * --获取割接用的机盘列表或端口列表
	 **/
	public String getEquippackBysearch(String equipcode,String rescode,String portrate,String porttype,String type,String cond){
		String result="";
		if("pack".equals(type)){
			//RESCODE为空
			//根据设备编号和端口速率、类型查找机盘列表
			Map map=new HashMap();
			map.put("equipcode", equipcode);
			map.put("x_capability", portrate);
			map.put("y_porttype", porttype);
			map.put("cond", cond);
			map.put("labelname", "e.s_packname||'-'||e.frameserial||'框'||e.slotserial||'槽'||e.packserial||'盘'");
			List<ComboxDataModel> list = sceneMgrDao.getEquippackBysearch(map);
			for (ComboxDataModel data : list) {
				result += "<pack id=\""
						+ data.getId()
						+ "\"label=\""
						+ data.getLabel()
						+ "\" name=\"pack\" isBranch=\"false\"></pack>";
			}
		}else{
			//rescode为机盘id
			//根据机盘id、端口速率和类型查找端口列表
			Map map = new HashMap();
			map.put("equipcode", equipcode);
			map.put("id", rescode);//机盘id
			map.put("x_capability", portrate);
			map.put("y_porttype", porttype);
			map.put("cond", cond);
			List<HashMap> list = sceneMgrDao.getEquipportBysearch(map);
			for (HashMap data : list) {
				result += "<port id=\""
						+ (String)data.get("ID")
						+ "\"label=\""
						+ (String)data.get("LABEL")
						+ "\" name=\"port\" isBranch=\"false\"></port>";
			}
		}
		return result;
	}
	
	/**
	 *@author 尹显贵 
	 * @param 复用段id
	 * @return string
	 * --根据复用段查找两端端口类型和速率
	 **/
	public String getPortTypeAndRate(String toplinkid){
		String result="";
		result = this.sceneMgrDao.getPortTypeAndRate(toplinkid);
		return result;
	}
	
	/**
	 * 查询光缆名称
	 * @author 尹显贵
	 * @param string
	 * @return string
	 **/
	public String getOcableNameById(String ocablecode,String type){
		String result="";
		result = this.sceneMgrDao.getOcableNameById(ocablecode,type);
		return result;
	}
	
	/**
	 * @author 尹显贵
	 * @param interposemodel,string
	 * @return string
	 * ---光缆、光纤激活功能
	 **/
	public String setSimulateEventIsActive(InterposeModel model,String type){
		String result="";
		
		try{
			//1、查找光缆下的光纤关联的复用段的端口列表
			List<String> sdhPortlst = new ArrayList<String>();
			Map map = new HashMap();
			map.put("resourcecode", model.getResourcecode());
			if("ocable".equals(type)){
				map.put("fieldname", "ocablecode");
			}else{
				map.put("fieldname", "fibercode");
			}
			List<String> portlst = this.sceneMgrDao.getAllEquipportByOcablecode(map);
			for(int i=0;i<portlst.size();i++){
				if(portlst.get(i).indexOf("=")!=-1){
					String porta = portlst.get(i).split("=")[0];
					String portz = portlst.get(i).split("=")[1];
					if(!sdhPortlst.contains(porta)){
						sdhPortlst.add(porta);
					}
					if(!sdhPortlst.contains(portz)){
						sdhPortlst.add(portz);
					}
				}
			}
			//2、根据端口查找：系统名称、站点名称、设备编码、机框、机槽、机盘序号
			for(int j=0;j<sdhPortlst.size();j++){
				this.insertAlarmInfosByPortcode(model,sdhPortlst.get(j));
			}
			
			this.sceneMgrDao.setEventIsActive(model);
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("设置激活", "故障仿真模块", "事件干预激活", "", request);
			result = "success";
		} catch (Exception e) {
			e.printStackTrace();
			log.error("setSimulateEventIsActive", e);
		}
		return result;
	}
	//2、根据端口查找：系统名称、站点名称、设备编码、机框、机槽、机盘序号,插入告警
	private void insertAlarmInfosByPortcode(InterposeModel model, String portcode) {

		// 用户id数组
		String[] arr;
		if (model.getUser_id().indexOf(",") != -1) {
			arr = model.getUser_id().split(",");
		} else {
			arr = new String[] { model.getUser_id() };
		}
		//查找信息
		LogicPort port = this.sceneMgrDao.getLogicPortInfos(portcode);
		
		Map map = new HashMap();
		map.put("interposetypeid", model.getInterposetypeid());
		map.put("faulttypeid", model.getFaulttypeid());
		map.put("equiptype", model.getEquiptype());
		map.put("x_vendor", this.sceneMgrDao.getX_vendorByEquipcode(port
				.getEquipcode()));
		List<InterposeModel> alarmLst = this.sceneMgrDao
				.getInterposeAlarmList(map);
		Set<String> carryList = new HashSet<String>();// 伴随告警ID列表
		for (int i = 0; i < alarmLst.size(); i++) {
			InterposeModel key = alarmLst.get(i);
			String alarmIds = key.getAlarmid();
			String alarmId[];
			if (alarmIds.indexOf(";") != -1) {
				alarmId = alarmIds.split(";");
			} else {
				alarmId = new String[] { alarmIds };
			}
			// 根据position的位置确定是本端还是对端
			if ("本端".equals(key.getPosition())) {
				for (int k = 0; k < alarmId.length; k++) {
					Set<String> set = this.ForEachAlarm(
							new HashSet<String>(), alarmId[k]);
					carryList.addAll(set);
					AlarmInfos alarmModel = new AlarmInfos();
					alarmModel.setInterposeid(model.getInterposeid());//科目ID
					//根据科目ID查询告警来源
					String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
					alarmModel.setAlarmlevel(this.sceneMgrDao
							.getAlarmLevelById(alarmId[k]));
					alarmModel.setBeginTime(this
							.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
					ComboxDataModel cm = this.sceneMgrDao
					.getStationByEquipCode(port.getEquipcode());
					String stationname="";
					if(cm!=null){
						alarmModel.setBelongstation(cm.getId());
						stationname=cm.getLabel();
					}else{
						alarmModel.setBelongstation("");
						stationname=this.sceneMgrDao
						.getEquipNameByEquipcode(port.getEquipcode());
					}
					
					
					
					alarmModel.setProbablecause(alarmId[k]);
					// 查询告警名称
					alarmModel.setAlarmdesc(this.sceneMgrDao
							.getAlarmNameByAlarmId(alarmId[k]));
					ComboxDataModel cm2 = this.sceneMgrDao
					.getTransystemByEquipCode(port.getEquipcode());
					String objAlarmDes = cm2.getLabel() + "/" + stationname + "."
					+ port.getFrameserial() + "框." + port.getPackserial()
					+ "盘" +port.getSlotserial()+"槽"+ port.getPortserial() + "端口";
					alarmModel.setAlarmobjdesc(objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙

					alarmModel.setBelongequip(port.getEquipcode());
					alarmModel.setBelongframe(port.getFrameserial());
					
					alarmModel.setBelongpack(port.getPackserial());
					alarmModel.setBelongport(port.getPortserial());
					// 根据端口查询承载业务
					alarmModel.setCarrycircuit(""
							+ this.carryOperaDao
									.getCarryOperaCountByLogicPort(
											portcode, 0));
					alarmModel.setBelongslot(port.getSlotserial());//槽位
					alarmModel.setBelongportcode(portcode);
					alarmModel.setVendor(key.getX_vendor());
					alarmModel.setBelongtransys(cm2.getId());
					alarmModel.setIscleared("0");
					alarmModel.setObjClass("port");
					alarmModel.setIsAck("0");
					alarmModel.setIsfilter("0");
					alarmModel.setTriggeredhour("12");
					alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
					
					DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					long now = System.currentTimeMillis();
					long newnow = now-10*60*1000;
					Calendar calendar = Calendar.getInstance();
					calendar.setTimeInMillis(newnow);
					// 设置一个告警标识，区分跟告警和伴随告警
					alarmModel.setIsRootAlarm("1");
					//添加字段 告警来源
					alarmModel.setAlarmType(alarmtype);
					// 按用户插入
					int p=0;
					for (int j = 0; j < arr.length; j++) {
						alarmModel.setAlarmman(arr[j]);
						//插入前判断该告警是否存在
						alarmModel.setEndTime(formatter.format(calendar.getTime()));
						List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
						if(info.size()==0){
							this.sceneMgrDao.insertAlarmInfo(alarmModel);
							p++;
						}
						
					}
					if(p>0){
						//插入仿真日志
						this.insertInterposeLog(alarmModel,model);
					}
				}
					
			}else{
				List<String> idLst = new ArrayList<String>();
				Map mp = new HashMap();
				mp.put("equipA", port.getEquipcode());
				mp.put("code", portcode);
				String ratecode = this.sceneMgrDao.getPortrateByPortcode(mp); 
				if("ZY070101".equals(ratecode)){//根据速率判断
					//电口通过复用段查找对端
					idLst = this.sceneMgrDao.getZportCodeListByToplink(mp);
				}else{
					//光口通过交叉
					idLst = this.sceneMgrDao
					.getZportCodeListByAportcode(mp);
				}
				for (int j = 0; j < idLst.size(); j++) {
					String Z_equipcode = this.sceneMgrDao
							.getZ_EquipcodeByPortCode(idLst.get(j));
					if (Z_equipcode != null) {
						ComboxDataModel zcm0 = this.sceneMgrDao
								.getTransystemByEquipCode(Z_equipcode);
						if (zcm0 == null) {
							zcm0 = new ComboxDataModel();
						}
						ComboxDataModel zcm1 = this.sceneMgrDao
								.getStationByEquipCode(Z_equipcode);
						String z_stationName;
						if (zcm1 != null) {
							z_stationName = zcm1.getLabel();
						} else {
							z_stationName = this.sceneMgrDao
									.getEquipNameByEquipcode(Z_equipcode);
						}
						String z_objAlarmDes = "";
						ComboxDataModel z_serial = new ComboxDataModel();

						String objClass = "port";
						z_serial = this.sceneMgrDao.getSerialsByCodes(idLst
								.get(j), "logicport", "equiplogicport");
						// 根据端口查盘名称
						// 获取端口序号
						String portSerial = this.sceneMgrDao
								.getPortSerialById(idLst.get(j));
						z_objAlarmDes = zcm0.getLabel() + "/"
								+ z_stationName + "." + z_serial.getId()
								+ "框." + z_serial.getLabel() + "盘"
								+this.sceneMgrDao
								.getPortSerialById(idLst.get(j))+"槽"+ portSerial + "端口";
						for (int k = 0; k < alarmId.length; k++) {
							Set<String> set = this.ForEachAlarm(
									new HashSet<String>(), alarmId[k]);
							carryList.addAll(set);

							AlarmInfos alarmModel = new AlarmInfos();
							alarmModel.setInterposeid(model
									.getInterposeid());
							alarmModel.setAlarmlevel(this.sceneMgrDao
									.getAlarmLevelById(alarmId[k]));
							alarmModel
									.setBeginTime(this
											.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
							if (zcm1 != null) {
								alarmModel.setBelongstation(zcm1.getId());
							} else {
								alarmModel.setBelongstation("");
							}

							alarmModel.setProbablecause(alarmId[k]);
							alarmModel.setAlarmdesc(this.sceneMgrDao
									.getAlarmNameByAlarmId(alarmId[k]));
							alarmModel.setAlarmobjdesc(z_objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙

							alarmModel.setBelongequip(Z_equipcode);
							alarmModel.setBelongframe(z_serial.getId());

							// 获取端口序号
							alarmModel.setBelongpack(z_serial.getLabel());
							alarmModel.setBelongport(this.sceneMgrDao
									.getPortSerialById(idLst.get(j)));
							// 根据端口查询承载业务
							alarmModel.setCarrycircuit(""
									+ this.carryOperaDao
											.getCarryOperaCountByLogicPort(
													idLst.get(j), 0));
							alarmModel.setBelongslot(this.sceneMgrDao
									.getEquipSlotSerialById(idLst.get(j)));
							alarmModel.setBelongportcode(idLst.get(j));

							alarmModel.setVendor(key.getX_vendor());
							alarmModel.setBelongtransys(zcm0.getId());
							alarmModel.setIscleared("0");
							alarmModel.setObjClass(objClass);
							alarmModel.setIsAck("0");
							alarmModel.setIsfilter("0");
							alarmModel.setTriggeredhour("12");
							alarmModel.setIsRootAlarm("1");
							String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
							alarmModel.setAlarmType(alarmtype);
							alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
							
							DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							long now = System.currentTimeMillis();
							long newnow = now-10*60*1000;
							Calendar calendar = Calendar.getInstance();
							calendar.setTimeInMillis(newnow);
							
							// 按用户插入
							int p=0;
							for (int t = 0; t < arr.length; t++) {
								alarmModel.setAlarmman(arr[t]);
								alarmModel.setEndTime(formatter.format(calendar.getTime()));
								List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
								if(info.size()==0){
									this.sceneMgrDao.insertAlarmInfo(alarmModel);
									p++;
								}
							}
							if(p>0){
								//插入仿真日志
								this.insertInterposeLog(alarmModel,model);
							}
						}
					}
				}
			}
		}
		// 插入伴随告警
		if (carryList.size() > 0) {
			this.insertAlarmTransmitFiber(carryList, model,portcode);
		}
	}
	public void insertAlarmTransmitFiber(Set<String> carryList, InterposeModel model,String portcode) {
		try {
			Iterator<String> iterator = carryList.iterator();
			String[] arr;
			if (model.getUser_id().indexOf(",") != -1) {
				arr = model.getUser_id().split(",");
			} else {
				arr = new String[] { model.getUser_id() };
			}
			//查找信息
			LogicPort port = this.sceneMgrDao.getLogicPortInfos(portcode);
			
			ComboxDataModel cm0 = this.sceneMgrDao
					.getTransystemByEquipCode(port.getEquipcode());
			if (cm0 == null) {
				cm0 = new ComboxDataModel();
			}
			ComboxDataModel cm1 = this.sceneMgrDao.getStationByEquipCode(port
					.getEquipcode());
			String stationName;
			if (cm1 != null) {
				stationName = cm1.getLabel();
			} else {
				stationName = this.sceneMgrDao.getEquipNameByEquipcode(port
						.getEquipcode());
			}
			String objClass = "";
			String objAlarmDes = "";
//			ComboxDataModel serial = new ComboxDataModel();
			
			Set<String> set = new HashSet<String>();// 避免重复
			while (iterator.hasNext()) {
				List<OperateList> operList = this.sceneMgrDao
						.getAlarmTransmitByAlarmId(iterator.next());
				// 插入伴随告警
				for (int t = 0; t < operList.size(); t++) {
					OperateList oper = operList.get(t);
					if ("本端".equals(oper.getOper_desc())) {
						AlarmInfos alarmModel = new AlarmInfos();
						alarmModel.setInterposeid(model.getInterposeid());
						alarmModel.setAlarmlevel(this.sceneMgrDao
								.getAlarmLevelById(oper.getAlarm_id()));
						alarmModel.setBeginTime(this
								.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
						if (cm1 != null) {
							alarmModel.setBelongstation(cm1.getId());
						} else {
							alarmModel.setBelongstation("");
						}

						alarmModel.setProbablecause(oper.getAlarm_id());
						alarmModel.setAlarmdesc(oper.getAlarm_name());

						alarmModel.setBelongequip(port.getEquipcode());

						objAlarmDes = cm0.getLabel() + "/" + stationName
								+ "." + port.getFrameserial() + "框."
								+ port.getPackserial() + "盘" +port.getSlotserial()+"槽"+ port.getPortserial()
								+ "端口";
						alarmModel.setAlarmobjdesc(objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙
						// 获取端口序号
						alarmModel.setBelongpack(port.getPackserial());
						alarmModel.setBelongport(port.getPortserial());
						// 根据端口查询承载业务
						alarmModel.setCarrycircuit(""
								+ this.carryOperaDao
										.getCarryOperaCountByLogicPort(
												portcode, 0));
						alarmModel.setBelongslot(port.getSlotserial());
						alarmModel.setBelongportcode(portcode);
						alarmModel.setObjClass("port");

						alarmModel.setVendor(oper.getVendercode());
						alarmModel.setBelongtransys(cm0.getId());
						alarmModel.setIscleared("0");
						alarmModel.setBelongframe(port.getFrameserial());
						alarmModel.setIsAck("0");
						alarmModel.setIsfilter("0");
						alarmModel.setTriggeredhour("12");
						String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
						alarmModel.setAlarmType(alarmtype);
						alarmModel.setIsRootAlarm("0");
						alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
						// 按用户插入
						DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						long now = System.currentTimeMillis();
						long newnow = now-10*60*1000;
						Calendar calendar = Calendar.getInstance();
						calendar.setTimeInMillis(newnow);
						
						// 按用户插入
						int p=0;
						for (int j = 0; j < arr.length; j++) {
							alarmModel.setAlarmman(arr[j]);
							alarmModel.setEndTime(formatter.format(calendar.getTime()));
							List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
							if(info.size()==0){
								this.sceneMgrDao.insertAlarmInfo(alarmModel);
								p++;
							}
						}
						if(p>0){
							//插入仿真日志
							this.insertInterposeLog(alarmModel,model);
						}
						// 插入本端端口的伴随告警
						Set<String> set1 = this.ForEachAlarm(
								new HashSet<String>(), oper.getAlarm_id());
						set.addAll(set1);
					}
					if ("对端".equals(oper.getOper_desc())) {
						List<String> idLst = new ArrayList<String>();
						Map map = new HashMap();
						map.put("equipA", model.getEquipcode());
						// 端口对端伴随告警
						map.put("code", portcode);
						String ratecode = this.sceneMgrDao.getPortrateByPortcode(map); 
						if("ZY070101".equals(ratecode)){//根据速率判断
							//电口通过复用段查找对端
							idLst = this.sceneMgrDao.getZportCodeListByToplink(map);
						}else{
							//光口通过交叉
							idLst = this.sceneMgrDao
							.getZportCodeListByAportcode(map);
						}
						// 根据端口插入告警
						String alarmId = oper.getAlarm_id();

						for (int i = 0; i < idLst.size(); i++) {
							String Z_equipcode = this.sceneMgrDao
									.getZ_EquipcodeByPortCode(idLst.get(i));
							if (Z_equipcode != null) {
								ComboxDataModel zcm0 = this.sceneMgrDao
										.getTransystemByEquipCode(Z_equipcode);
								if (zcm0 == null) {
									zcm0 = new ComboxDataModel();
								}
								ComboxDataModel zcm1 = this.sceneMgrDao
										.getStationByEquipCode(Z_equipcode);
								String z_stationName;
								if (zcm1 != null) {
									z_stationName = zcm1.getLabel();
								} else {
									z_stationName = this.sceneMgrDao
											.getEquipNameByEquipcode(Z_equipcode);
								}
								String z_objAlarmDes = "";
								ComboxDataModel z_serial = new ComboxDataModel();

								objClass = "port";
								z_serial = this.sceneMgrDao.getSerialsByCodes(
										idLst.get(i), "logicport",
										"equiplogicport");
								// 根据端口查盘名称
								// 获取端口序号
								String portSerial = this.sceneMgrDao
										.getPortSerialById(idLst.get(i));
								z_objAlarmDes = zcm0.getLabel() + "/"
										+ z_stationName + "."
										+ z_serial.getId() + "框."
										+ z_serial.getLabel() + "盘"
										+this.sceneMgrDao
										.getEquipSlotSerialById(idLst.get(i))+"槽"+ portSerial + "端口";

								AlarmInfos alarmModel = new AlarmInfos();
								alarmModel.setInterposeid(model
										.getInterposeid());
								alarmModel.setAlarmlevel(this.sceneMgrDao
										.getAlarmLevelById(alarmId));
								alarmModel
										.setBeginTime(this
												.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
								if (zcm1 != null) {
									alarmModel.setBelongstation(zcm1.getId());
								} else {
									alarmModel.setBelongstation("");
								}

								alarmModel.setProbablecause(alarmId);
								alarmModel.setAlarmdesc(oper.getAlarm_name());
								alarmModel.setAlarmobjdesc(z_objAlarmDes);// 告警对象系统-设备-机盘-端口-时隙

								alarmModel.setBelongequip(Z_equipcode);
								alarmModel.setBelongframe(z_serial.getId());

								// 获取端口序号
								alarmModel.setBelongpack(z_serial.getLabel());
								alarmModel.setBelongport(this.sceneMgrDao
										.getPortSerialById(idLst.get(i)));
								// 根据端口查询承载业务
								alarmModel.setCarrycircuit(""
										+ this.carryOperaDao
												.getCarryOperaCountByLogicPort(
														idLst.get(i), 0));
								alarmModel.setBelongslot(this.sceneMgrDao
										.getEquipSlotSerialById(idLst.get(i)));
								alarmModel.setBelongportcode(idLst.get(i));

								alarmModel.setVendor(oper.getVendercode());
								alarmModel.setBelongtransys(zcm0.getId());
								alarmModel.setIscleared("0");
								alarmModel.setObjClass(objClass);
								alarmModel.setIsAck("0");
								alarmModel.setIsfilter("0");
								alarmModel.setTriggeredhour("12");
								String alarmtype = this.sceneMgrDao.getAlarmTypeByID(model.getInterposeid());
								alarmModel.setAlarmType(alarmtype);
								alarmModel.setIsRootAlarm("0");
								alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(alarmModel.getBelongequip()));
								// 按用户插入
								DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
								long now = System.currentTimeMillis();
								long newnow = now-10*60*1000;
								Calendar calendar = Calendar.getInstance();
								calendar.setTimeInMillis(newnow);
								
								// 按用户插入
								int p=0;
								for (int j = 0; j < arr.length; j++) {
									alarmModel.setAlarmman(arr[j]);
									alarmModel.setEndTime(formatter.format(calendar.getTime()));
									List<AlarmInfos> info = this.sceneMgrDao.getAlarmInfosByModel(alarmModel);
									if(info.size()==0){
										this.sceneMgrDao.insertAlarmInfo(alarmModel);
										p++;
									}
								}
								if(p>0){
									//插入仿真日志
									this.insertInterposeLog(alarmModel,model);
								}
							}
						}
						// 插入对端端口的伴随告警
						if (idLst.size() > 0) {
							Set<String> setZ1 = this.ForEachAlarm(
									new HashSet<String>(), alarmId);
							if (setZ1.size() > 0) {
								for (int j = 0; j < idLst.size(); j++) {
									this.insertEachAlarmTransmit(setZ1, model,
											idLst.get(j));
								}
							}
						}
					}
				}

			}

			if (set.size() > 0) {// 本端伴随告警
				this.insertAlarmTransmitFiber(set, model,portcode);
			}
		} catch (Exception e) {
			log.error("insertAlarmTransmitFiber", e);
			e.printStackTrace();
		}
	}
	
	
	public String executeFault(String faultid,String userids){
		String result="fail";
		//如果faultid的父节点不为0，分类下发告警，发生告警的位置指定
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel) session.getAttribute((String) session
				.getAttribute("userid"));
		
		String[] userid;
		if(userids.indexOf(",")!=-1){
			userid = userids.split(",");
		}else{
			userid = new String[]{};
		}
		InterposeModel model = new InterposeModel();
		
		if("34962".equals(faultid)){//光缆中断
			model.setUser_id(userids);
			
			model.setInterposetype("IT0000002");
			model.setFaulttype("AT20000002");
			model.setS_event_title("故障");
			model.setUpdatetime(DateUtil.getCurrentDateString("yyyy-MM-dd HH:mm:ss"));
			model.setUpdateperson(user.getUser_id());
			model.setRemark(" ");
			model.setIsmaininterpose("");
			model.setEquiptype("光缆");
			model.setEquipcode("");
			model.setInterposename("典型故障---光缆中断"+DateUtil.getDateString(new Date(), "yyyy-MM-dd HH:mm:ss"));
			model.setResourcecode("00000000000000059380");
			model.setResourcename("北郊变电站地调通信机房机架25-茶山变电站通信机房机架05 ADSS光缆 24芯");
			
		}else if("4".equals(faultid)){
			//光纤劣化
			
			model.setUser_id(userids);
			model.setInterposetype("IT0000002");
			model.setFaulttype("AT20000012");
			model.setS_event_title("故障");
			model.setUpdatetime(DateUtil.getCurrentDateString("yyyy-MM-dd HH:mm:ss"));
			model.setUpdateperson(user.getUser_id());
			model.setRemark(" ");
			model.setIsmaininterpose("");
			model.setEquiptype("光纤");
			model.setEquipcode("");
			model.setInterposename("典型故障---光纤劣化"+DateUtil.getDateString(new Date(), "yyyy-MM-dd HH:mm:ss"));
			model.setResourcecode("00000000000500192767");
			model.setResourcename("旧局-新局 管道光缆 48芯/第31芯");
		}
		
		//1、插入故障
		String interpose_id = sceneMgrDao.addInterpose(model);
		//2、插入告警
		for(int i=0;i<userid.length;i++){
			this.insertClassicFaultAlarmInfo(interpose_id,faultid,userid[i]);
		}
		//3、激活
		model.setInterposeid(interpose_id);
		this.sceneMgrDao.setEventIsActive(model);
		result="success";
		
		return result;
	}
	
	private void insertClassicFaultAlarmInfo(String interposeid,String oper_id,
			String userid) {

		List<ClassicFaultAlarmModel> lst = new ArrayList<ClassicFaultAlarmModel>();
		lst = this.sceneMgrDao.getAllClassicFaultAlarmLst(oper_id);
		String objAlarmDes="";
		String carryCiruit="";
		for(int i=0;i<lst.size();i++){
			ClassicFaultAlarmModel key = lst.get(i);
			AlarmInfos alarmModel = new AlarmInfos();
			String alarmtype = this.sceneMgrDao.getAlarmTypeByID(interposeid);
			String stationcode = this.sceneMgrDao.getStationCodeByStation(key.getSTATION());
			alarmModel.setInterposeid(interposeid);
			alarmModel.setAlarmlevel(key.getALARMLEVEL());
			alarmModel.setBeginTime(this
					.getCurrentDateString("yyyy-MM-dd  HH:mm:ss"));
			alarmModel.setBelongstation(stationcode);//改为编码
			alarmModel.setProbablecause(key.getALARMID());
			alarmModel.setAlarmdesc(key.getALARMDESC());
			
			if("port".equals(key.getOBJCLASS())){
				objAlarmDes = key.getBELONGTRANSYS() + "/" + key.getSTATION() + "."
							+ key.getBELONGFRAME() + "框." + key.getBELONGPACK()
							+ "盘" +key.getBELONGSLOT()+"槽"+ key.getBELONGPORT() + "端口";
				
				carryCiruit = String.valueOf(this.carryOperaDao
				.getCarryOperaCountByLogicPort(
						key.getBELONGPORTCODE(), 0));
			}else if("circuitPack".equals(key.getOBJCLASS())){
				objAlarmDes = key.getBELONGTRANSYS() + "/" + key.getSTATION() + "."
							+ key.getBELONGFRAME() + "框." + key.getBELONGPACK()
							+ "盘" +key.getBELONGSLOT()+"槽";
				carryCiruit = String.valueOf(this.carryOperaDao
						.getCarryOperaCountByEquipPack(
								key.getBELONGEQUIP(),
								key.getBELONGFRAME(), key.getBELONGSLOT(),
								key.getBELONGPACK(), 0));
			}else{
				objAlarmDes = key.getBELONGTRANSYS() + "/" + key.getSTATION();
				carryCiruit = String.valueOf(this.carryOperaDao
				.getCarryOperaCountByEquipcode(
						key.getBELONGEQUIP(), 0));
			}
			
			
			alarmModel.setAlarmobjdesc(objAlarmDes);
			alarmModel.setBelongequip(key.getBELONGEQUIP());
			alarmModel.setBelongframe(key.getBELONGFRAME()==null?"":key.getBELONGFRAME());
			alarmModel.setBelongpack(key.getBELONGPACK()==null?"":key.getBELONGPACK());
			alarmModel.setBelongport(key.getBELONGPORT()==null?"":key.getBELONGPORT());
			// 根据端口查询承载业务
			
			alarmModel.setCarrycircuit(carryCiruit);
			
			alarmModel.setBelongslot(key.getBELONGSLOT()==null?"":key.getBELONGSLOT());//槽位
			alarmModel.setBelongportcode(key.getBELONGPORTCODE()==null?"":key.getBELONGPORTCODE());
			
			alarmModel.setVendor(key.getVENDOR());
			alarmModel.setBelongtransys(key.getBELONGTRANSYS());
			alarmModel.setIscleared("0");
			alarmModel.setObjClass(key.getOBJCLASS());
			alarmModel.setIsAck("0");
			alarmModel.setIsfilter("0");
			alarmModel.setTriggeredhour("12");
			
			alarmModel.setIsRootAlarm(key.getISROOTALARM());
			//添加字段 告警来源
			alarmModel.setAlarmType(alarmtype);
			//根据设备编码查找站点所属区域
			alarmModel.setBelonghouse(this.sceneMgrDao.getAreaNameByEquipcode(key.getBELONGEQUIP()));
			
			alarmModel.setAlarmman(userid);
			
			this.sceneMgrDao.insertAlarmInfo(alarmModel);
		}
	}

	public String getAllClassicFault(){
		List<OperationModel> opers = null;
		opers = (ArrayList)sceneMgrDao.getAllClassicFault("0");
		StringBuffer sb = new StringBuffer("<node id='0' name='典型故障' icon=''>");
		forEachFault(sb,opers);
		sb.append("</node>");
		return sb.toString();
	}
	
	private void forEachFault(StringBuffer str,List<OperationModel> opers){
		for(OperationModel oper:opers){
			str.append("<node id='"+oper.getOper_id()+"' name='"+oper.getOper_name()+"' parentid='"+oper.getParent_id()+"' checked='0' icon='assets/images/sysManager/plugin.gif'>");
			List<OperationModel> childOpers = (ArrayList)sceneMgrDao.getAllClassicFault(oper.getOper_id());
			if(childOpers.size() > 0){
				forEachFault(str,childOpers);
			}
			str.append("</node>");
		}
	}
	
	public void updateOperationByOperId(OperationModel oform){
		sceneMgrDao.updateOperationByOperId(oform);
	}
	
	public void insertOper(OperationModel oform){
		sceneMgrDao.insertOper(oform);
	}
	
	public String addClassicFaultAlarmConfig(ClassicFaultAlarmModel model){
		String result="fail";
		
		String alarmlevel = this.sceneMgrDao
		.getAlarmLevelById(model.getALARMID());
		String station = this.sceneMgrDao.getStationByEquipCode(model.getBELONGEQUIP()).getLabel();
		String logicport = "";
		if("port".equals(model.getOBJCLASS())){
			Map map = new HashMap();
			map.put("equipcode", model.getBELONGEQUIP());
			map.put("frameserial", model.getBELONGFRAME()==null?"":model.getBELONGFRAME());
			map.put("slotserial", model.getBELONGSLOT()==null?"":model.getBELONGSLOT());
			map.put("packserial", model.getBELONGPACK()==null?"":model.getBELONGPACK());
			map.put("portserial", model.getBELONGPORT()==null?"":model.getBELONGPORT());
			logicport = this.sceneMgrDao.getPortCodeByMap(map);
		}
		model.setALARMLEVEL(alarmlevel);
		model.setSTATION(station);
		model.setBELONGPORTCODE(logicport);
		this.sceneMgrDao.insertClassicFaultAlarmConf(model);
		result = "success";
		return result;
	}
	
	
}
