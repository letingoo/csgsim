package PressureLevel.model;

import java.util.List;

public class TopolinkItem {

	// 复用段的ID
	private String label;
	
	// 复用段的名称
	private String name;
	
	// 复用段风险值
	private double weight;
	
	
	// 复用段承载业务的个数
	private int buz_numbers;
	
	/*
	 * 业务名字的列表
	 */
	private List<String> busNameList;
	
	
	public String getLabel() {
		return label;
	}
	
	
	public double getWeight() {
		return weight;
	}
	
	public List<String> getBusNameList() {
		return busNameList;
	}
	
	public void setLabel(String label) {
		this.label = label;
	}
	
	
	public void setWeight(double weight) {
		this.weight = weight;
	}
	
	public void setBusNameList(List<String> busNameList) {
		this.busNameList = busNameList;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	
	public int getBuz_numbers() {
		return buz_numbers;
	}
	
	public void setBuz_numbers(int buz_numbers) {
		this.buz_numbers = buz_numbers;
	}
	
	
}
