package ocableResources.model;

public class OcablesectionGeoModel {
	private String SECTIONCODE;
	private String GEOX;
	private String GEOY;
	private String SERIAL;
	private String ROWNO;
	private String STATUS;
	
	public OcablesectionGeoModel(){
		SECTIONCODE = "";
		GEOX = "";
		GEOY = "";
		SERIAL = "";
		ROWNO = "";
		STATUS = "";
	}

	public String getSECTIONCODE() {
		return SECTIONCODE;
	}

	public void setSECTIONCODE(String sectioncode) {
		SECTIONCODE = sectioncode;
	}

	public String getGEOX() {
		return GEOX;
	}

	public void setGEOX(String geox) {
		GEOX = geox;
	}

	public String getGEOY() {
		return GEOY;
	}

	public void setGEOY(String geoy) {
		GEOY = geoy;
	}

	public String getSERIAL() {
		return SERIAL;
	}

	public void setSERIAL(String serial) {
		SERIAL = serial;
	}

	public String getROWNO() {
		return ROWNO;
	}

	public void setROWNO(String rowno) {
		ROWNO = rowno;
	}

	public String getSTATUS() {
		return STATUS;
	}

	public void setSTATUS(String status) {
		STATUS = status;
	}

}

