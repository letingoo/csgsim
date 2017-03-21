package com.metarnet.mnt.rootalarm.dwr;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import sysManager.user.model.UserModel;

import com.metarnet.mnt.rootalarm.dao.RealRootAlarmDAO;
import com.metarnet.mnt.rootalarm.model.AckRootAlarmModel;
import com.metarnet.mnt.rootalarm.model.AlarmAffirmModel;
import com.metarnet.mnt.rootalarm.model.ChangeZDResultModel;
import com.metarnet.mnt.rootalarm.model.PoUpKeyBussinessModel;
import com.metarnet.mnt.rootalarm.model.PoUpKeyBussinessModelResult;
import com.metarnet.mnt.rootalarm.model.RealRootAlarmModel;

import db.BaseDAO;
import flex.messaging.FlexContext;

public class RealRootAlarmDwr {
	private RealRootAlarmDAO realRootAlarmDao;

	public RealRootAlarmDAO getRealRootAlarmDao() {
		return realRootAlarmDao;
	}

	public void setRealRootAlarmDao(RealRootAlarmDAO realRootAlarmDao) {
		this.realRootAlarmDao = realRootAlarmDao;
	}

	public RealRootAlarmDAO getRootdealalarmdao() {
		return realRootAlarmDao;
	}

	public void setRootdealalarmdao(RealRootAlarmDAO realRootAlarmDao) {
		this.realRootAlarmDao = realRootAlarmDao;
	}

	public void ackRootAlarm(String alarmnumber, String dealresult,
			String isworkcase, String ackcontent, String ackPerson) {
		realRootAlarmDao.ackRootAlarm(alarmnumber, dealresult, isworkcase,
				ackcontent, ackPerson);
	}

	public String getequipname(String equipcode) {
		return realRootAlarmDao.getequipname(equipcode);
	}

	public String getusername() {
		return this.realRootAlarmDao.getusername();
	}

	public String getAlarmExperiecnceVendor() {
		return this.realRootAlarmDao.getAlarmExperiecnceVendor();
	}

	public RealRootAlarmModel getAlarmDealInfoByMessage(String vendor,
			String alarmdes, int start, int end) {
		RealRootAlarmModel rm = new RealRootAlarmModel();
		rm.setListEXP(this.realRootAlarmDao.getAlarmDealInfoByMessage(vendor,
				alarmdes, start, end));
		rm.setCountEXP(this.realRootAlarmDao.getAlarmExperienceCount(vendor,
				alarmdes));
		return rm;
	}

	public List getCauseData() {
		return this.realRootAlarmDao.getAlarmCause();
	}

	public List getDealWithData(String dealwith) {
		return this.realRootAlarmDao.getDealResult(dealwith);

	}

	public RealRootAlarmModel getCompanyAlarm(String alarmNum, String start,
			String end) {
		RealRootAlarmModel rm = new RealRootAlarmModel();
		rm.setListFollow(this.realRootAlarmDao.getCompanyAlarm(alarmNum, start,
				end));
		rm.setCountFollow(this.realRootAlarmDao.getCompanyAlarmCount(alarmNum,
				start, end));
		return rm;
	}

	public RealRootAlarmModel getAlarms(String alarmno, String start, String end) {
		RealRootAlarmModel rm = new RealRootAlarmModel();

		rm.setListCompany(this.realRootAlarmDao.getCurrentRootAlarm(alarmno,
				start, end));
		rm.setCountCompany(this.realRootAlarmDao
				.getCurrentRootAlarmCount(alarmno));

		return rm;
	}

	public RealRootAlarmModel getRootAlarmMgrInfo(String alarmnum,
			String alarmdesc, String alarmobjdesc, String belongtransys,
			String belongequip, String belongpackobject,
			String belongportobject, String belongportcode, String start,
			String end) {

		RealRootAlarmModel rm = new RealRootAlarmModel();
		rm
				.setListHisRoot(this.realRootAlarmDao.getRootAlarmMgrInfo(
						alarmnum, alarmdesc, alarmobjdesc, belongtransys,
						belongequip, belongpackobject, belongportobject,
						belongportcode, start, end));
		rm.setCountHisRoot(this.realRootAlarmDao.getRootAlarmMgrInfoCount(
				alarmnum, alarmdesc, alarmobjdesc, belongtransys, belongequip,
				belongpackobject, belongportobject, belongportcode));

		return rm;
	}

