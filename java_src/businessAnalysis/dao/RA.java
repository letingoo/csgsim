package businessAnalysis.dao;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.text.DecimalFormat;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import db.DbDAO;
import resManager.resBusiness.model.Circuit;
import faultSimulation.dao.SceneMgrDAO;
import flex.messaging.FlexContext;

public class RA {
	private static List<HashMap<Object,Object>> busInfo = new ArrayList<HashMap<Object,Object>>();
	private static List<HashMap<Object,Object>> cirRouteInfo = new ArrayList<HashMap<Object,Object>>();
	private static List<HashMap<Object,Object>> cirRouteBackInfo = new ArrayList<HashMap<Object,Object>>();
	private static List<HashMap<Object,Object>> equipInfo = new ArrayList<HashMap<Object,Object>>();
	private static List<HashMap<Object,Object>> linkInfo = new ArrayList<HashMap<Object,Object>>();
	private static List<HashMap<Object,Object>> log = new ArrayList<HashMap<Object,Object>>();
	private static DecimalFormat df = new DecimalFormat("0.00%");
	private static String allLog = "";
	
	static WebApplicationContext ctx = WebApplicationContextUtils
	.getWebApplicationContext(FlexContext.getServletContext());
	private static ReliabilityAnalysisDao busDao = (ReliabilityAnalysisDao) ctx.getBean("busDao");
	private static DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");
	
	private static HashMap<Object,Object> equipObj = new HashMap<Object,Object>();
	private static HashMap<Object,Object> linkObj = new HashMap<Object,Object>();
	
	public static String setSelected(HashMap<Object,Object> eObj, HashMap<Object,Object> lObj){
		equipObj = eObj;
		linkObj = lObj;
		
		return "success";
	}
	
