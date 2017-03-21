package bussiness_route.model;

public class equip_model {
	public String equipcode;
	public String equipname;
	public int X;
	public int Y;
	
	public equip_model(){
		equipcode="";
		equipname="";
		X=1;
		Y=1;
	}

	public String getEquipcode() {
		return equipcode;
	}

	public void setEquipcode(String equipcode) {
		this.equipcode = equipcode;
	}

	public String getEquipname() {
		return equipname;
	}

	public void setEquipname(String equipname) {
		this.equipname = equipname;
	}

	public int getX() {
		return X;
	}

	public void setX(int x) {
		X = x;
	}

	public int getY() {
		return Y;
	}

	public void setY(int y) {
		Y = y;
	}
}
