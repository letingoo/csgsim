package faultSimulation.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import resManager.resBusiness.model.Circuit;
import resManager.resBusiness.model.CircuitChannel;
import resManager.resNet.model.CCModel;
import resManager.resNet.model.Equipment;
import resManager.resNet.model.LogicPort;
import resManager.resNet.model.TopoLink;
import resManager.resNode.model.EquipPack;
import sysManager.function.model.OperationModel;

import channelroute.model.CircuitroutModel;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.metarnet.mnt.alarmmgr.model.AlarmInfos;

import faultSimulation.model.ClassicFaultAlarmModel;
import faultSimulation.model.InterposeLogModel;
import faultSimulation.model.InterposeModel;
import faultSimulation.model.OperateList;
import faultSimulation.model.SceneManager;
import faultSimulation.model.StdMaintainProModel;

import netres.model.ComboxDataModel;

public class SceneMgrDAOImpl extends SqlMapClientDaoSupport implements SceneMgrDAO  {

	@SuppressWarnings("unchecked")
	@Override
	public List<ComboxDataModel> getUserInfoByeqsearch(String user_name) {
		Map map=new HashMap();
		map.put("user_name", user_name);
		return this.getSqlMapClientTemplate().queryForList("getUserInfoByeqsearch", map);
	}


