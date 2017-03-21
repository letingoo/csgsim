package fiberwire.model;

public class BusinessInfoModel {
	private String business_name;
	private String username;
	private String business_id;
	private String circuitcode;

	
	public BusinessInfoModel()
	{
		business_name="";
		username="";
		business_id="";
		circuitcode="";
		
	}
	
	public String getBusiness_name() {
		return business_name;
	}
	public void setBusiness_name(String business_name) {
		this.business_name = business_name;
	}
	
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getBusiness_id() {
		return business_id;
	}
	public void setBusiness_id(String business_id) {
		this.business_id = business_id;
	}
	
	public String getCircuitcode() {
		return circuitcode;
	}
	public void setCircuitcode(String circuitcode) {
		this.circuitcode = circuitcode;
	}
	
	
	
}
