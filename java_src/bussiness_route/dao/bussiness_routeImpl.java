package bussiness_route.dao;

import java.util.List;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import bussiness_route.model.*;

public class bussiness_routeImpl   implements  bussiness_routeDao{
	private SqlMapClientTemplate sqlMapClientTemplate;

    public SqlMapClientTemplate getSqlMapClientTemplate() {
	   return sqlMapClientTemplate;
    }

    public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	   this.sqlMapClientTemplate = sqlMapClientTemplate;
    }
    
	
	public List<equip_model> getEquip(){
		return this.getSqlMapClientTemplate().queryForList("getEquip_Han");
	};
	
	public List<topolink_model> getTopolink(){
		return this.getSqlMapClientTemplate().queryForList("getTopolink_Han");
	};
	
	public List<bussiness_route_model> getBussineseRoute(){
		return this.getSqlMapClientTemplate().queryForList("getBussinessRoute_Han");
	};
	
	

}