	@Override
	public int getAllInterposeCount(InterposeModel model) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getAllInterposeCount", model);
	}

	@Override
	public List<HashMap<Object,Object>> getAllInterposeList(InterposeModel model) {
		return this.getSqlMapClientTemplate().queryForList("getAllInterposeList", model);
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<ComboxDataModel> getFaultTypeByInterposeType(String objid) {
		return this.getSqlMapClientTemplate().queryForList("getFaultTypeByInterposeType", objid);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ComboxDataModel> getInterposeType() {
		return this.getSqlMapClientTemplate().queryForList("getInterposeType");
	}

	@Override
	public String addInterpose(InterposeModel model) {
		String interpose_id="";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			//插入场景
			interpose_id=(String)sqlMap.insert("addInterpose",model);
			//插入场景-人员关系表
			String userid = model.getUser_id();
			String users[] ;
			if(userid.indexOf(",")!=-1){
				users=userid.split(",");
			}else{
				users=new String[]{userid};
			}
			SceneManager key = new SceneManager();
			key.setProjectid(interpose_id);
			key.setDataresource("");//资源怎么取？
			key.setState("0");//未释放资源
			key.setS_remark("");
			for(int i=0;i<users.length;i++){
				key.setUser_id(users[i]);
				sqlMap.insert("insertSceneAndPerson", key);
			}
			//插入设备、机盘和复用段
			if(model.getEquipport_a()!=null&&!"".equals(model.getEquipport_a())){
				//根据系统编码查找设备厂家
				String toplinkid = model.getToplinkid();
				//根据复用段ID查找复用段速率和两端设备编号
				String strs = (String) sqlMap.queryForObject("getEquipcodesAndLinerate", toplinkid);
				String equipa="";String equipz=""; String rate = "";
				String toplinkid1 = ""; String toplinkid2="";String ratecode="";
				if(strs!=null&&strs.indexOf(";")!=-1&&strs.split(";").length==4){
					equipa = strs.split(";")[0];//复用段A端设备
					equipz = strs.split(";")[1];//复用段Z端设备
					rate = strs.split(";")[2];
				}
				if("155M".equals(rate)){
					ratecode = "ZY110601";
				}else if("622M".equals(rate)){
					ratecode = "ZY110602";
				}else if("2.5G".equals(rate)){
					ratecode = "ZY110603";
				}else{
					ratecode = "ZY110604";
				}
				//割接后的业务没有，需要改
				String portcodea = toplinkid.split("#")[0];//开始端口，A端端口
				String portcodez = toplinkid.split("#")[1];//z端端口
				
				String temp=portcodea;
				List<InterposeModel> lst1 = sqlMap.queryForList("getSlotAndRateByPortcode", temp);
				temp=portcodez;
				List<InterposeModel> lst2 = sqlMap.queryForList("getSlotAndRateByPortcode", temp);
				List<InterposeModel> lst = new ArrayList<InterposeModel>();//原来的复用段起止端设备关联的交叉
				for(int t=0;t<lst2.size();t++){
					for(int k=0;k<lst1.size();k++){
						if(lst2.get(t).getSlotserial().equals(lst1.get(k).getSlotserial())&&lst2.get(t).getToplinkrate().equals(lst1.get(k).getToplinkrate())){
							lst.add(lst2.get(t));
							break;
						}
					}
				}
				Map mp = new HashMap();
				mp.put("PID", model.getEquipcode());//当前割接设备
				mp.put("DIRECTION", "BI");
				mp.put("APTP", model.getEquipport_a());//A端对端端口
				mp.put("ZPTP", model.getEquipport_z());//Z端对端端口
				mp.put("TYPE", "0");
				mp.put("ISDEFAULT", "0");
				mp.put("SYNC_STATUS", "ZT00");
				mp.put("UPDATEDATE", model.getUpdatetime());
				for(int p=0;p<lst.size();p++){
					mp.put("ID", model.getEquipport_a()+"-"+lst.get(p).getSlotserial()+"-"+model.getEquipport_z()+"-"+lst.get(p).getSlotserial()+"-"+lst.get(p).getToplinkrate());
					mp.put("ASLOT", lst.get(p).getSlotserial());
					mp.put("ZSLOT", lst.get(p).getSlotserial());
					mp.put("RATE", lst.get(p).getToplinkrate());
					//插入交叉
					sqlMap.insert("insertIntoCCByMap", mp);
				}
				
				//删除原来的复用段
				sqlMap.delete("deleteToplinkById", toplinkid);
				//插入2条复用段
				model.setToplinkrate(ratecode);
				toplinkid1 = model.getToplinkid().split("#")[0]+"#"+model.getEquipport_a();
				toplinkid2 = model.getEquipport_z()+"#"+model.getToplinkid().split("#")[1];
				model.setToplinkid(toplinkid1);
				model.setPorta(toplinkid.split("#")[0]);
				model.setPortz(model.getEquipport_a());
				model.setEquipa(equipa);
				model.setEquipz(model.getEquipcode());
				sqlMap.insert("insertEn_ToplinkByModel", model);
				model.setToplinkid(toplinkid2);
				model.setPorta(model.getEquipport_z());
				model.setPortz(toplinkid.split("#")[1]);
				model.setEquipa(model.getEquipcode());
				model.setEquipz(equipz);
				sqlMap.insert("insertEn_ToplinkByModel", model);
				
				//重新串接路由
				//1、查找当前复用段下的业务
				Map map=new HashMap();
				map.put("porta", portcodea);
				map.put("portz", portcodez);
				List<String> cirlst = sqlMap.queryForList("getCircuitcodeByPorts", map);
				for(int l=0;l<cirlst.size();l++){
					String circuitcode=cirlst.get(l);
					//查找电路的速率，时隙，开始端口
					Circuit cir = (Circuit) sqlMap.queryForObject("getCircuitInfoBycode", circuitcode);
					if(cir!=null){
						Map paraMap = new HashMap();
						paraMap.put("v_name", circuitcode);
						paraMap.put("logicport", cir.getPortcode1());
		                paraMap.put("vc", "VC12");
		                paraMap.put("slot", cir.getSlot1());
		                sqlMap.delete("deleteCircuitRoutByCircuitcode", paraMap);//删除当前电路路由
		                sqlMap.queryForObject("callRouteGenerate",paraMap);//重新串接路由
					}
				}
			}
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return	interpose_id;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<InterposeModel> getEventInterposeIsActive(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getEventInterposeIsActive", map);
	}

	@Override
	public void modifyInterpose(InterposeModel model) {

		//首先删除用户表里的信息，再添加
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			//删除用户信息
			this.getSqlMapClientTemplate().delete("deleteScenePerson", model.getInterposeid());
			//插入场景-人员关系表
			String userid = model.getUser_id();
			String users[] ;
			if(userid.indexOf(",")!=-1){
				users=userid.split(",");
			}else{
				users=new String[]{userid};
			}
			SceneManager key = new SceneManager();
			key.setProjectid(model.getInterposeid());
			key.setDataresource("");//资源怎么取？
			key.setState("0");//未释放资源
			key.setS_remark("");
			for(int i=0;i<users.length;i++){
				key.setUser_id(users[i]);
				this.getSqlMapClientTemplate().insert("insertSceneAndPerson", key);
			}
			//删除科目
			this.getSqlMapClientTemplate().update("modifyInterpose", model);
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}

	@Override
	public void delEventInterpose(String interposeid) {

		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			//同时要删除用户信息
			this.getSqlMapClientTemplate().delete("deleteScenePerson", interposeid);
			this.getSqlMapClientTemplate().delete("delEventInterpose", interposeid);
			sqlMap.commitTransaction();
		} catch (DataAccessException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}

	@Override
	public void setEventIsActive(InterposeModel model) {

		this.getSqlMapClientTemplate().update("setEventIsActive",model);
	}

	@Override
	public int getAllInterposeConfigCount(InterposeModel model) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getAllInterposeConfigCount", model);
	}

	@Override
	public List getAllInterposeConfigList(InterposeModel model) {
		return this.getSqlMapClientTemplate().queryForList("getAllInterposeConfigList", model);
	}

	@Override
	public void delInterposeConfig(InterposeModel model) {

		try {
			this.getSqlMapClientTemplate().delete("delInterposeConfig", model);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void addInterposeConfig(InterposeModel model) {

		this.getSqlMapClientTemplate().insert("addInterposeConfig", model);
	}

	@Override
	public int getAllInterposeAlarmConfigCount(InterposeModel model) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getAllInterposeAlarmConfigCount", model);
	}

	@Override
	public List getAllInterposeAlarmConfigList(InterposeModel model) {
		return this.getSqlMapClientTemplate().queryForList("getAllInterposeAlarmConfigList", model);
	}

	@Override
	public void delInterposeAlarmConfig(String alarmconfid) {

		try {
			this.getSqlMapClientTemplate().delete("delInterposeAlarmConfig", alarmconfid);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void addInterposeAlarmConfig(InterposeModel model) {

		try {
			this.getSqlMapClientTemplate().insert("addInterposeAlarmConfig", model);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void modifyInterposeAlarmConfig(InterposeModel model) {

		this.getSqlMapClientTemplate().update("modifyInterposeAlarmConfig", model);
	}

	@Override
	public int getAllInterposeStdMaintainCount(StdMaintainProModel model) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getAllInterposeStdMaintainCount", model);
	}

	@Override
	public List getAllInterposeStdMaintainList(StdMaintainProModel model) {
		return this.getSqlMapClientTemplate().queryForList("getAllInterposeStdMaintainList", model);
	}

	@Override
	public void addInterposeMaintainProc(StdMaintainProModel model) {

		try {
			this.getSqlMapClientTemplate().insert("addInterposeMaintainProc", model);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void delInterposeMaintainProc(String maintainprocid) {

		try {
			this.getSqlMapClientTemplate().delete("delInterposeMaintainProc", maintainprocid);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void modifyInterposeMaintainProc(StdMaintainProModel model) {

		try {
			this.getSqlMapClientTemplate().update("modifyInterposeMaintainProc", model);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<StdMaintainProModel> selectOperateOrderByMap(Map map) {
		return this.getSqlMapClientTemplate().queryForList("selectOperateOrderByMap", map);
	}

	@Override
	public List<ComboxDataModel> getOperateTypeByeqsearch(String operatetype) {
		Map map = new HashMap();
		map.put("operatetype", operatetype);
		return this.getSqlMapClientTemplate().queryForList("getOperateTypeByeqsearch", map);
	}

	@Override
	public int getAllEventMaintainProcCount(StdMaintainProModel model) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getAllEventMaintainProcCount", model);
	}

	@Override
	public List getAllEventMaintainProcList(StdMaintainProModel model) {
		return this.getSqlMapClientTemplate().queryForList("getAllEventMaintainProcList", model);
	}

	@Override
	public void delEventMaintainProc(String operatetypeid) {

		try {
			this.getSqlMapClientTemplate().delete("delEventMaintainProc", operatetypeid);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void addEventMaintainProc(StdMaintainProModel model) {

		try {
			this.getSqlMapClientTemplate().insert("addEventMaintainProc", model);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void modifyEventMaintainProc(StdMaintainProModel model) {

		try {
			this.getSqlMapClientTemplate().update("modifyEventMaintainProc", model);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<StdMaintainProModel> selectOperateTypeByName(String operatetype) {
		return this.getSqlMapClientTemplate().queryForList("selectOperateTypeByName", operatetype);
	}

	@Override
	public int getAllOperateListByUserCount(OperateList model) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getAllOperateListByUserCount", model);
	}

	@Override
	public List getAllOperateListByUserList(OperateList model) {
		return this.getSqlMapClientTemplate().queryForList("getAllOperateListByUserList", model);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<StdMaintainProModel> getEventSolutionLst(InterposeModel model) {
		return this.getSqlMapClientTemplate().queryForList("getEventSolutionLst", model);
	}

	@Override
	public List<HashMap> getInterposeUserListById(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getInterposeUserListById", map);
	}

	@Override
	public List<HashMap> getInterposeNameById(String interposeid) {
		Map map = new HashMap();
		map.put("interposeid", interposeid);
		return this.getSqlMapClientTemplate().queryForList("getInterposeNameById", map);
	}

	@Override
	public List<ComboxDataModel> getAlarmInfoByeqsearch(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getAlarmInfoByeqsearch", map);
	}

	@Override
	public String getX_vendorByEquipcode(String equipcode) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getX_vendorByEquipcode", equipcode);
	}

	@Override
	public String getX_vendorNameById(String x_vendor) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getX_vendorNameById", x_vendor);
	}

	@Override
	public List<ComboxDataModel> getEquiptypeLst(String type) {
		if("3".equals(type)){
			type="";
		}
		Map map = new HashMap();
		map.put("type", type);
		return this.getSqlMapClientTemplate().queryForList("getEquiptypeLst",map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<StdMaintainProModel> getStdFlowByID(String interposeid) {
		return this.getSqlMapClientTemplate().queryForList("getStdFlowByID", interposeid);
	}

	@Override
	public List<OperateList> getUserFlowByID(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getUserFlowByID", map);
	}

	@Override
	public ComboxDataModel getTransystemByEquipCode(String equipcode) {
		return (ComboxDataModel) this.getSqlMapClientTemplate().queryForObject("getTransystemByEquipCode", equipcode);
	}

	@Override
	public ComboxDataModel getStationByEquipCode(String equipcode) {
		return (ComboxDataModel) this.getSqlMapClientTemplate().queryForObject("getStationByEquipCode", equipcode);
	}

	@Override
	public ComboxDataModel getSerialsByCodes(String resourcecode,String field,
			 String tablename) {

		Map map=new HashMap();
		map.put("resourcecode", resourcecode);
		map.put("field", field);
		map.put("tablename", tablename);
		return (ComboxDataModel) this.getSqlMapClientTemplate().queryForObject("getSerialsByCodes", map);
	}

	@Override
	public String getAlarmLevelById(String alarmid) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getAlarmLevelById", alarmid);
	}

	@Override
	public void insertAlarmInfo(AlarmInfos alarmModel) {
		String type="-1";
		String alarmtype=alarmModel.getAlarmType();
		if("演习".equals(alarmtype)){
			type="3";
		}if("故障".equals(alarmtype)){
			type="2";
		}if("割接".equals(alarmtype)){
			type="1";
		}
		alarmModel.setAlarmType(type);
		try {
			this.getSqlMapClientTemplate().insert("insertAlarmInfo", alarmModel);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}


	@Override
	public List<ComboxDataModel> getResourceByrsearch(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getResourceByrsearch", map);
	}

	@Override
	public List<ComboxDataModel> getResourceNameAndID(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getPackResourceNameAndID", map);
	}
	
	@Override
	public List<ComboxDataModel> getResourceOfportNameAndID(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getResourceOfportNameAndID", map);
	}
	
	@Override
	public String getPortSerialById(String code) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getPortSerialById", code);
	}

	@Override
	public List<InterposeModel> getInterposeAlarmList(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getInterposeAlarmList", map);
	}

	@Override
	public String getInterposeIdsByMap(
			Map map) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getInterposeIdsByMap", map);
	}

	@Override
	public InterposeModel getInterposeTypeIds(String interposeid) {
		return (InterposeModel) this.getSqlMapClientTemplate().queryForObject("getInterposeTypeIds", interposeid);
	}

	@Override
	public void saveUserOperate(StdMaintainProModel model) {

		try {
			this.getSqlMapClientTemplate().insert("saveUserOperate", model);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<ComboxDataModel> getFaultTypeInfoByInterposeType(String objid,String sourcecode) {
		Map map=new HashMap();
		if(objid!=null&&objid.split(";").length==2){
			map.put("i_interpose_type", objid.split(";")[0]);
			String equiptype = objid.split(";")[1];
			map.put("equiptype", equiptype );
			String packtype="";
			if("机盘".equals(equiptype)&&sourcecode!=null){
				if(sourcecode.split(",").length==4){
					//查找机盘型号
					map.put("equipcode", sourcecode.split(",")[0]);
					map.put("frameserial", sourcecode.split(",")[1]);
					map.put("slotserial", sourcecode.split(",")[2]);
					map.put("packserial", sourcecode.split(",")[3]);
					packtype = (String) this.getSqlMapClientTemplate().queryForObject("getEquippackTypeByMap", map);
				}
				if(sourcecode.split(",").length==2){
					//只有机盘标志符和机槽序号
					map.put("id", sourcecode.split(",")[1]);
					map.put("slotserial", sourcecode.split(",")[0]);
					packtype = (String) this.getSqlMapClientTemplate().queryForObject("getEquippackTypeByMap1", map);
				}
				map.put("packtype", packtype);
				return this.getSqlMapClientTemplate().queryForList("getFaultTypeInfoByInterposeType1", map);
			}
			if("端口".equals(equiptype)&&sourcecode!=null){
				if(sourcecode.split("=").length==5){
					map.put("equipcode", sourcecode.split("=")[0]);
					map.put("frameserial", sourcecode.split("=")[1]);
					map.put("slotserial", sourcecode.split("=")[2]);
					map.put("packserial", sourcecode.split("=")[3]);
					map.put("portserial", sourcecode.split("=")[4]);
					packtype = (String) this.getSqlMapClientTemplate().queryForObject("getEquippackTypeByMap", map);
				}
				if(sourcecode.split(",").length==2){
					//只有端口编号和机槽序号
					map.put("logicport", sourcecode.split(",")[1]);
					map.put("slotserial", sourcecode.split(",")[0]);
					packtype = (String) this.getSqlMapClientTemplate().queryForObject("getEquippackTypeByMap2", map);
				}
				if("支路盘".equals(packtype)){
					map.put("packtype", "电端口");
				}else if("光路盘".equals(packtype)){
					map.put("packtype", "光端口");
				}
				return this.getSqlMapClientTemplate().queryForList("getFaultTypeInfoByInterposeType2", map);
			}
		}else{
			map.put("i_interpose_type", objid.replaceAll(";", ""));//替换";"
		}
		
		return this.getSqlMapClientTemplate().queryForList("getFaultTypeInfoByInterposeType", map);
	}
	
	public String getEquipNameByEquipcode(String paraValue){
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquipNameByEqcode", paraValue);
	}

	@Override
	public List<ComboxDataModel> getInterposeNameByeqsearch(String projectname) {
		Map map = new HashMap();
		map.put("projectname", projectname);
		return this.getSqlMapClientTemplate().queryForList("getInterposeNameByeqsearch", map);
	}

	@Override
	public String getEquipcodeByPortCode(String portcode) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquipcodeByPortCode", portcode);
	}

	@Override
	public String getPortCodeByMap(Map map) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getPortCodeByMap", map);
	}

	@Override
	public String getPortcode2ByPortCode1(String portcode) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getPortcode2ByPortCode1", portcode);
	}

	@Override
	public void deleteAlarmByMap(Map map3) {

		//修改完告警后要把演习设置为已处理
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			this.getSqlMapClientTemplate().update("deleteAlarmByMap", map3);
			//吧当前演习设置为已处理
			this.getSqlMapClientTemplate().update("modifyInterposeInfo", map3.get("interposeid"));
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}

	@Override
	public String getOperateTypeByMap(Map map2) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getOperateTypeByMap", map2);
	}

	@Override
	public void modifyInterposeConfig(InterposeModel model) {
		this.getSqlMapClientTemplate().update("modifyInterposeConfig", model);
	}


	public Object getAlarmOperations(Object obj) {
		return getSqlMapClientTemplate().queryForList("getAlarmOperations",obj);
	}

	@Override
	public List<InterposeModel> getInterposeAlarmConfigListByModel(
			InterposeModel model) {
		return this.getSqlMapClientTemplate().queryForList("getInterposeAlarmConfigListByModel", model);
	}

	@Override
	public List<OperateList> getAllOperateList() {
		return this.getSqlMapClientTemplate().queryForList("getAllOperateList");
	}

	@Override
	public void delAlarmOperation(String oper_id) {
		this.getSqlMapClientTemplate().delete("delAlarmOperation", oper_id);
	}

	@Override
	public void updateAlarmOperationByOperId(OperateList operation) {
		this.getSqlMapClientTemplate().update("updateAlarmOperationByOperId", operation);
	}

	@Override
	public void insertAlarmOper(Object obj) {
		this.getSqlMapClientTemplate().insert("insertAlarmOper", obj);
	}

	@Override
	public String getAlarmIdsByAlarmId(String alarmid) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getAlarmIdsByAlarmId", alarmid);
	}

	@Override
	public List<OperateList> getAlarmTransmitByAlarmId(String alarmid) {
		return this.getSqlMapClientTemplate().queryForList("getAlarmTransmitByAlarmId",alarmid);
	}

	@Override
	public List getZPortCodeListByEquipcode(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getZPortCodeListByEquipcode", equipcode);
	}

	@Override
	public String getZ_EquipcodeByPortCode(String portcode) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getZ_EquipcodeByPortCode", portcode);
	}

	@Override
	public String getEquipSlotSerialById(String portcode) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquipSlotSerialById", portcode);
	}

	@Override
	public List<String> getInterposeIdsByAlarmMap(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getInterposeIdsByAlarmMap", map);
	}

	@Override
	public List<InterposeModel> getAllInterposeListExcel() {
		return this.getSqlMapClientTemplate().queryForList("getAllInterposeListExcel");
	}

	@Override
	public List<StdMaintainProModel> getAllMantainListExcel() {
		return this.getSqlMapClientTemplate().queryForList("getAllMantainListExcel");
	}


	public List getCruFaulterFlag(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getCruFaulterFlag",map);
	}


	@Override
	public String getAlarmNameByAlarmId(String alarmId) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getAlarmNameByAlarmId", alarmId);
	}

	@Override
	public Object getAllFaultFunctions(Object obj) {
			return getSqlMapClientTemplate().queryForList("getAllFaultFunctions",obj);
	}
	
	@Override
	public void delFaultType(String oper_id) {
		this.getSqlMapClientTemplate().delete("delFaultType", oper_id);
	}

	@Override
	public void updateFaultTypeByOperId(OperateList operation) {
		this.getSqlMapClientTemplate().update("updateFaultTypeByOperId", operation);
	}

	@Override
	public void insertFaultType(Object obj) {
		this.getSqlMapClientTemplate().insert("insertFaultType", obj);
	}


	@Override
	public List<String> getZportCodeListByAportcode(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getZportCodeListByAportcode", map);
	}


	@Override
	public List<String> getZportCodeListByPackcode(Map map) {
		List<String> resultList = new ArrayList<String>();
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			//根据机盘编号，到机盘表中查找其对应的设备编号，机框、槽、盘序号
			HashMap resultMap =  (HashMap) this.getSqlMapClientTemplate().queryForObject("getZportCodeListByPackcode", map);
			Map mp = new HashMap();
			mp.put("equipcode", resultMap.get("EQUIPCODE").toString());
			mp.put("frameserial", resultMap.get("FRAMESERIAL").toString());
			mp.put("slotserial", resultMap.get("SLOTSERIAL").toString());
			mp.put("packserial", resultMap.get("PACKSERIAL").toString());
			//查询机盘对应的端口列表
			List<String> a_portLst = new ArrayList<String>();
			a_portLst = this.getSqlMapClientTemplate().queryForList("getPortcodesByMap", mp);
			//查找对端端口列表
			Map mp1 = new HashMap();
			mp1.put("equipcode", resultMap.get("EQUIPCODE").toString());
			mp1.put("a_portLst", a_portLst);
			if(a_portLst.size()>0){
				resultList = this.getSqlMapClientTemplate().queryForList("getZportCodeListByAportcodeLst", mp1);
			}
			
			sqlMap.commitTransaction();
		} catch (DataAccessException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return resultList;
	}


	@Override
	public List<String> getInterposeIdsByEquipcode(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getInterposeIdsByEquipcode", map);
	}


	@Override
	public StdMaintainProModel getStdMaintainProModelByType(String operatetype) {
		return (StdMaintainProModel) this.getSqlMapClientTemplate().queryForObject("getStdMaintainProModelByType", operatetype);
	}


	@Override
	public String getInterposeIdsByAlarmModel(AlarmInfos alarmModel) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getInterposeIdsByAlarmModel", alarmModel);
	}


	@Override
	public void delEventInterposeCascade(String interposeId) {
		//首先删除用户表里的信息，再添加
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			//删除告警列表
			this.getSqlMapClientTemplate().delete("deleteAlarmInfoByInterposeId", interposeId);
			//删除操作表
			this.getSqlMapClientTemplate().delete("deleteTOperateByInterposeId", interposeId);
			//删除科目表
			this.getSqlMapClientTemplate().delete("delEventInterpose", interposeId);
			
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}


	@Override
	public String getPortcodeAndEquipcodeGroups(
			String resourcecode) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getPortcodeAndEquipcodeGroups", resourcecode);
	}


	@Override
	public ComboxDataModel getSlotSerialByPortCode(String portcode) {
		return (ComboxDataModel) this.getSqlMapClientTemplate().queryForObject("getSlotSerialByPortCode", portcode);
	}


	@Override
	public List<String> getTopLinksByMap(Map mp) {
		return this.getSqlMapClientTemplate().queryForList("getTopLinksByMap", mp);
	}


	@Override
	public List<String> getEn_toplinkAndPortsByEquipcode(String eqcode) {
		return this.getSqlMapClientTemplate().queryForList("getEn_toplinkAndPortsByEquipcode", eqcode);
	}


	@Override
	public String getToplinkLabelByPortcode(String portcode) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getToplinkLabelByPortcode", portcode);
	}


	@Override
	public List<String> getEventIdListByEquipcode(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getEventIdListByEquipcode", equipcode);
	}


	@Override
	public List<String> getInterposeIdsByMap2(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getInterposeIdsByMap2", map);
	}


	@Override
	public List<ComboxDataModel> getEquipModelBySysCode(String syscode) {
		return this.getSqlMapClientTemplate().queryForList("getEquipModelBySysCode", syscode);
	}


	@Override
	public String getToplinkRateByCode(String toplinkid) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquipcodesAndLinerate", toplinkid);
	}


	@Override
	public List<InterposeModel> getToplinkLstByEquipcode(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getToplinkLstByEquipcode", equipcode);
	}


	@Override
	public List<InterposeModel> getToplinkRateAndPortAndEquipzByEquipcode(
			String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getToplinkRateAndPortAndEquipzByEquipcode", equipcode);
	}


	@Override
	public void insertToplinkByModel(InterposeModel model) {

		this.getSqlMapClientTemplate().insert("insertEn_ToplinkByModel", model);
	}


	@Override
	public void deleteEquipmentByEquipcode(String equipcode) {

		this.getSqlMapClientTemplate().delete("delEquipmentByModel",equipcode);
	}


	@Override
	public List<String> getAllBusinessRelateCircuitcode() {
		return this.getSqlMapClientTemplate().queryForList("getAllBusinessRelateCircuitcode");
	}


	@Override
	public List<String> getAllRelatedCircuitCode(Map m) {
		return this.getSqlMapClientTemplate().queryForList("getAllRelatedCircuitCode", m);
	}


	@Override
	public List<String> getPortcodesByMap(Map m) {
		return this.getSqlMapClientTemplate().queryForList("getPortcodesByMap", m);
	}


	@Override
	public List<String> getPortCodesByCCID(String ccid) {
		List<String> lst = new ArrayList<String>();
		String str[];
		String strs = (String) this.getSqlMapClientTemplate().queryForObject("getPortCodesByCCID", ccid);
		if(strs!=null&&!"".equals(strs)&&strs.indexOf(";")!=-1){
			str=strs.split(";");
		}else{
			str = new String[]{strs};
		}
		for(int i=0;i<str.length;i++){
			lst.add(str[i]);
		}
		return lst;
	}


	@Override
	public InterposeModel getEquipcodeAndEquipName(String portcode) {
		return (InterposeModel) this.getSqlMapClientTemplate().queryForObject("getEquipcodeAndEquipName", portcode);
	}


	@Override
	public Circuit getCircuitByCircuitcode(String circuitcode) {
		return (Circuit) this.getSqlMapClientTemplate().queryForObject("getCircuitByCircuitcode", circuitcode);
	}


	@Override
	public List<Circuit> getEquipcodeAndCounts(String circuitcode) {
		return this.getSqlMapClientTemplate().queryForList("getEquipcodeAndCounts", circuitcode);
	}


	@Override
	public String getEquipcodeByEquipName(String equipname) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquipcodeByEquipName", equipname);
	}


	@Override
	public List<String> getAllPortcodeLstByID(String equipcode,
			String circuitcode) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("equipcode", equipcode);
		map.put("circuitcode", circuitcode);
		return this.getSqlMapClientTemplate().queryForList("getAllPortcodeLstByMap", map);
	}


	@Override
	public LogicPort getLogicPortInfos(String portcode) {
		return (LogicPort) this.getSqlMapClientTemplate().queryForObject("getLogicPortInfos", portcode);
	}


	@Override
	public List<CircuitChannel> getAllRouteInfosByID(String circuitcode) {
		return this.getSqlMapClientTemplate().queryForList("getAllRouteInfosByID", circuitcode);
	}


	@Override
	public List<AlarmInfos> getAlarmInfosByModel(AlarmInfos alarmModel) {
		
		return this.getSqlMapClientTemplate().queryForList("getAlarmInfosByModel", alarmModel);
	}


	@Override
	public void deleteAlarmByEquipcode(String equipcode) {

		this.getSqlMapClientTemplate().delete("deleteAlarmByEquipcode", equipcode);
	}


	@Override
	public void updateAlarmInfosByInterposeid(String interposeid) {

		this.getSqlMapClientTemplate().update("updateAlarmInfosByInterposeid", interposeid);
	}


	@Override
	public void deleteEn_toplinkByID(String toplinkid) {

		this.getSqlMapClientTemplate().delete("deleteEn_toplinkByID", toplinkid);
	}


	@Override
	public InterposeModel getInterposeModelByID(String interposeid) {
		return (InterposeModel) this.getSqlMapClientTemplate().queryForObject("getInterposeModelByID", interposeid);
	}


	@Override
	public List getAllInterposeList1(InterposeModel model) {
		return this.getSqlMapClientTemplate().queryForList("getAllInterposeList1", model);
	}


	@Override
	public int getInterposeLogCount(InterposeLogModel model) {
		return (Integer) this.getSqlMapClientTemplate().queryForObject("getInterposeLogCount", model);
	}


	@Override
	public Object getInterposeLogList(InterposeLogModel model) {
		return this.getSqlMapClientTemplate().queryForList("getInterposeLogList", model);
	}


	@Override
	public void addInterposeLogEvent(Map logMap) {

		this.getSqlMapClientTemplate().insert("addInterposeLogEvent", logMap);
	}


	@Override
	public List<InterposeLogModel> getAllInterposeLogListExcel(
			InterposeLogModel model) {
		return this.getSqlMapClientTemplate().queryForList("getAllInterposeLogListExcel", model);
	}


	@Override
	public void autoAddInterpose(InterposeModel model) {
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			//插入场景
			String interpose_id=(String)this.getSqlMapClientTemplate().insert("addInterpose",model);
			//插入场景-人员关系表
			String userid = model.getUser_id();
			String users[] ;
			if(userid.indexOf(",")!=-1){
				users=userid.split(",");
			}else{
				users=new String[]{userid};
			}
			SceneManager key = new SceneManager();
			key.setProjectid(interpose_id);
			key.setDataresource("");//资源怎么取？
			key.setState("0");//未释放资源
			key.setS_remark("");
			for(int i=0;i<users.length;i++){
				key.setUser_id(users[i]);
				this.getSqlMapClientTemplate().insert("insertSceneAndPerson", key);
			}
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}


	@Override
	public List<Equipment> getAllEquipment() {
		return this.getSqlMapClientTemplate().queryForList("getAllEquipment");
	}


	@Override
	public List<EquipPack> getAllEquippack(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getAllEquippack",equipcode);
	}


	@Override
	public List<InterposeModel> getAllInterposeFaultList(String equiptype) {
		return this.getSqlMapClientTemplate().queryForList("getAllInterposeFaultList",equiptype);
	}


	@Override
	public List<LogicPort> getAllLogicport(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getAllLogicport", equipcode);
	}


	@Override
	public List<TopoLink> getAllTopLink(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getAllTopLink", equipcode);
	}


	@Override
	public List<String> getAllCircuitCode() {
		return this.getSqlMapClientTemplate().queryForList("getAllCircuitCode");
	}


	@Override
	public List<CircuitroutModel> selectCircuitroutLstByCircuitcode(
			String circuitcode) {
		return this.getSqlMapClientTemplate().queryForList("selectCircuitroutLstByCircuitcode", circuitcode);
	}


	@Override
	public void updateCircuitRouteByMap(Map map) {
		this.getSqlMapClientTemplate().update("updateCircuitRouteByMap",map);
	}


	@Override
	public List<ComboxDataModel> getFaultTypelst() {
		return this.getSqlMapClientTemplate().queryForList("getFaultTypelst");
	}


	@Override
	public String getAlarmTypeByID(String interposeid) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getAlarmTypeByID", interposeid);
	}


	@Override
	public void modifyInterposeInfo(String interposeid) {

		//修改完后要把告警信息设为已清除或已确认
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			this.getSqlMapClientTemplate().update("modifyInterposeInfo",interposeid);
			this.getSqlMapClientTemplate().update("updateAlarmInfoCleared", interposeid);
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}


	@Override
	public List<ComboxDataModel> selectPortCutLst(Map map) {
		return this.getSqlMapClientTemplate().queryForList("selectPortCutLst", map);
	}


	@Override
	public String addInterposePortCut(InterposeModel model) {
		String interpose_id="";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			//插入割接科目
			interpose_id=(String)sqlMap.insert("addInterpose",model);
			//插入场景-人员关系表
			String userid = model.getUser_id();
			String users[] ;
			if(userid.indexOf(",")!=-1){
				users=userid.split(",");
			}else{
				users=new String[]{userid};
			}
			SceneManager key = new SceneManager();
			key.setProjectid(interpose_id);
			key.setDataresource("");//资源怎么取？
			key.setState("0");//未释放资源
			key.setS_remark("");
			for(int i=0;i<users.length;i++){
				key.setUser_id(users[i]);
				sqlMap.insert("insertSceneAndPerson", key);
			}
//			//查找当前端口下的电路列表
//			List<String> circuitlst = this.getSqlMapClientTemplate().queryForList("getCircuitBycodes", model.getCutport());
//			if(circuitlst.size()>0){
//				for(int i=0;i<circuitlst.size();i++){
					Map map = new HashMap();
					map.put("portcode", model.getCutportcode());//新
					map.put("oldportcode", model.getCutport());//老
					
					//原来端口上的告警移植到割接后的端口上
					Map map1 = new HashMap();
					String code = model.getCutportcode();
					map1.put("newPortCode", model.getCutportcode());
					map1.put("oldPortCode", model.getCutport());
					//端口序号也要改
					String newportserial = (String) sqlMap.queryForObject("getPortSerialById", code);
					code = model.getCutport();
					String serial = (String) sqlMap.queryForObject("getPortSerialById", code);
					//告警位置要改，根据端口编号查找设备
					String portcode = model.getCutportcode();
					String alarmobj = (String) sqlMap.queryForObject("getAlarmObjByPortcode", portcode);
					map1.put("alarmobj", alarmobj);
					map1.put("newportserial", newportserial);
					map1.put("serial", serial);
					sqlMap.update("updateAlarmInfosByPortcode", map1);
					
					//修改电路路由表对应的端口号
					sqlMap.update("updateCircuit_ccABycodes", map);
					sqlMap.update("updateCircuit_ccZBycodes", map);
					
					//查找当前端口中是否有电路编号
					String circuitcode = (String) sqlMap.queryForObject("selectPortCircuitBycode", map);
					if(!"".equals(circuitcode)&&circuitcode!=null){
						//修改端口表中的对应的电路编号
						map.put("circuitcode", circuitcode);
						sqlMap.update("updateEquiplogicPortInfoA", map);
						sqlMap.update("updateEquiplogicPortInfoZ", map);
						//修改电路表中端口字段
						sqlMap.update("updateCircuitInfoABycodes", map);
						sqlMap.update("updateCircuitInfoZBycodes", map);
					}
					//查询当前端口关联的交叉列表
					List<CCModel> list =sqlMap.queryForList("getCCLstByPortcode", map);
					for(int i=0;i<list.size();i++){
						String porta = list.get(i).getAptp();
						String slota = list.get(i).getAslot();
						String rate = list.get(i).getRate();
						String portz = list.get(i).getZptp();
						String slotz = list.get(i).getZslot();
						if(model.getCutport().equals(porta)){
							//a端口
							map.put("id", model.getCutportcode()+"-"+slota+"-"+portz+"-"+slotz+"-"+rate);
							map.put("oldid", list.get(i).getId());
							//修改交叉表
							sqlMap.update("updateCCAbycodes", map);
						}
						if(model.getCutport().equals(portz)){
							//a端口
							map.put("id", porta+"-"+slota+"-"+model.getCutportcode()+"-"+slotz+"-"+rate);
							map.put("oldid", list.get(i).getId());
							//修改交叉表
							sqlMap.update("updateCCZbycodes", map);
						}
					}
					TopoLink link = (TopoLink) sqlMap.queryForObject("selectEn_topLinkByMap", map);
					if(link!=null){
						String porta = link.getAendptp();
						String portz = link.getZendptp();
						if(model.getCutport().equals(porta)){
							map.put("label", model.getCutport()+"#"+portz);
							map.put("oldlabel", link.getLabel());
							//修改复用段表
							sqlMap.update("updateToplinkABycodes", map);
						}
						if(model.getCutport().equals(portz)){
							map.put("label", porta+"#"+model.getCutport());
							map.put("oldlabel", link.getLabel());
							//修改复用段表
							sqlMap.update("updateToplinkZBycodes", map);
						}
					}
//				}
//			}
			
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return interpose_id;
	}


	@Override
	public String getPortrateByPortcode(Map mp) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getPortrateByPortcode", mp);
	}


	@Override
	public List<String> getZportCodeListByToplink(Map mp) {
		return this.getSqlMapClientTemplate().queryForList("getZportCodeListByToplink", mp);
	}


	@Override
	public List<HashMap> selectEquipPortCutLst(Map map) {
		return this.getSqlMapClientTemplate().queryForList("selectEquipPortCutLst", map);
	}


	@Override
	public List<ComboxDataModel> getCutPortResourceByrsearch(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getCutPortResourceByrsearch", map);
	}


	@Override
	public List<HashMap> getPackResourceByrsearch(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getPackResourceByrsearch", map);
	}


	@Override
	public EquipPack getEquipPackInfo(String id) {
		return (EquipPack) this.getSqlMapClientTemplate().queryForObject("getEquipPackInfo", id);
	}


	@Override
	public List<String> getPortInUseByPack(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getPortInUseByPack", map);
	}


	@Override
	public List<String> getPackListByTypeAndRate(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getPackListByTypeAndRate", map);
	}


	@Override
	public List<String> getLogicPortNotUseByMap(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getLogicPortNotUseByMap", map);
	}


	@Override
	public List<HashMap> getCutPackResourceByrsearch(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getCutPackResourceByrsearch", map);
	}


	@Override
	public void updatePortBusinessConfig(InterposeModel model) {
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			Map map = new HashMap();
			map.put("portcode", model.getCutportcode());//新
			map.put("oldportcode", model.getCutport());//老
			//修改电路路由表对应的端口号
			sqlMap.update("updateCircuit_ccABycodes", map);
			sqlMap.update("updateCircuit_ccZBycodes", map);
			
			//查找当前端口中是否有电路编号
			String circuitcode = (String) this.getSqlMapClientTemplate().queryForObject("selectPortCircuitBycode", map);
			if(!"".equals(circuitcode)&&circuitcode!=null){
				//修改端口表中的对应的电路编号
				map.put("circuitcode", circuitcode);
				sqlMap.update("updateEquiplogicPortInfoA", map);
				sqlMap.update("updateEquiplogicPortInfoZ", map);
				//修改电路表中端口字段
				sqlMap.update("updateCircuitInfoABycodes", map);
				sqlMap.update("updateCircuitInfoZBycodes", map);
			}
			//查询当前端口关联的交叉列表
			List<CCModel> list =sqlMap.queryForList("getCCLstByPortcode", map);
			for(int i=0;i<list.size();i++){
				String porta = list.get(i).getAptp();
				String slota = list.get(i).getAslot();
				String rate = list.get(i).getRate();
				String portz = list.get(i).getZptp();
				String slotz = list.get(i).getZslot();
				if(model.getCutport().equals(porta)){
					//a端口
					map.put("id", model.getCutportcode()+"-"+slota+"-"+portz+"-"+slotz+"-"+rate);
					map.put("oldid", list.get(i).getId());
					//修改交叉表
					sqlMap.update("updateCCAbycodes", map);
				}
				if(model.getCutport().equals(portz)){
					//a端口
					map.put("id", porta+"-"+slota+"-"+model.getCutportcode()+"-"+slotz+"-"+rate);
					map.put("oldid", list.get(i).getId());
					//修改交叉表
					sqlMap.update("updateCCZbycodes", map);
				}
			}
			TopoLink link = (TopoLink) sqlMap.queryForObject("selectEn_topLinkByMap", map);
			if(link!=null){
				String porta = link.getAendptp();
				String portz = link.getZendptp();
				if(model.getCutport().equals(porta)){
					map.put("label", model.getCutport()+"#"+portz);
					map.put("oldlabel", link.getLabel());
					//修改复用段表
					sqlMap.update("updateToplinkABycodes", map);
				}
				if(model.getCutport().equals(portz)){
					map.put("label", porta+"#"+model.getCutport());
					map.put("oldlabel", link.getLabel());
					//修改复用段表
					sqlMap.update("updateToplinkZBycodes", map);
				}
			}
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}


	@Override
	public List<String> getUsePortcodesByMap(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getUsePortcodesByMap", map);
	}


	@Override
	public String getPackcodeByMap(Map map) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getPackcodeByMap", map);
	}


	@Override
	public String getPortTypeAndRate(String toplinkid) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getPortTypeAndRate", toplinkid);
	}


	@Override
	public List<ComboxDataModel> getEquippackBysearch(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getEquippackBysearch", map);
	}


	@Override
	public List<HashMap> getEquipportBysearch(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getEquipportBysearch", map);
	}


	@Override
	public void restructCircuitRoute(String porta, String portz) {
		//重新串接路由
		//1、查找当前复用段下的业务
		Map map=new HashMap();
		map.put("porta", porta);
		map.put("portz", portz);
		List<String> cirlst = this.getSqlMapClientTemplate().queryForList("getCircuitcodeByPorts", map);
		for(int l=0;l<cirlst.size();l++){
			String circuitcode=cirlst.get(l);
			//查找电路的速率，时隙，开始端口
			Circuit cir = (Circuit) this.getSqlMapClientTemplate().queryForObject("getCircuitInfoBycode", circuitcode);
			if(cir!=null){
				Map paraMap = new HashMap();
				paraMap.put("v_name", circuitcode);
				paraMap.put("logicport", cir.getPortcode1());
                paraMap.put("vc", "VC12");
                paraMap.put("slot", cir.getSlot1());
                this.getSqlMapClientTemplate().delete("deleteCircuitRoutByCircuitcode", paraMap);//删除当前电路路由
                this.getSqlMapClientTemplate().queryForObject("callRouteGenerate",paraMap);//重新串接路由
			}
		}
	}


	@Override
	public String getOcableNameById(String ocablecode,String type) {
		if("ocable".equals(type)){
			return (String) this.getSqlMapClientTemplate().queryForObject("getOcableNameById", ocablecode);
		}
		else{
			return (String) this.getSqlMapClientTemplate().queryForObject("getFiberNameById", ocablecode);
		}
	}


	@Override
	public List<ComboxDataModel> getFaultTypelstByMap(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getFaultTypelstByMap", map);
	}


	@Override
	public List<String> getAllEquipportByOcablecode(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getAllEquipportByOcablecode", map);
	}


	@Override
	public Circuit getCircuitByCircuitcode1(String circuitcode) {
		return (Circuit) this.getSqlMapClientTemplate().queryForObject("getCircuitByCircuitcode1", circuitcode);
	}


	@Override
	public void insertCircuit_equipment_cnt(Map map) {
		this.getSqlMapClientTemplate().insert("insertCircuit_equipment_cnt", map);
	}


	@Override
	public void deleteCircuit_equipment_cnt(Map map) {
		this.getSqlMapClientTemplate().delete("deleteCircuit_equipment_cnt", map);
	}


	@Override
	public Circuit getCircuitInfoBycode(String circuitcode) {
		return (Circuit) this.getSqlMapClientTemplate().queryForObject("getCircuitInfoBycode", circuitcode);
	}


	@Override
	public void deleteCircuitRoutByCircuitcode(Map map) {
		this.getSqlMapClientTemplate().delete("deleteCircuitRoutByCircuitcode", map);
	}


	@Override
	public void insertcallRouteGenerate(Map map) {
		this.getSqlMapClientTemplate().queryForObject("callRouteGenerate", map);
	}


	@Override
	public String getAreaNameByEquipcode(String equipcode) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getAreaNameByEquipcode", equipcode);
	}


	@Override
	public void deleteEquipmentCCByEquipcode(String equipcode) {

		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			sqlMap.delete("deleteEquipmentCCByEquipcode", equipcode);
			sqlMap.delete("deleteEquipLinkByEquipcode", equipcode);
			sqlMap.delete("deleteEquipRouteByEquipcode", equipcode);
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}


	@Override
	public void updateAlarmInfosByPortcode(Map map) {

		this.getSqlMapClientTemplate().update("updateAlarmInfosByPortcode", map);
	}


	@Override
	public EquipPack getEquipPackInfoNew(String resid) {
		return (EquipPack) this.getSqlMapClientTemplate().queryForObject("getEquipPackInfoNew", resid);
	}


	@Override
	public void updateAlarmInfosBySerials(Map m) {

		this.getSqlMapClientTemplate().update("updateAlarmInfosBySerials", m);
	}


	@Override
	public String getAlarmObjByPortcode(String portcode) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getAlarmObjByPortcode", portcode);
	}


	@Override
	public String getAlarmobjByMap(Map m) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getAlarmobjByMap", m);
	}


	@Override
	public void updateAlarmInfosByPortcode1(Map m) {

		this.getSqlMapClientTemplate().update("updateAlarmInfosByPortcode1", m);
	}


	@Override
	public ArrayList getAllClassicFault(String oper_id) {
		return (ArrayList) this.getSqlMapClientTemplate().queryForList("getAllClassicFault", oper_id);
	}


	@Override
	public void insertOper(OperationModel oform) {

		getSqlMapClientTemplate().insert("insertOperNew",oform);
	}


	@Override
	public void updateOperationByOperId(OperationModel oform) {

		getSqlMapClientTemplate().update("updateOperationByOperIdNew", oform);
	}


	@Override
	public List<ClassicFaultAlarmModel> getAllClassicFaultAlarmLst(
			String oper_id) {
		return this.getSqlMapClientTemplate().queryForList("getAllClassicFaultAlarmLst", oper_id);
	}


	@Override
	public String getStationCodeByStation(String station) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getStationCodeByStation", station);
	}


	@Override
	public void insertClassicFaultAlarmConf(ClassicFaultAlarmModel model) {

		this.getSqlMapClientTemplate().insert("insertClassicFaultAlarmConf", model);
	}


	@Override
	public String getEquippackModelByMap(String belongequip,
			String belongframe, String belongslot, String belongpack) {
		Map map = new HashMap();
		map.put("equipcode", belongequip);
		map.put("frameserial", belongframe);
		map.put("slotserial", belongslot);
		map.put("packserial", belongpack);
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquippackModelByMap", map);
	}


}
