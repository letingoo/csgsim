package logintest.dao;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import login.model.ShortCut;
import login.model.StartMenu;
import login.model.VersionModel;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import sysManager.user.model.UserModel;

public class LoginDAOImpl implements LoginDAO {
	private SqlMapClientTemplate sqlMapClientTemplate;

    public SqlMapClientTemplate getSqlMapClientTemplate() {
	   return sqlMapClientTemplate;
    }

    public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	   this.sqlMapClientTemplate = sqlMapClientTemplate;
    }
 
	public UserModel login(UserModel user)
	{
		return (UserModel)this.getSqlMapClientTemplate().queryForObject("selectLogintest", user);
	}
	



}
