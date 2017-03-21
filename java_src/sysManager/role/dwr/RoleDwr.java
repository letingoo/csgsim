package sysManager.role.dwr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import sysManager.role.dao.RoleDao;
import sysManager.role.model.RoleModel;

public class RoleDwr {
	
	RoleDao roleDao;
	
	public RoleDao getRoleDao() {
		return roleDao;
	}

	public void setRoleDao(RoleDao roleDao) {
		this.roleDao = roleDao;
	}
	
	public String getRoles(){
		List<RoleModel>roles = (ArrayList)roleDao.getRoles();		
		return this.getTreeNodes(roles, roleDao);
	}
	
	//组织树JSON
	private String getTreeNodes(List<RoleModel>roles,RoleDao roleDao){
		StringBuffer sb = new StringBuffer("<node text='角色树' icon=''>");
		try{
			for(int i = 0; i < roles.size();i++){
				RoleModel role = roles.get(i);
				List funcs = (ArrayList)roleDao.getFuncs(role.getRole_id());
				String funcStr = "";
				for(int j = 0; j < funcs.size(); j++){
					Map map = (Map)funcs.get(j);
					funcStr += map.get("PARENT_ID")+":"+map.get("OPER_NAME")+",";
				}
				if(funcStr == ""){
					funcStr = "该角色未配置功能！";
				}
				sb.append("<node " +
						"id='"+role.getRole_id()+"' " +
						"text='"+role.getRole_name()+"' " +
						"desc='"+role.getRole_desc()+"' " +
						"funcs='"+funcStr+"' " +
						"icon='assets/images/fam/user.gif'" +
						"leaf='true'/>");
			}
			sb.append("</node>");
		}catch(Exception e){
			e.printStackTrace();
		}
		return sb.toString();
	}
	
	public void insertRole(RoleModel roleModel){
		roleDao.insertRole(roleModel);
	}
	
	public void updateRole(RoleModel roleModel){
		roleDao.updateRole(roleModel);
	}
	
	public void deleteRole(String role_id){
		roleDao.delRole(role_id);
	}
	
	public void addRoleOper(String role_id,String operIds){
		String funcIds[] = operIds.split(",");
		roleDao.delRoleOper(Integer.parseInt(role_id));
		for(String funcId:funcIds){
			if(funcId != null || funcId != ""){
				Map map=new HashMap();
				map.put("role_id", role_id);
				map.put("oper_id", funcId);
				roleDao.insertRoleOper(map);
			}
		}
	}
}
