package login.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import cn.swjtu.multisource.tools.ConstArgs;

import com.Message;

import sysManager.user.model.UserStateModel;

import db.DbDAO;

import flex.messaging.FlexContext;

public class SessionListener implements HttpSessionAttributeListener {
	/**
	 * 定义监听的session属性名.
	 */
	public final static String LISTENER_NAME = "_login";

	/**
	 * 定义存储客户登录session的集合.
	 */
	private static List sessions = new ArrayList();

	/**
	 * 加入session时的监听方法.
	 * 
	 * @param HttpSessionBindingEvent
	 *            session事件
	 */
	public void attributeAdded(HttpSessionBindingEvent sbe) {
		ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
		DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");
		Map map = new HashMap();
		if (LISTENER_NAME.equals(sbe.getName())) {
//			sessions.add(sbe.getValue());
			OnlineSession key = (OnlineSession) sbe.getValue();
			map.put("user_id", key.getUser_id());
			map.put("user_ip", key.getUser_ip());
			map.put("user_state", 1);
			UserStateModel userStateModel = (UserStateModel)basedao.queryForObject("getOnlineUserByUserId", map);
			if(userStateModel==null){
				basedao.insert("insertUserState", map);
			}
		}
		if("userid".equals(sbe.getName())){
			HttpServletRequest request = FlexContext.getHttpRequest();
			String ip = request.getRemoteAddr();
			String userid = (String) sbe.getValue();
			map.put("user_id", userid);
			map.put("user_ip", ip);
			map.put("user_state", 1);
			UserStateModel userStateModel = (UserStateModel)basedao.queryForObject("getOnlineUserByUserId", map);
			if(userStateModel==null){
				basedao.insert("insertUserState", map);
			}
		}
		
	}

	/**
	 * session失效时的监听方法.
	 * 
	 * @param HttpSessionBindingEvent
	 *            session事件
	 */
	public void attributeRemoved(HttpSessionBindingEvent sbe) {
		String user_id="";
		if (LISTENER_NAME.equals(sbe.getName())) {
//			sessions.remove(sbe.getValue());
			OnlineSession key = (OnlineSession)sbe.getValue();
			user_id = key.getUser_id();
		}
		//注销时
		if("userid".equals(sbe.getName())){
			//封装对象
			user_id = (String) sbe.getValue();
		}
		if(!"".equals(user_id)){
			ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
			DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");
			HttpServletRequest request = FlexContext.getHttpRequest();
			Map map =new HashMap();
			map.put("user_id", user_id);
			map.put("user_state", "0");
			map.put("user_ip", request.getRemoteAddr());
			basedao.delete("delUserState", map);
			
			HttpSession session = request.getSession();
			if(session.getAttribute("userid") != null)
				session.removeAttribute("userid");
			Message.pushMessage("off_line:"+user_id+":"+request.getRemoteAddr());
			session.setAttribute(ConstArgs.KEY_DATABASE,ConstArgs.DEFAULT_DATABASE);
		}
	}

	/**
	 * session覆盖时的监听方法.
	 * 
	 * @param HttpSessionBindingEvent
	 *            session事件
	 */
	public void attributeReplaced(HttpSessionBindingEvent sbe) {
	}

	/**
	 * 返回客户登录session的集合.
	 * 
	 * @return
	 */
	public static List getSessions() {
		return sessions;
	}

}
