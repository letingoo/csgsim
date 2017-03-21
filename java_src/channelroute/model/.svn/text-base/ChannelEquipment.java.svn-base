package channelroute.model;
import java.util.ArrayList;
import java.util.List;

// TODO: Auto-generated Javadoc
/**
 * 设备对象.
 */
public class ChannelEquipment {
	
	public ChannelEquipment() {
		super();
		this.isbranchequip=false;
		this.listconnequip=new ArrayList<ChannelEquipment>();
		this.CCLinks=new ArrayList<ChannelLink>();
		this.ports=new ArrayList<ChannelPort>();
		this.TopoLinks=new ArrayList<ChannelLink>();
		this.isThin=false;
		// TODO Auto-generated constructor stub
	}

	/**
	 * 设备编号.
	 */
	private String equipcode;
	
	/**
	 * 设备名称.
	 */
	private String equipname;
	
    /**
     * 连接的设备对象  没用.
     */
    private ChannelEquipment connectequipment;
    
	/**
	 * 坐标x.
	 */
	private double x;
	
	/**
	 * 坐标y.
	 */
	private double y;
	
	/**
	 * 连接的设备列表.
	 */
	private List<ChannelEquipment> listconnequip;
	
	/**
	 * 厂家.
	 */
	private String vendor;
	
	/**
	 * 型号. 
	 */
	private String xmodel;
	
	/**
	 * 是否为支路口所在的设备.
	 */
	private boolean isbranchequip;
	
	/**
	 * 是否需重新计算.
	 */
	private boolean isreset;
	
	/**
	 * 连接设备中是否存在重新计算的设备坐标.
	 */
	private boolean hasRest;
	
	/**
	 * 经过该设备计算出坐标的对象.
	 */
	private ChannelEquipment togetherequip;
	
	
	private String systemcode;
	
	
	private String isvirtual;
	
	/**
	 * 设备内端口列表
	 */
	private List<ChannelPort> ports;
	/**
	 * 设备内部交叉时隙列表
	 */
	private List<ChannelLink> CCLinks;
	/**
	 * 设备关联的复用段列表
	 */
	private List<ChannelLink> TopoLinks;
	/**
	 * 是否设备内只有一条交叉，用来设置设备的高度
	 */
	private Boolean isThin;
	/**
	 * 父设备
	 */
	private ChannelEquipment parentEquip;
	/**
	 * 子设备
	 */
	private ChannelEquipment sonEquip;
	
	
	private String porttype;
	//设备类型：ODF\DDF
	private String equiptype;
	//设备所属的站点
	private String stationname;
	//标示是是否是拓扑
	private boolean istopo;
	//标示拓扑id
	private String topoid;
	

	/**
	 * @return the isThin
	 */
	public Boolean getIsThin() {
		return isThin;
	}

	/**
	 * @param isThin the isThin to set
	 */
	public void setIsThin(Boolean isThin) {
		this.isThin = isThin;
	}

	/**
	 * @return the topoLinks
	 */
	public List<ChannelLink> getTopoLinks() {
		return TopoLinks;
	}

	/**
	 * @param topoLinks the topoLinks to set
	 */
	public void setTopoLinks(List<ChannelLink> topoLinks) {
		TopoLinks = topoLinks;
	}

	/**
	 * @return the cCLinks
	 */
	public List<ChannelLink> getCCLinks() {
		return CCLinks;
	}

	/**
	 * @param links the cCLinks to set
	 */
	public void setCCLinks(List<ChannelLink> links) {
		CCLinks = links;
	}

	/**
	 * @return the ports
	 */
	public List<ChannelPort> getPorts() {
		return ports;
	}

	/**
	 * @param ports the ports to set
	 */
	public void setPorts(List<ChannelPort> ports) {
		this.ports = ports;
	}

	public String getIsvirtual() {
		return isvirtual;
	}

	public void setIsvirtual(String isvirtual) {
		this.isvirtual = isvirtual;
	}

	public String getSystemcode() {
		return systemcode;
	}

	public void setSystemcode(String systemcode) {
		this.systemcode = systemcode;
	}

	/**
	 * Gets the togetherequip.
	 * 
	 * @return the togetherequip
	 */
	public ChannelEquipment getTogetherequip() {
		return togetherequip;
	}
	
	/**
	 * Sets the togetherequip.
	 * 
	 * @param togetherequip the togetherequip
	 */
	public void setTogetherequip(ChannelEquipment togetherequip) {
		this.togetherequip = togetherequip;
	}
	
	/**
	 * Checks if is has rest.
	 * 
	 * @return true, if is has rest
	 */
	public boolean isHasRest() {
		return hasRest;
	}
	
