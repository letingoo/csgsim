package cn.swjtu.multisource.tools;

import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConstArgs {
	public static String DEFAULT_DATABASE="csg_simulate02";
	public static final String KEY_DATABASE="key_database";
	public static String USER;
	public static String PASSWORD;
	public static String DRIVER_CLASS;
	public static String SERVER_URL;
	public static String MAXIMUMCONNECTIONCOUNT;
	public static String MINIMUMCONNECTIONCOUNT;
	public static String PROTOTYPECOUNT;
	public static String TRACE;
	public static String VERBOSE;
	public static String MAXIMUMACTIVETIME;
	public static String HOUSEKEEPINGTESTSQL;
	public static String SIMULTANEOUSBUILDTHROTTLE;
	public static String ORACLEDMPFILE;
	public static String ORACLEDMPFROMUSER;
	public static String ORACLEDMPSID;
	
	static {   
		
	try {   
		String filename="spring-jdbc.properties";
		Properties prop=new Properties();
		String path=Thread.currentThread().getContextClassLoader().getResource("/").getPath();
		path=path.substring(1,path.indexOf("classes"));
		prop.load(new java.io.FileInputStream(path+filename));   
		DEFAULT_DATABASE=prop.getProperty("jdbc.username").trim(); 
		USER = prop.getProperty("jdbc.username").trim();  
		PASSWORD  = prop.getProperty("jdbc.password").trim(); 
		//解密
//		PasswordDecoder des = new PasswordDecoder();
//		PASSWORD = des.decrypt(des.decrypt(des.encode(PASSWORD)));
//		DEFAULT_DATABASE = des.decrypt(des.decrypt(des.encode(DEFAULT_DATABASE)));
//		USER = des.decrypt(des.decrypt(des.encode(USER)));
		
		DRIVER_CLASS=prop.getProperty("jdbc.driver").trim();   
		SERVER_URL=prop.getProperty("jdbc.url").trim();   
		MAXIMUMCONNECTIONCOUNT=prop.getProperty("jdbc.maxPoolSize").trim();   
		MINIMUMCONNECTIONCOUNT=prop.getProperty("jdbc.minPoolSize").trim();  
		PROTOTYPECOUNT=prop.getProperty("jdbc.prototypeCount").trim();  
		TRACE=prop.getProperty("jdbc.trace").trim();  
		VERBOSE=prop.getProperty("jdbc.verbose").trim();  
		MAXIMUMACTIVETIME=prop.getProperty("jdbc.maximumActiveTime").trim();  
		HOUSEKEEPINGTESTSQL=prop.getProperty("jdbc.houseKeepingTestSql").trim();  
		SIMULTANEOUSBUILDTHROTTLE=prop.getProperty("jdbc.simultaneousBuildThrottle").trim();  
		//ORACLEDMPFILE=prop.getProperty("jdbc.oracledmpfile").trim();
		//ORACLEDMPFROMUSER=prop.getProperty("jdbc.oracledmpfromuser").trim();
		//ORACLEDMPSID=prop.getProperty("jdbc.oracledmpsid").trim();
//		System.out.println(USER+"||"+PASSWORD+"||"+SERVER_URL+"============================");
		 } catch (Exception e) {   
			 e.printStackTrace();   
//			 DEFAULT_DATABASE="csg_simulate02";   
//			USER = "csg_simulate02";  
//			PASSWORD  = "csg_simulate02"; 
//			DRIVER_CLASS="oracle.jdbc.driver.OracleDriver";   
//			SERVER_URL="jdbc:oracle:thin:@192.168.6.34:1521:orcl";   
			 
			 DEFAULT_DATABASE = "csg_simulate01";
			 USER = "root";
			 PASSWORD = "12345";
			 DRIVER_CLASS = "com.mysql.jdbc.Driver";
			 SERVER_URL = "jdbc:mysql://192.168.6.51:3306/csg_simulate01";
		 }   
	 } 
	
}