	public String changToNorAlarm(String alarmNo) {
		return this.realRootAlarmDao.changToNorAlarm(alarmNo);
	}
	//查看告警影响电路
	public PoUpKeyBussinessModelResult getAffectCircuit(
			PoUpKeyBussinessModel poupkeybussiness) {
		PoUpKeyBussinessModelResult pukb = new PoUpKeyBussinessModelResult();
		pukb.setList(this.realRootAlarmDao.getAffectCircuit(poupkeybussiness));
		pukb.setCount(this.realRootAlarmDao
				.getAffectCircuitCount(poupkeybussiness));
		return pukb;
	}

	public String ackTime(String alarmNo) {

		return this.realRootAlarmDao.ackTime(alarmNo);
	}

	public String getAlarmEXP(String alarmnumber) {
		return this.realRootAlarmDao.getAlarmEXP(alarmnumber);
	}

	public String changeToCompanyAlarm(String alarmid, String alarmnumber,
			String operPerson) {
		return this.realRootAlarmDao.changeToCompanyAlarm(alarmid, alarmnumber,
				operPerson);

	}

	public String changeToRepairAlarm(String operPerson, String alarmnm,
			String dealresult, String isworkcase) {
		return this.realRootAlarmDao.changeToRepairAlarm(operPerson, alarmnm,
				dealresult, isworkcase);
	}

	public RealRootAlarmModel getRepairs(String start, String end) {

		RealRootAlarmModel rm = new RealRootAlarmModel();
		rm.setListRepair(this.realRootAlarmDao.getRepairs(start, end));
		rm.setCountRepair(this.realRootAlarmDao.getRepairsCount());
		return rm;
	}

	public String getSoundStatus() {

		return this.realRootAlarmDao.getSoundStatus();
	}

	public String setFaultProcess(String alarmNo, String userID,
			String operPerson) {
		return this.realRootAlarmDao.setFaultProcess(alarmNo, userID,
				operPerson);
	}

	public RealRootAlarmModel getFaults(String alarmnm, String time,
			String alarmtime, String start, String end) {

		RealRootAlarmModel rm = new RealRootAlarmModel();
		rm.setListFault(this.realRootAlarmDao.getFaults(alarmnm, time,
				alarmtime, start, end));
		rm.setCountFault(this.realRootAlarmDao.getFaultsCount(alarmnm, time,
				alarmtime));
		return rm;
	}

	public String changeToOldFaultProcess(String bugno, String dutyid,
			String operPerson, String alarmnm, String dealresult,
			String isworkcase) {
		return this.realRootAlarmDao.setOldFaultProcess(bugno, dutyid,
				operPerson, alarmnm, dealresult, isworkcase);
	}

	public String ackRootAlarms(ArrayList<AckRootAlarmModel> ackRootAlarms) {
//		ArrayList<AckRootAlarmModel> aa = new ArrayList<AckRootAlarmModel>();
//			for(int i=0;i<ackRootAlarms.size();i++){
//				AckRootAlarmModel ack = ackRootAlarms.get(i);
//				if(ack.getBugno()==null||ack.getBugno()==""){
//					aa.add(ack);
//				}
//			}
//			this.toFaultHandler(aa);
		return realRootAlarmDao.ackRootAlarms(ackRootAlarms);
	}

	public ChangeZDResultModel setRootAlarms(ArrayList<AlarmAffirmModel> ackRootAlarms) {
		// TODO Auto-generated method stub
		return realRootAlarmDao.setRootAlarms(ackRootAlarms);
	}	
	
	public String ackRootAlarmNew(String alarmnumber, String ackPerson,
			String dealresult, String isworkcase, String ackcontent,
			String alarmtype) {
//		String re="";
//			if(dealresult=="转故障流程处理"){
//				ArrayList<AckRootAlarmModel> ac= new ArrayList<AckRootAlarmModel>();
//				AckRootAlarmModel alarm  = new AckRootAlarmModel();
//				alarm.setAlarmnumber(alarmnumber);
//				ac.add(alarm);
//				re=this.toFaultHandler(ac);
//			}
		return realRootAlarmDao.ackRootAlarmNew(alarmnumber, ackPerson,
				dealresult, isworkcase, ackcontent, alarmtype);
	}
	public String ackRootAlarmNew_(AlarmAffirmModel aam){
		return realRootAlarmDao.ackRootAlarmNew_(aam);
	}

