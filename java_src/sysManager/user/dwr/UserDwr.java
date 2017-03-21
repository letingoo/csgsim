package sysManager.user.dwr;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import login.model.OnlineSession;
import login.model.SessionListener;
import md5.MD5;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import cn.swjtu.multisource.tools.ConstArgs;

import com.Message;

import sysManager.function.model.Department;
import sysManager.log.dao.LogDao;
import sysManager.role.model.RoleModel;
import sysManager.user.dao.UserDao;
import sysManager.user.model.OperateDepartModel;
import sysManager.user.model.UserModel;
import sysManager.user.model.UserResultModel;
import sysManager.user.model.UserStateModel;
import exportexcel.OperationExcel;
import flex.messaging.FlexContext;

public class UserDwr{
	
	private static final Log log = LogFactory.getLog(UserDwr.class);
	
	UserDao userDao;
	
	public UserDao getUserDao() {
		return userDao;
	}

	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}
	

	// 获取用户信息
	@SuppressWarnings("unchecked")
	public List getUserInfos() {
		List<UserModel> users = (ArrayList) userDao.getUserInfos();
		return users;
	}
	
	public List getUserInfos(UserModel userModel) {
		List<UserModel> users = (ArrayList) userDao.queryUser(userModel);
		return users;
	}
	
	// getStation return Stations Object as type of ResultModel取数据并分页。
	public UserResultModel getUsers(UserModel userModel) {
		UserResultModel result = new UserResultModel();
		
		try {
			HttpServletRequest request = FlexContext.getHttpRequest();
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "用户管理", "查询用户信息", "", request);
			result.setTotalCount(userDao.getUserCounts(userModel));
			result.setUserList((ArrayList) userDao.queryUser(userModel));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	//添加用户
	public String addUser(UserModel userModel) {
		if(null==userDao.checkUserId(userModel.getUser_id())||userDao.checkUserId(userModel.getUser_id())==" ") {
			try {
				//添加系统日志
				HttpServletRequest request = FlexContext.getHttpRequest();
				WebApplicationContext ctx = WebApplicationContextUtils
						.getWebApplicationContext(FlexContext
								.getServletContext());
				LogDao logDao = (LogDao) ctx.getBean("logDao");
				logDao.createLogEvent("添加", "用户管理", "添加用户信息", "添加用户："
						+ userModel.getUser_id(), request);
				Date now = new Date();
				DateFormat d = DateFormat.getDateTimeInstance();
				userModel.setCreatetime(d.format(now));
				//密码加密
//				MD5 md5 = new MD5();
//				userModel.setUser_pwd(md5.getMD5ofStr(userModel.getUser_pwd()));
				System.out.println(userModel.getUser_pwd()+"!!!!!!!!!!!!!!!");
				userDao.insertUser(userModel);
				//默认给新用户赋予"普通用户"角色。
				logDao.createLogEvent("添加", "用户管理", "添加用户拥有角色", "用户："
						+ userModel.getUser_id(), request);
				this.addUserRoles(userModel.getUser_id(), "223");
			} catch (Exception e) {
				e.printStackTrace();
			}
			return "addsuccess";
		} else {
			return "addfailed";
		}

	}
	// 修改用户信息
	public String editUser(UserModel user_model) {
		//添加系统日志。
		HttpServletRequest request = FlexContext.getHttpRequest();			
		WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao)ctx.getBean("logDao");
		logDao.createLogEvent("修改", "用户管理", "修改用户信息", "修改用户："+user_model.getUser_id()+"的信息", request);
		
		
		String  editresult="";
		//密码加密
//		MD5 md5 = new MD5();
//		user_model.setUser_pwd(md5.getMD5ofStr(user_model.getUser_pwd()));		
		editresult=userDao.updateUser(user_model);
		if("ok".equalsIgnoreCase(editresult)){
		    return "editsuccess";
		}else{
			return "editfailed";
		}
		
	}

	// 删除用户
	public String del_User(UserModel user_model) {
		//添加系统日志。
		HttpServletRequest request = FlexContext.getHttpRequest();			
		WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao)ctx.getBean("logDao");
		logDao.createLogEvent("删除", "用户管理", "删除用户", "删除用户："+user_model.getUser_id(), request);
		
		String delResult="";
		delResult=userDao.delUser(user_model.getUser_id());
		logDao.createLogEvent("删除", "用户管理", "删除用户拥有的角色", "用户："+user_model.getUser_id(), request);
		this.delUserRoleForms(user_model.getUser_id());
		this.delUserAllShortcut(user_model.getUser_id());
		//userDao.delUserOperateDepart(user_model.getUser_id());
		if("ok".equalsIgnoreCase(delResult)){
			return "delsuccess";
		}else{
			return "delfailed";
		}

	}
	
	public void delUserAllShortcut(String user_id){
		HashMap map = new HashMap();
		map.put("user_id", user_id);
		userDao.delUserAllShortcut(map);
	}
	
	public UserResultModel getUserInfoByRoleIdAndPageSize(String role_id,String start,String end){
		UserResultModel result = new UserResultModel();
		UserModel user = new UserModel();
		Map map =new HashMap();
		map.put("role_id", role_id);
		map.put("start", start);
		map.put("end", end);
		List<UserModel> users = (ArrayList)userDao.getUserInfoByRoleId(map);
		result.setUserList(users);
		result.setTotalCount(userDao.getUserCountsByRoleId(role_id));
		return result; 
	}
	public UserModel getUserInfoByUserId(String userid) {
		UserModel user = new UserModel();
		try
		{
			user = (UserModel) userDao.getUserInfoById(userid);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		
//		System.out.println(user.getUser_id());
		return user;
	}
	public int get_UserCounts(UserModel userModel) {
		int size = userDao.getUserCounts(userModel);
		return size;
	}

	
	//查询已有的角色

	public List getUserRoleForLimit(String user_id) {
		List<RoleModel> roles = (ArrayList) userDao
				.queryUserRoleModels(user_id);
		return roles;
	}
	//查询未有的角色
	public List getUserNotRole(String user_id) {
		List<RoleModel> roles = (ArrayList) userDao
				.queryUserNotRoleModels(user_id);
		return roles;
	}
	
	public void delUserRoleForms(String user_id){
		userDao.delUserRoleForms(user_id);
	}
	
	public void addUserRoles(String user_id,String role_id){
		if(role_id != "")
		{
			String[] roles=role_id.split(",");
			for(int i=0;i<roles.length;i++ ){
				String roleId = roles[i];
				Map map =new HashMap();
				map.put("user_id", user_id);
				map.put("role_id", role_id);
				userDao.insertUserRoleForms(map);
			}
		}
	}
	public void changeUserRoles(String user_id, List<RoleModel> roleModels) {
		// 保存用户角色，思想是：先把用户角色清空，
		// 后根据已分配角色表的role_id重新插入用户角色，从而达到用户角色的更新
		if (user_id != null && user_id != "") {
			delUserRoleForms(user_id);
			for (RoleModel roleModel : roleModels) {
				if (null != roleModel.getRole_id()) {
					HttpServletRequest request = FlexContext.getHttpRequest();			
					WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
					LogDao logDao = (LogDao)ctx.getBean("logDao");
					logDao.createLogEvent("添加", "用户管理", "删添用户拥有角色", "用户："+user_id, request);
					addUserRoles(user_id, roleModel.getRole_id().toString());
				}
			}
		} else {
			System.out.println("出错了！");
		}
	}
	public String getroles(String user_id){
		List<String> rs=(List)userDao.queryUserRoles(user_id);
		String roles = "";
		if(rs.size() != 0){
			for(String role:rs){
				roles += role+",";
			}
			roles=roles.substring(0, roles.length()-1);
		}else{
			roles="该用户暂未配置角色!";
		}
		return roles;
	}
	
	private String getNodes(List<UserModel> users,UserDao userDao,int size){
		StringBuffer nodes=new StringBuffer();
		nodes.append("{totalCount:"+size+",root:[");
		for(UserModel user:users){
			nodes.append("{");
			nodes.append("user_id:'"+user.getUser_id()+"',");
			nodes.append("user_name:'"+user.getUser_name()+"',");
			nodes.append("user_pwd:'"+user.getUser_pwd()+"',");
			nodes.append("user_sex:'"+user.getUser_sex()+"',");
			if(user.getUser_dept()!=null){
				nodes.append("user_dept:'"+user.getUser_dept()+"',");
			}else{
				nodes.append("user_dept:'"+""+"',");
			}
			if(user.getUser_post()!=null){
				nodes.append("user_post:'"+user.getUser_post()+"',");
			}else{
				nodes.append("user_post:'"+""+"',");
			}
			nodes.append("birthday:'"+user.getBirthday()+"',");
			if(user.getEducation()!=null){
				nodes.append("education:'"+user.getEducation()+"',");
			}else{
				nodes.append("education:'"+""+"',");
			}
			if(user.getTelephone()!=null){
				nodes.append("telephone:'"+user.getTelephone()+"',");
			}else{
				nodes.append("telephone:'"+""+"',");
			}
			if(user.getMobile()!=null){
				nodes.append("mobile:'"+user.getMobile()+"',");
			}else{
				nodes.append("mobile:'"+""+"',");
			}
			if(user.getEmail()!=null){
				nodes.append("email:'"+user.getEmail()+"',");
			}else{
				nodes.append("email:'"+""+"',");
			}
			if(user.getAddress()!=null){
				nodes.append("address:'"+user.getAddress()+"',");
			}else{
				nodes.append("address:'"+""+"',");
			}
			if(user.getRemark()!=null){
				nodes.append("remark:'"+user.getRemark()+"',");
			}else{
				nodes.append("remark:'"+""+"',");
			}
			List<String> roles = (ArrayList) userDao.queryUserRoles(user
					.getUser_id());
			if (roles.size() != 0) {
				StringBuffer sb = new StringBuffer();
				sb.append("roles:'");
				for(String role:roles){
					sb.append(role+",");
				}
				sb.append("'");
				nodes.append(sb.toString());
			}else{
				nodes.append("roles:'该用户暂未配置角色!'");
			}
			nodes.append("},");
		}
		nodes.append("]}");
		int length = nodes.length();
		String strTemp = "";
		if (length == 22)
			strTemp = nodes.toString();
		else
			strTemp = nodes.toString().substring(0, length - 3).concat("]}");
		return strTemp;
	}
	public String UserExportEXCEL(String labels, String[] titles,UserModel userModel) {
		Date d = new Date();
		String path = null;// 返回到前台的路径
		List content = null;
		HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
		String RealPath = null;// 绝对路径
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String date = sDateFormat.format(new java.util.Date());
		String filename = date + ".xls";// 定义文件名
		int userCount = get_UserCounts(userModel); // = userDao.getUserCounts();
		List<UserModel> userInfos = (ArrayList) userDao.queryUser_Excel(userModel);
		content = new ArrayList();
		for (int i = 0; i < userCount; i++) {
			List newcolmn = new ArrayList();
			newcolmn.add(userInfos.get(i).getUser_id());
			newcolmn.add(userInfos.get(i).getUser_name());
			newcolmn.add(userInfos.get(i).getUser_sex());
			newcolmn.add(userInfos.get(i).getUser_dept());
			newcolmn.add(userInfos.get(i).getUser_post());
			newcolmn.add(userInfos.get(i).getBirthday());
			newcolmn.add(userInfos.get(i).getEducation());
			newcolmn.add(userInfos.get(i).getTelephone());
			newcolmn.add(userInfos.get(i).getMobile());
			newcolmn.add(userInfos.get(i).getEmail());
			newcolmn.add(userInfos.get(i).getAddress());
			newcolmn.add(userInfos.get(i).getRemark());
			content.add(newcolmn);
		}
		try {
			String fullPath = this.getClass().getResource("").getPath()
					.toString();// 文件所在的路径
			RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));
			RealPath += "exportExcel/";
			File f = new File(RealPath);
			if (!f.exists()) {
				f.mkdir();
			}
			new OperationExcel().WriteExcel(RealPath + filename, labels,
					titles, content);
		} catch (Exception e) {
			e.printStackTrace();
		}
		path = "exportExcel/"+filename;
		return path;
	}

	public void getUserState(String user_id){
		
	}
	
	public List getOnlineUser(){
		List users = userDao.getOnlineUser();
		return users;
//		List<OnlineSession> users = SessionListener.getSessions();  
//		return users;
	}
	
	public UserModel getOnlineUserByUserId(){
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		if(session.getAttribute("userid") == null)
			return null;
		UserModel user = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
		if(user != null)
		{
			return user;
		}
			
		else 
			return null;
	}
	
	
	public UserModel getUserInfoByUserName(String userName){
		
		UserModel user = new UserModel();
		user.setUser_name(userName);
		UserModel resultuser = userDao.login(user);
		if(resultuser != null){
			HttpServletRequest request = FlexContext.getHttpRequest();
			HttpSession session = request.getSession();
			boolean b=false;
			if(resultuser.getZby().equalsIgnoreCase(resultuser.getUser_name())){
				b=true;
			}
			resultuser.setEnable(b);
			session.setAttribute(resultuser.getUser_id(), resultuser);
			session.setAttribute(resultuser.getUser_name(), resultuser);
			session.setAttribute("userid", resultuser.getUser_id());
			session.setAttribute("usename", resultuser.getUser_name());
			session.setAttribute("userip", request.getRemoteAddr());
			session.setAttribute("enable", b);
			if(session.getAttribute("userid") == null)
				return null;
			UserModel user1 = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
			if(user1 != null)
			{
				return user1;
			}
			else 
				return null;
		}
		else{
			return null;
		}
	}
	
	public void userLayout(String user_id,String user_state){
		HttpServletRequest request = FlexContext.getHttpRequest();
		Map map =new HashMap();
		map.put("user_id", user_id);
		map.put("user_state", user_state);
		map.put("user_ip", request.getRemoteAddr());
		userDao.delUserState(map);
		
		HttpSession session = request.getSession();
		if(session.getAttribute("userid") != null)
			session.removeAttribute("userid");
		Message.pushMessage("off_line:"+user_id+":"+request.getRemoteAddr());
		session.setAttribute(ConstArgs.KEY_DATABASE,ConstArgs.DEFAULT_DATABASE);//设置登录版本 实为数据库连接用户
	}
	/**
	 * 根据用户ID获取此用户已配置的操作单位。
	 * @author Haifeng Liu
	 * 2010-11-10下午02:26:13
	 * @param userid
	 * @return
	 */
	public List<OperateDepartModel> getConfigOperation(String userid){
		if(userid!=""&&userid!=null){
			List<OperateDepartModel> setOPerateDepartList = (ArrayList)userDao.getConfigOperateDepartModels(userid);
			return setOPerateDepartList;
		}else{
			return null;
		}
	}
	
	/**
	 * 根据用户ID获取此用户未配置的操作单位。
	 * @author Haifeng Liu
	 * 2010-11-10下午02:24:48
	 * @param userid
	 * @return
	 */
	public List<OperateDepartModel> getNotConfigOperation(String userid){
		if(userid!=""&&userid!=null){
			List<OperateDepartModel> notSetOPerateDepartList = userDao.getNotConfigOperateDepartModels(userid);
			return notSetOPerateDepartList;
		}else{
			return null;
		}
	}
	/**
	 * 修改用户配置的操作单位。逻辑先删除，再插入。
	 * @author Haifeng Liu
	 * 2010-11-10下午02:22:14
	 * @param user_id 用户ID
	 * @param departs 操作单位
	 * @return
	 */
	public String departChanged(String user_id,List<OperateDepartModel> departs){
		String setResult="";
		if (user_id != null && user_id != "") {
			userDao.delUserOperateDepart(user_id);
			for(OperateDepartModel dept:departs){
				if(null!=dept.getDepartCode()){
					userDao.insertOperateDepart(user_id,dept.getDepartCode());
				}
			}
			setResult="setSuccess";
			return setResult;
		}
		return null;		
	}
	/**
	 * 根据用户的user_id获取用户配置的单位信息。
	 * @author Haifeng Liu
	 * 2010-11-10下午02:19:35
	 * @param user_id 传入参数
	 * @return
	 */
	public String getDepartIfos(String user_id){
		String str = "[";
		try
		{
			List<OperateDepartModel> departList =getConfigOperation(user_id);
			if(departList.size()!=0){
				for(OperateDepartModel depModel:departList){
					
					
					str+="{\"departcode\":\""+depModel.getDepartCode()+"\",\"departname\":\""+depModel.getDepartName()+"\"},";
					
				}
				str=str.substring(0, str.length()-1);
			}
			str+="]";
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		return str;
		
	}
	public String getDept(int level,String parentid,String user_id)//初始level=0,parentid="";
	{
		
		String xml="";	
		String subxml="";
		List<Department> list=null;
		List<Department> childlist=null;
		try
		{
			list=getDeptListByLevel(level, parentid,user_id);
			if(list==null||list.size()==0)
			{
				return xml;
			}
			for(int i=0;i<list.size();i++)
			{
				String dept_code=list.get(i).getDept_code();
				
				subxml=getDept(level+1,dept_code,user_id);
				if(subxml.equalsIgnoreCase(""))
				{
					if(list.get(i).getChecked()==0)
					{
						xml+="<item code=\"" + list.get(i).getDept_code()
						+ "\" name=\"" + list.get(i).getDept_name()
						+ "\" isBranch=\"false\" leaf=\"true\" checked=\"0\"></item>";
					}
					else
					{
						xml+="<item code=\"" + list.get(i).getDept_code()
						+ "\" name=\"" + list.get(i).getDept_name()
						+ "\" isBranch=\"false\" leaf=\"true\" checked=\"1\"></item>";
					}
					
				}
				else
				{
					xml+="<item code=\"" + list.get(i).getDept_code()
					+ "\" name=\"" + list.get(i).getDept_name()
					+ "\" isBranch=\"true\" leaf=\"false\">"+subxml+"</item>";
				}
				
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		
		
		return xml;
	}
		public String getDept(int level,String parentid)//初始level=0,parentid="";
	{
		
		String xml="";	
		String subxml="";
		List<Department> list=null;
		List<Department> childlist=null;
		try
		{
			list=getDeptListByLevel(level, parentid);
			if(list==null||list.size()==0)
			{
				return xml;
			}
			for(int i=0;i<list.size();i++)
			{
				String dept_code=list.get(i).getDept_code();
				
				subxml=getDept(level+1,dept_code);
				if(subxml.equalsIgnoreCase(""))
				{
					xml+="<item code=\"" + list.get(i).getDept_code()
					+ "\" name=\"" + list.get(i).getDept_name()
					+ "\" isBranch=\"false\" leaf=\"true\" checked=\"0\"></item>";
				}
				else
				{
					xml+="<item code=\"" + list.get(i).getDept_code()
					+ "\" name=\"" + list.get(i).getDept_name()
					+ "\" isBranch=\"true\" leaf=\"false\">"+subxml+"</item>";
				}
				
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		
		
		return xml;
	}
		
	
	public String getDeptTemp(int level,String parentid,String user_id)//初始level=0,parentid="";
	{
		String xml="";
		String subxml="";
		List<Department> list=null;
		List<Department> childlist=null;
		try
		{
			list=getDeptListByLevel(level, parentid,user_id);
			if(list==null||list.size()==0)
			{
				return xml;
			}
			for(int i=0;i<list.size();i++)
			{
				String dept_code=list.get(i).getDept_code();
				subxml=getDeptTemp(level+1,dept_code,user_id);
				if(subxml.equalsIgnoreCase(""))
				{
					xml+="<item code=\"" + list.get(i).getDept_code()
					+ "\" name=\"" + list.get(i).getDept_name()
					+ "\" isBranch=\"false\" leaf=\"true\" checked=\"0\"></item>";
				}
				else
				{
					xml+="<item code=\"" + list.get(i).getDept_code()
					+ "\" name=\"" + list.get(i).getDept_name()
					+ "\" isBranch=\"true\" leaf=\"false\">"+subxml+"</item>";
				}
				
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return xml;
	}	
			
	
	/**
	 * 删除sec_user_state中所有信息
	 * 
	 * 该表为在线用户模块使用
	 * 注意：此处使用spring-job 具体见
	 * 
	 * @void
	 */
	public void delAllUserStateJob(){
		this.userDao.delAllUserState();
		log.info("/* delete all information of sec_user_state */ ");
	}
	
	/**
	 * 根据userid和userip删除sec_user_state中相应信息
	 * 
	 * @param map
	 * @void
	 */
	public void delUserState(UserModel userModel){
		Map<String,String> map = new HashMap<String,String>();
		map.put("user_id", userModel.getUser_id());
		map.put("user_ip", userModel.getIp());
		this.userDao.delUserState(map);
	}

	public List<Department> getDeptListByLevel(int level,String parentid,String user_id)
	{
		List<Department> list=null;
		try
		{
			if(level==1)
			{
				list=this.userDao.getFirstDept();
			}
			else
			{
				list=this.userDao.getDeptByLevel(level,parentid,user_id);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		return list;
	}
	public List<Department> getDeptListByLevel(int level,String parentid)
	{
		List<Department> list=null;
		try
		{
			if(level==1)
			{
				list=this.userDao.getFirstDept();
			}
			else
			{
				list=this.userDao.getDeptByLevel(level,parentid);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		return list;
	}
}