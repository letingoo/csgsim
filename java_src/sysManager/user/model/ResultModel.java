package sysManager.user.model;

import java.util.List;

public class ResultModel {

    private int totalCount;
    private List orderList;
    
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public List getOrderList() {
		return orderList;
	}
	public void setOrderList(List orderList) {
		this.orderList = orderList;
	}

}