	public List getRootAlarm(String isacked, String dealresult) {
		return realRootAlarmDao.getRootAlarm(isacked, dealresult);
	}

	public int getRootAlarmCount() {
		return realRootAlarmDao.getRootAlarmCount();
	}

	public String getUserName(){
		return realRootAlarmDao.getUserName();
	}

/**
 * 转流程处理过程
 *@author jtsun
 * @param alarms
 * @return
 */
	public String toFaultHandler(ArrayList<AckRootAlarmModel> alarms ,String str){
		String resultString="";
		AckRootAlarmModel ackmodel = alarms.get(0);
		BaseDAO  dao = new BaseDAO();
		Connection c = null;
		Statement s = null;
		ResultSet rs = null;
		try {
			HttpServletRequest request = FlexContext.getHttpRequest();
			HttpSession session = request.getSession();
			String currentUser = "";//当前登录系统用户名
			String currentUserCh="";//当前用户真实姓名
			
			if (session.getAttribute("userid") != null) {
				UserModel user = (UserModel) session
						.getAttribute((String) session.getAttribute("userid"));
				if (user != null) {
					currentUser = user.getUser_id();
					currentUserCh = user.getUser_name();
//					ip = user.getIp();
				}
			}
			if(currentUser=="zby"){
				currentUserCh = this.realRootAlarmDao.getCurrentUserCh();
			}
			
			String sql ="call CSG_START_FAULTFLOW( "+ackmodel.getAlarmnumber()+" , "+currentUser+", "+currentUserCh+")";
			c = dao.getConnection();
			s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			s.executeUpdate(sql);
			String nFormID="";
			String nBugno ="";
			String sql1 = "select dutyid,bugno from alarminfo where alarmnumber='" +ackmodel.getAlarmnumber()+"'";
			rs = s.executeQuery(sql1);
			while (rs.next()) {
				nFormID = rs.getString("DUTYID")==null ? "" : rs.getString("DUTYID");
				nBugno = rs.getString("BUGNO")==null ? "" : rs.getString("BUGNO");
			}
			String sql3="";
			String sql4="";
			AlarmAffirmModel aam = new AlarmAffirmModel();
			for(int i=0;i<alarms.size();i++){
				sql3 = "update alarminfo t set t.dutyid= '"+nFormID+"' ,t.bugno='"+nBugno+"' where t.alarmnumber= '"+(alarms.get(i)).getAlarmnumber()+"'";
				s.executeUpdate(sql3);
				sql4 = "call Csg_Superaddition_Circuit('"+nFormID+"', '"+(alarms.get(i)).getAlarmnumber()+"')";
				s.executeUpdate(sql4);
				if(str.equalsIgnoreCase("1")){
					aam.setAlarmnumber((alarms.get(i)).getAlarmnumber());
					aam.setAckperson(currentUserCh);
					aam.setAckcontent((alarms.get(0)).getAckcontent());
					aam.setDealresult((alarms.get(0)).getDealresult());
					aam.setIsworkcase((alarms.get(0)).getIsworkcase());
					aam.setWhichsys("BS");
					realRootAlarmDao.confimAlarm(aam);
			}
			}
			String sql5="call csg_fault_calc_bus('"+nFormID+"')";
			
			s.executeUpdate(sql5);
			resultString="ok";
			
		} catch (Exception e) {
			e.printStackTrace();
			resultString="fault";
		}finally{
			dao.closeConnection(c, s, rs);
		}
		return resultString;
	}
	
