package com.metarnet.mnt.alarmmgr.model;

import java.util.List;

public class AlarmResult {
	private List list;
	
	private int   alarmcount;
	
	
	private int getKeyBusinessCount;
	private List getKeyBusinessList;
	

	public int getGetKeyBusinessCount() {
		return getKeyBusinessCount;
	}

	public void setGetKeyBusinessCount(int getKeyBusinessCount) {
		this.getKeyBusinessCount = getKeyBusinessCount;
	}

	public List getGetKeyBusinessList() {
		return getKeyBusinessList;
	}

	public void setGetKeyBusinessList(List getKeyBusinessList) {
		this.getKeyBusinessList = getKeyBusinessList;
	}

	public List getList() {
		return list;
	}

	public void setList(List list) {
		this.list = list;
	}

	public int getAlarmcount() {
		return alarmcount;
	}

	public void setAlarmcount(int alarmcount) {
		this.alarmcount = alarmcount;
	}
	
	
	
}
