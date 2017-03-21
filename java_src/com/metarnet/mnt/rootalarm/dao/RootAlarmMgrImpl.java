package com.metarnet.mnt.rootalarm.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.SqlMapClientTemplate;

import sysManager.user.model.UserModel;

import com.metarnet.mnt.rootalarm.model.RootAlarmFlowMgrInfo;
import com.metarnet.mnt.rootalarm.model.RootAlarmMgr;

import flex.messaging.FlexContext;

public class RootAlarmMgrImpl implements RootAlarmMgrDAO {

	private SqlMapClientTemplate sqlMapClientTemplate;

	public SqlMapClientTemplate getSqlMapClientTemplate() {
		return sqlMapClientTemplate;
	}

	public void setSqlMapClientTemplate(
			SqlMapClientTemplate sqlMapClientTemplate) {
		this.sqlMapClientTemplate = sqlMapClientTemplate;
	}

	public List getComboxData(String xtype) {
		try {
			return this.getSqlMapClientTemplate().queryForList(
					"getRootAlarmComboxData", xtype);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;

	}

	public List getRootAlarmMgrInfo(RootAlarmMgr rda) {
		try {
			RootAlarmMgr ars = new RootAlarmMgr();
			ars.setAcktime(rda.getAcktime());
			ars.setAlarmdesc(rda.getAlarmdesc());
			ars.setAlarmlevel(rda.getAlarmlevel());
			ars.setAlarmlevelname(rda.getAlarmlevelname());
			ars.setAlarmobjdesc(rda.getAlarmobjdesc());
			ars.setBelongtransys(rda.getBelongtransys());
			ars.setIsacked(rda.getIsacked());
			ars.setIsackedzh(rda.getIsackedzh());
			ars.setIscleared(rda.getIscleared());
			ars.setLaststarttime(rda.getLaststarttime());
			ars.setVendorzh(rda.getVendorzh());
			ars.setVendor(rda.getVendor());
			ars.setStart(rda.getStart());
			ars.setEnd(rda.getEnd());
			ars.setAckperson(rda.getAckperson());
			ars.setBugno(rda.getBugno());
			ars.setCarrycircuit(rda.getCarrycircuit());
			ars.setDealpart(rda.getDealpart());
			ars.setDealperson(rda.getDealperson());
			ars.setDealresult(rda.getDealresult());
			ars.setDutyid(rda.getDutyid());
			ars.setFlashcount(rda.getFlashcount());
			ars.setIsbugno(rda.getIsbugno());
			ars.setIsworkcase(rda.getIsworkcase());
			ars.setObjclasszh(rda.getObjclasszh());
			ars.setRun_unit(rda.getRun_unit());
			ars.setSpecialtyzh(rda.getSpecialtyzh());
			ars.setTriggeredthreshold(rda.getTriggeredthreshold());
			ars.setAckcontent(rda.getAckcontent());
			ars.setBelongportobject(rda.getBelongportobject());
			ars.setAlarmnumber(rda.getAlarmnumber());
			ars.setUsername(rda.getUsername());
			ars.setDealresultzh(rda.getDealresultzh());
			ars.setBelongequip(rda.getBelongequip());
			ars.setBelongpackobject(rda.getBelongpackobject());
			ars.setBelongportcode(rda.getBelongportcode());
			ars.setCompanyalarmcnt(rda.getCompanyalarmcnt());
			return this.getSqlMapClientTemplate().queryForList(
					"getsRootAlarmMgrInfo", ars);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public int getRootAlarmMgrCount(RootAlarmMgr rda) {
		try {
			RootAlarmMgr ars = new RootAlarmMgr();
			ars.setAcktime(rda.getAcktime());
			ars.setAlarmdesc(rda.getAlarmdesc());
			ars.setAlarmlevel(rda.getAlarmlevel());
			ars.setAlarmlevelname(rda.getAlarmlevelname());
			ars.setAlarmobjdesc(rda.getAlarmobjdesc());
			ars.setBelongtransys(rda.getBelongtransys());
			ars.setIsacked(rda.getIsacked());
			ars.setIsackedzh(rda.getIsackedzh());
			ars.setIscleared(rda.getIscleared());
			ars.setLaststarttime(rda.getLaststarttime());
			ars.setVendorzh(rda.getVendorzh());
			ars.setVendor(rda.getVendor());
			ars.setStart(rda.getStart());
			ars.setEnd(rda.getEnd());
			ars.setAckperson(rda.getAckperson());
			ars.setBugno(rda.getBugno());
			ars.setCarrycircuit(rda.getCarrycircuit());
			ars.setDealpart(rda.getDealpart());
			ars.setDealperson(rda.getDealperson());
			ars.setDealresult(rda.getDealresult());
			ars.setDutyid(rda.getDutyid());
			ars.setFlashcount(rda.getFlashcount());
			ars.setIsbugno(rda.getIsbugno());
			ars.setIsworkcase(rda.getIsworkcase());
			ars.setObjclasszh(rda.getObjclasszh());
			ars.setRun_unit(rda.getRun_unit());
			ars.setSpecialtyzh(rda.getSpecialtyzh());
			ars.setTriggeredthreshold(rda.getTriggeredthreshold());
			ars.setAckcontent(rda.getAckcontent());
			ars.setBelongportobject(rda.getBelongportobject());
			ars.setAlarmnumber(rda.getAlarmnumber());
			ars.setUsername(rda.getUsername());
			ars.setDealresultzh(rda.getDealresultzh());
			ars.setBelongequip(rda.getBelongequip());
			ars.setBelongpackobject(rda.getBelongpackobject());
			ars.setBelongportcode(rda.getBelongportcode());
			ars.setCompanyalarmcnt(rda.getCompanyalarmcnt());
			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getsRootAlarmMgrCount", ars);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
		return 0;
	}

	public String changeCurrentAlarmToCommonAlarm(String alarmid,
			String operPerson) {

		// 取到转普通告警的xtbm编号

		String xtbm = "";
		String dealresult = "转普通告警";
		xtbm = this.getSqlMapClientTemplate().queryForObject("getXTBM",
				dealresult).toString();

		// TODO Auto-generated method stub
		// 执行更新SQL，更新的当前告警为根告警
		String reuslt = "失败";
		// 将根告警对应的伴随报警清除（alarm_affection）
		Map m = new HashMap();
		m.put("alarmid", alarmid);
		m.put("operPerson", operPerson);
		m.put("dealresult", xtbm);
		int a = this.sqlMapClientTemplate.update(
				"changeCurrentAlarmToCommonAlarmMgr", m);
		if (a > 0) {
			try {
				this.sqlMapClientTemplate.delete(
						"deleteCurrentAlarmToCommonAlarmMgr", m);
				Map mDealInfo = new HashMap();
				mDealInfo.put("dealinfo", "根告警转普通告警");
				mDealInfo.put("ackperson", operPerson);
				mDealInfo.put("alarmnumber", alarmid);
				this.sqlMapClientTemplate.insert("writeDealAlarmLogMgr",
						mDealInfo); // .update("ackingRootAlarm", mParmed);
				reuslt = "成功";
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else {
			reuslt = "失败";
		}
		return reuslt;
	}

	public String getusername() {
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		String userId = "";
		if (session.getAttribute("userid") != null) {
			UserModel user = (UserModel) session.getAttribute((String) session
					.getAttribute("userid"));
			if (user != null) {
				userId = user.getUser_id();
			}
		}
		return userId;
	}

	public List getRootAlarmFlowMgrInfo(
			RootAlarmFlowMgrInfo rootalarmflowmgrinfo) {
		List resultResult = new ArrayList();
		Map m = new HashMap();
		String dealresultzh = rootalarmflowmgrinfo.getDealresultzh();
		if (!dealresultzh.equalsIgnoreCase("请选择")) {
			m.put("dealresultzh", dealresultzh);
		}
		if (rootalarmflowmgrinfo.getAlarmdesc() != null) {
			m.put("alarmdesc", rootalarmflowmgrinfo.getAlarmdesc());
		}
		if (rootalarmflowmgrinfo.getAlarmobjdesc() != null) {
			m.put("alarmobjdesc", rootalarmflowmgrinfo.getAlarmobjdesc());
		}
		m.put("start", rootalarmflowmgrinfo.getStart());
		m.put("end", rootalarmflowmgrinfo.getEnd());
		resultResult.add(this.sqlMapClientTemplate.queryForList(
				"getRootAlarmFlowMgrInfo", m));
		resultResult.add((Integer) this.getSqlMapClientTemplate()
				.queryForObject("getsRootAlarmFlowMgrCount", m));
		return resultResult;
	}

	public List getTransRootAlarmMgrInfo(String alarmobjdesc, String alarmdesc,
			String isacked, String alarmdealmethod, String start, String end) {
		HashMap m = new HashMap();
		m.put("alarmobjdesc", alarmobjdesc);
		m.put("alarmdesc", alarmdesc);
		m.put("isacked", isacked);
		m.put("alarmdealmethod", alarmdealmethod);
		m.put("start", start);
		m.put("end", end);
		try {
			return this.getSqlMapClientTemplate().queryForList(
					"getTransRootAlarmMgrInfo", m);
		} catch (Exception e) {
			// TODO: handle exception
		}
		return null;

	}

	@Override
	public int getTransRootAlarmMgrCount(String alarmobjdesc, String alarmdesc,
			String isacked, String alarmdealmethod, String start, String end) {
		// TODO Auto-generated method stub
		HashMap m = new HashMap();
		m.put("alarmobjdesc", alarmobjdesc);
		m.put("alarmdesc", alarmdesc);
		m.put("isacked", isacked);
		m.put("alarmdealmethod", alarmdealmethod);
		m.put("start", start);
		m.put("end", end);
		try {
			return (Integer)this.getSqlMapClientTemplate().queryForObject(
					"getTransRootAlarmMgrCount", m);
		} catch (Exception e) {
			// TODO: handle exception
		}
		return 0;
	}

	@Override
	public List findAllunAckedAlarms() {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList(
				"findAllunAckedAlarms", "");
	}

}
