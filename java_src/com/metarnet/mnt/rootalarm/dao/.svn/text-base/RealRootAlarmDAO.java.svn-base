package com.metarnet.mnt.rootalarm.dao;

import java.util.ArrayList;
import java.util.List;

import com.metarnet.mnt.rootalarm.model.AckRootAlarmModel;
import com.metarnet.mnt.rootalarm.model.AlarmAffirmModel;
import com.metarnet.mnt.rootalarm.model.ChangeZDResultModel;
import com.metarnet.mnt.rootalarm.model.PoUpKeyBussinessModel;

public interface RealRootAlarmDAO {

	/**
	 * 根告警确认
	 * 
	 * @param alarmid
	 *            ,告警编号
	 * @param dealMethod
	 *            ,处理方式
	 * @param ackPerson
	 *            ,告警确认人
	 * @param ackTime
	 *            ,告警确认时间
	 * @return 根告警集合
	 */
	public void ackRootAlarm(String alarmnumber, String dealresult,
			String isworkcase, String ackcontent, String ackPerson);

	public String getequipname(String equipcode);

	public String getusername();

	// 判断该跟告警是否确认过
	public String ackTime(String alarmnumber);

	/*
	 * 获取已经维护了告警经验的厂家信息列表
	 */
	public String getAlarmExperiecnceVendor();

	// 获取告警经验数据
	public List getAlarmDealInfoByMessage(String vendor, String alarmdes,
			int start, int end);

	// 获取告警经验数量
	public int getAlarmExperienceCount(String vendor, String alarmdes);

	// 获取告警起因数据
	public List getAlarmCause();

	// 获取处理方式
	public List getDealResult(String dealwith);

	// 获取伴随告警
	public List getCompanyAlarm(String alarmNum, String start, String end);

	// 获取伴随告警数量
	public int getCompanyAlarmCount(String alarmNum, String start, String end);

	// 获取当前跟告警，转伴随告警需要
	public List getCurrentRootAlarm(String alarmno, String start, String end);

	// 获取当前跟告警数量，转伴随告警需要
	public int getCurrentRootAlarmCount(String alarmno);

	// 查看历史告警
	public List getRootAlarmMgrInfo(String alarmnum, String alarmobjdesc,
			String alarmdesc, String belongtransys, String belongequip,
			String belongpackobject, String belongportobject,
			String belongportcode, String start, String end);

	// 查看历史告警数量
	public int getRootAlarmMgrInfoCount(String alarmnum, String alarmobjdesc,
			String alarmdesc, String belongtransys, String belongequip,
			String belongpackobject, String belongportobject,
			String belongportcode);

	// 根告警转普通告警单独操作
	public String changToNorAlarm(String alarmNo);

	// 获取影响电路信息
	public List getAffectCircuit(PoUpKeyBussinessModel poupkeybussiness);

	// 获取影响电路信息数量
	public int getAffectCircuitCount(PoUpKeyBussinessModel poupkeybussiness);

	// 根据厂家和描述获取告警经验信息

	public String getAlarmEXP(String alarmnumber);

	// 将当前告警转为伴随告警
	public String changeToCompanyAlarm(String alarmid, String alarmnumber,
			String operPerson);

	// 转检修流程处理
	public String changeToRepairAlarm(String operPerson, String alarmnm,
			String dealresult, String isworkcase);

	public List getRepairs(String start, String end);

	public int getRepairsCount();

	// 获取是否播放音乐
	public String getSoundStatus();

	// 根告警转流程操作
	public String setFaultProcess(String alarmNo, String userID,
			String operPerson);

	public List getFaults(String alarmnm, String time, String alarmtime,
			String start, String end);

	public int getFaultsCount(String alarmnm, String time, String alarmtime);

	public String setOldFaultProcess(String bugno, String dutyid,
			String operPerson, String alarmnm, String dealresult,
			String isworkcase);

	// 批量确认根告警
	public String ackRootAlarms(ArrayList<AckRootAlarmModel> ackRootAlarms);
	
	// 转中调处理
	public ChangeZDResultModel setRootAlarms(ArrayList<AlarmAffirmModel> ackRootAlarms);	

	// 单个确认根告警
	public String ackRootAlarmNew(String alarmnumber, String ackPerson,
			String dealresult, String isworkcase, String ackcontent,
			String alarmtype);

	// 查询根告警
	public List getRootAlarm(String isacked, String dealresult);

	public int getRootAlarmCount();


	public String getUserName();

	public String getCurrentUserCh();

	public String ackRootAlarmNew_(AlarmAffirmModel aam);

	public List<AlarmAffirmModel> getAckLog(String alarmnumber);

	public void insertAckLog(AlarmAffirmModel aam);
	public String confimAlarm(AlarmAffirmModel ackrootalarm);
}
