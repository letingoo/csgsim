package sysManager.user.dao;

import java.util.HashMap;
import java.util.List;

import sysManager.function.model.Department;
import sysManager.user.model.OperateDepartModel;
import sysManager.user.model.UserModel;

public interface UserDao {
	public Object getUserInfos();
	public String insertUser(UserModel obj);
	public String delUser(String userid);
	public String updateUser(UserModel obj);
	public String checkUserId(String user_id);
	public Object queryUser(Object obj);
	public Object queryUser_Excel(Object obj);
	public Object queryUserRoles(Object obj);
	public Object queryUserRoleModels(String string);
	public Object queryUserNotRoleModels(String string);
	public void delUserRoleForms(Object obj);
	public void insertUserRoleForms(Object obj);
	public Object getUserInfoByRoleId(Object obj);
	public int getUserCounts(Object obj);
	public int getUserCountsByRoleId(String role_id);
	public Object expUserInfo(Object obj);
	public Object getPSWByUserId(String userid);
	public UserModel getUserInfoById(String user_id);
	public Object getSingleUserInfoById(String user_id);
	
	public List getOnlineUser();
	public Object getOnlineUserByUserId(HashMap map);
	public void delUserState(Object obj);
	public void insertUserState(Object obj);
	public void updateUserState(Object obj);
	
	public void delUserAllShortcut(Object obj);
	
	public void delUserOperateDepart(String user_id);
	public void insertOperateDepart(String user_id,String departCode);
	public List<OperateDepartModel> getConfigOperateDepartModels(String user_id);
	public List<OperateDepartModel> getNotConfigOperateDepartModels(String user_id);
	public String getServerIPByUser_IP(String user_ip);
	public List<Department> getFirstDept();
	public List<Department> getDeptByLevel(int level,String parentid,String user_id);
	public List<Department> getDeptByLevel(int level,String parentid);
	public void delAllUserState();
	public void updateCurDutyMan(String userid);
	public UserModel login(UserModel user);
}