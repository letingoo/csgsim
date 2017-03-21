package cn.swjtu.multisource.tools;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpSession;


import flex.messaging.FlexContext;

public class MyFilter implements Filter {

	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		String database = null;
		if (FlexContext.getHttpRequest()!= null) {
			HttpSession session = FlexContext.getHttpRequest().getSession();
			database = (String) session.getAttribute(ConstArgs.KEY_DATABASE);
		}
		if (database == null && "".equals(database)) {
			database = ConstArgs.DEFAULT_DATABASE;
		}
		ThreadLocalHolder.set(database);
		chain.doFilter(request, response);
		ThreadLocalHolder.remove();
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub

	}

}
