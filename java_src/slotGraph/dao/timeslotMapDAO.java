package slotGraph.dao;

import java.util.HashMap;
import java.util.List;



public interface timeslotMapDAO {
	/**获取当前系统下的复用段的所有速率
	 * @param pid
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap> getTimeSlotSecondLayerTreeNode(String pid);
	/**获取当前系统下固定速率下的复用段
	 * @param str
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap> getThirdLayerTreeNode(String str);

}
