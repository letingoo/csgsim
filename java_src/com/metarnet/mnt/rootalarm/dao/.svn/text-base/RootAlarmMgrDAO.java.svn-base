package com.metarnet.mnt.rootalarm.dao;

import java.util.List;

import com.metarnet.mnt.rootalarm.model.RootAlarmFlowMgrInfo;
import com.metarnet.mnt.rootalarm.model.RootAlarmMgr;

public interface RootAlarmMgrDAO {
	public List findAllunAckedAlarms();
	
	public List getComboxData(String xtype);

	public List getRootAlarmMgrInfo(RootAlarmMgr rda);

	public int getRootAlarmMgrCount(RootAlarmMgr rda);

	public String changeCurrentAlarmToCommonAlarm(String alarmid,
			String operPerson);

	public String getusername();

	public List getRootAlarmFlowMgrInfo(
			RootAlarmFlowMgrInfo rootalarmflowmgrinfo);

	public List getTransRootAlarmMgrInfo(String alarmobjdesc,
			String alarmdesc, String isacked, String alarmdealmethod,
			String start, String end);
	
	public int getTransRootAlarmMgrCount(String alarmobjdesc,
			String alarmdesc, String isacked, String alarmdealmethod,
			String start, String end);

}
