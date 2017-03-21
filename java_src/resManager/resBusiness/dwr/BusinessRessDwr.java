package resManager.resBusiness.dwr;

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

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;

import jxl.write.WriteException;

import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ZipExcel;
import netres.model.ComboxDataModel;

import org.springframework.context.ApplicationContext;
import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import channelroute.model.CircuitroutModel;

import com.metarnet.VerticallyImpl;
import com.model.request.Condition;
import com.util.DBHelper;

import resManager.resBusiness.model.Circuit;
import db.BaseDAO;
import db.DbDAO;

import sysManager.log.dao.LogDao;
import faultSimulation.dao.SceneMgrDAO;
import flex.messaging.FlexContext; //import businessDispatch.dao.BusinessDispatchDAO;
import resManager.resBusiness.dao.BusinessRessDAO;
import resManager.resBusiness.model.BusinessRessModel;
import resManager.resBusiness.model.CircuitChannel;
import resManager.resBusiness.model.GetSystemRelations;
import resManager.resBusiness.model.Node;
import resManager.resBusiness.model.ResultModel;
import resManager.resBusiness.model.CircuitBusinessModel;
import resManager.resNet.model.LogicPort;

/**
 * 方式管理-业务资源
 * 
 * @author sunjt
 * 
 */
public class BusinessRessDwr {

	private BusinessRessDAO ressDao;
	private static EntityManagerFactory factory;
	private static final String PERSIST_UNIT = "VerticallyInterop";
	ApplicationContext ctx = WebApplicationContextUtils
			.getWebApplicationContext(FlexContext.getServletContext());
	private DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");

    
	public BusinessRessDAO getRessDao() {
		return this.ressDao;
	}

	public void setRessDao(BusinessRessDAO ressDao) {
		this.ressDao = ressDao;
	}

