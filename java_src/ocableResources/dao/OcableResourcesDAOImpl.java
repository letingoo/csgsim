package ocableResources.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ocableResources.model.ChannelRoutModel;
import ocableResources.model.ChannelRoutResultModel;
import ocableResources.model.En_Ocable_Res_Link;
import ocableResources.model.Fiber;
import ocableResources.model.FiberDetailsModel;
import ocableResources.model.MapCoordinate;
import ocableResources.model.OcableSection;
import ocableResources.model.OcableSectionSub;
import ocableResources.model.OcablesectionGeoModel;
import ocableResources.model.OcablesectionInfoModel;
import ocableResources.model.Re_Ocable_Ressite;
import ocableResources.model.StationModel;
import ocableResources.model.TnodeModel;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import carryOpera.model.CarryOperaModel;

import com.ibatis.sqlmap.client.SqlMapClient;

import fiberwire.model.EquInfoModel;


public class OcableResourcesDAOImpl extends SqlMapClientDaoSupport implements OcableResourcesDAO {
	public List getOcablesectionByVolt(String volt,String type){
		HashMap map=new HashMap();
		map.put("type", type);
    	return this.getSqlMapClientTemplate().queryForList("getOcablesectionByVolt",volt);
    }
	
	
	public List getOcablesectionByProvince(String volt,String province){
		HashMap map=new HashMap();
		map.put("volt", volt);
		map.put("province", province);
    	return this.getSqlMapClientTemplate().queryForList("getOcablesectionByProvince",map);
    }
	
	//修改局站图标位置
	public void updateStationLocation(MapCoordinate model){
		//this.getSqlMapClientTemplate().update("updateStationLocation", model);
		
		SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
			sqlMap.startTransaction();	
			List<HashMap> ls = getSqlMapClientTemplate().queryForList("getOcableCoordinates",model);
			if(ls.size() > 0){
				System.out.println(ls.size());
				this.getSqlMapClientTemplate().update("updateStationLocation", model);
			}else{
				sqlMap.insert("addOcableCoorDinates",model);
			}
			
			sqlMap.commitTransaction();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	};
	
	
	//修改局站名称位置
	public void updateStationLabelLocation(MapCoordinate model){
		//this.getSqlMapClientTemplate().update("updateStationLocation", model);
		
		SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
			sqlMap.startTransaction();	
			List<HashMap> ls = getSqlMapClientTemplate().queryForList("getOcableCoordinates",model);
			if(ls.size() > 0){
				System.out.println(ls.size());
				this.getSqlMapClientTemplate().update("updateStationLabelLocation", model);
			}else{
				sqlMap.insert("addOcableCoorDinates",model);
			}
			
			sqlMap.commitTransaction();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	};
	
	public void updateStationLocationByProvince(StationModel model){
		this.getSqlMapClientTemplate().update("updateStationLocationByProvince", model);
	};
	
//	public void updateStationLabelLocation(StationModel model){
//		this.getSqlMapClientTemplate().update("updateStationLabelLocation", model);
//	}
	
	public void updateStationCityLabelLocation(StationModel model){
		this.getSqlMapClientTemplate().update("updateStationCityLabelLocation", model);
	}
	
	
	public void updateTnodeLocation(TnodeModel model){
		this.getSqlMapClientTemplate().update("updateTnodeLocation", model);
	};
	public String getSearchStation(String searchtext) {
		List<HashMap> ls = getSqlMapClientTemplate().queryForList("getSearchStationTnode",searchtext);
		String searchXml="<Stations>";
		String detailxml="";
		for(HashMap line:ls)
		{
			detailxml+="<station><label>"+line.get("NAME")+"</label><name>"
			 +line.get("NAME")+"</name><code>"
			 +line.get("CODE")+"</code><x>"
			 +line.get("X")+"</x><y>"
			 +line.get("Y")+"</y><volt>"
			 +line.get("VOLT")+"</volt><type>"
			 +line.get("TYPE")+"</type></station>";
		}
		searchXml = searchXml + detailxml + "</Stations>";
		
		return searchXml;
	}
	
