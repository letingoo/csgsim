package slotGraph.dwr;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.metarnet.adapter.resource.RESUtil;

import slotGraph.dao.timeslotMapDAO;
import db.ForTimeBaseDAO;
import fiberwire.dao.FiberWireDAO;
import fiberwire.model.SystemInfoModel;
import flex.messaging.FlexContext;

/**
 * 时隙分布图
 * 
 * @author sunjter
 * 
 */
public class timeslotMapDwr {
	ApplicationContext ctx = WebApplicationContextUtils
	.getWebApplicationContext(FlexContext.getServletContext());
	ForTimeBaseDAO dao = new ForTimeBaseDAO();

	Connection con = null;
	Statement st = null;
	ResultSet rs = null;
	private timeslotMapDAO timeslotMapDao;
	private FiberWireDAO fiberWireDao=(FiberWireDAO) ctx.getBean("fiberWireDao");;

	public FiberWireDAO getFiberWireDao() {
		return fiberWireDao;
	}

	public void setFiberWireDao(FiberWireDAO fiberWireDao) {
		this.fiberWireDao = fiberWireDao;
	}

	public timeslotMapDAO getTimeslotMapDao() {
		return timeslotMapDao;
	}

	public void setTimeslotMapDao(timeslotMapDAO timeslotMapDao) {
		this.timeslotMapDao = timeslotMapDao;
	}

