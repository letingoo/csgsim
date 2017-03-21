package bussiness_route.model;

public class topolink_model {
	public String getTopocode() {
		return topocode;
	}
	public void setTopocode(String topocode) {
		this.topocode = topocode;
	}
	public String getToponame() {
		return toponame;
	}
	public void setToponame(String toponame) {
		this.toponame = toponame;
	}
	public String getEquip_a() {
		return Equip_a;
	}
	public void setEquip_a(String equip_a) {
		Equip_a = equip_a;
	}
	public String getEquip_z() {
		return Equip_z;
	}
	public void setEquip_z(String equip_z) {
		Equip_z = equip_z;
	}
	public String topocode;
	public String toponame;
	public String Equip_a;
	public String Equip_z;
	public topolink_model() {
		topocode = "";
		toponame = "";
		Equip_a = "";
		Equip_z = "";
	}
	
	
}
