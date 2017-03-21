package sysManager.log.dwr;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import jxl.write.WriteException;

import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ZipExcel;

import resManager.resBusiness.model.CircuitBusinessModel;
import sysManager.log.dao.LogDao;
import sysManager.log.model.LogModel;
import sysManager.log.model.LogResultModel;
import sysManager.user.model.UserModel;
import expExcel.OperationExcel;
import flex.messaging.FlexContext;


public class LogDwr{
	LogDao logDao;
	public LogDao getLogDao() {
		return logDao;
	}
	public void setLogDao(LogDao logDao) {
		this.logDao = logDao;
	}
	
	public LogResultModel getSysLogInfos(LogModel logModel){
		LogResultModel result = new LogResultModel();
		result.setTotalCount(logDao.getCountEvents(logModel));
		result.setLogList((ArrayList)logDao.getLogEvents(logModel));
		return result;
	}
	
	public LogResultModel getSyncLogInfos(LogModel logModel){
		LogResultModel result = new LogResultModel();
		result.setTotalCount(logDao.getSyncLogInfosCount(logModel));
		result.setLogList((ArrayList)logDao.getSyncLogInfos(logModel));
		return result;
	}
	
	/**
	 * 获取文件路径
	 * */
	public String getRealPath() {
		String RealPath = null;// 绝对路径
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
		RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));
		RealPath += "exportExcel/";
		return RealPath;
	}
	
	/**
	 * 此方法用于导出系统日志。当超过两万条时导出多个.xsl文件打成一个压缩包。
	 * @author Haifeng liu
	 * @param labels
	 * @param titles
	 * @param logModel
	 * @return
	 */
	public String LogExportEXCEL(String labels, String[] titles,LogModel logModel) {
//		Date d = new Date();
		String path = null;// 返回到前台的路径
		List content = null;
		HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String zipfilePath = null;// 压缩文件夹路径
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String date = sDateFormat.format(new java.util.Date());
		String filename = date + ".xls";// 定义文件名
		int logCount = logDao.getCountEvents(logModel); // = userDao.getUserCounts();
		List<LogModel> logInfos = (ArrayList) logDao.getLogEvents_exportExcel(logModel);
		content = new ArrayList();
		for (int i = 0; i < logCount; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(logInfos.get(i).getLog_type());
			newcolmn.add(logInfos.get(i).getModule_desc());
			newcolmn.add(logInfos.get(i).getFunc_desc());
			newcolmn.add(logInfos.get(i).getData_id()==null?"":logInfos.get(i).getDept_name());
			newcolmn.add(logInfos.get(i).getUser_id());
			newcolmn.add(logInfos.get(i).getUser_name());
			newcolmn.add(logInfos.get(i).getDept_name()==null?"":logInfos.get(i).getDept_name());
			newcolmn.add(logInfos.get(i).getUser_ip());
			newcolmn.add(logInfos.get(i).getLog_time());
			content.add(newcolmn);
		}
		//每两万条数据导出一个Excel表。
//		if(logCount>20000){
//			try{
//				RealPath = this.getRealPath();
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath + date;
//				RealPath += date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[logCount % 20000 == 0 ? logCount / 20000 + 1
//						: logCount / 20000 + 2];
//				for (int i = 0; i < list.length - 1; i++) {
//					CustomizedExcel ce = new CustomizedExcel(servletConfig);
//					list[i] = content.subList(i * 20000 + 1,
//							(i + 1) * 20000 > content.size() ? content.size()
//									: (i + 1) * 20000);
//					ce.WriteExcel(RealPath + date + "-log" + i + ".xls",
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
//			path = "exportExcel/" + date + ".zip";
//		}else {
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
		return path;
	}
	//同步日志导出
	public String syncLogExportEXCEL(String labels, String[] titles,
			String types, LogModel model) {
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
		List<LogModel> key = (ArrayList)logDao.getSyncLogInfos(model);
		int businessCount = key.size();
		content = new ArrayList();
		for (int i = 0; i < businessCount; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(key.get(i).getLog_type());
			newcolmn.add(key.get(i).getModule_desc());
			newcolmn.add(key.get(i).getFunc_desc());
			newcolmn.add(key.get(i).getData_id()==null?"":key.get(i).getData_id());
			newcolmn.add(key.get(i).getUser_id());
			newcolmn.add(key.get(i).getUser_name());
			newcolmn.add(key.get(i).getDept_name()==null?"":key.get(i).getDept_name());
			newcolmn.add(key.get(i).getUser_ip());
			newcolmn.add(key.get(i).getLog_time());
			content.add(newcolmn);
		}
//		if (businessCount > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath+ date;
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
		logDao.createLogEvent("导出", "资源管理模块", "同步日志导出", "", request);
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

	
}