	/**获取系统组织图树
	 * @param str 当前选中的结点id
	 * @param type 当前选中的结点类型
	 * @return
	 */
	public String getTimeSlotMapTree(String str, String type)
	{
		String xml = "";
		try
		{
			if (type.equalsIgnoreCase("root")) //生成系统层
			{
				xml += "<list>";
				List<SystemInfoModel> lstSystem = this.fiberWireDao.getSystemTree();
						
				for (SystemInfoModel system : lstSystem)
				{
					
					xml += "<system name=\""
							+ system.getSystemname() + "\" id=\""
							+ system.getSystemcode()
							+ "\" isBranch=\"true\" type=\"system\">";
					xml += "</system>";
				}
				xml += "</list>";
			} 
			else if (type.equalsIgnoreCase("system"))
			{
				List<HashMap> lstRate = timeslotMapDao
						.getTimeSlotSecondLayerTreeNode(str);
				for (HashMap rate : lstRate) {
					xml += "<device name=\"" + rate.get("LINERATE").toString()
							+ "\"id=\"" + rate.get("LINERATEBM").toString()
							+ "\"systemcode=\"" + str
							+ "\" isBranch=\"true\" type=\"rate\"></device>";
				}
			}
			else if (type.equalsIgnoreCase("rate"))
			{
				List<HashMap> lstYewu = timeslotMapDao.getThirdLayerTreeNode(str);
				String str1 = str.split("-")[0];
				for (HashMap yewu : lstYewu) {
					xml += "<rate name=\"" + yewu.get("NODE").toString()
							+ "\"text=\"" + yewu.get("NODE").toString()
							+ "\"qtip=\"" + yewu.get("LABEL").toString()
							+ "\"port1=\"" + yewu.get("AENDPTP").toString()
							+ "\"port2=\"" + yewu.get("ZENDPTP").toString()
							+ "\"port1code=\""
							+ yewu.get("AENDPTPCODE").toString()
							+ "\"port2code=\""
							+ yewu.get("ZENDPTPCODE").toString()
							+ "\"equipa=\"" + yewu.get("EQUIPA").toString()
							+ "\"equipz=\"" + yewu.get("EQUIPZ").toString()
							+ "\" isBranch=\"false\" checked=\"0\" rate=\"" + str1
							+ "\">" + "</rate>";
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		return xml;
	}

	/**根据复用段id和速率进行逻辑处理
	 * @param id
	 * @param size
	 * @return
	 */
	public List getRoot(String id, int size) 
	{
		List ls = null;
		try 
		{
			con = dao.getConnection();
			String sql="";
			for (int i = 1; i <= size; i++) 
			{
				if(i>1)
				{
					sql+=" union ";
				}
				sql+= "select '"
						+ i
						+ "' as num,getuseinfobyport((select aendptp from en_topolink where label = '"
						+ id
						+ "' ),'"
						+ i
						+ "') as getuseinfobyport, GetCircuitByPort((select aendptp from en_topolink where label = '"
						+ id + "'),'" + i + "') as getcircuitbyport,getvcbyport((select aendptp from en_topolink where label = '"
						+ id + "'),'" + i + "') as getvcbyport from dual ";
				
			}
			sql = "select * from (" + sql + ") order by num*1";
			System.out.println(sql);
			PreparedStatement pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();

			ls = this.getList(rs);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.closeConnection(con, st, rs);
		}

		return ls;
	}

	public List getList(ResultSet rs) {
		List list = new ArrayList();
		try {
			ResultSetMetaData md = (ResultSetMetaData) rs.getMetaData();
			int count = md.getColumnCount();
			while (rs.next()) {
				Map rowData = new HashMap();
				for (int i = 1; i <= count; i++) {
					rowData.put(md.getColumnName(i), rs.getObject(i));
				}
				list.add(rowData);
			}
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	public List getSlot(String id, int innerid)      // inner-id为VC4的标记
	{		
		List list = null;
		// 根据VC4计算VC12时隙号
		int vc12start = (innerid - 1)*63 + 1;
		int vc12end = innerid*63;
		
		try 
		{
			con = dao.getConnection();
			st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			String sql = "select '"+ vc12start +"' as num, getvc12circuitbyport((select aendptp from en_topolink where label = '"+id+"' ),'"+vc12start+"') as Yewu from dual ";
			for (int tag = vc12start+1; tag <= vc12end; tag++) {
				sql = sql + "union select '"+ tag +"' as num, getvc12circuitbyport((select aendptp from en_topolink where label = '"+id+"' ),'"+tag+"') as Yewu from dual ";
			}
			sql = "select * from ("+sql+") order by num*1";
			System.out.println(new Date() + "sql:   "+sql);
			rs = st.executeQuery(sql);
			list = this.getList(rs);

		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.closeConnection(con, st, rs);
		}	
		return list;
	}
	
	
    public List getUsernamesByCircuitcodes(ArrayList<String> array){
		List list = new ArrayList();
		try {
			con = dao.getConnection();
			st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		} catch (Exception e) {
		}
		for(int i = 0;i<array.size();i++){
			String id = array.get(i).split("@@")[0];
			String circuitcode = array.get(i).split("@@")[1];
			String sql = "select USERNAME from circuit where circuitcode = '" + circuitcode + "'";
			try {
				rs = st.executeQuery(sql);
				while(rs.next()){
					String username = (String) rs.getObject(1);
					String r = id + "@@" + username;
					list.add(r);
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return list;
	}
	
	public List getRootTemp(String ids) // 根据复用段id和速率进行逻辑处理
	{
		List ls = new ArrayList();
		String[]resources = ids.split(",");//得到传递过来的A、Z端口和数量
		for(int i = 0; i < resources.length; i++){
			String id = resources[i].split("@")[0];
			int size = Integer.parseInt((resources[i].split("@")[1]));
			String[] ports = id.split("#");
			String port_a = ports[0];
			String port_z = ports[1];
			List list = null;
			try {
				con = dao.getConnection();
				String sql = " select '"
						+ 1
						+ "' as num,getuseinfobyport((select aendptp from en_topolink where label = '"
						+ id
						+ "' ),'"
						+ 1
						+ "') as getuseinfobyport, GetCircuitByPort((select aendptp from en_topolink where label = '"
						+ id + "'),'" + 1 + "') as getcircuitbyport,getequipcodebyportid('"+ port_a +"') as equipA," 
								+" getequipcodebyportid('"+ port_z +"') as equipZ,'"+ port_a +"' as portA, '"+ port_z +
								"' as portZ,getportlabelnew('"+ port_a +"') as portaname,getportlabelnew('"+ port_z +"') as portzname from dual ";
				for (int l = 2; l <= size; l++) {
					sql = sql
							+ "union select '"
							+ l
							+ "' as num,getuseinfobyport((select aendptp from en_topolink where label = '"
							+ id
							+ "' ),'"
							+ l
							+ "') as getuseinfobyport, GetCircuitByPort((select aendptp from en_topolink where label = '"
							+ id + "'),'" + l + "') as getcircuitbyport,getequipcodebyportid('"+ port_a +"') as equipA,"
							+" getequipcodebyportid('"+ port_z +"') as equipZ,'"+ port_a +"' as portA, '"+ port_z +
							"' as portZ,getportlabelnew('"+ port_a +"') as portaname,getportlabelnew('"+ port_z +"') as portzname from dual ";
				}
				sql = "select * from (" + sql + ") order by num*1";
				PreparedStatement pstmt = con.prepareStatement(sql);
				rs = pstmt.executeQuery();
				list = new ArrayList();
				list = this.getList(rs);
				ls.add(list);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				dao.closeConnection(con, st, rs);
			}
		}
		return ls;
	}
	
	public List getSlotTemp(String ids)      // inner-id为VC4的标记
	{	
		// 根据VC4计算VC12时隙号
		List ls = new ArrayList();
		String[]resources = ids.split(",");//得到传递过来的A、Z端口和数量
		for(int i = 0; i < resources.length; i++){
			String id = resources[i].split("@")[0];
			int innerid = Integer.parseInt((resources[i].split("@")[1]));
			String[] ports = id.split("#");
			String port_a = ports[0];
			String port_z = ports[1];
			List list = null;
			int vc12start = (innerid - 1)*63 + 1;
			int vc12end = innerid*63;
			try 
			{
				con = dao.getConnection();
				st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				String sql = "select '"+ vc12start +"' as num, GetVC12CircuitByPortForFS((select aendptp from en_topolink where label = '"+id+"' ),'"+vc12start+"') as Yewu,getequipcodebyportid('"+ port_a +"') as equipA," +
						"getequipcodebyportid('"+ port_z +"') as equipZ,'"+ port_a +"' as portA, '"+ port_z +"' as portZ,'"+ innerid +"' as id,getportlabelnew('"+ port_a +"') as portaname,getportlabelnew('"+ port_z +"') as portzname from dual ";
				for (int tag = vc12start+1; tag <= vc12end; tag++) {
					sql = sql + "union select '"+ tag +"' as num, GetVC12CircuitByPortForFS((select aendptp from en_topolink where label = '"+id+"' ),'"+tag+"') as Yewu,getequipcodebyportid('"+ port_a +"') as equipA," +
					"getequipcodebyportid('"+ port_z +"') as equipZ,'"+ port_a +"' as portA, '"+ port_z +"' as portZ,'"+ innerid +"' as id,getportlabelnew('"+ port_a +"') as portaname,getportlabelnew('"+ port_z +"') as portzname from dual ";
				}
				sql = "select * from ("+sql+") order by num*1";
				rs = st.executeQuery(sql);
//				System.out.println(sql);
				list = this.getList(rs);
				ls.add(list);
			}
			catch (Exception e) {
				e.printStackTrace();
			} finally {
				dao.closeConnection(con, st, rs);
			}	
		}
		return ls;
	}
	
}
