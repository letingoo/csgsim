package resManager.resNet.dwr;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;

import jxl.write.WriteException;

import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ExportExcel;
import netres.component.ExcelOperation.ZipExcel;
import netres.component.Validators.NetresdataValidator;
import netres.model.ComboxDataModel;
import netres.model.ResultModel;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import resManager.resNet.dao.ResNetDao;
import resManager.resNet.model.*;
import sysManager.log.dao.LogDao;
import db.BaseDAO;
import db.DbDAO;
import flex.messaging.FlexContext;

/**
 * 
 * @ClassName: resNodeDwr
 * @Description: TODO(此文件用于资源管理中的 节点模型管理)
 * @author mawj
 * @date 2013-7-4 下午02:42:35
 * 
 */
public class ResNetDwr extends NetresdataValidator {

	private final static Log log = LogFactory.getLog(ResNetDwr.class);
	ApplicationContext ctx = WebApplicationContextUtils
			.getWebApplicationContext(FlexContext.getServletContext());
	private DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");// 用于 jdbc
	private ResNetDao resNetDao;

	/**
	 * 
	 * @Title: getEquipmentLst
	 * @Description: TODO(获取设备信息)
	 * @param @param equipment
	 * @param @return 设定文件
	 * @return ResultModel 返回类型
	 * @throws
	 */
	public ResultModel getEquipmentLst(Equipment model) {
		ResultModel result = new ResultModel();
		try {
			result.setTotalCount(resNetDao.getEquipmentCount(model));
			List<Equipment> list = resNetDao.getEquipmentLst(model);

			/*for (int i = 0; i < list.size(); i++) {
				Equipment key = list.get(i);
				// 设置设备厂商
				key.setX_vendor(resNetDao.getX_VendorNameById(key.getX_vendor()));
				// 设置设备所属系统
				key.setSystem_name(resNetDao.getSysNameById(key
						.getSystem_name()));
				// 设置设备类型
				key.setEquiptype(resNetDao.getEquiptypeById(key.getEquiptype()));
			}*/
			result.setOrderList(list);
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "资源模块", "查询设备", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 
	 * @Title: delEquipmentByModel
	 * @Description: TODO(删除设备信息)
	 * @param @param Equipment
	 * @param @return 设定文件
	 * @return String str:其值可能为2种：1.success->说明成功的删除了数据。2.failed->说明删除数据失败。
	 * @throws
	 */
	public String delEquipmentByModel(Equipment model) {
		String str = null;
		try {
			//把相关的信息都删除，再删除设备，调用一个存储过程(框、槽、盘、端口、复用段、交叉)
				resNetDao.delEquipmentByModel(model.getEquipcode());
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "资源模块", "删除设备", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}
		return str;
	}

	/**
	 * @title: getX_VendorLst
	 * @todo: 获取设备厂商
	 * @return:string
	 */
	public String getX_VendorLst() {
		String result = "";
		List<ComboxDataModel> lst = resNetDao.getX_VendorLst();
		for (ComboxDataModel data : lst) {
			result += "<x_vendor id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"x_vendor\"  isBranch=\"false\"></x_vendor>";
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @title getSysNameLst
	 * @todo 获取传输系统列表
	 * @date 2013-07-16
	 */
	public String getSysNameLst() {
		String result = "";
		List<ComboxDataModel> lst = resNetDao.getSysNameLst();
		for (ComboxDataModel data : lst) {
			result += "<system_name id=\""
					+ data.getId()
					+ "\" label=\""
					+ data.getLabel()
					+ "\" name=\"system_name\" isBranch=\"false\"></system_name>";
		}
		return result;
	}

	/**
	 * 此函数用于获取某厂商设备的型号数据信息。
	 * 
	 * @param vendor
	 *            :厂商。
	 * @return result:其值为XML形式的String。
	 * @author xgyin
	 * @version ver.1.0
	 * 
	 * */
	public String getX_modelLst(String vendor) {
		String result = "";
		List<ComboxDataModel> lst = null;
		lst = resNetDao.getEquipmentX_Model(vendor);
		for (ComboxDataModel data : lst) {
			result += "<x_model id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"x_model\"  isBranch=\"false\"></x_model>";
		}
		return result;
	}

	/**
	 * 此函数用于获取某厂商设备的类型数据信息。
	 * 
	 * @param
	 * @return result:其值为XML形式的String。
	 * @author xgyin
	 * @version ver.1.0
	 * 
	 * */
//	public String getX_equiptypeLst() {
//		String result = "";
//		List<ComboxDataModel> lst = null;
//		lst = resNetDao.getX_equiptypeLst();
//		for (ComboxDataModel data : lst) {
//			result += "<equiptype id=\"" + data.getId() + "\" label=\""
//					+ data.getLabel()
//					+ "\"  name=\"equiptype\"  isBranch=\"false\"></equiptype>";
//		}
//		return result;
//	}

	/**
	 * 
	 * @Title: SDHExportEXCEL
	 * @Description: TODO(导出Excel的函数)
	 * @param @param labels
	 * @param @param titles
	 * @param @param types
	 * @param @param model Excel文件表头 titles: 栏目名 types:导出excel类型
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @throws
	 */
	public String equipExportEXCEL(String labels, String[] titles,
			String types, Equipment model) {
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
		List<Equipment> sdhList = resNetDao.getEquipmentLst(model);
		int SDHCoutnt = sdhList.size();
		content = new ArrayList();
		for (int i = 0; i < SDHCoutnt; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i + 1);// 序号
			newcolmn.add(sdhList.get(i).getS_sbmc() == null ? "" : sdhList.get(
					i).getS_sbmc());
			newcolmn.add(sdhList.get(i).getX_model() == null ? "" : sdhList
					.get(i).getX_model());
			newcolmn.add(sdhList.get(i).getX_vendor() == null ? "" : sdhList
					.get(i).getX_vendor());
			newcolmn.add(sdhList.get(i).getEquiptype() == null ? "" : sdhList
					.get(i).getEquiptype());
			newcolmn.add(sdhList.get(i).getEquiplabel() == null ? "" : sdhList
					.get(i).getEquiplabel());
			newcolmn.add(sdhList.get(i).getSystem_name() == null ? "" : sdhList
					.get(i).getSystem_name());
			newcolmn.add(sdhList.get(i).getUpdateperson() == null ? ""
					: sdhList.get(i).getUpdateperson());
			newcolmn.add(sdhList.get(i).getUpdatedate() == null ? "" : sdhList
					.get(i).getUpdatedate());

			content.add(newcolmn);
		}
//		if (SDHCoutnt > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[SDHCoutnt % 20000 == 0 ? SDHCoutnt / 20000 + 1
//						: SDHCoutnt / 20000 + 2];
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
		logDao.createLogEvent("导出", "资源模块", "SDH导出", "", request);
		return path;
	}

	public ResNetDao getResNetDao() {
		return resNetDao;
	}

	public void setResNetDao(ResNetDao resNetDao) {
		this.resNetDao = resNetDao;
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
		RealPath = fullPath.substring(0, fullPath.indexOf("WEB-INF"));// linux下的情况
		RealPath += "exportExcel/";
		return RealPath;
	}

	/**
	 * 清理文件夹
	 * */
	public String ClearDir(String pattern) {
		String fullPath = this.getClass().getResource("").getPath().toString();
		String RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));
		String Path = RealPath + pattern + "/";
		CharSequence c = ".svn";
		File dir = new File(Path);
		String names[] = dir.list();
		if (names.length > 1) {
			for (int i = 0; i < names.length; i++) {
				if (!names[i].contains(c)) {
					if (new File(Path + names[i]).isDirectory()) {
						new ExportExcel().deleteDirectory(Path + names[i]);
					} else {
						new ExportExcel().deleteFile(Path + names[i]);
					}
				}
			}
			return "Success";
		} else {
			return "blank";
		}
	}

	// 端口 oder by yangzhong 2013-7-11 start
	/**
	 * 获取端口类型
	 * 
	 * @param logicPort
	 * @return
	 */
	public String getPortType() {
		String result = "";
		List<ComboxDataModel> lst = resNetDao.getPortType();
		for (ComboxDataModel data : lst) {
			result += "<porttype id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"porttype\"  isBranch=\"false\"></porttype>";
		}
		return result;
	}

	/**
	 * 获取端口状态
	 * 
	 * @param logicPort
	 * @return
	 */
	public String getPortStatus() {
		String result = "";
		List<ComboxDataModel> lst = resNetDao.getPortStatus();
		for (ComboxDataModel data : lst) {
			result += "<porttype id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"porttype\"  isBranch=\"false\"></porttype>";
		}
		return result;
	}

	/**
	 * 获取端口速率
	 * 
	 * @param logicPort
	 * @return
	 */
	public String getPortRate() {
		String result = "";
		List<ComboxDataModel> lst = resNetDao.getPortRate();
		for (ComboxDataModel data : lst) {
			result += "<portrate id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"portrate\"  isBranch=\"false\"></portrate>";
		}
		return result;
	}

	/**
	 * 获取端口信息
	 * 
	 * @param logicPort
	 * @return
	 */
	public ResultModel getLogicPort(LogicPort logicPort) {
		ResultModel result = new ResultModel();
		try {
			result.setTotalCount(resNetDao.GetLogicPortCount(logicPort));
			result.setOrderList(resNetDao.GetLogicPort(logicPort));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "资源模块", "查询端口", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 添加端口信息
	 * 
	 * @param logicPort
	 * @return
	 */
	public String addLogicPortModel(LogicPort logicPort) {
		try {
			// LogicPort logicPort=null;
			resNetDao.addLogicPort(logicPort);
			// System.out.println("-------------"+logicPort.getEquipcode());
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "资源模块", "添加端口", "", request);
			return "success";
		} catch (Exception e) {
			return "failed";
		}
	}

	/**
	 * 修改端口信息
	 * 
	 * @param logicPort
	 * @return
	 */
	public String ModifyLogicPort(LogicPort logicPort) {
		String str = null;
		try {
			SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd");
			String date = sDateFormat.format(new java.util.Date());
			logicPort.setUpdatedate(date);
			if (this.resNetDao.ModfyLogicPort(logicPort) > 0) {
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("修改", "资源模块", "修改端口", "", request);
			} else {
				str = "failed";
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}
		return str;
	}
	/**
	 * @author xgyin
	 * @ use:检查端口序号是否占用
	 * @ name :checkPortSerial
	 */
	public String checkPortSerial(String equipcode,String frameserial,String slotserial,String packserial,String portserial) {
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		map.put("portserial", portserial);
		String str = "failed";
		try {
			List<LogicPort> logicPort = resNetDao.checkPortSerial(map);
			if(logicPort.size()>0){
				str = "success";//存在
			}
		} catch (Exception e) {
			str= "failed";
		}
		return str;
	}
	/**
	 * 删除端口信息
	 * 
	 * @param logicPort
	 * @return
	 */
	public String delLogicPort(LogicPort logicPort) {
		try {
			resNetDao.delLogicPort(logicPort);
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("删除", "资源模块", "删除端口", "", request);
			return "success";
		} catch (Exception e) {
			return "failed";
		}
	}

	/**
	 * 导出逻辑端口信息
	 * 
	 * @param logicPort
	 * @order by yanghzong
	 */
	public String LogicPortExportEXCEL(String labels, String[] titles,
			String types, LogicPort model) {
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
		List<LogicPort> portList = resNetDao.GetLogicPort(model);
		int portCoutnt = resNetDao.GetLogicPortCount(model);
		content = new ArrayList();
		for (int i = 0; i < portCoutnt; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i + 1);// 序号
			newcolmn.add(portList.get(i).getEquipname() == null ? "" : portList
					.get(i).getEquipname());
			newcolmn.add(portList.get(i).getFrameserial() == null ? ""
					: portList.get(i).getFrameserial());
			newcolmn.add(portList.get(i).getSlotserial() == null ? ""
					: portList.get(i).getSlotserial());
			newcolmn.add(portList.get(i).getPackserial() == null ? ""
					: portList.get(i).getPackserial());
			newcolmn.add(portList.get(i).getPortserial() == null ? ""
					: portList.get(i).getPortserial());
			newcolmn.add(portList.get(i).getY_porttype() == null ? ""
					: portList.get(i).getY_porttype());
			newcolmn.add(portList.get(i).getX_capability() == null ? ""
					: portList.get(i).getX_capability());
			newcolmn.add(portList.get(i).getUpdatedate() == null ? ""
					: portList.get(i).getUpdatedate());
			content.add(newcolmn);
		}
		
//		if (portCoutnt > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[portCoutnt % 20000 == 0 ? portCoutnt / 20000 + 1
//						: portCoutnt / 20000 + 2];
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
//				// TODO Auto-generated catch block
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
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			path = "exportExcel/" + filename;
//		}

		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "资源模块", "端口导出", "", request);
		return path;
	}

	// 端口 oder by yangzhong 2013-7-11 end

	// 复用段 oder by yangzhong 2013-7-14 start
	/**
	 * 获取复用段信息
	 * 
	 * @param topoLink
	 * @return
	 */
	public ResultModel getTopoLink(TopoLink topoLink) {
		ResultModel result = new ResultModel();
		try {
//			if (topoLink.getAendptpcode().equals("")
//					&& !topoLink.getZendptpcode().equals("")) {
//				topoLink.setAendptpcode(topoLink.getZendptpcode());
//				topoLink.setMark("OR");
//			} else if (!topoLink.getAendptpcode().equals("")
//					&& topoLink.getZendptpcode().equals("")) {
//				topoLink.setZendptpcode(topoLink.getAendptpcode());
//				topoLink.setMark("OR");
//			} else if (!topoLink.getAendptpcode().equals("")
//					&& !topoLink.getZendptpcode().equals("")) {
//				topoLink.setMark("AND");
//			}
			result.setTotalCount(resNetDao.GetTopoLinkCount(topoLink));
			result.setOrderList(resNetDao.GetTopoLink(topoLink));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "资源模块", "查询复用段", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public String QueryRoutebyEquip(String aequip,String zequip){
		ResultModel result = new ResultModel();
		String tp="";
		String sql= " aequip= '" + aequip + "' and zequip='" + zequip + "'";  
		result.setOrderList(resNetDao.QueryRoutebyEquip(sql));
	//	List resultset=new ArrayList();
		
		for(int x=0;x<result.getOrderList().size();x++)
		{
			//if((String)result.getOrderList().get(x).)
			tp+=(String)result.getOrderList().get(x)+";;";
		}
		return tp;
		//return Integer.toString(result.getOrderList().size());
	}

	/**
	 * 添加复用段信息
	 * 
	 * @author yangzhong 2013-7-17
	 * @param topoLink
	 * @return
	 */
	public String AddTopLinks(TopoLink tk) {
		String str = null;
		Map map = null;
		try {
			tk.setUpdatedate(getName().substring(0, 10));
			resNetDao.AddTopoLink(tk);
			
			map = new HashMap();// add by xzk 修改A端和Z端端口状态为占用
			map.put("status", "ZY13100202");
			map.put("logicport", tk.getAendptpcode());
			resNetDao.updatePortStatus(map);

			map = new HashMap();
			map.put("status", "ZY13100202");
			map.put("logicport", tk.getZendptpcode());
			resNetDao.updatePortStatus(map);

			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "资源模块", "添加复用段", "", request);
			str = "success";
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}

		return str;
	}
	/**
	 *根据设备编号查找设备所属系统 
	 * 
	 **/
	public String getSystemcodesByEquipcode(String equipcode){
		String systemcode="";
		systemcode = this.resNetDao.getSystemcodesByEquipcode(equipcode);
		return systemcode;
	}

	/**
	 * 修改复用段信息
	 * 
	 * @author yangzhong 2013-7-17
	 * @param topoLink
	 * @return
	 */
	public String ModifyTopoLink(TopoLink topoLink) {
		String str = null;
		try {
			if (resNetDao.ModifyTopoLink(topoLink) > 0) {
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("修改", "资源模块", "修改复用段", "", request);
				str = "success";
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}

		return str;
	}

	public String delToplinkByID(String linkid){
		String str = null;
		try {
			TopoLink tk = this.resNetDao.getToplinkByID(linkid);
			if (tk!=null&&resNetDao.delTopoLink(tk) > 0) {
				//删除时，更新端口状态
				Map map = new HashMap();
				map.put("status", "ZY13100201");
				map.put("logicport", tk.getAendptpcode());
				resNetDao.updatePortStatus(map);
				Map map2 = new HashMap();
				map2.put("status", "ZY13100201");
				map2.put("logicport", tk.getZendptpcode());
				resNetDao.updatePortStatus(map2);
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "资源模块", "删除复用段", "", request);
				str = "success";
			} else {
				str = "failed";
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}
		return str;
	}
	
	/**
	 * 删除复用段信息
	 * 
	 * @author yangzhong 2013-7-17
	 * @param tk
	 * @return
	 */
	public String delTopoLink(TopoLink tk) {
		String str = null;
		try {
			if (resNetDao.delTopoLink(tk) > 0) {
				//删除时，更新端口状态
				Map map = new HashMap();
				map.put("status", "ZY13100201");
				map.put("logicport", tk.getAendptpcode());
				resNetDao.updatePortStatus(map);
				Map map2 = new HashMap();
				map2.put("status", "ZY13100201");
				map2.put("logicport", tk.getZendptpcode());
				resNetDao.updatePortStatus(map2);
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "资源模块", "删除复用段", "", request);
				str = "success";
			} else {
				str = "failed";
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}
		return str;
	}

	/**
	 * 此函数用于获取数据库中传输系统的数据信息。
	 * 
	 * @param 无参
	 *            。
	 * @return result:String类型对象，XML格式。
	 * @author yangzhong 2013-7-17
	 * @version ver.1.0
	 * */

	public String getTransSystem() {
		String result = "";
		List<ComboxDataModel> lst = resNetDao.getTransSystem();
		for (ComboxDataModel data : lst) {
			result += "<transystem id=\"" + data.getId() + "\" label=\""
					+ data.getLabel() + "\" isBranch=\"false\"></transystem>";
		}
		return result;
	}

	/**
	 * @author xgyin
	 * @use 检查端口上是否有复用段
	 * @name checkPortUse
	 */
	public String checkPortUse(String portcode){
		String str = "success";
		List<LogicPort> list = new ArrayList<LogicPort>();
		try {
			 list= resNetDao.checkPortUse(portcode);
			if(list.size()>0){
				str="failed";
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "success";
		}
		return str;
	}
	
	/**
	 * 此函数用于获取数据库中复用段的速率。
	 * 
	 * @param 无参
	 *            。
	 * @return result:String类型对象，XML格式。
	 * @author yangzhong 2013-7-17
	 * @version ver.1.0
	 * */
	public String getLineRate() {
		String result = "";
		List<ComboxDataModel> lst = resNetDao.getLineRate();
		for (ComboxDataModel data : lst) {
			result += "<linerate id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"linerate\"  isBranch=\"false\"></linerate>";
		}
		return result;
	}

	/**
	 * 导复用段信息
	 * 
	 * @param TopoLink
	 * @order by yangzhong 2013-7-17
	 */
	public String TopoLinkExportEXCEL(String labels, String[] titles,
			String types, TopoLink model) {
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
		List<TopoLink> topoLinkList = resNetDao.GetTopoLink(model);
		int topoLinkCoutnt = resNetDao.GetTopoLinkCount(model);
		content = new ArrayList();
		for (int i = 0; i < topoLinkCoutnt; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i + 1);// 序号
			newcolmn.add(topoLinkList.get(i).getEquipname_a() == null ? ""
					: topoLinkList.get(i).getEquipname_a());
			newcolmn.add(topoLinkList.get(i).getEquipname_z() == null ? ""
					: topoLinkList.get(i).getEquipname_z());
			newcolmn.add(topoLinkList.get(i).getA_systemcode() == null ? ""
					: topoLinkList.get(i).getA_systemcode());
			newcolmn.add(topoLinkList.get(i).getZ_systemcode() == null ? ""
					: topoLinkList.get(i).getZ_systemcode());
			newcolmn.add(topoLinkList.get(i).getLinerate() == null ? ""
					: topoLinkList.get(i).getLinerate());
			newcolmn.add(topoLinkList.get(i).getAendptp() == null ? ""
					: topoLinkList.get(i).getAendptp());
			newcolmn.add(topoLinkList.get(i).getZendptp() == null ? ""
					: topoLinkList.get(i).getZendptp());
			newcolmn.add(topoLinkList.get(i).getLinelength() == null ? ""
					: topoLinkList.get(i).getLinelength());
			newcolmn.add(topoLinkList.get(i).getRemark() == null ? ""
					: topoLinkList.get(i).getRemark());
			newcolmn.add(topoLinkList.get(i).getUpdatedate() == null ? ""
					: topoLinkList.get(i).getUpdatedate());
			// newcolmn.add(topoLinkList.get(i).getUpdatedate() == null?
			// "":topoLinkList.get(i).getUpdatedate());
			content.add(newcolmn);
		}
//		if (topoLinkCoutnt > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[topoLinkCoutnt % 20000 == 0 ? topoLinkCoutnt / 20000 + 1
//						: topoLinkCoutnt / 20000 + 2];
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
//				// TODO Auto-generated catch block
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
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			path = "exportExcel/" + filename;
//		}

		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "资源模块", "端口导出", "", request);
		return path;
	}

	// 复用段 oder by yangzhong 2013-7-14 end

	/**
	 * 复用段的选择设备，处理函数
	 * 
	 * @param TopoLink
	 * @order by yangzhong 2013-7-18
	 */
	public String getEquipBytopolinksearch(String child_systemcode,
			String topolinkeqsearch) {
		String result = "";
		Map map = new HashMap();
		map.put("systemcode", child_systemcode);
		map.put("topolinkeqsearch", topolinkeqsearch);
		List<ComboxDataModel> list = resNetDao.getEquipBytopolinksearch(map);
		for (ComboxDataModel data : list) {
			result += "<equip id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"equip\" isBranch=\"false\"></equip>";
		}

		return result;
	}

	/**
	 * 根据设备，框，槽 获取盘信息
	 * 
	 * @param EquipPort
	 * @order by yangzhong 2013-7-18
	 */
	public String getPackseriaByEuipSlot(String equipcode, String frameserial,
			String slotserial) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");
		String result = "";
		Map paraMap = new HashMap();
		paraMap.put("equipcode", equipcode);
		paraMap.put("frameserial", frameserial);
		paraMap.put("slotserial", slotserial);
		List<HashMap> list = basedao.queryForList("getPackseriaByEuipSlot",
				paraMap);
		if (list != null && list.size() > 0) {
			for (HashMap map : list) {
				result += "<pack id=\"" + (String) map.get("PACKSERIAL")
						+ "\" label=\"" + (String) map.get("PACKSERIAL")
						+ "\" isBranch=\"false\"></pack>";

			}
		}
		return result;
	}

	/**
	 * 通过设备，获取端口树信息
	 * 
	 * @param EquipPort
	 * @order by yangzhong 2013-7-18
	 */
	public String getPort(String equipcode, String textname, String rate,
			String parentnode, String nodeid, String tree,boolean flag) {

		String parentID = parentnode;
		String xml="";
		Map portRate2Field = new HashMap();
		Map tsRateMap;
		String slotRate;
		System.out.println(equipcode+"!!!!!!!!!!"+rate);
		boolean isLeaf = false;
		System.out.println(rate);
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
		// rate2TsStatus.put("ZY110699", "YW010299");
		rate2Field.put("ZY110612", "RATE2M");
		// rate2Field.put("ZY110613", "TS45MSTATUS");

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

		// 初始化资源数的第一层节点（端口类型：线路口，支路口
		if (tree.equalsIgnoreCase("root")) {
			xml = executeRootForPortType(equipcode, rate2Capacode.get(rate)
					.toString());
			System.out.println(xml);
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
					.toString(),flag);//modify by xgyin
			return xml;
		}

		return null;
	}
	/*
	 * 在复用段，获取端口树的第一层() order by yangzhong time 2013-7-19
	 */
	public String executeRootForPortType(String equipcode, String rate) {
		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		String xml = "";
		try {
			String sql = "select * from (select distinct porttypecode,porttypename from v_selectts$oc v where v.equipcode='"
					+ equipcode
					+ "' and v.capacode>'"
					+ rate
					+ "'  and v.capacode<>'ZY070112'"
					+ ")order by porttypecode ";
			// +
			// "union select distinct l.y_porttype porttypecode,x.xtxx porttypename from equiplogicport l,xtbm x where "
			// + "l.equipcode=lpad('"
			// + equipcode
			// + "',20,'0') and  x.xtbm=l.y_porttype "
			// + "and l.x_capability='"
			// + rate
			// + "' and l.x_capability<>'ZY070112' and l.logicport not in"
			// + "(select aptp portcode from cc where pid='"
			// + equipcode
			// + "' union select zptp portcode from cc where pid='"
			// + equipcode + "')) order by porttypecode";

			System.out.println(sql);
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

	/*
	 * 在复用段，获取端口树的第二层() order by yangzhong time 2013-7-19
	 */
	public String executeGetEquipPort(String equipcode, String nodeType,
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
		if("YW".equals(rate.substring(0, 2))){
			rate =  rate2Capacode.get(rate).toString();
		}
		try {
			String sql = "select * from (select distinct capacode,capaname from v_selectts$oc v where v.equipcode='"
					+ equipcode
					+ "' and porttypecode='"
					+ nodeType
					+ "' and capacode='" + rate + "')order by capacode desc";
			// + "' union "
			// +
			// "select distinct l.x_capability capacode,x.xtxx capaname from equiplogicport l,xtbm x where "
			// + "l.equipcode=lpad('"
			// + equipcode
			// + "',20,'0') and l.y_porttype='"
			// + nodeType
			// + "' and l.x_capability=x.xtbm "
			// + "and l.x_capability='"
			// + rate
			// +
			// "' and l.x_capability<>'ZY070112' and l.logicport not in (select aptp portcode from cc where pid='"
			// + equipcode
			// + "' union select zptp portcode from cc where pid='"
			// + equipcode + "'))order by capacode desc";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			System.out.println(sql);
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

	/*
	 * 在复用段，获取端口树的第二层() order by yangzhong time 2013-7-19
	 */
	public String executeGetPortInfo(String equipCode, String nodeType,
			String rate,boolean flag) {

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
		String sql = "";
		try {
			if(flag){//modify by xgyin
				 sql = "select * from (select distinct logicport,getportlabelnew(logicport) portname,capacode,v.slotserial,v.frameserial,v.portserial from view_porttree v where v.equipcode='"
					+ equipCode
					+ "' and capacode='"
					+ nodeType
					+ "' minus select distinct logicport,getportlabelnew(logicport) portname,x_capability capacode, slotserial,frameserial,portserial from equiplogicport "
					+ "where equipcode='"
					+ equipCode
					+ "' and x_capability='"
					+ rate
					+ "' and logicport in(select aptp portcode from cc "
					+ "where pid='"
					+ equipCode
					+ "' union select zptp portcode from cc where pid='"
					+ equipCode + "'))a where a.logicport not in(select distinct s.aendptp from en_topolink s ) and a.logicport not in(select distinct s.zendptp from en_topolink s ) order by to_number(a.frameserial),to_number(a.slotserial),to_number(a.portserial)";
			}
			else{
				 sql = "select * from (select distinct logicport,getportlabelnew(logicport) portname,capacode,v.slotserial,v.frameserial,v.portserial from v_selectts$oc v where v.equipcode='"
					+ equipCode
					+ "' and capacode='"
					+ nodeType
					+ "' minus select distinct logicport,getportlabelnew(logicport) portname,x_capability capacode,slotserial,frameserial,portserial from equiplogicport "
					+ "where equipcode='"
					+ equipCode
					+ "' and x_capability='"
					+ rate
					+ "' and logicport in(select aptp portcode from cc "
					+ "where pid='"
					+ equipCode
					+ "' union select zptp portcode from cc where pid='"
					+ equipCode + "'))a where a.logicport not in(select distinct s.aendptp from en_topolink s ) and a.logicport not in(select distinct s.zendptp from en_topolink s ) order by to_number(a.frameserial),to_number(a.slotserial),to_number(a.portserial)";
			}

			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			System.out.println(sql);
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
	

	public ResultModel getCCList(CCModel model) {
		ResultModel result = new ResultModel();
		try {
			result.setTotalCount(resNetDao.getCCCount(model));
			result.setOrderList(resNetDao.getCCList(model));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "资源模块", "查询交叉连接", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public ResultModel getCCListNew(CCModel model){
		ResultModel result = new ResultModel();
		try {
			result.setTotalCount((Integer)basedao.queryForObject("getUnusedCCCount",null));
			result.setOrderList(resNetDao.getCCList(model));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "资源模块", "查询交叉连接", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public String delCCByid(CCModel model){
			String str = "";
			try{
				resNetDao.delCCByid(model.getId());
				str = "success";
			}catch(Exception e) {
				e.printStackTrace();
				str = "fails";
			}
			return str;
		}
	
	
	public String delCCByID(String id){
		String str = "";
		try{
			resNetDao.delCCByid(id);
			str = "success";
		}catch(Exception e) {
			e.printStackTrace();
			str = "fails";
		}
		return str;
	}
	
	
	public String ccExportEXCEL(String labels, String[] titles,
			String types, CCModel model) {
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
		List<CCModel> ccList = resNetDao.getCCList(model);
		int ccCount = resNetDao.getCCCount(model);
		content = new ArrayList();
		for (int i = 0; i < ccCount; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i + 1);// 序号
			newcolmn.add(ccList.get(i).getPid() == null ? "" : ccList.get(
					i).getPid());
			newcolmn.add(ccList.get(i).getRate() == null ? "" : ccList
					.get(i).getRate());
			newcolmn.add(ccList.get(i).getDirection() == null ? "" : ccList
					.get(i).getDirection());
			newcolmn.add(ccList.get(i).getAptp() == null ? "" : ccList
					.get(i).getAptp());
			newcolmn.add(ccList.get(i).getAslot() == null ? "" : ccList
					.get(i).getAslot());
			newcolmn.add(ccList.get(i).getZptp() == null ? "" : ccList
					.get(i).getZptp());
			newcolmn.add(ccList.get(i).getZslot() == null ? "" : ccList
					.get(i).getZslot());
			newcolmn.add(ccList.get(i).getUpdateperson() == null ? ""
					: ccList.get(i).getUpdateperson());
			newcolmn.add(ccList.get(i).getIsdefault() == null ? ""
					: ccList.get(i).getIsdefault());
//			newcolmn.add(ccList.get(i).getSync_status() == null ? ""
//					: ccList.get(i).getSync_status());
			newcolmn.add(ccList.get(i).getUpdatedate() == null ? "" : ccList
					.get(i).getUpdatedate());

			content.add(newcolmn);
		}
//		if (ccCount > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[ccCount % 20000 == 0 ? ccCount / 20000 + 1
//						: ccCount / 20000 + 2];
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
		logDao.createLogEvent("导出", "资源模块", "SDH导出", "", request);
		return path;
	}
	
	public String getTopolinkByEquipsearch(String equipcode,
			String toposearch,String flag) {
		String result = "";
		Map map = new HashMap();
		if(equipcode.indexOf("=")!=-1){
			equipcode = equipcode.split("=")[0];
		}
		map.put("equipcode", equipcode);
		map.put("toposearch", toposearch);
		map.put("flag", flag);
		List<ComboxDataModel> list = resNetDao.getTopolinkByEquipsearch(map);
		for (ComboxDataModel data : list) {
			result += "<topo id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"topo\" isBranch=\"false\"></topo>";
		}

		return result;
	}
}
