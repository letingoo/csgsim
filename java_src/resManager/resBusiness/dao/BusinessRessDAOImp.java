package resManager.resBusiness.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import netres.model.ComboxDataModel;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import channelroute.model.CircuitroutModel;

import com.ibatis.sqlmap.client.SqlMapClient;

import resManager.resBusiness.model.Circuit;
import resManager.resBusiness.model.CircuitBusinessModel;
import resManager.resBusiness.model.CircuitChannel;
import resManager.resBusiness.model.GetSystemRelations;
import resManager.resBusiness.model.Node;

import resManager.resBusiness.dao.BusinessRessDAO;
import resManager.resBusiness.model.BusinessRessModel;
import resManager.resNet.model.CCModel;

public class BusinessRessDAOImp  extends SqlMapClientDaoSupport implements BusinessRessDAO {


	public int getRessCount(BusinessRessModel model) {
		int i = 0;
		try {
			i = (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getRessCount", model);

		} catch (Exception e) {
			e.printStackTrace();

		}

		return i;
	}

	public List getRessList(BusinessRessModel model) {

		return this.getSqlMapClientTemplate().queryForList("getRess", model);
	}

	public void insertRess(BusinessRessModel mo) {
		this.getSqlMapClientTemplate().insert("insertRess", mo);
	}

	public boolean deleRess(BusinessRessModel mo) {
		this.getSqlMapClientTemplate().delete("delRess", mo);
		return true;
	}

	public void updateRess(BusinessRessModel mo) {
		this.getSqlMapClientTemplate().update("updateRess", mo);
	}
	
	public List getCircuitBySearchText(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getCircuitBySearchText", map);
	}
	
	public List getCircuitCodeBySearchText(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getCircuitCodeBySearchText", map);
	}
	
	public List<ComboxDataModel> getStationAByCircuitcode(String circuitcode) {
		return this.getSqlMapClientTemplate().queryForList("getStationAByCircuitcode", circuitcode);
		
	}
	public List<ComboxDataModel> getStationZByCircuitcode(String circuitcode) {
		return this.getSqlMapClientTemplate().queryForList("getStationZByCircuitcode", circuitcode);
	}
	
	public List getCircuitList(Circuit circuit) {

		return this.getSqlMapClientTemplate().queryForList("getCircuitList", circuit);
	}
	@Override
	public Integer getCircuitListCount(Circuit circuit) {
		// TODO Auto-generated method stub
		return (Integer) this.getSqlMapClientTemplate().queryForObject("getCircuitListCount", circuit);
	}
	
	
	public boolean deleteCircuit(String circuitcode) {
		//删除电路的同时要删除业务，及电路业务关系
		SqlMapClient sqlMap = this.getSqlMapClient();
		
		try {
			sqlMap.startTransaction();
			List<String> bussiness_ids = sqlMap.queryForList("getRess_Business_id", circuitcode);
			
			
			BusinessRessModel model = new BusinessRessModel();
			Map map = new HashMap();
			map.put("circuitcode", circuitcode);
			for(int j=0;j<bussiness_ids.size();j++){
				model.setBusiness_id(bussiness_ids.get(j));
				//删除业务
				this.deleRess(model);
				map.put("business_id", bussiness_ids.get(j));
				//删除业务关系
				sqlMap.delete("deleteCircuitBusiness",map);
			}
			
			//删除端口表中对应circuit字段
			sqlMap.update("updateEquiplogicportCircuit", circuitcode);
			//删除电路对应交叉
			sqlMap.delete("deleteCCByCircuitcode",circuitcode);
			//删除路由
			map.put("v_name", circuitcode);
			sqlMap.delete("deleteCircuitRoutByCircuitcode",map);
			
			sqlMap.delete("deleteCircuit", circuitcode);
			
			sqlMap.commitTransaction();
		}catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return true;
	}
	
	public String getCircuitCode(String schedulerid) {
		return (String)this.getSqlMapClientTemplate().queryForObject("getCircuitCode", schedulerid);
	}
	
	public void addCircuit(Circuit circuit) {
		
		SqlMapClient sqlMap = this.getSqlMapClient();
		
		try {
			sqlMap.startTransaction();
			sqlMap.insert("addCircuit", circuit);
			
			String porta=circuit.getPortcode1();
			String portz=circuit.getPortcode2();
			String portcode = porta;
			String systemcode = (String) sqlMap.queryForObject("getSystemCodeByPortcode", portcode);
			String equipcodeA = (String) sqlMap.queryForObject("getEquipcodeByPortcode", porta);
			porta = portz;
			String equipcodeZ = (String) sqlMap.queryForObject("getEquipcodeByPortcode", porta);
			//找2端的最短路径，
			Object[] equips = getMinLengthByEquips(equipcodeA,equipcodeZ,systemcode);
			if(equips==null){
				equips = new Object[]{};
			}
			if(equips.length>0){
				//建立交叉，根据复用段，如果有交叉则不建
				List<String> equiplst = new ArrayList<String>();
				String path="";
				for(int i=0;i<equips.length;i++){
					Node equip = (Node)equips[i];
					equiplst.add(equip.getName());//设备编号
					String paraValue = equip.getName();
					String equipname = (String) sqlMap.queryForObject("getEquipNameByEqcode", paraValue);
					if(i<equips.length-1){
						path=path+equipname+"-->";
					}else{
						path=path+equipname;
					}
				}
				//修改电路表中主路由路径
				Map mp = new HashMap();
				mp.put("path", path);
				mp.put("remark", "");
				mp.put("circuitcode", circuit.getCircuitcode());
				sqlMap.update("updateCircuitRouteByMap", mp); 
				
				List<String> portlst = new ArrayList<String>();//端口列表
				String startport=circuit.getPortcode1();
				portlst.add(startport);
				String startslot = circuit.getSlot1();
				String endslot = circuit.getSlot1();
				if(equiplst.size()>1){
					for(int p=0;p<equiplst.size()-1;p++){
						Map map =new HashMap();
						map.put("equipA", equiplst.get(p));
						map.put("equipZ", equiplst.get(p+1));
						List<CCModel> endportLst = sqlMap.queryForList("getEndPortcodeByToplink", map);
						String starttemp = endportLst.get(0).getAptp();
						portlst.add(starttemp);
						String endport = endportLst.get(0).getZptp();
						portlst.add(endport);
						
					}
				}
				
				portlst.add(circuit.getPortcode2());
				
				for(int t=0;t<portlst.size()-1;t=t+2){
					if(t==portlst.size()-2){
						endslot = circuit.getSlot2();
					}
					boolean flag=true;
					while(flag){
						Map ccmap = new HashMap();
						ccmap.put("APTP", portlst.get(t));
						ccmap.put("ZPTP", portlst.get(t+1));
						ccmap.put("ASLOT", startslot);
						ccmap.put("ZSLOT", endslot);
						ccmap.put("PID", ((Node)equips[t/2]).getName());
						ccmap.put("ID", portlst.get(t)+"-"+startslot+"-"+portlst.get(t+1)+"-"+endslot+"-VC12");
						List<CCModel> cc = sqlMap.queryForList("getCCbyMap", ccmap);
						if(cc.size()>0){
							if(t==0){
								//换Z端时隙
								endslot = endslot+1;
							}
							else{//换A端
								startslot = startslot+1; 
							}
						}else{
							//插入交叉
							flag=false;
							sqlMap.insert("insertCCInfoByMap", ccmap);
						}
					}
				}
				//串接路由
				
				Map paraMap = new HashMap();
				paraMap.put("v_name", circuit.getCircuitcode());
				paraMap.put("logicport", circuit.getPortcode1());
				String rate;
				if("155M".equals(circuit.getRate())){
					rate="VC4";
				}else{
					rate="VC12";
				}
		        paraMap.put("vc", rate);
		        paraMap.put("slot", circuit.getSlot1());
		        //删除路由
		        sqlMap.delete("deleteCircuitRoutByCircuitcode", paraMap);
		        //串接路由
		        sqlMap.queryForObject("callRouteGenerate",paraMap);
	
		      //修改端口表中的电路编号字段
		        channelroute.model.Circuit key = new channelroute.model.Circuit();
		        key.setPortserialno1(circuit.getPortcode1());
		        key.setPortserialno2(circuit.getPortcode2());
		        key.setCircuitcode(circuit.getCircuitcode());
		        sqlMap.update("updateEquiplogicportForRelateCircuit", key);
		        
				sqlMap.commitTransaction();
			}
		}catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}
	
	public void modifyCircuit(Circuit circuit){
		
		SqlMapClient sqlMap = this.getSqlMapClient();
		
		try {
			sqlMap.startTransaction();
			sqlMap.update("modifyCircuit", circuit);
			String porta=circuit.getPortcode1();
			String portz=circuit.getPortcode2();
			String portcode = porta;
			String systemcode = (String) sqlMap.queryForObject("getSystemCodeByPortcode", portcode);
			String equipcodeA = (String) sqlMap.queryForObject("getEquipcodeByPortcode", porta);
			porta = portz;
			String equipcodeZ = (String) sqlMap.queryForObject("getEquipcodeByPortcode", porta);
			//找2端的最短路径，
			Object[] equips = getMinLengthByEquips(equipcodeA,equipcodeZ,systemcode);
			//建立交叉，根据复用段，如果有交叉则不建
			List<String> equiplst = new ArrayList<String>();
			String path="";
			for(int i=0;i<equips.length;i++){
				Node equip = (Node)equips[i];
				equiplst.add(equip.getName());//设备编号
				String paraValue = equip.getName();
				String equipname = (String) sqlMap.queryForObject("getEquipNameByEqcode", paraValue);
				if(i<equips.length-1){
					path=path+equipname+"-->";
				}else{
					path=path+equipname;
				}
			}
			//修改电路表中主路由路径
			Map mp = new HashMap();
			mp.put("path", path);
			mp.put("remark", "");
			mp.put("circuitcode", circuit.getCircuitcode());
			sqlMap.update("updateCircuitRouteByMap", mp); 
			
			List<String> portlst = new ArrayList<String>();//端口列表
			String startport=circuit.getPortcode1();
			portlst.add(startport);
			String startslot = circuit.getSlot1();
			String endslot = circuit.getSlot1();
			if(equiplst.size()>1){
				for(int p=0;p<equiplst.size()-1;p++){
					Map map =new HashMap();
					map.put("equipA", equiplst.get(p));
					map.put("equipZ", equiplst.get(p+1));
					List<CCModel> endportLst = sqlMap.queryForList("getEndPortcodeByToplink", map);
					String starttemp = endportLst.get(0).getAptp();
					portlst.add(starttemp);
					String endport = endportLst.get(0).getZptp();
					portlst.add(endport);
					
				}
			}
			portlst.add(circuit.getPortcode2());
			//删除当前电路中路由交叉
			sqlMap.delete("deleteCCByCircuitcodeMap", mp);
			
			for(int t=0;t<portlst.size()-1;t=t+2){
				if(t==portlst.size()-2){
					endslot = circuit.getSlot2();
				}
				boolean flag=true;
				while(flag){
					Map ccmap = new HashMap();
					ccmap.put("APTP", portlst.get(t));
					ccmap.put("ZPTP", portlst.get(t+1));
					ccmap.put("ASLOT", startslot);
					ccmap.put("ZSLOT", endslot);
					ccmap.put("PID", ((Node)equips[t/2]).getName());
					ccmap.put("ID", portlst.get(t)+"-"+startslot+"-"+portlst.get(t+1)+"-"+endslot+"-VC12");
					List<CCModel> cc = sqlMap.queryForList("getCCbyMap", ccmap);
					if(cc.size()>0){
						if(t==0){
							//换Z端时隙
							endslot = endslot+1;
						}
						else{//换A端
							startslot = startslot+1; 
						}
					}else{
						//插入交叉
						flag=false;
						sqlMap.insert("insertCCInfoByMap", ccmap);
					}
				}
			}
			//串接路由
			
			Map paraMap = new HashMap();
			paraMap.put("v_name", circuit.getCircuitcode());
			paraMap.put("logicport", circuit.getPortcode1());
			String rate;
			if("155M".equals(circuit.getRate())){
				rate="VC4";
			}else{
				rate="VC12";
			}
	        paraMap.put("vc", rate);
	        paraMap.put("slot", circuit.getSlot1());
	        //删除路由
	        sqlMap.delete("deleteCircuitRoutByCircuitcode", paraMap);
	        //串接路由
	        sqlMap.queryForObject("callRouteGenerate",paraMap);
	        
	      //修改端口表中的电路编号字段
	        channelroute.model.Circuit key = new channelroute.model.Circuit();
	        key.setPortserialno1(circuit.getPortcode1());
	        key.setPortserialno2(circuit.getPortcode2());
	        sqlMap.update("updateEquiplogicportForRelateCircuit", key);
	        
			sqlMap.commitTransaction();
		}catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}
	
	public List<ComboxDataModel>  getStationList(){
		return this.getSqlMapClientTemplate().queryForList("getStationList");
	}
	
	public List<ComboxDataModel>  getX_purposeList(){
		return this.getSqlMapClientTemplate().queryForList("getX_purposeList");
	}
	
	public List<ComboxDataModel>  getRateList(){
		return this.getSqlMapClientTemplate().queryForList("getRateList");
	}
	
	public int getCircuitBusinessCount(CircuitBusinessModel circuitbusiness){
		return (Integer) this.getSqlMapClientTemplate().queryForObject("getCircuitBusinessCount", circuitbusiness);
	}
	public List getCircuitBusinessList(CircuitBusinessModel circuitbusiness){
		return this.getSqlMapClientTemplate().queryForList("getCircuitBusinessList",circuitbusiness);
	}
	
	public void addCircuitBusiness(CircuitBusinessModel circuitbusiness){
		this.getSqlMapClientTemplate().insert("addCircuitBusiness",circuitbusiness);
	}
	
	public List getBusinessBySearchText(Map map){
		return this.getSqlMapClientTemplate().queryForList("getBusinessBySearchText",map);
	}
	public List getBusinessIdBySearchText(Map map){
		return this.getSqlMapClientTemplate().queryForList("getBusinessIdBySearchText",map);
	}
	
	public void modifyCircuitBusiness(CircuitBusinessModel circuitbusiness){
		this.getSqlMapClientTemplate().update("modifyCircuitBusiness", circuitbusiness);
	}
	
	public boolean deleteCircuitBusiness(Map map){
		this.getSqlMapClientTemplate().delete("deleteCircuitBusiness", map);
		return true;
	}
	
	public int getUnusedCCCount() {
		int i = 0;
		try {
			i = (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getUnusedCCCount");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return i;
	}
	
	public boolean deleteUnusedCC(){
		this.getSqlMapClientTemplate().delete("deleteUnusedCC");
		return true;
	}
	public List MygetCircuitList(Circuit circuit) {
		//System.out.println("MygetCircuitList");
		return this.getSqlMapClientTemplate().queryForList("MygetCircuitList", circuit);
	}
	public Integer MygetCircuitListCount(Circuit circuit) {
		//System.out.println("MygetCircuitListCount");
		Integer i =  (Integer) this.getSqlMapClientTemplate().queryForObject("MygetCircuitListCount", circuit);
		return (Integer) i;
	}

	@Override
	public List<ComboxDataModel> getSlotALstByPortcode(String portcode) {
		return this.getSqlMapClientTemplate().queryForList("getSlotALstByPortcode", portcode);
	}
	@Override
	public List<ComboxDataModel> getSlotZLstByPortcode(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getSlotZLstByPortcode", map);
	}

	@Override
	public int getCircuitChannelCount(CircuitChannel model) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getCircuitChannelCount", model);
	}

	@Override
	public List getCircuitChannelList(CircuitChannel model) {
		return this.getSqlMapClientTemplate().queryForList("getCircuitChannelList", model);
	}

	@Override
	public List<String> getCircuitByMapA(Map<String, String> map) {
		return this.getSqlMapClientTemplate().queryForList("getCircuitByMapA", map);
	}

	@Override
	public String getSystemCodeByPortcode(String portcode) {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClientTemplate().queryForObject("getSystemCodeByPortcode", portcode);
	}

	/**
	 * @author 尹显贵
	 * @param 起止设备,传输系统名称
	 * @return 返回两设备间的最短路径
	 * */
	public  Object[] getMinLengthByEquips(String startcode,String endcode,String systemcode) {
		List<String> lst = new ArrayList<String>();
		
		lst = this.getSqlMapClientTemplate().queryForList("getequipcodelst", systemcode);
		int nodeRalation[][]=new int[lst.size()][lst.size()];
		int s=0;int e=0;
		for(int n=0;n<lst.size();n++){
			for(int m=0;m<lst.size();m++){
				nodeRalation[n][m]=-1;
			}
			if(startcode.equals(lst.get(n))){
				s=n;
			}
			if(endcode.equals(lst.get(n))){
				e=n;
			}
		}
		for(int i=0;i<lst.size();i++){
			//查找与当前设备相连的设备，通过复用段查
			String tempcode = lst.get(i);
			List<String> templst = this.getSqlMapClientTemplate().queryForList("getequipcodeBytoplink", tempcode);
			if(templst.size()==0){
				//不操作
			}else{
				for(int k=0;k<templst.size();k++){
					for(int t=0;t<lst.size();t++){
						if(templst.get(k).equals(lst.get(t))){
							nodeRalation[i][k]=t;
						}
					}
				}
			}
		}

		/* 定义节点数组 */  
       Node[] node = new Node[nodeRalation.length];  
          
        for(int i=0;i<nodeRalation.length;i++)  
        {  
            node[i] = new Node();  
            node[i].setName(lst.get(i));  
        }  
          
        /* 定义与节点相关联的节点集合 */  
        for(int i=0;i<nodeRalation.length;i++)  
        {  
            ArrayList<Node> List = new ArrayList<Node>();  
            for(int j=0;j<nodeRalation.length;j++)  
           {  
            	if(nodeRalation[i][j]>=0){
            		List.add(node[nodeRalation[i][j]]);  
            	}
                
            }  
            node[i].setRelationNodes(List);  
            List = null;  //释放内存  
        }  
        
//        Node nodeS = new Node();
//        nodeS.setName(startcode);
//        //设置关联关系
//        Node nodeE = new Node();
//        nodeE.setName(endcode);
		/* 开始搜索所有路径 */  
        GetSystemRelations.getPaths(node[s], null, node[s], node[e]);
        List<Object[]> list = GetSystemRelations.sers;
        Object[] arr = null ;
        if(list.size()==0){
        	//提示没有路径
        	arr = new Object[]{};
        }else{
        	int num = list.get(0).length;
        	if(list.size()==1){
        		arr=list.get(0);
        	}else{
        		for(int a=1;a<list.size();a++){
		        	if(num>list.get(a).length){
		        		num=list.get(a).length;
		        		arr = list.get(a);
		        	}
		        }
        	}
        }
		        
		return arr;
	}

	@Override
	public String getPortRateBycode(String portcode) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getPortRateBycode", portcode);
	}

}
