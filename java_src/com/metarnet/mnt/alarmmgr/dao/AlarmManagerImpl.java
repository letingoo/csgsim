package com.metarnet.mnt.alarmmgr.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.SqlMapClientTemplate;
import com.metarnet.mnt.alarmmgr.model.AlarmInfos;
import com.metarnet.mnt.alarmmgr.model.AlarmLevelCount;

public class AlarmManagerImpl implements AlarmManagerDAO {

	private SqlMapClientTemplate sqlMapClientTemplate;

	public SqlMapClientTemplate getSqlMapClientTemplate() {
		return sqlMapClientTemplate;
	}

	public void setSqlMapClientTemplate(
			SqlMapClientTemplate sqlMapClientTemplate) {
		this.sqlMapClientTemplate = sqlMapClientTemplate;
	}

	public List getTranssysName(String xtype) {
		// TODO Auto-generated method stub
		try {
			return this.getSqlMapClientTemplate().queryForList(
					"getTranssysName", xtype);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public String getTreeData(String sysname) {
		try {
			String xml = "";
			List<String> systems;
			HashMap sqlPara = new HashMap();

			sqlPara.put("sysname", sysname);

			if (!sysname.equals("")) {
				systems = sqlMapClientTemplate.queryForList("getTreeData",
						sqlPara);
				System.out.println();
			} else {
				systems = sqlMapClientTemplate.queryForList("getTree", sqlPara);
			}
			for (int i = 0; i < systems.size(); i++) {
				xml += " <node label=\"" + systems.get(i) + "\">";
				String syscode = systems.get(i);
				List<String> equips = sqlMapClientTemplate.queryForList(
						"getTreeEquipData", syscode);
				for (int j = 0; j < equips.size(); j++) {
					xml += "<node label=\"" + equips.get(j) + "\"></node>";

				}
				xml += "</node>";
			}
			return xml;
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;

	}

	public AlarmLevelCount getcount(String dealperson, String isAck,
			String alarmlevel, String alarmdesc, String alarmObj,
			String ackperson, String belongportcode, String belongportobject,
			String belongpackobject, String iscleared, String belongshelfcode,
			String belongequip, String vendor, String beginTime,
			String endTime, String isRootAlarm,String table,String belongtransys,String alarmman,String queryFlag,String query,String interposename) {
		//queryFlag 中增加了其他查询条件 割接告警查询中 为了最小修改代码(其他地方或用到此方法)   在queryFlag中新增其他属性， 在impl文件中进行拆分
		String alarmType="";
		if(queryFlag!=null&&queryFlag.indexOf(";")!=-1&&queryFlag.split(";").length>1){
			alarmType=queryFlag.split(";")[1];
			queryFlag=queryFlag.split(";")[0];
		}
		Map m = new HashMap();
		m.put("dealperson", dealperson);
		m.put("isAck", isAck);
		m.put("alarmlevel", alarmlevel);
		m.put("alarmdesc", alarmdesc);
		m.put("alarmObj", alarmObj);
		m.put("ackperson", ackperson);
		m.put("belongportcode", belongportcode);
		m.put("belongportobject", belongportobject);
		m.put("belongpackobject", belongpackobject);
		m.put("iscleared", iscleared);
		m.put("belongshelfcode", belongshelfcode);
		m.put("belongequip", belongequip);
		m.put("vendor", vendor);
		m.put("isRootAlarm", isRootAlarm);
		m.put("table",table);
		m.put("belongtransys",belongtransys);
		m.put("alarmman",alarmman);
		m.put("queryFlag",queryFlag);
		m.put("query", query);
		m.put("alarmType", alarmType);
		m.put("interposename", interposename);
		if (dealperson == "未知") {
			dealperson = "";
		}
		AlarmLevelCount lev = new AlarmLevelCount();
		try {
			if (dealperson == "" || dealperson == null) {
				m.put("beginTime", beginTime);
				m.put("endTime", endTime);
				List list = (List) this.sqlMapClientTemplate.queryForList(
						"getAlarmlevelcount", m);
				if (list != null && list.size() > 0) {
					for (Object obj : list) {
						String s = obj.toString();
						if (s != null && s.length() > 0) {
							String[] arrs = s.split("@");
							if (arrs.length == 2) {
								if (arrs[0].indexOf("critical") != -1) {
									lev.setCritical(Integer.parseInt(arrs[1]));
								}
								if (arrs[0].indexOf("major") != -1) {
									lev.setMajor(Integer.parseInt(arrs[1]));
								}
								if (arrs[0].indexOf("minor") != -1) {
									lev.setMinor(Integer.parseInt(arrs[1]));
								}
								if (arrs[0].indexOf("warning") != -1) {
									lev.setWarning(Integer.parseInt(arrs[1]));
								}
							}
						}
					}
				}
			} else {
				HashMap result = (HashMap) this.sqlMapClientTemplate
						.queryForObject("getProDate");
				if (result.get("CHANGEDATE").toString().equals("0")) {
					m.put("starttime", "sysdate-30");
					m.put("endtime", "sysdate");
				} else if (result.get("CHANGEDATE").toString().equals("1")) {
					m.put("starttime", "trunc(sysdate,'d')");
					m.put("endtime", "Next_day(trunc(sysdate,'d'),7)");
				} else if (result.get("CHANGEDATE").toString().equals("2")) {
					m.put("starttime", "trunc(sysdate, 'mm')");
					m.put("endtime", "last_day(sysdate)");
				} else {
					m.put("starttime", "'" + result.get("STARTTIME").toString()
							+ "'");
					m.put("endtime", "'" + result.get("ENDTIME").toString()
							+ "'");
				}
				List list = (List) this.sqlMapClientTemplate.queryForList(
						"getAlarmlevelcountflag", m);
				if (list != null && list.size() > 0) {
					for (Object obj : list) {
						String s = obj.toString();
						if (s != null && s.length() > 0) {
							String[] arrs = s.split("@");
							if (arrs.length == 2) {
								if (arrs[0].indexOf("critical") != -1) {
									lev.setCritical(Integer.parseInt(arrs[1]));
								}
								if (arrs[0].indexOf("major") != -1) {
									lev.setMajor(Integer.parseInt(arrs[1]));
								}
								if (arrs[0].indexOf("minor") != -1) {
									lev.setMinor(Integer.parseInt(arrs[1]));
								}
								if (arrs[0].indexOf("warning") != -1) {
									lev.setWarning(Integer.parseInt(arrs[1]));
								}
							}
						}
					}
				}
			}
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
		return lev;
	}

	public List getAlarms(AlarmInfos amf) {

		try {
			AlarmInfos ars = new AlarmInfos();
//			ars.setInterposename(amf.getInterposename());
			ars.setAlarmdesc(amf.getAlarmdesc());
			ars.setAlarmlevel(amf.getAlarmlevel());
			ars.setVendor(amf.getVendor());
			ars.setBelongtransys(amf.getBelongtransys());
			ars.setStart(amf.getStart());
			ars.setEnd(amf.getEnd());
			ars.setIsAck(amf.getIsAck());
//			ars.setIsRootAlarm(amf.getIsRootAlarm());
			ars.setBelongequip(amf.getBelongequip());//设备编码
			ars.setIscleared(amf.getIscleared());
			ars.setBelongpackobject(amf.getBelongpackobject());//机盘
			ars.setBelongportobject(amf.getBelongportobject());//端口
			ars.setBelongportcode(amf.getBelongportcode());//端口编码
			ars.setAlarmObj(amf.getAlarmObj());
			
			ars.setFlashcount(amf.getFlashcount());
//			ars.setDealperson(amf.getDealperson());
			ars.setBelongstation(amf.getBelongstation());
			ars.setArea(amf.getArea());
			ars.setConfirmTime(amf.getConfirmTime());
			ars.setAckperson(amf.getAckperson());
			ars.setIsworkcase(amf.getIsworkcase());
//			ars.setDealresult(amf.getDealresult());
			ars.setAlarmman(amf.getAlarmman());
			ars.setQueryFlag(amf.getQueryFlag());
			ars.setQuery(amf.getQuery());
			// 新加的
			ars.setBelongshelfcode(amf.getBelongshelfcode());//
			ars.setTablename(amf.getTablename());//add by sjt
			ars.setAlarmType(amf.getAlarmType());// 告警类型  分为 故障 ，割接，演习，接口
			if(amf.getFlag().equals("1")){//历史根告警查询
				ars.setBeginTime(amf.getStart_time());
				ars.setEndTime(amf.getEnd_time());
				return this.getSqlMapClientTemplate().queryForList(
						"getsAlarmManangerInfos", ars);
			}
			if(amf.getAlarmSearchFlag().equals("1")){//告警查询 查询条件检索
				ars.setBeginTime(amf.getStart_time());
				ars.setEndTime(amf.getEnd_time());
				return this.getSqlMapClientTemplate().queryForList(
						"getsAlarmManangerInfos", ars);
			}
			
//			if (amf.getDealperson().equals("") || amf.getDealperson() == null) {
//				ars.setBeginTime(amf.getStart_time());
//				ars.setEndTime(amf.getEnd_time());
//				return this.getSqlMapClientTemplate().queryForList(
//						"getsAlarmManangerInfos", ars);
//			} else {
//				HashMap result = (HashMap) this.sqlMapClientTemplate
//						.queryForObject("getProDate");
//				if (result.get("CHANGEDATE").toString().equals("0")) {
//					ars.setBeginTime("sysdate-30");
//					ars.setEndTime("sysdate");
//				} else if (result.get("CHANGEDATE").toString().equals("1")) {
//					ars.setBeginTime("trunc(sysdate,'d')");
//					ars.setEndTime("Next_day(trunc(sysdate,'d'),7)");
//				} else if (result.get("CHANGEDATE").toString().equals("2")) {
//					ars.setBeginTime("trunc(sysdate, 'mm')");
//					ars.setEndTime("last_day(sysdate)");
//				} else {
//					ars.setBeginTime(result.get("'" + "STARTTIME").toString()
//							+ "'");
//					ars
//							.setEndTime(result.get("'" + "ENDTIME").toString()
//									+ "'");
//				}
//				ars.setIsRootAlarm("1");
//				if (amf.getDealperson().equals("未知")) {
//					ars.setDealperson("");
//				} else {
//					ars.setDealperson(amf.getDealperson());
//				}
//				return this.getSqlMapClientTemplate().queryForList(
//						"getsAlarmManangerInfosflag", ars);
//			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public int getAlarmCount(AlarmInfos amf) {
		try {
			AlarmInfos ars = new AlarmInfos();
//			ars.setInterposename(amf.getInterposename());
			ars.setAlarmdesc(amf.getAlarmdesc());
			ars.setAlarmlevel(amf.getAlarmlevel());
			ars.setVendor(amf.getVendor());
			 ars.setBelongtransys(amf.getBelongtransys());
			ars.setStart(amf.getStart());
			ars.setIsAck(amf.getIsAck());
			ars.setIsRootAlarm(amf.getIsRootAlarm());
			ars.setEnd(amf.getEnd());
			ars.setBelongequip(amf.getBelongequip());
			ars.setIscleared(amf.getIscleared());
			ars.setBelongpackobject(amf.getBelongpackobject());
			ars.setBelongportobject(amf.getBelongportobject());
			ars.setBelongportcode(amf.getBelongportcode());
			ars.setAlarmObj(amf.getAlarmObj());
			ars.setBelongshelfcode(amf.getBelongshelfcode());
			ars.setTablename(amf.getTablename());
			
//			ars.setDealperson(amf.getDealperson());
			ars.setFlashcount(amf.getFlashcount());
			ars.setBelongstation(amf.getBelongstation());
			ars.setArea(amf.getArea());
			ars.setConfirmTime(amf.getConfirmTime());
			ars.setAckperson(amf.getAckperson());
			ars.setIsworkcase(amf.getIsworkcase());
//			ars.setDealresult(amf.getDealresult());
			// 新加的
			ars.setBelongshelfcode(amf.getBelongshelfcode());
			ars.setTablename(amf.getTablename());//add by sjt
			ars.setAlarmman(amf.getAlarmman());
			ars.setQueryFlag(amf.getQueryFlag());
			ars.setQuery(amf.getQuery());
			ars.setAlarmType(amf.getAlarmType());// 告警类型  分为 故障 ，割接，演习，接口 mawj
			if(amf.getFlag().equals("1")||amf.getAlarmSearchFlag().equals("1")){//历史根告警查询或者告警查询
				ars.setBeginTime(amf.getStart_time());
				ars.setEndTime(amf.getEnd_time());
				return (Integer) this.getSqlMapClientTemplate().queryForObject(
						"getsAlarmManangerCount", ars);
			}
//			if (amf.getDealperson().equals("") || amf.getDealperson() == null) {
//				ars.setBeginTime(amf.getBeginTime());
//				ars.setEndTime(amf.getEndTime());
//				return (Integer) this.getSqlMapClientTemplate().queryForObject(
//						"getsAlarmManangerCount", ars);
//			} else {
//				HashMap result = (HashMap) this.sqlMapClientTemplate
//						.queryForObject("getProDate");
//				if (result.get("CHANGEDATE").toString().equals("0")) {
//					ars.setBeginTime("sysdate-30");
//					ars.setEndTime("sysdate");
//				} else if (result.get("CHANGEDATE").toString().equals("1")) {
//					ars.setBeginTime("trunc(sysdate,'d')");
//					ars.setEndTime("Next_day(trunc(sysdate,'d'),7)");
//				} else if (result.get("CHANGEDATE").toString().equals("2")) {
//					ars.setBeginTime("trunc(sysdate, 'mm')");
//					ars.setEndTime("last_day(sysdate)");
//				} else {
//					ars.setBeginTime("'" + result.get("STARTTIME").toString()
//							+ "'");
//					ars
//							.setEndTime("'" + result.get("ENDTIME").toString()
//									+ "'");
//				}
//				ars.setIsRootAlarm("1");
//				if (amf.getDealperson().equals("未知")) {
//					ars.setDealperson("");
//				} else {
//					ars.setDealperson(amf.getDealperson());
//				}
//				return (Integer) this.getSqlMapClientTemplate().queryForObject(
//						"getsAlarmManangerCountflag", ars);
//			}
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
		return 0;
	}

	public List getKeyBusiness(String alarmnumber, String circuitcode,
			String isacked, String start, String end) {

		Map m = new HashMap();
		m.put("alarmnumber", alarmnumber);
		m.put("circuitcode", circuitcode);
		m.put("isacked", isacked);
		m.put("start", start);
		m.put("end", end);
		try {

			return this.getSqlMapClientTemplate().queryForList(
					"getKeyBusiness", m);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	};

	public int getKeyBusinessCount(String alarmnumber, String circuitcode,
			String isacked) {

		Map m = new HashMap();
		m.put("alarmnumber", alarmnumber);
		m.put("circuitcode", circuitcode);
		m.put("isacked", isacked);

		try {

			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getKeyBusinessCount", m);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return 0;
	}

	public List getKeyBusiness_hz(String circuitname, String station1,
			String station2, String powerline, String start, String end) {

		Map m = new HashMap();
		m.put("username", circuitname);
		m.put("station1", station1);
		m.put("station2", station2);
		m.put("powerline", powerline);
		m.put("start", start);
		m.put("end", end);
		try {

			return this.getSqlMapClientTemplate().queryForList(
					"getKeyBusiness_hz", m);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	};

	public int getKeyBusinessCount_hz(String circuitname, String station1,
			String station2, String powerline) {

		Map m = new HashMap();
		m.put("username", circuitname);
		m.put("station1", station1);
		m.put("station2", station2);
		m.put("powerline", powerline);

		try {

			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getKeyBusinessCount_hz", m);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return 0;
	}

	public List getKeyBusiness_hz_OperaType(String circuitname,
			String station1, String station2, String powerline, String start,
			String end) {

		Map m = new HashMap();
		m.put("operationtype", circuitname);
		m.put("station1", station1);
		m.put("station2", station2);
		m.put("powerline", powerline);
		m.put("start", start);
		m.put("end", end);
		try {

			return this.getSqlMapClientTemplate().queryForList(
					"getKeyBusiness_hz_operaType", m);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	};

	public int getKeyBusinessCount_hz_OperaType(String circuitname,
			String station1, String station2, String powerline) {

		Map m = new HashMap();
		m.put("operationtype", circuitname);
		m.put("station1", station1);
		m.put("station2", station2);
		m.put("powerline", powerline);

		try {

			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getKeyBusinessCount_hz_operaType", m);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return 0;
	}

	public String getCircuitCount(String alarmnu) {

		try {
			return (String) this.getSqlMapClientTemplate().queryForObject(
					"getCircuitCount", alarmnu);

		} catch (Exception e) {
			e.printStackTrace();
			return "0";
		}
	}

	public List getAlarmConfirm(String alarmid) {
		Map map = new HashMap();
		map.put("alarmid", alarmid);
		try {
			return this.sqlMapClientTemplate.queryForList("getAlarmConfirm",
					map);

		} catch (Exception e) {

			e.printStackTrace();
		}

		return null;
	}

	public String updateAlarmConfirm(String alarmid, String operPerson,
			String ackcontent) {

		String reuslt = "失败";
		Map m = new HashMap();
		m.put("alarmid", alarmid);
		m.put("operPerson", operPerson);
		m.put("ackcontent", ackcontent);

		int a = this.sqlMapClientTemplate.update("updateAlarmConfirm", m);
		if (a > 0) {
			reuslt = "成功";
		} else {
			reuslt = "失败";
		}
		return reuslt;

	}

	public List getExportKeyBusiness_hz(String circuitname, String station1,
			String station2, String powerline) {

		Map m = new HashMap();
		m.put("username", circuitname);
		m.put("station1", station1);
		m.put("station2", station2);
		m.put("powerline", powerline);
		try {

			return this.getSqlMapClientTemplate().queryForList(
					"getExportKeyBusiness_hz", m);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public int getKeyBusinessCount_hz1(String circuitname, String station1,
			String station2, String powerline) {

		Map m = new HashMap();
		m.put("username", circuitname);
		m.put("station1", station1);
		m.put("station2", station2);
		m.put("powerline", powerline);

		try {

			return (Integer) this.getSqlMapClientTemplate().queryForObject(
					"getKeyBusinessCount_hz1", m);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return 0;
	}

	public List getKeyBusiness_hz1(String circuitname, String station1,
			String station2, String powerline, String start, String end) {

		Map m = new HashMap();
		m.put("username", circuitname);
		m.put("station1", station1);
		m.put("station2", station2);
		m.put("powerline", powerline);
		m.put("start", start);
		m.put("end", end);
		try {

			return this.getSqlMapClientTemplate().queryForList(
					"getKeyBusiness_hz1", m);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	};
	public List getAlarmsDutyid(AlarmInfos amf){
		return this.getSqlMapClientTemplate().queryForList(
				"getAlarmsDutyid", amf);
	}

	public int getAlarmDutyidCount(AlarmInfos amf){
		return (Integer) this.getSqlMapClientTemplate().queryForObject(
				"getAlarmsDutyidCount", amf);
	}
	public AlarmLevelCount getcountBySearch(AlarmInfos info){
		AlarmLevelCount lev = new AlarmLevelCount();
		try {
			info.setBeginTime(info.getStart_time());
			info.setEndTime(info.getEnd_time());
			List list = (List) this.sqlMapClientTemplate.queryForList(
					"getcountBySearch", info);
			if (list != null && list.size() > 0) {
				for (Object obj : list) {
					String s = obj.toString();
					if (s != null && s.length() > 0) {
						String[] arrs = s.split("@");
						if (arrs.length == 2) {
							if (arrs[0].indexOf("critical") != -1) {
								lev.setCritical(Integer.parseInt(arrs[1]));
							}
							if (arrs[0].indexOf("major") != -1) {
								lev.setMajor(Integer.parseInt(arrs[1]));
							}
							if (arrs[0].indexOf("minor") != -1) {
								lev.setMinor(Integer.parseInt(arrs[1]));
							}
							if (arrs[0].indexOf("warning") != -1) {
								lev.setWarning(Integer.parseInt(arrs[1]));
							}
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lev;
		
	}
	public List queryVisiable(String tablename){
		return this.getSqlMapClientTemplate().queryForList(
				"queryVisiable", tablename);
	}

	@Override
	public void deleteAlarmByAlarmNumber(String alarmnumber) {

		this.getSqlMapClientTemplate().delete("deleteAlarmByAlarmNumber", alarmnumber);
	}

	@Override
	public int getAllRootAlarmInfoLstCount(AlarmInfos model) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getAllRootAlarmInfoLstCount",model);
	}

	@Override
	public List getAllRootAlarmInfosLst(AlarmInfos model) {
		return this.getSqlMapClientTemplate().queryForList("getAllRootAlarmInfosLst", model);
	}

	@Override
	public void updateAlarmAckStatus(Map<String, String> map) {

		this.getSqlMapClientTemplate().update("updateAlarmAckStatus", map);
	}
}
