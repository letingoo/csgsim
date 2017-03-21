package sysManager.resourcesearch.dao;
import sysManager.resourcesearch.model.Testmodel;
import java.util.List;

public interface ResourceSearchDao {
	public List getStationByKeycode(String keycode);
	public List getEquipmentByKeycode(String keycode);
	public List getSectionByKeycode(String keycode);
	public List getCircuitBykeycode(String keycode);
	public Testmodel sqltest(String keycode);
	 
}
