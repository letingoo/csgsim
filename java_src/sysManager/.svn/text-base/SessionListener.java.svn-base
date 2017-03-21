package sysManager;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import cn.swjtu.multisource.tools.ConstArgs;

import flex.messaging.FlexContext;

import sysManager.user.dwr.UserDwr;
import sysManager.user.model.UserModel;

/*
 * 北京市天元网络技术股份有限公司
 * @date:2011-4-25
 * @author:ynn
 */
public class SessionListener implements HttpSessionListener {

	private final static Log log = LogFactory.getLog(SessionListener.class);
	
	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpSessionListener#sessionCreated(javax.servlet.http.HttpSessionEvent)
	 */
	public void sessionCreated(HttpSessionEvent sessionEvent) {
	    log.debug("session created sessionid " + sessionEvent.getSession().getId());
	}

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpSessionListener#sessionDestroyed(javax.servlet.http.HttpSessionEvent)
	 */
	public void sessionDestroyed(HttpSessionEvent sessionEvent) {
		HttpSession session = sessionEvent.getSession();
	    log.debug("session destroyed " + session.getAttribute("userid") + "|" + session.getAttribute("userip"));
	    session.setAttribute(ConstArgs.KEY_DATABASE,ConstArgs.DEFAULT_DATABASE);//设置登录版本 实为数据库连接用户 超时登出  设置连接为默认
		if(null != session.getAttribute("userid") && null != session.getAttribute("userip")){
		    UserModel user = new UserModel();
		    user.setUser_id((String)session.getAttribute("userid"));
		    user.setIp((String)session.getAttribute("userip"));
		    WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
		    UserDwr userDwr = (UserDwr)ctx.getBean("userManager");
		    userDwr.delUserState(user);
		}    
        		
	}

}