	public static List<HashMap<Object,Object>> getAllLog(){
		return log;
	}
	//查询影响的
	public static List<HashMap<Object,Object>> getBusinessFail(List<String> temp){
		List<HashMap<Object,Object>> result = new ArrayList<HashMap<Object,Object>>();

		List<String> linklst = new ArrayList<String>();
		List<String> equiplst = new ArrayList<String>();
		int m=0,n=0;
		for(int i=0;i<temp.size();i++){
			if(temp.get(i).indexOf("#")!=-1){
				//链路
				String linkId = temp.get(i);
				if(!linklst.contains(linkId)){
					linklst.add(linkId);
				}
				m++;
			}else{
				if(!equiplst.contains(temp.get(i))){
					equiplst.add(temp.get(i));
				}
				n++;
			}
		}
		List<String> lst = new ArrayList<String>();
		Map map1 = new HashMap();
		map1.put("equiplst", equiplst);
		if(n==temp.size()){
			//全部是设备，查询影响的业务
			lst = busDao.getCircuitcodeByEquipCode(map1);
		}
		else{//
			if(m==temp.size()){//全部链路
				String portcode = linklst.get(0).split("#")[0];
				String equipcode1 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
				portcode = linklst.get(0).split("#")[1];
				String equipcode2 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
				String equipcode = equipcode1;
				String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
				equipcode = equipcode2;
				String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
				String s1 = equipname1+"->"+equipname2;
				String s2 = equipname2+"->"+equipname1;
				Map mp = new HashMap();
				mp.put("equipcode1", equipcode1);
				mp.put("equipcode2", equipcode2);
				List<Circuit> clst = new ArrayList<Circuit>();
				if(m==1){
					//查询链路两端的设备编码
					clst = basedao.queryForList("getCircuitRouteInfoNew", mp);
					for(int j=0;j<clst.size();j++){
						String path = clst.get(j).getPath();
						String remark = clst.get(j).getRemark();
						if(path!=null&&!"".equals(path)){
							if(remark==null||"".equals(remark)){//只有主路由的情况
								if(path.contains(s1)||path.contains(s2)){//必须包含A->B
									lst.add(clst.get(j).getCircuitcode());
								}
							}
							else {
									//必须包含A->B
									if(path.contains(s1)||path.contains(s2)||remark.contains(s1)||remark.contains(s2)){
									lst.add(clst.get(j).getCircuitcode());
								}
							}
						}
					}
				}else if(m==2){//2条链路情况
					portcode = linklst.get(1).split("#")[0];
					String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(1).split("#")[1];
					String equipcode4 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					equipcode = equipcode3;
					String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode4;
					String equipname4 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					String s3 = equipname3+"->"+equipname4;
					String s4 = equipname4+"->"+equipname3;
					
					mp.put("equipcode3", equipcode3);
					mp.put("equipcode4", equipcode4);
					clst = basedao.queryForList("getCircuitRouteInfoBy2Link", mp);
					
					for(int j=0;j<clst.size();j++){
						String path = clst.get(j).getPath();
						String remark = clst.get(j).getRemark();
						if(path!=null&&!"".equals(path)){
							boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(s3)||path.contains(s4);
							if(remark==null||"".equals(remark)){//只有主路由的情况
								if(flag1){//必须包含A->B
									lst.add(clst.get(j).getCircuitcode());
								}
							}else{
								boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(s3)||remark.contains(s4);
								if(flag1 || flag2){
									lst.add(clst.get(j).getCircuitcode());
								}
							}
						}
					}
					
				}else{//三条复用段
					portcode = linklst.get(1).split("#")[0];
					String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(1).split("#")[1];
					String equipcode4 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(2).split("#")[0];
					String equipcode5 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(2).split("#")[1];
					String equipcode6 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					
					equipcode = equipcode3;
					String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode4;
					String equipname4 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode5;
					String equipname5 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode6;
					String equipname6 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					
					String s3 = equipname3+"->"+equipname4;
					String s4 = equipname4+"->"+equipname3;
					String s5 = equipname5+"->"+equipname6;
					String s6 = equipname6+"->"+equipname5;
					
					mp.put("equipcode3", equipcode3);
					mp.put("equipcode4", equipcode4);
					mp.put("equipcode5", equipcode5);
					mp.put("equipcode6", equipcode6);
					clst = basedao.queryForList("getCircuitRouteInfoBy3Link", mp);
					
					for(int j=0;j<clst.size();j++){
						String path = clst.get(j).getPath();
						String remark = clst.get(j).getRemark();
						if(path!=null&&!"".equals(path)){
							boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(s3)||path.contains(s4)||path.contains(s5)||path.contains(s6);
							if(remark==null||"".equals(remark)){//只有主路由的情况
								if(flag1){//必须包含A->B
									lst.add(clst.get(j).getCircuitcode());
								}
							}else{
								boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(s3)||remark.contains(s4)||remark.contains(s5)||remark.contains(s6);
								if(flag1 || flag2){
									lst.add(clst.get(j).getCircuitcode());
								}
							}
						}
					}
				}
			}else{
				if(n==1&&m==1){//1条复用段，1设备
					
					String equipcode1 = equiplst.get(0);
					String equipcode = equipcode1;
					String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					
					String portcode = linklst.get(0).split("#")[0];
					String equipcode2 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(0).split("#")[1];
					String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					equipcode = equipcode2;
					String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode3;
					String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					String s1 = equipname2+"->"+equipname3;
					String s2 = equipname3+"->"+equipname2;
					
					Map mp = new HashMap();
					mp.put("equipcode1", equipcode1);
					mp.put("equipcode2", equipcode2);
					mp.put("equipcode3", equipcode3);
					List<Circuit> clst = new ArrayList<Circuit>();
					//查询1设备坏，1复用段断影响的电路数
					clst = basedao.queryForList("getCircuitRouteInfoByNodeAndLink", mp);
					for(int k=0;k<clst.size();k++){
						if(clst.get(k).getPath()==null||"".equals(clst.get(k).getPath())){
							continue;
						}
						String path = clst.get(k).getPath();
						String remark = clst.get(k).getRemark();
						boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(equipname1);
						if(remark==null||"".equals(remark)){
							if(flag1){//无备用
								lst.add(clst.get(k).getCircuitcode());
							}
						}else{
							boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(equipname1);
							if(flag1 || flag2){
								lst.add(clst.get(k).getCircuitcode());
							}
						}
					}
					
				}else{
					if(m==1&&n==2){//1复用段2设备
						String equipcode1 = equiplst.get(0);
						String equipcode = equipcode1;
						String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
						String equipcode2 = equiplst.get(1);
						equipcode = equipcode2;
						String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
						
						String portcode = linklst.get(0).split("#")[0];
						String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
						portcode = linklst.get(0).split("#")[1];
						String equipcode4 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
						equipcode = equipcode3;
						String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
						equipcode = equipcode4;
						String equipname4 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
						String s1 = equipname4+"->"+equipname3;
						String s2 = equipname3+"->"+equipname4;
						
						Map mp = new HashMap();
						mp.put("equipcode1", equipcode1);
						mp.put("equipcode2", equipcode2);
						mp.put("equipcode3", equipcode3);
						mp.put("equipcode4", equipcode4);
						List<Circuit> clst = new ArrayList<Circuit>();
						//查询1设备坏，1复用段断影响的电路数
						clst = basedao.queryForList("getCircuitRouteInfoBy2NodeAndLink", mp);
						for(int k=0;k<clst.size();k++){
							if(clst.get(k).getPath()==null||"".equals(clst.get(k).getPath())){
								continue;
							}
							String path = clst.get(k).getPath();
							String remark = clst.get(k).getRemark();
							boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(equipname1)||path.contains(equipname2);
							if(remark==null||"".equals(remark)){
								if(flag1){//无备用
									lst.add(clst.get(k).getCircuitcode());
								}
							}else{
								boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(equipname1)||remark.contains(equipname2);
								if(flag1 || flag2){
									lst.add(clst.get(k).getCircuitcode());
								}
							}
						}
					}
					else{//2链路，1设备
						String equipcode1 = equiplst.get(0);
						String equipcode = equipcode1;
						String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
						
						String portcode = linklst.get(0).split("#")[0];
						String equipcode2 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
						portcode = linklst.get(0).split("#")[1];
						String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
						equipcode = equipcode2;
						String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
						equipcode = equipcode3;
						String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
						
						portcode = linklst.get(1).split("#")[0];
						String equipcode4 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
						portcode = linklst.get(1).split("#")[1];
						String equipcode5 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
						equipcode = equipcode4;
						String equipname4 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
						equipcode = equipcode5;
						String equipname5 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
						
						String s1 = equipname2+"->"+equipname3;
						String s2 = equipname3+"->"+equipname2;
						String s3 = equipname4+"->"+equipname5;
						String s4 = equipname5+"->"+equipname4;
						
						Map mp = new HashMap();
						mp.put("equipcode1", equipcode1);
						mp.put("equipcode2", equipcode2);
						mp.put("equipcode3", equipcode3);
						mp.put("equipcode4", equipcode4);
						mp.put("equipcode5", equipcode5);
						List<Circuit> clst = new ArrayList<Circuit>();
						//查询1设备坏，1复用段断影响的电路数
						clst = basedao.queryForList("getCircuitRouteInfoByNodeAnd2Link", mp);
						for(int k=0;k<clst.size();k++){
							if(clst.get(k).getPath()==null||"".equals(clst.get(k).getPath())){
								continue;
							}
							String path = clst.get(k).getPath();
							String remark = clst.get(k).getRemark();
							boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(equipname1)||path.contains(s3)||path.contains(s4);
							if(remark==null||"".equals(remark)){
								if(flag1){//无备用
									lst.add(clst.get(k).getCircuitcode());
								}
							}else{
								boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(equipname1)||remark.contains(s3)||remark.contains(s4);
								if(flag1 || flag2){
									lst.add(clst.get(k).getCircuitcode());
								}
							}
						}
					}
				}
			}
		}
		Map map = new HashMap();
		map.put("lst", lst);
		if(lst.size()>0){
			List<HashMap<Object,Object>> result1 = busDao.getAllBusByEquipcode(map);
			result.addAll(result1);
		}
		
		return result;
	}
	//查询不可恢复的
	public static List<HashMap<Object,Object>> getBusinessRe(List<String> temp){
		List<HashMap<Object,Object>> result = new ArrayList<HashMap<Object,Object>>();

		List<String> linklst = new ArrayList<String>();
		List<String> equiplst = new ArrayList<String>();
		int m=0,n=0;
		for(int i=0;i<temp.size();i++){
			if(temp.get(i).indexOf("#")!=-1){
				//链路
				String linkId = temp.get(i);
				if(!linklst.contains(linkId)){
					linklst.add(linkId);
				}
				m++;
			}else{
				if(!equiplst.contains(temp.get(i))){
					equiplst.add(temp.get(i));
				}
				n++;
			}
		}
		List<String> lst = new ArrayList<String>();
		List<Circuit> circuitlst = new ArrayList<Circuit>();
		Map map1 = new HashMap();
		map1.put("equiplst", equiplst);
		if(n==temp.size()){
			//根据设备查找电路编号
			circuitlst = busDao.getBusinessInfo(map1);
			if(n==1){
				String equipcode = temp.get(0);
				String equipname = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
				for(int p=0;p<circuitlst.size();p++){
					if(circuitlst.get(p).getPath()==null||"".equals(circuitlst.get(p).getPath())){
						continue;
					}
					String path=circuitlst.get(p).getPath();
					String remark = circuitlst.get(p).getRemark();
					if(remark==null||"".equals(remark)){
						if(!lst.contains(circuitlst.get(p).getCircuitcode())){
							lst.add(circuitlst.get(p).getCircuitcode());
						}
					}else{
						if(path.contains(equipname)&&remark.contains(equipname)){
							if(!lst.contains(circuitlst.get(p).getCircuitcode())){
								lst.add(circuitlst.get(p).getCircuitcode());
							}
						}
					}
				}
			}else if (n==2){
				String equipcode = temp.get(0);
				String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
				equipcode = temp.get(1);
				String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
				for(int p=0;p<circuitlst.size();p++){
					if(circuitlst.get(p).getPath()==null||"".equals(circuitlst.get(p).getPath())){
						continue;
					}
					String path = circuitlst.get(p).getPath();
					String remark = circuitlst.get(p).getRemark();
					if(remark==null||"".equals(remark)){
						if(!lst.contains(circuitlst.get(p).getCircuitcode())){
							lst.add(circuitlst.get(p).getCircuitcode());
						}
					}else{
						if(path.contains(equipname1)&&remark.contains(equipname1)||path.contains(equipname2)&&remark.contains(equipname2)){
							if(!lst.contains(circuitlst.get(p).getCircuitcode())){
								lst.add(circuitlst.get(p).getCircuitcode());
							}
						}else if(path.contains(equipname1)&&remark.contains(equipname2)||path.contains(equipname2)&&remark.contains(equipname1)){
							if(!lst.contains(circuitlst.get(p).getCircuitcode())){
								lst.add(circuitlst.get(p).getCircuitcode());
							}
						}
					}
				}
			}else{
				String equipcode = temp.get(0);
				String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
				equipcode = temp.get(1);
				String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
				equipcode = temp.get(2);
				String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
				for(int p=0;p<circuitlst.size();p++){
					if(circuitlst.get(p).getPath()==null||"".equals(circuitlst.get(p).getPath())){
						continue;
					}
					String path = circuitlst.get(p).getPath();
					String remark = circuitlst.get(p).getRemark();
					if(remark==null||"".equals(remark)){
						if(!lst.contains(circuitlst.get(p).getCircuitcode())){
							lst.add(circuitlst.get(p).getCircuitcode());
						}
					}else{
						if(path.contains(equipname1)&&remark.contains(equipname1)||path.contains(equipname2)&&remark.contains(equipname2)||path.contains(equipname3)&&remark.contains(equipname3)){
							if(!lst.contains(circuitlst.get(p).getCircuitcode())){
								lst.add(circuitlst.get(p).getCircuitcode());
							}
						}else if(path.contains(equipname1)&&remark.contains(equipname2)||path.contains(equipname1)&&remark.contains(equipname3)||path.contains(equipname2)&&remark.contains(equipname1)||path.contains(equipname2)&&remark.contains(equipname3)||path.contains(equipname3)&&remark.contains(equipname1)||path.contains(equipname3)&&remark.contains(equipname2)){
							if(!lst.contains(circuitlst.get(p).getCircuitcode())){
								lst.add(circuitlst.get(p).getCircuitcode());
							}
						}
					}
				}
			}
			
		}
		else{
			if(m==temp.size()){
				
				String portcode = linklst.get(0).split("#")[0];
				String equipcode1 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
				portcode = linklst.get(0).split("#")[1];
				String equipcode2 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
				String equipcode = equipcode1;
				String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
				equipcode = equipcode2;
				String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
				
				String s1=equipname1+"->"+equipname2;
				String s2=equipname2+"->"+equipname1;
				List<Circuit> clst = new ArrayList<Circuit>();
				Map mp = new HashMap();
				mp.put("equipcode1", equipcode1);
				mp.put("equipcode2", equipcode2);
				
				if(m==1){
					clst = basedao.queryForList("getCircuitRouteInfoNew", mp);
					for(int k=0;k<clst.size();k++){
						//
						if(clst.get(k).getPath()==null||"".equals(clst.get(k).getPath())){
							continue;
						}
						String path = clst.get(k).getPath();
						String remark = clst.get(k).getRemark();
						
						//2个设备必须同时处于主路由和备用路由上，否则表示可以恢复
						//同时要排除A->B这种情况
						if(remark==null||"".equals(remark)){//只有主路由
							if((path.contains(s1)||path.contains(s2))){
								if(!lst.contains(clst.get(k).getCircuitcode())){
									lst.add(clst.get(k).getCircuitcode());
								}
							}
						}
						else{//有备用
							if((path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))){
								if(!path.equals(s1)&&!path.equals(s2)&&!remark.equals(s1)&&!remark.equals(s2)){
									if(!lst.contains(clst.get(k).getCircuitcode())){
										lst.add(clst.get(k).getCircuitcode());
									}
								}
							}
						}
					}
				}else if(m==2){//2条链路断分析
					portcode = linklst.get(1).split("#")[0];
					String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(1).split("#")[1];
					String equipcode4 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					equipcode = equipcode3;
					String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode4;
					String equipname4 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					String s3 = equipname3+"->"+equipname4;
					String s4 = equipname4+"->"+equipname3;
					
					mp.put("equipcode3", equipcode3);
					mp.put("equipcode4", equipcode4);
					clst = basedao.queryForList("getCircuitRouteInfoBy2Link", mp);
					
					for(int j=0;j<clst.size();j++){
						String path = clst.get(j).getPath();
						String remark = clst.get(j).getRemark();
						if(path!=null&&!"".equals(path)){
							boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(s3)||path.contains(s4);
							if(remark==null||"".equals(remark)){//只有主路由的情况
								if(flag1){//必须包含A->B
									lst.add(clst.get(j).getCircuitcode());
								}
							}else{
								boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(s3)||remark.contains(s4);
								if(flag1 || flag2){
									boolean flag4 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s3)||path.contains(s4))&&(remark.contains(s4)||remark.contains(s3));
									boolean flag3 = !path.equals(s1)&&!path.equals(s2)&&!path.equals(s3)&&!path.equals(s4)&&!remark.equals(s1)&&!remark.equals(s2)&&!remark.equals(s3)&&!remark.equals(s4);
									//2条复用段分别在同一电路的主备路由上
									boolean flag5 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s3)||remark.contains(s4))||(path.contains(s3)||path.contains(s4))&&(remark.contains(s1)||remark.contains(s2));
									if(flag4&&flag3){//至少一条复用段既在主上，又在备上
										lst.add(clst.get(j).getCircuitcode());
									}
									else{ 
										if(flag5){
											lst.add(clst.get(j).getCircuitcode());
										}
									}
								}
							}
						}
					}
				}else{
					portcode = linklst.get(1).split("#")[0];
					String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(1).split("#")[1];
					String equipcode4 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(2).split("#")[0];
					String equipcode5 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(2).split("#")[1];
					String equipcode6 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					
					equipcode = equipcode3;
					String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode4;
					String equipname4 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode5;
					String equipname5 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode6;
					String equipname6 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					
					String s3 = equipname3+"->"+equipname4;
					String s4 = equipname4+"->"+equipname3;
					String s5 = equipname5+"->"+equipname6;
					String s6 = equipname6+"->"+equipname5;
					
					mp.put("equipcode3", equipcode3);
					mp.put("equipcode4", equipcode4);
					mp.put("equipcode5", equipcode5);
					mp.put("equipcode6", equipcode6);
					clst = basedao.queryForList("getCircuitRouteInfoBy3Link", mp);
					
					for(int j=0;j<clst.size();j++){
						String path = clst.get(j).getPath();
						String remark = clst.get(j).getRemark();
						if(path!=null&&!"".equals(path)){
							boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(s3)||path.contains(s4)||path.contains(s5)||path.contains(s6);
							if(remark==null||"".equals(remark)){//只有主路由的情况
								if(flag1){//必须包含A->B
									lst.add(clst.get(j).getCircuitcode());
								}
							}else{
								boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(s3)||remark.contains(s4)||remark.contains(s5)||remark.contains(s6);
								if(flag1 || flag2){
									//flag4表示至少一条复用段既在主上，又在备上
									boolean flag4 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s3)||path.contains(s4))&&(remark.contains(s4)||remark.contains(s3))||(path.contains(s5)||path.contains(s6))&&(remark.contains(s5)||remark.contains(s6));
									boolean flag3 = !path.equals(s1)&&!path.equals(s2)&&!path.equals(s3)&&!path.equals(s4)&&!path.equals(s5)&&!path.equals(s6)&&!remark.equals(s1)&&!remark.equals(s2)&&!remark.equals(s3)&&!remark.equals(s4)&&!remark.equals(s5)&&!remark.equals(s6);
									//flag5表示至少1条在主上，至少1条在备上
									boolean flag5 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s3)||remark.contains(s4))||(path.contains(s1)||path.contains(s2))&&(remark.contains(s5)||remark.contains(s6))||(path.contains(s3)||path.contains(s4))&&(remark.contains(s1)||remark.contains(s2))
									                 ||(path.contains(s3)||path.contains(s4))&&(remark.contains(s5)||remark.contains(s6))||(path.contains(s5)||path.contains(s6))&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s5)||path.contains(s6))&&(remark.contains(s3)||remark.contains(s4));
									if(flag4&&flag3){//至少一条复用段既在主上，又在备上
										lst.add(clst.get(j).getCircuitcode());
									}
									else{ 
										if(flag5){
											lst.add(clst.get(j).getCircuitcode());
										}
									}
								}
							}
						}
					}
				}
			}else{
				 if(m==1&&n==1){//一条链路，一设备
					String equipcode1 = equiplst.get(0);
					String equipcode = equipcode1;
					String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					
					String portcode = linklst.get(0).split("#")[0];
					String equipcode2 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(0).split("#")[1];
					String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					equipcode = equipcode2;
					String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode3;
					String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					String s1 = equipname2+"->"+equipname3;
					String s2 = equipname3+"->"+equipname2;
					
					Map mp = new HashMap();
					mp.put("equipcode1", equipcode1);
					mp.put("equipcode2", equipcode2);
					mp.put("equipcode3", equipcode3);
					List<Circuit> clst = new ArrayList<Circuit>();
					//查询1设备坏，1复用段断影响的电路数
					clst = basedao.queryForList("getCircuitRouteInfoByNodeAndLink", mp);
					for(int k=0;k<clst.size();k++){
						if(clst.get(k).getPath()==null||"".equals(clst.get(k).getPath())){
							continue;
						}
						String path = clst.get(k).getPath();
						String remark = clst.get(k).getRemark();
						boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(equipname1);
						if(remark==null||"".equals(remark)){
							if(flag1){//无备用
								lst.add(clst.get(k).getCircuitcode());
							}
						}else{
							boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(equipname1);
							if(flag1 || flag2){
								boolean flag3 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&remark.contains(equipname1);
								if(flag3&&!path.equals(s1)&&!path.equals(s2)&&!remark.equals(s1)&&!remark.equals(s2)){
									lst.add(clst.get(k).getCircuitcode());
								}else{//设备和复用段在主备上各一
									boolean flag4 = path.contains(equipname1)&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s1)||path.contains(s2))&&remark.contains(equipname1);
									if(flag4){
										lst.add(clst.get(k).getCircuitcode());
									}
								}
							}
						}
					}
				 }
				 else if(m==1&&n==2){//1链路，2设备
					String equipcode1 = equiplst.get(0);
					String equipcode = equipcode1;
					String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					String equipcode2 = equiplst.get(1);
					equipcode = equipcode2;
					String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					
					String portcode = linklst.get(0).split("#")[0];
					String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(0).split("#")[1];
					String equipcode4 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					equipcode = equipcode3;
					String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode4;
					String equipname4 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					String s1 = equipname4+"->"+equipname3;
					String s2 = equipname3+"->"+equipname4;
					
					Map mp = new HashMap();
					mp.put("equipcode1", equipcode1);
					mp.put("equipcode2", equipcode2);
					mp.put("equipcode3", equipcode3);
					mp.put("equipcode4", equipcode4);
					List<Circuit> clst = new ArrayList<Circuit>();
					//查询1设备坏，1复用段断影响的电路数
					clst = basedao.queryForList("getCircuitRouteInfoBy2NodeAndLink", mp);
					for(int k=0;k<clst.size();k++){
						if(clst.get(k).getPath()==null||"".equals(clst.get(k).getPath())){
							continue;
						}
						String path = clst.get(k).getPath();
						String remark = clst.get(k).getRemark();
						boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(equipname1)||path.contains(equipname2);
						if(remark==null||"".equals(remark)){
							if(flag1){//无备用
								lst.add(clst.get(k).getCircuitcode());
							}
						}else{
							boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(equipname1)||remark.contains(equipname2);
							if(flag1 || flag2){
								boolean flag3 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&remark.contains(equipname1)||path.contains(equipname2)&&remark.contains(equipname2);
								if(flag3&&!path.equals(s1)&&!path.equals(s2)&&!remark.equals(s1)&&!remark.equals(s2)){
									lst.add(clst.get(k).getCircuitcode());
								}else{//2设备和复用段至少在主备上各一
									boolean flag4 = (path.contains(s1)||path.contains(s2))&&remark.contains(equipname1)||(path.contains(s1)||path.contains(s2))&&remark.contains(equipname2)
									||path.contains(equipname1)&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&remark.contains(equipname2)
									||path.contains(equipname2)&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname2)&&remark.contains(equipname1);
									if(flag4){
										lst.add(clst.get(k).getCircuitcode());
									}
								}
							}
						}
					}
				}else{//2链路1设备
					String equipcode1 = equiplst.get(0);
					String equipcode = equipcode1;
					String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					
					String portcode = linklst.get(0).split("#")[0];
					String equipcode2 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(0).split("#")[1];
					String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					equipcode = equipcode2;
					String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode3;
					String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					
					portcode = linklst.get(1).split("#")[0];
					String equipcode4 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					portcode = linklst.get(1).split("#")[1];
					String equipcode5 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
					equipcode = equipcode4;
					String equipname4 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					equipcode = equipcode5;
					String equipname5 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
					
					String s1 = equipname2+"->"+equipname3;
					String s2 = equipname3+"->"+equipname2;
					String s3 = equipname4+"->"+equipname5;
					String s4 = equipname5+"->"+equipname4;
					
					Map mp = new HashMap();
					mp.put("equipcode1", equipcode1);
					mp.put("equipcode2", equipcode2);
					mp.put("equipcode3", equipcode3);
					mp.put("equipcode4", equipcode4);
					mp.put("equipcode5", equipcode5);
					List<Circuit> clst = new ArrayList<Circuit>();
					//查询1设备坏，1复用段断影响的电路数
					clst = basedao.queryForList("getCircuitRouteInfoByNodeAnd2Link", mp);
					for(int k=0;k<clst.size();k++){
						if(clst.get(k).getPath()==null||"".equals(clst.get(k).getPath())){
							continue;
						}
						String path = clst.get(k).getPath();
						String remark = clst.get(k).getRemark();
						boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(equipname1)||path.contains(s3)||path.contains(s4);
						if(remark==null||"".equals(remark)){
							if(flag1){//无备用
								lst.add(clst.get(k).getCircuitcode());
							}
						}else{
							boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(equipname1)||remark.contains(s3)||remark.contains(s4);
							if(flag1 || flag2){
								boolean flag3 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&remark.contains(equipname1)||(path.contains(s3)||path.contains(s4))&&(remark.contains(s3)||remark.contains(s4));
								if(flag3&&!path.equals(s1)&&!path.equals(s2)&&!remark.equals(s1)&&!remark.equals(s2)&&!path.equals(s3)&&!path.equals(s4)&&!remark.equals(s3)&&!remark.equals(s4)){
									lst.add(clst.get(k).getCircuitcode());
								}else{//2设备和复用段至少在主备上各一
									boolean flag4 = (path.contains(s1)||path.contains(s2))&&remark.contains(equipname1)||(path.contains(s1)||path.contains(s2))&&(remark.contains(s3)||remark.contains(s4))
									||path.contains(equipname1)&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&(remark.contains(s3)||remark.contains(s4))
									||(path.contains(s3)||path.contains(s4))&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s3)||path.contains(s4))&&remark.contains(equipname1);
									if(flag4){
										lst.add(clst.get(k).getCircuitcode());
									}
								}
							}
						}
					}
				}
			}
		}
		Map map = new HashMap();
		map.put("lst", lst);
		if(lst.size()>0){
			List<HashMap<Object,Object>> result1 = busDao.getAllBusByEquipcode(map);
			if(result1.size()==0)
				System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxresult1为空");
			else {
				System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxresult1不为空");
			}
			result.addAll(result1);
		}
		if(result.size()!=0)
			System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxresult不为空");
		else {
			System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxresult为空");
		}
		return result;
	}
	
	private static void getLinkLabel(){
		for(int i = 0; i<linkInfo.size(); i++){
			String name1 = getEquipLabel(linkInfo.get(i).get("FROM_EQUIP_ID").toString());
			String name2 = getEquipLabel(linkInfo.get(i).get("TO_EQUIP_ID").toString());
			linkInfo.get(i).put("LINK_LABEL", name1 + " - " + name2);
		}
	}
	private static String getEquipLabel(String str){
		for(int i = 0; i<equipInfo.size(); i++){
			if(str.equals(equipInfo.get(i).get("EQUIP_ID").toString()))
				return equipInfo.get(i).get("EQUIP_LABEL").toString();
		}
		return "";
	}

	private static void refreshInfo(){
		busInfo = new ArrayList<HashMap<Object,Object>>();
		cirRouteInfo = new ArrayList<HashMap<Object,Object>>();
		cirRouteBackInfo = new ArrayList<HashMap<Object,Object>>();
		equipInfo = new ArrayList<HashMap<Object,Object>>();
		linkInfo = new ArrayList<HashMap<Object,Object>>();
		log = new ArrayList<HashMap<Object,Object>>();
		allLog = "";
	}
	private static void getCRInfo(List<HashMap<Object,Object>> a){
		for(int i = 0;i<a.size() - 1;i++){
			if(a.get(i).get("EQUIP_ID").toString().equals(
					a.get(i+1).get("EQUIP_ID").toString())){
				if(a.get(i).get("GROUPNO").toString().equals("0"))
					cirRouteInfo.add(a.get(i));
				else
					cirRouteBackInfo.add(a.get(i));
				i++;
			}else{
				if(a.get(i).get("GROUPNO").toString().equals("0"))
					cirRouteInfo.add(a.get(i));
				else
					cirRouteBackInfo.add(a.get(i));
			}
		}
		getFuwuInfo();
	}
	private static void getFuwuInfo(){
		int count = 0,i=0,j=0;
		
		for(i = 0; i< busInfo.size(); i++){
			busInfo.get(i).put("index1", cirRouteInfo.size());
			busInfo.get(i).put("index2", cirRouteBackInfo.size());
		}
		i = 0;
		for(j = 0; j< cirRouteInfo.size() && i<busInfo.size() ; j++){
			if(busInfo.get(i).get("BUSINESS_ID").toString().equals(
					cirRouteInfo.get(j).get("CIRCUIT_ID").toString())){
				if(count == 0){
					busInfo.get(i).put("index1", j);
					count++;
				}
			}else{
				count = 0;
				i++;
				j--;
				
			}
		}
		
		i = 0;count = 0;
		for(j = 0; j< cirRouteBackInfo.size() && i<busInfo.size() ; j++){
			if(busInfo.get(i).get("BUSINESS_ID").toString().equals(
					cirRouteBackInfo.get(j).get("CIRCUIT_ID").toString())){
				if(count == 0){
					busInfo.get(i).put("index2", j);
					count++;
				}
			}else{
				count = 0;
				i++;
				j--;
			}
		}
		
	}

	public static String nxAnalysis(int num,String netType,String type, 
			List<HashMap<Object,Object>> equipA, List<HashMap<Object,Object>> equipB,
			List<HashMap<Object,Object>> linkA, List<HashMap<Object,Object>> linkB, 
			List<HashMap<Object,Object>> busA, List<HashMap<Object,Object>> busB,
			List<HashMap<Object,Object>> cirRouteA, List<HashMap<Object,Object>> cirRouteB){
		refreshInfo();
		busInfo = busA;
		equipInfo = equipA;
		linkInfo = linkA;
		getCRInfo(cirRouteA);
		if(num == 1){
			if(type.equals("设备")){
				System.out.println("是否开始");
				OneNode();
			}else{
				getLinkLabel();
				OneLink();
			}
		}else if(num == 2){
			if(equipObj == null && linkObj == null){
				if(type.equals("设备")){
					TwoNode();
				}else if(type.equals("复用段")){
					getLinkLabel();
					TwoLink();
				}else{
					getLinkLabel();
					NodeAndLink();
				}
			}else{
				getLinkLabel();
				haveSelected(type);
			}
		}else{
			if(type.equals("设备")){
			
				ThreeNode();
			}else if(type.equals("复用段")){
				getLinkLabel();
				ThreeLink();
			}else if(type.length()>=3){
				String s = type.substring(0, 3);
				if(s.equals("1设备")){
					getLinkLabel();
					NodeAndTwoLink();
				}else{
					getLinkLabel();
					TwoNodeAndLink();
				}
			}
		}
		
		System.out.println(allLog);
		return allLog;
	}
	
	private static void haveSelected(String type){
		float allPer = 0;
		
		if(equipObj != null && linkObj != null){//指定1设备，1复用段
			allPer = loopBus(equipObj.get("EQUIP_ID").toString(),linkObj.get("LINK_ID").toString(),
					equipObj.get("EQUIP_NAME").toString(),linkObj.get("LINK_LABEL").toString());
			//调用写函数 总的影响率
			if(equipInfo.size() > 0){
				allLog = "平均恢复率" + df.format(allPer);
			}
		}else if(equipObj != null){
			if(type.equals("设备")){//2设备，指定一个设备
				for(int i=0; i<equipInfo.size(); i++){
					HashMap<Object,Object> map = equipInfo.get(i);
					if(!map.get("EQUIP_ID").toString().equals(equipObj.get("EQUIP_ID").toString())){
						allPer += loopBus(equipObj.get("EQUIP_ID").toString(),map.get("EQUIP_ID").toString(),
								equipObj.get("EQUIP_NAME").toString(),map.get("EQUIP_NAME").toString());
					}
				}
				if(equipInfo.size() > 0){
					float l = (float)equipInfo.size() -1;
					allLog = "平均恢复率" + df.format(allPer/l);
				}
			}else{//指定设备，分析1复用段，1设备
				for(int i=0; i<linkInfo.size(); i++){
					HashMap<Object,Object> map = linkInfo.get(i);
					allPer += loopBus(equipObj.get("EQUIP_ID").toString(),map.get("LINK_ID").toString(),
							equipObj.get("EQUIP_NAME").toString(),map.get("LINK_LABEL").toString());
				}
				if(linkInfo.size() > 0){
					float l = (float)linkInfo.size();
					allLog = "平均恢复率" + df.format(allPer/l);
				}
			}
		}else{
			if(type.equals("复用段")){//指定一复用段，2复用段分析
				for(int i=0; i<linkInfo.size(); i++){
					HashMap<Object,Object> map = linkInfo.get(i);
					if(!map.get("LINK_ID").toString().equals(linkObj.get("LINK_ID").toString())){
						allPer += loopBus(linkObj.get("LINK_ID").toString(),map.get("LINK_ID").toString(),
								linkObj.get("LINK_LABEL").toString(),map.get("LINK_LABEL").toString());
					}
				}
				if(linkInfo.size() > 0){
					float l = (float)linkInfo.size() -1;
					allLog = "平均恢复率" + df.format(allPer/l);
				}
			}else{//指定1复用段，1设备分析
				for(int i=0; i<equipInfo.size(); i++){
					HashMap<Object,Object> map = equipInfo.get(i);
					allPer += loopBus(linkObj.get("LINK_ID").toString(),map.get("EQUIP_ID").toString(),
							linkObj.get("LINK_LABEL").toString(),map.get("EQUIP_NAME").toString());
				}
				if(equipInfo.size() > 0){
					float l = (float)equipInfo.size();
					allLog = "平均恢复率" + df.format(allPer/l);
				}
			}
		}
	}
	
	private static float loopBus(String id1, String id2, String label1, String label2){
		int failNum = 0,reNum = 0;
		float rePer = 1;
		//一设备或链路
		List<String> equiplst = new ArrayList<String>();
		List<String> linklst = new ArrayList<String>();
		if(id1.indexOf("#")!=-1){
			linklst.add(id1);//选中的链路
		}else{
			equiplst.add(id1);//选中的设备编码
		}
		if(id2.indexOf("#")!=-1){
			linklst.add(id2);
		}else{
			equiplst.add(id2);//其他的设备编码
		}
		List<Circuit> lst = new ArrayList<Circuit>();
		if(equiplst.size()==2){
			//2个设备故障情况
			Map map = new HashMap();
			map.put("equiplst", equiplst);
			lst= busDao.getBusinessInfo(map);
			failNum = lst.size();
			int u_num=0;
			for(int k=0;k<lst.size();k++){
				if(lst.get(k).getPath()==null||"".equals(lst.get(k).getPath())){
					continue;
				}
				String path = lst.get(k).getPath();
				String remark = lst.get(k).getRemark();
				if(remark==null||"".equals(remark)){
					u_num++;
				}else{
					if(path.contains(label1)&&remark.contains(label1)||path.contains(label2)&&remark.contains(label2)){
						u_num++;
					}else if(path.contains(label1)&&remark.contains(label2)||path.contains(label2)&&remark.contains(label1)){
						u_num++;
					}
				}
			}
			reNum = failNum-u_num;
		}else if(linklst.size()==2){//两条复用段情况
			String portcode = linklst.get(0).split("#")[0];
			String equipcode1 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
			portcode = linklst.get(0).split("#")[1];
			String equipcode2 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
			portcode = linklst.get(1).split("#")[0];
			String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
			portcode = linklst.get(1).split("#")[1];
			String equipcode4 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
			
			String equipcode = equipcode1;
			String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
			equipcode = equipcode2;
			String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
			equipcode = equipcode3;
			String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
			equipcode = equipcode4;
			String equipname4 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
			
			String s1 = equipname1+"->"+equipname2;
			String s2 = equipname2+"->"+equipname1;
			String s3 = equipname3+"->"+equipname4;
			String s4 = equipname4+"->"+equipname3;
			
			Map mp = new HashMap();
			mp.put("equipcode1", equipcode1);
			mp.put("equipcode2", equipcode2);
			mp.put("equipcode3", equipcode3);
			mp.put("equipcode4", equipcode4);
			lst = basedao.queryForList("getCircuitRouteInfoBy2Link", mp);
			
			for(int k=0;k<lst.size();k++){
				if(lst.get(k).getPath()==null||"".equals(lst.get(k).getPath())){
					continue;
				}
				String path = lst.get(k).getPath();
				String remark = lst.get(k).getRemark();
				boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(s3)||path.contains(s4);
				
				if(remark==null||"".equals(remark)){
					//无备用路由
					if(flag1){
						reNum++;
						failNum++;
					}
				}else{
					boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(s3)||remark.contains(s4);
					if(flag1 || flag2){
						failNum++;
						//2条复用段分别在同一电路的主备路由上
						boolean flag5 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s3)||remark.contains(s4))||(path.contains(s3)||path.contains(s4))&&(remark.contains(s1)||remark.contains(s2));
						boolean flag4 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s3)||path.contains(s4))&&(remark.contains(s4)||remark.contains(s3));
						boolean flag3 = !path.equals(s1)&&!path.equals(s2)&&!path.equals(s3)&&!path.equals(s4)&&!remark.equals(s1)&&!remark.equals(s2)&&!remark.equals(s3)&&!remark.equals(s4);
						if(flag4&&flag3){//至少一条复用段既在主上，又在备上
							reNum++;
						}else{
							if(flag5){
								reNum++;
							}
						}
					}
				}
			}
			reNum = failNum-reNum;
		}
		else{//1复用段，1设备情况
			
			String equipcode1 = equiplst.get(0);
			String equipcode = equipcode1;
			String equipname1 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
			
			String portcode = linklst.get(0).split("#")[0];
			String equipcode2 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
			portcode = linklst.get(0).split("#")[1];
			String equipcode3 = (String) basedao.queryForObject("getEquipcodeByPortCode", portcode);
			equipcode = equipcode2;
			String equipname2 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
			equipcode = equipcode3;
			String equipname3 = (String) basedao.queryForObject("getEquipNameByEquipcode", equipcode);
			String s1 = equipname2+"->"+equipname3;
			String s2 = equipname3+"->"+equipname2;
			
			Map mp = new HashMap();
			mp.put("equipcode1", equipcode1);
			mp.put("equipcode2", equipcode2);
			mp.put("equipcode3", equipcode3);
			List<Circuit> clst = new ArrayList<Circuit>();
			//查询1设备坏，1复用段断影响的电路数
			clst = basedao.queryForList("getCircuitRouteInfoByNodeAndLink", mp);
			for(int k=0;k<clst.size();k++){
				if(clst.get(k).getPath()==null||"".equals(clst.get(k).getPath())){
					continue;
				}
				String path = clst.get(k).getPath();
				String remark = clst.get(k).getRemark();
				boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(equipname1);
				if(remark==null||"".equals(remark)){
					if(flag1){//无备用
						reNum++;
						failNum++;
					}
				}else{
					boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(equipname1);
					if(flag1 || flag2){
						failNum++;
						boolean flag3 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&remark.contains(equipname1);
						if(flag3&&!path.equals(s1)&&!path.equals(s2)&&!remark.equals(s1)&&!remark.equals(s2)){
							reNum++;
						}else{//设备和复用段在主备上各一
							boolean flag4 = path.contains(equipname1)&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s1)||path.contains(s2))&&remark.contains(equipname1);
							if(flag4){
								reNum++;
							}
						}
					}
				}
			}
			reNum = failNum-reNum;
		}

		if(failNum > 0)
			rePer = (float)reNum/(float)failNum;
		if(log.size() < 40000)
			writeLog(label1+" + "+ label2,failNum,reNum,rePer);
		return rePer;
	}
	
	private static void writeLog(String name,int failNum, int reNum, float rePer){
		HashMap<Object,Object> info = new HashMap<Object,Object>();
		info.put("name", name);
		info.put("fail", failNum);
		info.put("re", reNum);
		info.put("lv", df.format(rePer));
		log.add(info);
	}
