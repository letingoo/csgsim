package businessAnalysis.dao;
import java.util.HashMap;
import java.util.List;

import netres.model.ComboxDataModel;
public interface TestDao {
	public List<HashMap<Object,Object>> openProEquipA(String tranSys);
	public List<HashMap<Object,Object>> openProLinkA(String tranSys);
	public List<HashMap<Object,Object>> openProBusinessA(String tranSys);
	public List<HashMap<Object,Object>> openProCircuitRouteA(String tranSys);
	
	public String nxAnalysis(int num,String netType,String type, 
			List<HashMap<Object,Object>> equipA, List<HashMap<Object,Object>> equipB,
			List<HashMap<Object,Object>> linkA, List<HashMap<Object,Object>> linkB, 
			List<HashMap<Object,Object>> busA, List<HashMap<Object,Object>> busB,
			List<HashMap<Object,Object>> cirRouteA, List<HashMap<Object,Object>> cirRouteB);
	public List<HashMap<Object,Object>> getAllLog();
	public List<HashMap<Object,Object>> getBusinessFail(List<String> temp);
	public List<HashMap<Object,Object>> getBusinessRe(List<String> temp);

	public List<ComboxDataModel> getTranSystemLst();
	
	public String setSelected(HashMap<Object,Object> equipObj,HashMap<Object,Object> linkObj);
	public String getBusinessInfo(String business_name);

}
