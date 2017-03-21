package fiberwire.dao;

import java.util.HashMap;
import java.util.List;

import netres.model.ComboxDataModel;

import fiberwire.model.EquInfoModel;
import fiberwire.model.TopoLinkModel;

public interface EquInfoDAO {
	public EquInfoModel getEquInfoByEquCode(String equCode);//根据设备编码获取设备信息
	
	public void updateEquInfo(EquInfoModel model);//更新设备信息
	public String insertEquInfo(EquInfoModel model);//添加设备信息

	public void delEquip(String equipcode);//删除设备
	public String getFromXTBM(String xtbm);//根据编码获取名称
	public String getSystems();//获取系统名称

	public List<HashMap> getCarryOperaN1(String equipcode);//查看设备业务
	

	public List<HashMap> getCarryOperaByLogicPortN1(String logicport);
	
	public List<HashMap> getCarryOperaByTopolinkN1(String label);
	
	public List<HashMap> hasEquipPack(String equipcode);
	
	public int getDeviceCountByStationcode(String stationcode);//获取站内设备列表的个数
	public List<EquInfoModel> getDeviceList_Flex(String stationcode,int start,int end);//查看设备列表
	public List<HashMap> getDeviceSummaryByVendor(String stationcode);	//获取设备按厂家分类的分析

	public List<ComboxDataModel> getProvince();
	public List<HashMap> getDeviceSummaryByType(String stationcode);

	public String getMaxCircuitcode();
	
}
