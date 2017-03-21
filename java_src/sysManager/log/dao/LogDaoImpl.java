package sysManager.log.dao;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.orm.ibatis.SqlMapClientTemplate;

import flex.messaging.FlexContext;
import flex.messaging.FlexSession;

import sysManager.log.model.LogModel;
import sysManager.user.model.UserModel;

public class LogDaoImpl implements LogDao{

    private final static Log log = LogFactory.getLog(LogDaoImpl.class);
	
	private SqlMapClientTemplate sqlMapClientTemplate;

    public SqlMapClientTemplate getSqlMapClientTemplate() {
	   return sqlMapClientTemplate;
    }

    public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	   this.sqlMapClientTemplate = sqlMapClientTemplate;
    }
	
	public void createLogEvent(String log_type, String module_desc,
			String func_desc, String data_id, HttpServletRequest request) {
        try{
	  	    //获取客户端Ip
		    String ip=request.getRemoteAddr();
		    //获取当前系统时间
		    SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		    String time=sf.format(new Date());
		    //获取用户信息
            FlexSession session = FlexContext.getFlexSession();
            if(null == session){
            	log.error("Session is null. Log will lost! ");
            	return;
            }
            UserModel user = (UserModel)session.getAttribute((String)session.getAttribute("userid"));
//          UserModel user = (UserModel)session.getAttribute("user");
            
		    LogModel logModel = new LogModel();
		    logModel.setLog_type(log_type);
		    logModel.setModule_desc(module_desc);
		    logModel.setFunc_desc(func_desc);
		    logModel.setData_id(data_id);
		    String userid="";
		    String username="";
		    String userunit = "";
		    if(user==null){
		    	userid="auto";
		    	username="系统自动同步";
		    	userunit = "系统";
            }else{
            	userid=user.getUser_id();
            	username = user.getUser_name();
            	userunit = user.getUser_dept();
            }
		    logModel.setUser_id(userid);
		    logModel.setUser_name(username);
		    logModel.setDept_name(userunit);
		    logModel.setUser_ip(ip);
		    logModel.setLog_time(time);
		
		    getSqlMapClientTemplate().insert("createLogEvent", logModel);
        }catch(Exception e){
	       	log.error("Can't get session. Log will lost! " + e.getMessage());
	       	e.printStackTrace();
		}
	}

	public Object getLogEvents(Object obj) {
		return getSqlMapClientTemplate().queryForList("getLogEvents",obj);
	}
	
	public Object getLogEvents_exportExcel(Object obj) {
		return getSqlMapClientTemplate().queryForList("getLogEvents_excel",obj);
	}	

	public int getCountEvents(Object obj) {
		return (Integer)getSqlMapClientTemplate().queryForObject("getCountEvents",obj);
	}

	public Object expLogs(Object obj) {
		
		return getSqlMapClientTemplate().queryForList("expLogs",obj);
	}

	@Override
	public ArrayList getSyncLogInfos(LogModel logModel) {
		// TODO Auto-generated method stub
		return (ArrayList) this.getSqlMapClientTemplate().queryForList("getSyncLogInfos", logModel);
	}

	@Override
	public int getSyncLogInfosCount(LogModel logModel) {
		// TODO Auto-generated method stub
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getSyncLogInfosCount", logModel);
	}

}
