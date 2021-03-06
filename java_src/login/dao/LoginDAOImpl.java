package login.dao;


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
 
	@SuppressWarnings("unchecked")
	public ArrayList<ShortCut> GetShortCutByUserName(String userName)
	{
		return  (ArrayList<ShortCut>) this.getSqlMapClientTemplate().queryForList("getShortCutByUserName", userName);
	}
	public List<StartMenu> getRootStartMenu()
	{
		return this.getSqlMapClientTemplate().queryForList("getRootStartMenu");
	}
	public List<StartMenu> getChildMenuByParentID(int parentID)
	{
		return this.getSqlMapClientTemplate().queryForList("getChildMenuByParentID", parentID);
		
	}
	public List<Integer> getOperByUser(String userName)
	{
		return this.getSqlMapClientTemplate().queryForList("getOperByUser", userName);
	}
	public UserModel login(UserModel user)
	{
		return (UserModel)this.getSqlMapClientTemplate().queryForObject("selectLogin", user);
	}
	
	public void insertUserShortcut(Object obj){
		this.getSqlMapClientTemplate().insert("insertUserShortcut",obj);
	}
	
	public void delUserShortcut(Object obj){
		this.getSqlMapClientTemplate().delete("deleteUserShortcut", obj);
	}
	
	public void delShortcut(String name){
		this.getSqlMapClientTemplate().delete("deleteShortcut", name);
	}
	
	public UserModel isSystemManager(String userName){
		return (UserModel)this.getSqlMapClientTemplate().queryForObject("isSystemManager",userName);
	}

	@Override
	public List<VersionModel> getVersionByIdName(String vid, String vname,String username) {
		// TODO Auto-generated method stub
		Map map=new HashMap();
		map.put("vid", vid);
		map.put("vname",vname);
		map.put("username",username);
		return this.getSqlMapClientTemplate().queryForList("getVersionByIdName", map);
	}

	@Override
	public int delVersion(String vid) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().update("delVersion", vid);
	}

	@Override
	public List<VersionModel> getVersion(VersionModel version) {
		// TODO Auto-generated method stub
		Map map=new HashMap();
		map.put("vid", version.getVid());
		map.put("vname",version.getVname());
		map.put("vdesc",version.getVdesc());
		map.put("fill_man",version.getFill_man());
		map.put("fill_time",version.getFill_time());
		return this.getSqlMapClientTemplate().queryForList("getVersionByIdName", map);
	}

	@Override
	public Integer getVersionCount(VersionModel version) {
		// TODO Auto-generated method stub
		Map map=new HashMap();
		map.put("vid", version.getVid());
		map.put("vname",version.getVname());
		map.put("vdesc",version.getVdesc());
		map.put("fill_man",version.getFill_man());
		map.put("fill_time",version.getFill_time());
		List vLst=this.getSqlMapClientTemplate().queryForList("getVersionByIdName", map);
		return (vLst==null?0:vLst.size());
	}

	@Override
	public List<VersionModel> getVersionXtbm(Map map) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList("getVersionXtbm", map);
	}

	@Override
	public void updateLoginVersionByUser(UserModel user) {
		// TODO Auto-generated method stub
		this.getSqlMapClientTemplate().update("updateLoginVersionByUser", user);
	}

	@Override
	public String getCurrVersionByUser(String userid) {
		// TODO Auto-generated method stub
		return (String)this.getSqlMapClientTemplate().queryForObject("getCurrVersionByUser", userid);
	}

	@Override
	public Object getVXtbms(Object obj) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("getVXtbms",obj);
	}

	@Override
	public void insertVXtbm(VersionModel vmodel) {
		// TODO Auto-generated method stub
		this.getSqlMapClientTemplate().insert("insertVXtbm",vmodel);
	}

	@Override
	public void updateVXtbmByOperId(VersionModel vmodel) {
		// TODO Auto-generated method stub
		this.getSqlMapClientTemplate().update("updateVXtbmByOperId", vmodel);
	}

	@Override
	public int delVersionXtbm(String oper_id) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().delete("delVersionXtbm", oper_id);
	}

	@Override
	public List<VersionModel> getVersionModelList(VersionModel model) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList("getVersionModelList", model);
	}

	@Override
	public int getVersionCountRestrict(VersionModel version) {
		Map map=new HashMap();
		map.put("vid", version.getVid());
		map.put("vname",version.getVname());
		map.put("vdesc",version.getVdesc());
		map.put("fill_man",version.getFill_man());
		map.put("fill_time",version.getFill_time());
		List vLst=this.getSqlMapClientTemplate().queryForList("getVersionByIdNameRestrict", map);
		return (vLst==null?0:vLst.size());
	}

	@Override
	public List getVersionRestrict(VersionModel version) {
		Map map=new HashMap();
		map.put("vid", version.getVid());
		map.put("vname",version.getVname());
		map.put("vdesc",version.getVdesc());
		map.put("fill_man",version.getFill_man());
		map.put("fill_time",version.getFill_time());
		return this.getSqlMapClientTemplate().queryForList("getVersionByIdNameRestrict", map);
	}

	@Override
	public String getVersionUserByID(String user) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getVersionUserByID", user);
	}

	@Override
	public List<StartMenu> getRootStartMenu_rep() {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList("getRootStartMenu_rep");
	}

	@Override
	public List<Integer> getOperByUser_rep(String userName) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList("getOperByUser_rep", userName);
	}

	@Override
	public List<StartMenu> getChildMenuByParentID_rep(int parentID) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList("getChildMenuByParentID_rep", parentID);
	}



}