	/**
	 * 该方法用于查询业务资源的数据
	 * 
	 * @param model
	 *            ：BusinessRessModel
	 * @author sunjt
	 * @return
	 */
	public ResultModel getRess(BusinessRessModel model) {
		ResultModel remodel = new ResultModel();
		remodel.setTotalCount(this.ressDao.getRessCount(model));
		remodel.setOrderList(this.ressDao.getRessList(model));
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "方式管理模块", "查询业务资源", "", request);
		return remodel;

	}

	/**
	 * 该方法用于在业务资源中添加数据
	 * 
	 * @param mo
	 *            ：BusinessRessModel
	 * @author sunjt
	 * @return str字符串 字符串为success->添加成功 faile->添加失败
	 */
	public String addRess(BusinessRessModel mo) {
		String str = "";
		try {
			ressDao.insertRess(mo);
			str = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "方式管理模块", "添加业务资源", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			str = "faile";
		}
		return str;
	}

	/**
	 * 该方法用于删除业务资源中的一条数据
	 * 
	 * @param mo
	 *            ：BusinessRessModel
	 * @author sunjt
	 * @return
	 */
	public String deletRess(BusinessRessModel mo) {
		boolean b = false;
		String str = null;
		try {
			if (b = ressDao.deleRess(mo)) {
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "方式管理模块", "删除业务资源", "", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "faile";
		}
		return str;
	}

	public String updateRess(BusinessRessModel mo) {
		String str = null;
		try {
			ressDao.updateRess(mo);
			str = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("更新", "方式管理模块", "更新业务资源", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			str = "faile";
		}
		return str;
	}

	/**
	 * 导出业务信息
	 * 
	 * @param BusinessRessModel
	 * @order by lsyu 2013-7-22
	 */
	public String businessExportEXCEL(String labels, String[] titles,
			String types, BusinessRessModel model) {
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
		List<BusinessRessModel> businessList = ressDao.getRessList(model);
		int businessCount = ressDao.getRessCount(model);
		content = new ArrayList();
		for (int i = 0; i < businessCount; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i + 1);// 序号
			newcolmn.add(businessList.get(i).getbusiness_name() == null ? ""
					: businessList.get(i).getbusiness_name());
			newcolmn.add(businessList.get(i).getCircuitcode() == null ? ""
					: businessList.get(i).getCircuitcode());
			newcolmn.add(businessList.get(i).getEnd_id_a() == null ? ""
					: businessList.get(i).getEnd_id_a());
			newcolmn.add(businessList.get(i).getEnd_id_z() == null ? ""
					: businessList.get(i).getEnd_id_z());
			newcolmn.add(businessList.get(i).getBusiness_type() == null ? ""
					: businessList.get(i).getBusiness_type());
			newcolmn.add(businessList.get(i).getBusiness_rate() == null ? ""
					: businessList.get(i).getBusiness_rate());
			newcolmn.add(businessList.get(i).getBusiness_state() == null ? ""
					: businessList.get(i).getBusiness_state());
			newcolmn.add(businessList.get(i).getVersion_id() == null ? ""
					: businessList.get(i).getVersion_id());
			// newcolmn.add(topoLinkList.get(i).getUpdatedate() == null?
			// "":topoLinkList.get(i).getUpdatedate());
			content.add(newcolmn);
		}
//		if (businessCount > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath + date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[businessCount % 20000 == 0 ? businessCount / 20000 + 1
//						: businessCount / 20000 + 2];
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
//			path = "exportExcel/" + date + ".zip";
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
		logDao.createLogEvent("导出", "资源模块", "业务导出", "", request);
		return path;
	}

	/**
	 * 根据查询条件取得业务模块需要的电路名称
	 * 
	 * @param searchTexts
	 * @return
	 */
	public String getCircuitBySearchText(String searchTexts) {
		StringBuffer sb = new StringBuffer();
		Map map = new HashMap();
		map.put("searchtext", searchTexts);
		List<ComboxDataModel> list = ressDao.getCircuitBySearchText(map);
		// for (ComboxDataModel data : list) {
		// String checked="0";
		// if(circuitcode!=null&&!"".equals(circuitcode)){
		// String[] circuitcodes = circuitcode.split(",");
		// for(String str:circuitcodes) {
		// if(str.equals(data.getId())){
		// checked="1";
		// }
		// }
		// }
		// sb.append("<circiut id=\"" + data.getId() + "\"label=\""
		// + data.getLabel()
		// +
		// "\" name=\"circiut\" isBranch=\"false\" checked=\""+checked+"\"></circiut>");
		// }
		for (ComboxDataModel data : list) {
//			sb.append("<circuit id=\"" + data.getId() + "\"label=\""
//					+ data.getLabel()
//					+ "\" name=\"circuit\" isBranch=\"false\"></circuit>");
			sb.append("<circiut id=\"" + data.getId() + "\"label=\""
			           + data.getLabel()
			           .replaceAll("<","&lt;")
			           .replaceAll(">","&gt;")
			           + "\" name=\"circiut\" isBranch=\"false\"></circiut>");

		}
		return sb.toString();
	}

	/**
	 * 根据查询条件取得业务模块需要的电路名称和ID
	 * 
	 * @param searchTexts
	 * @return
	 */
	public String getCircuitCodeBySearchText(String searchTexts) {
		StringBuffer sb = new StringBuffer();
		Map map = new HashMap();
		map.put("searchtext", searchTexts);
		List<ComboxDataModel> list = ressDao.getCircuitCodeBySearchText(map);
		for (ComboxDataModel data : list) {
			sb.append("<circiut id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"circiut\" isBranch=\"false\"></circiut>");
		}

		return sb.toString();
	}

	/**
	 * 根据电路编码取得A端站点和Z端站点
	 * 
	 * @param circuitcode
	 * @return
	 */
	public String getStationAAndStationZByCircuitcode(String circuitcode) {
		String result = "";
		List<ComboxDataModel> list1 = ressDao
				.getStationAByCircuitcode(circuitcode);
		List<ComboxDataModel> list2 = ressDao
				.getStationZByCircuitcode(circuitcode);
		for (ComboxDataModel data1 : list1) {
			result += "<name label='" + data1.getLabel() + "'  code='"
					+ data1.getId() + "'/>" + "splite";
		}
		for (ComboxDataModel data2 : list2) {
			result += "<name label='" + data2.getLabel() + "'  code='"
					+ data2.getId() + "'/>";
		}
		return result;
	}

	/**
	 * 删除一条电路（根据电路编码）
	 * 
	 * @param circuitcode
	 */
	public String deleteCircuit(Circuit circuit) {
		boolean flag = false;

		try {
			flag = ressDao.deleteCircuit(circuit.getCircuitcode());
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (flag == true) {
			return "success";
		} else {
			return "fail";
		}
	}

	/**
	 * 
	 * @Title: getCircuit
	 * @Description: TODO(获取电路信息)
	 * @param @param circuit
	 * @param @return 设定文件
	 * @return ResultModel 返回类型
	 * @throws
	 */
	public ResultModel getCircuit(Circuit circuit) {
		ResultModel result = new ResultModel();

		try {
			result.setTotalCount(ressDao.getCircuitListCount(circuit));
			result.setOrderList(ressDao.getCircuitList(circuit));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "资源模块", "查询电路", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 
	* @Title: getSlots 
	* @Description: TODO(获取时隙信息) 
	* @param @param str
	* @param @param type
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String getSlots(String portcode,String num, String type,String cond) {
		String xml = "";
		Map resultMap = new HashMap();

		Map map = new HashMap();
		map.put("portcode", portcode);
		map.put("cond", cond);
		String portrate = ressDao.getPortRateBycode(portcode);
		if (type.equalsIgnoreCase("VC4")) {//vc4
			if("ZY070101".equals(portrate)||"ZY070105".equals(portrate)){
				xml += "\n"
					+ "<slotvc4 code='1' label='VC4-1' isBranch='true' leaf='false' node='2'></slotvc4>";
			}else if("ZY070106".equals(portrate)){
				for(int i=1;i<5;i++){
					xml += "\n"
						+ "<slotvc4 code='"+i+"' label='VC4-"+i+"' isBranch='true' leaf='false' node='2'></slotvc4>";
				}
			}else if("ZY070107".equals(portrate)){
				for(int i=1;i<17;i++){
					xml += "\n"
						+ "<slotvc4 code='"+i+"' label='VC4-"+i+"' isBranch='true' leaf='false' node='2'></slotvc4>";
				}
			}else if("ZY070108".equals(portrate)){
				for(int i=1;i<65;i++){
					xml += "\n"
						+ "<slotvc4 code='"+i+"' label='VC4-"+i+"' isBranch='true' leaf='false' node='2'></slotvc4>";
				}
			}
		} else if (type.equalsIgnoreCase("VC12")) {//VC12
			if("ZY070101".equals(portrate)){
				xml += "\n"
					+ "<slotvc12 code='1' label='VC12-1' isBranch='false' leaf='true' node='3'></slotvc12>";
			}else{
				List<String> explst = this.basedao.queryForList("getSlotusedLstByPortcode", portcode);//查询已经占用的时隙列表
				if("查询".equals(cond)){
					explst = new ArrayList<String>();
				}
				int m = Integer.parseInt(num);
				int x=(m-1)*63+1;
				int y=m*63+1;
				List<String> slotlst = new ArrayList<String>();
				for(int i=x;i<y;i++){
					String data = String.valueOf(i);
					if(!explst.contains(data)){
						slotlst.add(data);
					}
				}
				for(int j=0;j<slotlst.size();j++){
					int slot = Integer.parseInt(slotlst.get(j))%63;
					if(slot==0){
						slot = 63;
					}
					xml += "\n"
						+ "<slotvc12 code='"
						+ (j+1)
						+ "' label='VC12-"
						+ slot
						+ "' isBranch='false' leaf='true' node='3' ></slotvc12>";
				}
			}
		}
		return xml;
	}

	/**
	 * 该方法用于在电路资源中添加数据
	 * 
	 * @param circuit
	 *            ：Circuit
	 * @author sunjt
	 * @return str字符串 字符串为success->添加成功 faile->添加失败
	 */
	public String addCircuit(Circuit circuit) {
		String str = "";
		try {
			circuit.setCircuitcode(circuit.getSchedulerid() + "."
					+ ressDao.getCircuitCode(circuit.getSchedulerid()));
			// 如果两个端口不在同一传输系统中，则提示端口选择不正确
			String systemcodeA = this.ressDao.getSystemCodeByPortcode(circuit
					.getPortcode1());
			String systemcodeZ = this.ressDao.getSystemCodeByPortcode(circuit
					.getPortcode2());
			if (!systemcodeA.equals(systemcodeZ)) {
				str = "faile";
			} else {
				//修改时隙
				String slot1 = circuit.getSlot1();
				String slot2 = circuit.getSlot2();
				int x = Integer.parseInt(slot1.split("_")[0].split(":")[1]);//VC4
				int y = Integer.parseInt(slot1.split("_")[1].split(":")[1]);//VC12
				circuit.setSlot1(String.valueOf((x-1)*63+y));
				int m = Integer.parseInt(slot2.split("_")[0].split(":")[1]);//VC4
				int n = Integer.parseInt(slot2.split("_")[1].split(":")[1]);//VC12
				circuit.setSlot2(String.valueOf((m-1)*63+n));
				circuit.setPortserialno1(circuit.getPortcode1());
				circuit.setPortserialno2(circuit.getPortcode2());
				ressDao.addCircuit(circuit);
				str = "success";
			}
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "电路管理模块", "添加电路资源", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			str = "faile";
		}
		return str;
	}

	public String modifyCircuit(Circuit circuit) {
		String str = "";
		try {
			//修改时隙
			String slot1 = circuit.getSlot1();
			String slot2 = circuit.getSlot2();
			int x = Integer.parseInt(slot1.split("_")[0].split(":")[1]);//VC4
			int y = Integer.parseInt(slot1.split("_")[1].split(":")[1]);//VC12
			circuit.setSlot1(String.valueOf((x-1)*63+y));
			int m = Integer.parseInt(slot2.split("_")[0].split(":")[1]);//VC4
			int n = Integer.parseInt(slot2.split("_")[1].split(":")[1]);//VC12
			circuit.setSlot2(String.valueOf((m-1)*63+n));
			circuit.setPortserialno1(circuit.getPortcode1());
			circuit.setPortserialno2(circuit.getPortcode2());
			ressDao.modifyCircuit(circuit);
			str = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("修改", "电路管理模块", "修改电路资源", "", request);

		} catch (Exception e) {
			e.printStackTrace();
			str = "fail";
		}
		return str;
	}

	/**
	 * 导出电路信息
	 * 
	 * @param circuitExportEXCEL
	 * @order by lsyu 2013-7-22
	 */
	public String circuitExportEXCEL(String labels, String[] titles,
			String types, Circuit model) {
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
		List<Circuit> circuitList = ressDao.getCircuitList(model);
		int circuitCount = ressDao.getCircuitListCount(model);
		content = new ArrayList();
		for (int i = 0; i < circuitCount; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i + 1);// 序号
			newcolmn.add(circuitList.get(i).getCircuitcode() == null ? ""
					: circuitList.get(i).getCircuitcode());
			newcolmn.add(circuitList.get(i).getUsername() == null ? ""
					: circuitList.get(i).getUsername());
			newcolmn.add(circuitList.get(i).getStation1() == null ? ""
					: circuitList.get(i).getStation1());
			newcolmn.add(circuitList.get(i).getStation2() == null ? ""
					: circuitList.get(i).getStation2());
			newcolmn.add(circuitList.get(i).getX_purpose() == null ? ""
					: circuitList.get(i).getX_purpose());
			newcolmn.add(circuitList.get(i).getPortname1() == null ? ""
					: circuitList.get(i).getPortname1());
			newcolmn.add(circuitList.get(i).getPortname2() == null ? ""
					: circuitList.get(i).getPortname2());
			newcolmn.add(circuitList.get(i).getSlot1() == null ? ""
					: circuitList.get(i).getSlot1());
			newcolmn.add(circuitList.get(i).getSlot2() == null ? ""
					: circuitList.get(i).getSlot2());
			newcolmn.add(circuitList.get(i).getRate() == null ? ""
					: circuitList.get(i).getRate());
			newcolmn.add(circuitList.get(i).getUsetime() == null ? ""
					: circuitList.get(i).getUsetime());
			content.add(newcolmn);
		}
		// if (circuitCount > 20000)// 每20000条数据写一个EXCEL
		// {
		// try {
		// RealPath = this.getRealPath();
		// zipfilePath = RealPath+ date;
		// RealPath += date + "/";
		// File f = new File(RealPath);
		// if (!f.exists()) {
		// f.mkdir();
		// }
		// List list[] = new List[circuitCount % 20000 == 0 ? circuitCount /
		// 20000 + 1
		// : circuitCount / 20000 + 2];
		// for (int i = 0; i < list.length - 1; i++) {
		// CustomizedExcel ce = new CustomizedExcel(servletConfig);
		// list[i] = content.subList(i * 20000 + 1,
		// (i + 1) * 20000 > content.size() ? content.size()
		// : (i + 1) * 20000);
		// ce.WriteExcel(RealPath + date + "-part" + i + ".xls",
		// labels, titles, list[i]);
		// }
		// } catch (Exception e) {
		// e.printStackTrace();
		// }
		// ZipExcel zip = new ZipExcel();
		// try {
		// zip.zip(zipfilePath, zipfilePath + ".zip", "");
		// } catch (Exception e) {
		// // TODO Auto-generated catch block
		// e.printStackTrace();
		// }
		// path = "exportExcel/"+ date + ".zip";
		// } else {
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
		// }

		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "资源模块", "电路导出", "", request);
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
		RealPath = fullPath.substring(0, fullPath.indexOf("WEB-INF"));// linux下的情况
		RealPath += "exportExcel/";
		return RealPath;
	}

	public String getEquip(String parentnode, String nodeid, String tree) {

		String parentID = parentnode;
		String xml;

		// 初始化电路数的第一层节点
		if (tree.equalsIgnoreCase("root")) {
			xml = executeRootForPortType();
			return xml;
		}
		// 初始化树的第二层节点
		if (tree.equalsIgnoreCase("1")) {
			xml = executeGetEquip(nodeid);
			return xml;
		}

		return null;
	}

	public String getPort(String parentnode, String nodeid, String tree) {

		String xml;

		// 初始化电路数的第一层节点
		if (tree.equalsIgnoreCase("root")) {
			xml = executeRootForPortType();
			return xml;
		}
		// 初始化树的第二层节点
		if (tree.equalsIgnoreCase("1")) {
			xml = executeGetEquipPort(nodeid);
			return xml;
		}
		// 初始化树的第三层节点（端口信息）
		if (tree.equalsIgnoreCase("2")) {
			xml = executeGetPortInfo(nodeid);
			return xml;
		}

		return null;
	}

	public String executeRootForPortType() {
		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		String xml = "";
		try {
			String sql = "select t.systemcode, t.sysname from transsystem t";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);

			while (rs.next()) {
				xml += "<folder state='0' label='"
						+ rs.getString("sysname")
						+ "' id='"
						+ rs.getString("systemcode")
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

	public String executeGetEquip(String systemcode) {
		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		String xml = "";
		try {
			String sql = "select e.equipcode,e.s_sbmc from re_sys_equip re,equipment e where e.equipcode = re.equipcode and re.systemcode = '"
					+ systemcode + "' order by e.s_sbmc";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);

			while (rs.next()) {
				xml += "<folder state='0' label='"
						+ rs.getString("s_sbmc")
						+ "' id='"
						+ rs.getString("equipcode")
						+ "' disabled=\"true\"  isBranch=\"false\" leaf='true'>";
				xml += "</folder>";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.closeConnection(c, s, rs);
		}

		return xml;
	}

	public String executeGetEquipPort(String systemcode) {
		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		String xml = "";
		try {
			String sql = "select e.equipcode,e.s_sbmc from re_sys_equip re,equipment e where e.equipcode = re.equipcode and re.systemcode = '"
					+ systemcode + "' order by e.s_sbmc";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);

			while (rs.next()) {
				xml += "<folder state='0' label='"
						+ rs.getString("s_sbmc")
						+ "' id='"
						+ rs.getString("equipcode")
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

	public String executeGetPortInfo(String equipCode) {

		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		String xml = "";
		try {
			String sql = "select p.logicport,p.slotserial||'槽-'||p.portserial||'端口' as portname from equiplogicport p where p.equipcode = '"
					+ equipCode + "' order by p.slotserial||p.portserial";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);

			while (rs.next()) {
				xml += "<folder state='0' label='"
						+ rs.getString("portname")
						+ "' id='"
						+ rs.getString("logicport")
						+ "' disabled=\"true\"  isBranch=\"false\" leaf='true' >";
				xml += "</folder>";

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.closeConnection(c, s, rs);
		}

		return xml;
	}

	/**
	 * 获取站点列表
	 * 
	 * @return
	 */
	public String getStation() {
		List<ComboxDataModel> list = ressDao.getStationList();
		String result = getComboxDataModel(list);
		return result;
	}

	/**
	 * 获取业务类型列表
	 * 
	 * @return
	 */
	public String getX_purposeList() {
		List<ComboxDataModel> list = ressDao.getX_purposeList();
		String result = getComboxDataModel(list);
		return result;
	}

	/**
	 * 获取速率列表
	 * 
	 * @return
	 */
	public String getRateList() {
		List<ComboxDataModel> list = ressDao.getRateList();
		String result = getComboxDataModel(list);
		return result;
	}

	public String getComboxDataModel(List<ComboxDataModel> list) {
		String result = "";
		for (ComboxDataModel data : list) {
			result += "<name label='" + data.getLabel() + "'  code='"
					+ data.getId() + "'/>";
		}
		return result;
	}

	/**
	 * 该方法用于查询电路业务关系的数据
	 * 
	 * @param model
	 *            ：CircuitBusinessModel
	 * @author lsyu
	 * @return
	 */
	public ResultModel getCircuitBusiness(CircuitBusinessModel circuitbusiness) {
		ResultModel remodel = new ResultModel();

		try {
			remodel.setTotalCount(this.ressDao
					.getCircuitBusinessCount(circuitbusiness));
			remodel.setOrderList(this.ressDao
					.getCircuitBusinessList(circuitbusiness));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "资源管理模块", "查询电路业务关系", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return remodel;

	}

	public String addCircuitBusiness(CircuitBusinessModel circuitbusiness) {
		String str = "";
		try {
			// 判断是否已经存在
			ressDao.addCircuitBusiness(circuitbusiness);
			str = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "电路业务关系模块", "添加电路业务关系", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			str = "faile";
		}
		return str;
	}

	/**
	 * 根据查询条件取得业务名称和业务id
	 * 
	 * @param searchTexts
	 * @return
	 */
	public String getBusinessBySearchText(String searchTexts) {
		StringBuffer result = new StringBuffer();
		Map map = new HashMap();
		map.put("searchtext", searchTexts);
		List<ComboxDataModel> list = ressDao.getBusinessBySearchText(map);
		int i = 0;
		for (ComboxDataModel data : list) {
			i++;
			// if(i>3030){
			// break;
			// }
			// 当data数据中含双引号和反斜杠的时候，拼接会出错
			result.append("<equip id=\""
					+ data.getId()
					+ "\"label=\""
					+ data.getLabel().replaceAll("\\\\", "\\\\\\\\")
							.replaceAll("\"", "\'")
					+ "\" name=\"equip\" isBranch=\"false\"></equip>");
		}
		// System.out.println("--"+result);
		// ResultModel model = new ResultModel();
		// model.setOrderList(list);
		return result.toString();
	}

	/**
	 * 根据查询条件取得业务名称和业务id
	 * 
	 * @param searchTexts
	 * @return
	 */
	public String getBusinessIdBySearchText(String searchTexts) {
		String result = "";
		Map map = new HashMap();
		map.put("searchtext", searchTexts);
		List<ComboxDataModel> list = ressDao.getBusinessIdBySearchText(map);
		for (ComboxDataModel data : list) {
			result += "<business id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\" name=\"business\" isBranch=\"false\"></business>";
		}

		return result;
	}

	/**
	 * 判断所选端口时隙上是否存在电路 checkPortAndSlotHasCircuit
	 * 
	 * @author xgyin
	 */
	public String checkPortAndSlotHasCircuit(String rate, String portcode,
			String slot, String flag, String circuitcode) {
		String result = "";
		String str = "fail";
		Map<String, String> map = new HashMap<String, String>();
		map.put("rate", rate);
		map.put("portcode", portcode);
		map.put("slot", slot);
		if (circuitcode == null) {
			circuitcode = "";
		}
		map.put("circuitcode", circuitcode);
		List<String> lst = this.ressDao.getCircuitByMapA(map);
		if (lst.size() > 0) {
			str = "SUCCESS";
		}

		result = str + ";" + rate;
		return result;
	}

	/**
	 * 修改电路业务关系表
	 * 
	 * @param circuitbusiness
	 * @return
	 */
	public String modifyCircuitBusiness(CircuitBusinessModel circuitbusiness) {
		String str = "";
		try {
			ressDao.modifyCircuitBusiness(circuitbusiness);
			str = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("修改", "电路业务关系模块", "修改电路业务关系表", "", request);

		} catch (Exception e) {
			e.printStackTrace();
			str = "fail";
		}
		return str;
	}

	public String deleteCircuitBusiness(CircuitBusinessModel circuitbusiness) {
		boolean flag = false;
		Map map = new HashMap();
		map.put("business_id", circuitbusiness.getBusiness_id());
		map.put("circuitcode", circuitbusiness.getCircuitcode());

		try {
			flag = ressDao.deleteCircuitBusiness(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (flag == true) {
			return "success";
		} else {
			return "fail";
		}
	}

	/**
	 * 导出电路业务关系表
	 * 
	 * @author lsyu 2013-09-22
	 * @param labels
	 * @param titles
	 * @param types
	 * @param model
	 * @return
	 */
	public String circuitBusinessExportEXCEL(String labels, String[] titles,
			String types, CircuitBusinessModel model) {
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
		List<CircuitBusinessModel> circuitBusinessList = ressDao
				.getCircuitBusinessList(model);
		int businessCount = ressDao.getCircuitBusinessCount(model);
		content = new ArrayList();
		for (int i = 0; i < businessCount; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i + 1);// 序号
			// newcolmn.add(circuitBusinessList.get(i).getBusiness_id() == null
			// ? ""
			// : circuitBusinessList.get(i).getBusiness_id());
			// newcolmn.add(circuitBusinessList.get(i).getCircuitcode() == null
			// ? ""
			// : circuitBusinessList.get(i).getCircuitcode());
			newcolmn
					.add(circuitBusinessList.get(i).getBusiness_name() == null ? ""
							: circuitBusinessList.get(i).getBusiness_name());
			newcolmn.add(circuitBusinessList.get(i).getUsername() == null ? ""
					: circuitBusinessList.get(i).getUsername());
			newcolmn
					.add(circuitBusinessList.get(i).getUpdateperson() == null ? ""
							: circuitBusinessList.get(i).getUpdateperson());
			content.add(newcolmn);
		}
		// if (businessCount > 20000)// 每20000条数据写一个EXCEL
		// {
		// try {
		// RealPath = this.getRealPath();
		// zipfilePath = RealPath+ date;
		// RealPath += date + "/";
		// File f = new File(RealPath);
		// if (!f.exists()) {
		// f.mkdir();
		// }
		// List list[] = new List[businessCount % 20000 == 0 ? businessCount /
		// 20000 + 1
		// : businessCount / 20000 + 2];
		// for (int i = 0; i < list.length - 1; i++) {
		// CustomizedExcel ce = new CustomizedExcel(servletConfig);
		// list[i] = content.subList(i * 20000 + 1,
		// (i + 1) * 20000 > content.size() ? content.size()
		// : (i + 1) * 20000);
		// ce.WriteExcel(RealPath + date + "-part" + i + ".xls",
		// labels, titles, list[i]);
		// }
		// } catch (Exception e) {
		// e.printStackTrace();
		// }
		// ZipExcel zip = new ZipExcel();
		// try {
		// zip.zip(zipfilePath, zipfilePath + ".zip", "");
		// } catch (Exception e) {
		// // TODO Auto-generated catch block
		// e.printStackTrace();
		// }
		// path = "exportExcel/"+ date + ".zip";
		// } else {
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
		// }

		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "资源模块", "电路业务关系导出", "", request);
		return path;
	}

	// 查询circuit表 @jxch
	public ResultModel MygetCircuit(Circuit circuit) {
		ResultModel result = new ResultModel();
		// System.out.println("我进来啦啦啦啦啦啦啦啦啦啦啦啦啦！！！！！！！！！");
		try {
			result.setOrderList(ressDao.MygetCircuitList(circuit));
			result.setTotalCount(ressDao.MygetCircuitListCount(circuit));

			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "资源模块", "查询circuit", "", request);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 查询业务数量 @jxch
	public ResultModel MygetRess(BusinessRessModel model) {
		ResultModel remodel = new ResultModel();
		remodel.setTotalCount(this.ressDao.getRessCount(model));
		remodel.setOrderList(null);
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "方式管理模块", "查询业务数量", "", request);
		return remodel;

	}

	public String getSlotALstByPortcode(String portcode) {
		String result = "";
		// 1、查找端口速率一共多少个VC12，2、查找去掉有业务的时隙，3、如果端口速率为2M，则时隙为1
		// 不考虑VC4整个建交叉
		// List<ComboxDataModel> list = this.ressDao
		// .getSlotALstByPortcode(portcode);
		// for (ComboxDataModel data : list) {
		// result += "<slot1 id=\"" + data.getId() + "\"label=\""
		// + data.getLabel()
		// + "\" name=\"slot1\" isBranch=\"false\"></slot1>";
		// }
		LogicPort port = (LogicPort) basedao.queryForObject(
				"getLogicPortInfos", portcode);
		result = port.getX_capability();
		return result;
	}

	public String getSlotZLstByPortcode(String portcodeA, String portcodeB) {
		String result = "";
		Map map = new HashMap();
		map.put("portcodeA", portcodeA);
		map.put("portcodeB", portcodeB);
		List<ComboxDataModel> list = this.ressDao.getSlotZLstByPortcode(map);
		for (ComboxDataModel data : list) {
			result += "<slot2 id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"slot2\" isBranch=\"false\"></slot2>";
		}
		return result;
	}

	public int getUnusedCCCount() {
		int i = 0;
		i = ressDao.getUnusedCCCount();
		return i;
	}

	public String deleteUnusedCC() {
		boolean flag = false;

		try {
			flag = ressDao.deleteUnusedCC();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (flag == true) {
			return "success";
		} else {
			return "fail";
		}
	}

	public String getPortByRate(String parentnode, String nodeid, String tree,
			String rate) {

		String xml;

		// 初始化电路数的第一层节点
		if (tree.equalsIgnoreCase("root")) {
			xml = executeRootForPortType();
			return xml;
		}
		// 初始化树的第二层节点
		if (tree.equalsIgnoreCase("1")) {
			xml = executeGetEquipPort(nodeid);
			return xml;
		}
		// 初始化树的第三层节点（端口信息）
		if (tree.equalsIgnoreCase("2")) {
			xml = executeGetPortInfoByRate(parentnode,nodeid, rate);
			return xml;
		}

		return null;
	}

	public String executeGetPortInfoByRate(String flag,String equipCode, String rate) {

		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		String xml = "";
		String sql = "";
		try {
			if("查询".equals(flag)){
				sql = "select p.logicport,p.frameserial||'框-'||p.slotserial||'槽-'||getpackmodelbylogicport(p.logicport)||'-'||p.portserial||'端口' as portname from equiplogicport p where p.equipcode = '"
					+ equipCode+"'";
			}else{
				sql = "select p.logicport,p.frameserial||'框-'||p.slotserial||'槽-'||getpackmodelbylogicport(p.logicport)||'-'||p.portserial||'端口' as portname from equiplogicport p where p.equipcode = '"
					+ equipCode
					+ "' and p.logicport not in ( select distinct c.tp_id_a from circuit_cc c ,equiplogicport t where c.equipcode ='"
					+ equipCode
					+ "' and  t.x_capability='ZY070101' and t.logicport = c.tp_id_a and t.equipcode=c.equipcode"
					+ " union"
					+ " select distinct c.tp_id_z from circuit_cc c ,equiplogicport t where c.equipcode ='"
					+ equipCode
					+ "' and t.x_capability='ZY070101' and t.logicport = c.tp_id_z and t.equipcode=c.equipcode)";
			}
			sql += "order by to_number(p.frameserial),to_number(p.slotserial),to_number(p.portserial)";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);

			while (rs.next()) {
				xml += "<folder state='0' label='"
						+ rs.getString("portname")
						+ "' id='"
						+ rs.getString("logicport")
						+ "' disabled=\"true\"  isBranch=\"false\" leaf='true' >";
				xml += "</folder>";

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.closeConnection(c, s, rs);
		}

		return xml;
	}

	/**
	 * 该方法用于查询通道列表数据
	 * 
	 * @param model
	 *            ：CircuitBusinessModel
	 * @author lsyu
	 * @return
	 */
	public ResultModel getAllChannelList(CircuitChannel model) {
		ResultModel remodel = new ResultModel();

		try {
			remodel.setTotalCount(this.ressDao.getCircuitChannelCount(model));
			remodel.setOrderList(this.ressDao.getCircuitChannelList(model));
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "资源管理模块", "查询通道列表", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return remodel;

	}

	// 资源同步---全部同步
	public String resourceAllSync() {
		String result = "failed";
		try {
			VerticallyImpl impl = VerticallyImpl.getInstance();

			factory = Persistence.createEntityManagerFactory(PERSIST_UNIT);

			String namespace = "http://tempuri.org/";
			String endpoint = "http://10.124.18.68/fzjk/WebService.asmx?wsdl";
			String receiver = "010102";

			List<Condition> list = new ArrayList<Condition>();
			Condition con = new Condition();
			con.setVar_0("1142220");
			con.setVar_1("4045");

			impl.SynSDataSite(namespace, endpoint, receiver, list);
			impl.RequestGetequipment(namespace, endpoint, receiver, list);
			List<Condition> equipList2 = new ArrayList<Condition>();
			equipList2 = DBHelper.queryEquipmentODF(factory);
			for (int i = 0; i < equipList2.size(); i++) {
				List<Condition> list2 = new ArrayList<Condition>();
				Condition con2 = (Condition) equipList2.get(i);
				list2.add(con2);

				impl.RequestGetequipframe(namespace, endpoint, receiver, list2);
				impl.RequestGetequipslot(namespace, endpoint, receiver, list2);
				impl.RequestGetequippack(namespace, endpoint, receiver, list2);
				impl.RequestGetequiplogicport(namespace, endpoint, receiver,
						list2);
				impl.RequestGetequipcc(namespace, endpoint, receiver, list2);
				impl.SynCiruit(namespace, endpoint, receiver, list2);
			}
			impl.RequestGettopolink(namespace, endpoint, receiver, list);
			impl.SynEnOcable(namespace, endpoint, receiver, list);
			List<Condition> ocableList = DBHelper.queryOcable(factory);
			for (int i = 0; i < ocableList.size(); i++) {
				List<Condition> list2 = new ArrayList<Condition>();
				Condition con2 = (Condition) ocableList.get(i);
				list2.add(con2);
				impl.SynEnfiber(namespace, endpoint, receiver, list2);
			}
			impl.SynBuss(namespace, endpoint, receiver, list);
			impl.SynCircuitBuss(namespace, endpoint, receiver, list);
			impl.SynOPTICAL(namespace, endpoint, receiver, list);

			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("资源手工同步", "资源管理模块", "全部资源同步", "", request);

			result = "SUCCESS";
		} catch (Exception e) {
			result = "failed";
		}
		return result;
	}

	// 资源同步---增量同步
	public String resourceSync(String resStr, String start, String end) {
		String result = "failed";
		try {
			String[] arr;
			if (resStr.indexOf(";") != -1) {
				arr = resStr.split(";");
			} else {
				arr = new String[] { resStr };
			}
			List<String> lst = new ArrayList<String>();
			for (int i = 0; i < arr.length; i++) {
				if (!lst.contains(arr[i])) {
					lst.add(arr[i]);
				}
			}
			if (lst.size() == 0) {
				return "failed";
			}
			VerticallyImpl impl = VerticallyImpl.getInstance();

			factory = Persistence.createEntityManagerFactory(PERSIST_UNIT);

			String namespace = "http://tempuri.org/";
			String endpoint = "http://10.124.18.68/fzjk/WebService.asmx?wsdl";
			String receiver = "010102";

			List<Condition> list = new ArrayList<Condition>();
			Condition con = new Condition();
			con.setVar_0("1142220");
			con.setVar_1("4045");
			con.setVar_4("增量");
			con.setVar_5(start);
			con.setVar_6(end);
			list.add(con);
			//		    
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");

			if (lst.contains("站点")) {
				// System.out.println("---站点");
				impl.SynSDataSite(namespace, endpoint, receiver, list);
				logDao.createLogEvent("资源手工同步", "资源管理模块", "站点同步", "", request);
			}
			List<Condition> equipList2 = new ArrayList<Condition>();
			if (lst.contains("设备")) {
				// System.out.println("---设备");
				impl.RequestGetequipment(namespace, endpoint, receiver, list);
				impl.synEquipmentXY(namespace, endpoint, receiver, list);
				equipList2 = DBHelper.queryEquipmentODF(factory);
				DBHelper.updateEquipmentXy(factory);
				logDao.createLogEvent("资源手工同步", "资源管理模块", "设备同步", "", request);
			}
			
			for (int i = 0; i < equipList2.size(); i++) {
				List<Condition> list2 = new ArrayList<Condition>();
				Condition con2 = (Condition) equipList2.get(i);
				con2.setVar_4("增量");
				con2.setVar_5(start);
				con2.setVar_6(end);
				list2.add(con2);

				if (lst.contains("机框")) {
					// System.out.println("---机框");
					impl.RequestGetequipframe(namespace, endpoint, receiver,
							list2);
				}
				if (lst.contains("机槽")) {
					// System.out.println("---机槽");
					impl.RequestGetequipslot(namespace, endpoint, receiver,
							list2);
				}
				if (lst.contains("机盘")) {
					// System.out.println("---机盘");
					impl.RequestGetequippack(namespace, endpoint, receiver,
							list2);
				}
				if (lst.contains("端口")) {
					// System.out.println("---端口");
					impl.RequestGetequiplogicport(namespace, endpoint,
							receiver, list2);
				}
				if (lst.contains("交叉")) {
					// System.out.println("---交叉");
					impl
							.RequestGetequipcc(namespace, endpoint, receiver,
									list2);
				}
				if (lst.contains("电路")) {
					impl.SynCiruit(namespace, endpoint, receiver, list2);
				}
			}
			if (lst.contains("机框")) {
				logDao.createLogEvent("资源手工同步", "资源管理模块", "机框同步", "", request);
			}
			if (lst.contains("机槽")) {
				logDao.createLogEvent("资源手工同步", "资源管理模块", "机槽同步", "", request);
			}
			if (lst.contains("机盘")) {
				logDao.createLogEvent("资源手工同步", "资源管理模块", "机盘同步", "", request);
			}
			if (lst.contains("端口")) {
				logDao.createLogEvent("资源手工同步", "资源管理模块", "端口同步", "", request);
			}
			if (lst.contains("交叉")) {
				logDao.createLogEvent("资源手工同步", "资源管理模块", "交叉同步", "", request);
			}
			if (lst.contains("电路")) {
				logDao.createLogEvent("资源手工同步", "资源管理模块", "电路同步", "", request);
				// 修改电路主备路径字段
				this.modifyCircuitInfo();
			}

			if (lst.contains("复用段")) {
				// System.out.println("---复用段");
				impl.RequestGettopolink(namespace, endpoint, receiver, list);
				logDao.createLogEvent("资源手工同步", "资源管理模块", "复用段同步", "", request);
			}

			if (lst.contains("光缆")) {
				// System.out.println("---光缆");
				impl.SynEnOcable(namespace, endpoint, receiver, list);
				logDao.createLogEvent("资源手工同步", "资源管理模块", "光缆同步", "", request);
			}
			if (lst.contains("光纤")) {
				List<Condition> ocableList = DBHelper.queryOcable(factory);
				for (int i = 0; i < ocableList.size(); i++) {
					List<Condition> list2 = new ArrayList<Condition>();
					Condition con2 = (Condition) ocableList.get(i);
					con2.setVar_4("增量");
					con2.setVar_5(start);
					con2.setVar_6(end);
					list2.add(con2);
					impl.SynEnfiber(namespace, endpoint, receiver, list2);
				}
				// 同步光路
				impl.SynOPTICAL(namespace, endpoint, receiver, list);
				// 同步光路复用段关系
				impl.synTopoLinkOptical(namespace, endpoint, receiver, list);
				logDao.createLogEvent("资源手工同步", "资源管理模块", "光纤同步", "", request);
				logDao.createLogEvent("资源手工同步", "资源管理模块", "光路同步", "", request);
				logDao.createLogEvent("资源手工同步", "资源管理模块", "光路与复用段关系", "",
						request);
			}
			
			if (lst.contains("业务")) {
				// System.out.println("---业务");
				impl.SynBuss(namespace, endpoint, receiver, list);
				logDao.createLogEvent("资源手工同步", "资源管理模块", "业务同步", "", request);
			}
			if (lst.contains("电路业务关系")) {
				// System.out.println("---电路业务关系");
				impl.SynCircuitBuss(namespace, endpoint, receiver, list);
				logDao.createLogEvent("资源手工同步", "资源管理模块", "电路业务关系同步", "",
						request);
			}
			result = "SUCCESS";
		} catch (Exception e) {
			result = "failed";
		}

		return result;
	}

	// 有重复
	public void modifyCircuitInfo() {
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		SceneMgrDAO sceneMgrDao = (SceneMgrDAO) ctx.getBean("sceneMgrDao");
		List<String> codelst = sceneMgrDao.getAllCircuitCode();
		for (int a = 0; a < codelst.size(); a++) {
			String circuitcode = codelst.get(a);
			// 查找设备
//			 String circuitcode="65961";
			Circuit key = sceneMgrDao.getCircuitByCircuitcode1(circuitcode);
			Circuit key1 = (Circuit) sceneMgrDao.getCircuitInfoBycode(circuitcode);
			String startEquip = key.getPortcode1();
			String endEquip = key.getPortcode2();
			if (!"".equals(startEquip) && startEquip != null
					&& !"".equals(endEquip) && endEquip != null) {
				Map paraMap = new HashMap();
				paraMap.put("v_name", circuitcode);
				paraMap.put("logicport", key1.getPortcode1());
				paraMap.put("vc", "VC12");
                paraMap.put("slot", key1.getSlot1());
                sceneMgrDao.deleteCircuitRoutByCircuitcode(paraMap);
                sceneMgrDao.insertcallRouteGenerate(paraMap);
		        
				List<CircuitroutModel> routlst = sceneMgrDao
						.selectCircuitroutLstByCircuitcode(circuitcode);
				List<Integer> lst = new ArrayList<Integer>();// 发散端点
				List<String> equiplst = new ArrayList<String>();// 设备编码发
				List<String> equipAll = new ArrayList<String>();
				for (int i = 0; i < routlst.size(); i++) {
					for (int j = i + 1; j < routlst.size(); j++) {
						if (routlst.get(i).getA_portcode().equals(
								routlst.get(j).getA_portcode())
								&& routlst.get(i).getA_slot().equals(
										routlst.get(j).getA_slot())) {
							// 说明有2条或以上路由
							if (!equiplst.contains(routlst.get(j)
									.getEquipcode())) {
								equiplst.add(routlst.get(j).getEquipcode());
								lst.add(i);
								lst.add(j);
								break;
							}

						}
					}
					if (!equipAll.contains(routlst.get(i).getEquipcode())) {
						equipAll.add(routlst.get(i).getEquipcode());
					}
				}
				String path = ""; // 主用路由
				String remark = "";// 备用路由
				String pathcode = "";
				String remarkcode = "";
				if (lst.size() == 0) {
					// 只有一条路径的情况
					for (int i = 0; i < routlst.size(); i++) {
						if (!path.contains(routlst.get(i).getEquipname())) {
							path += routlst.get(i).getEquipname() + "->";
							pathcode += routlst.get(i).getEquipcode() + "->";
						}
					}
				} else {
					// 查找起止端设备
					int m = 0;
					int x = 0;
					int y = 0;
					for (int q = 0; q < routlst.size(); q++) {
						if (!startEquip.equals(routlst.get(q).getEquipcode())) {
							continue;
						} else {
							x = q;
							break;
						}
					}
					for (int w = 0; w < routlst.size(); w++) {
						if (!endEquip.equals(routlst.get(w).getEquipcode())) {
							continue;
						} else {
							y = w;
							break;
						}
					}
					if (x > y) {// 从尾端开始串
						for (int p = y; p < x + 1; p++) {
							if (!path.contains(routlst.get(p).getEquipname())) {
								path += routlst.get(p).getEquipname() + "->";
								pathcode += routlst.get(p).getEquipcode()
										+ "->";
							}
						}
						for (int s = x + 1; s < routlst.size(); s++) {
							if (!remark.contains(routlst.get(s).getEquipname())) {
								remark += routlst.get(s).getEquipname() + "->";
								remarkcode += routlst.get(s).getEquipcode()
										+ "->";
							}
						}
						for (int j = 0; j < y; j++) {
							if (!remark.contains(routlst.get(j).getEquipname())) {
								remark += routlst.get(j).getEquipname() + "->";
								remarkcode += routlst.get(j).getEquipcode()
										+ "->";
							}
						}
						if(!remarkcode.contains(startEquip)){
							remarkcode += startEquip+"->";
						}
						if(!remarkcode.contains(endEquip)){
							remarkcode += endEquip+"->";
						}
							
					} else if(x<y) {// 从开始端开始串
						for (int p = x; p < routlst.size(); p++) {
							if (!endEquip.equals(routlst.get(p).getEquipcode())) {
								if (!path.contains(routlst.get(p)
										.getEquipname())) {
									path += routlst.get(p).getEquipname()
											+ "->";
									pathcode += routlst.get(p).getEquipcode()
											+ "->";
								}
							} else {
								m = p;
								break;
							}
						}
						if (m == 0) {
							m = routlst.size() - 1;
						}
						if (endEquip.equals(routlst.get(m).getEquipcode())) {
							path += routlst.get(m).getEquipname() + "->";
							pathcode += routlst.get(m).getEquipcode() + "->";
							int n = 0;
							for (int t = m; t < routlst.size(); t++) {
								if (!startEquip.equals(routlst.get(t)
										.getEquipcode())) {
									continue;
								} else {
									n = t;
									break;
								}
							}
							for (int j = n; j < routlst.size(); j++) {
								if (!remark.contains(routlst.get(j)
										.getEquipname())) {
									remark += routlst.get(j).getEquipname()
											+ "->";
									remarkcode += routlst.get(j).getEquipcode()
											+ "->";
								}
							}
							if (n > m + 1) {
								for (int l = m + 1; l < n; l++) {
									if (!remark.contains(routlst.get(l)
											.getEquipname())) {
										remark += routlst.get(l).getEquipname()
												+ "->";
										remarkcode += routlst.get(l)
												.getEquipcode()
												+ "->";
									}

								}
							}
							if (!remark.contains(routlst.get(m).getEquipname())) {
								remark += routlst.get(m).getEquipname() + "->";
								remarkcode += routlst.get(m).getEquipcode()
										+ "->";
							}
						} else {
							// 只考虑主路由，
							remarkcode = startEquip + "->" + endEquip + "->";
							for (int o = 0; o < lst.get(o); o = o + 2) {
								if (!remarkcode.contains(routlst
										.get(lst.get(o)).getEquipcode())) {
									remarkcode += routlst.get(lst.get(o))
											.getEquipcode()
											+ "->";
								}
							}
							int z = 0;
							for (int e = 0; e < x; e++) {
								if (!endEquip.equals(routlst.get(e)
										.getEquipcode())) {
									if (!path.contains(routlst.get(e)
											.getEquipname())) {
										path += routlst.get(e).getEquipname()
												+ "->";
										pathcode += routlst.get(e)
												.getEquipcode()
												+ "->";
									}
								} else {
									z = e;
									break;
								}
							}
							if (!pathcode.contains(endEquip)) {
								path += routlst.get(z).getEquipname() + "->";
								pathcode += endEquip + "->";
							}
							int k = 0;
							for (int s = z + 1; s < x; s++) {
								if (!startEquip.equals(routlst.get(s)
										.getEquipcode())) {
									continue;
								} else {
									k = s;
									break;
								}
							}
							if (k > 0) {
								for (int i = k; i < x; i++) {
									// 备用
									if (!remark.contains(routlst.get(i)
											.getEquipname())) {
										remark += routlst.get(i).getEquipname()
												+ "->";
										remarkcode += routlst.get(i)
												.getEquipcode()
												+ "->";
									}
								}
							}
						}
					}else{
						
					}
				}

				if (path.length() > 0) {
					path = path.substring(0, path.length() - 2);
					pathcode = pathcode.substring(0, pathcode.length() - 2);
				}
				if (remark.length() > 0) {
					remark = remark.substring(0, remark.length() - 2);
					remarkcode = remarkcode.substring(0,
							remarkcode.length() - 2);
				}
				// 修改电路表中，主备字段
				Map map = new HashMap();
				map.put("path", path);
				map.put("remark", remark);
				map.put("circuitcode", circuitcode);
				sceneMgrDao.updateCircuitRouteByMap(map);

				// 修改circuit_equipment_cnt中的数据，根据主备字段
				if(pathcode.indexOf("->")!=-1){
					String path1[] = pathcode.split("->");
					String codes = "",equips="";
					Map mp = new HashMap();
					mp.put("circuitcode", circuitcode);
					mp.put("equipcode", pathcode);
					if (!"".equals(remark)) {
						String remark1[] = remarkcode.split("->");
						List<String> remarklst = new ArrayList<String>();
						for (int r = 0; r < remark1.length; r++) {
							for (int h = 0; h < path1.length; h++) {
								if (remark1[r].equals(path1[h])
										&& !remarklst.contains(path1[h])) {
									remarklst.add(path1[h]);
									equipAll.remove(path1[h]);
								}
							}
						}
						for (int j = 0; j < remarklst.size()-1; j++) {
							codes += remarklst.get(j)+"->";
						}
						if(codes.length()>1){
							codes = codes.substring(0, codes.length() - 2);
						}
						for (int m = 0; m < equipAll.size(); m++) {
							equips +=equipAll.get(m)+"->";
						}
						if(equips.length()>1){
							equips = equips.substring(0, equips.length() - 2);
						}
					}
					mp.put("equipcode1", codes);//备用
					mp.put("equipcode2", equips);//主
					this.basedao.queryForList("insertCircuit_equipment_cnt", mp);
				}
			}
		}
	}

}
