package com.metarnet.mnt.alarmmgr.dao;

import java.util.List;
import java.util.Map;

import com.metarnet.mnt.alarmmgr.model.AlarmInfos;
import com.metarnet.mnt.alarmmgr.model.AlarmLevelCount;

public interface AlarmManagerDAO {
	public List getTranssysName(String xtype);

	public String getTreeData(String sysname);

	public AlarmLevelCount getcount(String dealperson, String isAck,
			String alarmlevel, String alarmdesc, String alarmObj,
			String ackperson, String belongportcode, String belongportobject,
			String belongpackobject, String iscleared, String belongshelfcode,
			String belongequip, String vendor, String beginTime,
			String endTime, String isRootAlarm,String table,String belongtransys,String alarmman,String queryFlag,String query,String interposename);

	public List getAlarms(AlarmInfos amf);

	public int getAlarmCount(AlarmInfos amf);

	public int getKeyBusinessCount(String alarmnumber, String circuitname,
			String isacked);

	public List getKeyBusiness(String alarmnumber, String circuitname,
			String isacked, String start, String end);

	public int getKeyBusinessCount_hz1(String circuitname, String station1,
			String station2, String powerline);

	public int getKeyBusinessCount_hz(String circuitname, String station1,
			String station2, String powerline);

	public List getKeyBusiness_hz(String circuitname, String station1,
			String station2, String powerline, String start, String end);

	public List getKeyBusiness_hz1(String circuitname, String station1,
			String station2, String powerline, String start, String end);

	public int getKeyBusinessCount_hz_OperaType(String circuitname,
			String station1, String station2, String powerline);

	public List getKeyBusiness_hz_OperaType(String circuitname,
			String station1, String station2, String powerline, String start,
			String end);

	public String getCircuitCount(String alarmnu);

	public String updateAlarmConfirm(String alarmid, String operPerson,
			String ackcontent);

	public List getAlarmConfirm(String alarmid);

	public List getExportKeyBusiness_hz(String circuitname, String station1,
			String station2, String powerline);
	public List getAlarmsDutyid(AlarmInfos amf);

	public int getAlarmDutyidCount(AlarmInfos amf);
	
	public AlarmLevelCount getcountBySearch(AlarmInfos info);
	
	public List queryVisiable(String tablename);

	public void deleteAlarmByAlarmNumber(String alarmnumber);

	public List getAllRootAlarmInfosLst(AlarmInfos model);

	public int getAllRootAlarmInfoLstCount(AlarmInfos model);

	public void updateAlarmAckStatus(Map<String, String> map);

}
