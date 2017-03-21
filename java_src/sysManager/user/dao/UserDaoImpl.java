package sysManager.user.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.HashMap;
import java.util.List;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import sysManager.function.model.Department;
import sysManager.user.model.OperateDepartModel;
import sysManager.user.model.UserModel;

import com.ibatis.sqlmap.client.SqlMapClient;

import db.ForTimeBaseDAO;

public class UserDaoImpl  extends SqlMapClientDaoSupport implements UserDao{
	
  
    
	public Object getUserInfos() {
		return this.getSqlMapClientTemplate().queryForList("getUserInfos",null);
	}

	public String delUser(String userid) {
		
		String success="ok";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
//			String sql = "";
//		    ForTimeBaseDAO dao = new ForTimeBaseDAO();
//		    Connection c = null;
//			Statement s = null;
//			ResultSet r = null;
//			CallableStatement cs = null;
//			
//			try {
//				c = dao.getConnection();
//				String callsql = "{call sdtmis.pro_synrestomis(?,?) } ";
//				callsql = callsql + sql;
//				cs = c.prepareCall(callsql);
//				cs.setString(1,userid);
//				cs.registerOutParameter(2, Types.VARCHAR);
//				cs.executeUpdate();
//				success = cs.getString(2);
//			} catch (Exception e) {
//				e.printStackTrace();
//			} finally {
//				dao.closeConnection(c, s, r);
//			}    
			
			sqlMap.startTransaction();	
			
//			HashMap map = new HashMap();
//			map.put("PUSERID", userid);

			sqlMap.delete("delUser",userid);	   
			sqlMap.commitTransaction();
			
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}

		
		
		
		return success;
		
	}

	public String insertUser(UserModel obj) {
		
		String success="ok";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
			sqlMap.startTransaction();	
			sqlMap.insert("insertUser",obj);
			sqlMap.commitTransaction();
//			HashMap map = new HashMap();
//			map.put("PUSERID", obj.getUser_id());
//			String sql = "";
//		    ForTimeBaseDAO dao = new ForTimeBaseDAO();
//		    Connection c = null;
//			Statement s = null;
//			ResultSet r = null;
//			CallableStatement cs = null;
//			
//			try {
//				c = dao.getConnection();
//				String callsql = "{call sdtmis.pro_synrestomis(?,?) } ";
//				callsql = callsql + sql;
//				cs = c.prepareCall(callsql);
//				cs.setString(1,obj.getUser_id());
//				cs.registerOutParameter(2, Types.VARCHAR);
//				cs.executeUpdate();
//				success = cs.getString(2);
//			} catch (Exception e) {
//				e.printStackTrace();
//			} finally {
//				dao.closeConnection(c, s, r);
//			}   
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}

		
		return success;
		
		
	}
	public String checkUserId(String user_id){
		return (String)this.getSqlMapClientTemplate().queryForObject("getUserId",user_id);
	}


	@SuppressWarnings("unchecked")
	public String updateUser(UserModel obj) {

		String success="ok";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
			
			
			sqlMap.update("updateUser", obj);		
		   

//			HashMap map = new HashMap();
//			map.put("PUSERID", obj.getUser_id());
//		    map.put("PSTATUS", "x");
//
//		    String sql = "";
//		    ForTimeBaseDAO dao = new ForTimeBaseDAO();
//		    Connection c = null;
//			Statement s = null;
//			ResultSet r = null;
//			CallableStatement cs = null;
//			
//			try {
//				c = dao.getConnection();
//				String callsql = "{call sdtmis.pro_synrestomis(?,?) } ";
//				callsql = callsql + sql;
//				cs = c.prepareCall(callsql);
//				cs.setString(1,obj.getUser_id());
//				cs.registerOutParameter(2, Types.VARCHAR);
//				cs.executeUpdate();
//				success = cs.getString(2);
//			} catch (Exception e) {
//				e.printStackTrace();
//			} finally {
//				dao.closeConnection(c, s, r);
//			}        
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		 return success;
	}

	public Object queryUser(Object obj) {
		return getSqlMapClientTemplate().queryForList("queryUser",obj);
	}
	
	public Object queryUser_Excel(Object obj) {
		return getSqlMapClientTemplate().queryForList("queryUser_Excel",obj);
	}

	public Object queryUserRoles(Object obj) {
		return getSqlMapClientTemplate().queryForList("queryUserRoles",obj);
	}


	public Object queryUserRoleModels(String string) {
		return getSqlMapClientTemplate().queryForList("queryUserRoleModel", string);
	}
	
	public Object queryUserNotRoleModels(String string) {
		return getSqlMapClientTemplate().queryForList("queryUserNotRoleModel", string);
	}
	
	public void delUserRoleForms(Object obj){
		getSqlMapClientTemplate().delete("delUserRoleForms", obj);
	}
	
	public void insertUserRoleForms(Object obj){
		getSqlMapClientTemplate().insert("insertUserRoleForms", obj);
	}

	public Object getUserInfoByRoleId(Object obj) {
		return getSqlMapClientTemplate().queryForList("getUserInfoByRoleId",obj);
	}

	public int getUserCounts(Object obj) {
		
		return (Integer)getSqlMapClientTemplate().queryForObject("getUserCounts",obj);
	}
	
	public int getUserCountsByRoleId(String role_id){
		return (Integer)getSqlMapClientTemplate().queryForObject("getUserCountsByRoleId",role_id);
	}

	public Object expUserInfo(Object obj) {
		return getSqlMapClientTemplate().queryForList("expUserInfo",obj);
	}
	
	public Object getPSWByUserId(String userid){
		return getSqlMapClientTemplate().queryForObject("getPSWByUserId",userid);
	}
	public UserModel getUserInfoById(String user_id) {
		return (UserModel)getSqlMapClientTemplate().queryForObject("getUserInfoById",user_id);
	}
	public Object getSingleUserInfoById(String user_id) {
		return getSqlMapClientTemplate().queryForObject("getSingleUserInfoById",user_id);
	}
	
	public List getOnlineUser(){
		//获取当前时间下的在线
		return getSqlMapClientTemplate().queryForList("getOnlineUser");
	}
	
	public Object getOnlineUserByUserId(HashMap map){
		return getSqlMapClientTemplate().queryForObject("getOnlineUserByUserId",map);
	}
	
	public void insertUserState(Object obj){
		getSqlMapClientTemplate().insert("insertUserState", obj);
	}
	
	public void updateUserState(Object obj){
	    this.getSqlMapClientTemplate().update("updateUserState",obj);	
	}
	
	public void delUserState(Object obj){
		getSqlMapClientTemplate().delete("delUserState",obj);
	}
	
	public void delUserAllShortcut(Object obj){
		this.getSqlMapClientTemplate().delete("deleteUserAllShortcut", obj);
	}
	
	public List<OperateDepartModel> getConfigOperateDepartModels(String user_id){
		List<OperateDepartModel> queryForList = this.getSqlMapClientTemplate().queryForList("getConfigOperateModel", user_id);
		return queryForList;
	}
	
	public List<OperateDepartModel> getNotConfigOperateDepartModels(String user_id){
		List<OperateDepartModel> queryForList = this.getSqlMapClientTemplate().queryForList("getNotConfigOperateModel", user_id);
		return queryForList;
	}
	
	public void delUserOperateDepart(String user_id){
		getSqlMapClientTemplate().delete("deleteUserIdOperateDepart", user_id);		
	}
	
	public void insertOperateDepart(String user_id,String departCode){
		HashMap map = new HashMap();
		map.put("user_id", user_id);
		map.put("depart", departCode);
		this.getSqlMapClientTemplate().insert("insertUserIdOperateDepart", map);
	}
	public String getServerIPByUser_IP(String user_ip)
	{
		return (String)this.getSqlMapClientTemplate().queryForObject("getServerIPByUser_IP", user_ip);
	}
	public List<Department> getFirstDept()
	{
		
		return this.getSqlMapClientTemplate().queryForList("getFirstDept");
	}
	public List<Department>getDeptByLevel(int level,String parentid,String user_id)
	{
		HashMap map = new HashMap();
		map.put("level", level);
		map.put("parentid", parentid);
		map.put("user_id", user_id);
		return this.getSqlMapClientTemplate().queryForList("getDeptByLevel", map);
	}
	public List<Department>getDeptByLevel(int level,String parentid)
	{
		HashMap map = new HashMap();
		map.put("level", level);
		map.put("parentid", parentid);		
		return this.getSqlMapClientTemplate().queryForList("getDeptByLevelWithoutUser", map);
	}
	public void delAllUserState(){
		this.getSqlMapClientTemplate().delete("delAllUserState");
	}
	public void updateCurDutyMan(String userid)
	{
		this.getSqlMapClientTemplate().update("updateCurDutyMan", userid);
	}
	public UserModel login(UserModel user)
	{
		return (UserModel)this.getSqlMapClientTemplate().queryForObject("selectLoginByUserName", user);
	}
}
