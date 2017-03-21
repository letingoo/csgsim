package ocableResources.component;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;

import jxl.write.WriteException;

import ocableResources.dao.OcableResourcesDAO;
import ocableResources.model.FiberDetailsModel;
import netres.model.EquipFrame;
import netres.model.EquipPack;
import netres.model.EquipSlot;
import netres.model.Equipment;
import netres.model.LogicPort;
import netres.model.Ocables;
import netres.model.Problems;
import netres.model.StationModel;
import flex.messaging.FlexContext;

public class ExportExcel {
	/**
	 * 导出Excel的函数
	 * 
	 * @luoshuai labels：导出EXCEL的标题 titles:导出EXCEL的字段名 types:导出数据的类型
	 * */
	private OcableResourcesDAO mapDao;

	/**
	 * 构造函数
	 * */
	public ExportExcel(OcableResourcesDAO mapDao) {
		this.mapDao = mapDao;
	}

	public ExportExcel() {

	}

	/**
	 * 获取时间的函数
	 * */
	public static String getName() {
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		return sDateFormat.format(new java.util.Date());
	}

	/**
	 * 获取文件路径
	 * */
	public String getRealPath() {
		String RealPath = null;// 绝对路径
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
		RealPath = fullPath.substring(0, fullPath.indexOf("WEB-INF"));
		RealPath += "exportExcel/";
		return RealPath;
	}

	/**
	 * 光纤业务信息
	 * 
	 * */
	public String ExportEXCEL(String labels, String[] titles,
			FiberDetailsModel fdm,String types) {
		Date d = new Date();
		String path = null;// 返回到前台的路径
		List content = null;
		HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
		String filename = types + "-" + date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
		List<FiberDetailsModel> datalist = mapDao.getFiberDetails(fdm);
//		int fiberCoutnt = mapDao.getFiberDetailsConnt(fdm);
		content = new ArrayList();
		List<FiberDetailsModel> fiberlist = new ArrayList<FiberDetailsModel>();
		for(int i = 0; i < datalist.size(); i++){
			if(!datalist.get(i).getIsmerge()){
				for(int j = i+1; j < datalist.size(); j++){
					if(!datalist.get(i).getAendeqport().equals(" ") && !datalist.get(j).getAendeqport().equals(" ") &&
							datalist.get(i).getAendeqport().equals(datalist.get(j).getAendeqport()) && 
							datalist.get(i).getZendeqport().equals(datalist.get(j).getZendeqport())){
						datalist.get(i).setFiberserial(datalist.get(i).getFiberserial()+"，" + datalist.get(j).getFiberserial());
						datalist.get(j).setIsmerge(true);
						fiberlist.add(datalist.get(i));
						break;
					}
				}
				if(!datalist.get(i).getAendeqport().equals(" ") && !datalist.get(i).getZendeqport().equals(" ")){
					fiberlist.add(datalist.get(i));
				}
			}
		}
		if(fiberlist == null || fiberlist.size() <= 0)
			return "";
		int fiberCoutnt = fiberlist.size();
		for (int i = 0; i < fiberlist.size(); i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(fiberlist.get(i).getFiberserial());
			newcolmn.add(fiberlist.get(i).getOcablesectionname());
			newcolmn.add(fiberlist.get(i).getAendeqport());
			newcolmn.add(fiberlist.get(i).getZendeqport());
			newcolmn.add(fiberlist.get(i).getAequip());
			newcolmn.add(fiberlist.get(i).getZequip());
			newcolmn.add(fiberlist.get(i).getRemark());
			content.add(newcolmn);
		}
		if (fiberCoutnt > 20000)// 每20000条数据写一个EXCEL
		{
			try {
				RealPath = this.getRealPath();
				zipfilePath = RealPath+ date;
				RealPath += date + "/";
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				List list[] = new List[fiberCoutnt % 20000 == 0 ? fiberCoutnt / 20000 + 1
						: fiberCoutnt / 20000 + 2];
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
			path = "exportExcel/" + date + ".zip";
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
	 * 光纤详细信息
	 * 
	 * */
	public String ExportExcelInfo(String labels, String[] titles,
			FiberDetailsModel fdm,String types) {
		Date d = new Date();
		String path = null;// 返回到前台的路径
		List content = null;
		HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
		String filename = types + "-" + date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
		List<FiberDetailsModel> datalist = mapDao.getALLFiberDetails(fdm);
		int fiberCoutnt = mapDao.getFiberDetailsConnt(fdm);
		content = new ArrayList();
		for (int i = 0; i < fiberCoutnt; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(datalist.get(i).getFiberserial());
			newcolmn.add(datalist.get(i).getOcablesectionname());
			newcolmn.add(datalist.get(i).getLength());
			newcolmn.add(datalist.get(i).getProperty());
			newcolmn.add(datalist.get(i).getAequip());
			newcolmn.add(datalist.get(i).getZequip());
			newcolmn.add(datalist.get(i).getAendeqport());
			newcolmn.add(datalist.get(i).getZendeqport());
			newcolmn.add(datalist.get(i).getRemark());
			content.add(newcolmn);
		}
		if (fiberCoutnt > 20000)// 每20000条数据写一个EXCEL
		{
			try {
				RealPath = this.getRealPath();
				zipfilePath = RealPath+ date;
				RealPath += date + "/";
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				List list[] = new List[fiberCoutnt % 20000 == 0 ? fiberCoutnt / 20000 + 1
						: fiberCoutnt / 20000 + 2];
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
			path = "exportExcel/" +  date + ".zip";
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
}
