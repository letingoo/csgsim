package fiberwire.dwr;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileFilter;
import javax.xml.parsers.ParserConfigurationException;

import jxl.Workbook;
import jxl.format.Border;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableImage;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import resManager.resNode.dao.ResNodeDao;
import resManager.resNode.model.EquipFrame;
import resManager.resNode.model.FrameSlot;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.xml.sax.SAXException;

import sysManager.log.dao.LogDao;
import sysManager.user.model.UserModel;
import twaver.Consts;
import twaver.DataBox;
import twaver.ElementBox;
import twaver.Follower;
import twaver.Layer;
import twaver.Link;
import twaver.Node;
import twaver.SerializationSettings;
import twaver.Styles;
import twaver.XMLSerializer;
import businessDispatch.model.ResultModel;
import channelroute.model.ChannelEquipment;
import channelroute.model.ChannelPort;

import com.StopTask;

import db.DbDAO;
import devicepanel.dwr.DevicePanelDwr;
import fiberwire.dao.FiberWireDAO;
import fiberwire.model.ChannelRoutModel;
import fiberwire.model.ChannelRoutResultModel;
import fiberwire.model.EquInfoModel;
import fiberwire.model.OcableRoutInfoData;
import fiberwire.model.PortInfo;
import fiberwire.model.SystemInfoModel;
import flex.messaging.FlexContext;
import fiberwire.model.BusinessInfoModel;
import topolink.dwr.topolinkDwr;

;
// 供ActionScript直接调用的java类
/**
 * @author yangzhong
 * 
 */
public class FiberWireDwr {

	FiberWireDAO fiberWireDao;

	public FiberWireDAO getFiberWireDao() {
		return fiberWireDao;

	}

	public void setFiberWireDao(FiberWireDAO fiberWireDao) {
		this.fiberWireDao = fiberWireDao;
	}

	ApplicationContext ctx = WebApplicationContextUtils
			.getWebApplicationContext(FlexContext.getServletContext());
	private ResNodeDao resNodeDao = (ResNodeDao) ctx.getBean("resNodeDao");
	private DbDAO basedao = (DbDAO) ctx.getBean("DbDAO");

	/**
	 * 端口对象
	 */
	private ChannelPort channelport = null;
	/**
	 * 端口在设备上的左侧的上中下三个位置
	 */
	int[] position = new int[] { 1, 2, 3 };
	/**
	 * 设备对象
	 */
	private ChannelEquipment channelequipment = null;
	/**
	 * 端口LIST
	 */
	private List portlist = null;

	/**
	 * 设备坐标
	 */
	int x = 80;

	/**
	 * 设备坐标
	 */
	int y = 150;
	boolean isHasCc = true;
	/**
	 * 端口相对设备的x坐标
	 */
	double[] port_x = new double[] { 24.86, 60.1, 93.1 };
	/**
	 * 端口相对设备的y坐标
	 */
	double[] port_y = new double[] { 30.25, 66, 95 };
	/**
	 * 设备列表
	 */
	private List equipList = null;
	double dx = 340.95;
	/**
	 * 设备坐标偏移量
	 */
	int dy = 500;
	int RepetiveTimes = 1000;

	public String getPortCodeByOpticalid(String opticalcode, String busitype) {

		String portcode = "";
		if ("复用段业务".equals(busitype)) {
			portcode = (String) this.basedao.queryForObject(
					"getPortCodeByOpticalcode", opticalcode);
		} else {
			List<String> lst = this.basedao.queryForList(
					"getPortcodelstByOpticalid", opticalcode);
			if (lst != null && lst.size() == 2) {
				portcode = lst.get(0) + "," + lst.get(1);
			}
		}
		return portcode;
	}

