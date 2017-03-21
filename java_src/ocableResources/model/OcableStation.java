package ocableResources.model;
import java.util.List;
/**
 * 局站或T接对象
 */
public class OcableStation {
	
	/** 局站或T接编码*/
	private String stationcode;
	
	/**局站或T接名称*/
	private String stationname;
	
	/** 标记  station:局站  tnode：T接*/
	private String type;
	
	/** 局站或T接坐标X*/
	private double x;
	
	/** 局站或T接坐标y*/
	private double y;
	
	/** 连接的局站或T接列表*/
	private List<OcableStation> listconnstation;
	
	/** 局站顺序  */
	private int position;
	
	
	
	public int getPosition() {
		return position;
	}

	public void setPosition(int position) {
		this.position = position;
	}

	public String getStationcode() {
		return stationcode;
	}

	public void setStationcode(String stationcode) {
		this.stationcode = stationcode;
	}

	public String getStationname() {
		return stationname;
	}

	public void setStationname(String stationname) {
		this.stationname = stationname;
	}

	public double getX() {
		return x;
	}

	public void setX(double x) {
		this.x = x;
	}

	public double getY() {
		return y;
	}

	public void setY(double y) {
		this.y = y;
	}

	public List<OcableStation> getListconnstation() {
		return listconnstation;
	}

	public void setListconnstation(List<OcableStation> listconnstation) {
		this.listconnstation = listconnstation;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
}
