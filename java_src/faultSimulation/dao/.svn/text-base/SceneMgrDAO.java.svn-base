package faultSimulation.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import resManager.resBusiness.model.Circuit;
import resManager.resBusiness.model.CircuitChannel;
import resManager.resNet.model.Equipment;
import resManager.resNet.model.LogicPort;
import resManager.resNet.model.TopoLink;
import resManager.resNode.model.EquipPack;
import sysManager.function.model.OperationModel;


import channelroute.model.CircuitroutModel;

import com.metarnet.mnt.alarmmgr.model.AlarmInfos;

import faultSimulation.model.ClassicFaultAlarmModel;
import faultSimulation.model.InterposeLogModel;
import faultSimulation.model.InterposeModel;
import faultSimulation.model.OperateList;
import faultSimulation.model.StdMaintainProModel;

import netres.model.ComboxDataModel;

public interface SceneMgrDAO {

	List<ComboxDataModel> getUserInfoByeqsearch(String cond);

	int getAllInterposeCount(InterposeModel model);

	List<HashMap<Object,Object>>getAllInterposeList(InterposeModel model);

	List<ComboxDataModel> getFaultTypeByInterposeType(String objid);

	List<ComboxDataModel> getInterposeType();

	String addInterpose(InterposeModel model);

	List<InterposeModel> getEventInterposeIsActive(Map map);

	void modifyInterpose(InterposeModel model);

	void delEventInterpose(String interposeid);

	void setEventIsActive(InterposeModel model);

	int getAllInterposeConfigCount(InterposeModel model);

	List getAllInterposeConfigList(InterposeModel model);

	void delInterposeConfig(InterposeModel model);

	void addInterposeConfig(InterposeModel model);

	int getAllInterposeAlarmConfigCount(InterposeModel model);

	List getAllInterposeAlarmConfigList(InterposeModel model);

	void delInterposeAlarmConfig(String alarmconfid);

	void addInterposeAlarmConfig(InterposeModel model);

	void modifyInterposeAlarmConfig(InterposeModel model);

	int getAllInterposeStdMaintainCount(StdMaintainProModel model);

	List getAllInterposeStdMaintainList(StdMaintainProModel model);

	void addInterposeMaintainProc(StdMaintainProModel model);

	void modifyInterposeMaintainProc(StdMaintainProModel model);

	void delInterposeMaintainProc(String maintainprocid);

	List<StdMaintainProModel> selectOperateOrderByMap(Map map);

	List<ComboxDataModel> getOperateTypeByeqsearch(String cond);

	int getAllEventMaintainProcCount(StdMaintainProModel model);

	List getAllEventMaintainProcList(StdMaintainProModel model);

	void delEventMaintainProc(String operatetypeid);

	void addEventMaintainProc(StdMaintainProModel model);

	void modifyEventMaintainProc(StdMaintainProModel model);

	List<StdMaintainProModel> selectOperateTypeByName(String operatetype);

	int getAllOperateListByUserCount(OperateList model);

	List getAllOperateListByUserList(OperateList model);

	List<StdMaintainProModel> getEventSolutionLst(InterposeModel model);

	List<HashMap> getInterposeUserListById(Map map);

	List<HashMap> getInterposeNameById(String pid);

	List<ComboxDataModel> getAlarmInfoByeqsearch(Map map);

	String getX_vendorByEquipcode(String equipcode);

	String getX_vendorNameById(String x_vendor);

	List<ComboxDataModel> getEquiptypeLst(String type);

	List<StdMaintainProModel> getStdFlowByID(String interposeid);

	List<OperateList> getUserFlowByID(Map map);

	ComboxDataModel getTransystemByEquipCode(String equipcode);

	ComboxDataModel getStationByEquipCode(String equipcode);

	ComboxDataModel getSerialsByCodes(String resourcecode,String field,
			String tablename);

	String getAlarmLevelById(String alarmid);

	void insertAlarmInfo(AlarmInfos alarmModel);

	List<ComboxDataModel> getResourceByrsearch(Map map);