	public String getPowerMapSearch(String searchtext) {
		List<HashMap> ls = getSqlMapClientTemplate().queryForList("getPowerMapSearch",searchtext);
		String searchXml="<Stations>";
		String detailxml="";
		for(HashMap line:ls)
		{
			detailxml+="<station><label>"+line.get("NAME")+"</label><name>"
			 +line.get("NAME")+"</name><code>"
			 +line.get("CODE")+"</code><x>"
			 +line.get("X")+"</x><y>"
			 +line.get("Y")+"</y><volt>"
			 +line.get("VOLT")+"</volt><type>"
			 +line.get("TYPE")+"</type></station>";
		}
		searchXml = searchXml + detailxml + "</Stations>";
		return searchXml;
	}
	
	public String getSearchOcable(String searchtext) {
		List<HashMap> ls = getSqlMapClientTemplate().queryForList("getSearchOcable",searchtext);
		String searchXml="<Stations>";
		String detailxml="";
		for(HashMap line:ls)
		{
			detailxml+="<station><label>"+line.get("NAME")+"</label>" +
					"<name>"+line.get("NAME")+"</name>" +
					"<code>"+line.get("CODE")+"</code></station>";
		}
		searchXml = searchXml + detailxml + "</Stations>";
		
		return searchXml;
	}
	
	public String getSearchOneName(String searchtext) {
		List<HashMap> ls = getSqlMapClientTemplate().queryForList("getSearchOneName",searchtext);
		String searchXml="<Stations>";
		String detailxml="";
		for(HashMap line:ls)
		{
			detailxml+="<station><label>"+line.get("NAME")+"</label>" +
					"<name>"+line.get("NAME")+"</name>" +
					"<code>"+line.get("CODE")+"</code></station>";
		}
		searchXml = searchXml + detailxml + "</Stations>";
		
		return searchXml;
	}
	
	public List getOcablesectionVolt(){
		return this.getSqlMapClientTemplate().queryForList("getOcablesectionVolt");
	}
	
	public TnodeModel getTnodeProperty(String tnodecode){
		return (TnodeModel)this.getSqlMapClientTemplate().queryForObject("getTnodeProperty", tnodecode);
	}
	
	public List getOcablesectiongeo(String secvolt,String province){
		HashMap map=new HashMap();
		map.put("secvolt", secvolt);
		map.put("province", province);
		return this.getSqlMapClientTemplate().queryForList("getOcablesectiongeo",map);
	}
//	public List getOcablesectiongeoByCity(String secvolt){
//		return this.getSqlMapClientTemplate().queryForList("getOcablesectiongeoByCity",secvolt);
//	}
//	
	public List getOcablesectionProperty()
	{
		return this.getSqlMapClientTemplate().queryForList("getOcablesectionProperty");
	}
	public List getOcablesectionByProperty(String property)
	{
		HashMap map=new HashMap();
		map.put("property", property);
    	return this.getSqlMapClientTemplate().queryForList("getOcablesectionByProperty",map);
	}
	