		public void WriteLog(String str) {
			String s = new String();
			String s1 = new String();
			try {
				 HttpServletRequest request = FlexContext.getHttpRequest();
				 HttpSession session = request.getSession();
				String currentUser = "";// 当前登录系统用户名
				String currentUserCh = "bbb";// 当前用户真实姓名
				 if (session.getAttribute("userid") != null) {
				 UserModel user = (UserModel) session
				 .getAttribute((String) session.getAttribute("userid"));
				 if (user != null) {
				 currentUser = user.getUser_id();
				 currentUserCh = user.getUser_name();
				 }
				 }
				Date d = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				String dfString = sdf.format(d);

				BaseDAO baseDAO = new BaseDAO();
				String logString = baseDAO.getLog();
				File file = new File(logString);
				if (file.exists()) {
					System.out.println("文件存在");
				} else {
					System.out.println("文件不存在，正在创建……");
					file.createNewFile();
				}

				BufferedReader input = new BufferedReader(new FileReader(file));

				while ((s = input.readLine()) != null) {
					s1 += s + "\n";
				}
				System.out.println(s1);
				input.close();
				s1 += "推送时间：" + dfString + "  推送给ID为" + currentUser + ",名称为"
						+ currentUserCh + ",推送告警数量为" + str+"条\n";
				BufferedWriter output = new BufferedWriter(new FileWriter(file));
				output.write(s1);
				output.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		/**
		 * 获得确认告警的日志
		 *@2013-3-7
		 *@author jtsun
		 * @param alarmnumber
		 * @return
		 */
		public List<AlarmAffirmModel> getAckLog(String alarmnumber){
			
			return this.realRootAlarmDao.getAckLog(alarmnumber);
		}
		
		
		/**
		 * 转至已有故障
		 *@author hjl
		 * @param alarms
		 * @return
		 */
			public String toExistFaultHandler(ArrayList<AckRootAlarmModel> alarms,String dutyid){
				String resultString="";
				AckRootAlarmModel ackmodel = alarms.get(0);
				BaseDAO  dao = new BaseDAO();
				Connection c = null;
				Statement s = null;
				ResultSet rs = null;
				try {
					HttpServletRequest request = FlexContext.getHttpRequest();
					HttpSession session = request.getSession();
					String currentUser = "";//当前登录系统用户名
					String currentUserCh="";//当前用户真实姓名
					
					if (session.getAttribute("userid") != null) {
						UserModel user = (UserModel) session
								.getAttribute((String) session.getAttribute("userid"));
						if (user != null) {
							currentUser = user.getUser_id();
							currentUserCh = user.getUser_name();
						}
					}
					if(currentUser=="zby"){
						currentUserCh = this.realRootAlarmDao.getCurrentUserCh();
					}
					
					String nFormID=dutyid;
					String sql1="";
					String sql2="";
					String sql3="";
					c = dao.getConnection();
					s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
					AlarmAffirmModel aam = new AlarmAffirmModel();
					for(int i=0;i<alarms.size();i++){
						sql1 = "update alarminfo a set a.acktime=decode(a.acktime,null,sysdate,a.acktime),a.ackperson='"+currentUserCh +"' where a.alarmnumber='"+alarms.get(i).getAlarmnumber()+ "' and a.acktime is null";
						s.executeUpdate(sql1);
						sql2 = "update alarminfo a set a.dutyid='" +nFormID+"',a.bugno='' where a.alarmnumber='"+alarms.get(i).getAlarmnumber()+"'";
						s.executeUpdate(sql2);
						sql3 = "call Csg_Superaddition_Circuit('"+nFormID+"', '"+(alarms.get(i)).getAlarmnumber()+"')";
						s.executeUpdate(sql3);
						
						aam.setAlarmnumber((alarms.get(i)).getAlarmnumber());
						aam.setAckperson(currentUser);
						aam.setAckcontent((alarms.get(0)).getAckcontent());
						aam.setDealresult((alarms.get(0)).getDealresult());
						aam.setIsworkcase((alarms.get(0)).getIsworkcase());
						aam.setWhichsys("BS");
						realRootAlarmDao.insertAckLog(aam);
					}
					String sql5="call csg_fault_calc_bus('"+nFormID+"')";
					
					s.executeUpdate(sql5);
					
					resultString="ok";
				} catch (Exception e) {
					e.printStackTrace();
					resultString="fault";
				}finally{
					dao.closeConnection(c, s, rs);
				}
				return resultString;
			}
}
