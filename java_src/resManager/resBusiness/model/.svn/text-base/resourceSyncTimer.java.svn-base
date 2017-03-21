package resManager.resBusiness.model;

import faultSimulation.dao.SceneMgrDAO;
import flex.messaging.FlexContext;
import indexEvaluation.model.DateUtil;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimerTask;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import sysManager.log.dao.LogDao;
import db.DbDAO;

import channelroute.model.CircuitroutModel;

import com.metarnet.VerticallyImpl;
import com.model.request.Condition;
import com.util.DBHelper;

public class resourceSyncTimer extends TimerTask {

	private static EntityManagerFactory factory;
	private static final String PERSIST_UNIT = "VerticallyInterop";
	@Override
	public void run() {
		// TODO Auto-generated method stub
		//执行方法体
		VerticallyImpl impl = VerticallyImpl.getInstance();
	       
        factory = Persistence.createEntityManagerFactory(PERSIST_UNIT);
        
        String namespace="http://tempuri.org/";
        String endpoint="http://10.124.18.68/fzjk/WebService.asmx?wsdl";
		String receiver="010102";
		
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		long now = System.currentTimeMillis();
		long newnow =now-24*60*60*1000;
		Calendar calendar = Calendar.getInstance();
		calendar.setTimeInMillis(newnow);
		
		List<Condition> list = new ArrayList<Condition>();
		Condition con = new Condition();
//		con.setVar_0("1142220");
//		con.setVar_1("4045");
		con.setVar_4("增量");
		con.setVar_5(formatter.format(calendar.getTime()));
		con.setVar_6(DateUtil.getDateString(new Date(), "yyyy-MM-dd HH:mm:ss"));
	    list.add(con);
	    
	    HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		
	    impl.SynSDataSite(namespace, endpoint, receiver, list);
	    
	    logDao.createLogEvent("资源自动同步", "资源管理模块", "站点同步", "", request);
	    
	    List<Condition> equipList2 = new ArrayList<Condition>();
	    impl.RequestGetequipment(namespace, endpoint, receiver, list);
	    logDao.createLogEvent("资源自动同步", "资源管理模块", "设备同步", "", request);
	    
		  DBHelper.updateEquipmentXy( factory);
	    
		equipList2 = DBHelper.queryEquipmentODF(factory);
		for(int i=0;i<equipList2.size();i++){
			List<Condition> list2 = new ArrayList<Condition>();
			Condition con2 = (Condition)equipList2.get(i);
			con2.setVar_4("增量");
			con2.setVar_5(formatter.format(calendar.getTime()));
			con2.setVar_6(DateUtil.getDateString(new Date(), "yyyy-MM-dd HH:mm:ss"));
			list2.add(con2);
			impl.RequestGetequipframe(namespace, endpoint, receiver, list2);
			logDao.createLogEvent("资源自动同步", "资源管理模块", "机框同步", "", request);
			
			impl.RequestGetequipslot(namespace, endpoint, receiver, list2);
			logDao.createLogEvent("资源自动同步", "资源管理模块", "机槽同步", "", request);
			impl.RequestGetequippack(namespace, endpoint, receiver, list2);
			logDao.createLogEvent("资源自动同步", "资源管理模块", "机盘同步", "", request);
			impl.RequestGetequiplogicport(namespace, endpoint, receiver, list2);
			logDao.createLogEvent("资源自动同步", "资源管理模块", "端口同步", "", request);
			impl.RequestGetequipcc(namespace, endpoint, receiver, list2);
			logDao.createLogEvent("资源自动同步", "资源管理模块", "交叉同步", "", request);
			impl.SynCiruit(namespace, endpoint, receiver, list2);
			logDao.createLogEvent("资源自动同步", "资源管理模块", "电路同步", "", request);
		}
		impl.RequestGettopolink(namespace, endpoint, receiver, list);
		logDao.createLogEvent("资源自动同步", "资源管理模块", "复用段同步", "", request);
		impl.SynEnOcable(namespace, endpoint, receiver, list);
		logDao.createLogEvent("资源自动同步", "资源管理模块", "光缆同步", "", request);
		List<Condition> ocableList = DBHelper.queryOcable(factory);
	    for(int i=0;i<ocableList.size();i++){
		   List<Condition> list2 = new ArrayList<Condition>();
		   Condition con2 = (Condition)ocableList.get(i);
		   con2.setVar_4("增量");
			con2.setVar_5(formatter.format(calendar.getTime()));
			con2.setVar_6(DateUtil.getDateString(new Date(), "yyyy-MM-dd HH:mm:ss"));
		   list2.add(con2);
		    impl.SynEnfiber(namespace, endpoint, receiver, list2);
		    logDao.createLogEvent("资源自动同步", "资源管理模块", "光纤同步", "", request);
	   }
	   impl.SynOPTICAL(namespace, endpoint, receiver, list);
	   logDao.createLogEvent("资源自动同步", "资源管理模块", "光路同步", "", request);
	   impl.synTopoLinkOptical(namespace, endpoint, receiver, list);
	   logDao.createLogEvent("资源自动同步", "资源管理模块", "光路与复用段关系", "", request);
	   impl.SynBuss(namespace, endpoint, receiver, list);
	   logDao.createLogEvent("资源自动同步", "资源管理模块", "业务同步", "", request);
	   impl.SynCircuitBuss(namespace, endpoint, receiver, list);
	   logDao.createLogEvent("资源自动同步", "资源管理模块", "电路业务关系同步", "", request);
	   impl.synEquipmentXY(namespace, endpoint, receiver, list);
	 //修改电路主备路径字段
		//修改光路路由
	   DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");
	   this.modifyCircuitInfo(basedao);//改为存储过程
		List<String> opticalIdlst = basedao.queryForList("getOpticalIdLst", null);
		for(int i=0;i<opticalIdlst.size();i++){
			String opticalcode = opticalIdlst.get(i);
			basedao.queryForList("insertopticalroute", opticalcode);
		}
	}
	public void modifyCircuitInfo(DbDAO basedao){
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		SceneMgrDAO sceneMgrDao = (SceneMgrDAO) ctx.getBean("sceneMgrDao");
		List<String> codelst = sceneMgrDao.getAllCircuitCode();
		for(int a=0;a<codelst.size();a++){
			String circuitcode = codelst.get(a);
	//		查找设备
			Circuit key = sceneMgrDao.getCircuitByCircuitcode1(circuitcode);
			String startEquip = key.getPortcode1();
			String endEquip = key.getPortcode2();
			if (!"".equals(startEquip) && startEquip != null
					&& !"".equals(endEquip) && endEquip != null) {
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
					mp.put("equipcode1", codes);//主备都经过的设备
					mp.put("equipcode2", equips);//其他设备
					basedao.queryForList("insertCircuit_equipment_cnt", mp);
				}
			}
		}
	}
}
