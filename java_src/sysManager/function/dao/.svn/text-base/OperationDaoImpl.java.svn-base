package sysManager.function.dao;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import sysManager.function.model.*;

public class OperationDaoImpl implements OperationDao{

	private SqlMapClientTemplate sqlMapClientTemplate;

    public SqlMapClientTemplate getSqlMapClientTemplate() {
	   return sqlMapClientTemplate;
    }

    public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	   this.sqlMapClientTemplate = sqlMapClientTemplate;
    }
    
	public Object getOperations(Object obj) {
		return getSqlMapClientTemplate().queryForList("getOperations",obj);
	}
	public void insertOper(Object obj) {
		 getSqlMapClientTemplate().insert("insertOper",obj);
	}
	public void delOper(String oper_id) {
		getSqlMapClientTemplate().delete("delOper",oper_id);
	}
	public void updateChilden(Object obj) {
		getSqlMapClientTemplate().update("updateChilden", obj);
	}
	public void updateOperationByOperId(OperationModel operation) {
		getSqlMapClientTemplate().update("updateOperationByOperId", operation);
	}

}
