package tuopu.dao;

import java.lang.SuppressWarnings;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import login.model.VersionModel;




import org.springframework.orm.ibatis.SqlMapClientTemplate;

import channelroute.dwr.ChannelRouteAction;
public class tuopuDAOImpl implements tuopuDAO {
	private SqlMapClientTemplate sqlMapClientTemplate;
	
    public SqlMapClientTemplate getSqlMapClientTemplate() {
	   return sqlMapClientTemplate;
    }

    public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	   this.sqlMapClientTemplate = sqlMapClientTemplate;
    }
    public List<String>getEqName(String sysname)
    {
    	  return this.getSqlMapClientTemplate().queryForList("getEqName",sysname);
    }
    public List<HashMap<Object,Object>>getNbmc(Object obj){
    	 
       return this.getSqlMapClientTemplate().queryForList("getNbmc",obj);
       }
    public List<HashMap<Object,Object>> getRep(Object obj){
   	 
       	return this.getSqlMapClientTemplate().queryForList("getRep",obj);
       }

    public List<HashMap<Object,Object>>getOp(){
      	 
       	return this.getSqlMapClientTemplate().queryForList("getOp");
       }
    public List<String>getID(String name){
     	 
       	return this.getSqlMapClientTemplate().queryForList("getID",name);
       }
	}
	

