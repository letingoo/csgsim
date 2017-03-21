package equipPack.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import equipPack.model.LogicPortModel;
import equipPack.model.OpticalPortDetailModel;
import equipPack.model.OpticalPortListModel;
import equipPack.model.OpticalPortStatusModel;
import equipPack.model.ParameterModel;
/**
 * 
 * @author sunjter
 *
 */
public interface EquipPackDAO {
	List getPortDetail(String equipcode);
	List getPackPortLabel(Map map);
	int getPortNum(String equipcode,String frameserial,String slotserial,String packserial);
	int getPackYewuCount(Map map);//未实现
	List getPackYewu(Map map);//承载业务
	int getPortYewuCount(String equipcode);//未实现
	List getPortYewu(Map map);//未实现
	
	List getPackAlarm(Map map);//告警信息
	List getPackStatis(Map map);//资源使用率
	List get2MPackStatus(Map map);//电口使用率
	List getEquipList(String equipcode);
	LogicPortModel getPortPropertyInfo(String port);//端口属性查询
	public String getZPort(String a_port);
	public List<HashMap> GetItemXTBM(String xtbm);
	public boolean  updatePortProperties(LogicPortModel logicpPort);
	
	public List<LogicPortModel> getLogicPortFlex(ParameterModel model);//获取端口信息
	
	/**
	 * 查询端口是否占用
	 * @param portid 逻辑端口编号
	 * @return 返回值为0:未占用；返回值大于0:占用
	 */
	public int getPortStatusFlex(String portid);
	/**
	 * 获取光口显示列表
	 * @param model 传入参数model
	 * @return OpticalPortListModel 光口列表model
	 */
	public List<OpticalPortListModel> getOpticalPortList(ParameterModel model);
	/**
	 * 根据设备编码和逻辑端口编号查询光口详情
	 * @param map 设备编码,逻辑端口编号
	 * @return OpticalPortDetailModel 光口详情model
	 */

	public 	 OpticalPortDetailModel getOpticalPortDetail(Map map);
	
	/**
	 *获取光口占用状态
	 * @param model 传入参数model
	 * @return map aptp a或者z端端口编号,aslot ,rate 速率(VC4,VC12)
	 * 
	 * logicport 
	 */

	public List<OpticalPortStatusModel> getOpticalPortStatus(String logicport);
	/**
	 * 查询端口上承载业务的电路号
	 * @param portserialno 端口号
	 * @return 电路号
	 */
	public String getPortServiceFlex(String portserialno);
	/**
	 * 获取2M端口信息
	 * @param model 传入参数model
	 * @return  LogicPortModel 端口信息model
	 */
	public List<LogicPortModel> getLogicPort2MFlex(ParameterModel model);
	/**
	 * 获取非2M端口信息
	 * @param model 传入参数model
	 * @return  LogicPortModel 端口信息model
	 */
	public List<LogicPortModel> getLogicPortNot2MFlex(ParameterModel model);
	
	/**
	 * 获取机盘端口告警
	 * 
	 */
	public List getEquipPortAlarm(String equipcode,String frameserial,String slotserial,String packserial,String user_id);
	/**
	 *gat pack's type
	 * 
	 */
	public List getPackType(String equipcode,String frameserial,String slotserial,String packserial);
	public String getPackserialByIds(String equipcode, String frameserial,
			String slotserial);
}
