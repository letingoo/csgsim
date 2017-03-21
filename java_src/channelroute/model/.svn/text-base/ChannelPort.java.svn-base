package channelroute.model;

import java.util.ArrayList;
import java.util.List;

// TODO: Auto-generated Javadoc
/**
 * 端口对象.
 */
public class ChannelPort {
	
	/**
	 * 端口编号.
	 */
	private String port;
	
	/**
	 * 时隙.
	 */
	private String slot;
	
	/**
	 * 速率.
	 */
	private String rate;
	
	/**
	 * 所属设备.
	 */
	private ChannelEquipment belongequipment;
	
	/**
	 * 真是速率.
	 */
	private String crate;
	
	/**
	 *  方向.
	 */
	private String direction;
	
	/**
	 * 端口描述.
	 */
	private String portlabel;
	
	/**
	 * 系统编码.
	 */
	private String systemcode;
	
	/**
	 * 坐标x.
	 */
	private double x;
	
	/**
	 * 坐标y.
	 */
	private double y;
	
	/**
	 * 路由名称.
	 */
	private String name;
	
	/**
	 * 和端口相连的端口列表.
	 */
	private List<ChannelPort> connectport;
	
	/**
	 * 位置.
	 */
	private int position;
	
	/**
	 * 是否是复用段的端口.
	 */
	private boolean istopo;
	
	/**
	 * 连接端口  没用.
	 */
	private String linkport;
	
	/**
	 * 复用段编号.
	 */
	private String topoid;
	
	/**
	 * 支路口.
	 */
	private boolean isbranch;
	
	/**
	 * 端口速率.
	 */
	private String portrate;
	
	/**
	 * 端口类型 
	 **/
	private String porttype;
	/**
	 * 端口真正的时隙
	 */
	private String real_slot;
	
	/**
	 * 端口详细信息
	 */
	private String portdetail;
	
	/**
	 * 是否为主用 1为主用 0为备用 2为普通
	 */
	private String islord;
	
	private String portshow;
	
	private int lowOrup;
	
	private int dslot;
	/**
	 * 是否查询过了对端复用段端口信息
	 */
	private Boolean link_searched;
	/**
	 * 端口的复用段对端端口
	 */
	private ChannelPort topoLinkPort;
/**
 * 端口的交叉对端端口
 */
	private ChannelPort ccLinkPort;
	
	/**
	 * 端口的交叉端口列表
	 */
	private List<ChannelPort> ccPortsList;
	public ChannelPort() {
		super();
		// TODO Auto-generated constructor stub
		isbranch=false;
		link_searched=false;
		position=0;
		this.connectport=new ArrayList<ChannelPort>();
		this.ccPortsList = new ArrayList<ChannelPort>();
	}

	/**
	 * @return the port
	 */
	public String getPort() {
		return port;
	}

	/**
	 * @param port the port to set
	 */
	public void setPort(String port) {
		this.port = port;
	}

	/**
	 * @return the slot
	 */
	public String getSlot() {
		return slot;
	}

	/**
	 * @param slot the slot to set
	 */
	public void setSlot(String slot) {
		this.slot = slot;
	}

	/**
	 * @return the rate
	 */
	public String getRate() {
		return rate;
	}

	/**
	 * @param rate the rate to set
	 */
	public void setRate(String rate) {
		this.rate = rate;
	}

	/**
	 * @return the belongequipment
	 */
	public ChannelEquipment getBelongequipment() {
		return belongequipment;
	}

	/**
	 * @param belongequipment the belongequipment to set
	 */
	public void setBelongequipment(ChannelEquipment belongequipment) {
		this.belongequipment = belongequipment;
	}

	/**
	 * @return the crate
	 */
	public String getCrate() {
		return crate;
	}

	/**
	 * @param crate the crate to set
	 */
	public void setCrate(String crate) {
		this.crate = crate;
	}

	/**
	 * @return the direction
	 */
	public String getDirection() {
		return direction;
	}

	/**
	 * @param direction the direction to set
	 */
	public void setDirection(String direction) {
		this.direction = direction;
	}

	/**
	 * @return the portlabel
	 */
	public String getPortlabel() {
		return portlabel;
	}

	/**
	 * @param portlabel the portlabel to set
	 */
	public void setPortlabel(String portlabel) {
		this.portlabel = portlabel;
	}

	/**
	 * @return the systemcode
	 */
	public String getSystemcode() {
		return systemcode;
	}

	/**
	 * @param systemcode the systemcode to set
	 */
	public void setSystemcode(String systemcode) {
		this.systemcode = systemcode;
	}

