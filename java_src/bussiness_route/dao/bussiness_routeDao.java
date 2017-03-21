package bussiness_route.dao;

import java.util.List;

import bussiness_route.model.bussiness_route_model;
import bussiness_route.model.equip_model;
import bussiness_route.model.topolink_model;


public interface bussiness_routeDao {
	public List<equip_model> getEquip();
	public List<topolink_model> getTopolink();
	public List<bussiness_route_model> getBussineseRoute();

}
