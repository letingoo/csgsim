package com.metarnet.mnt.rootalarm.model;

import java.util.ArrayList;

import flex.messaging.io.ArrayCollection;

public class ChangeZDResultModel {
	private String result;
	private int sum;
	private int sucess;
	private int fault;
	private ArrayCollection ac;

	public int getSum() {
		return sum;
	}

	public void setSum(int sum) {
		this.sum = sum;
	}

	public int getSucess() {
		return sucess;
	}

	public void setSucess(int sucess) {
		this.sucess = sucess;
	}

	public int getFault() {
		return fault;
	}

	public void setFault(int fault) {
		this.fault = fault;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public ArrayCollection getAc() {
		return ac;
	}

	public void setAc(ArrayCollection ac) {
		this.ac = ac;
	}
}
