package com.metarnet.mnt.rootalarm.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.SqlMapClientTemplate;

import sysManager.user.model.UserModel;

import com.metarnet.mnt.rootalarm.model.AckRootAlarmModel;
import com.metarnet.mnt.rootalarm.model.AlarmAffirmModel;
import com.metarnet.mnt.rootalarm.model.ChangeZDResultModel;
import com.metarnet.mnt.rootalarm.model.PoUpKeyBussinessModel;
import com.metarnet.mnt.rootalarm.model.RealRootAlarmModel;

import flex.messaging.FlexContext;
import flex.messaging.io.ArrayCollection;

public class RealRootAlarmImpl implements RealRootAlarmDAO {

	private SqlMapClientTemplate sqlMapClientTemplate;

	public SqlMapClientTemplate getSqlMapClientTemplate() {
		return sqlMapClientTemplate;
	}

	public void setSqlMapClientTemplate(
			SqlMapClientTemplate sqlMapClientTemplate) {
		this.sqlMapClientTemplate = sqlMapClientTemplate;
	}

	public void ackRootAlarm(String alarmnumber, String dealresult,
			String isworkcase, String ackcontent, String ackPerson) {
		// TODO Auto-generated method stub

		String ack = "";
		String dealinfo = "";
		// 已确认根告警参数
		Map mParming = new HashMap();
		mParming.put("ackperson", ackPerson);
		mParming.put("ackcontent", ackcontent);
		mParming.put("dealresult", dealresult);
		mParming.put("isworkcase", isworkcase);
		mParming.put("alarmnumber", alarmnumber);

		// 未确认根告警参数
		Map mParmed = new HashMap();
		mParmed.put("ackcontent", ackcontent);
		mParmed.put("dealresult", dealresult);
		mParmed.put("isworkcase", isworkcase);
		mParmed.put("alarmnumber", alarmnumber);

		try {
			this.sqlMapClientTemplate.update("ackingRealRootAlarm", mParming);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if (ackcontent != null && !"".equals(ackcontent)) {
			dealinfo = "确认内容:" + ackcontent;
		}

		if (dealresult != null && !"".equals(dealresult)) {
			if (dealinfo != null && !"".equals(dealinfo))
				dealinfo = dealinfo + ",处理方式:" + dealresult;
			else
				dealinfo = dealinfo + "处理方式:" + dealresult;
		}

		if (isworkcase != null && !"".equals(isworkcase)) {
			if (dealinfo != null)
				dealinfo = dealinfo + ",告警原因:" + isworkcase;
			else
				dealinfo = dealinfo + "告警原因:" + isworkcase;
		}

		if (dealinfo != null && !"".equals(dealinfo))
			dealinfo = "[" + dealinfo + "]";

		Map mDealInfo = new HashMap();
		mDealInfo.put("dealinfo", dealinfo);
		mDealInfo.put("ackperson", ackPerson);
		mDealInfo.put("alarmnumber", alarmnumber);
		try {
			this.sqlMapClientTemplate
					.insert("writeRealRootAlarmLog", mDealInfo); // .update("ackingRootAlarm",
			// mParmed);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// return null;
	}

	public String ackTime(String alarmnumber) {

		String ack = "";
		Map map = new HashMap();
		map.put("alarmnumber", alarmnumber);
		try {
			ack = this.getSqlMapClientTemplate().queryForObject("ackTimeIs",
					map).toString();
			// ack=this.getSqlMapClientTemplate().queryForObject("ackTimeIs").toString();
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ack;
	}

	public String getequipname(String equipcode) {
		return (String) this.getSqlMapClientTemplate().queryForObject(
				"getequipnameRealRootAlarm", equipcode);
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

	public String getAlarmExperiecnceVendor() {

		String xml = "";
		List<HashMap> items = this.getSqlMapClientTemplate().queryForList(
				"alarmEXPVendor");

		if (items.size() > 0) {

			HashMap map = new HashMap();

			Set t = items.get(0).keySet();

			for (int i = 0; i < items.size(); i++) {
				map = items.get(i);

				Iterator ir = t.iterator();

				xml += "<system>";

				while (ir.hasNext()) {
					String key = ir.next().toString();

					xml += "<" + key + ">" + map.get(key) + "</" + key + ">";
				}
				xml += "</system>";
			}

		}
		return xml;
	}

	public List getAlarmDealInfoByMessage(String vendor, String alarmdes,
			int start, int end) {
		// TODO Auto-generated method stub
		HashMap sqlPara = new HashMap();
		sqlPara.put("vendorcode", vendor);
		sqlPara.put("aldesc", alarmdes);
		sqlPara.put("start", start);
		sqlPara.put("end", end);

		try {
			return this.getSqlMapClientTemplate().queryForList("getAlarmsEXP",
					sqlPara);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
		return null;
	}

	public int getAlarmExperienceCount(String vendor, String alarmdes) {
		// TODO Auto-generated method stub
		HashMap sqlPara = new HashMap();
		sqlPara.put("vendorcode", vendor);
		sqlPara.put("aldesc", alarmdes);
		try {
			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getAlarmEXPCount", sqlPara);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return 0;
	}

	public List getAlarmCause() {

		try {
			return this.getSqlMapClientTemplate().queryForList("getAlarmCause");
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

	public List getDealResult(String dealwith) {

		Map m = new HashMap();
		m.put("dealwith", dealwith);

		try {
			return this.getSqlMapClientTemplate().queryForList("getDealResult",
					m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

	public List getCompanyAlarm(String alarmNum, String start, String end) {

		Map m = new HashMap();
		m.put("alarmNum", alarmNum);
		m.put("start", start);
		m.put("end", end);

		try {
			return this.getSqlMapClientTemplate().queryForList(
					"getCompanyAlarm", m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

	public int getCompanyAlarmCount(String alarmNum, String start, String end) {
		// TODO Auto-generated method stub
		HashMap m = new HashMap();
		m.put("alarmNum", alarmNum);
		try {
			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getCompanyAlarmCount", m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return 0;
	}

	public List getCurrentRootAlarm(String alarmno, String start, String end) {

		HashMap m = new HashMap();
		m.put("alarmno", alarmno);
		m.put("start", start);
		m.put("end", end);
		try {
			return this.getSqlMapClientTemplate().queryForList(
					"getCurrentRootAlarm", m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;

	}

	public String changeToRepairAlarm(String operPerson, String alarmnm,
			String dealresult, String isworkcase) {

		String result = "";
		HashMap m = new HashMap();
		m.put("operPerson", operPerson);
		m.put("alarmnumber", alarmnm);
		m.put("dealresult", dealresult);
		m.put("isworkcase", isworkcase);

		int a = this.sqlMapClientTemplate.update(
				"changeCurrentRealRootAlarmToRepairAlarm", m);

		if (a > 0) {
			result = "成功";

		} else {
			result = "失败";
		}
		return result;

	}

	public List getRepairs(String start, String end) {

		HashMap m = new HashMap();
		m.put("start", start);
		m.put("end", end);

		try {
			return this.getSqlMapClientTemplate().queryForList("getRepairs", m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;

	}

	public int getRepairsCount() {

		try {
			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getRepairsCount");
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return 0;

	}

	public int getCurrentRootAlarmCount(String alarmno) {
		HashMap m = new HashMap();
		m.put("alarmno", alarmno);
		try {
			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getCurrentRootAlarmCount", m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return 0;
	}

	public List getRootAlarmMgrInfo(String alarmnum, String alarmdesc,
			String alarmobjdesc, String belongtransys, String belongequip,
			String belongpackobject, String belongportobject,
			String belongportcode, String start, String end) {

		HashMap m = new HashMap();
		m.put("alarmnum", alarmnum);
		m.put("alarmdesc", alarmdesc);
		m.put("alarmobjdesc", alarmobjdesc);
		m.put("belongtransys", belongtransys);
		m.put("belongequip", belongequip);
		m.put("belongpackobject", belongpackobject);
		m.put("belongportobject", belongportobject);
		m.put("belongportcode", belongportcode);
		m.put("start", start);
		m.put("end", end);

		List list = new ArrayList();
		if (alarmnum != null && alarmnum != "") {
			list = this.getSqlMapClientTemplate().queryForList("getsHisAlarm",
					m);

			m.put("probablecause", ((Map) list.get(0)).get("PROBABLECAUSE"));
			m.put("objectcode", ((Map) list.get(0)).get("OBJECTCODE"));
		} else {

			m.put("probablecause", "");
			m.put("objectcode", "");
		}

		try {
			return this.getSqlMapClientTemplate().queryForList(
					"getsHisRootAlarm", m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

	public int getRootAlarmMgrInfoCount(String alarmnum, String alarmdesc,
			String alarmobjdesc, String belongtransys, String belongequip,
			String belongpackobject, String belongportobject,
			String belongportcode) {

		HashMap m = new HashMap();
		m.put("alarmnum", alarmnum);
		m.put("alarmdesc", alarmdesc);
		m.put("alarmobjdesc", alarmobjdesc);
		m.put("belongtransys", belongtransys);
		m.put("belongequip", belongequip);
		m.put("belongpackobject", belongpackobject);
		m.put("belongportobject", belongportobject);
		m.put("belongportcode", belongportcode);

		List list = new ArrayList();
		if (alarmnum != null && alarmnum != "") {
			list = this.getSqlMapClientTemplate().queryForList("getsHisAlarm",
					m);

			m.put("probablecause", ((Map) list.get(0)).get("PROBABLECAUSE"));
			m.put("objectcode", ((Map) list.get(0)).get("OBJECTCODE"));
		} else {

			m.put("probablecause", "");
			m.put("objectcode", "");
		}

		try {
			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getsHisRootAlarmCount", m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return 0;
	}

	public String changToNorAlarm(String alarmid) {

		String result = "";

		int a = this.sqlMapClientTemplate.update(
				"changeCurrentRealRootAlarmToCommonAlarm", alarmid);
		if (a > 0) {
			try {
				this.sqlMapClientTemplate.delete(
						"deleteCurrentRealRootAlarmToCommonAlarm", alarmid);
				result = "成功";
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else {
			result = "失败";
		}
		return result;
	}

	public String changeToCompanyAlarm(String alarmid, String alarmnumber,
			String operPerson) {
		String result = "失败";
		Map m = new HashMap();
		m.put("alm_company", alarmid);
		m.put("alm_number", alarmnumber);
		m.put("operPerson", operPerson);
		int a = (Integer) this.getSqlMapClientTemplate().queryForObject(
				"selectAlarm_affection", m);
		if (a > 0) {
			result = "已转";
		} else {
			try {
				this.sqlMapClientTemplate.insert("insertAlarm_affection", m);
				result = "成功";
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;

	}

	public List getAffectCircuit(PoUpKeyBussinessModel pukb) {

		try {
			PoUpKeyBussinessModel puk = new PoUpKeyBussinessModel();
			puk.setAlarmnumber(pukb.getAlarmnumber());
			puk.setCircuitcode(pukb.getCircuitcode());
			puk.setCircuittype(pukb.getCircuittype());
			puk.setEnd(pukb.getEnd());
			puk.setPortserialno1(pukb.getPortserialno1());
			puk.setPortserialno2(pukb.getPortserialno2());
			puk.setRate(pukb.getRate());
			puk.setStart(pukb.getStart());
			puk.setUsername(pukb.getUsername());
			puk.setUsetime(pukb.getUsetime());

			return this.getSqlMapClientTemplate().queryForList(
					"getAffectCircuit", puk);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	};

	public int getAffectCircuitCount(PoUpKeyBussinessModel pukb) {

		try {
			PoUpKeyBussinessModel puk = new PoUpKeyBussinessModel();
			puk.setAlarmnumber(pukb.getAlarmnumber());
			puk.setCircuitcode(pukb.getCircuitcode());
			puk.setCircuittype(pukb.getCircuittype());
			puk.setEnd(pukb.getEnd());
			puk.setPortserialno1(pukb.getPortserialno1());
			puk.setPortserialno2(pukb.getPortserialno2());
			puk.setRate(pukb.getRate());
			puk.setStart(pukb.getStart());
			puk.setUsername(pukb.getUsername());
			puk.setUsetime(pukb.getUsetime());
			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getAffectCircuitCount", puk);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return 0;
	}

	public String getAlarmEXP(String alarmnumber) {

		String result = "";
		Map m = new HashMap();
		m.put("alarmnumber", alarmnumber);
		try {
			List list = this.getSqlMapClientTemplate().queryForList(
					"getAlarmEXPs", m);

			if (list.size() > 0) {
				result = ((Map) list.get(0)).get("EXPERIENCE").toString();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	public String getSoundStatus() {

		try {

			return this.getSqlMapClientTemplate().queryForObject(
					"getSoundStatus").toString();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public String setFaultProcess(String alarmNo, String userID,
			String operPerson) {

		String result = "";
		HashMap m = new HashMap();
		m.put("alarmNo", alarmNo);
		m.put("userID", userID);
		m.put("operPerson", operPerson);

		try {

			this.sqlMapClientTemplate.update("setFaultProcess", m);

		} catch (Exception e) {
			e.printStackTrace();
		}

		int a = (Integer) this.sqlMapClientTemplate.queryForObject(
				"selectFaultProcess", m);
		if (a > 0) {
			result = "成功";
		} else {
			result = "失败";
		}
		return result;
	}

	public List getFaults(String alarmnm, String time, String alarmtime,
			String start, String end) {

		HashMap m = new HashMap();
		m.put("start", start);
		m.put("end", end);
		m.put("alarmnm", alarmnm);
		m.put("alarmtime", alarmtime);
		m.put("time", time);

		try {
			return this.getSqlMapClientTemplate().queryForList("getFaults_hz",
					m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;

	}

	public int getFaultsCount(String alarmnm, String time, String alarmtime) {
		HashMap m = new HashMap();
		m.put("alarmnm", alarmnm);
		m.put("alarmtime", alarmtime);
		m.put("time", time);

		try {
			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getFaultsCount_hz", m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return 0;

	}

	public String setOldFaultProcess(String bugno, String dutyid,
			String operPerson, String alarmnm, String dealresult,
			String isworkcase) {

		String result = "";
		HashMap m = new HashMap();
		m.put("bugno", bugno);
		m.put("dutyid", dutyid);
		m.put("operPerson", operPerson);
		m.put("alarmnm", alarmnm);
		m.put("dealresult", dealresult);
		m.put("isworkcase", isworkcase);
		int a = this.sqlMapClientTemplate.update("setOldFaultProcess", m);

		if (a > 0) {
			result = "成功";

		} else {
			result = "失败";
		}
		return result;

	}

	public String ackRootAlarms(ArrayList<AckRootAlarmModel> ackRootAlarms) {
		String result = "";
		String ackperson = (String) this.sqlMapClientTemplate
				.queryForObject("ackPersonRootAlarm");
		AlarmAffirmModel aa = new AlarmAffirmModel();//插入告警确认log的model 
		for (int i = 0; i < ackRootAlarms.size(); i++) {
			AckRootAlarmModel ackrootalarm = ackRootAlarms.get(i);
			String alarmid = ackrootalarm.getAlarmnumber();
			HashMap m = new HashMap();
			m.put("alarmid", ackrootalarm.getAlarmnumber());
			m.put("ackperson", ackperson);
			aa.setAlarmnumber(ackrootalarm.getAlarmnumber());
			aa.setAckperson(ackperson);
			aa.setAckcontent(ackrootalarm.getAckcontent());
			aa.setDealresult(ackrootalarm.getDealresult());
			aa.setIsworkcase(ackrootalarm.getIsworkcase());
			aa.setIsackedzh(ackrootalarm.getIsackedzh());
			if(aa.getTriggeredhour()==null){
				aa.setTriggeredhour("0");
			}
			if(aa.getIsfilter()==null){
				aa.setIsfilter("0");
			}
			aa.setWhichsys("BS");
			aa.setAlarmtype(ackrootalarm.getAlarmtype());
			this.sqlMapClientTemplate.insert("insertAlarm_acklog", aa);//在alarm_acklog表中插入数据
			int a=0;
			try {
				if(aa.getAlarmtype().equalsIgnoreCase("0")) {//传输网告警
					if(aa.getIsackedzh().equals("未确认")){
						 a = this.sqlMapClientTemplate.update("ackRootAlarmNew_", aa);
					}else{//确认过的不更新确认人和确认时间
						a = this.sqlMapClientTemplate.update("ackRootAlarmNew_acked", aa);
					}
				}
			}catch (DataAccessException e) {
				e.printStackTrace();
			}
			if (a > 0) {
				result = "成功";
			} else {
				result = "失败";
			}
		}

//		}
		return result;
	}

	public String ackRootAlarmNew(String alarmnumber, String ackPerson,
			String dealresult, String isworkcase, String ackcontent,
			String alarmtype) {
		String ackperson = (String) this.sqlMapClientTemplate
				.queryForObject("ackPersonRootAlarm");
		String alarmid = alarmnumber;
		String result = "";
		HashMap m = new HashMap();
		m.put("alarmid", alarmnumber);
		m.put("ackperson", ackperson);
		m.put("isworkcase", dealresult);
		m.put("dealresult", isworkcase);
		m.put("ackcontent", ackcontent);
		AlarmAffirmModel aam = new AlarmAffirmModel();
		aam.setAlarmnumber(alarmnumber);
		aam.setAckperson(ackperson);
		aam.setAckcontent(ackcontent);
		aam.setDealresult(dealresult);
		aam.setIsworkcase(isworkcase);
		aam.setWhichsys("BS");
		if (alarmtype.equalsIgnoreCase("0")) {//传输网告警
			int a = this.sqlMapClientTemplate.update("ackRootAlarmNew", m);
			if (a > 0) {
				try {
//					this.sqlMapClientTemplate.delete(
//							"deleteCurrentRealRootAlarmToCommonAlarm", alarmid);
					this.sqlMapClientTemplate.insert("insertAlarm_acklog", aam);//在alarm_acklog表中插入数据
					result = "成功";
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				result = "失败";
			}
		} else {
			int a = this.sqlMapClientTemplate.update("transAckRootAlarmNew", m);
			if (a > 0) {
				result = "成功";
			} else {
				result = "失败";
			}
		}

		return result;
	}

	@Override
	public List getRootAlarm(String isacked, String dealresult) {
		HashMap m = new HashMap();
		m.put("dealresult", dealresult);
		m.put("isacked", isacked);
		try {
			return this.getSqlMapClientTemplate().queryForList(
					"selectRootAlarm", m);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

	@Override
	public int getRootAlarmCount() {
		try {
			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getRootAlarmCount");
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}
	
	public String getUserName(){
		try {
			return  (String)this.getSqlMapClientTemplate().queryForObject(
					"ackPersonRootAlarm");
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public String getCurrentUserCh() {
		return (String) this.getSqlMapClientTemplate().queryForObject("getCurrentUserCh");
	}

	@Override
	public String ackRootAlarmNew_(AlarmAffirmModel aam) {
		String alarmid = aam.getAlarmnumber();
		String alarmtype = aam.getAlarmtype();
		String result = "";
		int a=0;
		if (alarmtype.equalsIgnoreCase("0")) {//传输网告警
			if(aam.getIsackedzh().equals("未确认")){
				 a = this.sqlMapClientTemplate.update("ackRootAlarmNew_", aam);
			}else{//确认过的不更新确认人和确认时间
				a = this.sqlMapClientTemplate.update("ackRootAlarmNew_acked", aam);
			}
			if (a > 0) {
				try {
//					this.sqlMapClientTemplate.delete(
//							"deleteCurrentRealRootAlarmToCommonAlarm", alarmid);
					result = "成功";
					this.sqlMapClientTemplate.insert("insertAlarm_acklog", aam);//在alarm_acklog表中插入数据
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				result = "失败";
			}
		} else {
//			int a = this.sqlMapClientTemplate.update("transAckRootAlarmNew", m);
//			if (a > 0) {
//				result = "成功";
//			} else {
//				result = "失败";
//			}
		}
		return result;
	}

	@Override
	public List<AlarmAffirmModel> getAckLog(String alarmnumber) {
		
		return this.sqlMapClientTemplate.queryForList("getAckLogbyAlarmNo", alarmnumber);
	}

	@Override
	public ChangeZDResultModel setRootAlarms(ArrayList<AlarmAffirmModel> ackRootAlarms) {
		ChangeZDResultModel re = new ChangeZDResultModel();
		String result = "";
		String result_ = "";
		ArrayCollection alarms = new ArrayCollection();
		String ackperson = (String) this.sqlMapClientTemplate
				.queryForObject("ackPersonRootAlarm");
		int sucess=0;
		int fault = 0;
		int sum = ackRootAlarms.size();
		re.setSum(sum);
		for (int i = 0; i < ackRootAlarms.size(); i++) {
			AlarmAffirmModel ackrootalarm = ackRootAlarms.get(i);
			String alarmnumber = ackrootalarm.getAlarmnumber();
			ackrootalarm.setAckperson(ackperson);
			int in = (Integer)this.sqlMapClientTemplate.queryForObject("selectZhongdiaoByAlarmnumber", alarmnumber);
			if(in==0){
				int a = 0;
				if(ackrootalarm.getAlarmtype().equalsIgnoreCase("0")) {//传输网告警
					if(ackrootalarm.getIsackedzh().equals("未确认")){
						 a = this.sqlMapClientTemplate.update("setRootAlarms", ackrootalarm);
					}else{//确认过的不更新确认人和确认时间
						a = this.sqlMapClientTemplate.update("setRootAlarms_acked", ackrootalarm);
					}
				}
				try {
					this.sqlMapClientTemplate.insert("insertAlarm_acklog", ackrootalarm);
				} catch (DataAccessException e) {
					e.printStackTrace();
				}
				if (a > 0) {
					sucess++;
					alarms.add(alarmnumber);
					result = "成功";
				} else {
					result = "失败";
				}
				}else{
					fault++;	
					
//					return "不允许";
				}
			}
		if(sucess==0){
			result = "失败";
		}
		re.setSucess(sucess);
		re.setFault(fault);
		re.setAc(alarms);
		re.setResult(result);
//		result_= result+"-"+sucess+"-"+fault+"-"+sum;
		return  re;

	}

	public void insertAckLog(AlarmAffirmModel aam){
		this.sqlMapClientTemplate.insert("insertAlarm_acklog", aam);//在alarm_acklog表中插入数据
	}
	public String confimAlarm(AlarmAffirmModel ackrootalarm){
		String result="";
		int a=0;
		if (ackrootalarm.getAlarmtype().equalsIgnoreCase("0")) {//传输网告警
			if(ackrootalarm.getIsackedzh().equals("未确认")){
				 a = this.sqlMapClientTemplate.update("ackRootAlarmNew_", ackrootalarm);
			}else{//确认过的不更新确认人和确认时间
				a = this.sqlMapClientTemplate.update("ackRootAlarmNew_acked", ackrootalarm);
			}
			if (a > 0) {
				try {
					result = "成功";
					this.sqlMapClientTemplate.insert("insertAlarm_acklog", ackrootalarm);//在alarm_acklog表中插入数据
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				result = "失败";
			}
		}
		return result;
	}
}
