package netres.component.ExcelOperation;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;


import jxl.write.WriteException;


import netres.dao.netresDao;
import netres.model.StationModel;
import flex.messaging.FlexContext;

public class ExportExcel {
	
	private static final int MAX_RECORDS_PER_EXCEL = 20000;
	
	/**
	 * 导出Excel的函数
	 * 
	 * @luoshuai labels：导出EXCEL的标题 titles:导出EXCEL的字段名 types:导出数据的类型
	 * */
	private netresDao mt;
	


	/**
	 * 构造函数
	 * */
	public ExportExcel(netresDao mt) {
		this.mt = mt;
	}

	public ExportExcel() {

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
//		if(System.getProperties().getProperty("os.name").toUpperCase().indexOf("WINDOWS") != -1){
//			RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));//windows下的情况
//		}else if(System.getProperties().getProperty("os.name").toUpperCase().indexOf("LINUX") != -1){
			RealPath = fullPath.substring(0, fullPath.indexOf("WEB-INF"));//linux下的情况	
//		}
		RealPath += "exportExcel/";
		return RealPath;
	}

	/**
	 * 局站导出
	 * 
	 * */
	@SuppressWarnings("unchecked")
	public String StationExportEXCEL(String labels, String[] titles,
			String types,StationModel model) {
//		Date d = new Date();
		String path = null;// 返回到前台的路径
		List content = null;
//		HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
		String filename = types + "-" + date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
		// String label="局站信息列表";
		// String[] title = { "局站名称","省份","经度","纬度","备注","更新时间"};
//		List<StationModel> stationList = mt.getALLStation();
		List<StationModel> stationList=mt.getStation(model);
		int StationCoutnt = mt.getStationCount(model);
		content = new ArrayList();
		for (int i = 0; i < StationCoutnt; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(stationList.get(i).getStationname() == null? "":stationList.get(i).getStationname());
			newcolmn.add(stationList.get(i).getProvince() == null? "":stationList.get(i).getProvince());
			newcolmn.add(stationList.get(i).getVolt() == null? "":stationList.get(i).getVolt());
			newcolmn.add(stationList.get(i).getLng() == null? "":stationList.get(i).getLng());
			newcolmn.add(stationList.get(i).getLat() == null? "":stationList.get(i).getLat());
			newcolmn.add(stationList.get(i).getRemark()==null?"":stationList.get(i).getRemark());
			newcolmn.add(stationList.get(i).getUpdatedate() == null? "":stationList.get(i).getUpdatedate());
			content.add(newcolmn);
		}
		if (StationCoutnt > 20000)// 每20000条数据写一个EXCEL
		{
			try {
				RealPath = this.getRealPath();
				zipfilePath = RealPath+ date;
				RealPath += date + "/";
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				List list[] = new List[StationCoutnt % 20000 == 0 ? StationCoutnt / 20000 + 1
						: StationCoutnt / 20000 + 2];
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
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			path = "exportExcel/"+ date + ".zip";
		} else {
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
		}
		return path;
	}



	/**
	 * 删除文件夹
	 * 
	 * */
	public boolean deleteDirectory(String sPath) {
		if (!sPath.endsWith(File.separator)) {
			sPath = sPath + File.separator;
		}
		File dirFile = new File(sPath);
		if (!dirFile.exists() || !dirFile.isDirectory()) {
			return false;
		}
		boolean flag = true;
		File[] files = dirFile.listFiles();
		for (int i = 0; i < files.length; i++) {
			if (files[i].isFile()) {
				flag = deleteFile(files[i].getAbsolutePath());
				if (!flag)
					break;
			} else {
				flag = deleteDirectory(files[i].getAbsolutePath());
				if (!flag)
					break;
			}
		}
		if (!flag)
			return false;
		if (dirFile.delete()) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 删除文件
	 * 
	 * */
	public boolean deleteFile(String sPath) {
		boolean flag = false;
		File file = new File(sPath);
		if (file.isFile() && file.exists()) {
			file.delete();
			flag = true;
		}
		return flag;
	}
	@SuppressWarnings("unchecked")
	public String ExportExcelCommon(String labels,String name, String[] titles,String[] columns,
			List list1) {
//		Date d = new Date();
		String path = null;// 返回到前台的路径
		List Content = new ArrayList();
//		HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
		String filename =date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
		int size = list1.size();
		CustomizedExcel oe = new CustomizedExcel(servletConfig);
		for (int i = 0; i < size; i++) {
			Map hashMap = (HashMap)list1.get(i);
			List newclomn = new ArrayList();
			for(int j=0;j<columns.length;j++){
				if(hashMap.get(columns[j])!=null)
				    newclomn.add(hashMap.get(columns[j]));
				else{
					newclomn.add("");
				}
			}
			Content.add(newclomn);
		}
		if (size > 20000)// 每20000条数据写一个EXCEL
		{
			try {
				RealPath = this.getRealPath();
				zipfilePath = RealPath+ date;
				RealPath += date + "/";
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				List list[] = new List[size % 20000 == 0 ? size / 20000 + 1
						: size / 20000 + 2];
				for (int i = 0; i < list.length - 1; i++) {
					CustomizedExcel ce = new CustomizedExcel(servletConfig);
					list[i] = Content
							.subList(
									i * 20000 + 1,
									(i + 1) * 20000 > Content.size() ? Content
											.size()
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
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			path = "exportExcel/" + date + ".zip";
		} else {
			try {
				RealPath = this.getRealPath();
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				oe.WriteExcel(RealPath + filename, labels, titles,
						Content);
			} catch (Exception e) {
				e.printStackTrace();
			}
			path = "exportExcel/" + filename;
		}
		return path;
	}
	

}
