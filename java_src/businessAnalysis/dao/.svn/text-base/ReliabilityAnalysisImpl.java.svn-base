package businessAnalysis.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import businessAnalysis.model.BusinessCircuit;
import businessAnalysis.model.CircuitEquipment;
import businessAnalysis.model.CircuitTwoequip;

import netres.model.ComboxDataModel;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import resManager.resBusiness.model.Circuit;

public class ReliabilityAnalysisImpl implements
		ReliabilityAnalysisDao {
	
	private SqlMapClientTemplate sqlMapClientTemplate;

	public void setSqlMapClientTemplate(
			SqlMapClientTemplate sqlMapClientTemplate) {
		this.sqlMapClientTemplate = sqlMapClientTemplate;
	}

	public SqlMapClientTemplate getSqlMapClientTemplate() {
		return sqlMapClientTemplate;
	}
	
	public List<HashMap<Object,Object>> getAllBus(){
		List<HashMap<Object,Object>> result = 
			this.sqlMapClientTemplate.queryForList("getAllBus");
		return result;
	}
	
	public List<BusinessCircuit> getBCList(
			List<HashMap<Object,Object>> selectedBus){
		List<BusinessCircuit> bcList = new ArrayList<BusinessCircuit>();
		for(int i=0; i<selectedBus.size(); i++){
			String business_id = selectedBus.get(i).get("BUSINESS_ID").toString();
			String business_name = selectedBus.get(i).get("BUSINESS_NAME").toString();
			List<String> bcResult = 
				this.sqlMapClientTemplate.queryForList("getCircuitCodeInfo",business_id);
			for(int j=0; j<bcResult.size(); j++){
				if(bcResult.get(j).indexOf(",") != -1){
					String[] temp = bcResult.get(j).split(",");
					for(int k = 0; k<temp.length; k++){
						BusinessCircuit bc = new BusinessCircuit();
						bc.setBusinessId(business_id);
						bc.setBusinessName(business_name);
						bc.setCircuitcode(temp[k]);
						bcList.add(bc);
					}
				}else{
					BusinessCircuit bc = new BusinessCircuit();
					bc.setBusinessId(business_id);
					bc.setBusinessName(business_name);
					bc.setCircuitcode(bcResult.get(j));
					bcList.add(bc);
				}
			}
		}
		return bcList;
	}
	
	public List<CircuitEquipment> getCEList(List<BusinessCircuit> bcList){
		List<CircuitEquipment> ceList = new ArrayList<CircuitEquipment>();
		for(int i=0; i<bcList.size(); i++){
			String circuitcode = bcList.get(i).getCircuitcode();
			int temp = 0;
			for(int k=0; k<i;k++)
				if(bcList.get(k).getCircuitcode().equals(circuitcode))
					temp = 1;
			if(temp == 0){
				List<HashMap<Object,Object>> bcResult = 
					this.sqlMapClientTemplate.queryForList("getCircuitPathInfo",circuitcode);
				//每个circuit判断主路由的所有设备 然后remark contains判断
				
				if(bcResult.size()>0&&bcResult.get(0).get("PATH") != null){
					String pathStr = bcResult.get(0).get("PATH").toString();
					String[] path = pathStr.split("->");
					for(int j=0; j<path.length; j++){
						if(bcResult.get(0).get("REMARK") == null){
							CircuitEquipment ce = new CircuitEquipment();
							ce.setCircuitcode(circuitcode);
							ce.setEquipmentName(path[j]);
							ceList.add(ce);
						}else if(bcResult.get(0).get("REMARK").toString().indexOf(path[j]) != -1){
							CircuitEquipment ce = new CircuitEquipment();
							ce.setCircuitcode(circuitcode);
							ce.setEquipmentName(path[j]);
							ceList.add(ce);
						}
					}
					//link
					for(int j=0; j<path.length-1; j++){
						if(bcResult.get(0).get("REMARK") == null){
							CircuitEquipment ce = new CircuitEquipment();
							ce.setCircuitcode(circuitcode);
							ce.setEquipmentName(path[j] + " - " + path[j+1]);
							ceList.add(ce);
						}else if(bcResult.get(0).get("REMARK").toString().indexOf(path[j]+"->"+path[j+1]) != -1){
							CircuitEquipment ce = new CircuitEquipment();
							ce.setCircuitcode(circuitcode);
							ce.setEquipmentName(path[j] + " - " + path[j+1]);
							ceList.add(ce);
						}
					}
				}
			}
		}
		
		
		
		return ceList;
	}
	
	public List<CircuitTwoequip> getCeeList(List<BusinessCircuit> bcList){
		List<CircuitTwoequip> ceeList = new ArrayList<CircuitTwoequip>();
		for(int i=0; i<bcList.size(); i++){
			String circuitcode = bcList.get(i).getCircuitcode();
			int temp = 0;
			for(int k=0; k<i;k++)
				if(bcList.get(k).getCircuitcode().equals(circuitcode))
					temp = 1;
			if(temp == 0){
				List<HashMap<Object,Object>> bcResult = 
					this.sqlMapClientTemplate.queryForList("getCircuitPathInfo",circuitcode);
				//每个circuit判断主路由的所有设备 然后remark contains判断
				
				if(bcResult.size()>0&&bcResult.get(0).get("REMARK") != null){
					if(bcResult.get(0).get("PATH") != null){
						String pathStr = bcResult.get(0).get("PATH").toString();
						String[] path = pathStr.split("->");
						String remarkStr = bcResult.get(0).get("REMARK").toString();
						String[] remark = remarkStr.split("->");
						
						for(int j=0; j<path.length; j++){
							if(remarkStr.indexOf(path[j]) == -1){
								for(int m=0; m<remark.length; m++){
									//path:equip + remark:equip
									if(pathStr.indexOf(remark[m]) == -1){
										CircuitTwoequip cee = new CircuitTwoequip();
										cee.setCircuitcode(circuitcode);
										cee.setEquipment1(path[j]);
										cee.setEquipment2(remark[m]);
										ceeList.add(cee);
									}
									//path:equip + remark:link
									if(m<remark.length-1 && pathStr.indexOf(remark[m]+"->"+remark[m+1]) == -1){
										CircuitTwoequip cee = new CircuitTwoequip();
										cee.setCircuitcode(circuitcode);
										cee.setEquipment1(path[j]);
										cee.setEquipment2(remark[m] + " - " + remark[m+1]);
										ceeList.add(cee);
									}
								}
							}
						}
						for(int j=0; j<path.length-1; j++){
							if(remarkStr.indexOf(path[j]+"->"+path[j+1]) == -1){
								for(int m=0; m<remark.length; m++){
									//path:link + remark:equip
									if(pathStr.indexOf(remark[m]) == -1){
										CircuitTwoequip cee = new CircuitTwoequip();
										cee.setCircuitcode(circuitcode);
										cee.setEquipment1(path[j] + " - " + path[j+1]);
										cee.setEquipment2(remark[m]);
										ceeList.add(cee);
									}
									//path:link + remark:link
									if(m<remark.length-1 && pathStr.indexOf(remark[m]+"->"+remark[m+1]) == -1){
										CircuitTwoequip cee = new CircuitTwoequip();
										cee.setCircuitcode(circuitcode);
										cee.setEquipment1(path[j] + " - " + path[j+1]);
										cee.setEquipment2(remark[m] + " - " + remark[m+1]);
										ceeList.add(cee);
									}
								}
							}
						}
					}
				}
			}
		}
		
		
		
		return ceeList;
	}

	@Override
	public List<String> getAllBusinessIDByEquip(String equipId) {
		return this.getSqlMapClientTemplate().queryForList("getAllBusinessIDByEquip", equipId);
	}

	@Override
	public String getEquip_Circuit_CNT(Map map) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquip_Circuit_CNT", map);
	}

	@Override
	public List<HashMap<Object, Object>> getAllBusByEquipcode(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getAllBusByEquipcode", map);
	}

	@Override
	public List<String> getAllBusinessIDByEquipLst(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getAllBusinessIDByEquipLst", map);
	}

	@Override
	public List<String> getEquip_Circuit_CNTLst(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getEquip_Circuit_CNTLst", map);
	}

	@Override
	public List<String> getAllBusinessIDByEquipAndLinkLst(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getAllBusinessIDByEquipAndLinkLst", map);
	}

	@Override
	public List<String> getAllBusinessIDByEquipLstAndLink(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getAllBusinessIDByEquipLstAndLink", map);
	}

	@Override
	public List<String> getAllBusinessIDByEquipLstAndLinkLst(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getAllBusinessIDByEquipLstAndLinkLst", map);
	}

	@Override
	public String getEquipcodesByLinkID(String linkid) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquipcodesByLinkID", linkid);
	}

	@Override
	public String getbusinessfailandrecover(Map map) {
		this.getSqlMapClientTemplate().queryForObject("getbusinessfailandrecover", map);
		
		return map.get("res").toString()+";"+map.get("res1").toString();
	}

	@Override
	public String getbusinessfailandrecovernew(Map map) {
		this.getSqlMapClientTemplate().queryForObject("getbusinessfailandrecovernew", map);
		return map.get("res").toString()+";"+map.get("res1").toString();
	}

	@Override
	public String getbusinessfailandrecovertemp(Map map) {
		this.getSqlMapClientTemplate().queryForObject("getbusinessfailandrecovertemp", map);
		return map.get("res").toString()+";"+map.get("res1").toString();
	}

	@Override
	public String getcircuitccfailandrecover(Map map) {
		this.getSqlMapClientTemplate().queryForObject("getcircuitccfailandrecover", map);
		return map.get("res").toString()+";"+map.get("res1").toString();
	}

	@Override
	public String getfailandrecoverbyids(Map map) {
		this.getSqlMapClientTemplate().queryForObject("getfailandrecoverbyids", map);
		return map.get("failnum").toString()+";"+map.get("renum").toString();
	}

	@Override
	public List<Circuit> getBusinessInfo(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getBusinessRouteInfo", map);
	}

	@Override
	public List<String> getCircuitcodeByEquipCode(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getCircuitcodeByEquipCode", map);
	}

}
