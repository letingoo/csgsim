package devicepanel.dao;


import java.util.List;
import java.util.Map;
import java.util.HashMap;
import devicepanel.model.*;

public interface DevicePanelDAO {
	    
	   public List getTransSystem();
	    
	   public List getEquipment(String systemcode);
	    
	   public String getDeviceModel(String equipcode);
	    
	   public List getCard(String equipcode,String flag);
	    
	   public List getCarryOperaFlex(Map map);
	    
	   public List getStatisInfoFlex(Map map);
	    
	   public List getStatisPieFlex(Map map);
	    
	   public PackInfoModel getPackInfo(Map map);
	    
	   public void updateEquipPack(Map map);

	   public List getModelList();
	   
	   public String getModelByName(Map map);
	   
	   public void addModel(Map map);
	   
	   public void updateModel(Map map);
	   
	   public Integer getModelCountByName(Map map);
	   
	   public void delModelByName(Map map);
	   
	   public List getVendor();
	   
	   public List getSlotInfo(Map map);//查看插槽业务
	   
	   public List getCarryOperaByPack(Map map);//查看插槽业务
	   
	   public List getEquipTypeByEquipCode(String equipModel);
	   
	   public String getFrameserialByEquipCode(Map map);
	   
	   public void addPack(PackInfoModel model);
	   
	   public List getEquipPackAlarm(Map equipcode);
	   
	   public String getNextPorts(String rate,Map map);

	public String getSlotDirectionByIds(Map map);
}