/*	private static void OneNode(){
		float allPer = 0;
		for(int i=0; i<equipInfo.size(); i++){//节点循环
			HashMap<Object,Object> map = equipInfo.get(i);
			String equipId = map.get("EQUIP_ID").toString();
			System.out.println("equipId"+equipId);
			int failNum = 0,reNum = 0;
			float rePer = 1;
			Map mp = new HashMap();
			mp.put("equipid", equipId);
			String returnstr = busDao.getfailandrecoverbyids(mp);
			System.out.println(returnstr+"returnstr");
			//影响的电路数
			failNum = Integer.parseInt(returnstr.split(";")[0]);
			System.out.println(failNum+"failNum");
			//可恢复的电路数
			reNum = Integer.parseInt(returnstr.split(";")[1]);
			//要记录的
			if(failNum > 0)
				rePer = (float)reNum/(float)failNum;
			allPer += rePer;
			String ss = map.get("EQUIP_LABEL").toString();
			writeLog(ss,failNum,reNum,rePer);
			//记录的条数过大先写再清空  应该再弄一个新函数，在每个大循环之后判断不然好废
			if(log.size() > 800000){
				//
				log.clear();
			}
		}
		//调用写函数 总的影响率
		if(equipInfo.size() > 0){
			float l = (float)equipInfo.size();
			
			allLog = "平均恢复率" + df.format(allPer/l);
		}
	}*/
	private static void OneNode(){
		float allPer = 0;
		System.out.println("equipInfo"+equipInfo.size());
		System.out.println("busInfo"+busInfo.size());
		for(int i=0; i<equipInfo.size(); i++){//节点循环
			HashMap<Object,Object> map = equipInfo.get(i);
			String equipId = map.get("EQUIP_ID").toString();
			int failNum = 0,reNum = 0;
			float rePer = 1;
			for(int p = 0; p<busInfo.size(); p++){//业务循环
				HashMap<Object,Object> ser = busInfo.get(p);
				int index1 = (Integer) ser.get("index1");
				String cid = ser.get("BUSINESS_ID").toString();
				List<String> temp = new ArrayList<String>();
				temp.add(equipId);
				int t1 = isRoute(index1,cid,temp);
				
				//先看主路由，主路由坏了就是影响了，再看备份可否回复
				if(t1 == 1){
					int index2 = (Integer) ser.get("index2");
					failNum++;
					int t2 = isBackRoute(index2,cid,temp);
					if(t2 == 0){
						reNum++;
					}
				}
			}
			//要记录的
			if(failNum > 0)
				rePer = (float)reNum/(float)failNum;
			allPer += rePer;
			writeLog(map.get("EQUIP_NAME").toString(),failNum,reNum,rePer);
			//记录的条数过大先写再清空  应该再弄一个新函数，在每个大循环之后判断不然好废
			if(log.size() > 800000){
				//
				log.clear();
			}
		}
		//调用写函数 总的影响率
		if(equipInfo.size() > 0){
			float l = (float)equipInfo.size();
			
			allLog = "平均恢复率" + df.format(allPer/l);
		}
	}	
	
	private static int isRoute(int index1,String cid,List<String> temp){
		for(int i = index1; i<cirRouteInfo.size() && 
			cirRouteInfo.get(i).get("CIRCUIT_ID").toString().equals(cid); i++){
			for(int j = 0; j<temp.size(); j++)
				if(temp.get(j).equals(cirRouteInfo.get(i).get("EQUIP_ID")) || 
					temp.get(j).equals(cirRouteInfo.get(i).get("LINK_ID")))
					return 1;
		}
		return 0;
	}
	private static int isBackRoute(int index1,String cid,List<String> temp){
		for(int i = index1; i<cirRouteBackInfo.size() && 
			cirRouteBackInfo.get(i).get("CIRCUIT_ID").toString().equals(cid); i++){
			for(int j = 0; j<temp.size(); j++)
				if(temp.get(j).equals(cirRouteBackInfo.get(i).get("EQUIP_ID")) || 
					temp.get(j).equals(cirRouteBackInfo.get(i).get("LINK_ID")))
					return 1;
		}
		if(index1 == cirRouteBackInfo.size())
			return 1;
		return 0;
	}
	private static void OneLink(){
		float allPer = 0;
		Map mp = new HashMap();
		for(int i=0; i<linkInfo.size(); i++){//节点循环
			HashMap<Object,Object> map = linkInfo.get(i);
			int failNum = 0,reNum = 0;
			float rePer = 1;
			String equipId1 = map.get("FROM_EQUIP_ID").toString();
			String equipId2 = map.get("TO_EQUIP_ID").toString();
			String equipname1 = map.get("FROM_EQUIP_NAME").toString();
			String equipname2 = map.get("TO_EQUIP_NAME").toString();
			//相当于两个设备同时故障
			mp.put("equipcode1", equipId1);
			mp.put("equipcode2", equipId2);
			List<Circuit> lst = basedao.queryForList("getCircuitRouteInfoNew", mp);
//			failNum = lst.size();//要过滤掉2个设备在不同路由上的情况
			String s1=equipname1+"->"+equipname2;
			String s2=equipname2+"->"+equipname1;
			for(int k=0;k<lst.size();k++){
				//
				if(lst.get(k).getPath()==null||"".equals(lst.get(k).getPath())){
					continue;
				}
				String path = lst.get(k).getPath();
				String remark = lst.get(k).getRemark();
				//路由中包含A->B或B->A的情况才能算是链路影响
				if(remark==null||"".equals(remark)){//没有备用
					if(path.contains(s1)||path.contains(s2)){
						failNum++;
						reNum++;
					}
				}else{
					if(path.contains(s1)||path.contains(s2)||remark.contains(s1)||remark.contains(s2)){
						failNum++;
						//2个设备必须同时处于主路由和备用路由上，否则表示可以恢复
						if((path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))&&!path.equals(s1)&&!path.equals(s2)&&!remark.equals(s1)&&!remark.equals(s2)){
							reNum ++;
						}
					}
				}
			}
			reNum = failNum-reNum;//可恢复
			

			//要记录的
			if(failNum > 0)
				rePer = (float)reNum/(float)failNum;
			writeLog(map.get("LINK_LABEL").toString(),failNum,reNum,rePer);
			allPer += rePer;
			//记录的条数过大先写再清空
		}
		//调用写函数
		if(linkInfo.size() > 0){
			float l = (float)linkInfo.size();
//			DecimalFormat df = new DecimalFormat("0.00%");
			allLog = "平均恢复率" + df.format(allPer/l);
		}
	}
	
	private static void TwoNode(){
		float allPer = 0;
		List<String> equiplst = new ArrayList<String>();
		for(int i=0; i<equipInfo.size(); i++){//节点循环
			HashMap<Object,Object> map = equipInfo.get(i);
			String equipId1 = map.get("EQUIP_ID").toString();
			String equipname1 = map.get("EQUIP_NAME").toString();
			equiplst.add(equipId1);
			for(int j = i+1; j<equipInfo.size(); j++){
				HashMap<Object,Object> map2 = equipInfo.get(j);
				String equipId2 = map2.get("EQUIP_ID").toString();
				String equipname2 = map2.get("EQUIP_NAME").toString();
				equiplst.add(equipId2);
				float rePer = 1;
				int failNum = 0, reNum = 0,u_num = 0;
				//2个设备同时故障时，
				Map map1 = new HashMap();
				map1.put("equiplst", equiplst);
				List<Circuit> lst = busDao.getBusinessInfo(map1);
				
				failNum = lst.size();
				for(int k=0;k<lst.size();k++){
					if(lst.get(k).getPath()==null||"".equals(lst.get(k).getPath())){
						continue;
					}
					String path = lst.get(k).getPath();
					String remark = lst.get(k).getRemark();
					if(remark==null||"".equals(remark)){//无备用
						u_num++;
					}else{//有备用
						if(path.contains(equipname1)&&remark.contains(equipname1)||path.contains(equipname2)&&remark.contains(equipname2)){
							u_num++;
						}else if(path.contains(equipname1)&&remark.contains(equipname2)||path.contains(equipname2)&&remark.contains(equipname1)){
							u_num++;
						}
					}
				}
				reNum = failNum-u_num;
				
				equiplst.remove(equipId2);
//				
				if(failNum > 0)
					rePer = (float)reNum/(float)failNum;
				allPer += rePer;
				if(log.size() < 40000)
					writeLog(map.get("EQUIP_LABEL").toString()+" + "+
						map2.get("EQUIP_LABEL"),failNum,reNum,rePer);
			}
			equiplst.remove(equipId1);
		}
		if(equipInfo.size() > 1){
			float l = (float)equipInfo.size();
//			DecimalFormat df = new DecimalFormat("0.00%");
			allLog = "平均恢复率" + df.format((allPer*2)/(l*(l-1)));
		}
	}
	private static void TwoLink(){
		float allPer = 0;
		for(int i=0; i<linkInfo.size(); i++){//节点循环
			HashMap<Object,Object> map = linkInfo.get(i);
			String equipId1 = map.get("FROM_EQUIP_ID").toString();
			String equipname1 = map.get("FROM_EQUIP_NAME").toString();
			String equipname2 = map.get("TO_EQUIP_NAME").toString();
			String s1 = equipname1+"->"+equipname2;
			String s2 = equipname2+"->"+equipname1;
			String equipId2 = map.get("TO_EQUIP_ID").toString();
			for(int j = i+1; j<linkInfo.size(); j++){
				HashMap<Object,Object> map2 = linkInfo.get(j);
				float rePer = 1;
				String equipId3 = map2.get("FROM_EQUIP_ID").toString();
				String equipId4 = map2.get("TO_EQUIP_ID").toString();
				String equipname3 = map2.get("FROM_EQUIP_NAME").toString();
				String equipname4 = map2.get("TO_EQUIP_NAME").toString();
				String s3 = equipname3+"->"+equipname4;
				String s4 = equipname4+"->"+equipname3;
				
				int failNum = 0, reNum = 0,u_num=0;
				List<Circuit> lst = new ArrayList<Circuit>();
				
				Map mp = new HashMap();
				mp.put("equipcode1", equipId1);
				mp.put("equipcode2", equipId2);
				mp.put("equipcode3", equipId3);
				mp.put("equipcode4", equipId4);
				lst = basedao.queryForList("getCircuitRouteInfoBy2Link", mp);
				for(int k=0;k<lst.size();k++){
					if(lst.get(k).getPath()==null||"".equals(lst.get(k).getPath())){
						continue;
					}
					String path = lst.get(k).getPath();
					String remark = lst.get(k).getRemark();
					
					boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(s3)||path.contains(s4);
					
					if(remark==null||"".equals(remark)){
						//无备用路由
						if(flag1){
							reNum++;
							failNum++;
						}
					}else{
						boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(s3)||remark.contains(s4);
						if(flag1 || flag2){
							failNum++;
							//2条复用段分别在同一电路的主备路由上
							boolean flag5 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s3)||remark.contains(s4))||(path.contains(s3)||path.contains(s4))&&(remark.contains(s1)||remark.contains(s2));
							boolean flag4 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s3)||path.contains(s4))&&(remark.contains(s4)||remark.contains(s3));
							boolean flag3 = !path.equals(s1)&&!path.equals(s2)&&!path.equals(s3)&&!path.equals(s4)&&!remark.equals(s1)&&!remark.equals(s2)&&!remark.equals(s3)&&!remark.equals(s4);
							if(flag4&&flag3){//至少一条复用段既在主上，又在备上
								reNum++;
							}else{
								if(flag5){
									reNum++;
								}
							}
						}
					}
				}
				
				reNum = failNum-reNum;//可恢复
				
				if(failNum > 0)
					rePer = (float)reNum/(float)failNum;
				
				allPer += rePer;
				if(log.size() < 40000)
					writeLog(map.get("LINK_LABEL").toString()+" + "+
						map2.get("LINK_LABEL"),failNum,reNum,rePer);
			}
		}
		if(linkInfo.size() > 1){
			float l = (float)linkInfo.size();
//			DecimalFormat df = new DecimalFormat("0.00%");
			allLog = "平均恢复率" + df.format((allPer*2)/(l*(l-1)));
		}
	}
	private static void NodeAndLink(){
		float allPer = 0;
		for(int i=0; i<equipInfo.size(); i++){//节点循环
			HashMap<Object,Object> map = equipInfo.get(i);
			String equipId = map.get("EQUIP_ID").toString();
			String equipname1 = map.get("EQUIP_NAME").toString();
			for(int j = 0; j<linkInfo.size(); j++){
				HashMap<Object,Object> map2 = linkInfo.get(j);
				float rePer = 1;
				String equipId2 = map2.get("FROM_EQUIP_ID").toString();
				String equipId3 = map2.get("TO_EQUIP_ID").toString();
				String equipname2 = map2.get("FROM_EQUIP_NAME").toString();
				String equipname3 = map2.get("TO_EQUIP_NAME").toString();
				String s1 = equipname2+"->"+equipname3;
				String s2 = equipname3+"->"+equipname2;
				int failNum = 0, reNum = 0;
				
				Map map1 = new HashMap();
				map1.put("equipcode1", equipId);
				map1.put("equipcode2", equipId2);//转换成string
				map1.put("equipcode3", equipId3);
				//查询1设备坏，1复用段断影响的电路数
				List<Circuit> lst = basedao.queryForList("getCircuitRouteInfoByNodeAndLink", map1);
				for(int k=0;k<lst.size();k++){
					if(lst.get(k).getPath()==null||"".equals(lst.get(k).getPath())){
						continue;
					}
					String path = lst.get(k).getPath();
					String remark = lst.get(k).getRemark();
					boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(equipname1);
					if(remark==null||"".equals(remark)){
						if(flag1){//无备用
							failNum++;
							reNum++;
						}
					}else{
						boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(equipname1);
						if(flag1 || flag2){
							failNum++;
							//设备在主备上都有，或者复用段在主备上都有
							boolean flag3 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&remark.contains(equipname1);
							if(flag3&&!path.equals(s1)&&!path.equals(s2)&&!remark.equals(s1)&&!remark.equals(s2)){
								reNum++;
							}else{//设备和复用段在主备上各一
								boolean flag4 = path.contains(equipname1)&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s1)||path.contains(s2))&&remark.contains(equipname1);
								if(flag4){
									reNum++;
								}
							}
						}
					}
				}
				
				
				reNum =failNum-reNum;
				
				if(failNum > 0)
					rePer = (float)reNum/(float)failNum;
				allPer += rePer;
				if(log.size() < 40000)
					writeLog(map.get("EQUIP_LABEL").toString()+" + "+
						map2.get("LINK_LABEL"),failNum,reNum,rePer);
			}
		}
		if(linkInfo.size() > 0){
			float l = (float)equipInfo.size();
			float l2 = (float)linkInfo.size();
//			DecimalFormat df = new DecimalFormat("0.00%");
			allLog = "平均恢复率" + df.format(allPer/(l*l2));
		}
	}
	
	private static void ThreeNode(){
		float allPer = 0;
		List<String> equiplst = new ArrayList<String>();
		for(int i=0; i<equipInfo.size(); i++){//节点循环
			HashMap<Object,Object> map = equipInfo.get(i);
			String equipId1 = map.get("EQUIP_ID").toString();
			String equipname1 = map.get("EQUIP_NAME").toString();
			equiplst.add(equipId1);
			for(int j = i+1; j<equipInfo.size(); j++){
				HashMap<Object,Object> map2 = equipInfo.get(j);
				String equipId2 = map2.get("EQUIP_ID").toString();
				String equipname2 = map2.get("EQUIP_NAME").toString();
				equiplst.add(equipId2);
				for(int k = j+1; k<equipInfo.size(); k++){
					HashMap<Object,Object> map3 = equipInfo.get(k);
					String equipId3 = map3.get("EQUIP_ID").toString();
					String equipname3 = map3.get("EQUIP_NAME").toString();
					equiplst.add(equipId3);
					float rePer = 1;
					int failNum = 0, reNum = 0,u_num=0;
					
					//3个设备同时故障时，
					Map map1 = new HashMap();
					map1.put("equiplst", equiplst);
					
					List<Circuit> lst = busDao.getBusinessInfo(map1);
					
					failNum = lst.size();
					for(int x=0;x<lst.size();x++){
						if(lst.get(x).getPath()==null||"".equals(lst.get(x).getPath())){
							continue;
						}
						String path = lst.get(x).getPath();
						String remark = lst.get(x).getRemark();
						if(remark==null||"".equals(remark)){//无备用
							u_num++;
						}else{
							if(path.contains(equipname1)&&remark.contains(equipname1)||path.contains(equipname2)&&remark.contains(equipname2)||path.contains(equipname3)&&remark.contains(equipname3)){
								u_num++;
							}else if(path.contains(equipname1)&&remark.contains(equipname2)||path.contains(equipname1)&&remark.contains(equipname3)||path.contains(equipname2)&&remark.contains(equipname1)||path.contains(equipname2)&&remark.contains(equipname3)||path.contains(equipname3)&&remark.contains(equipname1)||path.contains(equipname3)&&remark.contains(equipname2)){
								u_num++;
							}
						}
					}
					reNum = failNum -u_num;
					
					equiplst.remove(equipId3);

					if(failNum > 0)
						rePer = (float)reNum/(float)failNum;
					allPer += rePer;
					if(log.size() < 40000)
						writeLog(map.get("EQUIP_LABEL").toString() + " + " + 
							map2.get("EQUIP_LABEL") + " + " + map3.get("EQUIP_LABEL"),
							failNum,reNum,rePer);
				}
				
				//refreshArray();
				equiplst.remove(equipId2);
			}
			equiplst.remove(equipId1);
		}
		if(equipInfo.size() > 2){
			float l = (float)equipInfo.size();
//			DecimalFormat df = new DecimalFormat("0.00%");
			allLog = "平均恢复率" + df.format((allPer*6)/(l*(l-1)*(l-2)));
		}
	}
	private static void ThreeLink(){
		float allPer = 0;
		for(int i=0; i<linkInfo.size(); i++){//link循环
			HashMap<Object,Object> map = linkInfo.get(i);
			String equipId1 = map.get("FROM_EQUIP_ID").toString();
			String equipId2 = map.get("TO_EQUIP_ID").toString();
			String equipname1 = map.get("FROM_EQUIP_NAME").toString();
			String equipname2 = map.get("TO_EQUIP_NAME").toString();
			String s1 = equipname1+"->"+equipname2;
			String s2 = equipname2+"->"+equipname1;
			for(int j = i+1; j<linkInfo.size(); j++){
				HashMap<Object,Object> map2 = linkInfo.get(j);
				String equipId3 = map2.get("FROM_EQUIP_ID").toString();
				String equipId4 = map2.get("TO_EQUIP_ID").toString();
				String equipname3 = map2.get("FROM_EQUIP_NAME").toString();
				String equipname4 = map2.get("TO_EQUIP_NAME").toString();
				String s3 = equipname3+"->"+equipname4;
				String s4 = equipname4+"->"+equipname3;
				for(int k = j+1; k<linkInfo.size(); k++){
					HashMap<Object,Object> map3 = linkInfo.get(k);
					String equipId5 = map3.get("FROM_EQUIP_ID").toString();
					String equipId6 = map3.get("TO_EQUIP_ID").toString();
					String equipname5 = map3.get("FROM_EQUIP_NAME").toString();
					String equipname6 = map3.get("TO_EQUIP_NAME").toString();
					String s5 = equipname5+"->"+equipname6;
					String s6 = equipname6+"->"+equipname5;
					
					float rePer = 1;
					int failNum = 0, reNum = 0;
					
					List<Circuit> lst = new ArrayList<Circuit>();
					
					Map mp = new HashMap();
					mp.put("equipcode1", equipId1);
					mp.put("equipcode2", equipId2);
					mp.put("equipcode3", equipId3);
					mp.put("equipcode4", equipId4);
					mp.put("equipcode5", equipId5);
					mp.put("equipcode6", equipId6);
					lst = basedao.queryForList("getCircuitRouteInfoBy3Link", mp);
					
					for(int p=0;p<lst.size();p++){
						if(lst.get(p).getPath()==null||"".equals(lst.get(p).getPath())){
							continue;
						}
						String path = lst.get(p).getPath();
						String remark = lst.get(p).getRemark();
						boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(s3)||path.contains(s4)||path.contains(s5)||path.contains(s6);
						
						if(remark==null||"".equals(remark)){
							//无备用路由
							if(flag1){//主路径中包含3条复用段中的1条或更多
								reNum++;//中断
								failNum++;//影响
							}
						}else{
							boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(s3)||remark.contains(s4)||remark.contains(s5)||remark.contains(s6);
							if(flag1||flag2){
								failNum++;
								//flag4表示至少一条复用段既在主上，又在备上
								boolean flag4 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s3)||path.contains(s4))&&(remark.contains(s4)||remark.contains(s3))||(path.contains(s5)||path.contains(s6))&&(remark.contains(s5)||remark.contains(s6));
								boolean flag3 = !path.equals(s1)&&!path.equals(s2)&&!path.equals(s3)&&!path.equals(s4)&&!path.equals(s5)&&!path.equals(s6)&&!remark.equals(s1)&&!remark.equals(s2)&&!remark.equals(s3)&&!remark.equals(s4)&&!remark.equals(s5)&&!remark.equals(s6);
								//flag5表示至少1条在主上，至少1条在备上
								boolean flag5 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s3)||remark.contains(s4))||(path.contains(s1)||path.contains(s2))&&(remark.contains(s5)||remark.contains(s6))||(path.contains(s3)||path.contains(s4))&&(remark.contains(s1)||remark.contains(s2))
								                 ||(path.contains(s3)||path.contains(s4))&&(remark.contains(s5)||remark.contains(s6))||(path.contains(s5)||path.contains(s6))&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s5)||path.contains(s6))&&(remark.contains(s3)||remark.contains(s4));
								
								if(flag3&&flag4){
									reNum++;
								}else{
									if(flag5){
										reNum++;
									}
								}
							}
						}
					}
					reNum = failNum-reNum;
					
					if(failNum > 0)
						rePer = (float)reNum/(float)failNum;
					allPer += rePer;
					if(log.size() < 40000)
						writeLog(map.get("LINK_LABEL").toString() + " + " + 
							map2.get("LINK_LABEL") + " + " + map3.get("LINK_LABEL"),
							failNum,reNum,rePer);
				}
			}
		}
		if(linkInfo.size() > 2){
			float l = (float)linkInfo.size();
//			DecimalFormat df = new DecimalFormat("0.00%");
			allLog = "平均恢复率" + df.format((allPer*6)/(l*(l-1)*(l-2)));
		}
	}
	private static void TwoNodeAndLink(){
		float allPer = 0;
		for(int i=0; i<equipInfo.size(); i++){//节点循环
			HashMap<Object,Object> map = equipInfo.get(i);
			String equipId1 = map.get("EQUIP_ID").toString();
			String equipname1 = map.get("EQUIP_NAME").toString();
			for(int j = i+1; j<equipInfo.size(); j++){
				HashMap<Object,Object> map2 = equipInfo.get(j);
				String equipId2 = map2.get("EQUIP_ID").toString();
				String equipname2 = map2.get("EQUIP_NAME").toString();
				for(int k = 0; k<linkInfo.size(); k++){
					HashMap<Object,Object> map3 = linkInfo.get(k);
					String equipId3 = map3.get("FROM_EQUIP_ID").toString();
					String equipId4 = map3.get("TO_EQUIP_ID").toString();
					String equipname3 = map3.get("FROM_EQUIP_NAME").toString();
					String equipname4 = map3.get("TO_EQUIP_NAME").toString();
					String s1 = equipname3+"->"+equipname4;
					String s2 = equipname4+"->"+equipname3;
					float rePer = 1;
					int failNum = 0, reNum = 0;
					
					Map map1 = new HashMap();
					map1.put("equipcode1", equipId1);
					map1.put("equipcode2", equipId2);
					map1.put("equipcode3", equipId3);
					map1.put("equipcode4", equipId4);
					
					List<Circuit> lst = basedao.queryForList("getCircuitRouteInfoBy2NodeAndLink", map1);
					for(int p=0;p<lst.size();p++){
						if(lst.get(p).getPath()==null||"".equals(lst.get(p).getPath())){
							continue;
						}
						String path = lst.get(p).getPath();
						String remark = lst.get(p).getRemark();
						boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(equipname1)||path.contains(equipname2);
						if(remark==null||"".equals(remark)){
							if(flag1){//无备用
								failNum++;
								reNum++;
							}
						}else{
							boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(equipname1)||remark.contains(equipname2);
							if(flag1 || flag2){
								failNum++;
								//设备在主备上都有，或者复用段在主备上都有
								boolean flag3 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&remark.contains(equipname1)||path.contains(equipname2)&&remark.contains(equipname2);
								if(flag3&&!path.equals(s1)&&!path.equals(s2)&&!remark.equals(s1)&&!remark.equals(s2)){
									reNum++;
								}else{//2设备和复用段至少在主备上各一
									boolean flag4 = (path.contains(s1)||path.contains(s2))&&remark.contains(equipname1)||(path.contains(s1)||path.contains(s2))&&remark.contains(equipname2)
									||path.contains(equipname1)&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&remark.contains(equipname2)
									||path.contains(equipname2)&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname2)&&remark.contains(equipname1);
									if(flag4){
										reNum++;
									}
								}
							}
						}
					}
					reNum = failNum-reNum;

					if(failNum > 0)
						rePer = (float)reNum/(float)failNum;
					allPer += rePer;
					if(log.size() < 40000)
						writeLog(map.get("EQUIP_LABEL").toString() + " + " + 
							map2.get("EQUIP_LABEL") + " + " + map3.get("LINK_LABEL"),
							failNum,reNum,rePer);
				}
			}
		}
		if(linkInfo.size() > 0){
			float l = (float)equipInfo.size();
			float l2 = (float)linkInfo.size();
//			DecimalFormat df = new DecimalFormat("0.00%");
			allLog = "平均恢复率" + df.format((allPer*2)/(l*(l-1)*l2));
		}
	}
	private static void NodeAndTwoLink(){
		float allPer = 0;
		for(int i=0; i<equipInfo.size(); i++){//节点循环
			HashMap<Object,Object> map = equipInfo.get(i);
			String equipId1 = map.get("EQUIP_ID").toString();
			String equipname1 = map.get("EQUIP_NAME").toString();
			for(int j = 0; j<linkInfo.size(); j++){
				HashMap<Object,Object> map2 = linkInfo.get(j);
				String equipId2 = map2.get("FROM_EQUIP_ID").toString();
				String equipId3 = map2.get("TO_EQUIP_ID").toString();
				String equipname2 = map2.get("FROM_EQUIP_NAME").toString();
				String equipname3 = map2.get("TO_EQUIP_NAME").toString();
				for(int k = j+1; k<linkInfo.size(); k++){
					HashMap<Object,Object> map3 = linkInfo.get(k);
					String equipId4 = map3.get("FROM_EQUIP_ID").toString();
					String equipId5 = map3.get("TO_EQUIP_ID").toString();
					String equipname4 = map3.get("FROM_EQUIP_NAME").toString();
					String equipname5 = map3.get("TO_EQUIP_NAME").toString();
					float rePer = 1;
					int failNum = 0, reNum = 0;
					
					String s1 = equipname2+"->"+equipname3;
					String s2 = equipname3+"->"+equipname2;
					String s3 = equipname4+"->"+equipname5;
					String s4 = equipname5+"->"+equipname4;
					
					Map mp = new HashMap();
					mp.put("equipcode1", equipId1);
					mp.put("equipcode2", equipId2);
					mp.put("equipcode3", equipId3);
					mp.put("equipcode4", equipId4);
					mp.put("equipcode5", equipId5);
					List<Circuit> clst = new ArrayList<Circuit>();
					//查询1设备坏，1复用段断影响的电路数
					clst = basedao.queryForList("getCircuitRouteInfoByNodeAnd2Link", mp);
					for(int p=0;p<clst.size();p++){
						if(clst.get(p).getPath()==null||"".equals(clst.get(p).getPath())){
							continue;
						}
						String path = clst.get(p).getPath();
						String remark = clst.get(p).getRemark();
						boolean flag1 = path.contains(s1)||path.contains(s2)||path.contains(equipname1)||path.contains(s3)||path.contains(s4);
						if(remark==null||"".equals(remark)){
							if(flag1){//无备用
								failNum++;
								reNum++;
							}
						}else{
							boolean flag2 = remark.contains(s1)||remark.contains(s2)||remark.contains(equipname1)||remark.contains(s3)||remark.contains(s4);
							if(flag1 || flag2){
								failNum++;
								boolean flag3 = (path.contains(s1)||path.contains(s2))&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&remark.contains(equipname1)||(path.contains(s3)||path.contains(s4))&&(remark.contains(s3)||remark.contains(s4));
								if(flag3&&!path.equals(s1)&&!path.equals(s2)&&!remark.equals(s1)&&!remark.equals(s2)&&!path.equals(s3)&&!path.equals(s4)&&!remark.equals(s3)&&!remark.equals(s4)){
									reNum++;
								}else{//2设备和复用段至少在主备上各一
									boolean flag4 = (path.contains(s1)||path.contains(s2))&&remark.contains(equipname1)||(path.contains(s1)||path.contains(s2))&&(remark.contains(s3)||remark.contains(s4))
									||path.contains(equipname1)&&(remark.contains(s1)||remark.contains(s2))||path.contains(equipname1)&&(remark.contains(s3)||remark.contains(s4))
									||(path.contains(s3)||path.contains(s4))&&(remark.contains(s1)||remark.contains(s2))||(path.contains(s3)||path.contains(s4))&&remark.contains(equipname1);
									if(flag4){
										reNum++;
									}
								}
							}
						}
					}
					reNum = failNum-reNum;
					
					if(failNum > 0)
						rePer = (float)reNum/(float)failNum;
					allPer += rePer;
					if(log.size() < 40000)
						writeLog(map.get("EQUIP_LABEL").toString() + " + " + 
								map2.get("LINK_LABEL") + " + " + map3.get("LINK_LABEL"),
								failNum,reNum,rePer);
				}
			}
		}
		if(linkInfo.size() > 1){
			float l = (float)equipInfo.size();
			float l2 = (float)linkInfo.size();
//			DecimalFormat df = new DecimalFormat("0.00%");
			allLog = "平均恢复率" + df.format((allPer*2)/(l*(l2-1)*l2));
		}
	}
	

}