	//添加光缆以及拐点信息
	//@SuppressWarnings("unchecked")
	public String addOcableSection(OcablesectionInfoModel model,ArrayList<OcablesectionGeoModel> OcableSectionGeoList)
	{
		String OcableCode="";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
			sqlMap.startTransaction();	
			sqlMap.insert("addOcableSectionInfo",model);
			OcableCode = (String)sqlMap.queryForObject("getOcableSectionCode");
			for (int j = 0; j < OcableSectionGeoList.size(); j++) 
			{
				OcablesectionGeoModel geoModel = OcableSectionGeoList.get(j);
				Map map = new HashMap();
				map.put("SECTIONCODE",OcableCode);	
				map.put("X", geoModel.getGEOX());
				map.put("Y", geoModel.getGEOY());
				map.put("SERIAL", geoModel.getSERIAL());
				map.put("STATUS", geoModel.getSTATUS());
				sqlMap.insert("addOcableSectionGeo", map);
			}
			sqlMap.commitTransaction();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
			return OcableCode;
		}
	}
	
	//删除光缆段
	public void deleteOcableSectionInfo(String ocableSectionCode){
		this.getSqlMapClientTemplate().delete("deleteOcableSectionInfo", ocableSectionCode);
		this.getSqlMapClientTemplate().delete("deleteFibers",ocableSectionCode);
	}
	
	//添加站点
	public String addOcableSectionStation(StationModel model){
		this.getSqlMapClientTemplate().insert("addOcableSectionStation",model);
		String stationcode = (String) this.getSqlMapClientTemplate().queryForObject("getOcableSectionStationCode");
		MapCoordinate coormodel = new MapCoordinate();
		coormodel.setStationcode(stationcode);
		coormodel.setNode_x(model.getGlobalx());
		coormodel.setNode_y(model.getGlobaly());
		coormodel.setProvince(model.getProvince());
		coormodel.setIstnode(model.getX_stationtype());
		this.getSqlMapClientTemplate().insert("addOcableCoorDinates",coormodel);
		return stationcode;
		//return (String) this.getSqlMapClientTemplate().queryForList("getOcableSectionStationCode");
	}
	
	//删除站点
	public void deleteStation(String code){
		this.getSqlMapClientTemplate().delete("deleteOcableStationInfo",code);
	}
	
	//保存拐点信息
	public void saveOcableSectionGeo(String sectioncode,ArrayList<OcablesectionGeoModel> OcableSectionGeoList){
		System.out.println("保存拐点信息daoimp");
		SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
			sqlMap.startTransaction();	
			//ocablecode = (String)OcableSectionGeoList.get(0).getSECTIONCODE();
			sqlMap.delete("deleteOcableSectionGeo",sectioncode);
			
			for (int j = 0; j < OcableSectionGeoList.size(); j++) 
			{
				OcablesectionGeoModel geoModel = OcableSectionGeoList.get(j);
				Map map = new HashMap();
				map.put("SECTIONCODE",sectioncode);	
				map.put("X", geoModel.getGEOX());
				map.put("Y", geoModel.getGEOY());
				map.put("SERIAL", geoModel.getSERIAL());
				map.put("STATUS", geoModel.getSTATUS());
				sqlMap.insert("addOcableSectionGeo", map);
			}
			sqlMap.commitTransaction();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}
	public List getOcablesection_Sub(String sectioncode){
		return this.getSqlMapClientTemplate().queryForList("getOcablesection_Sub", sectioncode);
	}
	public List getOcablesection_Sub_Statis(String sectioncode){
		return this.getSqlMapClientTemplate().queryForList("getOcablesection_Sub_Statis", sectioncode);
	}
	public void delMixOcableBuildModel(String sectioncode){
		this.getSqlMapClientTemplate().delete("delMixOcableBuildModel", sectioncode);
	}
	public void insertMixOcableBuildModel(final List lst){
		if(lst.size()>0){
			String sectioncode=((OcableSectionSub) lst.get(0)).getSectioncode();
			this.getSqlMapClientTemplate().delete("delMixOcableBuildModel", sectioncode);
			for (int i = 0; i < lst.size(); i++) { 
                OcableSectionSub evDto = (OcableSectionSub) lst.get(i); 
                this.getSqlMapClientTemplate().insert("insertMixOcableBuildModel", evDto); 
                } 
		}
	}
	public List getRunUnits(){
		return this.getSqlMapClientTemplate().queryForList("getRunUnits");
	}
	
	public List getEstabList(String sectioncode){
		return this.getSqlMapClientTemplate().queryForList("getEstabList", sectioncode);
	}
	public List getConnectorbox(String sectioncode){
		return this.getSqlMapClientTemplate().queryForList("getConnectorbox", sectioncode);
	}
	
	//获得与ocablesection相关的资源点数目
	public int getRessiteCountBySectioncode(String sectioncode){
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getRessiteCountBySectioncode", sectioncode);
	}
	//获得与ocablesection相关的杆塔
	public List getEstabsBySectioncode(String sectioncode){
		return this.getSqlMapClientTemplate().queryForList("getEstabsBySectioncode", sectioncode);
	}
	//获得与ocablesection相关的起止点
	public List getEndPointBySectioncode(String sectioncode){
		return this.getSqlMapClientTemplate().queryForList("getEndPointBySectioncode", sectioncode);
	}
	//获得与ocablesection相关的接头盒
	public List getConnectorsBySectioncode(String sectioncode){
		return this.getSqlMapClientTemplate().queryForList("getConnectorsBySectioncode", sectioncode);
	}
	//获得与ocablesection相关的Link
	public List getLinksBySectioncode(String sectioncode){
		return this.getSqlMapClientTemplate().queryForList("getLinksBySectioncode", sectioncode);
	}
	//saveEstabView
	public void delEstabView1(String sectioncode){
		this.getSqlMapClientTemplate().delete("delEstabView1", sectioncode);
	}
	public void delEstabView2(String sectioncode){
		this.getSqlMapClientTemplate().delete("delEstabView2", sectioncode);
	}
	public void saveEstabView1(Re_Ocable_Ressite res){
		this.getSqlMapClientTemplate().insert("saveEstabView1", res);
	}
	public void saveEstabView2(En_Ocable_Res_Link link){
		this.getSqlMapClientTemplate().insert("saveEstabView2", link);
	}
	//根据code查询光缆长度
	public String getOcableLengthByCode(String sectioncode){
		return (String)this.getSqlMapClientTemplate().queryForObject("getLengthBySectioncode", sectioncode);
	}
	/* (non-Javadoc)
	 * @see ocableResources.dao.OcableResourcesDAO#ocableSectionCanDelete(java.lang.String)
	 */
	public int ocableSectionCanDelete(String ocableSectionCode) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("ocableSectionCanDelete",ocableSectionCode);
	}
	
	//最新代码
	public List getStationInfo(String volts,String province){
		Map map = new HashMap();
		map.put("volts",volts);	
		map.put("province", province);
		return this.getSqlMapClientTemplate().queryForList("getStationInfo", map);
	}
	
	//最新代码
	public List getTnodeInfo(String volts,String province){
		Map map = new HashMap();
		map.put("volts",volts);	
		map.put("province", province);
		return this.getSqlMapClientTemplate().queryForList("getTnodeInfo", map);
	}
	
	public List getOcableSectionbystation(String volts,String province){
		Map map = new HashMap();
		map.put("volts",volts);	
		map.put("province", province);
		return this.getSqlMapClientTemplate().queryForList("getOcableSectionbystation", map);
	}
	//wuwenqi 20110920
	public List getPorttype(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getPorttype", equipcode);
	}

	public List getPortrate(String equipcode, String porttype) {
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("typecode", porttype);
		return this.getSqlMapClientTemplate().queryForList("getPortrate", map);
	}
	
	public List getPortinfo(String equipcode, String porttype, String portrate) {
		Map map = new HashMap();
		map.put("equipcode", equipcode);
		map.put("typecode", porttype);
		map.put("ratecode", portrate);
		return this.getSqlMapClientTemplate().queryForList("getPortinfo", map);
	}

	//wuwenqi 20110921
	public List getEquiptype(String stationcode) {
		return this.getSqlMapClientTemplate().queryForList("getEquiptype", stationcode);
	}
	public List getEquipvendor(String stationcode, String equiptype) {
		Map map = new HashMap();
		map.put("stationcode", stationcode);
		map.put("typecode", equiptype);
		return this.getSqlMapClientTemplate().queryForList("getEquipvendor", map);
	}
	public List getEquipmodel(String stationcode, String equiptype, String vendorcode) {
		Map map = new HashMap();
		map.put("stationcode", stationcode);
		map.put("typecode", equiptype);
		map.put("vendorcode", vendorcode);
		return this.getSqlMapClientTemplate().queryForList("getEquipmodel", map);
	}
	public Object getMaxRequestID(){
		return this.getSqlMapClientTemplate().queryForObject("getMaxRequestID");
	}
	
	public List getProvinceList(){
		return this.getSqlMapClientTemplate().queryForList("getProvinceList");
	}
	
	public List getStationByProvince(String province){
		return this.getSqlMapClientTemplate().queryForList("getStationByProvince",province);
	}
	
	public void addCoordinatesByOcableSection(String stationcode,String province,String modelname,String nodex,String nodey,String labelx,String labely){
		
		Map map = new HashMap();
		map.put("stationcode", stationcode);
		map.put("province", province);
		map.put("modelname", modelname);
		map.put("nodex", nodex);
		map.put("nodey", nodey);
		map.put("labelx", labelx);
		map.put("labely", labely);
		this.getSqlMapClientTemplate().insert("addCoordinatesByOcableSection", map);
	}
	public void deleteCoordinatesByOcableSection(String stationcode,String province,String modelname){
		Map map = new HashMap();
		map.put("stationcode", stationcode);
		map.put("province", province);
		map.put("modelname", modelname); 
		this.getSqlMapClientTemplate().insert("deleteCoordinatesByOcableSection", map);
	}
	
	public String addTnodebyocablesection(TnodeModel model,String province,String modelname){
		String code = (String) this.getSqlMapClientTemplate().insert("addTnodebyocablesection", model);
		
		Map map = new HashMap();
		map.put("stationcode", code);
		map.put("province", province);
		map.put("modelname", modelname);
		System.out.println(model.getGlobalx()+"model.getGlobalx()"+model.getGlobaly());
		map.put("nodex", model.getGlobalx());
		map.put("nodey", model.getGlobaly());
		map.put("labelx", model.getGlobalx());
		map.put("labely",Double.parseDouble(model.getGlobaly())+20*1.00);
		map.put("istnode", "0");
		this.getSqlMapClientTemplate().insert("addTnodeCoordinatesByOcableSection", map);
		return code;
	}
	
	//删除Tnode
	public void deleteTnode(String code){
		this.getSqlMapClientTemplate().delete("deleteTnode", code);
		this.getSqlMapClientTemplate().delete("deletecoordinates", code);
	}
	
	public List<HashMap> getLegend(Map map){
		List<HashMap> pros=this.getSqlMapClientTemplate().queryForList("getLegendsFromOcable", map);
		return pros;
	}
	@SuppressWarnings("unchecked")
	public List<HashMap> selectDomainFlex() {
		return getSqlMapClientTemplate().queryForList("selectDomainFlexFromOcable");
    }
    
    @SuppressWarnings("unchecked")
	public List<HashMap> selectProvinceFlex(String domain) {
    	return getSqlMapClientTemplate().queryForList("selectProvinceFlexFromOcable", domain);
    }
    
    @SuppressWarnings("unchecked")
	public List<HashMap> selectCityFlex(String province) {
    	return getSqlMapClientTemplate().queryForList("selectCityFlexFromOcable", province);
    }
    
    @SuppressWarnings("unchecked")
	public List<HashMap> selectStationFlex(String city) {
    	return getSqlMapClientTemplate().queryForList("selectStationFlexFromOcable", city);	
    }
    
    
    @SuppressWarnings("unchecked")
	public List<HashMap> selectStationFlexByOcalbe(String city,String provinceParam) {
    	HashMap map=new HashMap();
		map.put("city", city);
		map.put("provinceParam", provinceParam);
    	return getSqlMapClientTemplate().queryForList("selectStationFlexByOcalbeFromOcable", map);	
    }
    
    @SuppressWarnings("unchecked")
	public List<HashMap> selectRoomFlex(String stationcode) {
    	return getSqlMapClientTemplate().queryForList("selectRoomFlexFromOcable", stationcode);    	
    }
    
	public int getOcableSectionCountByOcableResources(
			OcableSection ocableSection) {
		return (Integer) this.getSqlMapClientTemplate().queryForObject(
				"getOcableSectionCountByOcableResourcesFromOcable", ocableSection);
	}

	public List getOcableSectionByOcableResources(OcableSection ocableSection) {
		return this.getSqlMapClientTemplate().queryForList(
				"getOcableSectionByOcableResourcesFromOcable", ocableSection);
	}
	
	public List getUsername() {
		return this.getSqlMapClientTemplate().queryForList("getUsernameFromOcable");
	}
	
	public List getRate(){
		return this.getSqlMapClientTemplate().queryForList("getBusinessRateFromOcable");
	}
	
	public List<Fiber> getFiberByOcable(String ocablecode){
		return this.getSqlMapClientTemplate().queryForList("getFiberBySectioncodeFromOcable",ocablecode);
	}
	
	public Integer getCarryBusinessCount(Object obj){
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getCarryBusinessCountFromOcable",obj);
	}
	
	public List getCarryBusiness(Object obj){
		return this.getSqlMapClientTemplate().queryForList("getCarryBusinessFromOcable",obj);
	}
	
	public String getOpticalPortByFibercode(String fibercode){
		return (String)this.getSqlMapClientTemplate().queryForObject("getOpticalPortByFibercodeFromOcable",fibercode);
	}
	
	public List getCarryBusinessByLogicport(Object obj){
		return this.getSqlMapClientTemplate().queryForList("getCarryBusinessByLogicportFromOcable",obj);
	}
	
	public Integer getCountCarryBusinessByLogicport(Object obj){
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getCountCarryBusinessByLogicportFromOcable",obj);
	}
	
	public List getAllCarryBusinessByLogicport(String logicport){
		return this.getSqlMapClientTemplate().queryForList("getAllCarryBusinessByLogicportFromOcable",logicport);
	}
	
	public Integer getCountAllCarryBusinessByLogicport(Object obj) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getCountAllCarryBusinessByLogicportFromOcable",obj);
	}
	
	// 光纤详细信息
	public List<FiberDetailsModel> getFiberDetails(FiberDetailsModel fdm) {
		return this.getSqlMapClientTemplate().queryForList("getFiberDetailsFromOcable",fdm);
	}
	
	// 光纤详细信息
	public List<FiberDetailsModel> getFiberDetailsInfo(FiberDetailsModel fdm) {
		return this.getSqlMapClientTemplate().queryForList("getFiberDetailsInfoFromOcable",
				fdm);
	}
	
	// 光纤总数
	public int getFiberDetailsConnt(FiberDetailsModel fdm) {
		return (Integer) this.getSqlMapClientTemplate().queryForObject(
				"getFiberDetailsConntFromOcable", fdm);
	}
	
	// 所有光纤信息
	public List<FiberDetailsModel> getALLFiberDetails(FiberDetailsModel fdm) {
		return this.getSqlMapClientTemplate().queryForList(
				"getFiberDetailsFromOcable", fdm);
	}
	
	public List getFiberdetailsCarryBusiness(Object obj){
		return this.getSqlMapClientTemplate().queryForList("getFiberdetailsCarryBusinessFromOcable",obj);
	}
	
	public ChannelRoutResultModel getOcableRoutInfoByFiber(String ocablecode,String fiberserial)
	{
		ChannelRoutModel crm = new ChannelRoutModel();
		crm.setFIBERSERIAL1(fiberserial);
		crm.setOCABLE1(ocablecode);
		return (ChannelRoutResultModel)this.getSqlMapClientTemplate().queryForObject("getOcableRoutInfoByFiberFromOcable",crm);
	}
	
	public List getStationNamesByByCRName(String channelroutname)
	{
		return this.getSqlMapClientTemplate().queryForList("getStationNamesByByCRNameFromOcable",channelroutname);
	}
	
	public List<ChannelRoutModel> getChannelRoutDataByCRName(String channelroutname)
	{
		return this.getSqlMapClientTemplate().queryForList("getChannelRoutDataByCRNameFromOcable",channelroutname);
	}
	
	public String getOcableList(String apointcode, String zpointcode) {
		HashMap map = new HashMap();
		map.put("apointcode", apointcode);
		map.put("zpointcode", zpointcode);
		List<HashMap> ls=getSqlMapClientTemplate().queryForList("getOcableListFromOcable",map);
		String searchXml="<Ocables>";
		String detailxml="";
		for(HashMap line:ls)
		{
			detailxml+="<ocable><label>"+line.get("OCABLENAME")+
						"</label><code>"+line.get("SECTIONCODE")+"</code></ocable>";
		}
		searchXml = searchXml + detailxml + "</Ocables>";
		//System.out.println(searchXml);
		return searchXml;
	}
	//添加光纤
	public void addSingleFiber(FiberDetailsModel fiberObj, int fibercount)
	{
		SqlMapClient sqlMap = this.getSqlMapClientTemplate().getSqlMapClient(); //this.getSqlMapClientTemplate();
		String ocablesectionname = fiberObj.getOcablesectionname();
		String sectioncode = fiberObj.getSectioncode();
		if (!ocablesectionname.equalsIgnoreCase("") && ocablesectionname != null)
		{
			int secondIndex = ocablesectionname.indexOf("芯");
			int fiberserial = Integer.parseInt(fiberObj.getFiberserial()) + 1;
			fiberObj.setFiberserial(Integer.toString(fiberserial));
			if (secondIndex != -1)
			{
				ocablesectionname = "光缆" + fibercount + ocablesectionname.substring(secondIndex); 
			}
			else 
			{
				ocablesectionname = "光缆" + fibercount + "芯";
			}
		}
		HashMap map = new HashMap();
		map.put("SECTIONCODE", sectioncode);
		map.put("FIBERCOUNT", fibercount);
		map.put("OCABLESECTIONNAME", ocablesectionname);
		
		try
		{
			sqlMap.startTransaction();
			sqlMap.insert("addSingleFiberFromOcable", fiberObj);
			sqlMap.update("updateOcableSectionFibercountFromOcable", map);
			sqlMap.update("updateFiberNamestdBySectioncodeFromOcable", sectioncode);
			sqlMap.commitTransaction();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				sqlMap.endTransaction();
			}
			catch(SQLException se)
			{
				se.printStackTrace();
			}
		}
		
	}
	
	public void deleteSingleFiber(String fibercode,String fiberserial,FiberDetailsModel fiberObj,int fibercount)
	{
//		HashMap map=new HashMap();
//		map.put("fibercode", fibercode);
//		map.put("fiberserial", fiberserial);
//		this.getSqlMapClientTemplate().delete("deleteSingleFiber", map);
		
		SqlMapClient sqlMap = this.getSqlMapClientTemplate().getSqlMapClient(); //this.getSqlMapClientTemplate();
		String ocablesectionname = fiberObj.getOcablesectionname();
		String sectioncode = fiberObj.getSectioncode();
		int count = fibercount -1;
		if (!ocablesectionname.equalsIgnoreCase("") && ocablesectionname != null)
		{
			int secondIndex = ocablesectionname.indexOf("芯");
			int fiberindex = Integer.parseInt(fiberObj.getFiberserial()) - 1 ;
			fiberObj.setFiberserial(Integer.toString(fiberindex));
			if (secondIndex != -1)
			{
				ocablesectionname = "光缆" + count + ocablesectionname.substring(secondIndex); 
			}
			else 
			{
				ocablesectionname = "光缆" + count + "芯";
			}
		}
		HashMap map = new HashMap();
		map.put("SECTIONCODE", sectioncode);
		map.put("FIBERCOUNT", count);
		map.put("OCABLESECTIONNAME", ocablesectionname);
		
		HashMap deleteMap=new HashMap();
		deleteMap.put("fibercode", fibercode);
		deleteMap.put("fiberserial", fiberserial);
		try
		{
			sqlMap.startTransaction();
			sqlMap.delete("deleteSingleFiberFromOcable",deleteMap);
			sqlMap.update("updateOcableSectionFibercountFromOcable", map);
			sqlMap.update("updateFiberNamestdBySectioncodeFromOcable", sectioncode);
			sqlMap.commitTransaction();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				sqlMap.endTransaction();
			}
			catch(SQLException se)
			{
				se.printStackTrace();
			}
		}
		
	}
	
	public String getFiberRelateOpticaPort(String fibercode){
		Map map = new HashMap();
		map.put("fibercode", fibercode);
		return (String)this.getSqlMapClientTemplate().queryForObject("getFiberRelateOpticaPortFromOcable",map);
	}
	
	public String getTopoIdByPort(String aendptp,String zendptp){
		Map map = new HashMap();
		map.put("aendptp", aendptp);
		map.put("zendptp", zendptp);
		return (String)this.getSqlMapClientTemplate().queryForObject("getTopoIdByPortFromOcable",map);
	}
	
	public String getOcableTopoOcableInfo(String sectioncode) {
		String xml="";
		HashMap ocables = (HashMap)getSqlMapClientTemplate().queryForObject("getOcableTopoOcableInfoFromOcable",sectioncode);
		if(ocables!=null){
	    xml +=  "<ocable> <col1>光缆段名</col1> <col2>"+ocables.get("OCABLESECTIONNAME")+"</col2></ocable>";
		xml +=  "<ocable> <col1>起始站点</col1> <col2>"+ocables.get("STATION_A")+"</col2></ocable>";
		xml +=  "<ocable> <col1>终止站点</col1> <col2>"+ocables.get("STATION_Z")+"</col2></ocable>";
		xml +=  "<ocable> <col1>光缆类型</col1> <col2>"+ocables.get("OCABLEMODEL")+"</col2></ocable>";
		xml +=  "<ocable> <col1>光缆长度</col1> <col2>"+ocables.get("LENGTH")+"</col2></ocable>";
		xml +=  "<ocable> <col1>敷设方式</col1> <col2>"+ocables.get("LAYMODE")+"</col2></ocable>";
		xml +=  "<ocable> <col1>修改人</col1> <col2>"+ocables.get("UPDATEPERSON")+"</col2></ocable>";
		xml +=  "<ocable> <col1>修改日期</col1> <col2>"+ocables.get("UPDATEDATE")+"</col2></ocable>";
		xml +=  "<ocable> <col1>纤芯数目</col1> <col2>"+ocables.get("FIBERCOUNT")+"</col2></ocable>";
		xml +=  "<ocable> <col1>占用光纤</col1> <col2>"+ocables.get("OCCUPYFIBERCOUNT")+"</col2></ocable>";
		xml +=  "<ocable> <col1>生产厂家</col1> <col2>"+ocables.get("X_VENDOR")+"</col2></ocable>";
		}

		return xml;
	}
	
	public String getOcableTopoFiberInfo(String sectioncode) {	
		String xml = "<fibers>";
	
		try
		{
		List<HashMap> list = getSqlMapClientTemplate().queryForList("getOcableTopoFiberInfoFromOcable",sectioncode);

		for(int i = 0; i < list.size(); i++) {
			xml += "\n"+"<fiber ocablesectionname=\""+list.get(i).get("OCABLESECTIONNAME")
			+"\" station_a=\""+list.get(i).get("STATION_A")
			+"\" station_z=\""+list.get(i).get("STATION_Z")
			+"\" fibercode=\""+list.get(i).get("FIBERCODE")
			+"\" fiberserial=\""+list.get(i).get("FIBERSERIAL")
			+"\" name_std=\""+list.get(i).get("NAME_STD")
			+"\" length=\""+list.get(i).get("LENGTH")
			+"\" property=\""+list.get(i).get("PROPERTY")
			+"\" status=\""+list.get(i).get("STATUS")
			+"\" fibermodel=\""+list.get(i).get("FIBERMODEL")
			+"\" remark=\""+list.get(i).get("REMARK")
			+"\" aendeqport=\""+list.get(i).get("AENDEQPORT")
			+"\" zendeqport=\""+list.get(i).get("ZENDEQPORT")
			+"\" aendodfport=\""+list.get(i).get("AENDODFPORT")
			+"\" zendodfport=\""+list.get(i).get("ZENDODFPORT")
			+"\" updateperson=\""+list.get(i).get("UPDATEPERSON")
			+"\" zbystatus=\""+list.get(i).get("ZBYSTATUS")//Byxujiao 2012-7-30加的主备用
			+"\" updatedate=\""+list.get(i).get("UPDATEDATE")
			+"\"></fiber>";
		}
		
		xml += "</fibers>";
		
		}
		catch(Exception e)
		{
		 e.printStackTrace();
		}
		return xml;
	}


	@Override
	public List<HashMap> getStationModelList() {
		return this.getSqlMapClientTemplate().queryForList("getStationModelList");
	}


	@Override
	public List<CarryOperaModel> getAllCarryBusinessByOcableCode(
			Map map) {
		return this.getSqlMapClientTemplate().queryForList("getAllCarryBusinessByOcableCode", map);
	}


	@Override
	public List getAllCarryBusinessByFibercode(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getAllCarryBusinessByFibercode", map);
	}


	@Override
	public int getCountCarryBusinessByFibercode(String fibercode) {
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getCountCarryBusinessByFibercode", fibercode);
	}


	@Override
	public void updateStationLocationBylst(
			ArrayList<resManager.resNode.model.StationModel> equiplist) {

		SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
			sqlMap.startTransaction();	
			for (int j = 0; j < equiplist.size(); j++) 
			{
				resManager.resNode.model.StationModel equipinfo = equiplist.get(j);
				String stationcode = equipinfo.getStationcode();
				String x = equipinfo.getLng();
				String y = equipinfo.getLat();
				Map map = new HashMap();
				map.put("x", x);
				map.put("y", y);
				map.put("stationcode", stationcode);
				int count=(Integer)sqlMap.queryForObject("getStationCountByStationcode", map);
				if (count==0)
				{
					sqlMap.insert("insertStationLocation", map);
				}
				else
				{
												
					sqlMap.update("updateStationLocationnew", map);

				}
			}
			sqlMap.commitTransaction();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}


	@Override
	public String getOpticalIDByFibercode(String fibercode, String fiberserial) {
		Map map = new HashMap();
		map.put("fibercode", fibercode);
		map.put("fiberserial", fiberserial);
		return (String) this.getSqlMapClientTemplate().queryForObject("getOpticalIDByFibercode", map);
	}


	@Override
	public String getTopolinkidByOpticalid(String opticalid) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getTopolinkidByOpticalid", opticalid);
	}
}
