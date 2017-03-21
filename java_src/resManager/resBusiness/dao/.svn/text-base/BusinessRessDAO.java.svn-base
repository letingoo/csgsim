package resManager.resBusiness.dao;

import java.util.List;
import java.util.Map;

import resManager.resBusiness.model.Circuit;
import resManager.resBusiness.model.CircuitBusinessModel;
import resManager.resBusiness.model.CircuitChannel;
import netres.model.ComboxDataModel;

import resManager.resBusiness.model.BusinessRessModel;

public interface BusinessRessDAO {

	public int getRessCount(BusinessRessModel model);

	public List getRessList(BusinessRessModel model);

	public void insertRess(BusinessRessModel mo);

	public boolean deleRess(BusinessRessModel mo);

	public void updateRess(BusinessRessModel mo);
	
	/**
	 * 业务模块需要选择的电路
	 * @param map
	 * @return
	 */
	public List getCircuitBySearchText(Map map);
	public List getCircuitCodeBySearchText(Map map);
	
	public List<ComboxDataModel> getStationAByCircuitcode(String circuitcode);
	public List<ComboxDataModel> getStationZByCircuitcode(String circuitcode);
	
	public Integer getCircuitListCount(Circuit circuit);
	
	public List getCircuitList(Circuit circuit);
	
	public boolean deleteCircuit(String circuitcode);
	
	/**
	 * 根据方式单编号查看是否存在电路编号，如果存在则在电路编号后面增加"."和数字增加1
	 * @param schedulerid
	 * @return
	 */
	public String getCircuitCode(String schedulerid);
	
	public void addCircuit(Circuit circuit);
	public void modifyCircuit(Circuit circuit);
	
	/**
	 * 获取电路模块需要的站点
	 * @return
	 */
	public List<ComboxDataModel>  getStationList();
	public List<ComboxDataModel>  getX_purposeList();
	public List<ComboxDataModel>  getRateList();
	
	/**
	 *电路业务关系模块，查询数量
	 * @param circuitbusiness
	 * @return
	 */
	public int getCircuitBusinessCount(CircuitBusinessModel circuitbusiness);
	/**
	 *电路业务关系模块，查询数据列表
	 * @param circuitbusiness
	 * @return
	 */
	public List getCircuitBusinessList(CircuitBusinessModel circuitbusiness);
	/**
	 *电路业务关系模块，添加数据给电路业务关系表
	 * @param circuitbusiness
	 * @return
	 */
	public void addCircuitBusiness(CircuitBusinessModel circuitbusiness);
	/**
	 *电路业务关系模块，根据查询条件取得业务名称和业务id
	 * @param circuitbusiness
	 * @return
	 */
	public List getBusinessBySearchText(Map map);
	public List getBusinessIdBySearchText(Map map);
	
	public void modifyCircuitBusiness(CircuitBusinessModel circuitbusiness);
	public boolean deleteCircuitBusiness(Map map);
	
	public int getUnusedCCCount();
	public boolean deleteUnusedCC();
	
	public Integer MygetCircuitListCount(Circuit circuit);	
	public List MygetCircuitList(Circuit circuit);

	public List<ComboxDataModel> getSlotALstByPortcode(String portcode);
	public List<ComboxDataModel> getSlotZLstByPortcode(Map map);

	public List getCircuitChannelList(CircuitChannel model);

	public int getCircuitChannelCount(CircuitChannel model);

	public List<String> getCircuitByMapA(Map<String, String> map);

	public String getSystemCodeByPortcode(String portcode);

	public String getPortRateBycode(String portcode);

}
