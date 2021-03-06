package login.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import login.model.ShortCut;
import login.model.StartMenu;
import login.model.VersionModel;
import sysManager.user.model.UserModel;

public interface LoginDAO {
	public ArrayList<ShortCut> GetShortCutByUserName(String userName);
    
	public List<StartMenu> getRootStartMenu();
	public List<StartMenu> getChildMenuByParentID(int parentID);
    public List<Integer> getOperByUser(String userName);
    public UserModel login(UserModel user);
    public void insertUserShortcut(Object obj);
    public void delUserShortcut(Object obj);
    public UserModel isSystemManager(String userName);
    public void delShortcut(String name);
    public List<VersionModel> getVersionByIdName(String vid,String vname,String username);
    public Integer getVersionCount(VersionModel fiber);
	public List<VersionModel> getVersion(VersionModel fiber);
	public int delVersion(String fibercode);
	public List<VersionModel> getVersionXtbm(Map map);
	public void updateLoginVersionByUser(UserModel user);
	public String getCurrVersionByUser(String userid);
	public Object getVXtbms(Object obj);
	public void updateVXtbmByOperId(VersionModel vmodel);
	public void insertVXtbm(VersionModel vmodel);
	public int delVersionXtbm(String oper_id);

	public List<VersionModel> getVersionModelList(VersionModel model);

	public int getVersionCountRestrict(VersionModel vmodel);

	public List getVersionRestrict(VersionModel vmodel);

	public String getVersionUserByID(String user);

	public List<StartMenu> getRootStartMenu_rep();

	public List<Integer> getOperByUser_rep(String userName);

	public List<StartMenu> getChildMenuByParentID_rep(int oper_id);

}
