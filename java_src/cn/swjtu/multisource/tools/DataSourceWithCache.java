package cn.swjtu.multisource.tools;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import org.springframework.jdbc.datasource.SingleConnectionDataSource;


import flex.messaging.FlexContext;

public class DataSourceWithCache implements DataSource {

	private static Map<String, DataSource> sources = new HashMap<String, DataSource>();

	// private DataSource source;
	private DataSource getDataSource() {
		String name = ThreadLocalHolder.get();
		if (name == null || "".equals(name)) {
			if(FlexContext.getHttpRequest()!=null){
				name = (String) (FlexContext.getHttpRequest().getSession())
						.getAttribute(ConstArgs.KEY_DATABASE);
			}
			if (name == null || "".equals(name)) {
				name = ConstArgs.DEFAULT_DATABASE;
			}
		}
		DataSource source = sources.get(name);
		Boolean isNotConnect=true;
		Connection c =null;
		Statement s = null;
		if(source!=null){//当前有数据源 再进行判断数据源是否可用
			try{
				c = source.getConnection();
				s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
			}catch (Exception e) {
				e.printStackTrace();
				isNotConnect=false;
			}finally{
				try {
					if(c!=null)c.close();;
					if(s!=null)s.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		
		if (source == null||isNotConnect==false) {
			source = createSource(name);
			sources.put(name, source);
		}
		return source;
	}

	private DataSource createSource(String name) {
		SingleConnectionDataSource source = new SingleConnectionDataSource();
		System.out.println(ConstArgs.DRIVER_CLASS+"||"+ConstArgs.SERVER_URL);
		source.setDriverClassName(ConstArgs.DRIVER_CLASS);
		source.setUrl(ConstArgs.SERVER_URL);
		source.setUsername(name);
		source.setPassword(ConstArgs.PASSWORD);
		Properties connectionProperties=new Properties();
		connectionProperties.setProperty("maximumConnectionCount", ConstArgs.MAXIMUMCONNECTIONCOUNT);
		connectionProperties.setProperty("minimumConnectionCount", ConstArgs.MINIMUMCONNECTIONCOUNT);
		connectionProperties.setProperty("prototypeCount", ConstArgs.PROTOTYPECOUNT);
		connectionProperties.setProperty("trace", ConstArgs.TRACE);
		connectionProperties.setProperty("verbose", ConstArgs.VERBOSE);
		connectionProperties.setProperty("maximumActiveTime", ConstArgs.MAXIMUMACTIVETIME);
		connectionProperties.setProperty("houseKeepingTestSql", ConstArgs.HOUSEKEEPINGTESTSQL);
		connectionProperties.setProperty("simultaneousBuildThrottle", ConstArgs.SIMULTANEOUSBUILDTHROTTLE);
		source.setConnectionProperties(connectionProperties);
		source.setSuppressClose(true);
		return source;
	}

	@Override
	public Connection getConnection() throws SQLException {
		return getDataSource().getConnection();
	}

	@Override
	public Connection getConnection(String username, String password)
			throws SQLException {
		return getDataSource().getConnection(username, password);
	}

	@Override
	public PrintWriter getLogWriter() throws SQLException {
		return getDataSource().getLogWriter();
	}

	@Override
	public int getLoginTimeout() throws SQLException {
		return getDataSource().getLoginTimeout();
	}

	@Override
	public void setLogWriter(PrintWriter out) throws SQLException {
		getDataSource().setLogWriter(out);

	}

	@Override
	public void setLoginTimeout(int seconds) throws SQLException {
		getDataSource().setLoginTimeout(seconds);
	}

	@Override
	public boolean isWrapperFor(Class<?> iface) throws SQLException {
		return getDataSource().isWrapperFor(iface);
	}

	@Override
	public <T> T unwrap(Class<T> iface) throws SQLException {
		return getDataSource().unwrap(iface);
	}

}