	/**
	 * @return the x
	 */
	public double getX() {
		return x;
	}

	/**
	 * @param x the x to set
	 */
	public void setX(double x) {
		this.x = x;
	}

	/**
	 * @return the y
	 */
	public double getY() {
		return y;
	}

	/**
	 * @param y the y to set
	 */
	public void setY(double y) {
		this.y = y;
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the connectport
	 */
	public List<ChannelPort> getConnectport() {
		return connectport;
	}

	/**
	 * @param connectport the connectport to set
	 */
	public void setConnectport(List<ChannelPort> connectport) {
		this.connectport = connectport;
	}

	/**
	 * @return the position
	 */
	public int getPosition() {
		return position;
	}

	/**
	 * @param position the position to set
	 */
	public void setPosition(int position) {
		this.position = position;
	}

	/**
	 * @return the istopo
	 */
	public boolean isIstopo() {
		return istopo;
	}

	/**
	 * @param istopo the istopo to set
	 */
	public void setIstopo(boolean istopo) {
		this.istopo = istopo;
	}

	/**
	 * @return the linkport
	 */
	public String getLinkport() {
		return linkport;
	}

	/**
	 * @param linkport the linkport to set
	 */
	public void setLinkport(String linkport) {
		this.linkport = linkport;
	}

	/**
	 * @return the topoid
	 */
	public String getTopoid() {
		return topoid;
	}

	/**
	 * @param topoid the topoid to set
	 */
	public void setTopoid(String topoid) {
		this.topoid = topoid;
	}

	/**
	 * @return the isbranch
	 */
	public boolean isIsbranch() {
		return isbranch;
	}

	/**
	 * @param isbranch the isbranch to set
	 */
	public void setIsbranch(boolean isbranch) {
		this.isbranch = isbranch;
	}

	/**
	 * @return the portrate
	 */
	public String getPortrate() {
		return portrate;
	}

	/**
	 * @param portrate the portrate to set
	 */
	public void setPortrate(String portrate) {
		this.portrate = portrate;
	}

	/**
	 * @return the real_slot
	 */
	public String getReal_slot() {
		return real_slot;
	}

	/**
	 * @param real_slot the real_slot to set
	 */
	public void setReal_slot(String real_slot) {
		this.real_slot = real_slot;
	}

	/**
	 * @return the portdetail
	 */
	public String getPortdetail() {
		return portdetail;
	}

	/**
	 * @param portdetail the portdetail to set
	 */
	public void setPortdetail(String portdetail) {
		this.portdetail = portdetail;
	}

	/**
	 * @return the islord
	 */
	public String getIslord() {
		return islord;
	}

	/**
	 * @param islord the islord to set
	 */
	public void setIslord(String islord) {
		this.islord = islord;
	}

	/**
	 * @return the portshow
	 */
	public String getPortshow() {
		return portshow;
	}

	/**
	 * @param portshow the portshow to set
	 */
	public void setPortshow(String portshow) {
		this.portshow = portshow;
	}

	/**
	 * @return the lowOrup
	 */
	public int getLowOrup() {
		return lowOrup;
	}

	/**
	 * @param lowOrup the lowOrup to set
	 */
	public void setLowOrup(int lowOrup) {
		this.lowOrup = lowOrup;
	}

	/**
	 * @return the dslot
	 */
	public int getDslot() {
		return dslot;
	}

	/**
	 * @param dslot the dslot to set
	 */
	public void setDslot(int dslot) {
		this.dslot = dslot;
	}


	/**
	 * @return the link_searched
	 */
	public Boolean getLink_searched() {
		return link_searched;
	}

	/**
	 * @param link_searched the link_searched to set
	 */
	public void setLink_searched(Boolean link_searched) {
		this.link_searched = link_searched;
	}

	public ChannelPort getTopoLinkPort() {
		return topoLinkPort;
	}

	public void setTopoLinkPort(ChannelPort topoLinkPort) {
		this.topoLinkPort = topoLinkPort;
	}

	public ChannelPort getCcLinkPort() {
		return ccLinkPort;
	}

	public void setCcLinkPort(ChannelPort ccLinkPort) {
		this.ccLinkPort = ccLinkPort;
	}

	public List<ChannelPort> getCcPortsList() {
		return ccPortsList;
	}

	public void setCcPortsList(List<ChannelPort> ccPortsList) {
		this.ccPortsList = ccPortsList;
	}

	public String getPorttype() {
		return porttype;
	}

	public void setPorttype(String porttype) {
		this.porttype = porttype;
	}
	
	
	
	
	
	
	


}