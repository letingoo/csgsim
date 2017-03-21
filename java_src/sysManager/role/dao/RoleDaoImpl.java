package sysManager.role.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import sysManager.role.dao.RoleDao;

@SuppressWarnings("unchecked")
public class RoleDaoImpl implements RoleDao{
	
	private SqlMapClientTemplate sqlMapClientTemplate;

    public SqlMapClientTemplate getSqlMapClientTemplate() {
	   return sqlMapClientTemplate;
    }

    public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	   this.sqlMapClientTemplate = sqlMapClientTemplate;
    }
    
	public Object getRoles() {
		return getSqlMapClientTemplate().queryForList("getRoles",null);
	}

	public List getFuncs(Object obj) {
		return getSqlMapClientTemplate().queryForList("getFuncs",obj);
	}

	public void delRoleOper(Integer roleid) {
		 getSqlMapClientTemplate().delete("delRoleOper", roleid);
	}

	public void insertRoleOper(Object obj) {
		getSqlMapClientTemplate().insert("insertRoleOper",obj);
	}

	public void delRole(String role_id) {
		getSqlMapClientTemplate().delete("delRole", role_id);
	}

	public void insertRole(Object obj) {
		getSqlMapClientTemplate().insert("insertRole",obj);
	}

	public void updateRole(Object obj) {
		getSqlMapClientTemplate().update("updateRole", obj);
	}

}
