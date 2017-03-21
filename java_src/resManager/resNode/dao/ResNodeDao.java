package resManager.resNode.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


import resManager.resNode.model.EquipPack;
import resManager.resNode.model.FiberModel;
import resManager.resNode.model.OcableModel;
import resManager.resNode.model.StationModel;

import netres.model.ComboxDataModel;

import resManager.resNode.model.EquipFrame;
import resManager.resNode.model.FrameSlot;
import resManager.resNode.model.testframe;



public interface ResNodeDao {
	
	public Integer getStationCount(StationModel station);

	public List getStation(StationModel station);

	public int delStation(String stationcode);

	public List getStationType();
	
	public String getStationCodeByName(String stationName);
	
	public String getFromXTBM(String xtbm);//根据编码获取名称
	
	public List getVoltValue();
	
	public void updateStationNameStd(String stationcode);
	
	public Integer getOcableCount(OcableModel ocable);
	/**
	 * 获取机框信息的数量
	 * @param equipframe
	 * @return
	 */
	public int GetEquipFrameCount(EquipFrame equipframe);
	/**
	 * 获取机框信息
	 * @param equipframe
	 * @return
	 */
	public List GetEquipFrame(EquipFrame equipframe);
//	public List GettestFrame(testframe equipframe);


	public List getOcable(OcableModel ocable);

	public int delOcable(String ocablecode);
	
	public int updateOcableNameStd(String ocablecode);
	
	public OcableModel getEnOcableByCode(String ocablecode);
	
	public int getFibercountByOcableCode(String sectioncode);
	
	public void addFibers(final List lst);
	
	public Integer getFiberCount(FiberModel fiber);
	
	public Integer getFiberCounttest(testframe fiber);
	
	public List gettestFiber(testframe fiber) ;

	public List getFiber(FiberModel fiber);

	public int delFiber(String fibercode);
	public int addrectest(testframe fibercode);
	public int modrectest(testframe fibercode);
	public int delFibertest(String ocablename);
	
	
	/**
	 * 获取机盘的数量
	 * @return
	 */
	public int GetEquipPackCount(EquipPack equipPack);
	/**
	 * 获取机盘信息
	 * @param equipPack
	 * @return
	 */
	public List GetEquipPack(EquipPack equipPack);
	/**
	 * 添加机盘
	 * @param equipPack
	 */
	public void AddEquipPack(EquipPack equipPack);
	/**
	 * 删除机盘
	 * @param equipPack
	 * @return
	 */
	public int delEquipPack(EquipPack equipPack);
	/**
	 * 修改机盘
	 * @param equipPack
	 * @return
	 */
	public int ModifyPack(EquipPack equipPack);
	
	public List getPackModel();
	
	public List getSystemByVender(String vender);
	
	//台账的机框的添加中的选择设备
	public List getEquipByeqsearch(Map map);
	

//	public void AddEquipFrame(EquipFrame equipframe);
	//获取机框厂商
	public List<ComboxDataModel> getVender();
	//获取系统列表
//	public List<ComboxDataModel> getTransSystem();
	//通过厂商获取传输系统
//	public List<ComboxDataModel> getSystemByVender(String vender);
	//通过编码获取机架信息
//	public List<ComboxDataModel> getShelfinfoByEquip(String equipcode);
	//修改机框信息
//	public int ModifyFrame(EquipFrame equipframe);
	//根据编码获取机框厂商
	public String getEquipFrameVendorById(String vender);
	//获取机框状态BY ID
	public String getEquipFrameStateById(String frame_state);
	//获取机框型号BY ID
	public String getEquipFrameModelById(String framemodel);
	//删除机框信息
//	public int delEquipFrame(String equipcode);
	//获取机框状态列表
	public List<ComboxDataModel> getFrameState();
	//获取机框型号列表
	public List<ComboxDataModel> getFrameModel();
	//获取机槽状态列表
	public List<ComboxDataModel> getFrameSlotStatus();
	//获取机槽状态BY ID
	public String getSlotStatusById(String status);
	//获取机槽数目
	public int getFrameSlotCount(FrameSlot model);
	//获取机槽列表
	public List<FrameSlot> getEFrameSlotLst(FrameSlot model);
	//删除机槽BY ID
//	public int delFrameSlot(String equipcode);
	//获取设备名称BY ID
	public String getShelfinfoNameById(String shelfinfo);
	//获取机框名称BY ID
	public String getFramenameById(String framename);
	//获取机框序号列表
	public List<ComboxDataModel> getFrameserialByeId(String equipcode);
	//获取机框序号BY ID
	public String getFrameserialByeName_std(String id);
		
	public List<HashMap> selectDomainFlex();
	
	public List<HashMap> selectProvinceFlex(Map map);

	public List<HashMap> selectStationFlex(Map map);
	
	public List<ComboxDataModel> getLogicportserialByEquip(String equipcode);
	//add by xgyin
	public List<ComboxDataModel> getLogicportserialByEquipNew(String equipcode);
	
	public FiberModel getFiberByCode(String fibercode);
	//添加机框
	public void AddEquipFrame(EquipFrame equipframe);
	//添加机槽
	public void AddEquipSlot(FrameSlot equipslot);

	public List<ComboxDataModel> getPackModels(String equipcode);
	//修改机框
	public void modifyEquipFrame(EquipFrame frame);
	//修改机槽
	public void modifyEquipSlot(FrameSlot slot);

	public List<ComboxDataModel> getSlotserialByeIds(Map map);

	public List<ComboxDataModel> getPortseriaByIds(Map map);

	public List<EquipPack> checkPackSerial(Map map);
	
	//查询设备所属系统
	public List<HashMap> selectSystemForEquipment(Map map);
	
	//查询系统下的设备
	public List<HashMap> selectEquipmentFlex(Map map);
	
	public String getEquipCodeByName(String equipname);

	public String getProvinceByStationcode(String code);

	public List<ComboxDataModel> getOcablesearch(String cond);

	public String getAportAndZportByOcablecode(String ocablecode);

	public List<ComboxDataModel> getEquipByStationAndeqsearch(Map map);

	public List<ComboxDataModel> getFiberPortserialByEquip(String equipcode);

	public String getFiberSerialByOcablecode(String ocablecode);
}
