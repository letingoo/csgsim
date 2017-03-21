package com.metarnet.mnt.alarmmgr.component;
//
//import java.io.File;
//import java.io.IOException;
//import java.text.SimpleDateFormat;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.HashMap;
//import java.util.List;
//import javax.servlet.ServletConfig;
//import javax.servlet.http.HttpServletRequest;
//
//import netres.component.ExcelOperation.CustomizedExcel;
//
//import mapResourcesInfo.component.FiberCustomizedExcel;
//import mapResourcesInfo.component.ZipExcel;
//
//import com.metarnet.mnt.alarmmgr.dao.AlarmManagerDAO;
//import com.metarnet.mnt.alarmmgr.model.AlarmResult;
//
//import jxl.write.WriteException;
//import flex.messaging.FlexContext;
//
public class ExportExcel {
//	/**
//	 * 导出Excel的函数
//	 * 
//	 * @luoshuai labels：导出EXCEL的标题 titles:导出EXCEL的字段名 types:导出数据的类型
//	 * */
//	private AlarmManagerDAO alarmManagerDao;
//	private static final int MAX_RECORDS_PER_EXCEL = 20000;
//	/**
//	 * 构造函数
//	 * */
//	public ExportExcel(AlarmManagerDAO alarmManagerDao) {
//		this.alarmManagerDao =alarmManagerDao;
//	}
//
//	public ExportExcel() {
//
//	}
//
//	/**
//	 * 获取时间的函数
//	 * */
//	public static String getName() {
//		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd");
//		return sDateFormat.format(new java.util.Date());
//	}
//
//	/**
//	 * 获取文件路径
//	 * */
//	public String getRealPath() {
//		String RealPath = null;// 绝对路径
//		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
//		RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));
//		RealPath += "exportExcel/";
//		return RealPath;
//	}
//
//	/**
//	 * 中断电路信息
//	 * 
//	 * */
//	@SuppressWarnings("unchecked")
//	public String ExportEXCEL(String labels, String[] titles,
//			String circuitname,String station1,String station2,String powerline,String types) {
//		try{
//			Date d = new Date();
//			String path = null;// 返回到前台的路径
//			List content = null;
//	//		HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
//			ServletConfig servletConfig = FlexContext.getServletConfig();
//			String RealPath = null;// 绝对路径
//			String date = getName();
//			String filename = types + "-" + date + ".xls";
//			String zipfilePath = null; // 压缩文件夹路径
//			List<HashMap> datalist = alarmManagerDao.getExportKeyBusiness_hz(circuitname,station1,station2,powerline);
//			int AlarmCoutnt =datalist.size();
//			content = new ArrayList();
//			for (int i = 0; i < AlarmCoutnt; i++) {	
//				List newclomn = new ArrayList();
//				HashMap map = datalist.get(i);
//				newclomn.add(map.get("CIRCUITCODE") == null? " ":map.get("CIRCUITCODE"));
//				newclomn.add(map.get("USERNAME") == null? " ":map.get("USERNAME"));
//				newclomn.add(map.get("CIRCUITTYPE") == null? " ":map.get("CIRCUITTYPE"));
//				newclomn.add(map.get("USETIME") == null? " ":map.get("USETIME"));
//				newclomn.add(map.get("RATE") == null? " ":map.get("RATE"));
//				newclomn.add(map.get("PORTSERIALNO1") == null? " ":map.get("PORTSERIALNO1"));
//				newclomn.add(map.get("PORTSERIALNO2") == null ?" ":map.get("PORTSERIALNO2"));
//				newclomn.add(map.get("ALARMDETAIL") == null?" ":map.get("ALARMDETAIL"));				
//				content.add(newclomn);								
//			}
//		if (AlarmCoutnt > 20000)// 每20000条数据写一个EXCEL
//		{
//			try {
//				RealPath = this.getRealPath();
//				zipfilePath = RealPath + labels + "-" + date;
//				RealPath += labels + "-" + date + "/";
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				List list[] = new List[AlarmCoutnt % 20000 == 0 ? AlarmCoutnt / 20000 + 1
//						: AlarmCoutnt / 20000 + 2];
//				for (int i = 0; i < list.length - 1; i++) {
//					FiberCustomizedExcel ce = new FiberCustomizedExcel(servletConfig);
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
//			path = "exportExcel/" + types
//					+ "-" + date + ".zip";
//		} else {
//			try {
//				RealPath = this.getRealPath();
//				File f = new File(RealPath);
//				if (!f.exists()) {
//					f.mkdir();
//				}
//				new CustomizedExcel(servletConfig).WriteExcel(RealPath
//						+ filename, labels, titles, content);
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			path = "exportExcel/" + filename;
//		}
//		
//		return path;
//		}catch(Exception e){
//			e.printStackTrace();
//			return null;
//		}
//	}	
//	
}
