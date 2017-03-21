package businessAnalysis.dao;

import java.util.HashMap;
import java.util.List;

import netres.model.ComboxDataModel;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

public class TestDaoImpl implements TestDao {
	
	private SqlMapClientTemplate sqlMapClientTemplate;

	public SqlMapClientTemplate getSqlMapClientTemplate() {
		return sqlMapClientTemplate;
	}

	public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
		this.sqlMapClientTemplate = sqlMapClientTemplate;
	}

	//打开 返回链路 
	@SuppressWarnings("unchecked")
	public List<HashMap<Object,Object>> openProEquipA(String tranSys) {
		List<HashMap<Object,Object>> result = this.sqlMapClientTemplate.queryForList("equipA_list",tranSys);
		return result;
	}
	//打开 返回链路 
	@SuppressWarnings("unchecked")
	public List<HashMap<Object,Object>> openProLinkA(String tranSys) {
		List<HashMap<Object,Object>> result = this.sqlMapClientTemplate.queryForList("linkA_list",tranSys);
		return result;
	}
	//打开 返回链路 
	@SuppressWarnings("unchecked")
	public List<HashMap<Object,Object>> openProBusinessA(String tranSys) {
		List<HashMap<Object,Object>> result = this.sqlMapClientTemplate.queryForList("businessA_list",tranSys);
		return result;
	}
	//打开 返回链路 
	@SuppressWarnings("unchecked")
	public List<HashMap<Object,Object>> openProCircuitRouteA(String  tranSys) {
		List<HashMap<Object,Object>> result = this.sqlMapClientTemplate.queryForList("circuitRouteA_list",tranSys);
		return result;
	}
	public String nxAnalysis(int num,String netType,String type, 
			List<HashMap<Object,Object>> equipA, List<HashMap<Object,Object>> equipB,
			List<HashMap<Object,Object>> linkA, List<HashMap<Object,Object>> linkB, 
			List<HashMap<Object,Object>> busA, List<HashMap<Object,Object>> busB,
			List<HashMap<Object,Object>> cirRouteA, List<HashMap<Object,Object>> cirRouteB){
		return RA.nxAnalysis(num, netType, type, equipA, equipB, 
				linkA, linkB, busA, busB, cirRouteA, cirRouteB);
	}
	public List<HashMap<Object,Object>> getAllLog(){
		return RA.getAllLog();
	}
	public List<HashMap<Object,Object>> getBusinessFail(List<String> temp){
		return RA.getBusinessFail(temp);
	}
	public List<HashMap<Object,Object>> getBusinessRe(List<String> temp){
		return RA.getBusinessRe(temp);
	}
	@SuppressWarnings("unchecked")
	public List<ComboxDataModel> getTranSystemLst() {
		return this.getSqlMapClientTemplate().queryForList("getTranSystemLst");
	}
	
	public String setSelected(HashMap<Object,Object> equipObj,HashMap<Object,Object> linkObj) {
		return RA.setSelected(equipObj, linkObj);
	}

	@Override
	public String getBusinessInfo(String business_name) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getBusinessInfo", business_name);
	}
}
