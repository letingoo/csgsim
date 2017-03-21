package devicepanel.model;

import java.util.List;

public class ResultModel {

    private int totalCount;
    private List orderList;
    private String string;
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
	public String getString() {
		return string;
	}
	public void setString(String string) {
		this.string = string;
	}

}
