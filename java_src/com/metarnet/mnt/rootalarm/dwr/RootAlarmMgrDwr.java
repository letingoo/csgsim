package com.metarnet.mnt.rootalarm.dwr;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.metarnet.mnt.rootalarm.dao.RootAlarmMgrDAO;
import com.metarnet.mnt.rootalarm.model.RootAlarmFlowMgrInfo;
import com.metarnet.mnt.rootalarm.model.RootAlarmMgr;
import com.metarnet.mnt.rootalarm.model.RootAlarmMgrResult;

public class RootAlarmMgrDwr {
	private RootAlarmMgrDAO rootalarmmgrdao;

	public RootAlarmMgrDAO getRootalarmmgrdao() {
		return rootalarmmgrdao;
	}

	public void setRootalarmmgrdao(RootAlarmMgrDAO rootalarmmgrdao) {
		this.rootalarmmgrdao = rootalarmmgrdao;
	}

	public List getComboxData(String xtype) {
		return rootalarmmgrdao.getComboxData(xtype);
	}

	public RootAlarmMgrResult getRootAlarmMgrInfo(RootAlarmMgr info) {
		RootAlarmMgrResult ars = new RootAlarmMgrResult();
		ars.setList(this.rootalarmmgrdao.getRootAlarmMgrInfo(info));
		ars.setAlarmcount(this.rootalarmmgrdao.getRootAlarmMgrCount(info));
		return ars;
	}

	public String changeCurrentAlarmToCommonAlarm(String alarmid,
			String operPerson) {
		return rootalarmmgrdao.changeCurrentAlarmToCommonAlarm(alarmid,
				operPerson);
	}

	public RootAlarmMgrResult getTransRootAlarmMgrInfo(String alarmobjdesc,
			String alarmdesc, String isacked, String alarmdealmethod,
			String start, String end) {
		RootAlarmMgrResult rm = new RootAlarmMgrResult();
		rm.setList(this.rootalarmmgrdao.getTransRootAlarmMgrInfo(alarmobjdesc,
				alarmdesc, isacked, alarmdealmethod, start, end));
		rm.setAlarmcount(this.rootalarmmgrdao.getTransRootAlarmMgrCount(alarmobjdesc,
				alarmdesc, isacked, alarmdealmethod, start, end));
		return rm;
	}

	public String getusername() {
		return this.rootalarmmgrdao.getusername();
	}

	public List getRootAlarmFlowMgrInfo(
			RootAlarmFlowMgrInfo rootalarmflowmgrinfo) {
		System.out.println(rootalarmflowmgrinfo.getDealresultzh());
		return this.rootalarmmgrdao
				.getRootAlarmFlowMgrInfo(rootalarmflowmgrinfo);
	}
	
	
	public List findAllunAckedAlarms(){
	    System.out.println("当前时间----------------------------------------"+getStringDate());
		return  rootalarmmgrdao.findAllunAckedAlarms();
	}	
	
	public static String getStringDate() {
		   Date currentTime = new Date();
		   SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		   String dateString = formatter.format(currentTime);
		   return dateString;
		}	
}
