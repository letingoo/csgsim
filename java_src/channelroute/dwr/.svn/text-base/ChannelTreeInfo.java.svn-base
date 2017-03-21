package channelroute.dwr;

import java.io.File;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import db.BaseDAO;

// TODO: Auto-generated Javadoc
/**
 * The Class ChannelTreeInfo.
 */
public class ChannelTreeInfo {
	
	/**
	 * Execute root for route.
	 * 
	 * @param flag the flag
	 * 
	 * @return the string
	 */
	public String executeRootForRoute(String flag) {

		StringBuffer root = new StringBuffer("[");

		try {

			//String pString[] = new String[] {"保护","安控", "自动化", "调度交换","行政交换" , "电视会议" ,"综合数据网" , "其他" };
			String pString[] = new String[] {"保护","安控", "自动化", "调度交换","行政交换" , "电视会议" ,"综合数据网" };
			String rootString[] = new String[] { "待提交方式", "已提交待执行方式", "归档方式" };
			int id = 1001;
			if (flag != null) {
				if (flag.equalsIgnoreCase("2")) {
					id = 2001;
					for (int i = 0; i < rootString.length; i++) {
						root.append("{id:" + id + ", text:'" + rootString[i]
								+ "', leaf:false, singleClickExpand:true}");
						root.append(",");
						id++;
					}
				}if(flag.equalsIgnoreCase("3")){
					id=3111;
						root.append("{id:" + id + ", text:'我的电路', leaf:false, singleClickExpand:true}");
						root.append(",");
				}
			} else {
				for (int i = 0; i < pString.length; i++) {
					root.append("{id:" + id + ", text:'" + pString[i]
							+ "', leaf:false, singleClickExpand:true}");
					root.append(",");
					id++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		root = new StringBuffer(root.substring(0, root.length() - 1));
		root.append("]");
		return root.toString();
	}

	/**
	 * Execute node for route.
	 * 
	 * @param textname the textname
	 * @param tid the tid
	 * @param request the request
	 * @param issystem the issystem
	 * @param response the response
	 * 
	 * @return the string
	 */
	public String executeNodeForRoute(String tid, String textname,
			HttpServletRequest request, HttpServletResponse response,
			String issystem) {
		StringBuffer node = new StringBuffer("[");
		String json = "";
		StringBuffer json_temp = new StringBuffer("[");

		try {
			request.setCharacterEncoding("UTF-8");
			String path = request.getRealPath(""); 
			boolean isprivate = false;
			if (issystem != null) {
				isprivate = true;
			} 

			if (!isprivate) {
				BaseDAO dao = new BaseDAO();
				Connection c = null;
				Statement s = null;
				ResultSet r = null;
				if(textname!=null&&!textname.equalsIgnoreCase("")){
				try{
                    String sql = "";
                    if(textname.contains("调度")){
                        textname = "调度电话";
                    }
				   if(!textname.equalsIgnoreCase("其他")){
                       sql = "select t.*,w.flag from circuit t,circuit_watch w where t.circuitcode like '%"+textname+"%' and t.circuitcode=w.circuitcode(+) order by t.circuitcode";
                   }else {
                       sql = "select t.*,w.flag from circuit t,circuit_watch w where t.circuitcode  not like '%保护%' and t.circuitcode not like '%安控%' and t.circuitcode not like '%自动化%' and t.circuitcode not like '%调度电话%' and t.circuitcode not like '%行政交换%' and t.circuitcode not like '%电视会议%' and t.circuitcode not like '%综合数据网%' and rownum<50 and t.circuitcode=w.circuitcode(+) order by circuitcode";
                   }
					c = dao.getConnection();
					s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
							ResultSet.CONCUR_READ_ONLY);
					r = s.executeQuery(sql);
					while (r.next()) {
						String circuitcode = r.getString("CIRCUITCODE");
                        String flag = r.getString("FLAG");
                        String cls="";
                        boolean change = false;
                        if(flag!=null&&flag.equalsIgnoreCase("1")){
                          cls ="channeltreecompare";
                          change = true;
                        }
						json_temp.append("{id:'" + circuitcode + "', text:'" + circuitcode
						                  								+ "', leaf:true,cls:'"+cls+"',change:"+change+" }");
						json_temp.append(",");
					}
					json_temp = new StringBuffer(json_temp.substring(0,json_temp.length()-1));
					json_temp.append("]");
					json = json_temp.toString();
					
				}catch(Exception e){
					e.printStackTrace();
				}finally{
					
				}
				}
				
			} 

			

			// response.setCharacterEncoding("UTF-8");
			response.setContentType("application/json");
			response.getWriter().write(json);

			response.getWriter().close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		node.append("]");

		return json;
	}

	/**
	 * 获取文件列表
	 * 
	 * @param tid the tid
	 * @param path the path
	 * 
	 * @return the views
	 */
	public String getViews(String path, String tid) {

		StringBuffer json_temp = new StringBuffer("[");

		String rootdir = path;

		File f = new File(rootdir);
		if (f.isDirectory()) {
			String[] array = f.list();
			int length = array.length;
			if (length == 0) {
				json_temp.append("]");
				return json_temp.toString();
			}
			for (int i = 0; i < length - 1; i++) {
				if(!array[i].contains("svn")){
				json_temp.append("{");
				if (tid.startsWith("2", 0)) {
					System.out.print("OKOKOK");
				}

				String a = tid + "0" + String.valueOf(i);
				json_temp.append("id:");
				json_temp.append(Integer.valueOf(a));
				json_temp.append(",");
				json_temp.append("text:'");
				
				json_temp.append(array[i].replace("&", "&amp;").replace(".xml",
						""));
				
				json_temp.append("'");
				json_temp.append(",");
				json_temp.append("iconCls:'");
				json_temp.append("sysorg-img");
				json_temp.append("',");
				json_temp.append("leaf:true},");
				}
			}
			if(!array[length - 1].contains("svn")){
			json_temp.append("{");
			String a = tid + "0" + String.valueOf(length);
			json_temp.append("id:");
			json_temp.append(Integer.valueOf(a));
			json_temp.append(",");
			json_temp.append("text:'");
			json_temp.append(array[length - 1].replace("&", "&amp;").replace(
					".xml", ""));
			json_temp.append("'");
			json_temp.append(",");
			json_temp.append("iconCls:'");
			json_temp.append("sysorg-img");
			json_temp.append("',");
			json_temp.append("leaf:true}]");
		}
		}
		return json_temp.toString();
	}
}
