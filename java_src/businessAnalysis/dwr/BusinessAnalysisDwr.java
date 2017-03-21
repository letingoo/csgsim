package businessAnalysis.dwr;

import businessAnalysis.dao.TestDao;
import java.util.HashMap;
import java.util.List;

import netres.model.ComboxDataModel;

public class BusinessAnalysisDwr {
	
	private TestDao testDao;

	public TestDao getTestDao() {
		return testDao;
	}

	public void setTestDao(TestDao testDao) {
		this.testDao = testDao;
	}
	
	public List<HashMap<Object,Object>> openProEquipA(String tranSys){
		return testDao.openProEquipA(tranSys);
	}
	public List<HashMap<Object,Object>> openProLinkA(String tranSys){
		return testDao.openProLinkA(tranSys);
	}
	public List<HashMap<Object,Object>> openProBusinessA(String tranSys){
		return testDao.openProBusinessA(tranSys);
	}
	public List<HashMap<Object,Object>> openProCircuitRouteA(String tranSys){
		return testDao.openProCircuitRouteA(tranSys);
	}
	public String nxAnalysis(int num,String netType,String type){
		List<HashMap<Object,Object>> equipA = this.testDao.openProEquipA(netType);
		List<HashMap<Object,Object>> equipB=null;
		List<HashMap<Object,Object>> linkA = this.testDao.openProLinkA(netType);
		List<HashMap<Object,Object>> linkB = null;
		List<HashMap<Object,Object>> busA = this.testDao.openProBusinessA(netType);
		List<HashMap<Object,Object>> busB = null;
		List<HashMap<Object,Object>> cirRouteA = this.testDao.openProCircuitRouteA(netType);
		List<HashMap<Object,Object>> cirRouteB = null;
		return testDao.nxAnalysis(num, netType, type, equipA, equipB, 
				linkA, linkB, busA, busB, cirRouteA, cirRouteB);
	}
    	  
	public List<HashMap<Object,Object>> getAllLog(){
		return testDao.getAllLog();
	}
	public List<HashMap<Object,Object>> getBusinessFail(List<String> temp){
		return testDao.getBusinessFail(temp);
	}
	public List<HashMap<Object,Object>> getBusinessRe(List<String> temp){
		return testDao.getBusinessRe(temp);
	}
	
	//获取传输系统
	public String getTranSystemLst(){
		String result="";
		List<ComboxDataModel>  list=testDao.getTranSystemLst();
		for(ComboxDataModel data:list){
			result+="<name label='"+data.getLabel()+"'  code='"
			+data.getId()
			+"'/>";		
		}
		
		return result;
	}
	
	public String setSelected(HashMap<Object,Object> equipObj,HashMap<Object,Object> linkObj){
		return testDao.setSelected(equipObj, linkObj);
	}
	
	public String getBusinessInfo(String business_name){
		return this.testDao.getBusinessInfo(business_name);
	}
	
}
