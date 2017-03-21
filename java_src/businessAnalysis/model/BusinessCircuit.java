package businessAnalysis.model;


public class BusinessCircuit {
	private String business_id;
	private String business_name;
    private String circuitcode;
    
	public String getBusinessId() {
		return business_id;
	}
	public void setBusinessId(String business_id) {
		this.business_id = business_id;
	}
	public String getBusinessName() {
		return business_name;
	}
	public void setBusinessName(String business_name) {
		this.business_name = business_name;
	}
	public String getCircuitcode(){
		return circuitcode;
	}
	public void setCircuitcode(String circuitcode) {
		this.circuitcode = circuitcode;
	}
}
