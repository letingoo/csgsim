package resManager.resNode.dwr;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import jxl.write.WriteException;
import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ExportExcel;
import netres.component.ExcelOperation.ZipExcel;
import netres.component.Validators.NetresdataValidator;
import netres.model.ComboxDataModel;
import resManager.resNode.model.EquipFrame;
import resManager.resNode.model.FrameSlot;
import netres.model.ResultModel;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import resManager.resNode.dao.ResNodeDao;
import resManager.resNode.model.EquipPack;
import resManager.resNode.model.FiberModel;
import resManager.resNode.model.OcableModel;
import resManager.resNode.model.StationModel;
import resManager.resNode.model.testframe;
import sysManager.log.dao.LogDao;
import sysManager.user.model.UserModel;
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
public class ResNodeDwr  extends NetresdataValidator {
	
	private final static Log log = LogFactory.getLog(ResNodeDwr.class);
	ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
	private DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");//用于 jdbc
	private ResNodeDao resNodeDao;
	

	public ResNodeDao getResNodeDao() {
		return resNodeDao;
	}
	public void setResNodeDao(ResNodeDao resNodeDao) {
		this.resNodeDao = resNodeDao;
	}
	/**
	 * 
	* @Title: getSortData 
	* @Description: TODO(此函数用于向前台返回点击Flex中DATAGRID的HEADERTEXT进行排序的功能。) 
	* @param @param info:按info变量的值所代表的字段进行排序；
	* @param @param panel:用户操作的台帐中的哪种资源
	* @param @param obj:资源的实例对象
	* @param @return    设定文件 
	* @return ResultModel    返回类型 
	* @throws
	 */
	public ResultModel getSortData(String info, String panel, Object obj) {
		ResultModel result = new ResultModel();
		if (panel.equals("Station")) {
			result = this.getStation((StationModel) obj);
		}else if (panel.equals("Ocable")) {
			result = this.getOcables((OcableModel) obj);
		} 
		return result;
	}
	//=====================================================================================================
	//============================    站点	    start			===========================================
	//=====================================================================================================
	/**
	 * 此函数用于向前台返回局站的数据信息。
	 * 
	 * @param station
	 *            :StationModel类型的对象
	 * @return 返回ResultModel类型的数据。
	 * @author mawj
	 * @version ver.1.0
	 * 
	 * */
	public ResultModel getStation(StationModel station) {
		ResultModel result = new ResultModel();
		try{
		result.setTotalCount(resNodeDao.getStationCount(station));
		result.setOrderList(resNodeDao.getStation(station));
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "资源模块", "查询站点", "", request);
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}


