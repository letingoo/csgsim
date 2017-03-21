package bussiness_route.dwr;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import netres.model.ResultModel;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import resManager.resNet.model.Equipment;
import sysManager.log.dao.LogDao;
import db.DbDAO;
import flex.messaging.FlexContext;
import bussiness_route.dao.bussiness_routeDao;
import bussiness_route.model.bussiness_route_model;
import bussiness_route.model.equip_model;
import bussiness_route.model.topolink_model;

public class bussiness_routeDwr {
	ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(FlexContext.getServletContext());
	private DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");//用于 jdbc
	private bussiness_routeDao dao;
	
	

	

	public bussiness_routeDao getDao() {
		return dao;
	}


	public void setDao(bussiness_routeDao dao) {
		this.dao = dao;
	}




	


	/**
	 * 此函数用于向前台返回查询的设备信息。
	 * 
	 * @return 返回ResultModel类型的数据。
	 * @author winstonHan
	 * @return 
	 * 
	 * */
	public ResultModel getEquip(){
		ResultModel result = new ResultModel();
		try {
//			result.setTotalCount(22333);
			List<equip_model> list=dao.getEquip();
			int temp_count=list.size();
			result.setOrderList(list);
			
//			HttpServletRequest request = FlexContext.getHttpRequest();
//			WebApplicationContext ctx = WebApplicationContextUtils
//					.getWebApplicationContext(FlexContext.getServletContext());
//			LogDao logDao = (LogDao) ctx.getBean("logDao");
//			logDao.createLogEvent("查询", "资源模块", "查询设备", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 此函数用于向前台返回查询的复用段信息。
	 * 
	 * @return 返回ResultModel类型的数据。
	 * @author winstonHan
	 * @return 
	 * 
	 * */
	public ResultModel getTopolink(){
		ResultModel result = new ResultModel();
		
		try {
//			result.setTotalCount(Bussiness_routeDao.getTopolink().size());
			List<topolink_model> list=dao.getTopolink();
			result.setOrderList(list);
//			
//			HttpServletRequest request = FlexContext.getHttpRequest();
//			WebApplicationContext ctx = WebApplicationContextUtils
//					.getWebApplicationContext(FlexContext.getServletContext());
//			LogDao logDao = (LogDao) ctx.getBean("logDao");
//			logDao.createLogEvent("查询", "资源模块", "查询复用段", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	

	/**
	 * 此函数用于向前台返回查询的业务路由信息。
	 * 
	 * @return 返回ResultModel类型的数据。
	 * @author winstonHan
	 * @return 
	 * 
	 * */	
	public ResultModel getBusRoute(){
		ResultModel result = new ResultModel();
//		System.out.print('c');
		try {
//			result.setTotalCount(Bussiness_routeDao.getBussineseRoute().size());
			List<bussiness_route_model> list=dao.getBussineseRoute();
			result.setOrderList(list);
//			
//			
//			HttpServletRequest request = FlexContext.getHttpRequest();
//			WebApplicationContext ctx = WebApplicationContextUtils
//					.getWebApplicationContext(FlexContext.getServletContext());
//			LogDao logDao = (LogDao) ctx.getBean("logDao");
//			logDao.createLogEvent("查询", "资源模块", "查询业务路由", "", request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
}
