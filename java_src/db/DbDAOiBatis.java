
package db;


import java.util.List;
import java.util.Map;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

public class DbDAOiBatis extends SqlMapClientDaoSupport implements DbDAO {


     public Object queryForObject(String sqlKey,Object param){
        return this.getSqlMapClientTemplate().queryForObject(sqlKey,param);
    }

    public List queryForList(String sqlKey, Object param) {
        return this.getSqlMapClientTemplate().queryForList(sqlKey,param);
    }

    public Map queryForMap(String sqlKey, Object param, String keyProperty ) {
        return this.getSqlMapClientTemplate().queryForMap(sqlKey,param,keyProperty);
    }

    public Object insert(String sqlKey,Object param){
        return this.getSqlMapClientTemplate().insert(sqlKey,param);
    }

    public int update(String sqlKey, Object param) {
        return this.getSqlMapClientTemplate().update(sqlKey,param);
    }

    public int delete(String sqlKey, Object param) {
        return this.getSqlMapClientTemplate().delete(sqlKey,param);
    }

}