	/**
	 * Sets the has rest.
	 * 
	 * @param hasRest the has rest
	 */
	public void setHasRest(boolean hasRest) {
		this.hasRest = hasRest;
	}
	
	/**
	 * Checks if is isreset.
	 * 
	 * @return true, if is isreset
	 */
	public boolean isIsreset() {
		return isreset;
	}
	
	/**
	 * Sets the isreset.
	 * 
	 * @param isreset the isreset
	 */
	public void setIsreset(boolean isreset) {
		this.isreset = isreset;
	}
	
	/**
	 * Checks if is isbranchequip.
	 * 
	 * @return true, if is isbranchequip
	 */
	public boolean isIsbranchequip() {
		return isbranchequip;
	}
	
	/**
	 * Sets the isbranchequip.
	 * 
	 * @param isbranchequip the isbranchequip
	 */
	public void setIsbranchequip(boolean isbranchequip) {
		this.isbranchequip = isbranchequip;
	}
	
	/**
	 * Gets the vendor.
	 * 
	 * @return the vendor
	 */
	public String getVendor() {
		return vendor;
	}
	
	/**
	 * Sets the vendor.
	 * 
	 * @param vendor the vendor
	 */
	public void setVendor(String vendor) {
		this.vendor = vendor;
	}
	
	/**
	 * Gets the xmodel.
	 * 
	 * @return the xmodel
	 */
	public String getXmodel() {
		return xmodel;
	}
	
	/**
	 * Sets the xmodel.
	 * 
	 * @param xmodel the xmodel
	 */
	public void setXmodel(String xmodel) {
		this.xmodel = xmodel;
	}
	
	/**
	 * Gets the equipcode.
	 * 
	 * @return the equipcode
	 */
	public String getEquipcode() {
		return equipcode;
	}
	
	/**
	 * Sets the equipcode.
	 * 
	 * @param equipcode the equipcode
	 */
	public void setEquipcode(String equipcode) {
		this.equipcode = equipcode;
	}
	
	/**
	 * Gets the equipname.
	 * 
	 * @return the equipname
	 */
	public String getEquipname() {
		return equipname;
	}
	
	/**
	 * Sets the equipname.
	 * 
	 * @param equipname the equipname
	 */
	public void setEquipname(String equipname) {
		this.equipname = equipname;
	}
    
	/**
	 * Gets the connectequipment.
	 * 
	 * @return the connectequipment
	 */
	public ChannelEquipment getConnectequipment() {
		return connectequipment;
	}
	
	/**
	 * Sets the connectequipment.
	 * 
	 * @param connectequipment the connectequipment
	 */
	public void setConnectequipment(ChannelEquipment connectequipment) {
		this.connectequipment = connectequipment;
	}
	
	/**
	 * Gets the x.
	 * 
	 * @return the X
	 */
	public double getX() {
		return x;
	}
	
	/**
	 * Sets the x.
	 * 
	 * @param x the X
	 */
	public void setX(double x) {
		this.x = x;
	}
	
	/**
	 * Gets the y.
	 * 
	 * @return the Y
	 */
	public double getY() {
		return y;
	}
	
	/**
	 * Sets the y.
	 * 
	 * @param y the Y
	 */
	public void setY(double y) {
		this.y = y;
	}
	
	/**
	 * Gets the listconnequip.
	 * 
	 * @return the listconnequip
	 */
	public List<ChannelEquipment> getListconnequip() {
		return listconnequip;
	}
	
	/**
	 * Sets the listconnequip.
	 * 
	 * @param listconnequip the listconnequip
	 */
	public void setListconnequip(List<ChannelEquipment> listconnequip) {
		this.listconnequip = listconnequip;
	}

	public ChannelEquipment getParentEquip() {
		return parentEquip;
	}

	public void setParentEquip(ChannelEquipment parentEquip) {
		this.parentEquip = parentEquip;
	}

	public ChannelEquipment getSonEquip() {
		return sonEquip;
	}

	public void setSonEquip(ChannelEquipment sonEquip) {
		this.sonEquip = sonEquip;
	}

	public String getPorttype() {
		return porttype;
	}

	public void setPorttype(String porttype) {
		this.porttype = porttype;
	}

	public String getEquiptype() {
		return equiptype;
	}

	public void setEquiptype(String equiptype) {
		this.equiptype = equiptype;
	}

	public String getStationname() {
		return stationname;
	}

	public void setStationname(String stationname) {
		this.stationname = stationname;
	}

	public boolean isIstopo() {
		return istopo;
	}

	public void setIstopo(boolean istopo) {
		this.istopo = istopo;
	}

	public String getTopoid() {
		return topoid;
	}

	public void setTopoid(String topoid) {
		this.topoid = topoid;
	}
     	
		
}