	// -----前台调用画图
	public String getOcableRoutInfo(String portcode) {

		// 录入MATRIX_STOS表数据，相当于电路路由的交叉
		// this.insertMatrix_stosInfos();
		// 调用存储过程
		// List<String> opticalIdlst =
		// this.basedao.queryForList("getOpticalIdLst", null);
		// for(int i=0;i<opticalIdlst.size();i++){
		// String opticalcode = opticalIdlst.get(i);
		// this.basedao.queryForList("insertopticalroute", opticalcode);
		// }
		// String opticalcode = "00000000000500199407";
		// this.basedao.queryForList("insertopticalroute", opticalcode);

		String xml = "";
		try {
			// Map map = null;
			String[] arr;
			if (portcode.indexOf(",") != -1) {
				arr = portcode.split(",");
			} else {
				arr = new String[] { portcode };
			}
			List<String> lst = new ArrayList<String>();
			for (int j = 0; j < arr.length; j++) {
				if (!lst.contains(arr[j])) {
					lst.add(arr[j]);
				}
			}
			String port = lst.get(0);
			String porttype = "";
			porttype = "equipport";
			// 如果当前端口为ODF端口则为odf
			String equiptype = (String) this.basedao.queryForObject(
					"getEquiptypeByPort", port);
			if ("ODF设备".equals(equiptype)) {
				porttype = "odf";
			}
			Map m = new HashMap();
			m.put("portlst", lst);
			System.out.println("设备口" + portcode + "为入口！！！");
			List<HashMap> maplst = (List<HashMap>) basedao.queryForList(
					"selectEQUIPMENTPortInfoByPortCode", m);
			portlist = new ArrayList();
			for (int i = 0; i < maplst.size(); i++) {
				Map map = maplst.get(i);
				if (map != null) {
					channelport = new ChannelPort();
					// 端口号
					channelport.setPort((String) map.get("PORT"));
					// 端口类型
					channelport.setPorttype((String) porttype);
					// 前台绘制端口的内容
					channelport.setPortlabel((String) map.get("PORTLABEL"));
					channelport.setName("test");
					channelport.setPosition(position[1]);
					// 前台显示端口的冒泡提示
					channelport.setPortdetail((String) map.get("PORTDETAIL"));
					// channelequipment为端口所属的设备或则模块
					channelequipment = new ChannelEquipment();
					// 端口口所属的设备或则模块的编码
					channelequipment.setEquipcode((String) map.get("CODE"));
					// 端口口所属的设备或则模块的名称
					channelequipment
							.setEquipname((String) map.get("EQUIPNAME"));
					// 端口所属设备的类型
					channelequipment.setPorttype((String) porttype);
					channelequipment.setIstopo(false);
					// 端口所属设备的设备类型equiptype
					channelequipment
							.setEquiptype((String) map.get("EQUIPTYPE"));
					// 端口所属设备的设备类型equiptype
					channelequipment.setStationname((String) map
							.get("STATIONNAME"));
					channelequipment.setX(x);

					channelequipment.setY(y);
					// 端口口所属的设备厂商，模块则为空
					channelequipment.setVendor((String) map.get("X_VENDOR"));
					// 端口口所属的设备模板，模块则为空
					channelequipment
							.setXmodel((String) map.get("X_MODEL") == null ? ""
									: (String) map.get("X_MODEL"));
					// 端口口所属的设备所属的系统，模块则为空
					channelequipment.setSystemcode((String) map
							.get("SYSTEMCODE"));
					channelport.setBelongequipment(channelequipment);
					channelport.setSystemcode((String) map.get("SYSTEMCODE"));

					List<ChannelPort> tempportlist = new ArrayList<ChannelPort>();
					tempportlist = getBaseData();// 获取拓扑连接和交叉
					for (int x = 0; x < tempportlist.size(); x++) {
						ChannelPort cp = tempportlist.get(x);
						if (cp != null && !portlist.contains(cp)) {
							portlist.add(cp);
						}
					}
					// portlist.addAll(tempportlist);
				}
				System.out.println("DrawFiberRoute's portlist.length is  "
						+ portlist.size());
				ComputePortPosition();// 计算端口在设备上的相对位置
				getBranchPort();// 确定支路口
				ComputeEquipPosition();// 计算设备坐标
				xml = getXml(null, false);

			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return xml;

	}

	private void insertMatrix_stosInfos() {

		// 1、查找所有光路ID
		List<String> opticalIdlst = this.basedao.queryForList(
				"getOpticalIdLst", null);
		// //2、循环光路ID，根据光路ID查找光路路由，分收和发
		Map map = new HashMap();
		for (int i = 0; i < opticalIdlst.size(); i++) {
			String opticalid = opticalIdlst.get(i);
			// String opticalid = "00000000000500199407";
			map.put("opticalid", opticalid);
			map.put("logo", "发");
			List<String> lst1 = this.basedao.queryForList("getOpticalRoutelst",
					map);
			Map m = new HashMap();
			for (int j = 0, k = j + 1; j < lst1.size() && k < lst1.size(); j++, k++) {
				m.put("portcode1", lst1.get(j));
				m.put("portcode2", lst1.get(k));
				m.put("porttype1", "ZY23010499");
				m.put("porttype2", "ZY23010499");
				this.basedao.insert("insertMatrix_stosInfo", m);// 如果没有
			}
			map.put("logo", "收");
			List<String> lst2 = this.basedao.queryForList("getOpticalRoutelst",
					map);
			for (int j = 0, k = j + 1; j < lst2.size() && k < lst2.size(); j++, k++) {
				m.put("portcode1", lst2.get(j));
				m.put("portcode2", lst2.get(k));
				m.put("porttype1", "ZY23010499");
				m.put("porttype2", "ZY23010499");
				this.basedao.insert("insertMatrix_stosInfo", m);// 如果没有
			}

			// 3、查找与光路关联的复用段，将起止端口插入表中
			String toplink = (String) this.basedao.queryForObject(
					"getToplinkIDByOpticalCode", opticalid);
			if (toplink != null && !"".equals(toplink)) {
				// 查找复用段起止端口
				String linkPorts = (String) this.basedao.queryForObject(
						"getPortcodesByResid", toplink);
				Map mp = new HashMap();
				if (lst1.size() > 1) {
					mp.put("portcode1", linkPorts.split(";")[0]);
					mp.put("portcode2", lst1.get(0));
					mp.put("porttype1", "ZY03070402");
					mp.put("porttype2", "ZY23010499");
					this.basedao.insert("insertMatrix_stosInfo", mp);// 如果没有

					mp.put("portcode1", linkPorts.split(";")[1]);
					mp.put("portcode2", lst1.get(lst1.size() - 1));
					mp.put("porttype1", "ZY03070402");
					mp.put("porttype2", "ZY23010499");
					this.basedao.insert("insertMatrix_stosInfo", mp);// 如果没有
				}
				if (lst2.size() > 1) {
					mp.put("portcode1", linkPorts.split(";")[0]);
					mp.put("portcode2", lst2.get(0));
					mp.put("porttype1", "ZY03070402");
					mp.put("porttype2", "ZY23010499");
					this.basedao.insert("insertMatrix_stosInfo", mp);// 如果没有

					mp.put("portcode1", linkPorts.split(";")[1]);
					mp.put("portcode2", lst2.get(lst2.size() - 1));
					mp.put("porttype1", "ZY03070402");
					mp.put("porttype2", "ZY23010499");
					this.basedao.insert("insertMatrix_stosInfo", mp);// 如果没有
				}
			}
		}

	}

	public String getXml(String filename, boolean isRefresh) {
		String xml = "";
		isHasCc = true;
		if (isHasCc) {
			String equipgroup = "";
			// port_x = new double[]{24.86,93.1};
			port_x = new double[] { 24.86, 60.1, 93.1 };

			/**
			 * 端口相对设备的y坐标
			 */
			// port_y = new double[]{30.25,95};
			port_y = new double[] { 30.25, 66, 95 };
			double dx = 40.95;
			double dy1 = 50.00;
			double dy2 = -80.00;
			// 生成设备xml
			int k = 1;
			box.clear();
			box = new ElementBox();

			Layer layer = new Layer("equipment");
			layer.setVisible(true);
			layer.setEditable(true);
			layer.setMovable(true);
			layer.setName("equipment");
			box.getLayerBox().add(layer);
			layer = new Layer("port1");
			layer.setVisible(true);
			layer.setEditable(true);
			layer.setMovable(false);
			layer.setName("port1");
			box.getLayerBox().add(layer);
			layer = new Layer("port");
			layer.setVisible(true);
			layer.setEditable(true);
			layer.setMovable(true);
			layer.setName("port");
			box.getLayerBox().add(layer);

			Styles style = new Styles();
			SerializationSettings.registerGlobalClient("flag",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("equipisbranch",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("position",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("equipcode",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("portcode",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("topoid",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("portlabel",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("equiptype",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("porttype",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("systemcode",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("portisbranch",
					Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("portshow",
					Consts.TYPE_STRING);
			String systemcodegroup = "";
			if (equipList.size() > 0) {
				for (int i = 0; i < equipList.size(); i++) {
					ChannelEquipment equipment = (ChannelEquipment) equipList
							.get(i);
					String a = "1";
					String b = "2";
					System.out.println("设备类型：" + equipment.getPorttype());
					double x = 0;
					double y = 0;
					String equipment_image = "";
					String lowname = "";
					String nodename = "";
					String aa = "  ";
					if (equipment.getPorttype().equalsIgnoreCase("equipport")) {
						equipment_image = "twaverImages/channelroute/luyou_bg2.png";
						lowname = equipment.getVendor() + aa
								+ equipment.getXmodel();
						nodename = equipment.getEquipname();
					} else if (equipment.getPorttype().equalsIgnoreCase("odf")) {
						equipment_image = "twaverImages/channelroute/ODF.png";
						lowname = "ODF模块";
						if (equipment.getEquipname().length() > 5) {
							nodename = equipment.getStationname();
						} else {
							nodename = equipment.getEquipname();
						}

					} else if (equipment.getPorttype().equalsIgnoreCase("ddf")) {
						equipment_image = "twaverImages/channelroute/DDF.png";
						lowname = "DDF模块";
						if (equipment.getEquipname().length() > 5) {
							nodename = equipment.getStationname();
						} else {
							nodename = equipment.getEquipname();
						}
					}
					Node node = new Node(equipment.getEquipcode());
					node.setName("");
					node.setImage(equipment_image);
					node.setLocation(equipment.getX(), equipment.getY());
					node.setWidth(133);
					node.setHeight(153);
					node.setLayerID("equipment");
					node.setClient("flag", "equipment");
					node.setClient("equiptype", equipment.getPorttype());
					node.setClient("equipisbranch", equipment.isIsbranchequip());
					node.setClient("equipcode", equipment.getEquipcode());
					node.setClient("systemcode", equipment.getSystemcode()); // 添加syscode参数for设备面板图
					// node.setParent(box.getElementByID(equipment.getSystemcode()));
					box.add(node);
					k++;
					x = equipment.getX() + dx;
					y = equipment.getY() - dy1;
					Follower follower = new Follower(equipment.getEquipcode()
							+ a);
					follower.setName(nodename);
					follower.setParent(box.getDataByID(equipment.getEquipcode()));
					// follower.setStyle(style.LABEL_BOLD, true);
					follower.setStyle(style.LABEL_SIZE, 12);
					follower.setImage(null);
					follower.setWidth(0);
					follower.setHeight(0);
					follower.setLayerID("port1");
					follower.setHost((Node) box.getDataByID(equipment
							.getEquipcode()));

					follower.setLocation(x, y);

					box.add(follower);
					y = equipment.getY() - dy2;
					k++;

					follower = new Follower(equipment.getEquipcode() + b);
					follower.setName(lowname);
					follower.setStyle(style.LABEL_SIZE, 13);
					follower.setParent(box.getDataByID(equipment.getEquipcode()));
					follower.setImage(null);
					follower.setWidth(0);
					follower.setHeight(0);
					follower.setLayerID("port1");
					follower.setHost((Node) box.getDataByID(equipment
							.getEquipcode()));
					follower.setLocation(x, y);

					box.add(follower);
				}
			}
			// 生成端口xml
			if (portlist.size() > 0) {
				for (int i = 0; i < portlist.size(); i++) {
					ChannelPort port = (ChannelPort) portlist.get(i);
					if (!isRefresh) {
						// double x = port.getBelongequipment().getX();
						// double y =port.getBelongequipment().getY();
						double x = 0;
						double y = 0;
						for (int j = 0; j < equipList.size(); j++) {
							ChannelEquipment equipment = (ChannelEquipment) equipList
									.get(j);
							if (equipment.getEquipcode().equalsIgnoreCase(
									port.getBelongequipment().getEquipcode())) {
								x = equipment.getX();
								y = equipment.getY();
							}
						}
						// port.setX(port_x[1]+x);
						// port.setY(port_y[1]+y);
						if (port.getPosition() > 0) {
							if (port.getPorttype()
									.equalsIgnoreCase("equipport")) {
								port.setX(port_x[1] + x);
							} else {
								port.setX(port_x[0] + x);
							}
							// port.setY(port_y[0]+y);
							if (port.getY() == 0) {
								port.setY(port_y[port.getPosition() - 1] + y);
							}

						} else {
							if (port.getPorttype()
									.equalsIgnoreCase("equipport")) {
								port.setX(port_x[1] + x);
							} else {
								port.setX(port_x[2] + x);
							}
							if (port.getPosition() != 0) {
								port.setY(port_y[-port.getPosition() - 1] + y);
							} else
								port.setY(port_y[1] + y);
						}
					}
					String portcode = port.getPort();
					String img = "twaverImages/channelroute/luyou_port.png";
					if (port.isIsbranch()) {
						img = "twaverImages/channelroute/luyou_port2.png";
					}
					Follower follower = null;
					follower = new Follower(port.getPort());
					follower.setName(port.getPortlabel());
					// 绘制的端口是设备的跟随者
					follower.setParent(box.getDataByID(port
							.getBelongequipment().getEquipcode()));
					follower.setStyle(style.LABEL_SIZE, 9);
					follower.setImage(img);
					follower.setWidth(12);
					follower.setHeight(12);
					follower.setLayerID("port");
					follower.setHost((Node) box.getDataByID(port
							.getBelongequipment().getEquipcode()));
					follower.setLocation(port.getX(), port.getY());
					follower.setClient("flag", "port");
					follower.setClient("porttype", port.getPorttype());
					follower.setClient("position",
							String.valueOf(port.getPosition()));
					follower.setClient("portcode", portcode);
					follower.setClient("portisbranch", port.isIsbranch());
					String toolTip = port.getPortdetail() != null ? port
							.getPortdetail() : "";
					follower.setToolTip(toolTip);
					String portshow = port.getPortshow() != null ? port
							.getPortshow() : "";
					follower.setClient("portshow", portshow);
					box.add(follower);
				}
			}
			// 生成复用段,交叉
			String groupFlag = "";// 判断该条交叉或复用段是否已经生成过xml
			if (portlist.size() > 0) {
				for (int i = 0; i < portlist.size(); i++) {
					ChannelPort portchannel = (ChannelPort) portlist.get(i);
					List tmpList = portchannel.getConnectport();
					if (tmpList != null && tmpList.size() > 0) {
						for (int j = 0; j < tmpList.size(); j++) {
							ChannelPort channeltopo = (ChannelPort) tmpList
									.get(j);
							boolean T = false;
							if (!groupFlag.contains(portchannel.getPort() + "#"
									+ channeltopo.getPort())
									&& !groupFlag.contains(channeltopo
											.getPort()
											+ "#"
											+ portchannel.getPort())) {
								T = true;
							}
							if (T) {
								boolean arrowfrom = false;
								boolean arrowto = false;
								if (portchannel
										.getBelongequipment()
										.getEquipcode()
										.equalsIgnoreCase(
												channeltopo
														.getBelongequipment()
														.getEquipcode())) {
									arrowfrom = true;
									arrowto = true;
								}
								int strokeWidth = 2;
								int arrowWidth = 9;
								if (portchannel
										.getBelongequipment()
										.getEquipcode()
										.equalsIgnoreCase(
												channeltopo
														.getBelongequipment()
														.getEquipcode())) {
									strokeWidth = 3;
									arrowWidth = 12;
								}
								String topoid = "cc";
								String toplink = channeltopo.getTopoid();
								String toplink1 = portchannel.getTopoid();
								String equip1 = channeltopo
										.getBelongequipment().getEquipcode();
								String equip2 = portchannel
										.getBelongequipment().getEquipcode();

								if (toplink != null
										&& !toplink.equalsIgnoreCase("")
										&& toplink1 != null
										&& !toplink1.equalsIgnoreCase("")
										&& !equip1.equalsIgnoreCase(equip2)
										&& toplink.equals(toplink1)) {
									topoid = toplink;
								}
								// String
								// linkname=portchannel.getPortdetail()+"\n"+"至"+channeltopo.getPortdetail();
								// if(portchannel.isIstopo()&&
								// channeltopo.isIstopo()){
								// linkname=portchannel.getBelongequipment().getStationname()+portchannel.getPortdetail()
								// +"\n"
								// +"至"+channeltopo.getBelongequipment().getStationname()+channeltopo.getPortdetail();
								// }
								String linkname = "";
								if (!"cc".equalsIgnoreCase(topoid)) {
									String ocablecode = topoid;
									linkname = (String) this.basedao
											.queryForObject("getFiberNameById",
													ocablecode);
								}
								Link link;
								link = new Link(portchannel.getPort() + '#'
										+ channeltopo.getPort());
								link.setStyle(style.ARROW_FROM, arrowfrom);
								link.setStyle(style.ARROW_TO, arrowto);
								link.setStyle(style.ARROW_FROM_HEIGHT,
										arrowWidth);
								link.setStyle(style.ARROW_TO_HEIGHT, arrowWidth);
								link.setStyle(style.LINK_WIDTH, strokeWidth);
								link.setStyle(style.LABEL_XOFFSET, -5);
								link.setStyle(style.LABEL_YOFFSET, -17);
								link.setLayerID("port");
								link.setStyle(Styles.LINK_BUNDLE_GAP, 30);
								if (!topoid.equalsIgnoreCase("cc")) {
									link.setClient("flag", "topolink");// 表示是光纤相连
									link.setName(linkname);
									String color = "0x00CC00";
									link.setStyle(style.ARROW_FROM_COLOR, color);
									link.setStyle(style.ARROW_TO_COLOR, color);
									link.setStyle(style.LINK_COLOR, color);
								} else {
									link.setClient("flag", "cc");// 表示是跳纤
									link.setName("");
									String color = "black";
									link.setStyle(style.ARROW_FROM_COLOR, color);
									link.setStyle(style.ARROW_TO_COLOR, color);
									link.setStyle(style.LINK_COLOR, color);
								}
								Follower from;
								Follower to;
								from = (Follower) box.getDataByID(portchannel
										.getPort());
								to = (Follower) box.getDataByID(channeltopo
										.getPort());
								link.setFromNode(from);
								link.setToNode(to);
								link.setClient("topoid", topoid);
								box.add(link);
								groupFlag += portchannel.getPort() + '#'
										+ channeltopo.getPort() + "&";
							}
						}
					}
				}
			}
		}
		XMLSerializer serializer1 = new XMLSerializer(box);
		xml = serializer1.serialize();
		return xml;
	}

	/**
	 * 取所有设备.
	 *
	 * @return the all equip author:ycguan date:2012-7-9
	 */
	public List getAllEquip() {
		List list = null;
		list = new ArrayList();
		for (int i = 0; i < portlist.size(); i++) {
			channelport = new ChannelPort();
			channelport = (ChannelPort) portlist.get(i);
			boolean t = false;
			if (list.size() > 0) {
				for (int j = 0; j < list.size(); j++) {
					ChannelEquipment judge = (ChannelEquipment) list.get(j);
					if (judge.getEquipcode().equalsIgnoreCase(
							channelport.getBelongequipment().getEquipcode())) {
						t = true;
						break;
					}
				}
			}
			if (!t) {
				list.add(channelport.getBelongequipment());
			}
		}
		return list;
	}

	/**
	 * 计算支路口所在的设备. author:ycguan date:2012-7-9
	 */
	public void getEquipByBranchPort() {
		if (equipList.size() > 0) {
			for (int i = 0; i < equipList.size(); i++) {
				ChannelEquipment equipment = (ChannelEquipment) equipList
						.get(i);
				if (portlist.size() > 0) {
					for (int j = 0; j < portlist.size(); j++) {
						ChannelPort portTmp = (ChannelPort) portlist.get(j);
						if (portTmp.isIsbranch()
								&& portTmp
										.getBelongequipment()
										.getEquipcode()
										.equalsIgnoreCase(
												equipment.getEquipcode())) {
							equipment.setIsbranchequip(true);
							break;
						} else
							equipment.setIsbranchequip(false);
					}
				}
			}
		}

	}

	/**
	 * 判断相连的设备是否存在.
	 *
	 * @param list
	 *            the list
	 * @param judge
	 *            the judge
	 * @return true, if judge conn equip exit
	 * 
	 *         author:ycguan date:2012-7-9
	 */
	public boolean JudgeConnEquipExit(String judge, List list) {
		if (list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				ChannelEquipment judgetmp = (ChannelEquipment) list.get(i);
				if (judgetmp.getEquipcode().equalsIgnoreCase(judge)) {
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * 获取和某设备相连的所有的设备. author:ycguan date:2012-7-9
	 */
	public void getEquipConnectEquiplist() {
		List listequip = null;
		for (int i = 0; i < equipList.size(); i++) {
			listequip = new ArrayList();
			channelequipment = new ChannelEquipment();
			channelequipment = (ChannelEquipment) equipList.get(i);
			for (int j = 0; j < portlist.size(); j++) {
				channelport = new ChannelPort();
				channelport = (ChannelPort) portlist.get(j);
				if (channelequipment.getEquipcode().equalsIgnoreCase(
						channelport.getBelongequipment().getEquipcode())) {
					List list = channelport.getConnectport();
					if (list != null) {
						if (list.size() > 0) {
							for (int k = 0; k < list.size(); k++) {
								ChannelPort tmp = (ChannelPort) list.get(k);
								if (!tmp.getBelongequipment()
										.getEquipcode()
										.equalsIgnoreCase(
												channelequipment.getEquipcode())) {
									boolean t = false;
									if (listequip.size() > 0) {
										t = JudgeConnEquipExit(tmp
												.getBelongequipment()
												.getEquipcode(), listequip);
									}
									if (!t || listequip.size() < 0) {
										listequip.add(tmp.getBelongequipment());
									}
								}
							}
							channelequipment.setListconnequip(listequip);
						}
					}
				}
			}
		}
		for (int i = 0; i < equipList.size(); i++) {
			ChannelEquipment equipment = (ChannelEquipment) equipList.get(i);
			List list = equipment.getListconnequip();
			List listmp;
			if (list != null) {
				if (list.size() > 0) {
					for (int j = 0; j < list.size(); j++) {
						listmp = null;
						ChannelEquipment equipmentmp = (ChannelEquipment) list
								.get(j);
						for (int k = 0; k < equipList.size(); k++) {
							ChannelEquipment ment = (ChannelEquipment) equipList
									.get(k);
							if (equipmentmp.getEquipcode().equalsIgnoreCase(
									ment.getEquipcode())) {
								listmp = ment.getListconnequip();
							}
						}
						if (equipmentmp.getListconnequip() == null
								|| equipmentmp.getListconnequip().size() == 0) {
							equipmentmp.setListconnequip(listmp);
						}
					}
				}
			}
		}

	}

	/**
	 * 获取设备对象中的CONNEQUIP中的坐标为0的size的大小.
	 *
	 * @param tmpList
	 *            the tmp list
	 * @param channel
	 *            the channel
	 * @param totalsize
	 *            the totalsize
	 * @return the nullitemsize author:ycguan date:2012-7-9
	 */
	public int getnullitemsize(ChannelEquipment channel, List tmpList,
			int totalsize) {//
		int size = 0;
		List list = channel.getListconnequip();
		if (list != null) {
			if (list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {
					ChannelEquipment equip = (ChannelEquipment) list.get(i);
					for (int j = 0; j < tmpList.size(); j++) {
						ChannelEquipment ment = (ChannelEquipment) tmpList
								.get(j);
						if (ment.getEquipcode().equalsIgnoreCase(
								equip.getEquipcode())) {
							equip.setX(ment.getX());
							equip.setY(ment.getY());
						}
					}
					if (equip.getY() == 0) {
						size++;
					}
				}
			}
		}
		return size;
	}

	// 计算设备坐标�
	public void ComputeEquipPosition() {
		equipList = new ArrayList();
		equipList = getAllEquip();
		System.out.println("equipList.length is  " + equipList.size());
		getEquipByBranchPort();// 计算支路口所在的设备(即起止端口)
		List tmpList = null;
		if (equipList.size() > 0) {
			getEquipConnectEquiplist();// 取连接设备
			channelequipment = new ChannelEquipment();
			channelequipment = (ChannelEquipment) equipList.get(0);
			channelequipment.setX(x);
			channelequipment.setY(y);
			tmpList = new ArrayList();
			tmpList.add(channelequipment);
			int connectnum = 0;
			for (int i = 0; i < tmpList.size(); i++) {
				channelequipment = new ChannelEquipment();
				channelequipment = (ChannelEquipment) tmpList.get(i);
				int totalsize = 0;
				if (channelequipment.getListconnequip() != null) {
					totalsize = channelequipment.getListconnequip().size();
				}
				if (totalsize > 2) {
					connectnum++;
				}
				int size = getnullitemsize(channelequipment, tmpList, totalsize);
				int u = size;
				if (channelequipment.getListconnequip() != null) {
					for (int j = 0, k = 0; k < channelequipment
							.getListconnequip().size() && j < size; k++, j++, u--) {
						ChannelEquipment channeltmp = channelequipment
								.getListconnequip().get(k);

						if (channeltmp.getY() == 0
								&& ((channeltmp.isIsbranchequip() && channelequipment
										.isIsbranchequip()) || !channeltmp
										.isIsbranchequip())) {
							if (totalsize > 2 && connectnum > 1) {
								channeltmp.setIsreset(true);
								channeltmp.setIsreset(true);
							} else {
								channeltmp.setIsreset(false);
								channeltmp.setIsreset(false);
							}
							channeltmp.setX(channelequipment.getX() + dx);
							if (size < 2) {
								channeltmp.setY(channelequipment.getY()
										+ (size - j - 1) * dy / (size));
							} else {
								int position = 0;
								if (channelequipment.getTopoid() != null) {
									Map paraMap = new HashMap();
									Map resultMap;
									paraMap.put("fibercode",
											channelequipment.getTopoid());

									List list = (List) basedao.queryForList(
											"getFiberCodePort", paraMap);

									// for (Iterator it = list.iterator(); it
									// .hasNext();) {
									// resultMap = (HashMap) it.next();
									resultMap = (HashMap) list.get(0);
									String port_a = (String) resultMap
											.get("AENDODFPORT");
									String port_z = (String) resultMap
											.get("ZENDODFPORT");
									for (int kk = 0; kk < portlist.size(); kk++) {
										ChannelPort porttmp = (ChannelPort) portlist
												.get(kk);
										if (porttmp.getPort().equalsIgnoreCase(
												port_a)
												|| porttmp.getPort()
														.equalsIgnoreCase(
																port_z)) {
											position = porttmp.getPosition();
											if (position == 1 || position == -1) {
												break;
											}
										}
									}
									// }
								}
								if ((Math.abs(position) == 1 || Math
										.abs(position) == 3)) {
									if (Math.abs(position) == 1) {
										channeltmp
												.setY(channelequipment.getY());

									}
									if (Math.abs(position) == 3) {
										channeltmp.setY(channelequipment.getY()
												+ dy / 2);
									}
								} else {
									channeltmp.setY(channelequipment.getY()
											+ (size - u) * dy / (size));
								}
							}
							channeltmp.setTogetherequip(channelequipment);
							boolean flag = false;
							if (tmpList.size() > 0) {
								for (int p = 0; p < tmpList.size(); p++) {
									ChannelEquipment tmp = (ChannelEquipment) tmpList
											.get(p);
									if (tmp.getEquipcode().equalsIgnoreCase(
											channeltmp.getEquipcode())) {
										flag = true;
										break;
									}
								}
							} else
								tmpList.add(channeltmp);
							if (!flag) {
								tmpList.add(channeltmp);
							}
						} else {
							j--;
							u++;
						}
					}
				}
			}
			addXYForEquip(tmpList);
			reComputeEndEquipPostion();// 重新计算支路口终点设备的坐标
		}
	}

	/**
	 * 重新计算支路口终点设备的坐标. author:ycguan date:2012-7-9
	 */
	public void reComputeEndEquipPostion() {
		double max_x = 0;
		double first_y = 0;
		if (equipList.size() > 0) {
			for (int i = 0; i < equipList.size(); i++) {
				ChannelEquipment equipment = (ChannelEquipment) equipList
						.get(i);
				if (equipment.getX() > max_x && !equipment.isIsbranchequip()) {
					max_x = equipment.getX();
				}
				if (i == 0) {
					first_y = equipment.getY();
				}
			}
			for (int i = 1; i < equipList.size(); i++) {
				ChannelEquipment equipment = (ChannelEquipment) equipList
						.get(i);
				if (equipment.isIsbranchequip()) {
					equipment.setX(max_x + dx);
					equipment.setY(first_y);
				}
			}
		}

	}

	/**
	 * 回写坐标到设备list中.
	 *
	 * @param tmpList
	 *            the tmp list author:ycguan date:2012-7-9
	 */
	public void addXYForEquip(List tmpList) {
		for (int i = 0; i < tmpList.size(); i++) {
			ChannelEquipment route = (ChannelEquipment) tmpList.get(i);
			for (int j = 0; j < equipList.size(); j++) {
				ChannelEquipment routetmp = (ChannelEquipment) equipList.get(j);
				if (route.getEquipcode().equalsIgnoreCase(
						routetmp.getEquipcode())) {
					// if (routetmp.getX() == 0 && routetmp.getY() == 0) {
					routetmp.setX(route.getX());
					routetmp.setY(route.getY());
					// }
				}
			}
		}

	}

	/**
	 * 获取支路口. author:ycguan date:2012-7-9
	 */
	public void getBranchPort() {
		if (portlist.size() > 0) {
			for (int i = 0; i < portlist.size(); i++) {
				ChannelPort portTmp = (ChannelPort) portlist.get(i);
				if (portTmp.getPorttype() != null) {
					if (portTmp.getPorttype().equalsIgnoreCase("equipport")) {
						// 设备口既是支路口
						portTmp.setIsbranch(true);
						if (i != 0) {
							portTmp.setPosition(-2);
						}
					} else
						portTmp.setIsbranch(false);
				}
			}
		}

	}

	/**
	 * 计算第一个设备上的端口的相对位置. author:ycguan date:2012-7-9
	 */
	public void ComputeFirstEquipPortPosition() {// 优化 麻烦
		ChannelPort porttmp = null;
		List listtmp = null;
		if (portlist.size() > 0) {
			channelport = new ChannelPort();
			channelport = (ChannelPort) portlist.get(0);
			if (channelport.getPorttype().equalsIgnoreCase("equipport")) {
				channelport.setPosition(position[1]);
				return;
			}
			listtmp = new ArrayList();
			int portsum = 1;
			for (int i = 0; i < portlist.size(); i++) {
				porttmp = new ChannelPort();
				porttmp = (ChannelPort) portlist.get(i);
				if (channelport.getBelongequipment().getEquipcode() != null
						&& channelport
								.getBelongequipment()
								.getEquipcode()
								.equalsIgnoreCase(
										porttmp.getBelongequipment()
												.getEquipcode())
						&& !channelport.getPort().equalsIgnoreCase(
								porttmp.getPort())) {
					portsum++;
				}
			}
			if (portsum > 0) {
				int j = 1;
				for (int i = 0; i < portlist.size(); i++) {
					porttmp = new ChannelPort();
					porttmp = (ChannelPort) portlist.get(i);
					if (channelport
							.getBelongequipment()
							.getEquipcode()
							.equalsIgnoreCase(
									porttmp.getBelongequipment().getEquipcode())
							&& !channelport.getPort().equalsIgnoreCase(
									porttmp.getPort())) {
						// 修改两个ODF端口的位置（相对于设备）
						if (portsum == 2) {
							channelport.setPosition(position[0]);
							porttmp.setPosition(channelport.getPosition() + 2);
						}
						if (portsum == 3) {
							channelport.setPosition(position[1]);
							porttmp.setPosition(-channelport.getPosition() - j);
							j = -1;
						}
						if (portsum == 4) {
							channelport.setPosition(position[1]);
							porttmp.setPosition(-channelport.getPosition() - j);
							j--;
						}
					}
				}
			}
		}
	}

	/**
	 * 计算一个端口的交叉有几个，为计算设备上的端口的相对坐标.
	 *
	 * @param 端口对象
	 * @param 端口对象中的conlist
	 * @return 交叉数量 author:ycguan date:2012-7-9
	 */
	public int judgePortCCandTopoNum(ChannelPort portParm, List conPortList) {
		int num = 0;
		if (conPortList.size() > 0) {
			for (int i = 0; i < conPortList.size(); i++) {
				ChannelPort portTmp = (ChannelPort) conPortList.get(i);
				if (portParm
						.getBelongequipment()
						.getEquipcode()
						.equalsIgnoreCase(
								portTmp.getBelongequipment().getEquipcode())) {
					for (int j = 0; j < portlist.size(); j++) {
						ChannelPort portJudge = (ChannelPort) portlist.get(j);
						if (portTmp.getPort().equalsIgnoreCase(
								portJudge.getPort())
								&& portJudge.getPosition() == 0) {
							num++;
						}
					}
				}
			}
		}
		return num;
	}

	/**
	 * 获取端口相对位置.
	 *
	 * @param 端口对象
	 * @param 端口对象中的conlist
	 * @return the postion for port author:ycguan date:2012-7-9
	 */
	public String getPostionForPort(ChannelPort portParm, List conPortList) {//
		int num = 0;
		String positionset = "0";
		if (conPortList.size() > 0) {
			for (int i = 0; i < conPortList.size(); i++) {
				ChannelPort portTmp = (ChannelPort) conPortList.get(i);
				if (portParm
						.getBelongequipment()
						.getEquipcode()
						.equalsIgnoreCase(
								portTmp.getBelongequipment().getEquipcode())) {
					for (int j = 0; j < portlist.size(); j++) {
						ChannelPort portJudge = (ChannelPort) portlist.get(j);
						if (portTmp.getPort().equalsIgnoreCase(
								portJudge.getPort())) {
							num++;
						}
						if (portTmp.getPort().equalsIgnoreCase(
								portJudge.getPort())
								&& portJudge.getPosition() != 0) {
							positionset += portJudge.getPosition() + ",";
						}
					}
				}
			}
		}
		String data = "";
		data = num + "#" + positionset;
		return data;
	}

	/**
	 * 判断此端口是否已经被计算过位置.
	 *
	 * @param 端口对象
	 * @return boolean author:ycguan date:2012-7-9
	 */
	public boolean getHasPositionport(ChannelPort portParm) {
		// true 计算/false
		// 没有计算
		boolean T = false;
		for (int i = 0; i < portlist.size(); i++) {
			ChannelPort portTmp = (ChannelPort) portlist.get(i);
			if (portParm.getPort().equalsIgnoreCase(portTmp.getPort())
					&& portTmp.getPosition() != 0) {
				T = true;
				break;
			}
		}

		return T;
	}

	/**
	 * 计算端口相对设备的坐标. author:ycguan date:2012-7-9
	 */
	public void ComputePortPosition() {
		ComputeFirstEquipPortPosition();// 计算第一个设备上的端口的位置
		ChannelPort tmp = new ChannelPort();
		tmp = (ChannelPort) portlist.get(0);
		String equip = tmp.getBelongequipment().getEquipcode();
		if (portlist.size() > 0) {
			channelport = new ChannelPort();
			for (int i = 0; i < portlist.size(); i++) {
				channelport = (ChannelPort) portlist.get(i);
				// if(channelport.getPorttype().equalsIgnoreCase("equipport")){
				// channelport.setPosition(position[1]);
				//
				// }
				List list = channelport.getConnectport();
				// sum为同一设备上未设置position的端口。
				int sum = judgePortCCandTopoNum(channelport, list);
				String sumnative = getPostionForPort(channelport, list);
				int sum1 = Integer.valueOf(sumnative.split("#")[0]);
				String positionset = "";
				// sum1为 同一设备上已设置position的端口
				if (sum1 > sum) {
					positionset = sumnative.split("#")[1];
				}
				int sumhis = sum;
				int k = 0;
				int l = 3;
				boolean M = false;
				if (list.size() > 0) {
					for (int j = 0; j < list.size(); j++) {
						ChannelPort portmp = (ChannelPort) list.get(j);
						if (!portmp.getBelongequipment().getEquipcode()
								.equalsIgnoreCase(equip)) {
							if (portmp.getPosition() == 0) {
								boolean T = getHasPositionport(portmp);
								if (!T
										&& !portmp
												.getBelongequipment()
												.getEquipcode()
												.equalsIgnoreCase(
														channelport
																.getBelongequipment()
																.getEquipcode())) {
									// ComputeCurrentPortEquipPortPosition(channelport,portmp);
									if (channelport.getPorttype()
											.equalsIgnoreCase("equipport")) {
										if (!M) {
											portmp.setPosition(channelport
													.getPosition() - 1);
											M = true;
										} else
											portmp.setPosition(channelport
													.getPosition() + 1);

									} else {
										if (channelport.getPosition() < 0) {
											portmp.setPosition(-channelport
													.getPosition());
										} else
											portmp.setPosition(channelport
													.getPosition());
									}
									System.out.println("channelport is"
											+ channelport.getPosition());
									System.out.println("portmp.position is"
											+ portmp.getPosition());
									// portmp.setPosition(-channelport
									// .getPosition());
									// 计算与channelport相连的端口（不同设备上）的相对于
									// 所属设备的位置
									// ComputeCurrentPortEquipPortPosition(channelport,portmp);
								}

								if (!T
										&& portmp
												.getBelongequipment()
												.getEquipcode()
												.equalsIgnoreCase(
														channelport
																.getBelongequipment()
																.getEquipcode())) {
									if (sum1 > 1) {
										if (sumhis > 1) {
											if (sumhis != 2) {
												if (channelport.getPosition() == 3
														|| channelport
																.getPosition() == -3) {
													if (channelport
															.getPosition() > 0) {
														portmp.setPosition(-channelport
																.getPosition()
																+ sum - 1);
													} else {
														portmp.setPosition(-channelport
																.getPosition()
																- sum + 1);
													}
													sum--;
												}
												if (channelport.getPosition() == 2
														|| channelport
																.getPosition() == -2) {
													if (channelport
															.getPosition() > 0) {
														portmp.setPosition(-channelport
																.getPosition()
																+ sum - 2);
													} else {
														portmp.setPosition(-channelport
																.getPosition()
																- sum + 2);
													}
													sum--;
												}
												if (channelport.getPosition() == 1
														|| channelport
																.getPosition() == -1) {
													if (channelport
															.getPosition() > 0) {
														portmp.setPosition(-channelport
																.getPosition()
																- sum + 1);
													} else {
														portmp.setPosition(-channelport
																.getPosition()
																+ sum - 1);
													}
													sum--;
												}
											} else {
												if (channelport.getPosition() == 3
														|| channelport
																.getPosition() == -3) {
													if (channelport
															.getPosition() > 0) {
														portmp.setPosition(-channelport
																.getPosition()
																+ sum - k);
														k++;
													} else {
														portmp.setPosition(-channelport
																.getPosition()
																- sum + k);
														k++;
													}
													sum--;
												}
												if (channelport.getPosition() == 2
														|| channelport
																.getPosition() == -2) {
													if (channelport
															.getPosition() > 0) {
														portmp.setPosition(-channelport
																.getPosition()
																+ sum - l);
														l = 0;
													} else {
														portmp.setPosition(-channelport
																.getPosition()
																- sum + l);
														l++;
													}
													sum--;
												}
												if (channelport.getPosition() == 1
														|| channelport
																.getPosition() == -1) {
													if (channelport
															.getPosition() > 0) {
														portmp.setPosition(-channelport
																.getPosition()
																- sum + k);
														k++;
													} else {
														portmp.setPosition(-channelport
																.getPosition()
																+ sum - k);
														k++;
													}
													sum--;
												}

											}
										} else {
											if (positionset.contains(String
													.valueOf(-channelport
															.getPosition()))) {

												if (channelport.getPosition() == 1
														|| channelport
																.getPosition() == -3)
													portmp.setPosition(-channelport
															.getPosition() - 2);
												if (channelport.getPosition() == 3
														|| channelport
																.getPosition() == -1)
													portmp.setPosition(-channelport
															.getPosition() + 2);
												if (channelport.getPosition() == 2
														|| channelport
																.getPosition() == -2)
													portmp.setPosition(-channelport
															.getPosition() + 1);

											}
										}
									} else {
										portmp.setPosition(-channelport
												.getPosition());
									}
								}
								if (portmp.getPosition() != 0) {
									for (int ii = 0; ii < portlist.size(); ii++) {
										ChannelPort channeltmp = (ChannelPort) portlist
												.get(ii);
										if (channeltmp.getPort()
												.equalsIgnoreCase(
														portmp.getPort())
												&& channeltmp.getPosition() == 0) {
											channeltmp.setPosition(portmp
													.getPosition());
										}
									}
								}
							}
						}
					}
				}

			}
		}
		// reCompetePortPostion();
	}

	/**
	 * 通过给定的端口和时隙获取整条电路的复用信息和交叉信息。
	 *
	 * @return 端口对象列表 author:ycguan date:2012-7-9
	 */
	public List getBaseData() {
		List portlist = null;
		portlist = new ArrayList();
		portlist.add(channelport);
		ChannelPort porttmp = null;
		ChannelEquipment equiptmp = null;
		List listtmp = null;
		try {
			for (int i = 0; i < portlist.size(); i++) {
				if (portlist.size() > RepetiveTimes) { // 循环次数
					break;
				}
				channelport = new ChannelPort();
				channelport = (ChannelPort) portlist.get(i);
				Map ccmap = new HashMap();
				int a = 0;
				ccmap.put("portcode", channelport.getPort());
				List list = basedao.queryForList("selectMatrixForFiberRoute",
						ccmap);
				List list1 = basedao.queryForList(
						"selectTopoForBaseDataForFiberRoute", ccmap);
				Map resultMap = null;

				// 处理交叉盘
				if (list1 == null || list1.size() < 1) {
					if (list != null && list.size() == 1) {
						resultMap = (HashMap) list.get(0);
						String tmpport = (String) resultMap.get("APTP");
						boolean U = false;
						List tmplist = channelport.getConnectport();
						if (tmplist != null && tmplist.size() > 0) {
							for (int kk = 0; kk < tmplist.size(); kk++) {
								ChannelPort tmp = (ChannelPort) tmplist.get(kk);
								if (tmp.getPort().equalsIgnoreCase(tmpport)) {
									U = true;
								} else {
									U = false;
									break;
								}
							}
						}
						if (U) {
							list = null;
						}

					}
				}
				resultMap = null;
				if (list != null && list.size() > 0) {
					for (int j = 0; j < list.size(); j++) {
						resultMap = (HashMap) list.get(j);
						// System.out.println("端口类型："+(String)resultMap.get("PORTTYPE"));
						porttmp = new ChannelPort();
						porttmp.setPort((String) resultMap.get("APTP"));
						// PORTTYPE标示了端口的类型：设备端口、ODF、DDF
						porttmp.setPorttype((String) resultMap.get("PORTTYPE"));
						porttmp.setPortdetail((String) resultMap
								.get("PORTDETAIL"));
						porttmp.setPortlabel((String) resultMap
								.get("PORTLABEL"));
						porttmp.setSystemcode((String) resultMap
								.get("SYSTEMCODE"));
						// 交叉对端的端口详细信息$为分隔符
						porttmp.setPortshow((String) resultMap.get("PORTSHOW"));
						// System.out.println("端口类型："+porttmp.getPorttype());
						listtmp = new ArrayList();
						listtmp.add(channelport);
						porttmp.setIstopo(false);
						porttmp.setTopoid("");
						// 设置
						porttmp.setConnectport(listtmp);
						porttmp.setLinkport(channelport.getPort());
						listtmp = new ArrayList();
						if (null != (channelport.getConnectport())) {
							listtmp = channelport.getConnectport();
						}
						boolean t = false;
						t = JudgeConnPortExit(porttmp, listtmp);
						if (!t) {
							listtmp.add(porttmp);
						}
						channelport.setConnectport(listtmp);
						channelequipment = new ChannelEquipment();
						// code 可能是设备编码也可能是模块编号
						channelequipment.setEquipcode((String) resultMap
								.get("CODE"));
						// EQUIPNAME 可能是设备名称也可能是模块名称
						channelequipment.setEquipname((String) resultMap
								.get("EQUIPNAME"));
						// 如果是设备，则为设备厂商 ，否则为空
						channelequipment.setVendor((String) resultMap
								.get("X_VENDOR"));
						// 如果是设备，则为设备型号，否则为空
						channelequipment.setXmodel((String) resultMap
								.get("X_MODEL") == null ? ""
								: (String) resultMap.get("X_MODEL"));
						channelequipment.setIstopo(false);
						channelequipment.setTopoid("");
						// PORTTYPE标示了设备的类型：设备端口、ODF、DDF
						channelequipment.setPorttype((String) resultMap
								.get("PORTTYPE"));
						// 如果是设备，则为设备所属系统，否则为空
						channelequipment.setSystemcode((String) resultMap
								.get("SYSTEMCODE"));
						// 端口所属设备的设备类型equiptype
						channelequipment.setStationname((String) resultMap
								.get("STATIONNAME"));
						// System.out.println("设备类型："+channelequipment.getPorttype());
						porttmp.setBelongequipment(channelequipment);
						channelequipment = new ChannelEquipment();
						equiptmp = new ChannelEquipment();
						equiptmp = channelport.getBelongequipment();
						channelequipment.setEquipcode(equiptmp.getEquipcode());
						channelequipment.setConnectequipment(porttmp
								.getBelongequipment());
						// 设置为本端属性
						channelequipment.setIstopo(equiptmp.isIstopo());
						channelequipment.setTopoid(equiptmp.getTopoid());
						channelequipment.setPorttype(equiptmp.getPorttype());
						channelequipment.setVendor(equiptmp.getVendor());
						channelequipment.setXmodel(equiptmp.getXmodel());
						channelequipment.setStationname(equiptmp
								.getStationname());
						channelequipment.setEquipname(equiptmp.getEquipname());
						channelequipment
								.setSystemcode(equiptmp.getSystemcode());
						channelport.setBelongequipment(channelequipment);
						boolean T = Judge(portlist, porttmp);
						if (!T) {
							portlist.add(porttmp);
						}
						porttmp = null;
						channelequipment = null;
						equiptmp = null;
					}
					isHasCc = true;
				} else {
					isHasCc = false;
				}
				list = list1;
				int op = 0;
				if (list != null && list.size() > 0) {
					for (int j = 0; j < list.size(); j++) {
						resultMap = (HashMap) list.get(j);
						porttmp = new ChannelPort();
						// 拓扑图对端的端口类型：设备端口、ODF、DDF
						porttmp.setPorttype((String) resultMap.get("PORTTYPE"));
						// 拓扑图对端的端口编码
						porttmp.setPort((String) resultMap.get("ENDPTP"));
						// 拓扑图对端的端口冒泡提示信息
						porttmp.setPortdetail((String) resultMap
								.get("PORTDETAIL"));
						// 拓扑图对端的端口显示信息
						porttmp.setPortlabel((String) resultMap
								.get("PORTLABEL"));
						// 拓扑图对端的端口详细信息$为分隔符
						porttmp.setPortshow((String) resultMap.get("PORTSHOW"));
						porttmp.setSystemcode((String) resultMap
								.get("SYSTEMCODE"));
						listtmp = new ArrayList();
						listtmp.add(channelport);
						porttmp.setConnectport(listtmp);
						porttmp.setLinkport(channelport.getPort());
						listtmp = new ArrayList();
						if (null != channelport.getConnectport()) {
							listtmp = channelport.getConnectport();
						}
						boolean t = false;
						t = JudgeConnPortExit(porttmp, listtmp);// 判断相连的端口是否已经存在�����
						if (!t) {
							listtmp.add(porttmp);
						}
						channelport.setConnectport(listtmp);
						listtmp = null;
						porttmp.setTopoid((String) resultMap.get("LABEL"));
						porttmp.setIstopo(true);
						// 查询的label字段为en_fiber表中的fibercode
						channelport.setIstopo(porttmp.isIstopo());
						channelport.setTopoid(porttmp.getTopoid());
						channelequipment = new ChannelEquipment();
						// 拓扑图对端的端口所属ODF模块名称
						channelequipment.setEquipname((String) resultMap
								.get("EQUIPNAME"));
						// 拓扑图对端的端口所属ODF模块编码odfodmcode
						channelequipment.setEquipcode((String) resultMap
								.get("ODFODMCODE"));
						// 拓扑图对端的端口所属ODF模块的厂商
						channelequipment.setVendor((String) resultMap
								.get("X_VENDOR"));
						// 拓扑图对端的端口所属ODF模块的模板
						channelequipment.setXmodel((String) resultMap
								.get("X_MODEL"));
						// PORTTYPE标示了设备的类型：设备端口、ODF、DDF
						channelequipment.setPorttype((String) resultMap
								.get("PORTTYPE"));
						// 端口所属设备的设备类型equiptype
						channelequipment.setStationname((String) resultMap
								.get("STATIONNAME"));
						// 标示是否 为拓扑设备
						channelequipment.setIstopo(true);
						// 查询的label字段为en_fiber表中的fibercode
						channelequipment.setTopoid((String) resultMap
								.get("LABEL"));
						// 如果是设备，则为设备所属系统，否则为空
						channelequipment.setSystemcode((String) resultMap
								.get("SYSTEMCODE"));
						channelequipment.setConnectequipment(channelport
								.getBelongequipment());
						porttmp.setBelongequipment(channelequipment);
						channelequipment = new ChannelEquipment();
						equiptmp = new ChannelEquipment();
						equiptmp = channelport.getBelongequipment();
						channelequipment.setEquipcode(equiptmp.getEquipcode());
						channelequipment.setConnectequipment(porttmp
								.getBelongequipment());
						channelequipment.setPorttype(equiptmp.getPorttype());
						// 设置为对端属性
						channelequipment.setIstopo(porttmp.isIstopo());
						channelequipment.setTopoid(porttmp.getTopoid());
						channelequipment.setVendor(equiptmp.getVendor());
						channelequipment.setXmodel(equiptmp.getXmodel());
						channelequipment.setStationname(equiptmp
								.getStationname());
						channelequipment.setEquipname(equiptmp.getEquipname());
						channelequipment
								.setSystemcode(equiptmp.getSystemcode());
						channelport.setBelongequipment(channelequipment);
						boolean T = Judge(portlist, porttmp);
						if (!T) {
							portlist.add(porttmp);
						}
						if (portlist.size() > RepetiveTimes) { // 循环次数
							break;
						}
						channelequipment = null;
						porttmp = null;
						equiptmp = null;
						op++;
					}

				}
				if (portlist.size() > RepetiveTimes) { // 循环次数
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("getBaseData's portlist.length is  "
				+ portlist.size());
		return portlist;
	}

	/**
	 * 判断相同的端口.
	 *
	 * @param porttmp
	 *            the porttmp
	 * @param portlist
	 *            the portlist
	 * @return boolean author:ycguan date:2012-7-9
	 */
	public boolean Judge(List portlist, ChannelPort porttmp) {
		for (int i = 0; i < portlist.size(); i++) {
			ChannelPort judge = (ChannelPort) portlist.get(i);
			if ((judge.getPort().equalsIgnoreCase(porttmp.getPort()))) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 判断相连的端口是否已经存在.
	 *
	 * @param list
	 *            the list
	 * @param channel
	 *            the channel
	 * @return true, if judge conn port exit author:ycguan date:2012-7-9
	 */
	public boolean JudgeConnPortExit(ChannelPort channel, List list) {
		if (null != list) {
			if (list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {
					ChannelPort tmp = (ChannelPort) list.get(i);
					if (tmp.getPort().equalsIgnoreCase(channel.getPort())) {
						return true;
					}
				}
			}
		}
		return false;
	}

	/**
	 * 获取系统树
	 * 
	 * @return
	 */
	public String getSystemTree() {

		String xml = "<system code=\"全网\" name=\"全网\" x_coordinate=\"0\" y_coordinate=\"0\" itemShowCheckBox=\"false\" isBranch=\"true\" type=\"all\" checked=\"0\">";
		SystemInfoModel resultMap;
		List<SystemInfoModel> systems = this.getFiberWireDao().getSystemTree();
		for (int i = 0; i < systems.size(); i++) {
			resultMap = systems.get(i);
			xml += "<system code=\""
					+ resultMap.getSystemcode()
					+ "\" name=\""
					+ resultMap.getSystemname()
					+ "\" x_coordinate=\""
					+ resultMap.getX()
					+ "\" y_coordinate=\""
					+ resultMap.getY()
					+ "\" x_capacity=\""
					+ resultMap.getX_capacity()
					+ "\" projectname=\""
					+ resultMap.getProjectname()
					+ "\" tranmodel=\""
					+ resultMap.getTranmodel()
					+ "\" vendor=\""
					+ resultMap.getVendor()
					+ "\" remark=\""
					+ resultMap.getRemark()
					+ "\" isBranch=\"true\" type=\"system\" itemShowCheckBox=\"true\" checked=\"0\"></system>";
		}
		xml += "</system>";
		return xml;
	}

	public String getSystemTreeBytimerTask() {

		String xml = "<system code=\"全网\" name=\"全网\" x_coordinate=\"0\" y_coordinate=\"0\" itemShowCheckBox=\"false\" isBranch=\"true\" type=\"all\" checked=\"0\">";
		SystemInfoModel resultMap;
		List<SystemInfoModel> systems = this.getFiberWireDao().getSystemTree();
		for (int i = 0; i < systems.size(); i++) {
			resultMap = systems.get(i);
			xml += "<system code=\""
					+ resultMap.getSystemcode()
					+ "\" name=\""
					+ resultMap.getSystemname()
					+ "\" x_coordinate=\""
					+ resultMap.getX()
					+ "\" y_coordinate=\""
					+ resultMap.getY()
					+ "\" x_capacity=\""
					+ resultMap.getX_capacity()
					+ "\" projectname=\""
					+ resultMap.getProjectname()
					+ "\" tranmodel=\""
					+ resultMap.getTranmodel()
					+ "\" vendor=\""
					+ resultMap.getVendor()
					+ "\" remark=\""
					+ resultMap.getRemark()
					+ "\" isBranch=\"false\" type=\"system\" itemShowCheckBox=\"true\" checked=\"0\"></system>";
		}
		xml += "</system>";
		return xml;
	}

	/**
	 * 定时任务模块中的系统树
	 * 
	 * @return
	 */
	public String getTimeSystemTree() {

		String xml = "<system code=\"传输系统\" name=\"传输系统\" x_coordinate=\"0\" y_coordinate=\"0\" itemShowCheckBox=\"false\" isBranch=\"true\" type=\"all\" checked=\"0\">";
		SystemInfoModel resultMap;
		List<SystemInfoModel> systems = this.getFiberWireDao().getSystemTree();
		for (int i = 0; i < systems.size(); i++) {
			resultMap = systems.get(i);
			xml += "<system code=\""
					+ resultMap.getSystemcode()
					+ "\" name=\""
					+ resultMap.getSystemname()
					+ "\" x_coordinate=\""
					+ resultMap.getX()
					+ "\" y_coordinate=\""
					+ resultMap.getY()
					+ "\" x_capacity=\""
					+ resultMap.getX_capacity()
					+ "\" projectname=\""
					+ resultMap.getProjectname()
					+ "\" tranmodel=\""
					+ resultMap.getTranmodel()
					+ "\" vendor=\""
					+ resultMap.getVendor()
					+ "\" remark=\""
					+ resultMap.getRemark()
					+ "\" isBranch=\"true\" type=\"system\" itemShowCheckBox=\"true\" checked=\"0\"></system>";
		}
		xml += "</system>";
		return xml;
	}

	public String getSystemTreeforFangshi() {// add by sjt
		String xml = "<system title=\"全网\" label=\"全网\" x_coordinate=\"0\" y_coordinate=\"0\" isBranch=\"true\" checked=\"0\">";
		SystemInfoModel resultMap;

		List<SystemInfoModel> systems = this.getFiberWireDao().getSystemTree();
		for (int i = 0; i < systems.size(); i++) {
			resultMap = systems.get(i);
			xml += "<system title=\"" + resultMap.getSystemcode()
					+ "\" label=\"" + resultMap.getSystemname()
					+ "\" x_coordinate=\"" + resultMap.getX()
					+ "\" y_coordinate=\"" + resultMap.getY()
					+ "\" isBranch=\"false\" checked=\"0\"></system>";
		}
		xml += "</system>";
		// System.out.println(xml);
		return xml;
	}

	public String getEquipBySystem1(String systemname) {

		String xml = "";
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel) session.getAttribute((String) session
				.getAttribute("userid"));
		List<EquInfoModel> equips = this.getFiberWireDao().getAllEquips(
				systemname, false, user.getUser_id());

		for (EquInfoModel info : equips) {
			xml += "<system code=\""
					+ info.getEquipcode()
					+ "\" name=\""
					+ info.getEquipname()
					+ "\" remark=\""
					+ systemname
					+ "\" isBranch=\"true\" type=\"equip\" itemShowCheckBox=\"true\" checked=\"0\"></system>";
		}

		return xml;
	}

	public String getPortByEquip(String equip) {
		String xml = "";
		List<Map> ports = this.getFiberWireDao().getPortByEquip(equip);

		for (Map info : ports) {
			xml += "<system code=\""
					+ info.get("LOGICPORT")
					+ "\" name=\""
					+ info.get("LABEL")
					+ "\" remark=\""
					+ equip
					+ "\" solt=\""
					+ info.get("SOLT")
					+ "\" isBranch=\"false\" type=\"port\" itemShowCheckBox=\"true\" checked=\"0\"></system>";
		}

		return xml;
	}

	/**
	 * 获取当前系统中的设备和复用段
	 * 
	 * @param systemcode
	 * @param dock
	 *            是否呈现对接设备
	 * @return
	 */
	public String getSystemData(String systemcode, Boolean dock) {
		String liao = "[";
		String li="[";
		String xml = "[";
		String sysname = "";
		String equipcode = "";
		String x_vendor = "";
		String x_model = "";
		String equipname = "";
		String equiplabel = "";
		String x = "";
		String y = "";
		String alarmlevel = "";
		String alarmcount = "";
		String rootalarm = "";
		String stationcode = "";// 增加设备所在站点 modified by mawj
		String stationname = "";
		// 获得系统设备
		Map map = new HashMap();
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel) session.getAttribute((String) session
				.getAttribute("userid"));
		map.put("systemcode", systemcode);
		map.put("alarmman", user.getUser_id());

		try {
			List<EquInfoModel> equips = this.getFiberWireDao().getAllEquips(
					systemcode, dock, user.getUser_id());

			for (EquInfoModel info : equips) {
				systemcode = info.getSystemcode();
				sysname = info.getSysname();
				equipcode = info.getEquipcode().trim();
				x_vendor = info.getX_vendor();
				x_model = info.getX_model();
				equipname = info.getEquipname();
				equiplabel = info.getEquiplabel();
				x = info.getX();
				y = info.getY();
				alarmlevel = info.getAlarmlevel();
				alarmcount = info.getAlarmcount();
				rootalarm = info.getRootalarm();
				stationcode = info.getStationcode();
				stationname = info.getStationname();
				// x_model设备类型为空
				xml += "{\"systemcode\":\"" + systemcode + "\", \"sysname\":\""
						+ sysname + "\", \"equipcode\":\"" + equipcode
						+ "\", \"equipname\":\"" + equipname
						+ "\", \"equiplabel\":\"" + equiplabel
						+ "\", \"x_vendor\":\"" + x_vendor
						+ "\", \"x_model\":\"" + x_model + "\", \"x\":\"" + x
						+ "\", \"y\":\"" + y + "\", \"stationcode\":\""
						+ stationcode + "\", \"stationname\":\"" + stationname
						+ "\", \"alarmlevel\":\"" + alarmlevel
						+ "\", \"alarmcount\":\"" + alarmcount
						+ "\", \"rootalarm\":\"" + rootalarm + "\"},";
			}
			if (equips.size() == 0) {
				xml += "]";
			} else {
				xml = xml.substring(0, xml.length() - 1);
				xml += "]";
			}
			xml += "---";
			// liao-获取业务名称
			boolean adjust = zs;
			if (adjust == false) {
				String business_name;
				List<BusinessInfoModel> business_n = this.getFiberWireDao()
						.getSystemBusiness(map);
				for (BusinessInfoModel bus_liao : business_n) {
					business_name = bus_liao.getBusiness_name();

					// x_model设备类型为空
					liao += "{\"business_name\":\"" + business_name + "\"},";
				}
				if (business_n.size() == 0) {
					liao += "]";
				} else {
					liao = liao.substring(0, liao.length() - 1);
					liao += "]";
				}
				xml += liao;
				xml += "---";
			}
			if (adjust == true) {
				List<HashMap<Object, Object>> result = topolinkDwr
						.businessname(idid);// 取出该复用段上所有不重复业务
				String business_name;

				for (int k = 0; k < result.size(); k++) {
					business_name = result.get(k).get("BUSNAME").toString();
					// x_model设备类型为空
					liao += "{\"business_name\":\"" + business_name + "\"},";
				}
				if (result.size() == 0) {
					liao += "]";
				} else {
					liao = liao.substring(0, liao.length() - 1);
					liao += "]";
				}
				xml += liao;
				xml += "---";
			}
			//
			// 获得系统内部复用段

			List<HashMap> ocables = this.getFiberWireDao()
					.getSystemOcables(map);
			System.out.print("------------------"+ocables.size());
			String equip_a = "", equip_z = "", system_a = "", system_z = "", label = "", topolinkid = "", linerate = "", aendptp = "", aendptpxx = "",
					zendptp = "", zendptpxx = "", linktype = "", linkcolor = "", linkocable = "";
			for (HashMap ocable : ocables) {

				topolinkid = ocable.get("TOPOLINKID") == null ? "" : ocable
						.get("TOPOLINKID").toString();
				equip_a = ocable.get("EQUIP_A").toString();
				system_a = ocable.get("SYSTEM_A").toString();
				equip_z = ocable.get("EQUIP_Z").toString();
				system_z = ocable.get("SYSTEM_Z").toString();
				label = ocable.get("LABEL").toString();
				aendptp = ocable.get("AENDPTP").toString();
				aendptpxx = (null == ocable.get("AENDPTPXX")) ? "" : ocable
						.get("AENDPTPXX").toString();
				zendptp = ocable.get("ZENDPTP").toString();
				zendptpxx = (null == ocable.get("ZENDPTPXX")) ? "" : ocable
						.get("ZENDPTPXX").toString();
				linerate = ocable.get("LINERATE").toString();
				linktype = ocable.get("LINKTYPE").toString();
				linkcolor = ocable.get("LINKCOLOR").toString();

				// 在复用段数据中增加所属光缆信息
//				linkocable = "";
//
//				Map ob = new HashMap();
//				ob = this.getFiberWireDao().selectOcables(label);
//
//				// 光缆编号
//				if (ob.get("ocablecode") != null) {
//					// 该值有可能是逗号隔开的一串编码
//					linkocable = ob.get("ocablecode").toString();
//				}

				
				// 以上新增
				
				li += "{\"equip_a\":\"" + equip_a + "\", \"system_a\":\""
						+ system_a + "\", \"equip_z\":\"" + equip_z
						+ "\", \"system_z\":\"" + system_z + "\", \"label\":\""
						+ label + "\", \"opticalid\":\"" + topolinkid

						//+ "\", \"linkocable\":\"" + linkocable
						+ "\", \"aendptp\":\"" + aendptp
						+ "\", \"aendptpxx\":\"" + aendptpxx
						+ "\", \"zendptp\":\"" + zendptp
						+ "\", \"zendptpxx\":\"" + zendptpxx
						+ "\", \"linerate\":\"" + linerate
						+ "\", \"linktype\":\"" + linktype
						+ "\", \"linkcolor\":\"" + linkcolor + "\"},";

			}
			if (ocables.size() == 0) {
				li += "]";
			} else {
				li = li.substring(0, li.length() - 1);
				li += "]";
			}
			xml += li;
			xml += "---";
		
		String json = "[";
		
		List<HashMap> fibers = this.getFiberWireDao()
				.getSystemFibers(map);
		System.out.print("------------------"+fibers.size());
		String equip_a1 = "", equip_z1 = "";
		        for (HashMap fiber : fibers) {
				equip_a1 = fiber.get("EQUIP_A1").toString();
				equip_z1 = fiber.get("EQUIP_Z1").toString();
			
		        json += "{\"equip_a1\":\"" + equip_a1
						+ "\", \"equip_z1\":\"" + equip_z1 + "\"},";
	    }
	    if (fibers.size() == 0) {
		   json += "]";
	   } else {
		   json = json.substring(0, json.length() - 1);
		   json += "]";
	  }
	     xml += json;
     } catch (Exception e) {
			e.printStackTrace();
		}
		return xml;
	}

	public String getTransDevice(String id, String type) {
		String xml = "";
		try {
			if (id == null) {
				List<HashMap> list = this.getFiberWireDao().getEquipTypeXtxx();

				for (HashMap lst : list) {
					String xtbm = (String) lst.get("XTBM");
					String xtxx = (String) lst.get("XTXX");
					xml += "\n"
							+ "<folder state='0' code='"
							+ xtbm
							+ "' label='"
							+ xtxx
							+ "' parameter='"
							+ xtbm
							+ "' isBranch='true' leaf='false' type='equiptype' >";
					xml += "\n" + "</folder>";
				}
			} else {
				if ("equiptype".equalsIgnoreCase(type)) {
					List<HashMap> childlist = this.getFiberWireDao()
							.getVendorByEquipType(id);
					for (HashMap clst : childlist) {
						String vendorcode = (String) clst.get("XTBM");
						String vendorname = (String) clst.get("XTXX");
						xml += "\n"
								+ "<folder state='0' code='"
								+ vendorcode
								+ "' label='"
								+ vendorname
								+ "' parameter='"
								+ id
								+ "#"
								+ vendorcode
								+ "'isBranch='true' leaf='false' type='vendor' >";
						xml += "\n" + "</folder>";
					}
				} else if ("vendor".equalsIgnoreCase(type)) {
					String[] type_vendor = id.split("#");
					List<HashMap> leaflist = this.getFiberWireDao()
							.getEquipmentByVendor(type_vendor[0],
									type_vendor[1]);
					for (HashMap llst : leaflist) {
						String equipcode = (String) llst.get("EQUIPCODE");
						String equipname = (String) llst.get("EQUIPNAME");
						String equiplabel = (String) llst.get("EQUIPLABEL");
						String x_model = (String) llst.get("X_MODEL")
								.toString().replaceAll(" ", "");
						String connections = (String) llst.get("NEWEQUIPCODE");
						xml += "\n" + "<folder state='0' code='" + equipcode
								+ "' label='" + equipname + "' equiplabel='"
								+ equiplabel + "' vendor='" + type_vendor[1]
								+ "' x_model='"
								+ x_model.replace(" ", "").replace("/", "")
								+ "' connections='" + connections
								+ "'isBranch='false' leaf='true'>\n</folder>";
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return xml;

	}

	public Boolean SaveSysOrgMap(ArrayList<EquInfoModel> equiplist) {
		Boolean result = true;
		try {
			fiberWireDao.updateSystemEquip(equiplist);

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		}
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("修改", "系统组织图", "修改系统组织图", "", request);

		return result;
	}

	public void addSys(SystemInfoModel systemInfo) {
		fiberWireDao.addSys(systemInfo);
	}

	public int modSys(SystemInfoModel systemInfo) {
		return fiberWireDao.modSys(systemInfo);
	}

	public void delSys(String systemcode) {
		fiberWireDao.delSys(systemcode);
	}

	/**
	 * 查询设备模版数据
	 * 
	 * @return xml
	 * @author xiezhikui
	 */
	public String getDeviceModel() {
		String xml = "<models>";
		List<HashMap> list = this.getFiberWireDao().getDeviceModelList();
		List<HashMap> fileList = getFileNames();
		for (HashMap lst : list) {
			String x_model = (String) lst.get("X_MODEL");
			String image_model = x_model.replace(" ", "");
			image_model = image_model.replace("/", "");
			String vendor = (String) lst.get("XTBM");
			String label = (String) lst.get("XTXX");
			if (!x_model.equals("default") && !x_model.equals("guangxun")
					&& !x_model.equals("nonManagedElement")) {
				String source = vendor + '-' + image_model + ".png";
				// 删除没有相对应的设备模板 if (!isExists(fileList, source))
				// source = "noIcon.png";
				// if (x_model.equalsIgnoreCase("虚拟设备"))
				// source = vendor + "-xunishebei.png";
				if (isExists(fileList, source))
					xml += "<model vendor='" + vendor + "' label='" + label
							+ "' x_model='" + x_model
							+ "' source='twaverImages/device/" + source + "'/>";
			}
		}
		xml += "</models>";

		return xml;
	}

	private Boolean isExists(List list, String name) {
		Boolean bool = false;
		for (int i = 0; i < list.size(); i++) {
			HashMap map = (HashMap) list.get(i);
			if (map.get("fileName").toString().equalsIgnoreCase(name)) {

				return true;
			}
		}
		return bool;
	}

	private List getFileNames() {
		HttpServletRequest request = FlexContext.getHttpRequest();
		String path = request.getRealPath("") + "\\twaverImages\\device";
		File f = new File(path);
		File[] files = f.listFiles();
		List<HashMap> list = new ArrayList();
		for (int i = 0; i < files.length; i++) {
			HashMap map = new HashMap();
			map.put("fileName", files[i].getName());
			list.add(map);
		}
		return list;
	}

	/**
	 * 根据服用段编号返回光路路由的数据对象。
	 * 
	 * @param topoLinkID为复用段编号
	 * @return OcableRoutInfo数据对象
	 * @author ls
	 * @version
	 * */
	// public OcableRoutInfoData getOcableRoutInfo(String topoLinkID) {
	// OcableRoutInfoData ori = new OcableRoutInfoData();
	// ChannelRoutResultModel routdata = new ChannelRoutResultModel();
	// String chanRoutName = null;
	// String systemcode = null;
	// List<ChannelRoutModel> channelRoutData = null;
	// List stationNames = null;
	// try {
	// routdata = this.getFiberWireDao().getChanRoutNameByTopolinkID(
	// topoLinkID);
	// if (routdata != null) {
	// chanRoutName = routdata.getFIBERCHANNELCODE();
	// systemcode = routdata.getSYSTEMCODE();
	// if (chanRoutName != null) {
	// stationNames = this.getFiberWireDao()
	// .getStationNamesByByCRName(chanRoutName);
	// channelRoutData = this.getFiberWireDao()
	// .getChannelRoutDataByCRName(chanRoutName);
	// ori.setSystemName(systemcode);
	// ori.setChannelRoutModelData(channelRoutData);
	// ori.setStationNames(stationNames);
	// } else {
	// return null;
	// }
	//
	// } else {
	// return null;
	// }
	//
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// return ori;
	// }

	public OcableRoutInfoData getOcableRoutInfoByFiber(String ocablecode,
			String fiberserial) {
		OcableRoutInfoData ori = new OcableRoutInfoData();
		ChannelRoutResultModel routdata = new ChannelRoutResultModel();
		String chanRoutName = null;
		String systemcode = null;
		List<ChannelRoutModel> channelRoutData = null;
		List stationNames = null;
		try {
			routdata = this.getFiberWireDao().getOcableRoutInfoByFiber(
					ocablecode, fiberserial);
			if (routdata != null) {
				chanRoutName = routdata.getFIBERCHANNELCODE();
				systemcode = routdata.getSYSTEMCODE();// 无意义
				if (chanRoutName != null) {
					stationNames = this.getFiberWireDao()
							.getStationNamesByByCRName(chanRoutName);
					channelRoutData = this.getFiberWireDao()
							.getChannelRoutDataByCRName(chanRoutName);
					ori.setSystemName(systemcode);
					ori.setChannelRoutModelData(channelRoutData);
					ori.setStationNames(stationNames);
				} else {
					return null;
				}

			} else {
				return null;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return ori;

	}

	public static boolean zs = false;
	public static String idid = "";

	public void hsdata(boolean a, String b) {
		zs = a;
		idid = b;
	}

	public void deleteEquipReSys(String equipcode, String systemcode) {
		this.fiberWireDao.deleteEquipReSys(equipcode, systemcode);
	}

	public void createFrameandSlot(String vendor, String model_name,
			String equipcode) throws ParserConfigurationException,
			SAXException, IOException {
		try {
			devicepanel.dwr.DevicePanelDwr getxml = new DevicePanelDwr();
			String xmlStr = getxml.getModelContext(vendor, model_name);
			Map map = new HashMap();
			DataBox box = new DataBox();
			XMLSerializer xmlserializer = new XMLSerializer(box);
			xmlserializer.deserializeXML(xmlStr);
			for (int i = 0; i < box.getDatas().size(); i++) {

				if (box.getDatas().get(i) instanceof Follower) {
					Follower follower = (Follower) box.getDatas().get(i);
					if (follower.getClient("ShapeType").equals("板卡")) {
						EquipFrame equipframe = new EquipFrame();
						equipframe.setEquipcode(equipcode);
						equipframe.setFrontheight("");
						equipframe.setFrontwidth("");
						equipframe.setRemark("");
						equipframe.setS_framename("");
						equipframe.setUpdatedate("");
						equipframe.setUpdateperson("");
						FrameSlot equipslot = new FrameSlot();
						equipslot.setEquipcode(equipcode);
						equipslot.setRemark("");
						equipslot.setStatus("");
						equipslot.setRemark("");
						equipslot.setUpdatedate("");
						String[] arr = follower.getName().split("_");
						if (arr.length == 1) {

							equipframe.setFrameserial("1");
							equipslot.setFrameserial("1");
							equipslot.setSlotserial(arr[0]);
						} else if (arr.length == 2) {
							equipframe.setFrameserial(arr[0]);
							equipslot.setFrameserial(arr[0]);
							equipslot.setSlotserial(arr[1]);
						}
						try {
							if (map.get(equipframe.getFrameserial()) == null) {
								resNodeDao.AddEquipFrame(equipframe);
								map.put(equipframe.getFrameserial(),
										equipframe.getFrameserial());
							}
							resNodeDao.AddEquipSlot(equipslot);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 光路路由导出EXCEL
	 * 
	 * @param fiberchannelcode
	 * @param url
	 * @return
	 */
	public String exportOcableRouteExcel(String fiberchannelcode, String url) {
		OcableRoutInfoData ori = new OcableRoutInfoData();
		List<ChannelRoutModel> channelRoutData = null;
		List stationNames = null;
		try {
			stationNames = this.getFiberWireDao().getStationNamesByByCRName(
					fiberchannelcode);
			channelRoutData = this.getFiberWireDao()
					.getChannelRoutDataByCRName(fiberchannelcode);
			ori.setStationNames(stationNames);
			ori.setChannelRoutModelData(channelRoutData);
		} catch (Exception e) {
			e.printStackTrace();
		}

		HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
		String realPath = request.getRealPath("");
		String templateFilePath = realPath
				+ "/assets/excels/template/ocablerouteinfo.xls";
		String ocablerouteinfoPath = realPath + "/assets/excels/expfiles/"
				+ fiberchannelcode + ".xls";
		String relativeCircuitFilePath = realPath + "/assets/excels/expfiles/"
				+ fiberchannelcode + ".xls";
		String filepath = realPath + "/assets/excels/expfiles/";
		String filename = fiberchannelcode;
		try {
			FileInputStream fin = new FileInputStream(
					new File(templateFilePath));
			FileOutputStream fout = new FileOutputStream(new File(
					ocablerouteinfoPath));
			int bytesRead;
			byte[] buf = new byte[8 * 1024]; // 4K
			while ((bytesRead = fin.read(buf)) != -1) {
				fout.write(buf, 0, bytesRead);
			}
			fout.flush();
			fout.close();
			fin.close();

			Workbook wb = Workbook.getWorkbook(new File(ocablerouteinfoPath));
			WritableWorkbook workbook = Workbook.createWorkbook(new File(
					ocablerouteinfoPath), wb);
			WritableSheet sheet = workbook.getSheet(1);
			WritableFont cellFont = new WritableFont(
					WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
			WritableCellFormat cellFormat = new WritableCellFormat();
			WritableCellFormat cellFormat2 = new WritableCellFormat(cellFont);
			cellFormat.setBorder(Border.ALL, jxl.format.BorderLineStyle.THIN);
			cellFormat2.setAlignment(jxl.format.Alignment.CENTRE);
			String stationName = "";
			for (int i = 0; i < stationNames.size(); i++) {
				stationName += stationNames.get(i).toString() + "-";
			}
			stationName = stationName.substring(0, stationName.length() - 1);
			Label title = new Label(0, 0, stationNames.get(0).toString() + "-"
					+ stationNames.get(stationNames.size() - 1).toString()
					+ "光路路由列表");
			title.setCellFormat(cellFormat2);
			sheet.addCell(title);
			Label station = new Label(2, 2, stationName);
			station.setCellFormat(cellFormat);
			sheet.addCell(station);
			int j = 0;
			for (int i = 0; i < channelRoutData.size(); i++) {
				Label l1 = new Label(1, j + 6, channelRoutData.get(i)
						.getEQUIPNAME());
				l1.setCellFormat(cellFormat);
				sheet.addCell(l1);
				Label l2 = new Label(2, j + 6, channelRoutData.get(i)
						.getNAME_NODE1());
				l2.setCellFormat(cellFormat);
				sheet.addCell(l2);
				Label l3 = new Label(3, j + 6, channelRoutData.get(i)
						.getEQUIPNAME());
				l3.setCellFormat(cellFormat);
				sheet.addCell(l3);
				Label l4 = new Label(4, j + 6, channelRoutData.get(i)
						.getNAME_NODE2());
				l4.setCellFormat(cellFormat);
				sheet.addCell(l4);
				j++;
				if (channelRoutData.get(i).getOCABLESECTIONNAME() != null
						&& !channelRoutData.get(i).getOCABLESECTIONNAME()
								.equals("")) {
					Label o1 = new Label(1, j + 6, channelRoutData.get(i)
							.getOCABLESECTIONNAME());
					o1.setCellFormat(cellFormat);
					sheet.addCell(o1);
					Label o2 = new Label(2, j + 6, channelRoutData.get(i)
							.getFIBERSERIAL1() + "芯");
					o2.setCellFormat(cellFormat);
					sheet.addCell(o2);
					Label o3 = new Label(3, j + 6, channelRoutData.get(i)
							.getOCABLESECTIONNAME());
					o3.setCellFormat(cellFormat);
					sheet.addCell(o3);
					Label o4 = new Label(4, j + 6, channelRoutData.get(i)
							.getFIBERSERIAL2() + "芯");
					o4.setCellFormat(cellFormat);
					sheet.addCell(o4);
					j++;
				}

			}
			WritableSheet sheet2 = workbook.getSheet(0);
			Label title2 = new Label(0, 0, stationNames.get(0).toString() + "-"
					+ stationNames.get(stationNames.size() - 1).toString()
					+ "光路路由图");
			title2.setCellFormat(cellFormat2);
			sheet2.addCell(title2);
			Label startStation = new Label(2, 1, stationNames.get(0).toString());
			sheet2.addCell(startStation);
			Label endstation = new Label(7, 1, stationNames.get(
					stationNames.size() - 1).toString());
			sheet2.addCell(endstation);
			workbook.write();
			workbook.close();
			this.updateExcelImageBySheet(ocablerouteinfoPath, 0,
					request.getRealPath("")
							+ "/assets/excels/template/ocableroute.png", 1, 4);
			// String path = request.getLocalName();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return filename;
	}

	private JFileChooser getFile() {
		// 默认打开D盘
		JFileChooser file = new JFileChooser();
		// 下面这句是去掉显示所有文件这个过滤器。
		file.setAcceptAllFileFilterUsed(false);
		// 添加excel文件的过滤器
		file.addChoosableFileFilter(new FileFilter() {

			public String getDescription() {
				return null;
			}

			public boolean accept(File f) {
				return false;
			}
		});
		int result = file.showSaveDialog(null);

		// JFileChooser.APPROVE_OPTION是个整型常量，代表0。就是说当返回0的值我们才执行相关操作，否则什么也不做。
		if (result == JFileChooser.APPROVE_OPTION) {

			// 获得你选择的文件绝对路径。并输出。当然，我们获得这个路径后还可以做很多的事。
			String path = file.getSelectedFile().getAbsolutePath();
			System.out.println(path);
		} else {
			file = null;
			System.out.println("你已取消并关闭了窗口！");

		}
		return file;
	}

	/**
	 * 保存图片到EXCEL
	 * 
	 * @param excelfilename
	 * @param sheetnum
	 * @param imagepath
	 * @param imagerow
	 * @param imagecol
	 * @throws IOException
	 * @throws WriteException
	 */
	public void updateExcelImageBySheet(String excelfilename, int sheetnum,
			String imagepath, int imagerow, int imagecol) throws IOException,
			WriteException {
		WritableFont wfontLable = new WritableFont(WritableFont.TIMES, 12,
				WritableFont.NO_BOLD, false,
				jxl.format.UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLACK);
		WritableCellFormat contentFormat = new WritableCellFormat(wfontLable);
		// contentFormat.setBorder(Border.ALL,
		// BorderLineStyle.THIN,jxl.format.Colour.BLACK);
		contentFormat.setAlignment(jxl.format.Alignment.LEFT);
		contentFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		try {
			Workbook wb = Workbook.getWorkbook(new File(excelfilename));
			WritableWorkbook workbook = Workbook.createWorkbook(new File(
					excelfilename), wb);
			WritableSheet sheetpic = workbook.getSheet(sheetnum);
			File fileImage = new File(imagepath);
			BufferedImage bi7 = ImageIO.read(new File(imagepath));
			int picWidth = bi7.getWidth();
			int picHeight = bi7.getHeight();
			// 输入参数, 图片显示的位ID
			double picBeginCol = 1.2;
			double picBeginRow = 1.2;
			double picCellWidth = 0.0;
			double picCellHeight = 0.0;
			int _picWidth = picWidth * 32;
			for (int x = 0; x < 1234; x++) {
				int bc = (int) Math.floor(picBeginCol + x);
				int v = sheetpic.getColumnView(bc).getSize();
				double _offset0 = 0.0;
				if (0 == x)
					_offset0 = (picBeginCol - bc) * v;
				if (0.0 + _offset0 + _picWidth > v) {
					double _ratio = 1.0;
					if (0 == x)
						_ratio = (0.0 + v - _offset0) / v;
					picCellWidth += _ratio;
					_picWidth -= (int) (0.0 + v - _offset0); // int
				} else {
					double _ratio = 0.0;
					if (v != 0)
						_ratio = (0.0 + _picWidth) / v;
					picCellWidth += _ratio;
					break;
				}
				if (x >= 1233) {
				}
			}
			// 此时 picCellWidth
			int _picHeight = picHeight * 15;
			for (int x = 0; x < 1234; x++) {
				int bc = (int) Math.floor(picBeginRow + x);
				int v = sheetpic.getRowView(bc).getSize();
				double _offset0 = 0.0;
				if (0 == x)
					_offset0 = (picBeginRow - bc) * v;
				if (0.0 + _offset0 + _picHeight > v) {
					double _ratio = 1.0;
					if (0 == x)
						_ratio = (0.0 + v - _offset0) / v;
					picCellHeight += _ratio;
					_picHeight -= (int) (0.0 + v - _offset0);
				} else {
					double _ratio = 0.0;
					if (v != 0)
						_ratio = (0.0 + _picHeight) / v;
					picCellHeight += _ratio;
					break;
				}
				if (x >= 1233) {
				}
			}
			WritableImage image = new WritableImage(imagerow, imagecol,
					picCellWidth, picCellHeight, fileImage);
			sheetpic.addImage(image);
			workbook.write();
			workbook.close();
		} catch (Exception e) {
			System.out.println(e);
		}

	}

	/**
	 * 根据传过来的二进制数组生成图片
	 *
	 * @param byte[] bytearray
	 * @return void
	 */
	public void getByteData(byte[] bytearray) {
		try {
			HttpServletRequest request = FlexContext.getHttpRequest();
			InputStream buffin = new ByteArrayInputStream(bytearray);
			BufferedImage bufferedImage = ImageIO.read(buffin);
			if (bufferedImage != null) {
				ImageIO.write(bufferedImage, "png",
						new File(request.getRealPath("")
								+ "/assets/excels/template/ocableroute.png"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public void addEquipToSystem(String systemcode, String equipcode) {
		try {
			this.getFiberWireDao().addEquipToSystem(systemcode, equipcode);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public String getPortsByLabel(String label) {
		String xml = "<names>";
		HashMap<String, String> resultMap = new HashMap<String, String>();
		List<HashMap> list = this.getFiberWireDao().getPortsByLabel(label);
		if (list.size() > 0) {
			xml += "<name label =\"" + list.get(0).get("AENDPTPXX")
					+ "\"code=\"" + list.get(0).get("AENDPTP") + "\"/>";
			xml += "<name label =\"" + list.get(0).get("ZENDPTPXX")
					+ "\"code=\"" + list.get(0).get("ZENDPTP") + "\"/>";
		}

		xml += "</names>";
		return xml;

	}

	private int e = 0;
	public int _nodeCount = 0;
	private int _pathCount = 0;
	private Node startNode;
	private Node endNode;
	private List<String> paths = new ArrayList<String>();
	private List<String> all = new ArrayList<String>();
	private ElementBox box = new ElementBox();
	private XMLSerializer serializer = new XMLSerializer(box);

	public List<String> getPaths(String networkXML, String startID,
			String endID, int nodeCount, int pathCount) {
		try {
			box.clear();
			paths.clear();
			all.clear();
			e = 0;
			serializer.deserializeXML(networkXML);
			startNode = (Node) box.getElementByID(startID);
			endNode = (Node) box.getElementByID(endID);
			_nodeCount = nodeCount;
			_pathCount = pathCount;
			paths.add(startNode.getID().toString());
			Timer timer = new Timer();
			timer.schedule(new StopTask(this, timer), 10000);
			getRoutePath();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return all;
	}

	private void getRoutePath() {
		try {
			if (_nodeCount <= 0) {
				System.out.println("系统为您推荐了" + all.size() + "个方案");
				for (int i = 0; i < all.size(); i++) {
					System.out.println(all.get(i));
				}
				return;
			}
			List<String> ps = new ArrayList<String>();
			ps = paths;
			paths = new ArrayList<String>();
			for (String path : ps) {
				String[] t = path.split("-");
				String last = t[t.length - 1];
				Node lastNode = (Node) box.getElementByID(last);
				if (lastNode.getLinks().equals(null)
						|| lastNode.getLinks() == null) {
					continue;
				}
				for (int k = 0; k < lastNode.getLinks().size(); k++) {
					Link link = (Link) lastNode.getLinks().get(k);
					Node next = link.getFromNode() == lastNode ? link
							.getToNode() : link.getFromNode();
					String p = new String(path);
					if (path.indexOf(next.getID().toString()) < 0) {
						p += "-" + next.getID();
						if (next.getID() == endNode.getID()) {
							e++;
							if (e > _pathCount) {
								return;
							}
							all.add(p);
						} else {
							if (paths.indexOf(p) < 0) {
								paths.add(p);
							}
						}
					}
				}
			}
			_nodeCount--;
			getRoutePath();
		} catch (Exception e) {
			e.printStackTrace();
			return;
		}
	}

	public Map getEquipCcxx(String belongequip, String start, String end) {
		Map para = new HashMap();
		para.put("returnList",
				this.getFiberWireDao().getEquipCc(belongequip, start, end));
		para.put("count", this.getFiberWireDao().getEquipCcCount(belongequip));
		return para;
	}

	public Map searchTasks(String start, String end) {
		Map para = new HashMap();
		para.put("list", this.getFiberWireDao().searchTasks(start, end));
		para.put("count", this.getFiberWireDao().searchTaskCount());
		return para;
	}

	@SuppressWarnings("unchecked")
	public String insertTask(Map taskObject, List portList) {
		String flag = "success";
		try {
			this.getFiberWireDao().insertTask(taskObject, portList);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}

	public String delTask(String id) {
		String flag = "success";
		try {
			this.getFiberWireDao().delTask(id);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}

	public String updateTask(Map taskObject, List portList) {
		String flag = "success";
		try {
			this.getFiberWireDao().updateTask(taskObject, portList);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}

	public String getTypeBycircuitCode(String circuitCode) {
		return this.getFiberWireDao().getTypeBycircuitCode(circuitCode);
	}

	/**
	 * 查询该设备下所有端口信息
	 *
	 * @2013-4-1
	 * @author jtsun
	 * @param equipcode
	 * @return
	 */
	public ResultModel getPortsByEquipcode(String equipcode, String start,
			String end) {
		ResultModel result = new ResultModel();
		result.setTotalCount(fiberWireDao.getPortsByEquipcodeCount(equipcode));
		result.setOrderList(fiberWireDao.getPortsByEquipcodeInfo(equipcode,
				start, end));
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("查询", "网络拓扑图", "查询该设备下所有端口信息", "", request);
		return result;
	}

	/**
	 * 查询性能
	 *
	 * @2013-4-2
	 * @author jtsun
	 * @param logicport
	 * @return
	 */
	public ResultModel getLinedata(String logicport, String time, String date) {
		ResultModel result = new ResultModel();
		result.setOrderList(fiberWireDao
				.getPortsPerTrend(logicport, time, date));
		return result;
	}

	/**
	 * 获取当前系统中的设备和复用段 增加个数限制
	 * 
	 * @param systemcode
	 * @param dock
	 *            是否呈现对接设备
	 * @return
	 */
	public String getSystemDataByCount(String systemcode, Boolean dock,
			String count) {
		String xml = "[";
		String sysname = "";
		String equipcode = "";
		String x_vendor = "";
		String x_model = "";
		String equipname = "";
		String equiplabel = "";
		String x = "";
		String y = "";
		String alarmlevel = "";
		String alarmcount = "";
		String rootalarm = "";
		String stationcode = "";// 增加设备所在站点 modified by mawj
		String stationname = "";
		// 获得系统设备
		Map map = new HashMap();
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel) session.getAttribute((String) session
				.getAttribute("userid"));
		map.put("systemcode", systemcode);
		map.put("alarmman", user.getUser_id());
		// map.put("count", count);
		try {

			List<EquInfoModel> equips = this.getFiberWireDao()
					.getAllEquipsByCount(systemcode, dock, user.getUser_id(),
							count);

			for (EquInfoModel info : equips) {
				systemcode = info.getSystemcode();
				sysname = info.getSysname();
				equipcode = info.getEquipcode().trim();
				x_vendor = info.getX_vendor();
				x_model = info.getX_model();
				equipname = info.getEquipname();
				equiplabel = info.getEquiplabel();
				x = info.getX();
				y = info.getY();
				alarmlevel = info.getAlarmlevel();
				alarmcount = info.getAlarmcount();
				rootalarm = info.getRootalarm();
				stationcode = info.getStationcode();
				stationname = info.getStationname();
				// x_model设备类型为空
				xml += "{\"systemcode\":\"" + systemcode + "\", \"sysname\":\""
						+ sysname + "\", \"equipcode\":\"" + equipcode
						+ "\", \"equipname\":\"" + equipname
						+ "\", \"equiplabel\":\"" + equiplabel
						+ "\", \"x_vendor\":\"" + x_vendor
						+ "\", \"x_model\":\"" + x_model + "\", \"x\":\"" + x
						+ "\", \"y\":\"" + y + "\", \"stationcode\":\""
						+ stationcode + "\", \"stationname\":\"" + stationname
						+ "\", \"alarmlevel\":\"" + alarmlevel
						+ "\", \"alarmcount\":\"" + alarmcount
						+ "\", \"rootalarm\":\"" + rootalarm + "\"},";
			}
			if (equips.size() == 0) {
				xml += "]";
			} else {
				xml = xml.substring(0, xml.length() - 1);
				xml += "]";
			}
			xml += "---";
			String json = "[";
			// 获得系统内部复用段
			// 增加复用段关联光路字段
			List<HashMap> ocables = this.getFiberWireDao()
					.getSystemOcables(map);
			String equip_a = "", equip_z = "", system_a = "", system_z = "", label = "", linerate = "", aendptp = "", aendptpxx = "", topolinkid = "", zendptp = "", zendptpxx = "", linktype = "", linkcolor = "", linkocable = "";
			for (HashMap ocable : ocables) {
				topolinkid = ocable.get("TOPOLINKID") == null ? "" : ocable
						.get("TOPOLINKID").toString();
				equip_a = ocable.get("EQUIP_A").toString();
				system_a = ocable.get("SYSTEM_A").toString();
				equip_z = ocable.get("EQUIP_Z").toString();
				system_z = ocable.get("SYSTEM_Z").toString();
				label = ocable.get("LABEL").toString();
				aendptp = ocable.get("AENDPTP").toString();
				aendptpxx = (null == ocable.get("AENDPTPXX")) ? "" : ocable
						.get("AENDPTPXX").toString();
				zendptp = ocable.get("ZENDPTP").toString();
				zendptpxx = (null == ocable.get("ZENDPTPXX")) ? "" : ocable
						.get("ZENDPTPXX").toString();
				linerate = ocable.get("LINERATE").toString();
				linktype = ocable.get("LINKTYPE").toString();
				linkcolor = ocable.get("LINKCOLOR").toString();

				// 在复用段数据中增加所属光缆信息
//				linkocable = "";
//				Map ob = new HashMap();
//				ob = this.getFiberWireDao().selectOcables(label);
//
//				if (ob.get("ocablecode") != null) {
//					linkocable = ob.get("ocablecode").toString();
//				}

				// 以上新增

				json += "{\"equip_a\":\"" + equip_a + "\", \"system_a\":\""
						+ system_a + "\", \"equip_z\":\"" + equip_z
						+ "\", \"system_z\":\"" + system_z + "\", \"label\":\""
						+ label + "\", \"opticalid\":\"" + topolinkid

						//+ "\", \"linkocable\":\"" + linkocable

						+ "\", \"aendptp\":\"" + aendptp
						+ "\", \"aendptpxx\":\"" + aendptpxx
						+ "\", \"zendptp\":\"" + zendptp
						+ "\", \"zendptpxx\":\"" + zendptpxx
						+ "\", \"linerate\":\"" + linerate
						+ "\", \"linktype\":\"" + linktype
						+ "\", \"linkcolor\":\"" + linkcolor + "\"},";

			}
			if (ocables.size() == 0) {
				json += "]";
			} else {
				json = json.substring(0, json.length() - 1);
				json += "]";
			}
			xml += json;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return xml;
	}

	public String getPortCodeByToplinkid(String toplinkid) {
		String portcode = "";
		portcode = (String) this.basedao.queryForObject(
				"getPortCodeByToplinkid", toplinkid);
		if (portcode == null) {
			portcode = "";
		}
		// if(portcode.indexOf(",")!=-1){
		// portcode=portcode.split(",")[0];
		// }
		return portcode;
	}

	public String getOpticalIDByFiber(String ocableid, String fiberserial) {
		String opticalids = "";
		Map map = new HashMap();
		map.put("ocableid", ocableid);
		map.put("fiberserial", fiberserial);
		opticalids = (String) this.basedao.queryForObject(
				"getOpticalIDByFiber", map);
		if ("-1".equals(opticalids)) {
			opticalids = "";
		} else {
			// 查询光路下是否有复用段
			String resid = (String) this.basedao.queryForObject(
					"getAportcodeByResid", opticalids);
			if (resid == null || "".equals(resid)) {
				// 查找光路起始端口
				opticalids = (String) this.basedao.queryForObject(
						"getOpticalPortcodeAByID", opticalids);
			} else {
				// 根据复用段查找端口
				opticalids = (String) this.basedao.queryForObject(
						"getPortCodeByResid", resid);
			}

		}
		return opticalids;
	}

	public String getOpticalIDByPortcode(String portcode) {
		String result = "";
		// 根据端口查找复用段
		String resid = (String) this.basedao.queryForObject("getToplinkResid",
				portcode);
		if (resid == null || "".equals(resid)) {
			return result;
		} else {
			// 查找光路id
			String opticalid = (String) this.basedao.queryForObject(
					"getOpticalResidByToplink", resid);
			if (opticalid == null || "".equals(opticalid)) {
				return result;
			} else {
				return portcode;
			}
		}

	}

	public String getSystemTree1() {

		String xml = "<system code=\"全网\" name=\"全网\" x_coordinate=\"0\" y_coordinate=\"0\" itemShowCheckBox=\"false\" isBranch=\"true\" type=\"all\" checked=\"0\">";
		SystemInfoModel resultMap;
		List<SystemInfoModel> systems = this.getFiberWireDao().getSystemTree();
		for (int i = 0; i < systems.size(); i++) {
			resultMap = systems.get(i);
			xml += "<system code=\""
					+ resultMap.getSystemcode()
					+ "\""
					+ " name=\"业务名称\""
					+ " x_coordinate=\""
					+ resultMap.getX()
					+ "\" y_coordinate=\""
					+ resultMap.getY()
					+ "\" x_capacity=\""
					+ resultMap.getX_capacity()
					+ "\" projectname=\""
					+ resultMap.getProjectname()
					+ "\" tranmodel=\""
					+ resultMap.getTranmodel()
					+ "\" vendor=\""
					+ resultMap.getVendor()
					+ "\" remark=\""
					+ resultMap.getRemark()
					+ "\" isBranch=\"true\" type=\"system\" itemShowCheckBox=\"true\" checked=\"0\"></system>";
		}
		xml += "</system>";
		return xml;
	}

}