	List<ComboxDataModel> getResourceNameAndID(Map map);
	
	List<ComboxDataModel> getResourceOfportNameAndID(Map map);

	String getPortSerialById(String code);

	List<InterposeModel> getInterposeAlarmList(Map map);

	String getInterposeIdsByMap(Map map);

	InterposeModel getInterposeTypeIds(String interposeid);

	void saveUserOperate(StdMaintainProModel model);
	
	List<ComboxDataModel> getFaultTypeInfoByInterposeType(String objid,String sourcecode);
	
	public String getEquipNameByEquipcode(String paraValue);

	List<ComboxDataModel> getInterposeNameByeqsearch(String projectname);

	String getPortCodeByMap(Map map);

	String getPortcode2ByPortCode1(String portcode1);

	String getEquipcodeByPortCode(String portcode2);

	String getOperateTypeByMap(Map map2);

	void deleteAlarmByMap(Map map3);
	
	void modifyInterposeConfig(InterposeModel model);

	List<InterposeModel> getInterposeAlarmConfigListByModel(InterposeModel model);

	List<OperateList> getAllOperateList();
	
	public Object getAlarmOperations(Object obj);
	
	public void delAlarmOperation(String oper_id);
	
	public void updateAlarmOperationByOperId(OperateList operation);
	
	public void insertAlarmOper(Object obj);

	String getAlarmIdsByAlarmId(String alarmid);

	List<OperateList> getAlarmTransmitByAlarmId(String alarmid);

	List getZPortCodeListByEquipcode(String equipcode);

	String getZ_EquipcodeByPortCode(String portcode);

	String getEquipSlotSerialById(String portcode);

	List<String> getInterposeIdsByAlarmMap(Map map);

	List<InterposeModel> getAllInterposeListExcel();

	List<StdMaintainProModel> getAllMantainListExcel();
	
	List getCruFaulterFlag(Map map);

	String getAlarmNameByAlarmId(String alarmId);
	
	public Object getAllFaultFunctions(Object obj);
	
	public void delFaultType(String oper_id);
	
	public void updateFaultTypeByOperId(OperateList operation);
	
	public void insertFaultType(Object obj);

	List<String> getZportCodeListByAportcode(Map map);

	List<String> getZportCodeListByPackcode(Map map);

	List<String> getInterposeIdsByEquipcode(Map map);

	StdMaintainProModel getStdMaintainProModelByType(String operatetype);

	String getInterposeIdsByAlarmModel(AlarmInfos alarmModel);
	
	void delEventInterposeCascade(String interposeId);

	String getPortcodeAndEquipcodeGroups(String resourcecode);

	ComboxDataModel getSlotSerialByPortCode(String string);

	List<String> getTopLinksByMap(Map mp);

	List<String> getEn_toplinkAndPortsByEquipcode(String eqcode);

	String getToplinkLabelByPortcode(String portcode);

	List<String> getEventIdListByEquipcode(String a_equipcode);

	List<String> getInterposeIdsByMap2(Map map);

	List<ComboxDataModel> getEquipModelBySysCode(String syscode);

	String getToplinkRateByCode(String toplinkid);

	List<InterposeModel> getToplinkLstByEquipcode(String equipcode);

	List<InterposeModel> getToplinkRateAndPortAndEquipzByEquipcode(
			String equipcode);

	void insertToplinkByModel(InterposeModel model);

	void deleteEquipmentByEquipcode(String equipcode);

	List<String> getAllBusinessRelateCircuitcode();

	List<String> getAllRelatedCircuitCode(Map m);

	List<String> getPortcodesByMap(Map m);

	List<String> getPortCodesByCCID(String ccid);

	InterposeModel getEquipcodeAndEquipName(String portcode);

	Circuit getCircuitByCircuitcode(String circuitcode);

	List<Circuit> getEquipcodeAndCounts(String circuitcode);

	String getEquipcodeByEquipName(String equipname);

	List<String> getAllPortcodeLstByID(String equipcode, String circuitcode);

	LogicPort getLogicPortInfos(String portcode);

