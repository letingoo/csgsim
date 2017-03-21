package db;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import cn.swjtu.multisource.tools.PasswordDecoder;

import flex.messaging.FlexContext;

@SuppressWarnings("deprecation")
public class NewBaseDAO {
	public static String dbUrl;
	
	
	public Connection getConnection(){
		Connection c = null;
		HttpServletRequest request = FlexContext.getHttpRequest();
		try {
			String path = request.getRealPath("")+"/WEB-INF/spring-jdbc.properties";
			InputStream is = new BufferedInputStream(new FileInputStream(path));
            Properties p = new Properties();
        	p.load(is);
        	String driver = p.get("gdtmis.jdbc.driver").toString();
        	String url = p.get("gdtmis.jdbc.url").toString();
        	String username = p.get("gdtmis.jdbc.username").toString();
        	String password = p.get("gdtmis.jdbc.password").toString();
        	PasswordDecoder des = new PasswordDecoder();
        	username = des.decrypt(des.decrypt(des.encode(username)));
        	password = des.decrypt(des.decrypt(des.encode(password)));
			Class.forName(driver);
			c = DriverManager.getConnection(url, username, password);
			return c;
		} catch (Exception e) {
			e.printStackTrace();
			if(c!=null) try {c.close();} catch (SQLException e1) {}
		}
		return null;
	}
	
	public void closeConnection(Connection c,Statement s,ResultSet r){
		try {
			if(r!=null) r.close();
		} catch (Exception e) {}
		try {
			if(s!=null) s.close();
		} catch (Exception e) {}
		try {
			if(c!=null) c.close();
		} catch (Exception e) {}
	}
}
