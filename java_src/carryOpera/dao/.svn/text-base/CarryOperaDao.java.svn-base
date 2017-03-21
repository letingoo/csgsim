package carryOpera.dao;

import java.util.HashMap;
import java.util.List;

import carryOpera.model.CarryOperaModel;

public interface CarryOperaDao {
	public int getCarryOperaCountByStationcode(String stationcode,int show);
	public List<CarryOperaModel> getCarryOperaByStationcode(String stationcode,int start,int end,int groundOpera);
	public int getCarryOperaCountByEquipcode(String equipcode,int groundOpera);//获取设备业务的个数
	public List<CarryOperaModel> getCarryOpera_Flex(String equipcode,int start,int end,int groundOpera);//查看设备业务
	//获取局站业务按业务类型分类的分析
	public List<HashMap> getStationCarryOperaSummaryByType(String stationcode,int groundOpera);
	//获取局站业务按速率分类的分析
	public List<HashMap> getStationCarryOperaSummaryByRate(String stationcode,int groundOpera);
	
	//获取设备业务按业务类型分类的分析
	public List<HashMap> getCarryOperaSummaryByType(String equipcode,int groundOpera);
	//获取设备业务按速率分类的分析
	public List<HashMap> getCarryOperaSummaryByRate(String equipcode,int groundOpera);
	public int getCarryOperaCountByLogicPort(String logicport,int groundOpera);
	
	public List<CarryOperaModel> getCarryOperaByLogicPort(String logicport,int start,int end,int groundOpera);//通过设备端口号查看设备业务信息
	public List<HashMap> getLogicportCarryOperaSummaryByType(String logicport,int groundOpera);
	//获取端口业务按速率分类的分析
	public List<HashMap> getLogicportCarryOperaSummaryByRate(String logicport,int groundOpera);
	public int getCarryOperaCountByEquipPack(String equipcode,String frameserial,String slotserial,String packserial,int groundOpera);
	public List<CarryOperaModel> getCarryOperaByEquipPack(String equipcode,String frameserial,String slotserial,String packserial,int start,int end,int groundOpera);
	public List<HashMap> getEquipPackCarryOperaSummaryByType(String equipcode,String frameserial,String slotserial, String packserial,int groundOpera);
	public List<HashMap> getEquipPackCarryOperaSummaryByRate(String equipcode,String frameserial, String slotserial, String packserial,int groundOpera);
	public int getCarryOperaCountByTopolink(String label,int groundOpera);
	public List<CarryOperaModel> getCarryOperaByTopolink(String label,int start,int end,int groundOpera);
	public List<HashMap> getOperaCountByTopolinkAndRate(String label,int groundOpera);
	
	
	
	public List<HashMap> getTopolinkCarryOperaSummaryByType(String label,int groundOpera);
	public List<HashMap> getTopolinkCarryOperaSummaryByRate(String label,int groundOpera);
	
	
	public List<HashMap> getOperaCountByStationCodeAndRate(String stationcode,int show);
	public List<HashMap> getOperaCountByEquipCodeAndRate(String equipcode,int groundOpera);
	public List<HashMap> getOperaCountByPortAndRate(String logicport,int groundOpera);
	public List<HashMap> getOperaCountByPackAndRate(String equipcode,String frameserial,String slotserial,String packserial,int groundOpera);
	
	public List<HashMap> getPortsByOcable(String ocablecode);
	public int getCarryOperaCountByTwoPort(String aendport,String zendport,int groundOpera);
	public List<CarryOperaModel> getCarrayOperaByTwoPort(String aendport,String zendport,int start,int end,int groundOpera);
	public List<HashMap> getOperaCountByPortsAndRate(String aendport,String zendport,int groundOpera);
	public List<HashMap> getFiberCarryOperaSummaryByType(String aendport,String zendport,int groundOpera);
	public List<HashMap> getFiberCarryOperaSummaryByRate(String aendport,String zendport,int groundOpera);
	public int getCarryOperaCountByLogicPortAndSlot(String portcode,
			String slotcode);
	public List getCarryOperaByLogicPortAndSlot(String portcode,
			String slotcode, int start, int end);
	public List getOperaCountByPortAndRateAndSlot(String portcode,
			String slotcode);	
}
