package ocableResources.model;

import java.util.List;

public class FiberDetailsResultModel {
	private List acdatas;
  private String datas;
  private int datascounts;

  
public String getDatas() {
	return datas;
}
public void setDatas(String datas) {
	this.datas = datas;
}
/**
 * @return the datascounts
 */
public int getDatascounts() {
	return datascounts;
}
/**
 * @param datascounts the datascounts to set
 */
public void setDatascounts(int datascounts) {
	this.datascounts = datascounts;
}
public List getAcdatas() {
	return acdatas;
}
public void setAcdatas(List acdatas) {
	this.acdatas = acdatas;
}
}
