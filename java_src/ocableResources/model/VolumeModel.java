package ocableResources.model;

public class VolumeModel {
	private String portcode;
	private String porttype;
	public String slotserial;
	public String packserial;
	private String portserial;
	private String linecount;
	private String frameserial;
	
	
	public String getLinecount() {
		return linecount;
	}
	public void setLinecount(String linecount) {
		this.linecount = linecount;
	}
	public String getFrameserial() {
		return frameserial;
	}
	public void setFrameserial(String frameserial) {
		this.frameserial = frameserial;
	}
	public String getPortserial() {
		return portserial;
	}
	public void setPortserial(String portserial) {
		this.portserial = portserial;
	}
	public String getPortcode() {
		return portcode;
	}
	public void setPortcode(String portcode) {
		this.portcode = portcode;
	}
	public String getPorttype() {
		return porttype;
	}
	public void setPorttype(String porttype) {
		this.porttype = porttype;
	}
	public String getSlotserial() {
		return slotserial;
	}
	public void setSlotserial(String slotserial) {
		this.slotserial = slotserial;
	}
	public String getPackserial() {
		return packserial;
	}
	public void setPackserial(String packserial) {
		this.packserial = packserial;
	}
}
