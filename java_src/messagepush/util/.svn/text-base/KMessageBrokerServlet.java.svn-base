package messagepush.util;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import flex.messaging.HttpFlexSession;
import flex.messaging.MessageBrokerServlet;

public class KMessageBrokerServlet extends MessageBrokerServlet {
	@Override
	public void service(HttpServletRequest req, HttpServletResponse res) { 
		HttpSession httpSession = req.getSession(true);
		HttpFlexSession flexSession = (HttpFlexSession)httpSession.getAttribute("__flexSession");
		if( flexSession != null && !flexSession.isValid()){  
			httpSession.removeAttribute("__flexSession");  
		} 

		super.service(req, res);
	}
}
