package  channelroute.dao;

import java.util.List;

import netres.model.ComboxDataModel;


import channelroute.model.ChannelRouteDetailModel;
import channelroute.model.Circuit;


public interface ChannelRouteDAO {
	//树的实现
	@SuppressWarnings("unchecked")
	public List getChannelRouteNames(String string);
	
	//详情的实现；
	public ChannelRouteDetailModel getChannelRouteDetailModel(String itemid);
	/**添加电路重点监控
	 * @param circuitcode
	 */
	public void addCircuitmonitoring(String circuitcode); 
	/**取消电路重点监控
	 * @param circuitcode
	 */
	public void delCircuitmonitoring(String circuitcode);
	
}