	List<CircuitChannel> getAllRouteInfosByID(String circuitcode);

	List<AlarmInfos> getAlarmInfosByModel(AlarmInfos alarmModel);

	void deleteAlarmByEquipcode(String equipcode);

	void updateAlarmInfosByInterposeid(String interposeid);

	void deleteEn_toplinkByID(String toplinkid);

	InterposeModel getInterposeModelByID(String interposeid);

	List getAllInterposeList1(InterposeModel model);

	int getInterposeLogCount(InterposeLogModel model);

	Object getInterposeLogList(InterposeLogModel model);

	void addInterposeLogEvent(Map logMap);

	List<InterposeLogModel> getAllInterposeLogListExcel(InterposeLogModel model);

	List<Equipment> getAllEquipment();

	List<LogicPort> getAllLogicport(String equipcode);

	List<EquipPack> getAllEquippack(String equipcode);

	List<TopoLink> getAllTopLink(String equipcode);

	List<InterposeModel> getAllInterposeFaultList(String equiptype);

	void autoAddInterpose(InterposeModel model);

	List<String> getAllCircuitCode();

	List<CircuitroutModel> selectCircuitroutLstByCircuitcode(String circuitcode);

	void updateCircuitRouteByMap(Map map);

	List<ComboxDataModel> getFaultTypelst();

	String getAlarmTypeByID(String interposeid);

	void modifyInterposeInfo(String interposeid);

	List<ComboxDataModel> selectPortCutLst(Map map);

	String addInterposePortCut(InterposeModel model);

	String getPortrateByPortcode(Map mp);

	List<String> getZportCodeListByToplink(Map mp);

	List<HashMap> selectEquipPortCutLst(Map map);

	List<ComboxDataModel> getCutPortResourceByrsearch(Map map);

	List<HashMap> getPackResourceByrsearch(Map map);

	EquipPack getEquipPackInfo(String rescode);

	List<String> getPortInUseByPack(Map map);

	List<String> getPackListByTypeAndRate(Map map);

	List<String> getLogicPortNotUseByMap(Map map);

	List<HashMap> getCutPackResourceByrsearch(Map map);

	void updatePortBusinessConfig(InterposeModel model);

	List<String> getUsePortcodesByMap(Map map);

	String getPackcodeByMap(Map map);

	String getPortTypeAndRate(String toplinkid);

	List<ComboxDataModel> getEquippackBysearch(Map map);

	List<HashMap> getEquipportBysearch(Map map);

	void restructCircuitRoute(String porta, String portz);

	String getOcableNameById(String ocablecode,String type);

	List<ComboxDataModel> getFaultTypelstByMap(Map map);

	List<String> getAllEquipportByOcablecode(Map map);

	Circuit getCircuitByCircuitcode1(String circuitcode);

	void insertCircuit_equipment_cnt(Map mp);

	void deleteCircuit_equipment_cnt(Map mp);

	Circuit getCircuitInfoBycode(String circuitcode);

	void deleteCircuitRoutByCircuitcode(Map paraMap);

	void insertcallRouteGenerate(Map paraMap);

	String getAreaNameByEquipcode(String equipcode);

	void deleteEquipmentCCByEquipcode(String equipcode);

	void updateAlarmInfosByPortcode(Map map);

	EquipPack getEquipPackInfoNew(String resid);

	void updateAlarmInfosBySerials(Map m);

	String getAlarmObjByPortcode(String portcode);

	String getAlarmobjByMap(Map m);

	void updateAlarmInfosByPortcode1(Map m);

	ArrayList getAllClassicFault(String oper_id);

	void updateOperationByOperId(OperationModel oform);

	void insertOper(OperationModel oform);

	List<ClassicFaultAlarmModel> getAllClassicFaultAlarmLst(String oper_id);

	String getStationCodeByStation(String station);

	void insertClassicFaultAlarmConf(ClassicFaultAlarmModel model);

	String getEquippackModelByMap(String belongequip, String belongframe,
			String belongslot, String belongpack);

}
