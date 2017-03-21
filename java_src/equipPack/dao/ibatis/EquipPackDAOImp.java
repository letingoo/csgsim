package equipPack.dao.ibatis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import equipPack.dao.EquipPackDAO;
import equipPack.model.LogicPortModel;
import equipPack.model.OpticalPortDetailModel;
import equipPack.model.OpticalPortListModel;
import equipPack.model.OpticalPortStatusModel;
import equipPack.model.ParameterModel;


public class EquipPackDAOImp extends SqlMapClientDaoSupport implements EquipPackDAO{
	
	public int getPortNum(String equipid,String frameserial,String slotserial,String packserial)
	{
		Map map = new HashMap();
		map.put("equipcode", equipid);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial",packserial);
		return (Integer)getSqlMapClientTemplate().queryForObject("getPortNum", map);
	}

	public List getPortDetail(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getPortDetail",equipcode);
	}

	public List getPackPortLabel(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getPackPortLabel",map);
	}

	public int getPackYewuCount(Map map){
		return (Integer)getSqlMapClientTemplate().queryForObject("getPackYewuCount",map);
	}
	public List getPackYewu(Map map){
		return getSqlMapClientTemplate().queryForList("getPackYewu",map);
	}
	public int getPortYewuCount(String equipcode){
		return (Integer)getSqlMapClientTemplate().queryForObject("getPortYewuCount", equipcode);
	}
	public List getPortYewu(Map map){
		return getSqlMapClientTemplate().queryForList("getPortYewu",map);
	}



	public List getPackAlarm(Map map) {

		return this.getSqlMapClientTemplate().queryForList("getPackAlarm",map);
	}



	public List getPackStatis(Map map) {
			return getSqlMapClientTemplate().queryForList("getPackStatis",map);
	}
	
	public List get2MPackStatus(Map map) {
		return getSqlMapClientTemplate().queryForList("get2MPackStatus",map);
}

	public List getEquipList(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getEquipList",equipcode);
	}

	public List<HashMap> GetItemXTBM(String xtbm)// 系统编码列表
	{
		return this.getSqlMapClientTemplate().queryForList("getItemByXTBM",
				xtbm);
	}
	/**
	 * 
	 *机盘详情----端口属性查询
	 *
	 */
		public LogicPortModel getPortPropertyInfo(String port){
			return(LogicPortModel) this.getSqlMapClientTemplate().queryForObject("getPortPropertyInfo",port);
		}
		public boolean  updatePortProperties(LogicPortModel logicpPort){
			boolean  b ;
			try{
				this.getSqlMapClientTemplate().update("updateLogicPort", logicpPort);
				b=true;
			}catch( Exception e){
				e.printStackTrace();
				b=false;
			}
			return b;
		}
		public String getZPort(String a_port)
		{
			String z_port = "";
			
			z_port = (String)getSqlMapClientTemplate().queryForObject("getZPort", a_port);

			if (z_port == null || z_port.equals(""))
			{
				z_port = (String)getSqlMapClientTemplate().queryForObject("getAPort", a_port);
			}
			
			return z_port;
		}
	
	//获取端口信息
	@SuppressWarnings("unchecked")
	public List<LogicPortModel> getLogicPortFlex(ParameterModel model){
		return this.getSqlMapClientTemplate().queryForList("getLogicPortFlex", model);
	}
	//查询端口是否占用
	public int getPortStatusFlex(String portid){
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getPortStatusFlex",portid);
	}

	// 获取光口显示列表
	@SuppressWarnings("unchecked")
	public List<OpticalPortListModel> getOpticalPortList(ParameterModel model){
		return this.getSqlMapClientTemplate().queryForList("getOpticalPortList",model);
	}
	// 根据设备编码和逻辑端口编号查询光口详情
	public 	 OpticalPortDetailModel getOpticalPortDetail(Map map){
		return (OpticalPortDetailModel)this.getSqlMapClientTemplate().queryForObject("getOpticalPortDetail",map);
	}
	//获取光口占用状态
	public List<OpticalPortStatusModel> getOpticalPortStatus(String logicport){
		return this.getSqlMapClientTemplate().queryForList("getOpticalPortStatus",logicport);
	}
	//查询端口上承载业务的电路号
	public String getPortServiceFlex(String portserialno){
		return (String)this.getSqlMapClientTemplate().queryForObject("getPortServiceFlex",portserialno);
	}
	 //获取2M端口信息
	public List<LogicPortModel> getLogicPort2MFlex(ParameterModel model){
		return this.getSqlMapClientTemplate().queryForList("getLogicPort2MFlex", model);
	}
	 //获取非2M端口信息
	public List<LogicPortModel> getLogicPortNot2MFlex(ParameterModel model){
		return this.getSqlMapClientTemplate().queryForList("getLogicPortNot2MFlex", model);
	}
	
	/**
	 * 获取机盘端口告警
	 * 
	 */
	public List getEquipPortAlarm(String equipcode,String frameserial,String slotserial,String packserial,String user_id){
		Map map=new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		map.put("alarmman", user_id);
		return this.getSqlMapClientTemplate().queryForList("getEquipPortAlarm", map);
	}
	/**
	 * get pack's type
	 */
	public List getPackType(String equipcode,String frameserial,String slotserial,String packserial){
		Map map=new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		return this.getSqlMapClientTemplate().queryForList("getPackType", map);
	}

	@Override
	public String getPackserialByIds(String equipcode, String frameserial,
			String slotserial) {
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		return (String) this.getSqlMapClientTemplate().queryForObject("getPackserialByIds", map);
	}
}
