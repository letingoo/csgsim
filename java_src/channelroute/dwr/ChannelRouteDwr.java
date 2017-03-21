package channelroute.dwr;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;

import jxl.write.WriteException;

import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ZipExcel;
import netres.model.ComboxDataModel;
import netres.model.ResultModel;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import resManager.resBusiness.model.BusinessRessModel;
import sysManager.log.dao.LogDao;

import channelroute.dao.ChannelRouteDAO;
import channelroute.model.ChannelRouteDetailModel;
import channelroute.model.Circuit;
import db.BaseDAO;
import flex.messaging.FlexContext;

public class ChannelRouteDwr {
	ChannelRouteDAO channelRouteDao;

	public ChannelRouteDAO getChannelRouteDao() {
		return channelRouteDao;
	}

	public void setChannelRouteDao(ChannelRouteDAO channelRouteDao) {
		this.channelRouteDao = channelRouteDao;
	}

	// public String getChannelRouteTree() {
	// return this.getChannelRouteName();
	//
	// }

	// public String getChannelRouteName() {
	// String pString[] = new String[] { "保护", "安控", "自动化", "调度交换", "行政交换",
	// "电视会议", "综合数据网" };
	// String xml = "";
	// String circuitType;
	// for (int i = 0; i < pString.length; i++) {
	// xml += "\n" + "<folder state='0' label='" + pString[i]
	// + "' leaf='false' root='1' >";
	// circuitType = pString[i];
	// if (circuitType == "调度交换") {
	// circuitType = "调度电话";
	// }
	// List<HashMap> leaflist = channelRouteDao
	// .getChannelRouteNames(circuitType);
	// for (HashMap lst : leaflist) {
	// String circuitcode = (String) lst.get("CIRCUITCODE");
	// xml += "\n" + "<folder state='0' label='" + circuitcode
	// + "' leaf='true' />";
	// }
	// xml += "\n" + "</folder>";
	// }
	// return xml;
	// }

	public ChannelRouteDetailModel getItems(String circuitcode) {
		ChannelRouteDetailModel model = (ChannelRouteDetailModel) channelRouteDao
				.getChannelRouteDetailModel(circuitcode);

		return model;
	}

	/**
	 * 取消电路重点监控
	 * 
	 * @param circuitcode
	 */
	public void delCircuitmonitoring(String circuitcode) {

		try {
			channelRouteDao.delCircuitmonitoring(circuitcode);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 添加电路重点监控
	 * 
	 * @param circuitcode
	 */
	public void addCircuitmonitoring(String circuitcode) {

		try {
			channelRouteDao.addCircuitmonitoring(circuitcode);

		} catch (Exception e) {
			e.printStackTrace();
		}

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

}
