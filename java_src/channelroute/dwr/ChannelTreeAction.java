package channelroute.dwr;
import indexEvaluation.model.DateUtil;

import java.awt.geom.Point2D;
import java.io.IOException;
import java.io.Writer;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.web.context.support.WebApplicationContextUtils;
import sysManager.user.model.UserModel;
import twaver.Consts;
import twaver.ElementBox;
import twaver.Follower;
import twaver.IElement;
import twaver.Link;
import twaver.Node;
import twaver.SerializationSettings;
import twaver.XMLSerializer;
import channelroute.model.CCTmpModel;
import channelroute.model.ChannelRouteContent;
import channelroute.model.Circuit;
import channelroute.model.CircuitroutModel;
import channelroute.model.PositionModel;
import channelroute.model.SQLHelper;
import channelroute.model.StringUtil;
import com.AppointStrToStr;
import com.sun.org.apache.xml.internal.security.utils.Base64;
import db.BaseDAO;
import db.DbDAO;
import db.ForTimeBaseDAO;
import db.NewBaseDAO;
import equipPack.model.OpticalPortStatusModel;
import faultSimulation.dwr.ScenePrjDwr;
import fiberwire.dao.FiberWireDAO;
import flex.messaging.FlexContext;
import flex.messaging.FlexSession;

// TODO: Auto-generated Javadoc
/**
 * 此方法中包含电路路由图中的树，还有部分小图标的功能，如：保存，另存.
 */
public class ChannelTreeAction {

	/**
	 * 登陆用户对象
	 */
	ApplicationContext ctx = WebApplicationContextUtils
			.getWebApplicationContext(FlexContext.getServletContext());
	private SqlMapClientTemplate sqlMapClientTemplate;
	private DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");
	private FiberWireDAO fdao = (FiberWireDAO) ctx.getBean("fiberWireDao");
	private final static Log log = LogFactory.getLog(ChannelTreeAction.class);

	public SqlMapClientTemplate getSqlMapClientTemplate() {
		return sqlMapClientTemplate;
	}

	public void setSqlMapClientTemplate(
			SqlMapClientTemplate sqlMapClientTemplate) {
		this.sqlMapClientTemplate = sqlMapClientTemplate;
	}

