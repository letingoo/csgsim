package ocableResources.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import carryOpera.model.CarryOperaModel;

import ocableResources.model.ChannelRoutModel;
import ocableResources.model.En_Ocable_Res_Link;
import ocableResources.model.Fiber;
import ocableResources.model.FiberDetailsModel;
import ocableResources.model.MapCoordinate;
import ocableResources.model.OcableSection;
import ocableResources.model.OcablesectionGeoModel;
import ocableResources.model.OcablesectionInfoModel;
import ocableResources.model.Re_Ocable_Ressite;
import ocableResources.model.StationModel;
import ocableResources.model.TnodeModel;
import ocableResources.model.ChannelRoutResultModel;


public interface OcableResourcesDAO {
	public List getOcablesectionByVolt(String volt,String type);
	
	public List getOcablesectionByProvince(String volt,String province);
	
	public void updateStationLocation(MapCoordinate model);
	public void updateStationLabelLocation(MapCoordinate model);
	//public void updateStationLabelLocation(StationModel model);
	public void updateStationCityLabelLocation(StationModel model);
	public void updateTnodeLocation(TnodeModel model);
	public void updateStationLocationByProvince(StationModel model);
	public String getSearchStation(String searchtext);
	public String getPowerMapSearch(String searchtext);
	public String getSearchOcable(String searchtext);
	public String getSearchOneName(String searchtext);
	public List getOcablesectionVolt();
	public TnodeModel getTnodeProperty(String tnodecode);
	public List getOcablesectiongeo(String secvolt,String province);//中心拐点信息
//	public List getOcablesectiongeoByCity(String secvolt);//地市拐点信息
	public List getOcablesectionProperty();
	public List getOcablesectionByProperty(String property);
	//添加光缆
	public String addOcableSection(OcablesectionInfoModel model,ArrayList<OcablesectionGeoModel> OcableSectionGeoList);
	//删除光缆段
	public void deleteOcableSectionInfo(String ocableSectionCode);
	//添加站点
	public String addOcableSectionStation(StationModel model);
	//删除局站
	public void deleteStation(String code);
	
	public void saveOcableSectionGeo(String sectioncode,ArrayList<OcablesectionGeoModel> OcableSectionGeoList);
	
	public List getOcablesection_Sub(String sectioncode);
	public void delMixOcableBuildModel(String sectioncode);
	public void insertMixOcableBuildModel(final List lst);
	public List getOcablesection_Sub_Statis(String sectioncode);
	public List getRunUnits();
	public List getEstabList(String sectioncode);
	public List getConnectorbox(String sectioncode);
	//获得与ocablesection相关的资源点数目
	public int getRessiteCountBySectioncode(String sectioncode);
	//获得与ocablesection相关的杆塔
	public List getEstabsBySectioncode(String sectioncode);
	//获得与ocablesection相关的起止点
	public List getEndPointBySectioncode(String sectioncode);
	//获得与ocablesection相关的接头盒
	public List getConnectorsBySectioncode(String sectioncode);
	//获得与ocablesection相关的Link
	public List getLinksBySectioncode(String sectioncode);
	//saveEstanView
	public void delEstabView1(String sectioncode);
	public void delEstabView2(String sectioncode);
	public void saveEstabView1(Re_Ocable_Ressite res);
	public void saveEstabView2(En_Ocable_Res_Link link);
	//根据code查询长度
	public String getOcableLengthByCode(String sectioncode);
	public int ocableSectionCanDelete(String ocableSectionCode);
	
	//最新代码
	public List getStationInfo(String volt,String province);
	public List getTnodeInfo(String volt,String province);
	public List getOcableSectionbystation(String volt,String province);
	//wuwenqi 20110920
	public List getPorttype(String equipcode);
	public List getPortrate(String equipcode, String porttype);
	public List getPortinfo(String equipcode, String porttype, String portrate);
	//wuwenqi 20110921
	public List getEquiptype(String stationcode);
	public List getEquipvendor(String stationcode, String equiptype);
	public List getEquipmodel(String stationcode, String equiptype, String vendorcode);
	public Object getMaxRequestID();
	public List getProvinceList();
	public List getStationByProvince(String province);
	
	public void addCoordinatesByOcableSection(String stationcode,String province,String modelname,String nodex,String nodey,String labelx,String labely);
	public void deleteCoordinatesByOcableSection(String stationcode,String province,String modelname);
	
	public String addTnodebyocablesection(TnodeModel model,String province,String modelname);
	
	//删除Tnode
	public void deleteTnode(String code);
	
	public List<HashMap> getLegend(Map map);
	
	List<HashMap> selectDomainFlex();
    
	List<HashMap> selectProvinceFlex(String domain);
    
	List<HashMap> selectCityFlex(String province);
    
    @SuppressWarnings("unchecked")
	List<HashMap> selectStationFlex(String city);
    
    @SuppressWarnings("unchecked")
	List<HashMap> selectStationFlexByOcalbe(String city,String provinceParam);
    
    @SuppressWarnings("unchecked")
	List<HashMap> selectRoomFlex(String stationcode);
    
    public int getOcableSectionCountByOcableResources(OcableSection ocableSection);
    
    public List getOcableSectionByOcableResources(OcableSection ocableSection);
    
    public List getUsername();
    
    public List getRate();
    
    public List<Fiber> getFiberByOcable(String ocablecode);
    
    public Integer getCarryBusinessCount(Object obj);
    
    public List getCarryBusiness(Object obj);
    
    public String getOpticalPortByFibercode(String fibercode);
    
    public List getCarryBusinessByLogicport(Object obj);
    
    public Integer getCountCarryBusinessByLogicport(Object obj);
    
    public List getAllCarryBusinessByLogicport(String logicport);
    
    public Integer getCountAllCarryBusinessByLogicport(Object obj);
    
    public List<FiberDetailsModel> getFiberDetails(FiberDetailsModel fdm);
    
    public List<FiberDetailsModel> getFiberDetailsInfo(FiberDetailsModel fdm);
    
    public int getFiberDetailsConnt(FiberDetailsModel fdm);
    
    public List<FiberDetailsModel> getALLFiberDetails(FiberDetailsModel fdm);
    
    public List getFiberdetailsCarryBusiness(Object obj);
    
    public ChannelRoutResultModel getOcableRoutInfoByFiber(String ocablecode,String fiberserial);
    
    public List getStationNamesByByCRName(String channelroutname);
    
    public List<ChannelRoutModel> getChannelRoutDataByCRName(String channelroutname);
    
    public String getOcableList(String apointcode, String zpointcode);
    
    public void addSingleFiber(FiberDetailsModel fiberObj, int fibercount);//添加光纤
    
    public void deleteSingleFiber(String fibercode,String fiberserial,FiberDetailsModel fiberObj,int fibercount);//删除光纤
    
	public String getFiberRelateOpticaPort(String fibercode);
	public String getTopoIdByPort(String aendptp,String zendptp);
	
	public String getOcableTopoOcableInfo(String sectioncode);
	
	public String getOcableTopoFiberInfo(String sectioncode);
	
	public List<HashMap> getStationModelList();

	public List<CarryOperaModel> getAllCarryBusinessByOcableCode(
			Map map);

	public List getAllCarryBusinessByFibercode(Map map);

	public int getCountCarryBusinessByFibercode(String fibercode);

	public void updateStationLocationBylst(
			ArrayList<resManager.resNode.model.StationModel> equiplist);

	public String getOpticalIDByFibercode(String fibercode, String fiberserial);

	public String getTopolinkidByOpticalid(String opticalid);
}
