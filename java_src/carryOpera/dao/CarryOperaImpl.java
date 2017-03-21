package carryOpera.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import carryOpera.model.CarryOperaModel;
public class CarryOperaImpl extends SqlMapClientDaoSupport implements CarryOperaDao {
	@SuppressWarnings("unchecked")
	public List<CarryOperaModel> getCarryOperaByStationcode(String stationcode,int start,int end,int show)
	{
		HashMap map=new HashMap();
		map.put("stationcode", stationcode);
		map.put("start", start);
		map.put("end", end);
		if(show==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaByStationcode", map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getCarryOperaByStationcode",map);
		}
		
	}
	
	public int getCarryOperaCountByEquipcode(String equipcode,int groundOpera)//获取设备业务的个数
	{
		if(groundOpera==1)
		{
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getGroundOperaCountByEquipcode", equipcode);
		}
		else
		{
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getCarryOperaCountByEquipcode", equipcode);
		}
	}
	//查看设备业务
	@SuppressWarnings("unchecked")
	public List<CarryOperaModel> getCarryOpera_Flex(String equipcode,int start,int end,int groundOpera){
		HashMap map=new HashMap();
		map.put("equipcode", equipcode);
		map.put("start", start);
		map.put("end", end);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaByEquipcode", map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getCarryOpera_Flex",map);
		}
		
	}
	//获取局站业务按业务类型分类的分析
	public List<HashMap> getStationCarryOperaSummaryByType(String stationcode,int groundOpera)
	{
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getStationGroundOperaSummaryByType", stationcode);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getStationCarryOperaSummaryByType",stationcode);
		}
		
	}
	//获取局站业务按速率分类的分析
	public List<HashMap> getStationCarryOperaSummaryByRate(String stationcode,int groundOpera)
	{
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getStationGroundOperaSummaryByRate", stationcode);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getStationCarryOperaSummaryByRate",stationcode);
		}
		
	}
	//获取设备业务按业务类型分类的分析
	public List<HashMap> getCarryOperaSummaryByType(String equipcode,int groundOpera)
	{
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaSummaryByType",equipcode);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getCarryOperaSummaryByType",equipcode);
		}
		
	}
	//获取设备业务按速率分类的分析
	public List<HashMap> getCarryOperaSummaryByRate(String equipcode,int groundOpera)
	{
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaSummaryByRate",equipcode);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getCarryOperaSummaryByRate",equipcode);
		}
		
	}
	public int getCarryOperaCountByLogicPort(String logicport,int groundOpera)
	{
		if(groundOpera==1)
		{
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getGroundOperaCountByLogicPort", logicport);
		}
		else
		{
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getCarryOperaCountByLogicPort", logicport);
		}
		
	}
	public List<CarryOperaModel> getCarryOperaByLogicPort(String logicport,int start,int end,int groundOpera)//通过设备端口号查看设备业务信息
	{
		HashMap map=new HashMap();
		map.put("logicport", logicport);
		map.put("start", start);
		map.put("end", end);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaByLogicPort",map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getCarryOperaByLogicPort",map);
		}
		
	}
	//获取端口业务按业务类型分类的分析
	public List<HashMap> getLogicportCarryOperaSummaryByType(String logicport,int groundOpera)
	{
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getLogicportGroundOperaSummaryByType",logicport);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getLogicportCarryOperaSummaryByType",logicport);
		}
		
	}
	//获取端口业务按速率分类的分析
	public List<HashMap> getLogicportCarryOperaSummaryByRate(String logicport,int groundOpera)
	{
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getLogicportGroundOperaSummaryByRate", logicport);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getLogicportCarryOperaSummaryByRate", logicport);
		}
		
	}
	public List<HashMap> getCarryOperaByLogicPortN1(String logicport)//通过设备端口号查看设备业务信息
	{
		return this.getSqlMapClientTemplate().queryForList("getCarryOperaByLogicPortN1",logicport);
	}
	
	public int getCarryOperaCountByEquipPack(String equipcode,String frameserial,String slotserial,String packserial,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		if(groundOpera==1)
		{
			return (Integer) this.getSqlMapClientTemplate().queryForObject("getGroundOperaCountByEquipPack", map);
		}
		else
		{
			return (Integer) this.getSqlMapClientTemplate().queryForObject("getCarryOperaCountByEquipPack", map);
		}
		
	}
	public List<CarryOperaModel> getCarryOperaByEquipPack(String equipcode,String frameserial,String slotserial,String packserial,int start,int end,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		map.put("start", start);
		map.put("end", end);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaByEquipPack",map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getCarryOperaByEquipPack",map);
		}
		
	}
	
	public List<HashMap> getEquipPackCarryOperaSummaryByType(String equipcode,String frameserial,String slotserial, String packserial,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getEquipPackGroundOperaSummaryByType", map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getEquipPackCarryOperaSummaryByType", map);
		}
		
	}
	public List<HashMap> getEquipPackCarryOperaSummaryByRate(String equipcode,String frameserial, String slotserial, String packserial,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getEquipPackGroundOperaSummaryByRate", map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getEquipPackCarryOperaSummaryByRate", map);
		}
		
	}
	public int getCarryOperaCountByTopolink(String label,int groundOpera)
	{
		if(groundOpera==1)
		{
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getGroundOperaCountByTopolink", label);
		}
		else
		{
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getCarryOperaCountByTopolink",label);
		}
		
		
	}
	public List<CarryOperaModel> getCarryOperaByTopolink(String label,int start,int end,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("label", label);
		map.put("start", start);
		map.put("end", end);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaByTopoLink",map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getCarryOperaByTopoLink",map);
		}
		
	}
	public List<HashMap> getOperaCountByTopolinkAndRate(String label,int groundOpera)
	{
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaCountByTopolinkAndRate",label);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getOperaCountByTopolinkAndRate",label);
		}
		
	}
	public List<HashMap> getTopolinkCarryOperaSummaryByType(String label,int groundOpera)
	{
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getTopolinkGroundOperaSummaryByType", label);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getTopolinkCarryOperaSummaryByType", label);
		}
		
	}
	public List<HashMap> getTopolinkCarryOperaSummaryByRate(String label,int groundOpera)
	{
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getTopolinkGroundOperaSummaryByRate", label);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getTopolinkCarryOperaSummaryByRate", label);
		}
		
	}
	public List<HashMap> getOperaCountByStationCodeAndRate(String stationcode,int show)
	{
		if(show==1)
		{
		
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaCountByStationCodeAndRate", stationcode);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getOperaCountByStationCodeAndRate", stationcode);
		}
		
	}
	public List<HashMap> getOperaCountByEquipCodeAndRate(String equipcode,int groundOprea)
	{
		if(groundOprea==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaCountByEquipCodeAndRate",equipcode);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getOperaCountByEquipCodeAndRate",equipcode);
		}
		
	}
	public List<HashMap> getOperaCountByPortAndRate(String logicport,int groundOpera)
	{
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaCountByPortAndRate",logicport);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getOperaCountByPortAndRate",logicport);
		}
		
	}
	public List<HashMap> getOperaCountByPackAndRate(String equipcode,String frameserial,String slotserial,String packserial,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("equipcode", equipcode);
		map.put("frameserial", frameserial);
		map.put("slotserial", slotserial);
		map.put("packserial", packserial);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaCountByPackAndRate",map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getOperaCountByPackAndRate",map);
		}
		
	}
	public int getCarryOperaCountByTwoPort(String aendport,String zendport,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("aendport", aendport);
		map.put("zendport",zendport);
		if(groundOpera==1)
		{
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getGroundOperaCountByTwoPort", map);
		}
		else
		{
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getCarryOperaCountByTwoPort", map);
		}
		
	}
	public List<CarryOperaModel> getCarrayOperaByTwoPort(String aendport,String zendport,int start,int end,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("aendport", aendport);
		map.put("zendport",zendport);
		map.put("start", start);
		map.put("end", end);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaByTwoPort", map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getCarrayOperaByTwoPort", map);
		}
		
	}
	public List<HashMap> getOperaCountByPortsAndRate(String aendport,String zendport,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("aendport", aendport);
		map.put("zendport",zendport);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getGroundOperaCountByPortsAndRate", map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getOperaCountByPortsAndRate", map);
		}
		
	}
	public List<HashMap> getFiberCarryOperaSummaryByType(String aendport,String zendport,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("aendport", aendport);
		map.put("zendport",zendport);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getFiberGroundOperaSummaryByType",map);
			
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getFiberCarryOperaSummaryByType", map);
		}
		
	}
	public List<HashMap> getFiberCarryOperaSummaryByRate(String aendport,String zendport,int groundOpera)
	{
		HashMap map=new HashMap();
		map.put("aendport", aendport);
		map.put("zendport",zendport);
		if(groundOpera==1)
		{
			return this.getSqlMapClientTemplate().queryForList("getFiberGroundOperaSummaryByRate", map);
		}
		else
		{
			return this.getSqlMapClientTemplate().queryForList("getFiberCarryOperaSummaryByRate", map);
		}
		
	}
	public List<HashMap> getPortsByOcable(String ocablecode)
	{
		return this.getSqlMapClientTemplate().queryForList("getPortsByOcable", ocablecode);
	}
	public int getCarryOperaCountByStationcode(String stationcode,int show)
	{
		if(show==1)
		{
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getGroundOperaCountByStationcode", stationcode);
		}
		else
		{
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getCarryOperaCountByStationcode", stationcode);
		}
		
	}

	@Override
	public List getCarryOperaByLogicPortAndSlot(String portcode,
			String slotcode, int start, int end) {
		Map map = new HashMap();
		map.put("portcode", portcode);
		map.put("slotcode", slotcode);
		map.put("start", start);
		map.put("end", end);
		return this.getSqlMapClientTemplate().queryForList("getCarryOperaByLogicPortAndSlot", map);
	}

	@Override
	public int getCarryOperaCountByLogicPortAndSlot(String portcode,
			String slotcode) {
		Map map = new HashMap();
		map.put("portcode", portcode);
		map.put("slotcode", slotcode);
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getCarryOperaCountByLogicPortAndSlot", map);
	}

	@Override
	public List getOperaCountByPortAndRateAndSlot(String portcode,
			String slotcode) {
		Map map = new HashMap();
		map.put("portcode", portcode);
		map.put("slotcode", slotcode);
		return this.getSqlMapClientTemplate().queryForList("getOperaCountByPortAndRateAndSlot", map);
	}
}
