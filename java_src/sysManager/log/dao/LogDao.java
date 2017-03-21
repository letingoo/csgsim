package sysManager.log.dao;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import sysManager.log.model.LogModel;


public interface LogDao {
	public Object getLogEvents(Object obj);
	public Object getLogEvents_exportExcel(Object obj);
	public void createLogEvent(String log_type, String module_desc,
			String func_desc, String data_id, HttpServletRequest request);
	public int getCountEvents(Object obj);
	public Object expLogs(Object obj);
//	public Object getLogEventsfeng();
	public int getSyncLogInfosCount(LogModel logModel);
	public ArrayList getSyncLogInfos(LogModel logModel);
}
