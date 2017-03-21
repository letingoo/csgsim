package sysManager.permissionControl.dwr;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import sysManager.permissionControl.model.PermissionControlModel;
import sysManager.user.model.UserModel;

import db.DbDAO;
import flex.messaging.FlexContext;



public class PermissionControlDwr {
	
	ApplicationContext ctx = WebApplicationContextUtils
	.getWebApplicationContext(FlexContext.getServletContext());
    private DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");
    
    public PermissionControlModel[] getPermissionByUserId(String modelName){
    	HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		String userId = null;
		String json="";
		PermissionControlModel[] permissionControlModels = {};
		try{
			if (session.getAttribute("userid") != null) {
				UserModel user = (UserModel) session
						.getAttribute((String) session.getAttribute("userid"));
				if (user != null) {
					userId = user.getUser_id();
				}
			}
			if(modelName!=null&&userId!=null){
				Map paraMap = new HashMap();
				paraMap.put("userId", userId);
				paraMap.put("modelName", modelName);
				List list = basedao.queryForList("getPermissionListByUserIdAndModelName", paraMap);
				if(list!=null&&list.size()>0){
					permissionControlModels = new PermissionControlModel[list.size()];
					for(int i=0;i<list.size();i++){
						Map resultMap = (HashMap)list.get(i);
						PermissionControlModel model = new PermissionControlModel();
						model.setOper_id(String.valueOf((BigDecimal)resultMap.get("OPER_ID")));
						model.setOper_name((String)resultMap.get("OPER_NAME"));
						permissionControlModels[i] = model;
					}
				}
				
			}else{
				return null;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
    	return permissionControlModels;
    }
    
    public String getPermissionControlByUserDepartAndConfigDepartAndResouseDept(String tablename,String property,String key,String value){
    	String success="false";
    	try{
    		String userId = null;
    		HttpServletRequest request = FlexContext.getHttpRequest();
    		HttpSession session = request.getSession();
    		if (session.getAttribute("userid") != null) {
				UserModel user = (UserModel) session
						.getAttribute((String) session.getAttribute("userid"));
				if (user != null) {
					userId = user.getUser_id();
				}
			}
    		if(userId!=null){
	    		Map paraMap = new HashMap();
	    		paraMap.put("tablename", tablename);
	    		paraMap.put("property", property);
	    		paraMap.put("key", key);
	    		paraMap.put("value", value);
	    		paraMap.put("userId", userId);
	    		List list = basedao.queryForList("getPermissionControlByUserDepartAndConfigDepartAndResouseDept", paraMap);
	    		if(list!=null&&list.size()>0){
	    			success = "true";
	    		}
    		}
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	
    	return success;
    }
}