	/**
	 * 此函数用于删除数据库中局站的数据信息。
	 * 
	 * @param station
	 *            :StationModel类型的对象
	 * @return str:其值可能为2种：1.success->说明成功的删除了数据。2.failed->说明删除数据失败。
	 * @author mawj
	 * @version ver.1.0
	 * 
	 * */
	public String delStation(StationModel station) {
		String str = null;
		try {
			if (resNodeDao.delStation(station.getStationcode()) > 0) {
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "资源模块", "删除站点", "", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}
		return str;
	}
	/**
	 * 
	* @Title: getStationType 
	* @Description: TODO(获取站点类型) 
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String getStationType() {
		String result = "";
		List<ComboxDataModel> lst = resNodeDao.getStationType();
		for (ComboxDataModel data : lst) {
			result += "<x_stationtype id=\""
					+ data.getId()
					+ "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"x_stationtype\"  isBranch=\"false\"></x_stationtype>";
		}
		return result;
	}
	/**
	 * 
	* @Title: getFromXTBM 
	* @Description: TODO(通过xtbm获取列表) 
	* @param @param xtbm
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String getFromXTBM(String xtbm){
		return resNodeDao.getFromXTBM(xtbm);
	}
	
	/**
	 * 获取电压数值类型
	 * @param str
	 * @param type
	 * @return String
	 */
	public String getVoltType(){
		StringBuilder sbVoltTypeXml = new StringBuilder();
		List<ComboxDataModel> lstVoltType = resNodeDao.getVoltValue();
		for(ComboxDataModel model: lstVoltType){
			sbVoltTypeXml.append("<volt id=\"")
			             .append(model.getId())
			             .append("\" label=\"")
			             .append(model.getLabel())
			             .append("\" ")
			             .append("name=\"volt\" isBranch=\"false\">")
			             .append("</volt>");
		}
		return sbVoltTypeXml.toString();
	}
	
	/**
	 * 
	* @Title: updateStationNameStd 
	* @Description: TODO(更新站点标准命名) 
	* @param @param stationcode    设定文件 
	* @return void    返回类型 
	* @throws
	 */
	public void updateStationNameStd(String stationcode){
		try{
			resNodeDao.updateStationNameStd(stationcode);
		}catch(Exception e){
			log.error("update name_std of station : " + e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * 导出Excel的函数
	 * 
	 * luoshuai labels :Excel文件表头 titles: 栏目名 types:导出excel类型
	 * */
	public String StationExportEXCEL(String labels, String[] titles,
			String types,StationModel model) {
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
		List<StationModel> stationList=resNodeDao.getStation(model);
		int StationCoutnt = resNodeDao.getStationCount(model);
		content = new ArrayList();
		for (int i = 0; i < StationCoutnt; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i+1);//序号
			newcolmn.add(stationList.get(i).getStationname() == null? "":stationList.get(i).getStationname());
			newcolmn.add(stationList.get(i).getProvince() == null? "":stationList.get(i).getProvince());
			newcolmn.add(stationList.get(i).getX_stationtype() == null? "":stationList.get(i).getX_stationtype());
			newcolmn.add(stationList.get(i).getVolt() == null? "":stationList.get(i).getVolt());
			newcolmn.add(stationList.get(i).getLng() == null? "":stationList.get(i).getLng());
			newcolmn.add(stationList.get(i).getLat()==null?"":stationList.get(i).getLat());
			newcolmn.add(stationList.get(i).getFounddate() == null? "":stationList.get(i).getFounddate());
			content.add(newcolmn);
		}
//		if (StationCoutnt > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[StationCoutnt % 20000 == 0 ? StationCoutnt / 20000 + 1
//						: StationCoutnt / 20000 + 2];
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
		logDao.createLogEvent("导出", "资源模块", "站点导出", "", request);
		return path;
	}
	//=====================================================================================================
	//============================    站点	    end				===========================================
	//=====================================================================================================
	
	//=====================================================================================================
	//============================    光缆	    start			===========================================
	//=====================================================================================================
	/**
	 * 此函数用于向前台返回光缆的数据信息。
	 * 
	 * @param ocable
	 *            :OcableModel类型的对象
	 * @return 返回ResultModel类型的数据。
	 * @author mawj
	 * @version ver.1.0
	 * 
	 * */
	public ResultModel getOcables(OcableModel ocable) {
		ResultModel result = new ResultModel();
		try{
		result.setTotalCount(resNodeDao.getOcableCount(ocable));
		result.setOrderList(resNodeDao.getOcable(ocable));
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "资源模块", "查询光缆", "", request);
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 根据站点编码查找所属地市
	 * getAProvinceByStaioncode
	 **/
	public String getAProvinceByStaioncode(String code){
		String result="";
		result = this.resNodeDao.getProvinceByStationcode(code);
		return result;
	}

	/**
	 * 此函数用于删除数据库中光缆的数据信息。
	 * 
	 * @param ocable
	 *            :OcableModel类型的对象
	 * @return str:其值可能为2种：1.success->说明成功的删除了数据。2.failed->说明删除数据失败。
	 * @author mawj
	 * @version ver.1.0
	 * 
	 * */
	public String delOcable(OcableModel ocable) {
		String str = null;
		try {
			if (resNodeDao.delOcable(ocable.getOcablecode()) > 0) {
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "资源模块", "删除光缆", "", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}
		return str;
	}
	/**
	 * 
	* @Title: updateOcableNameStd 
	* @Description: TODO(更新线路标准命名) 
	* @param @param stationcode    设定文件 
	* @return void    返回类型 
	* @throws
	 */
	public void updateOcableNameStd(String ocablecode){
		try{
			//更新线路时 判断如果没有光纤则添加
			if(resNodeDao.updateOcableNameStd(ocablecode)>0){
				OcableModel ocable=resNodeDao.getEnOcableByCode(ocablecode);
				if (!(resNodeDao.getFibercountByOcableCode(ocablecode) > 0)) {
					addFibers(ocablecode, Integer
							.valueOf(ocable.getFibercount()),
							ocable.getProperty(),
							ocable.getOcablename());
				}
				
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("更新", "资源模块", "更新光缆", "", request);
			}
		}catch(Exception e){
			log.error("update name_std of ocable : " + e.getMessage());
			e.printStackTrace();
		}
	}
	/**
	 * 
	* @Title: addFibers 
	* @Description: TODO(通过光缆添加光纤) 
	* @param @param sectioncode
	* @param @param fibercount
	* @param @param property
	* @param @param ocableSectionName    设定文件 
	* @return void    返回类型 
	* @throws
	 */
	public void addFibers(String sectioncode, int fibercount, String property,
			String ocableSectionName) {
		try {
			HttpServletRequest request = FlexContext.getHttpRequest();
			HttpSession session = request.getSession();
			String userId = "";

			if (session.getAttribute("userid") != null) {
				UserModel user = (UserModel) session
						.getAttribute((String) session.getAttribute("userid"));
				if (user != null) {
					userId = user.getUser_id();
				}
			}
			List<FiberModel> lst = new ArrayList<FiberModel>();

			for (int i = 1; i <= fibercount; i++) {
				FiberModel fiber = new FiberModel();
				fiber.setOcablecode(sectioncode);
				fiber.setFiberserial(String.valueOf(i));
				fiber.setProperty(property);
				fiber.setUpdateperson(userId);
				fiber.setName_std("纤芯/" + ocableSectionName + "/"
						+ i);
				lst.add(fiber);
			}
			resNodeDao.addFibers(lst);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	/**
	 * 
	* @Title: getStationXML 
	* @Description: TODO(获取站点信息) 
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String getStationXml(){
		StringBuilder stationXml = new StringBuilder();
		stationXml.append("<names>");
		List<StationModel> stations = resNodeDao.getStation(null);
		for(StationModel model: stations){
			stationXml.append("<name code=\"")
			             .append(model.getStationcode())
			             .append("\" label=\"")
			             .append(model.getStationname())
			             .append("\"/>");
		}
		stationXml.append("</names>");
		return stationXml.toString();
		
	}
	/**
	 * 导出光缆Excel的函数
	 * 
	 * luoshuai labels :Excel文件表头 titles: 栏目名 types:导出excel类型
	 * */
	public String OcableExportEXCEL(String labels, String[] titles,
			String types,OcableModel model) {
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
		List<OcableModel> ocableList=resNodeDao.getOcable(model);
		int OcableCoutnt = resNodeDao.getOcableCount(model);
		content = new ArrayList();
		for (int i = 0; i < OcableCoutnt; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i+1);//序号
			newcolmn.add(ocableList.get(i).getOcablename() == null? "":ocableList.get(i).getOcablename());
			newcolmn.add(ocableList.get(i).getOcablemodel() == null? "":ocableList.get(i).getOcablemodel());
			newcolmn.add(ocableList.get(i).getVoltlevel() == null? "":ocableList.get(i).getVoltlevel());
			newcolmn.add(ocableList.get(i).getLength() == null? "":ocableList.get(i).getLength());
			newcolmn.add(ocableList.get(i).getBuilddate() == null? "":ocableList.get(i).getBuilddate());
			newcolmn.add(ocableList.get(i).getProperty()==null?"":ocableList.get(i).getProperty());
			newcolmn.add(ocableList.get(i).getBuildmode() == null? "":ocableList.get(i).getBuildmode());
			newcolmn.add(ocableList.get(i).getStation_a() == null? "":ocableList.get(i).getStation_a());
			newcolmn.add(ocableList.get(i).getA_area() == null? "":ocableList.get(i).getA_area());
			newcolmn.add(ocableList.get(i).getStation_z() == null? "":ocableList.get(i).getStation_z());
			newcolmn.add(ocableList.get(i).getZ_area() == null? "":ocableList.get(i).getZ_area());
			
			newcolmn.add(ocableList.get(i).getFibercount() == null? "":ocableList.get(i).getFibercount());
			content.add(newcolmn);
		}
//		if (OcableCoutnt > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[OcableCoutnt % 20000 == 0 ? OcableCoutnt / 20000 + 1
//						: OcableCoutnt / 20000 + 2];
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
		logDao.createLogEvent("导出", "资源模块", "光缆导出", "", request);
		return path;
	}
	/**
	 * 
	* @Title: getStations 
	* @Description: TODO(获取站点信息) 
	* @param @param str
	* @param @param type
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String getStations(String str, String type,String cond) {
		String xml = "";
		Map resultMap = new HashMap();
//		if (type.equalsIgnoreCase("root")) {
//			List<HashMap> list = resNodeDao.selectDomainFlex();
//			for (HashMap map : list) {
//				String domainname = (String) map.get("DOMAINNAME");
//				xml += "\n"
//						+ "<folder label='"
//						+ domainname
//						+ "' isBranch='true' leaf='false' type='domainname' ></folder>";
//			}
//		} else 
		Map map = new HashMap();
		map.put("domain", str);
		map.put("cond", cond);
		if (type.equalsIgnoreCase("system")) {
			List<HashMap> childlist = resNodeDao.selectProvinceFlex(map);
			for (HashMap cmap : childlist) {
				String province = (String) cmap.get("PROVINCE");
				String provincename = (String) cmap.get("PROVINCENAME");
				xml += "\n"
						+ "<province code='"
						+ province
						+ "' label='"
						+ provincename
						+ "' isBranch='true' leaf='false' node='2'  type='province'></province>";
			}
		} else if (type.equalsIgnoreCase("rate")) {
			List<HashMap> leaflist = resNodeDao.selectStationFlex(map);
			for (HashMap lmap : leaflist) {
				String stationname = (String) lmap.get("STATIONNAME");
				String stationcode = (String) lmap.get("STATIONCODE");
				xml += "\n"
						+ "<station code='"
						+ stationcode
						+ "' label='"
						+ stationname
						+ "' isBranch='false' leaf='true' node='3' type='stationcode' ></station>";

			}
		}
		return xml;
	}
	
	
	/**
	 * 
	 * @Title: getEquipments 
	 * @Description: TODO(获取站点信息) 
	 * @param @param str
	 * @param @param type
	 * @param @return    设定文件 
	 * @return String    返回类型 
	 * @throws
	 */
	public String getEquipments(String catalogsid, String type, String searchText) {
		StringBuffer xml = new StringBuffer();
		Map searchMap = new HashMap();
		searchMap.put("s_sbmc", searchText);
		searchMap.put("systemcode", catalogsid);
		if (type.equalsIgnoreCase("root")) {
			List<HashMap> rootlist = resNodeDao.selectSystemForEquipment(searchMap);
			for (HashMap rmap : rootlist) {
				String systemcode = (String) rmap.get("SYSTEMCODE");
				String systemname = (String) rmap.get("SYSTEM_NAME");
				xml.append("\n"
						+ "<system code='"
						+ systemcode
						+ "' label='"
						+ systemname
						+ "' isBranch='true' leaf='false' node='2' type='system'></system>");
			}
		} else if (type.equalsIgnoreCase("leaf")) {
			List<HashMap> leaflist = resNodeDao.selectEquipmentFlex(searchMap);
			for (HashMap lmap : leaflist) {
				String s_sbmc = (String) lmap.get("S_SBMC");
				String equipcode = (String) lmap.get("EQUIPCODE");
				xml.append("\n"
						+ "<equipment code='"
						+ equipcode
						+ "' label='"
						+ s_sbmc
						+ "' isBranch='false' leaf='true' node='3' type='equipcode' ></equipment>");
				
			}
		}
		return xml.toString();
	}
	
	/**
	 * 
	 * @Title: getEquipByTransSystem 
	 * @Description: TODO(根据传输系统获取设备信息) 
	 * @param @param str
	 * @param @param type
	 * @param @return    设定文件 
	 * @return String    返回类型 
	 * @throws
	 */
//	public String getEquipByTransSystem(String str, String type) {
//		String xml = "";
//		Map resultMap = new HashMap();
//		if (type.equalsIgnoreCase("root")) {
////			List<HashMap> list = resNodeDao.selectDomainOfSystemFlex();
////			for (HashMap map : list) {
////				String domainname = (String) map.get("DOMAINNAME");
//			xml += "\n"
//					+ "<folder label='"
//					+ "所属系统"
//					+ "' isBranch='true' leaf='false' type='domainname' ></folder>";
////			}
//		} else if (type.equalsIgnoreCase("system")) {
//			List<HashMap> childlist = resNodeDao.selectSystemFlex();
//			for (HashMap cmap : childlist) {
//				String systemcode = (String) cmap.get("SYSTEMCODE");
//				String sysname = (String) cmap.get("SYSNAME");
//				xml += "\n"
//						+ "<system code='"
//						+ systemcode
//						+ "' label='"
//						+ sysname
//						+ "' isBranch='true' leaf='false' node='2' type='system'></system>";
//			}
//		} else if (type.equalsIgnoreCase("equip")) {
//			List<HashMap> leaflist = resNodeDao.selectEquipFlex(str);
//			for (HashMap lmap : leaflist) {
//				String s_sbmc = (String) lmap.get("S_SBMC");
//				String equipcode = (String) lmap.get("EQUIPCODE");
//				xml += "\n"
//						+ "<equip code='"
//						+ equipcode
//						+ "' label='"
//						+ s_sbmc
//						+ "' isBranch='false' leaf='true' node='3' type='equipcode' ></equip>";
//				
//			}
//		}
//		return xml;
//	}
	/**
	 * 
	* @Title: getDomainForVolt 
	* @Description: TODO(根据电压等级查询站点) 
	* @param @param str
	* @param @param type
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String getDomainForVolt(String str, String type,String cond) {
		String xml = "";
		try{
		Map mp = new HashMap();
		mp.put("volt", str);
		mp.put("cond", cond);
		if (type.equalsIgnoreCase("root")) {
			List<HashMap> list = basedao.queryForList("getStationVolt1",mp);
			for (HashMap map : list) {
				String name = (String)map.get("XTXX");
				String code = (String)map.get("REMARK");
					xml += "\n" + "<folder label='" + name + "' code='"
							+ code
							+ "' isBranch='true' leaf='false' type='volt'></folder>";
					}
		}  else if (type.equalsIgnoreCase("volt")) {
//			String sql = "select decode(stationname,null,'未知站点',stationname) stationname,stationcode from station where volt like '"+str+"%' order by stationname";
//			if(str!=null&&str.equalsIgnoreCase("ZY010301")){
//				sql = "select decode(stationname,null,'未知站点',stationname) stationname,stationcode from station where x_stationtype like '"+str+"%' order by stationname";	
//			}
//			if(str!=null&&str.equalsIgnoreCase("供电公司")){
//				sql = "select decode(stationname,null,'未知站点',stationname) stationname,stationcode from station where x_stationtype like 'ZY010302' or x_stationtype like 'ZY010303'  order by stationname";
//			}
//			if(str!=null&&str.equalsIgnoreCase("ZY010308")){
//				sql = "select decode(stationname,null,'未知站点',stationname) stationname,stationcode from station where x_stationtype like '"+str+"%' order by stationname";
//			}
//			if(str!=null&&str.equalsIgnoreCase("其他")){
//				sql = " select decode(stationname,null,'未知站点',stationname) stationname ,stationcode,volt  from station where volt not like '220%' and volt not like '500%' and x_stationtype not like 'ZY010301' and x_stationtype not like 'ZY010303'  and x_stationtype not like 'ZY010308'   order by stationname";
//			}
			List<HashMap> nodelist = basedao.queryForList("selectStationByVolt1", mp);
			for (HashMap nmap : nodelist) {
				String stationcode = (String) nmap.get("STATIONCODE");
				String stationname = (String) nmap.get("STATIONNAME");
					xml += "\n"
							+ "<station code='"
							+ stationcode
							+ "' label='"
							+ stationname
							+ "' isBranch='false' leaf='true'  type='stationcode'>";


				xml += "\n" + "</station>";
			}
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		return xml;
	}
	//=====================================================================================================
	//============================    光缆	    end				===========================================
	//=====================================================================================================
	//=====================================================================================================
	//============================    光纤	    start			===========================================
	//=====================================================================================================
	/**
	 * 此函数用于向前台返回光纤的数据信息。
	 * 
	 * @param fiber
	 *            :FiberModel类型的对象
	 * @return 返回ResultModel类型的数据。
	 * @author mawj
	 * @version ver.1.0
	 * 
	 * */
	public ResultModel getFibers(FiberModel fiber) {
		ResultModel result = new ResultModel();
		try{
		result.setTotalCount(resNodeDao.getFiberCount(fiber));
		result.setOrderList(resNodeDao.getFiber(fiber));
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "资源模块", "查询光纤", "", request);
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}
	
	
	public ResultModel gettestFibers(testframe fiber) {
		ResultModel result = new ResultModel();
		try{
		result.setTotalCount(resNodeDao.getFiberCounttest(fiber));
		result.setOrderList(resNodeDao.gettestFiber(fiber));
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "资源模块", "查询光纤", "", request);
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}



	/**
	 * 此函数用于删除数据库中光纤的数据信息。
	 * 
	 * @param fiber
	 *            :FiberModel类型的对象
	 * @return str:其值可能为2种：1.success->说明成功的删除了数据。2.failed->说明删除数据失败。
	 * @author mawj
	 * @version ver.1.0
	 * 
	 * */
	public String delFiber(FiberModel fiber) {
		String str = null;
		try {
			if (resNodeDao.delFiber(fiber.getFibercode()) > 0) {
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "资源模块", "删除光纤", "", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}
		return str;
	}
	public String delFibertest(testframe fiber) {
		String str = null;
		try {
			if (resNodeDao.delFibertest(fiber.getOcablename()) > 0) {
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "资源模块", "删除test", "", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}
		return str;
	}
	public String get_param_from_selecteditem(testframe fiber) {
		String str = null;
		str=fiber.getFiberserial()+";;"+fiber.getOcablename()+";;"+fiber.getAendeqport()+";;"+fiber.getZendeqport();

		return str;
	}
	public String addrectest(testframe fiber) {
		String str = null;
		try {
			if (resNodeDao.addrectest(fiber) == 1) {
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("add", "test", "addtest", "", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}
		return str;
	}
	
	
	public String modrectest(testframe fiber) {
		String str = null;
		try {
			if (resNodeDao.modrectest(fiber) == 1) {
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("mod", "test", "addtest", "", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			str = "failed";
		}
		return str;
	}



	/**
	 * 导出光纤Excel的函数
	 * 
	 * luoshuai labels :Excel文件表头 titles: 栏目名 types:导出excel类型
	 * */
	public String FiberExportEXCEL(String labels, String[] titles,
			String types,FiberModel model) {
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
		List<FiberModel> ocableList=resNodeDao.getFiber(model);
		int FiberCoutnt = resNodeDao.getFiberCount(model);
		content = new ArrayList();
		for (int i = 0; i < FiberCoutnt; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(i+1);//序号
			newcolmn.add(ocableList.get(i).getOcablename() == null? "":ocableList.get(i).getOcablename());
			newcolmn.add(ocableList.get(i).getFiberserial() == null? "":ocableList.get(i).getFiberserial());
			newcolmn.add(ocableList.get(i).getLength() == null? "":ocableList.get(i).getLength());
			newcolmn.add(ocableList.get(i).getAendeqport() == null? "":ocableList.get(i).getAendeqport());
			newcolmn.add(ocableList.get(i).getZendeqport() == null? "":ocableList.get(i).getZendeqport());
			newcolmn.add(ocableList.get(i).getProperty()==null?"":ocableList.get(i).getProperty());
			newcolmn.add(ocableList.get(i).getOpticalbusiness()==null?"":ocableList.get(i).getOpticalbusiness());
			newcolmn.add(ocableList.get(i).getToplinkbusiness()==null?"":ocableList.get(i).getToplinkbusiness());
			newcolmn.add(ocableList.get(i).getUpdatedate()==null?"":ocableList.get(i).getUpdatedate());
			content.add(newcolmn);
		}
//		if (FiberCoutnt > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[FiberCoutnt % 20000 == 0 ? FiberCoutnt / 20000 + 1
//						: FiberCoutnt / 20000 + 2];
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
		logDao.createLogEvent("导出", "资源模块", "光纤导出", "", request);
		return path;
	}
	/**
	 * @name :getLogicportserialByEquip
	 * @author mawj
	 */
	public String getLogicportserialByEquip(String equipcode){
		String result="";
		List<ComboxDataModel>  list=resNodeDao.getLogicportserialByEquipNew(equipcode);
		for(ComboxDataModel data:list){
			result+="<name label='"+data.getLabel()+"'  code='"
			+data.getId()
			+"'/>";		
		}
		
		return result;
	}
	
	/**
	 *查找光纤序号---自动添加序号 
	 * getFiberSerialByOcablecode
	 * @parm ocablecode
	 */
	public String getFiberSerialByOcablecode(String ocablecode){
		String result="";
		result = this.resNodeDao.getFiberSerialByOcablecode(ocablecode);
		if(result==null||"".equals(result)){
			result="1";
		}else{
			result = String.valueOf(Integer.parseInt(result)+1);
		}
		return result;
	}
	public String getFiberSerialByOcablecodeNew(String ocablecode){
		String result="";
		//已有光纤
		int oper1 = (Integer) this.basedao.queryForObject("getFibercountByOcableCode", ocablecode);
		int oper2 = (Integer)this.basedao.queryForObject("getFiberCountByOcablecodeNew", ocablecode);
		if(oper1<oper2){
			result = String.valueOf(oper1+1);
		}
		return result;
	}
	
	/**
	 *查找设备下不被占用的端口序号 
	 * getFiberPortserialByEquip
	 * @param equipcode
	 */
	public String getFiberPortserialByEquip(String equipcode){
		String result="";
		List<ComboxDataModel>  list=resNodeDao.getFiberPortserialByEquip(equipcode);
		for(ComboxDataModel data:list){
			result+="<name label='"+data.getLabel()+"'  code='"
			+data.getId()
			+"'/>";		
		}
		
		return result;
	}
	
	public String getLogicportserialSelectedByEquipPort(String fibercode,String aequip,String zequip){
		String result="";
		FiberModel fmodel=resNodeDao.getFiberByCode(fibercode);
		List<ComboxDataModel>  lista=resNodeDao.getLogicportserialByEquipNew(aequip);
		List<ComboxDataModel>  listz=resNodeDao.getLogicportserialByEquipNew(zequip);
		String aport=(fmodel!=null?fmodel.getAendeqport():"");
		String zport=(fmodel!=null?fmodel.getZendeqport():"");
		int aSelected=0;
		int zSelected=0;
		int acount=0;
		int zcount=0;
		for(ComboxDataModel data:lista){
			result+="<name label='"+data.getLabel()+"'  code='"
			+data.getId()
			+"'/>";	
			if(data.getId().equals(aport)){
				aSelected=acount;
			}
			acount+=1;
		}
		result+=";"+aSelected+";";
		for(ComboxDataModel data:listz){
			result+="<name label='"+data.getLabel()+"'  code='"
			+data.getId()
			+"'/>";		
			if(data.getId().equals(zport)){
				zSelected=zcount;
			}
			zcount+=1;
		}
		result+=";"+zSelected+";";
		return result;
	}
	
	//=====================================================================================================
	//============================    光纤	    end				===========================================
	//=====================================================================================================
	//=====================================================================================================
	//============================    机盘	    start			===========================================
	//=====================================================================================================
	/**

	 * @获取机盘信息
	 * */
	public ResultModel getEquipPack(EquipPack equipPack) {
		ResultModel result = new ResultModel();
		try{
		result.setTotalCount(resNodeDao.GetEquipPackCount(equipPack));
		result.setOrderList(resNodeDao.GetEquipPack(equipPack));
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "资源模块", "查询机盘", "", request);
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}
	/**
	 * 
	 * 添加机盘
	 * @param equipPack
	 * @return
	 */
	public String addEquipPack(EquipPack equipPack) {
		String str = null;
		try {
			resNodeDao.AddEquipPack(equipPack);
			str = "success";
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("添加", "资源模块", "添加机盘", "", request);
		} catch (Exception e) {
			str = "failed";
			e.printStackTrace();
		}
		return str;
	}
	/**
	 * 
	 *修改机盘信息
	 * @param equipPack
	 * @return
	 */
	public String ModifyPack(EquipPack equipPack) {
		String str = null;

		try {
			if (resNodeDao.ModifyPack(equipPack) > 0) {
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("修改", "资源模块", "修改机盘", "", request);
			}
		} catch (Exception e) {
			str = "failed";
			e.printStackTrace();
		}

		return str;
	}
	
	/**
	 * @author xgyin
	 * @use 查找指定机盘序号的机盘
	 * @name checkPackSerial
	 * 
	 */
	public String checkPackSerial(String  equipcode,String frameserail,String slotserial,String packserial) {
		String str = "failed";
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserail);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		List<EquipPack> list = new ArrayList<EquipPack>();
		try {
			list=resNodeDao.checkPackSerial(map);
			if(list.size()>0){
				str="success";
			}
		} catch (Exception e) {
			str = "failed";
			e.printStackTrace();
		}
		return str;
	}
	/**
	 * 删除机盘
	 * @param equipPack
	 * @return
	 */
	public String delEquipPack(EquipPack equipPack) {
		String str = null;
		try {
			if (resNodeDao.delEquipPack(equipPack) > 0) {
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("删除", "资源模块", "删除机盘", "", request);
			}
			str = "success";
		} catch (Exception e) {
			str = "failed";
			e.printStackTrace();
		}
		return str;
	}

	public String getPackModel() {
		String result = "";
		List<ComboxDataModel> lst = resNodeDao.getPackModel();
		for (ComboxDataModel data : lst) {
			result += "<packmodel id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"packmodel\"  isBranch=\"false\"></packmodel>";
		}
		return result;
	}

	/**
	 * 此函数用于根据厂商获取系统数据信息。
	 * 
	 * @param vender
	 *            :String类型参数。
	 * @return result:String类型。
	 * @version ver.1.0
	 * */
	public String getSystemsByVender(String vender) {
		String result = "";
		List<ComboxDataModel> lst = resNodeDao.getSystemByVender(vender);
		for (ComboxDataModel data : lst) {
			result += "<system id=\"" + data.getId() + "\" label=\""
					+ data.getLabel() + "\" parentcode=\"" + vender
					+ "\"  name=\"system\"  isBranch=\"false\"></system>";
		}
		return result;
	}
	/**
	 * 
	* @Title: getEuipSlotSerialByFrame 
	* @Description: TODO(通过机框获取机槽) 
	* @param @param equipcode
	* @param @param frameserial
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String getEuipSlotSerialByFrame(String equipcode, String frameserial) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");
		String result = "";
		Map paraMap = new HashMap();
		paraMap.put("equipcode", equipcode);
		paraMap.put("frameserial", frameserial);
		List<HashMap> list = basedao.queryForList("getSlotSerialByEquipcode",
				paraMap);
		if (list != null && list.size() > 0) {
			for (HashMap map : list) {
				result += "<slot id=\"" + (String) map.get("SLOTSERIAL")
						+ "\" label=\"" + (String) map.get("SLOTSERIAL")
						+ "\" isBranch=\"false\"></slot>";

			}
		}
		return result;
	}
	
	/**
	 * getEuipSlotSerialByFrame
	 * 通过机框获取槽位号---去掉已经有盘的槽位
	 * 
	 **/
	public String getEuipSlotSerialByFrameDistinct(String equipcode, String frameserial) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");
		String result = "";
		Map paraMap = new HashMap();
		paraMap.put("equipcode", equipcode);
		paraMap.put("frameserial", frameserial);
		List<HashMap> list = basedao.queryForList("getEuipSlotSerialByFrameDistinct",
				paraMap);
		if (list != null && list.size() > 0) {
			for (HashMap map : list) {
				result += "<slot id=\"" + (String) map.get("SLOTSERIAL")
						+ "\" label=\"" + (String) map.get("SLOTSERIAL")
						+ "\" isBranch=\"false\"></slot>";

			}
		}
		return result;
	}
	

	public String getEuipFrameSerial(String equipcode) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");
		String result = "";
		List<HashMap> list = basedao.queryForList("getFrameSerialByEquipcode",
				equipcode);
		if (list != null && list.size() > 0) {
			for (HashMap map : list) {
				result += "<frame id=\"" + (String) map.get("FRAMESERIAL")
						+ "\" label=\"" + (String) map.get("FRAMESERIAL")
						+ "\" name=\"frameserial\" isBranch=\"false\"></frame>";

			}

		}
		return result;
	}
	//台账-机框的选择设备，处理函数 
	public String getEquipByeqsearch(String child_systemcode,String child_vendor,String eqsearch){
		StringBuffer result=new StringBuffer();
		Map map=new HashMap();
		map.put("systemcode", child_systemcode);
		map.put("vendor", child_vendor);
		map.put("topolinkeqsearch", eqsearch);
		List<ComboxDataModel>list=resNodeDao.getEquipByeqsearch(map);
		for(ComboxDataModel data:list){
			result.append("<equip id=\""+data.getId()+"\"label=\""
			+data.getLabel()
			+"\" name=\"equip\" isBranch=\"false\"></equip>");		
		}
		
		return result.toString();
	}
	/**
	 * 机盘导出
	 * @param labels
	 * @param titles
	 * @param types
	 * @param model
	 * @return
	 */
	public String EquipPackExportEXCEL(String labels, String[] titles,
			String types,EquipPack model) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		String path = null;// 返回到前台的路径
		List content = null;
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String zipfilePath = null; // 压缩文件夹路径
		String date = getName();
		String filename = date + ".xls";
		List<EquipPack> eplist = resNodeDao.GetEquipPack(model);
		int equipPackCount = resNodeDao.GetEquipPackCount(model);
		content = new ArrayList();
		EquipPack equipPack;
		for (int i = 0; i < equipPackCount; i++) {
			List newcolmn = new ArrayList();
			equipPack = eplist.get(i);
			newcolmn.add(equipPack.getEquipname() == null? "":equipPack.getEquipname());
			newcolmn.add(equipPack.getFrameserial() == null? "":equipPack.getFrameserial());
			newcolmn.add(equipPack.getSlotserial() == null? "":equipPack.getSlotserial());
			newcolmn.add(equipPack.getPackserial() == null? "":equipPack.getPackserial());
			newcolmn.add(equipPack.getPackmodel() == null? "":equipPack.getPackmodel());
			newcolmn.add(equipPack.getUpdatedate() == null? "":equipPack.getUpdatedate());
			content.add(newcolmn);
		}
//		if (equipPackCount > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[equipPackCount % 20000 == 0 ? equipPackCount / 20000 + 1
//						: equipPackCount / 20000 + 2];
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
			try {
				RealPath = this.getRealPath();
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				new CustomizedExcel(servletConfig).WriteExcel(RealPath
						+ filename, labels, titles, content);
			} catch (Exception e) {
				e.printStackTrace();
			}
			path = "exportExcel/" + filename;
//		}
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "台帐模块", "机盘导出", "", request);
		return path;
	}
	//=====================================================================================================
	//============================    机盘	    end				===========================================
	//=====================================================================================================
	/**

	 * 此函数用于获取数据库中机框的数据信息。
	 * 
	 * @param equipframe
	 *            :EquipFrame类型参数。
	 * @return result:ResultModel类型的数据。
	 * @author xgyin
	 * @version ver.1.0
	 * */
	public ResultModel getEquipFrame(EquipFrame equipframe) {
		ResultModel result = new ResultModel();
		try{
		result.setTotalCount(resNodeDao.GetEquipFrameCount(equipframe));
		List<EquipFrame> list = resNodeDao.GetEquipFrame(equipframe);
		/*for(int i=0;i<list.size();i++){
			EquipFrame key = list.get(i);
			//设置机框厂商
//			key.setVendor(resNodeDao.getEquipFrameVendorById(key.getVendor()));
			//设置机框状态
			if(key.getFrame_state()!=null){
				key.setFrame_state(resNodeDao.getEquipFrameStateById(key.getFrame_state()));
			}
			//设置机框型号
			key.setFramemodel(resNodeDao.getEquipFrameModelById(key.getFramemodel()));
		}*/
		result.setOrderList(list);
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "台帐模块", "查询机框", "", request);
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 此函数用于获取机框厂商列表。
	 * 
	 * @param 无参数
	 *            。
	 * @return result:String 类型。
	 * @author xgyin
	 * @version ver.1.0
	 * */
	public String getVenders() {
		String result = "";
		List<ComboxDataModel> lst = resNodeDao.getVender();
		for (ComboxDataModel data : lst) {
			result += "<vendor id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"vendor\"  isBranch=\"false\"></vendor>";
		}
		return result;
	}
	/**
	 * 
	* @Title: getPackModels 
	* @Description: TODO(获取机盘型号) 
	* @param @return    设定文件 
	* @return String    返回类型 
	* @author mawj 
	* @throws
	 */
	public String getPackModels(String equipcode){
		String result = "";
		List<ComboxDataModel> lst = resNodeDao.getPackModels(equipcode);
		for (ComboxDataModel data : lst) {
			result += "<packmodel id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"packmodel\"  isBranch=\"false\"></packmodel>";
		}
		return result;
	}
	
	public String getEquipCodeByName(String equipname){
		String result="";
		result = this.resNodeDao.getEquipCodeByName(equipname);
		return result;
	}
	
	/**
	 * 
	 * 	@Title: delEquipFrames 
	 * @Description: TODO(删除站点信息) 
	 * @param @param EquipFrame
	 * @param @return    设定文件 
	 * @return String    str:其值可能为2种：1.success->说明成功的删除了数据。2.failed->说明删除数据失败。
	 * @throws
	 */
//	public String delEquipFrames(EquipFrame model) {
//		String str = null;
//		try {
//			if (resNodeDao.delEquipFrame(model.getProjectname()) > 0) {
//				str = "success";
//				HttpServletRequest request = FlexContext.getHttpRequest();
//				WebApplicationContext ctx = WebApplicationContextUtils
//						.getWebApplicationContext(FlexContext
//								.getServletContext());
//				LogDao logDao = (LogDao) ctx.getBean("logDao");
//				logDao.createLogEvent("删除", "资源模块", "删除机框", "", request);
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//			str = "failed";
//		}
//		return str;
//	}

	/**
	 * 此函数用于获取机框状态列表。
	 * 
	 * @param 无参数
	 *            。
	 * @return result:String 类型。
	 * @author xgyin
	 * @version ver.1.0
	 * */
	public String getFrameState() {
		String result = "";
		List<ComboxDataModel> lst = resNodeDao.getFrameState();
		for (ComboxDataModel data : lst) {
			result += "<frame_state id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"frame_state\"  isBranch=\"false\"></frame_state>";
		}
		return result;
	}
	/**
	 * 此函数用于获取机框模型列表。
	 * 
	 * @param 无参数
	 *            。
	 * @return result:String 类型。
	 * @author xgyin
	 * @version ver.1.0
	 * */
	public String getFrameModel() {
		String result = "";
		List<ComboxDataModel> lst = resNodeDao.getFrameModel();
		for (ComboxDataModel data : lst) {
			result += "<framemodel id=\"" + data.getId() + "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"framemodel\"  isBranch=\"false\"></framemodel>";
		}
		return result;
	}
	/**
	 * 
	* @Title: frameExportEXCEL 
	* @Description: TODO(导出Excel的函数) 
	* @param @param labels
	* @param @param titles
	* @param @param types
	* @param @param model Excel文件表头 titles: 栏目名 types:导出excel类型
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String frameExportEXCEL(String labels, String[] titles,
			String types,EquipFrame model) {
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
		List<EquipFrame> frameList=resNodeDao.GetEquipFrame(model);
		int frameCoutnt = frameList.size();
		content = new ArrayList();
		for (int i = 0; i < frameCoutnt; i++) {
			EquipFrame key = frameList.get(i);
			List newcolmn = new ArrayList();
			newcolmn.add(i+1);//序号
			newcolmn.add(key.getFrameserial() == null? "":key.getFrameserial());
//			newcolmn.add(key.getS_framename() == null? "":key.getS_framename());
			newcolmn.add(key.getShelfinfo() == null? "":key.getShelfinfo());
			newcolmn.add(key.getFrame_state() == null? "":key.getFrame_state());
			newcolmn.add(key.getFramemodel() == null? "":key.getFramemodel());
			newcolmn.add(key.getFrontwidth() == null? "":key.getFrontwidth());
			newcolmn.add(key.getFrontheight() == null? "":key.getFrontheight());
			newcolmn.add(key.getRemark() == null? "":key.getRemark());
//			newcolmn.add(key.getUpdateperson() == null? "":key.getUpdateperson());
//			newcolmn.add(key.getUpdatedate() == null? "":key.getUpdatedate());
			content.add(newcolmn);
		}
//		if (frameCoutnt > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[frameCoutnt % 20000 == 0 ? frameCoutnt / 20000 + 1
//						: frameCoutnt / 20000 + 2];
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
//			path = "exportExcel/" +  date + ".zip";
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
		logDao.createLogEvent("导出", "资源模块", "机框导出", "", request);
		return path;
	}
	/**
	 * 
	* @Title: getFrameSlotStatus 
	* @Description: TODO(获取机槽状态) 
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String getFrameSlotStatus() {
		String result = "";
		List<ComboxDataModel> lst = resNodeDao.getFrameSlotStatus();
		for (ComboxDataModel data : lst) {
			result += "<slot_status id=\""
					+ data.getId()
					+ "\" label=\""
					+ data.getLabel()
					+ "\"  name=\"slot_status\"  isBranch=\"false\"></slot_status>";
		}
		return result;
	}
	/**
	 * 此函数用于获取数据库中机槽的数据信息。
	 * 
	 * @param getFrameSlot
	 *            :FrameSlot类型参数。
	 * @return result:ResultModel类型的数据。
	 * @author xgyin
	 * @version ver.1.0
	 * */
	public ResultModel getFrameSlot(FrameSlot model) {
		ResultModel result = new ResultModel();
		try{
		result.setTotalCount(resNodeDao.getFrameSlotCount(model));
		List<FrameSlot> list = resNodeDao.getEFrameSlotLst(model);
		/*for(int i=0;i<list.size();i++){
			FrameSlot key = list.get(i);
			//设置机槽同步状态
			if(key.getSync_status()!=null){
				key.setSync_status(resNodeDao.getEquipFrameStateById(key.getSync_status()));
			}
			
			//设置机槽状态
			if(key.getStatus()!=null){
				key.setStatus(resNodeDao.getSlotStatusById(key.getStatus()));
			}
			
//			//设置机框名称
//			if(key.getName_std()!=null){
//				key.setFramename(resNodeDao.getFramenameById(key.getName_std()));
//			}
		}*/
		result.setOrderList(list);
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "台帐模块", "查询机槽", "", request);
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}
	/**
	 * 
	 * 	@Title: delFrameSlot 
	 * @Description: TODO(删除机槽信息) 
	 * @param @param FrameSlot
	 * @param @return    设定文件 
	 * @return String    str:其值可能为2种：1.success->说明成功的删除了数据。2.failed->说明删除数据失败。
	 * @throws
	 */
//	public String delFrameSlot(FrameSlot model) {
//		String str = null;
//		try {
//			if (resNodeDao.delFrameSlot(model.getName_std()) > 0) {
//				str = "success";
//				HttpServletRequest request = FlexContext.getHttpRequest();
//				WebApplicationContext ctx = WebApplicationContextUtils
//						.getWebApplicationContext(FlexContext
//								.getServletContext());
//				LogDao logDao = (LogDao) ctx.getBean("logDao");
//				logDao.createLogEvent("删除", "资源模块", "删除机槽", "", request);
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//			str = "failed";
//		}
//		return str;
//	}
	/**
	 * 
	* @Title: slotExportEXCEL 
	* @Description: TODO(导出Excel的函数) 
	* @param @param labels
	* @param @param titles
	* @param @param types
	* @param @param model Excel文件表头 titles: 栏目名 types:导出excel类型
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String slotExportEXCEL(String labels, String[] titles,
			String types,FrameSlot model) {
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
		List<FrameSlot> slotList=resNodeDao.getEFrameSlotLst(model);
		int slotCoutnt = slotList.size();
		content = new ArrayList();
		for (int i = 0; i < slotCoutnt; i++) {
			FrameSlot key = slotList.get(i);
			
			List newcolmn = new ArrayList();
			newcolmn.add(i+1);//序号
//			newcolmn.add(key.getSlotname() == null? "":key.getSlotname());
			newcolmn.add(key.getFrameserial() == null? "":key.getFrameserial());
			newcolmn.add(key.getSlotserial() == null? "":key.getSlotserial());
			newcolmn.add(key.getEquipname() == null? "":key.getEquipname());
			newcolmn.add(key.getStatus() == null? "":key.getStatus());
//			newcolmn.add(key.getY_slotmodel() == null? "":key.getY_slotmodel());
//			newcolmn.add(key.getRowno()==null?"":key.getRowno());
//			newcolmn.add(key.getColno() == null? "":key.getColno());
			newcolmn.add(key.getPanelwidth() == null? "":key.getPanelwidth());
			newcolmn.add(key.getPanellength() == null? "":key.getPanellength());
			newcolmn.add(key.getRemark() == null? "":key.getRemark());
//			newcolmn.add(key.getUpdatedate() == null? "":key.getUpdatedate());
//			newcolmn.add(key.getSync_status() == null? "":key.getSync_status());
			content.add(newcolmn);
		}
//		if (slotCoutnt > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[slotCoutnt % 20000 == 0 ? slotCoutnt / 20000 + 1
//						: slotCoutnt / 20000 + 2];
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
//				zip.zip(zipfilePath, zipfilePath+ ".zip", "");
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
		logDao.createLogEvent("导出", "资源模块", "机框导出", "", request);
		return path;
	}
	//机槽/机框的选择设备，处理函数
		public String getEquipSlotByeqsearch(String child_systemcode,String child_vendor,String eqsearch){
			StringBuffer result= new StringBuffer();
			Map map=new HashMap();
			map.put("systemcode", child_systemcode);
			map.put("vendor", child_vendor);
			map.put("topolinkeqsearch", eqsearch);
			List<ComboxDataModel>list=resNodeDao.getEquipByeqsearch(map);
			for(ComboxDataModel data:list){
				result.append("<equip id=\""+data.getId()+"\"label=\""
				+data.getLabel()
				+"\" name=\"equip\" isBranch=\"false\"></equip>");		
			}
			
			return result.toString();
		}
		
		/**
		 * 
		 * 查找光缆段---有光纤没被占用的
		 * getOcablesearch
		 * 
		 */
		public String getOcablesearch(String cond){
			String result="";
			List<ComboxDataModel>  list=resNodeDao.getOcablesearch(cond);
			for(ComboxDataModel data:list){
				result+="<name label='"+data.getLabel()+"'  id='"
				+data.getId()
				+"'/>";		
			}
			
			return result;
		}
		
		/**
		 *查询站点下的设备 
		 * getEquipByStationAndeqsearch
		 * 
		 */
		public String getEquipByStationAndeqsearch(String stationcode,String cond){
			String result="";
			Map map = new HashMap();
			map.put("cond", cond);
			map.put("stationcode", stationcode);
			List<ComboxDataModel>  list=resNodeDao.getEquipByStationAndeqsearch(map);
			for(ComboxDataModel data:list){
				result+="<name label='"+data.getLabel()+"'  id='"
				+data.getId()
				+"'/>";		
			}
			
			return result;
		}
		
		/**
		 *根据光缆编码查找起止端口
		 * getAportAndZportByOcablecode
		 * 
		 */
		public String getAportAndZportByOcablecode(String ocablecode){
			String result="";
			if(ocablecode==null){
				ocablecode="";
			}
				result = this.resNodeDao.getAportAndZportByOcablecode(ocablecode);
			return result;
		}
		
		/**
		 * @name :getFrameserialByeId
		 * @author xgyin
		 */
		public String getFrameserialByeId(String equipcode){
			StringBuffer result= new StringBuffer();
			List<ComboxDataModel>  list=resNodeDao.getFrameserialByeId(equipcode);
			for(ComboxDataModel data:list){
				result.append("<name label='"+data.getLabel()+"'  code='"
				+data.getId()
				+"'/>");		
			}
			
			return result.toString();
		}
		
		/**
		 * @name :getSlotserialByeIds
		 * @author xgyin
		 */
		public String getSlotserialByeIds(String equipcode,String frameserial){
			String result="";
			Map map= new HashMap();
			map.put("equipcode", equipcode);
			map.put("frameserial", frameserial);
			List<ComboxDataModel>  list=resNodeDao.getSlotserialByeIds(map);
			for(ComboxDataModel data:list){
				result+="<name label='"+data.getLabel()+"'  code='"
				+data.getId()
				+"'/>";		
			}
			
			return result;
		}
		
		
		/**
		 * @name :getFrameserialByeIds
		 * @author xgyin
		 */
		public String getFrameserialByeIds(String equipcode,String id){
			String result="";
			String frameserial = resNodeDao.getFrameserialByeName_std(id);
			List<ComboxDataModel>  list=resNodeDao.getFrameserialByeId(equipcode);
			for(ComboxDataModel data:list){
				result+="<name label='"+data.getLabel()+"'  code='"
				+data.getId()
				+"'/>";	
				if(frameserial.equals(data.getLabel())){
					frameserial=data.getId();
				}
			}
			
			return frameserial+";"+result;
		}
		/**
		 * @name :getPortseriaByIds
		 * @author xgyin
		 */
		public String getPortseriaByIds(String equipcode,String frameSerial,String slotSerial,String packSerial){
			String result="";
			Map map = new HashMap();
			map.put("equipcode", equipcode);
			map.put("frameserial", frameSerial);
			map.put("slotserial", slotSerial);
			map.put("packserial", packSerial);
			List<ComboxDataModel>  list=resNodeDao.getPortseriaByIds(map);
			for(ComboxDataModel data:list){
				result+="<name label='"+data.getLabel()+"'  code='"
				+data.getId()
				+"'/>";		
			}
			
			return result;
		}
		/**
		 *@name:modifyEquipFrame
		 * @author xgyin
		 * @use：修改机框信息
		 */
		public String modifyEquipFrame(EquipFrame frame) {
			String str = "";
			try {
				resNodeDao.modifyEquipFrame(frame);
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("修改", "资源模块", "修改机框资源", "", request);

			} catch (Exception e) {
				e.printStackTrace();
				str = "fail";
			}
			return str;
		}
		
		/**
		 * @author xgyin
		 * @name modifyEquipSlot
		 * @ use: 修改机槽信息
		 */
		public String modifyEquipSlot(FrameSlot slot) {
			String str = "";
			try {
				resNodeDao.modifyEquipSlot(slot);
				str = "success";
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("修改", "资源模块", "修改机槽资源", "", request);

			} catch (Exception e) {
				e.printStackTrace();
				str = "fail";
			}
			return str;
		}
		
		/**
		 * @author 尹显贵
		 * @name getOpticalIdByToplinkid
		 * @param  复用段ID
		 */
		public String getOpticalIdByToplinkid(String toplinkid){
			
			String result="";
			result = (String) this.basedao.queryForObject("getOpticalIdByToplinkid", toplinkid);
			if(result==null){
				result="";
			}
			return result;
		}
		
		
		
	/**

	 * 获取时间的函数
	 * */
	public static String getName() {
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd HH.mm.ss");
		return sDateFormat.format(new java.util.Date().getTime());
	}
	

	/**
	 * 获取文件路径
	 * */
	public String getRealPath() {
		String RealPath = null;// 绝对路径
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
		RealPath = fullPath.substring(0, fullPath.indexOf("WEB-INF"));//linux下的情况	
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
}
