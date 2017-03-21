package indexEvaluation.model;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class SetCharacterEncodingFilter implements Filter {

	
	public void destroy() {
		// TODO Auto-generated method stub

	}

	
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("GBK");
		response.setContentType("text/html;charset=gb2312");
        System.out.println("+++++++++++++过滤器访问++++++++++++++");
		// 传递控制到下一个过滤器
		chain.doFilter(request, response);
	}

	
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub

	}

}