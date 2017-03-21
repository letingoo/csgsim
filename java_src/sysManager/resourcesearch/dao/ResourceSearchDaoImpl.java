package sysManager.resourcesearch.dao;

import java.util.List;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import sysManager.resourcesearch.model.Testmodel;

public class ResourceSearchDaoImpl implements ResourceSearchDao{
	private SqlMapClientTemplate sqlMapClientTemplate;

    public SqlMapClientTemplate getSqlMapClientTemplate() {   
    	
	   return sqlMapClientTemplate;
    }

    public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	   this.sqlMapClientTemplate = sqlMapClientTemplate;
    }
    
    public List getStationByKeycode(String keycode){
    	return this.sqlMapClientTemplate.queryForList("getStationByKeycode", keycode);
    }
    public List getEquipmentByKeycode(String keycode){
    	return this.sqlMapClientTemplate.queryForList("getEquipmentByKeycode", keycode);
    }
    public List getSectionByKeycode(String keycode){
    	return this.sqlMapClientTemplate.queryForList("getSectionByKeycode", keycode);
    }
	public List getCircuitBykeycode(String keycode){
		return this.sqlMapClientTemplate.queryForList("getCircuitBykeycode", keycode);
	}

	@Override
	public Testmodel sqltest(String keycode) {
		
		return (Testmodel)this.sqlMapClientTemplate.queryForObject("testsql", keycode);
	}
}
