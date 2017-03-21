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

import login.dwr.LoginDwr;

import flex.messaging.FlexContext;

// 数据库连接配置都直接从spring-jdbc.properties文件读取
@SuppressWarnings("deprecation")
public class ForTimeBaseDAO {
	public static String dbUrl;
	public Connection getConnection(){
		Connection c = null;
		try {
			HttpServletRequest request = FlexContext.getHttpRequest();
			String path = request.getRealPath("")+"/WEB-INF/spring-jdbc.properties";
			InputStream is = new BufferedInputStream(new FileInputStream(path));
            Properties p = new Properties();
        	p.load(is);
        	String driver = p.get("jdbc.driver").toString();
        	String url = p.get("jdbc.url").toString();
        	String username = LoginDwr.getCurrVersionByUser();//p.get("jdbc.username").toString();
        	String password = LoginDwr.getCurrVersionByUser();//p.get("jdbc.password").toString();
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