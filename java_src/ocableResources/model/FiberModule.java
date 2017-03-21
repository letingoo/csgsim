package ocableResources.model;
/**
 * 说明:此类为光缆类.
 * 
 * */
public class FiberModule {
	private String ocableCode;
    private String name_std ;
    private String a_point;
    private String z_point;
    private String a_pointtype;
    private String z_pointtype;
    
    
	public String getA_pointtype() {
		return a_pointtype;
	}
	public void setA_pointtype(String a_pointtype) {
		this.a_pointtype = a_pointtype;
	}
	public String getZ_pointtype() {
		return z_pointtype;
	}
	public void setZ_pointtype(String z_pointtype) {
		this.z_pointtype = z_pointtype;
	}
	/**
	 * @return the ocableCode
	 */
	public String getOcableCode() {
		return ocableCode;
	}
	/**
	 * @param ocableCode the ocableCode to set
	 */
	public void setOcableCode(String ocableCode) {
		this.ocableCode = ocableCode;
	}
	/**
	 * @return the name_std
	 */
	public String getName_std() {
		return name_std;
	}
	/**
	 * @param nameStd the name_std to set
	 */
	public void setName_std(String nameStd) {
		name_std = nameStd;
	}
	public String getA_point() {
		return a_point;
	}
	public void setA_point(String a_point) {
		this.a_point = a_point;
	}
	public String getZ_point() {
		return z_point;
	}
	public void setZ_point(String z_point) {
		this.z_point = z_point;
	}
	
	

	
}