	/**
	 * 电路路由图左侧面板树
	 * 
	 * @return xml
	 */
	public String TreeRouteAction() {
		String xml = "";
		try {
			List list = sqlMapClientTemplate.queryForList("getChannelTreeData",
					null);
			if (list != null && list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {
					Map rMap = (HashMap) list.get(i);
					xml += "\n"
							+ "<folder state='0' label='"
							+ (String) rMap.get("XTXX")
							+ "' disabled=\"true\"  isBranch=\"true\" leaf='false' >";
					String textname = (String) rMap.get("XTXX");
					String sql = "";
					sql = "select t.*,w.flag from circuit t,circuit_watch w where t.username like '%"
							+ textname
							+ "%' and t.circuitcode=w.circuitcode(+) and t.circuitcode not in (select circuitcode from circuit_content) order by t.circuitcode";
					ForTimeBaseDAO dao = new ForTimeBaseDAO();
					Connection c = null;
					Statement s = null;
					ResultSet r = null;
					c = dao.getConnection();
					s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
							ResultSet.CONCUR_READ_ONLY);
					r = s.executeQuery(sql);
					while (r.next()) {
						String circuitcode = r.getString("CIRCUITCODE");
						String flag = r.getString("FLAG");
						String ismonitored = r.getString("ISMONITORED");
						String cls = "";
						boolean change = false;
						if (flag != null && flag.equalsIgnoreCase("1")) {
							cls = "channeltreecompare";
							change = true;
						}
						xml += "\n" + "<folder state='0' label='" + circuitcode
								+ "' ismonitored='" + ismonitored
								+ "'isBranch=\"false\" leaf='true' />";

					}
					xml += "\n" + "</folder>";

				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return xml;
	}
	/**
	 *因南网目前数据量大，考虑异步加载
	 * @param circuitcode1 电路编号
	 * @param requisitionid1 申请单号
	 * @param username1 业务名称
	 * @param operationtype1 操作类型
	 * @param rate1 速率
	 * @param state1 状态
	 * @param nodeType 结点类型
	 * @return
	 * @throws Exception
	 * @author jtsun
	 */
 @SuppressWarnings("unchecked")
public String TreeRouteActionForAsynch(String circuitcode1,
			String requisitionid1, String username1, String operationtype1,
			String rate1, String state1,String nodeType,String xtxx) throws Exception{
	 String xml = "";
	 if(nodeType.equalsIgnoreCase("root"))
	 {
		 try 
		 {
			 HashMap m = new HashMap();
				m.put("circuitcode", circuitcode1);
				m.put("requisitionid", requisitionid1);
				m.put("username", username1);
				m.put("operationtype", operationtype1);
				m.put("rate", rate1);
				m.put("state", state1);
				List list = sqlMapClientTemplate.queryForList("getNewTree", m);//获取电路路由图树的所有业务类型
				if (list != null && list.size() > 0) 
				{
					for (int i = 0; i < list.size(); i++)
					{
						Map rMap = (HashMap) list.get(i);
						xml += "\n"
								+ "<folder state='0' label='"
								+ (String) rMap.get("XTXX")
								+ "' disabled=\"true\"  isBranch=\"true\" leaf='false' ></folder>";
					}
				}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return xml;
	 }
	 if(nodeType.equalsIgnoreCase("leaf"))
	 {
			Connection c = null;
			Statement s = null;
			ResultSet r = null;
		 try
		 {
			 StringBuffer sql = new StringBuffer();
				if(xtxx.equalsIgnoreCase("PCM"))
				{
					sql.append("select * from v_circuit_topolink_type_nw where xtxx ='"+xtxx+"'");
				}
				else
				{
					sql.append("select * from v_circuit_topolink_type_nw where xtxx like '%"
							+ xtxx + "%'");
				}
				if (StringUtil.isNotEmpty(circuitcode1)) {
					sql.append(" and circuitcode like '%" + circuitcode1
							+ "%'");
				}
				if (StringUtil.isNotEmpty(requisitionid1)) {
					sql.append(" and requisitionid like '%"
							+ requisitionid1 + "%'");
				}
				if (StringUtil.isNotEmpty(operationtype1)) {
					sql.append(" and operationtype = '" + operationtype1
							+ "'");
				}
				if (StringUtil.isNotEmpty(rate1)) {
					sql.append(" and getxtbm(decode(rate,'64K',rate||'/s', '128K',rate||'/s',rate||'b/s'),'YW')  = '" + rate1 + "'");
				}
				if (StringUtil.isNotEmpty(state1)) {
					sql.append(" and state = '" + state1 + "'");
				}
//				if (StringUtil.isNotEmpty(username1)) {
//					sql.append(" and username = '" + username1 + "'");
//				}
				ForTimeBaseDAO dao = new ForTimeBaseDAO();

				c = dao.getConnection();
				s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
				r = s.executeQuery(sql.toString());
				while (r.next()) 
				{
					String circuitcode = r.getString("CIRCUITCODE");
					String ismonitored = r.getString("ISMONITORED");
					xml += "\n" + "<folder state='0' label='" + circuitcode
							+ "' ismonitored='" + ismonitored
							+ "'isBranch=\"false\" leaf='true' />";
				}
		} 
	    catch (Exception e)
	   {
	    	e.printStackTrace();
	   }
	   finally
	   {
			SQLHelper.close(r);
			SQLHelper.close(s);
			SQLHelper.close(c);
	   }
		return xml;
	 }
	return null;
	
 }
	/**
	 * 经过过滤条件重新加载，电路路由图左侧面板树byxujiao
	 * 
	 * @return xml
	 */
	public String TreeRouteActionNew(String circuitcode1,
			String requisitionid1, String username1, String operationtype1,
			String rate1, String state1) throws Exception {
//		System.out.println(circuitcode1);
//		System.out.println(requisitionid1);
//		System.out.println(username1);
//		System.out.println(operationtype1);
//		System.out.println(rate1);
//		System.out.println(state1);
//		if(username1=="---全部---"){
//			username1=null;
//		}
//		if(operationtype1=="---全部---"){
//			operationtype1=null;
//		}
		String xml = "";
		Connection c = null;
		Statement s = null;
		ResultSet r = null;
		try {

			Map m = new HashMap();
			m.put("circuitcode", circuitcode1);
			m.put("requisitionid", requisitionid1);
			m.put("username", username1);
			m.put("operationtype", operationtype1);
			m.put("rate", rate1);
			m.put("state", state1);
			System.out.println(m);
			List list = sqlMapClientTemplate.queryForList("getNewTree", m);
			if (list != null && list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {
					Map rMap = (HashMap) list.get(i);
					xml += "\n"
							+ "<folder state='0' label='"
							+ (String) rMap.get("XTXX")
							+ "' disabled=\"true\"  isBranch=\"true\" leaf='false' >";
					String textname = (String) rMap.get("XTXX");
					StringBuffer sql = new StringBuffer();
					if(textname.equalsIgnoreCase("PCM")){
						sql.append("select * from v_circuit_topolink_type_nw where xtxx ='"+textname+"'");
					}else{
						sql.append("select * from v_circuit_topolink_type_nw where xtxx like '%"
								+ textname + "%'");
					}
					if (StringUtil.isNotEmpty(circuitcode1)) {
						sql.append(" and circuitcode like '%" + circuitcode1
								+ "%'");
					}
					if (StringUtil.isNotEmpty(requisitionid1)) {
						sql.append(" and schedulerid like '%"
								+ requisitionid1 + "%'");
					}
					if (StringUtil.isNotEmpty(operationtype1)) {
						sql.append(" and operationtype = '" + operationtype1
								+ "'");
					}
					if (StringUtil.isNotEmpty(rate1)) {
						sql.append(" and getxtbm(decode(rate,'64K',rate||'/s', '128K',rate||'/s',rate||'b/s'),'YW') = '" + rate1 + "'");
					}
					if (StringUtil.isNotEmpty(state1)) {
						sql.append(" and state = '" + state1 + "'");
					}
					if (StringUtil.isNotEmpty(username1)) {
						sql.append(" and username = '" + username1 + "'");
					}
//					System.out.println(sql);
					ForTimeBaseDAO dao = new ForTimeBaseDAO();

					c = dao.getConnection();
					s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
							ResultSet.CONCUR_READ_ONLY);
					r = s.executeQuery(sql.toString());
					while (r.next()) {
						String circuitcode = r.getString("CIRCUITCODE");
						String flag = r.getString("FLAG");
						String ismonitored = r.getString("ISMONITORED");
						String cls = "";
						boolean change = false;
						if (flag != null && flag.equalsIgnoreCase("1")) {
							cls = "channeltreecompare";
							change = true; 
						}
						xml += "\n" + "<folder state='0' label='" + circuitcode
								+ "' ismonitored='" + ismonitored
								+ "'isBranch=\"false\" leaf='true' />";
					}
					xml += "\n" + "</folder>";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			SQLHelper.close(r);
			SQLHelper.close(s);
			SQLHelper.close(c);

		}
//		System.out.println(xml);
		return xml;
	}

	/**
	 * 给设备、端口前面补0，补齐20位,可以写的通用点,再传一个需要补的字符串和长度.
	 * 
	 * @param string
	 *@return string
	 */
	public String lpad(String str) { // 给设备、端口前面补0，补齐20位,可以写的通用点,再传一个需要补的字符串和长度.
		if (str != null && !str.equalsIgnoreCase("")) {
			str = "00000000000000000" + str;
			str = str.substring(str.length() - 20);
		}
		return str;
	}

	/**
	 * 根据设备编号获取局站 编号
	 * 
	 * @param string
	 *@return string
	 */
	public String getStationcode(String equipcode) {
		String stationcode = "";
		Map paraMap = new HashMap();
		paraMap.put("equipcode", equipcode);
		stationcode = (String) basedao
				.queryForObject("getStationCode", paraMap);
		return stationcode;
	}

	public void getCircuitCode(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String logicport = lpad(request.getParameter("logicport"));
		String circuitcode = null;
		Map paraMap = new HashMap();
		paraMap.put("logicport", logicport);
		circuitcode = (String) basedao.queryForObject(
				"getCircuitCodeByPortCodeForTandem", paraMap);
		response.getWriter().write(circuitcode != null ? circuitcode : "");
		response.getWriter().close();
	}

	public void channelcompareTree(HttpServletRequest request,
			HttpServletResponse response) throws IOException, ServletException {
		String pString[] = new String[] { "保护", "安控", "自动化", "调度交换", "行政交换",
				"电视会议", "综合数据网", "其他" };
		StringBuffer sb = new StringBuffer("[");
		for (int i = 0; i < pString.length; i++) {
			sb.append("{id:'" + pString[i] + "', text:'" + pString[i]
					+ "', leaf:true, checked:false}");
			sb.append(",");
		}
		sb = new StringBuffer(sb.substring(0, sb.length() - 1));
		sb.append("]");
		response.getWriter().write(sb.toString());
		response.getWriter().close();
	}

	public void getCircuitChangeNum(HttpServletRequest request,
			HttpServletResponse response) throws IOException, ServletException {
		Map paraMap = new HashMap();
		paraMap.put("flag", "1");
		String num = (String) basedao.queryForObject("getCircuitChangeNum",
				paraMap);
		if (num != null) {
			response.getWriter().write(num);
		} else {
			response.getWriter().write("0");
		}

	}
	/**
	 * 
	 * @param circuitcode 电路编号或者起始端口编号
	 * @param xml
	 * @param bytearray
	 * @param flag
	 * @return
	 */

	public String saveChannelRoute(String circuitcode, String xml,
			byte[] bytearray, String flag) {
		String issuccess = "false";

		ChannelRouteContent content = new ChannelRouteContent();
		content.setCircuitcode(circuitcode);
		content.setContent("empty_clob()");
		content.setCircuitpic("empty_clob()");
		content.setUserid(" ");
		content.setType(" ");
		String table = "";
		Map map = new HashMap();

		ForTimeBaseDAO dao = new ForTimeBaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet r = null;
		try {

			if (flag != null && flag.equalsIgnoreCase("nocc")) {
				table = "CHANNELROUTENOCC_CONTENT";//表不存在
				content.setTable("CHANNELROUTENOCC_CONTENT");
				map.put("table", "CHANNELROUTENOCC_CONTENT");
			} else {
				table = "CHANNELROUTE_CONTENT";
				content.setTable("CHANNELROUTE_CONTENT");
				map.put("table", "CHANNELROUTE_CONTENT");
			}
			Object newkey = null;

			map.put("circuitcode", circuitcode);
			sqlMapClientTemplate.delete("deleteChannelRouteByCircuitcodeflex",
					map);

			newkey = sqlMapClientTemplate.insert(
					"insertChannelrouteContentflex", content);
			int id = 0;
			if (newkey != null) {
				id = Integer.valueOf(String.valueOf(newkey));
			}

			String sql = "select content from " + table
					+ " where id=" + id + " for update";

			c = dao.getConnection();
			c.setAutoCommit(false);
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			r = s.executeQuery(sql);
			oracle.sql.CLOB osc = null;// 初始化一个空的clob对象
			oracle.sql.CLOB osc_clob = null;
			if (r.next()) {
				osc = (oracle.sql.CLOB) r.getClob("content");

				Writer w = osc.getCharacterOutputStream();// 使用字符输出流
				w.write(xml);// 将字符串str_text写到流中
				w.flush();// 输出流中数据，大概是正式向clob中写了
				w.close();

//				if (bytearray != null) {
//					osc_clob = (oracle.sql.CLOB) r.getClob("circuitpic");
//					Writer w1 = osc_clob.getCharacterOutputStream();// 使用字符输出流
//
//					w1.write(Base64.encode(bytearray));// 将字符串str_text写到流中
//					w1.flush();// 输出流中数据，大概是正式向clob中写了
//					w1.close();
//				}

				c.commit();// 执行
				issuccess = "true";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.closeConnection(c, s, r);
		}
		if (flag != null && flag.equalsIgnoreCase("nocc")) {
			insertPosition(circuitcode, xml, "channelnocc_element_position");//表不存在
		} else {
			insertPosition(circuitcode, xml, "channel_element_position");
		}
		return issuccess;
	}

	/**
	 * 手动关联方式
	 * 
	 * @param Circuit
	 *@return string(电路编号)
	 */
	public String relateCircuit(Circuit circuit_param, String xml,
			boolean isReplace) {
		//isReplace为true时，表示新建业务并关联，否则表示修改当前业务
		String native_circuitcode = circuit_param.getCircuitcode();
		Circuit circuit = new Circuit();// 方式对象
		circuit = circuit_param;
		try {
			circuit.setCircuitcode(native_circuitcode);
			if("".equals(circuit_param.getPortserialno1())||circuit_param.getPortserialno1()==null){
				List<Circuit> lst = this.getSqlMapClientTemplate().queryForList("getCircuitLstByCode",circuit_param.getPowerline());
				circuit.setSlot1(lst.get(0).getSlot1());
				circuit.setSlot2(lst.get(lst.size()-1).getSlot2());
				circuit.setPortserialno1(lst.get(0).getPortserialno1());
				circuit.setPortserialno2(lst.get(lst.size()-1).getPortserialno2());
				circuit.setPortcode1(lst.get(0).getPortserialno1());
				circuit.setPortcode2(lst.get(lst.size()-1).getPortserialno2());
			}
			String creattime = circuit.getCreatetime();
			if(creattime==null||"".equals(creattime)||creattime.length()<2){
				creattime = DateUtil.getDateString(new Date(), "yyyy-MM-dd");
			}
			circuit.setCreatetime(creattime);
			//更新电路、业务、电路业务关系信息
			if (isReplace)
				{//新增
					//更新电路
					//查询电路表中是否有，没有就插
					
					String code = (String) sqlMapClientTemplate.queryForObject("getCircuitcodeByCircuitcode",native_circuitcode);
					if(code==null||"".equals(code)){
						sqlMapClientTemplate.insert(
								"insert_updateCircuitForRelateCircuit", circuit);
					}
					
					//更新电路表
					sqlMapClientTemplate.insert("updateCircuitForRelateCircuit",circuit);
					
					//更新业务
					String X_purpose = circuit.getUsername();
					circuit.setX_purpose((String)this.getSqlMapClientTemplate().queryForObject("getX_purposeCode",X_purpose));
					String busi_id = (String) sqlMapClientTemplate.insert("insertBusinessForRelateCircuit",circuit);
					circuit.setCircuitcode_bak(busi_id);
					//更新电路业务关系
					sqlMapClientTemplate.insert("insertBusi_circuitForRelateCircuit",circuit);
					//更新路由表电路编号信息
					sqlMapClientTemplate.insert("updateCircuit_ccForRelateCircuit",circuit);
					//更新端口表中的电路编号字段，如果A端口同时是2条以上电路的起始点，该怎么处理？（解决方法：一个2M端口只能跑一条业务）
					sqlMapClientTemplate.insert("updateEquiplogicportForRelateCircuit",circuit);
					
					//修改电路表中的主备路由字段
					//1、查找路由表
					String circuitcode = circuit.getCircuitcode();
					resManager.resBusiness.model.Circuit key = (resManager.resBusiness.model.Circuit) sqlMapClientTemplate.queryForObject("getCircuitByCircuitcode1", circuitcode);
					String startEquip = key.getPortcode1();
					String endEquip = key.getPortcode2();
					if (!"".equals(startEquip) && startEquip != null
							&& !"".equals(endEquip) && endEquip != null) {
						List<CircuitroutModel> routlst = sqlMapClientTemplate.queryForList("selectCircuitroutLstByCircuitcode", circuitcode);
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
						sqlMapClientTemplate.update("updateCircuitRouteByMap", map);

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
				
				else {//修改
					//更新电路表
					sqlMapClientTemplate.insert("updateCircuitForRelateCircuit",circuit);
					//更新业务表,通过state字段
					sqlMapClientTemplate.insert("updateBusinessForRelateCircuit", circuit);
//					//更新电路业务关系表
//					sqlMapClientTemplate.insert("updateBusi_circuitForRelateCircuit", circuit);
//					
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
//		if (circuit != null) {
//			//有问题
//			insertCCTmp(circuit.getCircuitcode(), xml);
//		}
		return circuit.getCircuitcode();
	}

	private String getShortRage(String rate) {
		if (rate != null && !rate.equalsIgnoreCase("")) {
			String ratename = (String) sqlMapClientTemplate.queryForObject(
					"selectXtxxByXtbm", rate);
			if (ratename != null) {
				if (ratename.equals("2Mb/s")) {
					return "2M";
				} else if (ratename.equals("45Mb/s")) {
					return "45M";
				} else if (ratename.equals("155Mb/s")) {
					return "155M";
				} else if (ratename.equals("622Mb/s")) {
					return "622M";
				} else if (ratename.equals("1.25Gb/s")) {
					return "1.25G";
				} else if (ratename.equals("2.5Gb/s")) {
					return "2.5G";
				} else if (ratename.equals("10Gb/s")) {
					return "10G";
				} else if (ratename.equals("34Mb/s")) {
					return "34M";
				} else if (ratename.equals("64Kb/s")) {
					return "64K";
				} else if (ratename.equals("10Mb-100Mb/s")) {
					return "10/100M";
				} else if (ratename.equals("N*2Mb/s")) {
					return "2NM";
				} else if (ratename.equals("N*155Mb/s")) {
					return "155NM";
				} else if (ratename.equals("其它")) {
					return "其它";
				} else {
					return "其他";
				}
			} else {
				return "其他";
			}
		} else {
			return "其他";
		}
	}

	public boolean insertPosition(String circuitcode, String xml, String table) {
		if (circuitcode != null && xml != null
				&& !circuitcode.equalsIgnoreCase("")
				&& !xml.equalsIgnoreCase("")) {
			try {

				Map map = new HashMap();
				map.put("circuitcode", circuitcode);
				map.put("table", table);
				sqlMapClientTemplate.delete("deletePositionByCircuitcode", map);
				ElementBox box = new ElementBox();
				XMLSerializer serializer = new XMLSerializer(box);
				SerializationSettings.registerGlobalClient("flag",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("isbranch",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("position",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("equipcode",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("portcode",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("topoid",
						Consts.TYPE_STRING);
				box.clear();
				serializer = new XMLSerializer(box);
				// System.out.println(xml);
				serializer.deserializeXML(xml);
				for (int i = 0; i < box.getCount(); i++) {
					IElement iet = (IElement) box.getDatas().get(i);

					String flag = (String) iet.getClient("flag");
					if (flag != null) {
						if (flag.equalsIgnoreCase("equipment")) {
							Node node = (Node) iet;
							PositionModel model = new PositionModel();
							model.setCircuitcode(circuitcode);
							model.setFlag("equipment");
							Point2D point2d = node.getLocation();
							model.setX(String.valueOf(point2d.getX()));
							model.setY(String.valueOf(point2d.getY()));
							model.setEquipcode(node.getClient("equipcode")
									.toString());
							model.setLogicport("");
							model.setSlot("");
							model.setPosition("");
							model.setTable(table);
							sqlMapClientTemplate.insert("inertChannelPosition",
									model);
						} else if (flag.equalsIgnoreCase("port")) {
							Follower follower = (Follower) iet;
							PositionModel model = new PositionModel();
							String portcode = follower.getClient("portcode")
									.toString().split(",")[0];
							String slot = follower.getClient("portcode")
									.toString().split(",")[1];
							model.setCircuitcode(circuitcode);
							model.setLogicport(portcode);
							model.setSlot(slot);
							model.setX(String.valueOf(follower.getLocation()
									.getX()));
							model.setY(String.valueOf(follower.getLocation()
									.getY()));
							model.setFlag("port");
							model.setEquipcode("");
							model.setPosition(follower.getClient("position")
									.toString());
							model.setTable(table);
							sqlMapClientTemplate.insert("inertChannelPosition",
									model);
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			return false;
		}
		return true;
	}

	public boolean insertCCTmp(String circuitcode, String xml) {
		if (circuitcode != null && xml != null
				&& !circuitcode.equalsIgnoreCase("")
				&& !xml.equalsIgnoreCase("")) {
			try {

				Map paramap = new HashMap();
				paramap.put("circuitcode", circuitcode);
				sqlMapClientTemplate.delete("deleteCCTmp", paramap);
				ElementBox box = new ElementBox();
				XMLSerializer serializer = new XMLSerializer(box);
				SerializationSettings.registerGlobalClient("flag",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("isbranch",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("position",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("equipcode",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("portcode",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("topoid",
						Consts.TYPE_STRING);
				SerializationSettings.registerGlobalClient("rate",
						Consts.TYPE_STRING);
				box.clear();
				serializer = new XMLSerializer(box);
				// System.out.println(xml);
				serializer.deserializeXML(xml);
				for (int i = 0; i < box.getCount(); i++) {
					IElement iet = (IElement) box.getDatas().get(i);
					String flag = (String) iet.getClient("flag");
					if (flag != null) {
						if (flag.equalsIgnoreCase("cc")) {
							Link link = (Link) iet;
							Follower from_follower = (Follower) link
									.getFromNode();
							Follower to_follower = (Follower) link.getToNode();
							CCTmpModel model = new CCTmpModel();
							String aptp = from_follower.getClient("portcode")
									.toString().split(",")[0];
							String aslot = from_follower.getClient("portcode")
									.toString().split(",")[1];
							String zptp = to_follower.getClient("portcode")
									.toString().split(",")[0];
							String zslot = to_follower.getClient("portcode")
									.toString().split(",")[1];
							String equipcode = from_follower.getHost().getID()
									.toString();
							model.setAptp(aptp);
							model.setAslot(aslot);
							model.setReal_aslot("");
							model.setReal_rate("");
							model.setReal_zslot("");
							model.setCircuitcode(circuitcode);
							model.setZptp(zptp);
							model.setZslot(zslot);
							model.setPid(equipcode);
							model.setRate(link.getClient("rate").toString());
							model.setType("");
							model.setUpdateperson("");
							String direction = "";
							model.setDirection(direction);
							sqlMapClientTemplate.insert("insertCCTmpflex",
									model);

						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			return false;
		}
		return true;
	}

	/**
	 * 通过申请单关联方式
	 * 
	 * @param Circuit
	 *@return string(电路编号)
	 */
	public String relateCircuit1(Circuit circuit_param, String xml) {
		String native_circuitcode = circuit_param.getCircuitcode();
		Circuit circuit = new Circuit();// 方式对象
		circuit = circuit_param;
		try {
			String operationType = "";
			operationType = circuit_param.getOperationtype();

			Map paraMap = new HashMap();
			paraMap.put("operationType", operationType);
			String level = (String) sqlMapClientTemplate.queryForObject(
					"getCircuitLevel1", paraMap);
			if (level != null)
				circuit.setCircuitLevel(Integer.valueOf(level));
			String operationKind = "";
			if (operationType != null) {
				if (operationType.contains("-")) {
					operationKind = operationType.substring(0, operationType
							.indexOf("-"));
					operationType = operationType.substring(operationType
							.indexOf("-") + 1, operationType.length());
				} else {
					operationKind = operationType;
				}
			}
			String rate = circuit_param.getRate();
			String type = "YW";
			paraMap = new HashMap();
			paraMap.put("type", type);
			paraMap.put("xtxx", rate);
			rate = (String) sqlMapClientTemplate.queryForObject(
					"selectXtbmByName", paraMap);

			String name = (String) sqlMapClientTemplate.queryForObject(
					"getChannelBiaoSHi", null);
			if (native_circuitcode != null
					&& !native_circuitcode.equalsIgnoreCase("")) {
				circuit.setCircuitcode(native_circuitcode);
			} else {
				paraMap = new HashMap();
				paraMap.put("circuitcode", operationType);
				paraMap.put("rate", rate);
				String circuitCode = (String) sqlMapClientTemplate
						.queryForObject("getMaxCircuitCode", paraMap);
				if (circuitCode != null && !circuitCode.equalsIgnoreCase("")) {
					if (circuitCode.split("-").length > 0) {
						int a = 0;
						if (circuitCode.split("-")[1] != null) {
							a = Integer.valueOf(circuitCode.split("-")[1]);
						}
						a = a + 1;
						String b = "0000" + String.valueOf(a);
						b = b.substring(b.length() - 4);
						circuitCode = circuitCode.split("-")[0] + "-" + b;
					}
				} else {
					circuitCode = name + operationType + "-0001";
				}
				circuit.setCircuitcode(circuitCode);
			}
			circuit.setOperationtype(operationType);
			circuit.setUsername(operationKind);
			circuit.setProperty("YW010701");
			circuit.setSerial("1");
			circuit.setX_purpose("YW010903");
			circuit.setSlot1("1");
			circuit.setSlot2("1");
			circuit.setArea("YW011002");
			circuit.setState("YW010301");
			circuit.setUsetime("");
			circuit.setCreatetime("");
			circuit.setLeaser("");
			circuit.setUsercom("");
			circuit.setCheck1("");
			circuit.setCheck2("");
			circuit.setBeizhu("");
			if (native_circuitcode != null
					&& !native_circuitcode.equalsIgnoreCase("")) {
				sqlMapClientTemplate.insert("updateCircuitForRelateCircuit",
						circuit);
			} else {
				sqlMapClientTemplate.insert("insertCircuitForRelateCircuit",
						circuit);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (circuit != null) {
			insertCCTmp(circuit.getCircuitcode(), xml);
		}
		return circuit.getCircuitcode();
	}

	/**
	 * 根据方式单编号获取方式信息
	 * 
	 * @param string
	 *            (电路编号)
	 *@return json
	 */
	public String getCircuitDetail(String circuitcode) {
//		AppointStrToStr strTostr = new AppointStrToStr();
		Map resultMap = new HashMap();
		List items = sqlMapClientTemplate.queryForList("getCircuitInfoflex",
				circuitcode);
		StringBuffer node = new StringBuffer("[");
		try {
			if (items != null && items.size() > 0) {
				resultMap = (HashMap) items.get(0);
				node.append("{\"circuitcode\":\""
						+ circuitcode
						+ "\",\"usercom\":\""
						+ (String) resultMap.get("USERCOM")
						+ "\",\"remark\":\""
						+ (String) resultMap.get("REMARK")
						+ "\",\"requestcom\":\""
						+ (String) resultMap.get("REQUESTCOM")
						+ "\",\"requistionid\":\""
						+ (String) resultMap.get("REQUISITIONID")
						+ "\",\"username\":\""
						+ (String) resultMap.get("USERNAME")
						+ "\",\"usercomcode\":\""
						+ (String) resultMap.get("USERCOMCODE")
						+ "\",\"rate\":\""
						+ (String) resultMap.get("RATE")
						+ "\",\"circuitlevel\":\""
						+ (BigDecimal) resultMap.get("CIRCUITLEVEL")
						+ "\",\"interfacetype\":\""
						+ (String) resultMap.get("INTERFACETYPE")
						+ "\",\"interfacetypecode\":\""
						+ (String) resultMap.get("INTERFACETYPECODE")
						+ "\",\"port1\":\""
						+ (String) resultMap.get("PORTSERIALNO1")
						+ "\",\"port2\":\""
						+ (String) resultMap.get("PORTSERIALNO2")
						+ "\",\"createtime\":\""
						+ (String) resultMap.get("CREATETIME")
						+ "\",\"usetime\":\""
						+ (String) resultMap.get("USETIME")
						+ "\",\"leaser\":\""
						+ (String) resultMap.get("LEASER")
						+ "\",\"ratecode\":\""
						+ (String) resultMap.get("RATECODE")
						+ "\",\"requestcomcode\":\""
						+ (String) resultMap.get("REQUESTCOMCODE")
						+ "\",\"slot1\":\""
						+ (String) resultMap.get("SLOT1")
						+ "\",\"slot2\":\""
						+ (String) resultMap.get("SLOT2")
						+ "\",\"busitype\":\""
						+ (String) resultMap.get("BUSITYPE")
						+ "\",\"busitypecode\":\""
						+ (String) resultMap.get("BUSITYPECODE")
						 + "\" }");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		node.append("]");
		return node.toString();
	}

	/**
	 * 根据方式单编号获取方式申请单信息
	 * 
	 * @param string
	 *            (电路编号)
	 *@return json
	 */
	public String getCircuitReqByCircuitcode(String circuitcode) {

		String json = "";
		if (circuitcode != null && !circuitcode.equalsIgnoreCase("")) {
			Map map = new HashMap();
			map.put("circuitcode", circuitcode);
			String form_id = (String) sqlMapClientTemplate.queryForObject(
					"getFormIdByCircuitcode1", map);

			if (form_id != null && !form_id.equalsIgnoreCase("")) {
				NewBaseDAO dao = new NewBaseDAO();
				Connection c = null;
				Statement s = null;
				ResultSet r = null;
				try {
					c = dao.getConnection();
					s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
							ResultSet.CONCUR_READ_ONLY);
					String sql = "select t.* "
							+ " from vw_circuit t where t.form_id='" + form_id
							+ "'";
					r = s.executeQuery(sql);
					while (r.next()) {
						json += "[";
						json += "{";
						json += "\"form_id\":\"" + r.getString("FORM_ID")
								+ "\"";
						json += ",";
						json += "\"form_no\":\"" + r.getString("FORM_NO")
								+ "\"";
						json += ",";
						json += "\"appdepartment\":\""
								+ r.getString("APPDEPARTMENT") + "\"";
						json += ",";
						json += "\"applier\":\"" + r.getString("APPLIER")
								+ "\"";
						json += ",";
						json += "\"starttime\":\"" + r.getString("STARTTIME")
								+ "\"";
						json += ",";
						json += "\"finishtime\":\"" + r.getString("FINISHTIME")
								+ "\"";
						json += ",";
						json += "\"speedname\":\"" + r.getString("SPEEDNAME")
								+ "\"";
						json += ",";
						json += "\"purpose\":\"" + r.getString("PURPOSE")
								+ "\"";
						json += ",";
						json += "\"operationtype\":\""
								+ r.getString("SPECIALTYTYPE") + "\"";
						json += ",";
						json += "\"circuitname\":\""
								+ r.getString("SPECIALTYNAME") + "\"";
						json += ",";
						json += "\"causation\":\"\"";
						json += ",";
						json += "\"asite\":\"" + r.getString("ASITE") + "\"";
						json += ",";
						json += "\"zsite\":\"" + r.getString("ZSITE") + "\"";
						json += ",";
						json += "\"form_name\":\""
								+ r.getString("SPECIALTYNAME") + "\"";
						json += ",";
						json += "\"porttype\":\"" + r.getString("PORTTYPE")
								+ "\"";
						json += ",";
						json += "\"telephone\":\"\"";
						json += "}";
						json += "]";
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					dao.closeConnection(c, s, r);
				}

			}

		}

		return json;
	}

	@SuppressWarnings("unchecked")
	public String getTransDevice(String id, String type, String flag) {
		String xml = "";
		try {
			if (id == null) {
				List<HashMap> list = fdao.getEquipTypeXtxx();

				for (HashMap lst : list) {
					String xtbm = (String) lst.get("XTBM");
					String xtxx = (String) lst.get("XTXX");
					xml += "\n"
							+ "<folder state='0' code='"
							+ xtbm
							+ "' label='"
							+ xtxx
							+ "' isBranch='true' leaf='false' type='equiptype' >";
					xml += "\n" + "</folder>";
				}
			} else {
				if ("equiptype".equalsIgnoreCase(type)) {
					List<HashMap> childlist = fdao.getVendorByEquipType(id);
					for (HashMap clst : childlist) {
						String vendorcode = (String) clst.get("XTBM");
						String vendorname = (String) clst.get("XTXX");
						xml += "\n"
								+ "<folder state='0' code='"
								+ vendorcode
								+ "' label='"
								+ vendorname
								+ "'isBranch='true' leaf='false' type='vendor' >";
						xml += "\n" + "</folder>";
					}
				} else if ("vendor".equalsIgnoreCase(type)) {
					List<HashMap> leaflist = basedao.queryForList(
							"getEquipForChannel", id);
					for (HashMap llst : leaflist) {
						String equipcode = (String) llst.get("EQUIPCODE");
						String equipname = (String) llst.get("EQUIPNAME");
						String x_model = (String) llst.get("X_MODEL");
						String stationname = (String) llst.get("STATIONNAME");
						xml += "\n"
								+ "<folder state='0' code='"
								+ equipcode
								+ "' label='"
								+ equipname
								+ "' vendor='"
								+ id
								+ "' x_model='"
								+ x_model
								+ "' stationname='"
								+ stationname
								+ "' isBranch='true' leaf='false' type='equip'/>";
					}
				} else if ("equip".equalsIgnoreCase(type)) {
					xml = getPort(id, "", "YW010201", "", "", "root");
				} else if ("1".equalsIgnoreCase(type)) {
					xml = getPort(id, "", "YW010201", "", flag, type);
				} else if ("2".equalsIgnoreCase(type)) {
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
					xml = executeGetPortInfo1(id, flag, "YW010201");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return xml;

	}

	public String getPort(String equipcode, String textname, String rate,
			String parentnode, String nodeid, String tree) {

		String parentID = parentnode;
		String xml;
		Map portRate2Field = new HashMap();
		Map tsRateMap;
		String slotRate;
		boolean isLeaf = false;
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

		// rate2TsStatus.put("ZY110601", "TS155MSTATUS");
		// rate2TsStatus.put("ZY110602", "TS622MSTATUS");
		// rate2TsStatus.put("ZY110603", "TS2DOT5GSTATUS");
		// rate2TsStatus.put("ZY110604", "TS10GSTATUS");
		// // rate2TsStatus.put("ZY110699", "YW010299");
		// rate2TsStatus.put("ZY110612", "TS2MSTATUS");
		// // rate2TsStatus.put("ZY110613", "TS45MSTATUS");

		// 初始化资源数的第一层节点（端口类型：线路口，支路口
		if (tree.equalsIgnoreCase("root")) {
			xml = executeRootForPortType(equipcode, rate2Capacode.get(rate)
					.toString());
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
					.toString());
			return xml;
		}

		return null;
	}

	public String executeRootForPortType(String equipcode, String rate) {
		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		String xml = "";
		try {
			String sql = "select * from (select distinct porttypecode,porttypename from v_selectts$oc v where v.equipcode='"
				+ equipcode
//				+ "' and v.capacode>'"
//				+ rate
				+ "'  and v.capacode<>'ZY070112'"
				+ ")order by porttypecode ";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);
			log.info("executeRootForPortType:"+sql);
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

	public String executeGetEquipPort(String equipcode, String nodeType,
			String rate) {
		BaseDAO dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		String xml = "";
		try {
			String sql = "select distinct  capacode,capaname from( select x_capability capacode, getxtxx(x_capability) capaname from equiplogicport where equipcode ='"
				+ equipcode
				+ "' and y_porttype='"
				+ nodeType
				+ "'  order by slotserial,portserial）order by capacode desc";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);
			log.info("executeGetEquipPort:"+sql);
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

	public String executeGetPortInfo(String equipCode, String nodeType,
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
		try {
			String sql = "select logicport,getportlabelwithoutequipname(logicport) portname,x_capability capacode from equiplogicport where equipcode='"
				+ equipCode
				+ "' and x_capability='"
				+ nodeType
				+ "' order by to_number(slotserial),to_number(portserial)";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);
			log.info("executeGetPortInfo:"+sql);
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

	public String executeGetPortInfo1(String equipCode, String nodeType,
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
		try {
			String sql = "select * from (select distinct logicport,getportlabelnew(logicport) portname,getportstandardname(logicport) as portstandardname, capacode from v_selectts$oc v where v.equipcode=lpad('"
					+ equipCode
					+ "',20,'0') and capacode='"
					+ nodeType
					+ "' minus select distinct logicport,getportlabelnew(logicport) portname,getportstandardname(logicport) as portstandardname,x_capability capacode from equiplogicport "
					+ "where equipcode=lpad('"
					+ equipCode
					+ "',20,'0') and x_capability='"
					+ rate
					+ "' and logicport in(select aptp portcode from cc "
					+ "where pid='"
					+ equipCode
					+ "' union select zptp portcode from cc where pid='"
					+ equipCode + "'))order by getportlabelnew(logicport)";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = s.executeQuery(sql);

			while (rs.next()) {

				if (rs.getString("capacode").equalsIgnoreCase(rate)) {
					xml += "<folder state='0' label='"
							+ rs.getString("portname")
							+ "' id='port"
							+ rs.getString("logicport")
							+ "' portcode='"
							+ rs.getString("logicport")
							+ "' portstandardname='"
							+ rs.getString("portstandardname")
							+ "' disabled=\"true\"  isBranch=\"false\" leaf='true' >";
					xml += "</folder>";
				} else if (rate.equalsIgnoreCase("port")) {
					xml += "<folder state='0' label='"
							+ rs.getString("portname")
							+ "' id='port"
							+ rs.getString("logicport")
							+ "' portcode='"
							+ rs.getString("logicport")
							+ "' portstandardname='"
							+ rs.getString("portstandardname")
							+ "' disabled=\"true\"  isBranch=\"false\" leaf='true' >";
					xml += "</folder>";
				} else {
					xml += "<folder state='0' label='"
							+ rs.getString("portname")
							+ "' id='port"
							+ rs.getString("logicport")
							+ "' portcode='"
							+ rs.getString("logicport")
							+ "' portstandardname='"
							+ rs.getString("portstandardname")
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

	public String getSlotDetailByportAAndPortZ(String portA, String portZ) {
		String json = "";
		Map paraMap = new HashMap();
		paraMap.put("portA", portA);
		paraMap.put("portZ", portZ);
		List list = sqlMapClientTemplate.queryForList(
				"getSlotDetailByPortAAndPortZ", paraMap);
		try {
			if (list != null && list.size() > 0) {
				json += "[";
				for (int i = 0; i < list.size(); i++) {
					Map resultMap = (HashMap) list.get(i);
					json += "{";
					json += "\"id\":\"" + (String) resultMap.get("ID") + "\"";
					json += ",";
					json += "\"pid\":\"" + (String) resultMap.get("PID") + "\"";
					json += ",";
					json += "\"rate\":\"" + (String) resultMap.get("RATE")
							+ "\"";
					json += ",";
					json += "\"portA\":\"" + (String) resultMap.get("APTP")
							+ "\"";
					json += ",";
					json += "\"aslot\":\""
							+ String.valueOf((BigDecimal) resultMap
									.get("ASLOT")) + "\"";
					json += ",";
					json += "\"portZ\":\"" + (String) resultMap.get("ZPTP")
							+ "\"";
					json += ",";
					json += "\"zslot\":\""
							+ String.valueOf((BigDecimal) resultMap
									.get("ZSLOT")) + "\"";
					json += ",";
					json += "\"arate\":\"" + (String) resultMap.get("ARATE")
							+ "\"";
					json += ",";
					json += "\"zrate\":\"" + (String) resultMap.get("ZRATE")
							+ "\"";
					json += ",";
					json += "\"aslot373\":\""
							+ (String) resultMap.get("ASLOT373") + "\"";
					json += ",";
					json += "\"zslot373\":\""
							+ (String) resultMap.get("ZSLOT373") + "\"";
					json += ",";
					json += "\"porta_label\":\""
							+ (String) resultMap.get("PORTA_LABEL") + "\"";
					json += ",";
					json += "\"portz_label\":\""
							+ (String) resultMap.get("PORTZ_LABEL") + "\"";
					json += ",";
					json += "\"isdefault\":\""
							+ resultMap.get("ISDEFAULT").toString() + "\"";
					json += "}";
					json += ",";
				}
				json = json.substring(0, json.length() - 1);
				json += "]";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return json;

	}

	public String insertCCNative(String aptp, String aslot, String zptp,
			String zslot, String rate) {
		try {
			Map paraMap = new HashMap();
			FlexSession session = FlexContext.getFlexSession();
			String userId = "";
			if (session != null && session.getAttribute("userid") != null) {
				UserModel user = (UserModel) session
						.getAttribute((String) session.getAttribute("userid"));
				if (user != null) {
					userId = user.getUser_id();
				}
			}
			String id = aptp + "-" + aslot + "-" + zptp + "-" + zslot + "-"
					+ rate;
			paraMap.put("id", id);
			paraMap.put("aptp", aptp);
			paraMap.put("aslot", aslot);
			paraMap.put("zptp", zptp);
			paraMap.put("zslot", zslot);
			paraMap.put("rate", rate);
			paraMap.put("updateperson", userId);
			sqlMapClientTemplate.insert("insertIntoCCNative", paraMap);

		} catch (Exception e) {
			e.printStackTrace();
			return "false";
		}
		return "true";
	}

	public String batchInsertCC(int startA, int endA, int startZ, int endZ,
			List<OpticalPortStatusModel> slotA,
			List<OpticalPortStatusModel> slotZ) {

		int numberA = startA;
		int numberZ = startZ;
		while (numberA <= endA && numberZ <= endZ) {
			OpticalPortStatusModel modela = slotA.get(numberA);
			OpticalPortStatusModel modelz = slotZ.get(numberZ);
			insertCCNative(modela.getAptp(), modela.getAslot(), modelz
					.getAptp(), modelz.getAslot(), modela.getRate());
			numberA++;
			numberZ++;
		}

		return "true";
	}

	public String batchDelCC(int startA, int endA, int startZ, int endZ,
			List<OpticalPortStatusModel> slotA,
			List<OpticalPortStatusModel> slotZ) {
		String str = "";
		int numberA = startA;
		int numberZ = startZ;
		while (numberA <= endA && numberZ <= endZ) {
			OpticalPortStatusModel modela = slotA.get(numberA);
			OpticalPortStatusModel modelz = slotZ.get(numberZ);
			Map map = new HashMap();
			map.put("aptp", modela.getAptp());
			map.put("aslot", modela.getAslot());
			map.put("zptp", modelz.getAptp());
			map.put("zslot", modelz.getAslot());
			map.put("isdefault", "1");
			String id = (String) sqlMapClientTemplate.queryForObject(
					"getPersonCCID", map);
			if (id != null) {
				sqlMapClientTemplate.delete("deleteCCByID", id);
				str += id + ":";
			}
			numberA++;
			numberZ++;
		}
		return str;
	}

	public String insertCCNativeForBatch(String aptp, String aslot,
			String zptp, String[] zslot, String rate) {
		try {
			Map paraMap = new HashMap();
			FlexSession session = FlexContext.getFlexSession();
			String userId = "";
			if (session != null && session.getAttribute("userid") != null) {
				UserModel user = (UserModel) session
						.getAttribute((String) session.getAttribute("userid"));
				if (user != null) {
					userId = user.getUser_id();
				}
			}
			if (zslot != null && zslot.length > 0) {
				for (int i = 0; i < zslot.length; i++) {
					String id = aptp + "-" + aslot + "-" + zptp + "-"
							+ zslot[i] + "-" + rate;
					paraMap.put("id", id);
					paraMap.put("aptp", aptp);
					paraMap.put("aslot", aslot);
					paraMap.put("zptp", zptp);
					paraMap.put("zslot", zslot[i]);
					paraMap.put("rate", rate);
					paraMap.put("updateperson", userId);
					sqlMapClientTemplate.insert("insertIntoCCNative", paraMap);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "false";
		}
		return "true";
	}

	public String getPortAZDetailForSlot(String portA, String portZ) {
		String json = "";
		try {
			Map paraMap = new HashMap();
			paraMap.put("portA", portA);
			paraMap.put("portZ", portZ);
			Map resultMap = (HashMap) sqlMapClientTemplate.queryForObject(
					"getPortAZDetailForSlot", paraMap);
			if (resultMap != null) {
				json += "[";
				json += "{";
				json += "\"portA\":\"" + (String) resultMap.get("PORTA") + "\"";
				json += ",";
				json += "\"portZ\":\"" + (String) resultMap.get("PORTZ") + "\"";
				json += ",";
				json += "\"rateA\":\"" + (String) resultMap.get("RATEA") + "\"";
				json += ",";
				json += "\"rateZ\":\"" + (String) resultMap.get("RATEZ") + "\"";
				json += ",";
				json += "\"portA_label\":\""
						+ (String) resultMap.get("PORTA_LABEL") + "\"";
				json += ",";
				json += "\"portZ_label\":\""
						+ (String) resultMap.get("PORTZ_LABEL") + "\"";
				json += ",";
				json += "\"pid\":\"" + (String) resultMap.get("PID") + "\"";
				json += ",";
				json += "\"pname\":\"" + (String) resultMap.get("PNAME") + "\"";
				json += "}";
				json += "]";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return json;
	}

	public String judgeVC4IsOverAllOrBreakUp(String port, int vc4) {
		String flag = "";

		Map paraMap = new HashMap();
		paraMap.put("port", port);
		paraMap.put("rate", "VC4");
		paraMap.put("slot", vc4);
		if (vc4 != 0) {
			List list = sqlMapClientTemplate.queryForList(
					"selectPortVc4SlotForConfigSlot", paraMap);
			if (list != null && list.size() > 0) {
				return "overall";
			} else {
				paraMap.put("port", port);
				paraMap.put("rate", "VC12");
				int a = Integer.valueOf(vc4);
				int begin = a * 63 - 63 + 1;
				int end = a * 63;
				paraMap.put("begin", begin);
				paraMap.put("end", end);
				list = sqlMapClientTemplate.queryForList(
						"selectPortVc4SlotBreakUpForConfigSlot", paraMap);
				if (list != null && list.size() > 0) {
					return "scattered";
				}
			}
		}
		return flag;
	}

	public String saveChannelConfig(String content) {
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
			Map paraMap = new HashMap();
			paraMap.put("userid", userId);
			paraMap.put("content", content);
			sqlMapClientTemplate.delete("deleteChannelConfigByUserid", paraMap);
			sqlMapClientTemplate.insert("insertChannelConfig", paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return "true";
	}

	public String getChannelConfig() {
		String content = null;
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
			Map paraMap = new HashMap();
			paraMap.put("userid", userId);
			content = (String) sqlMapClientTemplate.queryForObject(
					"selectChannelConfigByUserid", paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return content;
	}

	public String updateCircuit(Circuit circuit) {
		String flag = "flase";
		try {
			sqlMapClientTemplate
					.update("updateCircuitForChannelRoute", circuit);
			flag = "true";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}

	public String releasePortCircuit(String circuitcode) {
		String sucess = "false";
		try {
			sqlMapClientTemplate.delete("releasePortCircuit", circuitcode);
			sucess = "true";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sucess;
	}

	public String confirmStartOrEndPort(String portcode, String slot,
			String circuitcode, String flag) {
		try {
			Map paraMap = new HashMap();
			paraMap.put("portcode", portcode);
			paraMap.put("slot", slot);
			paraMap.put("circuitcode", circuitcode);
			if (flag != null && flag.equalsIgnoreCase("start")) {
				sqlMapClientTemplate.update("updateCircuitStartPort", paraMap);
			} else if (flag != null && flag.equalsIgnoreCase("end")) {
				sqlMapClientTemplate.update("updateCircuitEndPort", paraMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "true";
	}

	public String deleteSlotLink(String aptp, String aslot, String zptp,
			String zslot, String rate) {
		try {
			Map map = new HashMap();
			map.put("aptp", aptp);
			map.put("aslot", aslot);
			map.put("zptp", zptp);
			map.put("zslot", zslot);
			map.put("rate", rate);
			sqlMapClientTemplate.delete("deleteSlotLink", map);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "true";

	}
	public String getCircuitState(){
		String xml = "<names>";
		HashMap<String,String> resultMap = new HashMap<String,String>();
		List<String> list = getCircuitStates();
		for(Iterator it = list.iterator();it.hasNext();){
			resultMap = (HashMap)it.next();
			String xtbm_t = (String)resultMap.get("XTBM") != null ? (String)resultMap.get("XTBM") : "";
			String xtxx = (String)resultMap.get("XTXX") != null ? (String)resultMap.get("XTXX") : "";
			xml +=  "<name label =\""+xtxx+"\"code=\""+xtbm_t+"\"/>";
		}
		xml +="</names>";
		return xml;
	}
	private List<String> getCircuitStates(){
		return (List<String>)this.getSqlMapClientTemplate().queryForList("getCircuitState");
	}
/**
 * 电路路由图中速率下拉框的数据源
 *@2013-1-14
 *@author jtsun
 * @return
 */
	public String getRate(){
		String xml = "<names>";
		HashMap<String,String> resultMap = new HashMap<String,String>();
		List<String> list = (List<String>)this.getSqlMapClientTemplate().queryForList("getRateForNW");
		for(Iterator it = list.iterator();it.hasNext();){
			resultMap = (HashMap)it.next();
			String xtbm_t = (String)resultMap.get("XTBM") != null ? (String)resultMap.get("XTBM") : "";
			String xtxx = (String)resultMap.get("XTXX") != null ? (String)resultMap.get("XTXX") : "";
			xml +=  "<name label =\""+xtxx+"\"code=\""+xtbm_t+"\"/>";
		}
		xml +="</names>";
		return xml;
	}
	
	/**
	 * 验证电路编号是否存在
	 * checkCircuitId
	 * @param circuitcode
	 * @author xgyin
	 * */
	public String checkCircuitId(String circuitCode){
		String result="Success";
		String code = (String) this.getSqlMapClientTemplate().queryForObject("checkCircuitIdIsUse",circuitCode);
		if(code==null||"".equals(code)){
			result="Fail";//表示当前电路编号不存在
		}
		return result;
	}
	
	/**
	 * 验证业务名称是否存在
	 * checkCircuitName
	 * @param busName
	 * @author xgyin
	 * */
	public String checkCircuitName(String busName){
		String result="Success";
		String code = (String) this.getSqlMapClientTemplate().queryForObject("checkCircuitNameIsUse",busName);
		if(code==null||"".equals(code)){
			result="Fail";//业务名称不存在
		}
		return result;
	}
}
