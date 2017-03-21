package businessAnalysis.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import resManager.resBusiness.model.Circuit;

import businessAnalysis.model.BusinessCircuit;
import businessAnalysis.model.CircuitEquipment;
import businessAnalysis.model.CircuitTwoequip;

public interface ReliabilityAnalysisDao {
	public List<HashMap<Object,Object>> getAllBus();
	public List<BusinessCircuit> getBCList(
			List<HashMap<Object,Object>> selectedBus);
	public List<CircuitEquipment> getCEList(
			List<BusinessCircuit> bcList);
	public List<CircuitTwoequip> getCeeList(List<BusinessCircuit> bcList);
	public List<String> getAllBusinessIDByEquip(String equipId);
	public String getEquip_Circuit_CNT(Map mp);
	public List<HashMap<Object, Object>> getAllBusByEquipcode(Map map);
	public List<String> getAllBusinessIDByEquipLst(Map map);
	public List<String> getEquip_Circuit_CNTLst(Map map);
	public List<String> getAllBusinessIDByEquipAndLinkLst(Map map);
	public List<String> getAllBusinessIDByEquipLstAndLink(Map map);
	public List<String> getAllBusinessIDByEquipLstAndLinkLst(Map map);
	public String getEquipcodesByLinkID(String linkid);
	public String getbusinessfailandrecover(Map map);
	public String getbusinessfailandrecovernew(Map map);
	public String getbusinessfailandrecovertemp(Map map);
	public String getcircuitccfailandrecover(Map map);
	public String getfailandrecoverbyids(Map map);
	public List<Circuit> getBusinessInfo(Map map);
	public List<String> getCircuitcodeByEquipCode(Map map);
}
