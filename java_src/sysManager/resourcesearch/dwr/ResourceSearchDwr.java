package sysManager.resourcesearch.dwr;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import flex.messaging.FlexContext;
import sysManager.log.dao.LogDao;
import sysManager.resourcesearch.dao.ResourceSearchDao;
import sysManager.resourcesearch.model.ResultModel;
import sysManager.resourcesearch.model.Testmodel;

public class ResourceSearchDwr {
	private ResourceSearchDao resourceSearchDao;

	public void setResourceSearchDao(ResourceSearchDao resourceSearchDao) {
		this.resourceSearchDao = resourceSearchDao;
	}

	public ResourceSearchDao getResourceSearchDao() {
		return resourceSearchDao;
	}
	
	public Testmodel  testsql(String con){
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		HttpServletRequest request = FlexContext.getHttpRequest();
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", "test", "sql", "", request);
		return  this.resourceSearchDao.sqltest(con);
		
	}
	
	public List getSearchResult(String keycode){
		List resultList=new ArrayList();
		try{
			ResultModel station_result=new ResultModel();
			List stationList=this.resourceSearchDao.getStationByKeycode(keycode);
			station_result.setTotalCount(stationList.size());
			station_result.setOrderList(stationList);
			resultList.add(station_result);
			
			ResultModel equip_result=new ResultModel();
			List equipList=this.resourceSearchDao.getEquipmentByKeycode(keycode);
			equip_result.setTotalCount(equipList.size());
			equip_result.setOrderList(equipList);
			resultList.add(equip_result);
			
			ResultModel section_result=new ResultModel();
			List sectionList=this.resourceSearchDao.getSectionByKeycode(keycode);
			section_result.setTotalCount(sectionList.size());
			section_result.setOrderList(sectionList);
			resultList.add(section_result);
			
			ResultModel circuit_result=new ResultModel();
			List circuitList=this.resourceSearchDao.getCircuitBykeycode(keycode);
			circuit_result.setTotalCount(circuitList.size());
			circuit_result.setOrderList(circuitList);
			resultList.add(circuit_result);
		}catch(Exception e){
			
		}finally{
			return resultList;
		}
	}
}
