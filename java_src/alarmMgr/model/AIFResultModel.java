package alarmMgr.model;

import java.util.List;

public class AIFResultModel {

	public int totalCount;
	public List orderList;

	public AIFResultModel() {
		this.totalCount = 0;
		this.orderList = null;
	}

	/**
	 * @return the totalCount
	 */
	public int getTotalCount() {
		return totalCount;
	}

	/**
	 * @param totalCount
	 *            the totalCount to set
	 */
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	/**
	 * @return the orderList
	 */
	public List getOrderList() {
		return orderList;
	}

	/**
	 * @param orderList
	 *            the orderList to set
	 */
	public void setOrderList(List orderList) {
		this.orderList = orderList;
	}

}