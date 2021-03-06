package channelroute.dwr;

import java.awt.geom.Point2D;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;

import jcifs.dcerpc.msrpc.lsarpc;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import com.sun.org.apache.bcel.internal.generic.RETURN;

import twaver.Consts;
import twaver.ElementBox;
import twaver.Follower;
import twaver.Group;
import twaver.IData;
import twaver.IElement;
import twaver.Layer;
import twaver.Link;
import twaver.Node;
import twaver.SerializationSettings;
import twaver.Styles;
import twaver.XMLSerializer;
import channelroute.metarnet.ComparatorPort;
import channelroute.model.ChannelEquipment;
import channelroute.model.ChannelLink;
import channelroute.model.ChannelPort;
import channelroute.model.Circuit;


public class ChannelRouteAction
{

	private SqlMapClientTemplate sqlMapClientTemplate;

    public SqlMapClientTemplate getSqlMapClientTemplate() {
	   return sqlMapClientTemplate;
    }

    public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	   this.sqlMapClientTemplate = sqlMapClientTemplate;
    }
    /**
     * 保存起始端口
     */
    private ChannelPort startPort;
    /**
     * 保存终止端口
     */
    private ChannelPort endPort;
    /**
     * 端口对象：用来临时保存遍历的端口对象
     */
    private ChannelPort channelport = null;

    
    /**
     * 设备对象：用来临时保存遍历的设备对象
     */
    private ChannelEquipment channelequipment = null;

   

    /**
     * 速率：当前电路的交叉速率
     */
    private String rate = "VC12";

    /**
     * 端口在设备上的左侧的上中下三个位置
     */
    int[] position = new int[]{1, 2, 3};
    /**
     * 端口LIST：用来保存整个电路的端口
     */

	private List<ChannelPort> portlist = null;

    /**
     * 设备列表：用来保存串接电路时的所有设备信息
     */

	private List<ChannelEquipment> equipList = null;
	/**
	 * 用来保存串接电路时的所有端口信息列表
	 */
	private List<ChannelLink> linkList=null;
    /**
     * 整个系统中设备的宽度
     */
    private static final double equip_Width=150.0;
    /**
     * 整个系统中设备的高度
     */
    private static final double equip_Height=150.0;
    /**
     * 瘦设备的高度(交叉时隙只有一条)
     */
    private static final double thinEquip_Height=50.0;
    /**
     * 瘦设备的端口y坐标
     */
    private static final double thinPort_Y=17;
    /**
     * 整个系统中端口图片宽度
     */
    private static final double port_Width=16.0;
    
    /**
     * 整个系统中端口图片的高度
     */
    private static final double port_Height=16.0;
    /**
     * 普通端口图片路径
     */
    private static final String portImage="twaverImages/channelroute/luyou_port.png";
    /**
     * 支路端口的图片路径
     */
    private static final String branchPortImage="twaverImages/channelroute/luyou_port2.png";
    /**
     * 设备图片的路径
     */
    private static final String equipImage="twaverImages/channelroute/luyou_bg.png";
    
    /**
     * 虚拟设备图片的路径
     */
    private static final String virtualEquipImage="twaverImages/channelroute/luyou_bg1.png";
    /**
     * 整个系统中标签的高度
     */
    private static final double label_Height=20.0;
    /**
     * 整个系统中标签相对设备的x坐标
     */
    private static final double label_x=40;
    /**
     * 设备的名称伴随节点(follower)的id后缀
     */
    private static final String name_ID="1";
    /**
     * 设备的型号伴随节点(follower)的id后缀
     */
    private static final String model_ID="2";

    /**
     * 起始设备x坐标
     */
    int x = 80;

    /**
     * 起始设备y坐标
     */
    int y = 150;

    /**
     * 设备x坐标偏移量
     */
    int dx = 220;

    /**
     * 设备坐标y偏移量
     */
    int dy = 200;

    /**
     * 端口相对设备的x坐标
     */
    double[] port_x = new double[]{8, 126};

    /**
     * 端口相对设备的y坐标
     */
    double[] port_y = new double[]{17, 67, 117};

   
    /**
	 * 整条电路的速率（暂时只支持2M/155M(VC4/VC12) STM4的还未处理）
	 */
	private String circuitRate = null;
	/**
	 * 当前串接的电路编号
	 */
	private String currentCircuitCode="";
	/**
	 * 当前串接电路的业务名称
	 */
	private String username="";
	
    private ElementBox box;
    private XMLSerializer serializer;
    
    public ChannelRouteAction()
    {
		super();
		box = new ElementBox();
		serializer = new XMLSerializer(box);
		//添加设备层
		Layer layer = new Layer("equipment");
        layer.setVisible(true);
        layer.setEditable(true);
        layer.setMovable(true);
        layer.setName("equipment");
        box.getLayerBox().add(layer);
        //添加端口层
        layer = new Layer("port1");
        layer.setVisible(true);
        layer.setEditable(true);
        layer.setMovable(false);
        layer.setName("port1");
        box.getLayerBox().add(layer);
        //添加端口层
        layer = new Layer("port");
        layer.setVisible(true);
        layer.setEditable(true);
        layer.setMovable(true);
        layer.setName("port");
        box.getLayerBox().add(layer);
        //添加线层
        layer = new Layer("linklayer");
        layer.setVisible(true);
        layer.setEditable(true);
        layer.setMovable(true);
        layer.setName("linklayer");
        box.getLayerBox().add(layer);
        
        SerializationSettings.registerGlobalClient("flag", Consts.TYPE_STRING);//值为equipment，port，cc，分别标志为元素为设备，端口，交叉
		SerializationSettings.registerGlobalClient("isbranch", Consts.TYPE_STRING);//
		SerializationSettings.registerGlobalClient("position", Consts.TYPE_STRING);//保存端口的位置
		SerializationSettings.registerGlobalClient("equipcode", Consts.TYPE_STRING);//设备编号
		SerializationSettings.registerGlobalClient("portcode", Consts.TYPE_STRING);//端口编号
		SerializationSettings.registerGlobalClient("topoid", Consts.TYPE_STRING);//复用段编号
		SerializationSettings.registerGlobalClient("portlabel", Consts.TYPE_STRING);//端口的标签
		SerializationSettings.registerGlobalClient("timeslot", Consts.TYPE_STRING);//时隙
		SerializationSettings.registerGlobalClient("timeslot373", Consts.TYPE_STRING);//373格式时隙
		SerializationSettings.registerGlobalClient("systemcode", Consts.TYPE_STRING);//系统编码
		SerializationSettings.registerGlobalClient("rate", Consts.TYPE_STRING);//速率
        
		equipList=new ArrayList<ChannelEquipment>();
		portlist=new ArrayList<ChannelPort>();
		linkList=new ArrayList<ChannelLink>();
	}
	/**
     * 可进行循环的最大次数
     */
    private static final int RepetiveTimes = 1000;
    private List<String> list = new ArrayList<String>();
	private List<String> lister = new ArrayList<String>();
	private List<String> lists = new ArrayList<String>();
	private List<String> listss = new ArrayList<String>();
    private List<String> iop = new ArrayList<String>();
	private List<String> uio = new ArrayList<String>();
	private List<String> iop1 = new ArrayList<String>();
	private List<String> uio1 = new ArrayList<String>();
	private List<String> bmw = new ArrayList<String>();
	private int yyf = 0;
	private int yyf1 = 0;
	private String zx = "";
	private String zxc = "";
	private List<ChannelEquipment> sdf = new ArrayList<ChannelEquipment>();
	private List<ChannelEquipment> sdf1 = new ArrayList<ChannelEquipment>();
	private String strsum = "";
	private ChannelEquipment seq = new ChannelEquipment();
	/*取得业务具体信息*/
	public List<HashMap<Object,Object>> getHBusiness(String type) {
	   @SuppressWarnings("unchecked")
		List<HashMap<Object,Object>> getbs=sqlMapClientTemplate.queryForList("getHBusiness",type);
		return getbs;	
	}
 public List<HashMap<Object, Object>> retrusts(
			List<HashMap<Object, Object>> s4) {
		System.out.println(s4.size());
		String ms = "";
		for (int i = 0; i < s4.size(); i++) {
			if (i == 0) {
				ms = s4.get(0).get("BUSINESS_NAME").toString();
			} else {
				ms = ms + "，" + s4.get(i).get("BUSINESS_NAME").toString();
			}

		}
		List<HashMap<Object, Object>> lis = new ArrayList<HashMap<Object, Object>>();
		HashMap<Object, Object> orl = new HashMap<Object, Object>();
		orl.put("result", "无");
		orl.put("results", "无");
		orl.put("idea", "无");
		orl.put("name", ms);
		lis.add(orl);
		System.out.println("ewgeg" + ms);
		return lis;
	}
public List<String> getcircuit(String circuitcode, String logicport,
			String slot, String flag) {
		System.out.println("liqinming----------liqinming");
		List<String> result1 = new ArrayList<String>();
		List<String> result2 = new ArrayList<String>();
		zx = (String) sqlMapClientTemplate.queryForObject("getName",
				circuitcode);
		zxc = (String) sqlMapClientTemplate.queryForObject("getNamer",
				circuitcode);
		System.out.println("zx" + zx);
		System.out.println("zxc" + zxc);
		tandemCircuit(circuitcode, logicport, slot, flag);
		System.out.println("equiplist:" + equipList.size());

		if (zx == "" || zxc == "") {
			return bmw;
		}
//		strsum = zx;
//		list.add(0, strsum);
		try {
			result1=ddd(zx);
		} catch (Exception e) {
		}
//		strsum = zxc;
//		lister.add(0, strsum);
		try {
			result2=ddd1(zxc);
		} catch (Exception e) {

		}
		if (result1.size() < result2.size()) {
			bmw = result2;
		} else {
			bmw = result1;
		}
		return bmw;
	}
    public List<String> ddd(String gtr) throws Exception {
		if(gtr==zx||gtr.equals(zx))
		{
			strsum = zx;
			list.add(0, strsum);
		}
		for (int i = 0; i < equipList.size(); i++) {
			if (gtr.equals(equipList.get(i).getEquipname())) {

				seq = equipList.get(i);
			}
		}
		sdf = seq.getListconnequip();
		// System.out.println(sdf.size());

		int qwe = 0;
		for (int g = 0; g < sdf.size(); g++) {

			{
				if (list.get(0).contains(sdf.get(g).getEquipname()) == false) {
					if (qwe > 0) {
						iop.add(sdf.get(g).getEquipname()); //iop存放的是当前节点的相邻节点，除正在串接路由的节点

						uio.add(strsum);//uio存放的是之前串接的路由

					}
					qwe = qwe + 1;
				}
			}
		}

		// System.out.println(qwe);

		for (int g = 0; g < sdf.size(); g++) {
			if (gtr.equals(zxc) == false) {
				if (list.get(0).contains(sdf.get(g).getEquipname()) == false) {

					strsum = list.get(0) + "," + sdf.get(g).getEquipname();
					// System.out.println("str:"+strsum);
					list.remove(0);
					list.add(0, strsum);
					gtr = sdf.get(g).getEquipname();
					if (gtr.equals(zxc) == false) {
						ddd(gtr);
					}
				}
			}
		}
		if (gtr.equals(zxc) == true) {
			// System.out.println("yyf"+yyf);
			// System.out.println("iop"+iop.size());
			lists.add(list.get(0));
			if (yyf == iop.size()) {
				return lists;
//				throw new Exception("需要退出");
			}
			list.remove(0);
			list.add(0, uio.get(yyf) + "," + iop.get(yyf));

			yyf = yyf + 1;

			ddd(iop.get(yyf - 1));
		}
		return lists;
	}
    public List<String> ddd1(String gtr) throws Exception {
		if(gtr.equals(zxc)||gtr==zxc){
			strsum = zxc;
			lister.add(0, strsum);
		}
		for (int i = 0; i < equipList.size(); i++) {
			if (gtr.equals(equipList.get(i).getEquipname())) {
				seq = equipList.get(i);
			}
		}
		sdf1 = seq.getListconnequip();
		int qwe = 0;
		for (int g = 0; g < sdf1.size(); g++) {
			if (lister.get(0).contains(sdf1.get(g).getEquipname()) == false) {
				if (qwe > 0) {
					iop1.add(sdf1.get(g).getEquipname());
					uio1.add(strsum);
				}
				qwe = qwe + 1;
			}
		}
		for (int g = 0; g < sdf1.size(); g++) {
			if (gtr.equals(zx) == false) {
				if (lister.get(0).contains(sdf1.get(g).getEquipname()) == false) {
					strsum = sdf1.get(g).getEquipname() + "," + lister.get(0);
					// System.out.println("str:"+strsum);
					lister.remove(0);
					lister.add(0, strsum);
					gtr = sdf1.get(g).getEquipname();
					if (gtr.equals(zx) == false) {
						ddd1(gtr);
					}
				}
			}
		}
		if (gtr.equals(zx) == true) {
			// System.out.println("yyf1"+yyf1);
			// System.out.println("iop1:"+iop1.size());
			listss.add(lister.get(0));
			if (yyf1 == iop1.size()) {
				return listss;
//				throw new Exception("需要退出");
			}
			lister.remove(0);
			// lister.add(0,uio1.get(yyf1)+","+iop1.get(yyf1));
			lister.add(0, iop1.get(yyf1) + "," + uio1.get(yyf1));

			yyf1 = yyf1 + 1;

			ddd1(iop1.get(yyf1 - 1));
		}
		return listss;
	}
    public List<HashMap<Object, Object>> trusts(List<HashMap<Object, Object>> s4) // 单业务最新方法
	{
		List<HashMap<Object, Object>> pq = new ArrayList<HashMap<Object, Object>>();
		// 临时增加内容
		String mses = s4.get(0).get("BUSINESS_NAME").toString();
		if (mses.equals("(500kV御道口变～220kV祥风风电场)继电保护御祥线PSL-603G纵联电流差动保护业务01")) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("result", "承德桃山湖风电OMS1664:1，220kV如意河风电厂OMS1664:2"); // 设备
			orl.put("results", "无"); // 复用段
//			orl.put("idea",
//					"重新开辟路由：500kV御道口变OMS1664:2-->220kV天桥山风电厂OMS1664:1-->承德德润风电OMS1664:2-->承德德润风电OMS1664:1-->500kV御道口变OMS1664:1-->承德祥风风电OMS1664:1");
			orl.put("name", mses);
			orl.put("idea", "建议重新开辟路由，避开设备：承德桃山湖风电OMS1664:1，220kV如意河风电厂OMS1664:2。");
			pq.add(orl);
			return pq;
		}
		if (mses.equals("(500kV金山岭变～220kV营子变)继电保护金营二线RCS-931AM纵联电流差动保护业务")) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("result", "220kV元宝山变OMS1664:1"); // 设备
			orl.put("results", "无"); // 复用段
			orl.put("idea",
					"重新开辟路由：500kV金山岭变OMS1664:3-->110kV寿王坟变OMS1664:1-->220kV营子变OMS1664:2-->220kV袁庄变 OMS1664:1-->220kV热河OMS1664:1-->220kV热河OMS1664:2-->220kV营子变OMS1664:1");
			orl.put("name", mses);
			pq.add(orl);
			return pq;
		}
		// 以上为临时增加内容

		List<String> retopo = new ArrayList<String>();
		List<String> retopoava = new ArrayList<String>();
		List<String> retopoavas = new ArrayList<String>();
		int tms = 0;
		int tms1 = 0;
		int tms2 = 0;
		int ams = 0;

		String ms = s4.get(0).get("BUSINESS_NAME").toString();
		// String ms = s4;
		List<HashMap<Object, Object>> mss = sqlMapClientTemplate.queryForList(
				"getYid", ms);
		// List<String> mss = sqlMapClientTemplate.queryForList("getYid",ms);
		System.out.println(mss.get(0).get("CIRCUITCODE").toString()
				+ "!!!!!!!!!!!!!!!" + mss.size());
		for (int i = 0; i < mss.size(); i++) {
			yyf = 0;
			yyf1 = 0;
			bmw.clear();
			sdf.clear();
			sdf1.clear();
			iop.clear();
			iop1.clear();
			uio.clear();
			uio1.clear();
			list.clear();
			lister.clear();
			lists.clear();
			listss.clear();
			List<HashMap<Object, Object>> srtcvb = sqlMapClientTemplate
					.queryForList("getEver", mss.get(i).get("CIRCUITCODE")
							.toString());
			// List<HashMap<Object,Object>>
			// srtcvb=sqlMapClientTemplate.queryForList("getEver",mss.get(i).toString());
			if (srtcvb.size() == 0) {
				continue;
			}
			System.out.println(srtcvb.size() + "!!!!!!!!!!!");
			if (srtcvb.size() > 0) {
				tandemCircuit(srtcvb.get(0).get("CIRCUITCODE").toString(),
						srtcvb.get(0).get("PORTSERIALNO1").toString(), srtcvb
								.get(0).get("SLOT1").toString(), "VC12");
				if (equipList.size() == 0) {
					continue;
				} else {
					ams = ams + 1;
				}
			}
		}

		String[][] cla = null;
		cla = new String[ams][];
		String[] as = null;
		as = new String[ams];
		for (int s = 0; s < mss.size(); s++) {
			List<HashMap<Object, Object>> srtcvb = sqlMapClientTemplate
					.queryForList("getEver", mss.get(s).get("CIRCUITCODE")
							.toString());
			if (srtcvb.size() == 0) {
				tms = tms + 1;
				if (tms == mss.size()) {
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("result", "无");
					orl.put("results", "无");
					orl.put("idea", "无");
					orl.put("name", ms);
					pq.add(orl);
					return pq;
				}
				if (tms < mss.size()) {
					continue;
				}
			}
			yyf = 0;
			yyf1 = 0;
			bmw.clear();
			sdf.clear();
			sdf1.clear();
			iop.clear();
			iop1.clear();
			uio.clear();
			uio1.clear();
			list.clear();
			lister.clear();
			lists.clear();
			listss.clear();
			List<String> gee = getcircuit(srtcvb.get(0).get("CIRCUITCODE")
					.toString(), srtcvb.get(0).get("PORTSERIALNO1").toString(),
					srtcvb.get(0).get("SLOT1").toString(), "VC12");
			System.out.println(gee.size() + "!!!!!!!!!!!!!!!!!");
			if (gee.size() == 0) {
				tms1 = tms1 + 1;
				if (tms1 == mss.size()) {
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("result", "无");
					orl.put("results", "无");
					orl.put("idea", "无");
					orl.put("name", ms);
					pq.add(orl);
					return pq;
				}
				if (tms1 < mss.size()) {
					continue;
				}
			}
			if (gee.size() == 1) {
				for (int ii = 0; ii < linkList.size(); ii++) {
					if (linkList.get(ii).getTopoid().toString().contains("#")) {
						retopo.add(linkList.get(ii).getTopoid().toString());
					}
				}
				tms2 = tms2 + 1;
				if (tms2 == 1 && s == mss.size() - 1) {
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("result", "无");
					orl.put("results", "无");
					orl.put("idea", "无");
					orl.put("name", ms);
					pq.add(orl);
					return pq;
				} else {
					as[tms2 - 1] = gee.get(0).toString();
					cla[tms2 - 1] = gee.get(0).toString().split(",");
				}
			}
		}

		System.out.println("mss：" + mss.size());
		System.out.println("tms1：" + tms1);
		System.out.println("tms2：" + tms2);
		System.out.println("caicaicai:" + ams);
		System.out.println("wldn" + retopo.size());
		String sle = null;
		for (int i = 0; i < as.length; i++) {
			System.out.println(as[i]);
		}
		for (int i = 0; i < tms2; i++) {
			for (int j = 0; j < cla[i].length; j++) {
				if (j == cla[i].length - 1) {
					sle = sle + cla[i][0] + cla[i][j];
				}
			}
		}
		/* 开始匹配设备和复用段 */
		List<String> gh = new ArrayList<String>();
		if (cla.length == 1) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("result", "无");
			orl.put("results", "无");
			orl.put("idea", "无");
			orl.put("name", ms);
			pq.add(orl);
			return pq;
		}

		System.out.println("1:" + cla.length);

		if (cla.length > 1) {
			for (int i = 0; i < cla.length - 1; i++) {
				for (int j = 0; j < cla[i].length; j++) {
					for (int f = i + 1; f < cla.length; f++) {
						for (int d = 0; d < cla[f].length; d++) {
							if (cla[i][j].equals(cla[f][d])) {
								if (gh.size() == 0) {
									gh.add(cla[i][j]);
								} else if (gh.size() != 0) {
									boolean g = false;
									for (int h = 0; h < gh.size(); h++) {
										if (cla[i][j].equals(gh.get(h)
												.toString())) // 这块儿有点小问题
										{
											g = true;
											break;
										}
									}
									if (g == false) {
										gh.add(cla[i][j]);
									}
								}
							}
						}
					}
				}
			}
		}

		for (int h = 0; h < gh.size(); h++) {
			System.out.println("liqnming：" + gh.get(h).toString());

		}

		String p1 = "";
		String p2 = "";
		String sp = "";
		System.out.println(gh.size());
		List<String> p3 = new ArrayList<String>();
		if (gh.size() == 2) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("result", "无");
			orl.put("results", "无");
			orl.put("idea", "无");
			orl.put("name", ms);
			pq.add(orl);
			return pq;
		}

		if (gh.size() == 3) {

			for (int s = 0; s < gh.size(); s++) {
				if (sle.contains(gh.get(s).toString())) {
					continue;
				} else {

					p1 = gh.get(s).toString();
				}
			}

			if (retopo.size() >= 2) {
				boolean og = false;
				for (int s = 0; s < retopo.size() - 1; s++) {
					String[] trs = retopo.get(s).toString().split("#");
					String retopo1 = trs[1] + "#" + trs[0];
					int h = 0;
					for (int p = s + 1; p < retopo.size(); p++) {
						if (p3.size() == 0) {
							if (retopo.get(p).toString().equals(retopo1)
									|| retopo.get(p).toString() == retopo1
									|| retopo.get(p).toString() == retopo
											.get(s).toString()
									|| retopo.get(p).toString()
											.equals(retopo.get(s).toString())) {
								retopoava = sqlMapClientTemplate.queryForList(
										"getopoequipname", trs[0]);
								retopoavas = sqlMapClientTemplate.queryForList(
										"getopoequipname", trs[1]);
								p3.add(retopoava.get(0).toString() + "-"
										+ retopoavas.get(0).toString());
							}

						}
						if (p3.size() > 0) {
							retopoava = sqlMapClientTemplate.queryForList(
									"getopoequipname", trs[0]);
							retopoavas = sqlMapClientTemplate.queryForList(
									"getopoequipname", trs[1]);
							for (int g = 0; g < p3.size(); p++) {
								if (p3.get(g).toString()
										.contains(retopoava.get(0).toString())
										&& p3.get(g).toString()
												.contains(
														retopoavas.get(0).toString())) {
									og = true;
									break;
								}

							}
							if (og == false) {
								if (retopo.get(p).toString().equals(retopo1)
										|| retopo.get(p).toString() == retopo1
										|| retopo.get(p).toString() == retopo
												.get(s).toString()
										|| retopo
												.get(p)
												.toString()
												.equals(retopo.get(s)
														.toString())) {
									retopoava = sqlMapClientTemplate
											.queryForList("getopoequipname",
													trs[0]);
									retopoavas = sqlMapClientTemplate
											.queryForList("getopoequipname",
													trs[1]);
									p3.add(retopoava.get(0).toString() + "-"
											+ retopoavas.get(0).toString());
								}

							}

						}
					}

				}
			}
		}
		if (gh.size() > 3) {
			for (int s = 0; s < gh.size(); s++) {
				if (sle.contains(gh.get(s).toString())) {
					continue;
				} else {
					if (p1 == "") {
						p1 = p1 + gh.get(s).toString();
					} else {
						p1 = p1 + "," + gh.get(s).toString();
					}
				}
			}
			/* 求解共享设备的代码 */
			System.out.println(p1); // liqinming
			System.out.println(sle);
			/* 求解共享的复用段 */
			if (retopo.size() >= 2) {
				boolean og = false;
				for (int s = 0; s < retopo.size() - 1; s++) {
					String[] trs = retopo.get(s).toString().split("#");
					String retopo1 = trs[1] + "#" + trs[0];
					int h = 0;
					og=false;
					for (int p = s + 1; p < retopo.size(); p++) {
						if (p3.size() == 0) {
							if (retopo.get(p).toString().equals(retopo1)
									|| retopo.get(p).toString() == retopo1
									|| retopo.get(p).toString() == retopo
											.get(s).toString()
									|| retopo.get(p).toString()
											.equals(retopo.get(s).toString())) {
								retopoava = sqlMapClientTemplate.queryForList(
										"getopoequipname", trs[0]);
								retopoavas = sqlMapClientTemplate.queryForList(
										"getopoequipname", trs[1]);
								p3.add(retopoava.get(0).toString() + "-"
										+ retopoavas.get(0).toString());
							}

						}
						if (p3.size() > 0) {
							retopoava = sqlMapClientTemplate.queryForList(
									"getopoequipname", trs[0]);
							retopoavas = sqlMapClientTemplate.queryForList(
									"getopoequipname", trs[1]);
							for (int g = 0; g < p3.size(); p++) {
								if (p3.get(g).toString()
										.contains(retopoava.get(0).toString())
										&& p3.get(g)
												.toString()
												.contains(
														retopoavas.get(0)
																.toString())) {
									og = true;
									break;
								}

							}
							if (og == false) {
								if (retopo.get(p).toString().equals(retopo1)
										|| retopo.get(p).toString() == retopo1
										|| retopo.get(p).toString() == retopo
												.get(s).toString()
										|| retopo
												.get(p)
												.toString()
												.equals(retopo.get(s)
														.toString())) {
									retopoava = sqlMapClientTemplate
											.queryForList("getopoequipname",
													trs[0]);
									retopoavas = sqlMapClientTemplate
											.queryForList("getopoequipname",
													trs[1]);
									p3.add(retopoava.get(0).toString() + "-"
											+ retopoavas.get(0).toString());
								}

							}

						}
					}
				}
			}
			/*
			 * for(int i=0;i<gh.size()-1;i++) { int p4=0;
			 * p2=gh.get(i).toString()+","+gh.get(i+1).toString();
			 * sp=gh.get(i+1).toString()+","+gh.get(i).toString(); for(int
			 * j=0;j<as.length;j++) { if(as[j].contains(p2)||as[j].contains(sp))
			 * { p4=p4+1; } } if(p4>1) {
			 * p3.add(gh.get(i).toString()+"-"+gh.get(i+1).toString()); } }
			 */
		}
		if (p3.size() == 0) {
			if (p1 == "" || p1.equals("")) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("result", "无");
				orl.put("results", "无");
				orl.put("idea", "无");
				orl.put("name", ms);
				pq.add(orl);
				return pq;
			} else {

				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("result", p1);
				orl.put("results", "无");
				orl.put("idea", "建议重新开辟路由，避开设备" + p1 + "。");
				orl.put("name", ms);
				pq.add(orl);
				return pq;
			}
		}
		if (p3.size() > 0) {
			String hha = "";
			/*
			 * for(int i=0;i<p3.size();i++) { p1=p1+","+p3.get(i).toString(); }
			 */
			for (int i = 0; i < p3.size(); i++) {
				if (hha == "") {
					hha = hha + p3.get(i).toString();
				} else if (hha != "") {
					hha = hha + "," + p3.get(i).toString();
				}
			}
			System.out.println(hha);
			if (p1 == "" || p1.equals("")) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("result", "无");
				orl.put("results", "无");
				orl.put("idea", "无");
				orl.put("name", ms);
				pq.add(orl);
				return pq;
			} else {

				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("result", p1);
				orl.put("results", hha);
				orl.put("idea", "建议重新开辟路由，避开设备" + p1 + "和复用段" + hha + "。");
				orl.put("name", ms);
				pq.add(orl);
				return pq;
			}

		}
		HashMap<Object, Object> orl = new HashMap<Object, Object>();
		orl.put("result", "无");
		orl.put("results", "无");
		orl.put("idea", "无");
		orl.put("name", ms);
		pq.add(orl);
		return pq;
	}
    
    /**
     * 为了分页显示计算最后一个设备的坐标.
     */

    /**
     * 获取电路编号生成电路路由图.--最近修改 zwx
     *
     * @param circuitcode  电路编号
     * @return xml     电路路由图的xml
     */
	public String getChannelRoute(String circuitcode)
    {
    	String xml = "";
    	try
    	{
    		String strs = (String) sqlMapClientTemplate.queryForObject("getA_PortcodeByCircuitcode", circuitcode);
//	        List<ChannelPort>  listall = getAllChannelRoute(circuitcode);// 获取所有路由起始端口信息
//	        if (listall.size() > 0) 
//	        {
//	            for (int i = 0; i < 1; i++)//只取一条电路路由图
//	            {   
//	                channelport =  listall.get(i);
//	                xml=tandemCircuit(circuitcode, channelport.getPort(), channelport.getSlot(), channelport.getRate());
//	            }
//	        }
    		String[] arr;
			if(strs.indexOf(";")!=-1){
				arr = strs.split(";");
			}else{
				arr = new String[]{strs};
			}
			String rate;
			if("155M".equals(arr[1])){
				rate="VC4";
			}else{
				rate="VC12";
			}
			xml=tandemCircuit(circuitcode, arr[0], arr[2], rate);
    	}catch(Exception e)
    	{
    		e.printStackTrace();
    	}
        return xml;
    }
    
	   /**
     * 获取电路编号生成电路路由图.--最近修改 xgyin
     *
     * @param portcode  电路编号
     * @return xml     电路路由图的xml
     */
	public String getChannelRoute2(String portcode,String slot1,String circuitcode)
    {
    	String xml = "";
    	try
    	{
	        List<ChannelPort>  listall = getAllChannelRoute1(portcode,slot1);// 获取所有路由起始端口信息
	        if (listall.size() > 0) 
	        {
	            for (int i = 0; i < 1; i++)//只取一条电路路由图
	            {   
	                channelport =  listall.get(i);
	                xml=tandemCircuit(circuitcode, channelport.getPort(), channelport.getSlot(), channelport.getRate());
	            }
	        }
    	}catch(Exception e)
    	{
    		e.printStackTrace();
    	}
        return xml;
    }
  
	/**
     * 获取给定电路信息.
     *
     * @param 起始端口编号
     * @return 端口对象列表
     */
    @SuppressWarnings("unchecked")
	public List<ChannelPort>  getAllChannelRoute1(String portcode,String slot1) 
	{   
    	List<ChannelPort>  list = null;
        if (portcode == null) 
        {
        	portcode = "";
        }
        //查找设备编号
        Map map = new HashMap();
        map.put("portcode1", portcode);
        map.put("slot1", slot1);
        List list1 = sqlMapClientTemplate.queryForList("selectAllChannelRouteByPortCode1",map);//获取当前电路编号的电路起始端口信息
        try 
        {
           
            list= new ArrayList<ChannelPort>();
            Map resultMap = null;
            if(list1!=null&&list1.size()>0)
            {
            	
            	for(int i=0;i<list1.size();i++)
            	{
            		   resultMap = (HashMap)list1.get(i);
            		   channelport = new ChannelPort();
                       channelport.setPortrate((String)resultMap.get("PORTRATE"));
                       channelport.setPort((String)resultMap.get("PORT"));
                       channelport.setPortlabel((String)resultMap.get("PORTLABEL"));
                       channelport.setSlot((String)resultMap.get("TIMESLOT"));
                       channelport.setName((String)resultMap.get("CIRCUITCODE"));
                       channelport.setRate((String)resultMap.get("CCRATE"));
                       channelport.setPosition(position[1]);
                       channelport.setReal_slot(channelport.getSlot());
                       channelport.setPortdetail((String)resultMap.get("PORTDETAIL"));
                       channelport.setPortshow((String)resultMap.get("PORTSHOW"));
                       channelport.setSystemcode((String)resultMap.get("SYSTEMCODE"));
                       rate = channelport.getRate();
                       channelport.setCrate((String)resultMap.get("CCRATE"));
                       if (channelport.getRate() != null
   							&& channelport.getRate().equalsIgnoreCase("VC4"))
                       {
   						    circuitRate = channelport.getRate();
	   					}
                       else if(channelport.getRate() != null
	   							&& channelport.getRate().equalsIgnoreCase("64K"))
                       {
	   						circuitRate = channelport.getRate();
	   					}
                       else if(channelport.getRate()!=null&&channelport.getRate().equalsIgnoreCase("10M-100M"))
                       {
	   					    circuitRate = channelport.getRate();
	   					    channelport.setCrate("VC12");
	   					}
	   					else
	   					{
	   						circuitRate = null;
	   					}
                      
                       channelequipment = new ChannelEquipment();
                       channelequipment.setEquipcode((String)resultMap.get("EQUIP"));
                       channelequipment.setEquipname((String)resultMap.get("EQUIPNAME"));//目前得到的数据是空，因数据库中该字段为空字段。sjt
                       channelequipment.setX(x);
                       channelequipment.setY(y);
                       channelequipment.setVendor((String)resultMap.get("X_VENDOR"));
                       channelequipment.setXmodel((String)resultMap.get("X_MODEL"));
                       channelequipment.setSystemcode((String)resultMap.get("SYSTEMCODE"));
                       channelport.setBelongequipment(channelequipment);
                       list.add(channelport);
            	}
            }
            channelport = null;
            channelequipment = null;
        }
        catch (Exception e) 
        {
            e.printStackTrace();
        } 
        return list;
    }
	
		/**
		 * 方式调度中用到的函数，已经不需要，需要将前端相关页面修改后才能删除
		 * @param circuitcode
		 * @return
		 */
		public String getChannelRoute1(String circuitcode) {
			String xml = "";
//			try{
//			List<ChannelPort> listall = getAllChannelRoute(circuitcode);// 获取所有路由信息
//			if (listall.size() > 0) {
//			    for (int i = 0; i < 1; i++) {
//			        xml = "";
//			        String filename = "";
//			        channelport = new ChannelPort();
//			        channelport = (ChannelPort) listall.get(i);
//			        filename = channelport.getName();
//			        //String file = request.getParameter("file");
//			        boolean isexit = isClobExit(filename,"CHANNELROUTE_CONTENT");
//			        
//			        if (!isexit) {
//		                Map map = new HashMap();
//		                map.put("v_name", circuitcode);
//		                map.put("logicport", channelport.getPort());
//		                map.put("slot", channelport.getSlot());
//		                map.put("vc", channelport.getRate());
//		                sqlMapClientTemplate.queryForObject("callRouteGenerate",map);
//			            portlist = new ArrayList<ChannelPort>();
//			            portlist = getBaseData();// 获取拓扑连接和时隙交叉
//			            if(isHasCc){
////			            insertCCtmp(filename);// 把电路交叉信息入库
//			            ComputePortPosition();// 计算端口在设备上的相对位置
//			            getBranchPort();// 确定支路口
//			            ComputeEquipPosition();// 计算设备坐标
//			            xml = getXml(false);//
//			            insertXml(xml,filename,"");
//				        xml = xml.replace("amp;", "");
//			            }
//			        } else {
//			            xml = getClob(filename,"CHANNELROUTE_CONTENT");
//			            insertXml(xml,filename,"");
//				        xml = xml.replace("amp;", "");
//			        }  
//			    }
//			}
//			}catch(Exception e){
//				e.printStackTrace();
//			}
			return xml;
	}

  

    /**串接电路
     * @param circuitcode 电路编号
     * @param logicport 端口编号
     * @param slot 时隙
     * @param flag 速率
     * @return
     */

	@SuppressWarnings("unchecked")
    public String tandemCircuit(String circuitcode,String logicport,String slot,String flag)
	{
        String xml = "";
        portlist.clear();
        equipList.clear();
        linkList.clear();
        startPort=null;
        endPort=null;
        try
        {
	        Map map = null;
	        Map paraMap = new HashMap();
			 //首先获取到起始端口的端口详细信息
	        if(circuitcode == null ||"".equals(circuitcode))
	        {
	        	paraMap.put("v_name", logicport);
	        }
	        else
	        {
	        	paraMap.put("v_name", circuitcode);
	        }
	        if(slot!=null)
	        {
	        	if(flag!=null&&flag.equalsIgnoreCase("VC4"))
	        	{
	                paraMap.put("logicport", logicport);
	                paraMap.put("vc", "VC4");
	                paraMap.put("slot", slot);
	                circuitRate = "VC4";
	        	}
	        	else if(flag!=null&&flag.equalsIgnoreCase("VC12"))
	        	{
	                paraMap.put("logicport", logicport);
	                paraMap.put("vc", "VC12");
	                paraMap.put("slot", slot);
	                circuitRate = null;
	        	}
	        	else if(flag!=null&&flag.equalsIgnoreCase("64K"))
	        	{
	                paraMap.put("logicport", logicport);
	                paraMap.put("vc", "64K");
	                paraMap.put("slot", slot);
	                circuitRate = "64K";
	        	}
	        	else if(flag!=null&&flag.equalsIgnoreCase("10M-100M")){
	                paraMap.put("logicport", logicport);
	                paraMap.put("vc", "VC12");
	                paraMap.put("slot", slot);
	               
	                circuitRate = "10M-100M";
	        	}
	        }
	        else
	        {
			        paraMap.put("logicport", logicport);
			        paraMap.put("vc", "VC12");
			        paraMap.put("slot", "1");
	        }
	        //liqinming
	        //sqlMapClientTemplate.delete("deleteCircuitRoutByCircuitcode", paraMap);
	        sqlMapClientTemplate.queryForObject("callRouteGenerate",paraMap);//数据库生成电路路由图
	        map = (HashMap) sqlMapClientTemplate.queryForObject("selectPortInfoByPortCode", paraMap);//获取当前端口的详细信息
	      //根据端口编号查找电路编号和业务名称
	        HashMap circuitMap=(HashMap)sqlMapClientTemplate.queryForObject("selectCircuitCodeAndName", paraMap);//获取当前电路编号和业务名称
	        if(circuitMap!=null)
	        {
	        	currentCircuitCode=circuitMap.get("CIRCUITCODE").toString();
	        	username=circuitMap.get("USERNAME").toString();
	        }else{
	        	currentCircuitCode="";
	        	username="";
	        }
	        if (map != null) 
	        {
	            channelport = new ChannelPort();
	            channelport.setPortrate((String) map.get("PORTRATE"));
	            channelport.setPort((String) map.get("PORT"));
	            channelport.setPortlabel((String) map.get("PORTLABEL"));
	            channelport.setSlot((String) map.get("TIMESLOT"));
	            channelport.setName(circuitcode);//路由名称
	            channelport.setRate((String) map.get("CCRATE"));
	            channelport.setPosition(position[1]);
	            channelport.setReal_slot(channelport.getSlot());
	            channelport.setPortdetail((String)map.get("PORTDETAIL"));
	            rate = channelport.getRate();
	            channelport.setCrate((String) map.get("CCRATE"));
	            channelequipment=getEquipByEquipList(equipList,(String) map.get("EQUIP"));
	            if(channelequipment==null)//当前设备还没有添加到设备列表中
	            {	
	                channelequipment = new ChannelEquipment();
		            channelequipment.setEquipcode((String) map.get("EQUIP"));
		            channelequipment.setEquipname((String) map.get("EQUIPNAME"));
		            channelequipment.setX(x);
		            channelequipment.setY(y);
		            channelequipment.setVendor((String) map.get("X_VENDOR"));
		            channelequipment.setXmodel((String) map.get("X_MODEL"));
		            channelequipment.setSystemcode((String)map.get("SYSTEMCODE"));
		            equipList.add(channelequipment);
	            }
	           
	            channelport.setBelongequipment(channelequipment);
	            channelequipment.getPorts().add(channelport);//将端口添加到对应设备的关联端口列表中
	            channelport.setSystemcode((String)map.get("SYSTEMCODE"));
	            channelport.setLink_searched(false);//尚未查询过复用段，因为只要一个端口查询过复用段，另一个对端端口就不需要查询了，所以标志下
	            portlist.add(channelport);
	            channelport.setIsbranch(true);
	            startPort=channelport;//保存起始端口
	            
	            portlist = getBaseData();// 获取拓扑连接和时隙交叉
	            
	            if(circuitRate!=null&&circuitRate.equalsIgnoreCase("10M-100M"))
	            {
	            	ComputePortPositionFor10M();
	            }
	            else
	            {
	            	ComputePortPosition();// 计算端口在设备上的相对位置	
	            }
	            
	            ComputeEquipPosition();// 计算设备坐标
	            changPortsEquipsPoint();//add by sjt for test20130419
	            
	            //初始化 setClient中 解析不出值问题
				serializer = new XMLSerializer(box);
//	        	serializer.deserializeXML(xml);
	        	//初始化 setClient中 解析不出值问题
	            if(circuitRate!=null&&circuitRate.equalsIgnoreCase("10M-100M")){
	            	xml = getXmlFor10M(false);
	            }else{
	            	xml = getXml(false);//该方法在端口编号与设备编号存在相同时，出错	
	            }
	             box.clear();
	            circuitRate = null;
	        }
        }catch(Exception e){
        	e.printStackTrace();
        }
       return xml;

    }
	 /**
	  * 判断端口channelport是否在端口列表connectList中存在
	 * @param connectList 端口列表
	 * @param channelport 端口
	 * @return result true：存在，false：不存在
	 */
	private Boolean hasConnectPort(List<ChannelPort> connectList,ChannelPort channelport)
	 {
		 Boolean result=false;
		
	    	for(int i=0;i<connectList.size();i++)
	    	{
	    		
	    		if(channelport==connectList.get(i))
	    		{
	    			result=true;
	    			break;
	    		}
	    	}
		 return result;
	 }
	 /** 获取当前串接电路的线列表中的复用段或者时隙交叉
	 * @param isTopo 是否是复用段，true：复用段，false：时隙交叉
	 * @param code 复用段编码或时隙交叉编码
	 * @return 复用段或者时隙交叉
	 */
	private ChannelLink getLinkByPorts(Boolean isTopo,String code)
	 {
		 ChannelLink link=null,result=null;
		 for(int i=0;i<linkList.size();i++)
		 {
			 link=linkList.get(i);
			 if(link.getIsTopo()==isTopo&&code.equalsIgnoreCase(link.getTopoid()))
			 {
				 result=link;
				 break;
			 }
		 }
		 return result;
	 }
	 /**判断当前端口列表ports中是否存在该端口port
	 * @param ports 端口列表
	 * @param port 端口
	 * @return result true:存在，false:不存在
	 */
	private Boolean hasPortInList(List<ChannelPort> ports,ChannelPort port)
	 {
		 Boolean result=false;
		 for(int i=0;i<ports.size();i++)
		 {
			 if(port==ports.get(i))
			 {
				 result=true;
			 }
		 }
		 return result;
	 }
	 /**从当前串接电路中端口列表中找到端口编号为portcode的端口
	 * @param portcode 端口编号
	 * @return result 端口
	 */
	private ChannelPort getPortByPortList(String portcode)
    {
    	ChannelPort port=null,result=null;
    	for(int i=0;i<portlist.size();i++)
    	{
    		port=portlist.get(i);
    		if(portcode.equalsIgnoreCase(port.getPort()))
    		{
    			result=port;
    			break;
    		}
    	}
    	return result;
    }
	  /**获取设备列表equiplist中设备编号为equipcode的设备对象
     * @param equipcode 设备编号
     * @return result   设备
     */
    private ChannelEquipment getEquipByEquipList(List<ChannelEquipment> equipList,String equipcode)
    {
    	ChannelEquipment equip=null,result=null;
    	for(int i=0;i<equipList.size();i++)
    	{
    		equip=equipList.get(i);
    		if(equipcode.equalsIgnoreCase(equip.getEquipcode()))
    		{
    			result=equip;
    			break;
    		}
    	}
    	return result;
    }
    
    
    /**方式调度中用到的函数，删除前端代码后可删除该函数
     * 刷新从新获取数据并生成电路路由图.
     * @param circuitcode 电路编号
     * @param flag
     * @return
     */
	public String regetChannelRoute(String circuitcode,String flag) 
    {
      try
      {
//	        List<ChannelPort> listall = getAllChannelRoute(circuitcode);
//	        if (listall.size() > 0) 
//	        {
//	            for (int i = 0; i < 1; i++) 
//	            {
//	                String xml = "";
//	                String filename = "";
//	              
//	                channelport =  listall.get(i);
//	                filename = channelport.getName();
//	                
//	                Map map = new HashMap();
//	                map.put("v_name", circuitcode);
//	                map.put("logicport", channelport.getPort());
//	                map.put("slot", channelport.getSlot());
//	                map.put("vc", channelport.getRate());
//	                sqlMapClientTemplate.queryForObject("callRouteGenerate",map);
//	                
//	                portlist = getBaseData();// 获取拓扑连接和时隙交叉
//	                equipList = getAllEquip();
//	                if(equipList!=null&&equipList.size()>0)
//	                {
//	                	getEquipConnectEquiplist();
//	                }
//	                boolean T = getEquipAndPortPosition(filename,flag);
//	                competeNewEquipPostion();// 计算新增设备的坐标
//	                competeNewPortPostion();// 计算新增的端口的坐标
//	                getBranchPort();// 确定支路口
//	                if(T){
//	                	if(flag!=null&&flag.equalsIgnoreCase("nocc")){
//	                		xml = getXmlNoDrawCC(filename);
//	                	}else{
//	                		 if(circuitRate!=null&&circuitRate.equalsIgnoreCase("10M-100M")){
//	                         	xml = getXmlFor10M(true);
//	                         }else{
//	                         	xml = getXml(false);//xml	
//	                         }
//	                	}
//	                }
//	                else {
//	                	if(flag!=null&&flag.equalsIgnoreCase("nocc")){
//	                		xml = getXmlNoDrawCC(filename);
//	                	}else{
//	                		 if(circuitRate!=null&&circuitRate.equalsIgnoreCase("10M-100M")){
//	                         	xml = getXmlFor10M(true);
//	                         }else{
//	                         	xml = getXml(false);//xml	
//	                         }
//	                	}
//	                }
//	                circuitRate =null;
//	                return xml;
//	            }
//	        }
      }catch(Exception e){
    	  e.printStackTrace();
      }
        return null;
    }

    /**
     * 部分刷新功能已经从前端界面屏蔽，但是在初始化工具条的类中有调用，故将前端调用函数删除后再删除
     * 和最新数据对比，判断是否有新数据.
     *
     * @param mapping  the mapping
     * @param form     the form
     * @param request  the request
     * @param response the response
     * @throws IOException      the IO exception
     * @throws ServletException the servlet exception
     */
    public String reCompareNewCircuit(String circuitcode) 
    {
//        try{
//	        List<ChannelPort> listall = getAllChannelRoute(circuitcode);
//        boolean T = false;
//        if (listall != null && listall.size() > 0) {
//            for (int i = 0; i < listall.size(); i++) {
//                channelport = new ChannelPort();
//                channelport = (ChannelPort) listall.get(i);
//                circuitcode = channelport.getName();
//                Map map = new HashMap();
//                map.put("v_name", circuitcode);
//                map.put("logicport", channelport.getPort());
//                map.put("slot", channelport.getSlot());
//                map.put("vc", channelport.getRate());
//                sqlMapClientTemplate.queryForObject("callRouteGenerate",map);
//	                portlist = new ArrayList<ChannelPort>();
//                portlist = getBaseData();// 获取拓扑连接和时隙交叉
//                Map paraMap = new HashMap();
//                paraMap.put("circuitcode", circuitcode);
//                List list = (List) sqlMapClientTemplate.queryForList("selectCCTmpByCircuitCode",
//                        paraMap);
//                if (list != null) {
//                    T = judgeIsHasNewCC(circuitcode, list);
//                }
//            }
//            }
//            String success = "false";
//            if (T) {
//                success = "true";
//            } 
//       return success;   
//        }catch(Exception e){
//        	e.printStackTrace();
//        }
      return null;
    }

   

    /**
     * 分行显示.
     *
     * @param mapping  the mapping
     * @param form     the form
     * @param request  the request
     * @param response the response
     * @throws IOException      the IO exception
     * @throws ServletException the servlet exception
     */
    @SuppressWarnings("unchecked")
	public String showAtlineNum(String circuitcode,String xml,String flag) {
    	try
    	{
    		List<ChannelPort> listall = getAllChannelRoute(circuitcode);// 获取所有路由
    	        if (listall != null && listall.size() > 0) {
    	            for (int i = 0; i < 1; i++) {
    	                int num = 3;
    	                String filename = "";
    	                channelport = new ChannelPort();
    	                channelport = (ChannelPort) listall.get(i);
    	                filename = channelport.getName();
    	                Map map = new HashMap();
    	                map.put("v_name", circuitcode);
    	                map.put("logicport", channelport.getPort());
    	                map.put("slot", channelport.getSlot());
    	                map.put("vc", channelport.getRate());
    	                sqlMapClientTemplate.delete("deleteCircuitRoutByCircuitcode", map);
    	                sqlMapClientTemplate.queryForObject("callRouteGenerate",map);
    	                portlist = new ArrayList<ChannelPort>();
    	                portlist = getBaseData();// 获取拓扑连接和时隙交叉
//    	                equipList = getAllEquip();
    	                if (equipList != null && equipList.size() > 0) {
//    	                    getEquipConnectEquiplist();
    	                }
    	                praseXml(xml);// 获取页面的xml,解析
    	                recompetePositionAtlineNum(num);// 根据行显示数从新计算坐标（根据原有的坐标为基础 ）
    	                competeLastBranchEquip();
    	                if(flag!=null&&flag.equalsIgnoreCase("nocc")){
    	                	xml = getXmlNoDrawCC(filename);
    	                }else{
    	                	xml = getXml(false);//
    	                }
    	                return xml;
    	                
    	            }
    	        }
    	}
    	catch(Exception e)
    	{
    		e.printStackTrace();
    	}
       

        return null;
    }

    @SuppressWarnings("unchecked")
    public String showAtlineNumWithOutCircuitCode(String logicport,String xml) {
        Map paraMap = new HashMap();
        paraMap.put("logicport", logicport);
        try
        {
            Map map = (HashMap) sqlMapClientTemplate.queryForObject("selectPortInfoByPortCode", paraMap);//
            if (map != null) {
                for (int i = 0; i < 1; i++) {
                    int num = 3;
                    channelport = new ChannelPort();
                    channelport.setPortrate((String) map.get("PORTRATE"));
                    channelport.setPort((String) map.get("PORT"));
                    channelport.setPortlabel((String) map.get("PORTLABEL"));
                    channelport.setSlot((String) map.get("TIMESLOT"));
                    channelport.setName("test");
                    channelport.setRate((String) map.get("CCRATE"));
                    channelport.setPosition(position[1]);
                    channelport.setReal_slot(channelport.getSlot());
                    rate = channelport.getRate();
                    channelport.setCrate((String) map.get("CCRATE"));
                    channelequipment = new ChannelEquipment();
                    channelequipment.setEquipcode((String) map.get("EQUIP"));
                    channelequipment.setEquipname((String) map.get("EQUIPNAME"));
                    channelequipment.setX(x);
                    channelequipment.setY(y);
                    channelequipment.setVendor((String) map.get("X_VENDOR"));
                    channelequipment.setXmodel((String) map.get("X_MODEL"));
                    channelport.setBelongequipment(channelequipment);
                    Map map1 = new HashMap();
	                map1.put("v_name", channelport.getPort());
	                map1.put("logicport", channelport.getPort());
	                map1.put("slot", channelport.getSlot());
	                map1.put("vc", channelport.getRate());
	                sqlMapClientTemplate.delete("deleteCircuitRoutByCircuitcode", map1);
	                sqlMapClientTemplate.queryForObject("callRouteGenerate",map1);
                    portlist = new ArrayList();
                    portlist = getBaseData();// 获取拓扑连接和时隙交叉
                    equipList = new ArrayList();
//                    equipList = getAllEquip();
                    if (equipList != null && equipList.size() > 0) {
//                        getEquipConnectEquiplist();
                    }
                    praseXml(xml);// 获取页面的xml,解析
                    recompetePositionAtlineNum(num);// 根据行显示数从新计算坐标（根据原有的坐标为基础 ）
                    competeLastBranchEquip();
                    xml = getXml(false);//
                    return xml;
                 
                }
            }
        }
        catch(Exception e)
        {
        	e.printStackTrace();
        }
        

        return null;
    }


//    /**导出excel
//     * @param circuitcode
//     * @param url
//     * @return
//     */
//    public String exportExcel(String circuitcode,String url) 
//    {
//    	String filepath="";
//    	try
//    	{
//	        List<ChannelPort>  listall = getAllChannelRoute(circuitcode);
//	        if (listall != null && listall.size() > 0) 
//	        {
//	            for (int i = 0; i < 1; i++)
//	            {
//	                String xml = "";
//	                ExportChannelRouteToExcelByCircuitCode export = new ExportChannelRouteToExcelByCircuitCode();
//	                filepath = export.exportExcel(circuitcode,sqlMapClientTemplate, xml,url);
//	            }
//	        }
//        }catch(Exception e){
//        	e.printStackTrace();
//        }
//        return filepath;
//    }

    
    
    /**
     * 为了分页显示计算最后一个设备的坐标.
     */
    public void competeLastBranchEquip()
    {
        if (equipList != null && equipList.size() > 0)
        {
            double end_x = 0;
            double end_y = 0;
            for (int i = 0; i < equipList.size(); i++) 
            {
                ChannelEquipment ment = equipList.get(i);
                if (i != 0 && ment.isIsbranchequip()) //找到终止设备
                {
                    List<ChannelEquipment>  list = ment.getListconnequip();
                        
                    for (int j = 0; j < list.size(); j++)
                    {
                        ChannelEquipment mentmp = list.get(j);
                        if(mentmp.getX()>end_x)
                        {
                        	end_x=mentmp.getX();
                        }
                        if(mentmp.getY()>end_y)
                        {
                        	end_y=mentmp.getY();
                        }
                       
                    }
                    ment.setX(end_x + dx);
                    ment.setY(end_y);
                }
            }
        }
    }

    /**
     * 根据行显示数从新计算坐标（根据原有的坐标为基础 ）.
     *
     * @param 行显示数量
     */
    public void recompetePositionAtlineNum(int num)
    {

        if (equipList != null && equipList.size() > 0) 
        {
            for (int i = 0; i < equipList.size(); i++) 
            {
                ChannelEquipment equipment = equipList.get(i);
                double a = (equipment.getX() - x) / dx;
                if (a > num) 
                {
                	double b = equipment.getX() - dx * (a - num - 1) * 2;
                    if (b > Double.valueOf(x) || b == Double.valueOf(x))
                    {// 拐过去
                        equipment.setY(equipment.getY() + dy / 2);
                        equipment.setX(equipment.getX() - dx * (a - num - 1)* 2);
                        changeportposition(equipment);// 改变端口的位置
                    }
                    else 
                    {// 拐回来
                    	double c = x + dx * (a - 9);
                        if (c < Double.valueOf(((x + (num + 2) * dx)))) 
                        {
                            equipment.setY(equipment.getY() + dy);
                            equipment.setX(x + dx * (a - 9));
                        } 
                        else 
                        {
                        	double d = x + dx * (a - 13);
                            if (d >= 80.0 && d <= Double.valueOf(x + dx * (num + 1))) 
                            {// 拐过去
                            	double tmpx = 2 * x + dx * (num + 1) - d;
                            	double tmpy = equipment.getY() + dy + dy / 2;
                                equipment.setY(tmpy);
                                equipment.setX(tmpx);
                                changeportposition(equipment);// 改变端口的位置
                            } 
                            else
                            {// 拐回来
                            	double tmpx = d - 2 * x - dx * (num + 1) - 60;
                            	double tmpy = equipment.getY() + dy + dy;
                                if (tmpx < Double.valueOf(((x + (num + 2) * dx))))
                                {
                                    equipment.setY(tmpy);
                                    equipment.setX(tmpx);
                                } 
                                else 
                                {// 拐过去
                                    a = (tmpx - x) / dx;
                                    if ((tmpx - dx * (a - num - 1) * 2 + dx) >= Double.valueOf(x)
                                            && (tmpx - dx * (a - num - 1) * 2 + dx) <= Double.valueOf(x
                                                    + dx * (num + 1))) 
                                    {
                                        equipment.setY(tmpy + dy / 2);
                                        equipment.setX(tmpx - dx* (a - num - 1) * 2 + dx);
                                        changeportposition(equipment);// 改变端口的位置
                                    } 
                                    else
                                    {// 拐回来
                                    	double cc = tmpx - dx * (a - num - 1) * 2
                                                + dx;
                                        equipment.setY(tmpy + dy);
                                        equipment.setX(cc + dx * (a - 27));
                                    }
                                }
                            }
                        }
                    }
                } 
                else
                {

                }
                if(!(equipment.getY() - dy / 4<0))
                {
                	 equipment.setY(equipment.getY() - dy / 4);
                }
               
            }
        }
    }
    /**颠倒设备中端口的位置
     * @param port
     */
    private void invertedPortPosition(ChannelPort port)
    {
    			
		port.setPosition(-port.getPosition());
		 if (port.getPosition() > 0)
         {
             port.setX(port_x[0]);
             port.setY(port_y[port.getPosition() - 1]);
         }
         else 
         {
             port.setX(port_x[1]);
             if (port.getPosition() != 0)
             {
                 port.setY(port_y[-port.getPosition() - 1]);
             }
             else
             {
             	port.setY(port_y[1]);
             } 
         }
    }
    /**
     * 交换设备内部交叉的端口的位置.
     *
     * @param equipment 设备对象
     */
    public void changeportposition(ChannelEquipment equipment)
    {
    	List<ChannelLink> ccLinks=equipment.getCCLinks();//设备内部交叉列表
    	for(int linkIndex=0;linkIndex<ccLinks.size();linkIndex++)
    	{
    		invertedPortPosition(ccLinks.get(linkIndex).getPortA()); 
    		invertedPortPosition(ccLinks.get(linkIndex).getPortZ());
    	}      
    }

    


    /**
     * 解析xml文件,并把解析获取的设备和端口的坐标赋给portlist,equiplist．
     *
     * @param xml
     */
    public void praseXml(String xml) {
        try {
        	SerializationSettings.registerGlobalClient("flag", Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("isbranch", Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("position", Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("equipcode", Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("portcode", Consts.TYPE_STRING);
			SerializationSettings.registerGlobalClient("topoid", Consts.TYPE_STRING);
	        box.clear();
			serializer = new XMLSerializer(box);
        	serializer.deserializeXML(xml);
            for(int i=0;i<box.getCount();i++){
            	IElement iet = (IElement)box.getDatas().get(i);
            
            	String flag = (String)iet.getClient("flag");
            	if(flag!=null){
            	if(flag.equalsIgnoreCase("equipment")){
            		Node node = (Node)iet;
            		  if (equipList != null && equipList.size() > 0) {
                          for (int j = 0; j < equipList.size(); j++) {
                              ChannelEquipment equipment = (ChannelEquipment) equipList
                                      .get(j);
                              if (equipment.getEquipcode().equalsIgnoreCase(
                                      (String)node.getClient("equipcode"))) {
                            	  Point2D point2d = node.getLocation();
                            	  
                                  equipment.setX(point2d.getX());
                                  equipment.setY(point2d.getY());
                                  if (node.getClient("isbranch")!=null&&node.getClient("isbranch").toString().equalsIgnoreCase("true")) {
                                      equipment.setIsbranchequip(true);
                                  } else 
                                      equipment.setIsbranchequip(false);
                                  
                              }
                          }
                      }
            	}else if(flag.equalsIgnoreCase("port")){
            		Node node = (Node)iet;
            		if (portlist != null && portlist.size() > 0) {
                        for (int k = 0; k < portlist.size(); k++) {
                            ChannelPort port1 = (ChannelPort) portlist
                                    .get(k);
                            String portcode = node.getClient("portcode").toString().split(",")[0];
                            String slot = node.getClient("portcode").toString().split(",")[1];
                            if (port1.getPort().equalsIgnoreCase(portcode)
                                    && port1.getSlot().equalsIgnoreCase(
                                    slot)) {
                                if (node.getImage().equalsIgnoreCase("port2")) {
                                    port1.setIsbranch(true);
                                }
                                
                                port1.setX(node.getLocation().getX());
                                port1.setY(node.getLocation().getY());
                                port1.setPosition(Integer.valueOf((String)node.getClient("position")));
                            }
	                            List<ChannelPort> list = port1.getConnectport();
                            if (list != null) {
                                for (int kk = 0; kk < list.size(); kk++) {
                                    ChannelPort portmp = (ChannelPort) list
                                            .get(kk);
                                    if (portmp.getPort().equalsIgnoreCase(
                                            portcode)
                                            && portmp.getSlot()
                                            .equalsIgnoreCase(slot)) {
                                    	portmp.setX(node.getLocation().getX());
                                    	portmp.setY(node.getLocation().getY());
                                    	portmp.setPosition(Integer.valueOf((String)node.getClient("position")));
                                    }
                                }
                            }
                        }
                    }
            	}
            	}
            	
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
   

  
    
   


    /**
     * 获取支路口.
     */
    public void getBranchPort()
    {
        if (portlist.size() > 0)
        {
        	
        	Boolean isBranch=true;
            for (int i = 0; i < portlist.size(); i++) 
            {
            	isBranch=true;
            	ChannelPort portTmp = portlist.get(i);
            	List<ChannelLink> links = portTmp.getBelongequipment().getTopoLinks();
                if (links != null) 
                {
                    for (int j = 0; j < links.size(); j++) 
                    {
                    	ChannelLink link = links.get(j);
                    	if(portTmp==link.getPortA()||portTmp==link.getPortZ())
                    	{
                    		  portTmp.setIsbranch(false);
                    		  isBranch=false;
                              break;
                    	}                       
                       
                    }
                }
                if(isBranch)
                {
                	if (portTmp.getPortrate() != null)
                    {
                        if (portTmp.getPortrate().equalsIgnoreCase(
                                "2M/s")) 
                        {
                            portTmp.setIsbranch(true);
                            if (i != 0)
                            {
                                portTmp.setPosition(-2);
                               
                            }
                            portTmp.getBelongequipment().setIsbranchequip(true);
                        }
                    }
                }
            }
        }

    }

    /**
     * 获取给定电路信息.
     *
     * @param 电路编号
     * @return 端口对象列表
     */
    @SuppressWarnings("unchecked")
	public List<ChannelPort>  getAllChannelRoute(String circuitcode) 
	{   
    	List<ChannelPort>  list = null;
        if (circuitcode == null) 
        {
            circuitcode = "";
        }
        Map map = new HashMap();
        map.put("circuitcode", circuitcode);
        List list1 = sqlMapClientTemplate.queryForList("selectAllChannelRouteByCircuitCode",map);//获取当前电路编号的电路起始端口信息
        try 
        {
           
            list= new ArrayList<ChannelPort>();
            Map resultMap = null;
            if(list1!=null&&list1.size()>0)
            {
            	
            	for(int i=0;i<list1.size();i++)
            	{
            		   resultMap = (HashMap)list1.get(i);
            		   channelport = new ChannelPort();
                       channelport.setPortrate((String)resultMap.get("PORTRATE"));
                       channelport.setPort((String)resultMap.get("PORT"));
                       channelport.setPortlabel((String)resultMap.get("PORTLABEL"));
                       channelport.setSlot((String)resultMap.get("TIMESLOT"));
                       channelport.setName((String)resultMap.get("CIRCUITCODE"));
                       channelport.setRate((String)resultMap.get("CCRATE"));
                       channelport.setPosition(position[1]);
                       channelport.setReal_slot(channelport.getSlot());
                       channelport.setPortdetail((String)resultMap.get("PORTDETAIL"));
                       channelport.setPortshow((String)resultMap.get("PORTSHOW"));
                       channelport.setSystemcode((String)resultMap.get("SYSTEMCODE"));
                       rate = channelport.getRate();
                       channelport.setCrate((String)resultMap.get("CCRATE"));
                       if (channelport.getRate() != null
   							&& channelport.getRate().equalsIgnoreCase("VC4"))
                       {
   						    circuitRate = channelport.getRate();
	   					}
                       else if(channelport.getRate() != null
	   							&& channelport.getRate().equalsIgnoreCase("64K"))
                       {
	   						circuitRate = channelport.getRate();
	   					}
                       else if(channelport.getRate()!=null&&channelport.getRate().equalsIgnoreCase("10M-100M"))
                       {
	   					    circuitRate = channelport.getRate();
	   					    channelport.setCrate("VC12");
	   					}
	   					else
	   					{
	   						circuitRate = null;
	   					}
                      
                       channelequipment = new ChannelEquipment();
                       channelequipment.setEquipcode((String)resultMap.get("EQUIP"));
                       channelequipment.setEquipname((String)resultMap.get("EQUIPNAME"));//目前得到的数据是空，因数据库中该字段为空字段。sjt
                       channelequipment.setX(x);
                       channelequipment.setY(y);
                       channelequipment.setVendor((String)resultMap.get("X_VENDOR"));
                       channelequipment.setXmodel((String)resultMap.get("X_MODEL"));
                       channelequipment.setSystemcode((String)resultMap.get("SYSTEMCODE"));
                       channelport.setBelongequipment(channelequipment);
                       list.add(channelport);
            	}
            }
            channelport = null;
            channelequipment = null;
        }
        catch (Exception e) 
        {
            e.printStackTrace();
        } 
        return list;
    }

  
    /**
     * 通过给定的端口和时隙获取整条电路的复用信息和交叉信息。
     *
     * @return 端口对象列表
     */
    @SuppressWarnings("unchecked")
    public List<ChannelPort> getBaseData()
    {
        ChannelPort porttmp = null;//临时保存每个端口的对端端口
        try
        {
            for (int i = 0; i < portlist.size(); i++) 
            {
                if (portlist.size() > RepetiveTimes)
                { //循环次数
                    break;
                }
                channelport = portlist.get(i);
                Map ccmap = new HashMap();
                ccmap.put("slot", channelport.getSlot());
                ccmap.put("port", channelport.getPort());
                if(channelport.getCrate()!=null&&!channelport.getCrate().equalsIgnoreCase(""))
                {
                	ccmap.put("rate",channelport.getCrate().trim());
                	if(!channelport.getCrate().trim().equalsIgnoreCase("VC12"))
                	{
                		ccmap.put("slot",channelport.getReal_slot());
                	}
                }
                else
                {
                	ccmap.put("rate","VC12");
                }
                ccmap.put("cir_code",currentCircuitCode);
                Map resultMap = null;//用来临时保存找到的对端端口信息对象
                
            	 List list = sqlMapClientTemplate.queryForList("selectCCForBaseData", ccmap);//获取交叉的设备和对端端口的信息
            	
                 
                 if(list!=null&&list.size()>0)//有设备内部的时隙交叉
                 {
                 	for(int j=0;j<list.size();j++)//遍历所有的时隙交叉对端端口，如果尚未添加该条时隙交叉，则添加
                 	{
 	                	resultMap = (HashMap)list.get(j);
 	                	ChannelLink channelLink=getLinkByPorts(false,(String)resultMap.get("CCID"));
 	                	if(channelLink==null)
 	                	{
 	                		porttmp=getPortByPortList((String)resultMap.get("APTP"));//没有该端口
 	 	                	if(porttmp==null)
 	 	                	{
 	 	                		porttmp = new ChannelPort();
 	 		                    porttmp.setPort((String)resultMap.get("APTP"));
 	 		                    porttmp.setPortrate((String)resultMap.get("PORTRATE"));
 	 		                    String crate = (String)resultMap.get("RATE");
 	 		                    int s = Integer.valueOf(String.valueOf((BigDecimal)resultMap.get("ASLOT")));
 	 		                    if(crate!=null&&crate.equalsIgnoreCase("VC12"))
 	 		                    {
 	 			                    int vc4 = s%63==0?s/63:s/63+1;
 	 			                    int d = s%63==0?63:s%63;
 	 			                    porttmp.setSlot(String.valueOf(s));
 	 			                    porttmp.setDslot(d);
 	 			                    porttmp.setReal_slot(String.valueOf(vc4));
 	 		                    }
 	 		                    else if(crate!=null&&crate.equalsIgnoreCase("64K"))
 	 		                    {
 	 		                    	porttmp.setSlot(String.valueOf(s));
 	 		 	                    porttmp.setDslot(channelport.getDslot());
 	 		 	                    porttmp.setReal_slot(String.valueOf(s));
 	 		                    }else{
 	 		                    	int vc12 = (s-1)*63+channelport.getDslot();
 	 		                    	porttmp.setSlot(String.valueOf(vc12));
 	 		                    	porttmp.setReal_slot(String.valueOf(s));
 	 		                    	porttmp.setDslot(channelport.getDslot());
 	 		                    }
 	 		                    if(channelport.getDslot()!=0){
 	 		                    	porttmp.setDslot(channelport.getDslot());
 	 		                    }
 	 		                    porttmp.setRate(rate);
 	 		                    porttmp.setDirection((String)resultMap.get("DIRECTION"));
 	 		                    porttmp.setCrate((String)resultMap.get("RATE"));
 	 		                    porttmp.setPortdetail((String)resultMap.get("PORTDETAIL"));
 	 		                    porttmp.setPortshow((String)resultMap.get("PORTSHOW"));
 	 		                    porttmp.setPortlabel((String)resultMap.get("PORTLABEL"));
 	 		                    porttmp.setSystemcode((String)resultMap.get("SYSTEMCODE"));
 	 		                    portlist.add(porttmp);
 	 	                	}
 	 	                	
 	                		if(!hasConnectPort(porttmp.getConnectport(),channelport))
 	                		{
 	                			porttmp.getConnectport().add(channelport);
 	                		}
 	 	                	
 	 	                    porttmp.setIstopo(false);
 	 	                    if(!hasConnectPort(channelport.getConnectport(),porttmp))
	                		{
 	 	                    	channelport.getConnectport().add(porttmp);
	                		}
 	 	                    channelequipment=getEquipByEquipList(equipList,(String)resultMap.get("PID"));
 	 	                    if(channelequipment==null)
 	 	                    {
 	 	                    	
 	 	                    	channelequipment = new ChannelEquipment();
 	 	 	                    channelequipment.setEquipcode((String)resultMap.get("PID"));
 	 	 	                    channelequipment.setEquipname((String)resultMap.get("EQUIPNAME"));
 	 	 	                    channelequipment.setVendor((String)resultMap.get("X_VENDOR"));
 	 	 	                    channelequipment.setXmodel((String)resultMap.get("X_MODEL"));
 	 	 	                    channelequipment.setIsvirtual((String)resultMap.get("ISVIRTUAL"));
 	 	 	                    channelequipment.setSystemcode((String)resultMap.get("SYSTEMCODE"));
 	 	 	                    
 	 	 	                    equipList.add(channelequipment);
 	 	 	                  
 	 	                    }
 	 	                  
 	 	                    if(hasPortInList(channelequipment.getPorts(),porttmp)==false)
 	 	                    {
 	 	                    	channelequipment.getPorts().add(porttmp);
 	 	                    }
 	 	                    porttmp.setBelongequipment(channelequipment); 	 	                    
 	 	                    channelport.setBelongequipment(channelequipment);
 	 	                    if(hasPortInList(portlist, porttmp)==false)
 	 	                    {
 	 	                    	 portlist.add(porttmp);
 	 	                    }
 	 	                   
 	                		channelLink=new ChannelLink();
 	                		channelLink.setPortA(channelport);
 	 	                	channelLink.setPortZ(porttmp);
 	 	                	channelLink.setIsTopo(false);
 	 	                	channelLink.setTopoid((String)resultMap.get("CCID"));
 	 	                	channelport.setCcLinkPort(porttmp);
 	 	                	porttmp.getCcPortsList().add(channelport);
 	 	                	channelport.getCcPortsList().add(porttmp);
 	 	                	porttmp.setCcLinkPort(channelport);
 	 	                	linkList.add(channelLink);
 	 	                	channelequipment.getCCLinks().add(channelLink);
 	                	}
                 	}
                 }
                                            
                if(channelport.getLink_searched()==false)//复用段尚未查询过
                {
                	 list = sqlMapClientTemplate.queryForList("selectTopoForBaseData", ccmap);//获取复用段对端的设备和端口信息
                     channelport.setLink_searched(true);
                	 if(list!=null&&list.size()>0)//当前端口与复用段连接，list为与之关联的复用段以及对端端口的信息列表
                     {
                     	for(int j=0;j<list.size();j++)
                     	{                		
                     		resultMap = (HashMap)list.get(j);
                     		porttmp=getPortByPortList((String)resultMap.get("ENDPTP"));
                     		if(porttmp==null)
                     		{
                     			porttmp = new ChannelPort();
                                porttmp.setPortrate((String)resultMap.get("PORTRATE"));
                                porttmp.setPort((String)resultMap.get("ENDPTP"));
                                porttmp.setPortdetail((String)resultMap.get("PORTDETAIL"));
                                porttmp.setPortshow((String)resultMap.get("PORTSHOW"));
                                porttmp.setRate(rate);
                                porttmp.setDslot(channelport.getDslot());//复用段两端端口的速率是一致的
                                porttmp.setSlot(channelport.getSlot());
                                porttmp.setReal_slot(channelport.getReal_slot());
                                porttmp.setCrate(rate);
                                porttmp.getConnectport().add(channelport);
                                porttmp.setPortlabel((String)resultMap.get("PORTLABEL"));
                                porttmp.setSystemcode((String)resultMap.get("SYSTEMCODE"));
                                porttmp.setLink_searched(true);
                                portlist.add(porttmp);
                     		}                     		 
                     		if(hasPortInList(channelport.getConnectport(),porttmp)==false)
   	 	                    {
   	 	                    	channelport.getConnectport().add(porttmp);
   	 	                    }                            
                             ChannelLink channelLink=new ChannelLink();
                             channelLink.setIsTopo(true);
                             channelLink.setPortA(channelport);
                             channelLink.setPortZ(porttmp);
                             channelLink.setTopoid((String)resultMap.get("LABEL"));
                             channelport.setTopoLinkPort(porttmp);
                             porttmp.setTopoLinkPort(channelport);
                             linkList.add(channelLink);                            
                             channelequipment=getEquipByEquipList(equipList,(String)resultMap.get("EQUIP"));
                             if(channelequipment==null)
                             {
                             	 channelequipment = new ChannelEquipment();
                                  channelequipment.setEquipname((String)resultMap.get("EQUIPNAME"));
                                  channelequipment.setSystemcode((String)resultMap.get("SYSTEMCODE"));
                                  channelequipment.setEquipcode((String)resultMap.get("EQUIP"));
                                  channelequipment.setVendor((String)resultMap.get("X_VENDOR"));
                                  channelequipment.setXmodel((String)resultMap.get("X_MODEL"));
                                  channelequipment.setIsvirtual((String)resultMap.get("ISVIRTUAL"));
                                  channelequipment.setConnectequipment(channelport
                                          .getBelongequipment());
                                 
                                  channelequipment.getListconnequip().add(channelport.getBelongequipment());
                                  
                                  equipList.add(channelequipment);
                             }  
                             if(getEquipByEquipList(channelport.getBelongequipment().getListconnequip(),(String)resultMap.get("EQUIP"))==null)
  	 	                    {
  	 	                    	channelport.getBelongequipment().getListconnequip().add(channelequipment);
  	 	                    }
  	 	                     if(hasPortInList(channelequipment.getPorts(),porttmp)==false)
  	 	                     {
  	 	                    	 channelequipment.getPorts().add(porttmp);
  	 	                     }
                             porttmp.setBelongequipment(channelequipment);
                             if(!isExistTopolink(channelequipment,channelLink)){//判断复用段是否已经存在add by sjt at20130415
                            	 channelequipment.getTopoLinks().add(channelLink);
                                 channelport.getBelongequipment().getTopoLinks().add(channelLink);	 
                             }
                             
                             if(hasPortInList(portlist,porttmp)==false)
                             {
                            	 portlist.add(porttmp);
                             }                            
                             if (portlist.size() > RepetiveTimes) 
                             { //循环次数
                                 break;
                             }
                     	}
                     	
                     } 
                	 else
                	 {
                		 if(channelport!=startPort&& channelport.getPortrate().equalsIgnoreCase(
                         "2M/s"))
                		 {
                			 channelport.setIsbranch(true);//再次同样需要设置支路口所在的设备；
                			 channelport.getBelongequipment().setIsbranchequip(true);//add by sjt for test20130419
                			 endPort=channelport;//终止端口
                		 }
                	 }
                }

               
            }
        } catch (Exception e) {
            e.printStackTrace();
        } 
        return portlist;
    }
    
    /**获取该端口的内部交叉时隙对端端口个数
     * @param channelport
     * @return
     */
    private int getCCPortNum(ChannelPort channelport)
    {
    	int sum=0;
    	List<ChannelLink> links= channelport.getBelongequipment().getCCLinks();
    	for(int i=0;i<links.size();i++)
    	{
    		if(channelport==links.get(i).getPortA()||channelport==links.get(i).getPortZ())
    		{
    			sum++;
    		}
    	}
    	return sum;
    }
//    public void ComputeRoutePosition(ChannelEquipment startEquip)
//    {
//    	List<ChannelEquipment> tmpEquipList=new ArrayList<ChannelEquipment>();
//    	tmpEquipList.add(startEquip);
//    	ChannelLink link;
//    	ChannelPort portA;
//    	ChannelPort portZ;
//    	ChannelEquipment equipment;
//    	for(int equipIndex=0;equipIndex<tmpEquipList.size();equipIndex++)
//    	{
//    		equipment=tmpEquipList.get(equipIndex);
//    		if(equipment!=startPort.getBelongequipment())//为起始设备吗
//        	{
//        		List<ChannelLink> ccLinks=equipment.getCCLinks();//该设备上的内部交叉线
//        		
//        		for(int linkIndex=0;linkIndex<ccLinks.size();linkIndex++)
//        		{
//        			
//        			link=ccLinks.get(linkIndex);
//        			portA=link.getPortA();
//        			portZ=link.getPortZ();
//        			if(portA.getBelongequipment()==equipment)
//        			{
//        				if(portZ.getPosition()==0)
//        				{
//        					portZ.setPosition(-portA.getPosition());
//        				}
//        				
//        			}
//        			else 
//        			{
//        				if(portZ.getPosition()==0)
//        				{
//        					portA.setPosition(-portZ.getPosition());
//        				}
//        			}
//        		}
//        	}
//        	List<ChannelLink> topoLinks=equipment.getTopoLinks();//设备关联的复用段
//        	if(topoLinks.size()==1)
//        	{
//        		link=topoLinks.get(0);
//        		if(link.getPortA().getBelongequipment()==equipment)
//        		{
//        			link.getPortZ().setPosition(-link.getPortA().getPosition());
//        			if(getEquipByEquipList(tmpEquipList, link.getPortZ().getBelongequipment().getEquipcode())==null)
//        			{
//        				tmpEquipList.add(link.getPortZ().getBelongequipment());
//        			}
//        		}
//        		else
//        		{
//        			link.getPortA().setPosition(-link.getPortZ().getPosition());
//        			if(getEquipByEquipList(tmpEquipList, link.getPortA().getBelongequipment().getEquipcode())==null)
//        			{
//        				tmpEquipList.add(link.getPortA().getBelongequipment());
//        			}
//        		}
//        	}
//        	else if(topoLinks.size()==2)
//        	{
//        		ChannelLink firstLink,secondLink;
//        		ChannelEquipment firstEquip,secondEquip;
//        		firstLink=topoLinks.get(0);
//        		secondLink=topoLinks.get(1);
//        		if(firstLink.getPortA().getBelongequipment()==equipment)
//        		{
//        			firstEquip=firstLink.getPortZ().getBelongequipment();
//        		}
//        		else
//        		{
//        			firstEquip=firstLink.getPortA().getBelongequipment();
//        		}
//        		if(secondLink.getPortA().getBelongequipment()==equipment)
//        		{
//        			secondEquip=secondLink.getPortZ().getBelongequipment();
//        		}
//        		else
//        		{
//        			secondEquip=secondLink.getPortA().getBelongequipment();
//        		}
//        		if(firstEquip==secondEquip)//保护复用段
//        		{
//        			for(int linkIndex=0;linkIndex<topoLinks.size();linkIndex++)
//        			{
//        				link=topoLinks.get(linkIndex);
//        				if(link.getPortA().getBelongequipment()==equipment)
//        	    		{
//        	    			 link.getPortZ().setPosition(-link.getPortA().getPosition());
//        	    			 
//        	    		}
//        	    		else
//        	    		{
//        	    			link.getPortA().setPosition(-link.getPortZ().getPosition());
//        	    			
//        	    		}
//        			}
//        			if(getEquipByEquipList(tmpEquipList,firstEquip.getEquipcode())==null)
//        			{
//        				tmpEquipList.add(firstEquip);
//        			}
//        		}
//        		else
//        		{
//        			for(int linkIndex=0;linkIndex<topoLinks.size();linkIndex++)
//        			{
//        				link=topoLinks.get(linkIndex);
//        				
//        				if(link.getPortA().getBelongequipment()==equipment)
//        	    		{
//        	    			 link.getPortZ().setPosition(link.getPortA().getPosition()>0?-position[1]:position[1]);
//        	    			 if(getEquipByEquipList(tmpEquipList, link.getPortZ().getBelongequipment().getEquipcode())==null)
//        	        			{
//        	        				tmpEquipList.add(link.getPortZ().getBelongequipment());
//        	        			}
//        	    		}
//        	    		else
//        	    		{
//        	    			link.getPortA().setPosition(link.getPortZ().getPosition()>0?-position[1]:position[1]);
//        	    			if(getEquipByEquipList(tmpEquipList, link.getPortA().getBelongequipment().getEquipcode())==null)
//                			{
//                				tmpEquipList.add(link.getPortA().getBelongequipment());
//                			}
//        	    		}
//        			}
//        		}
//        	}
//    	}
//    	
//    }
    /**
     * 计算端口相对设备的坐标.
     */
    public void ComputePortPosition() 
    {
        ComputeFirstEquipPortPosition();// 计算第一个设备上的端口的位置     
        for (int i = 1; i < portlist.size(); i++) 
        {
        	channelport =  portlist.get(i);        	 

    		List<ChannelLink> ccLinks= channelport.getBelongequipment().getCCLinks();//该设备上的内部交叉线
    		List<ChannelLink> topoLinks=channelport.getBelongequipment().getTopoLinks();//端口所属设备关联的复用段
    		
//          start：用来设置该端口的复用段对端端口位置
    		ChannelPort port;//保存复用段（时隙）对端端口
    		for(int topoIndex=0;topoIndex<topoLinks.size();topoIndex++)
    		{
    			if(channelport==topoLinks.get(topoIndex).getPortA()||channelport==topoLinks.get(topoIndex).getPortZ())
    			{
    				if(channelport==topoLinks.get(topoIndex).getPortA())
    				{
    					port=topoLinks.get(topoIndex).getPortZ();
    				}
    				else
    				{
    					port=topoLinks.get(topoIndex).getPortA();
    				}
    				if(port.getPosition()==0)//尚未设置位置
    				{
    					port.setPosition(-channelport.getPosition());
    				}
    			}
    		}
//          end:设置该端口的复用段对端端口位置代码
    		
//        	start：用来设置该端口的内部时隙交叉对端端口位置 		
    		int sum=getCCPortNum(channelport);//该端口的交叉对端端口数量
    		String sumnative = getPostionForPort(channelport);//该端口所在设备已经定位了端口位置的端口位置
    		int sum1 = Integer.valueOf(sumnative.split("#")[0]);//该端口的时隙对端端口的时隙个数总和
            String positionset = "";
            if (sum1 > sum) 
            {
                positionset = sumnative.split("#")[1];
            }
            int sumhis = sum;
            int k = 0;
            int l = 3;
    		for(int ccIndex=0;ccIndex<ccLinks.size();ccIndex++)
    		{
    			if(channelport==ccLinks.get(ccIndex).getPortA()||channelport==ccLinks.get(ccIndex).getPortZ())
    			{
    				if(channelport==ccLinks.get(ccIndex).getPortA())
    				{
    					port=ccLinks.get(ccIndex).getPortZ();
    				}
    				else
    				{
    					port=ccLinks.get(ccIndex).getPortA();
    				}
    				
    				if(port.getPosition()==0)//尚未设置位置
    				{
                        if (port.getBelongequipment()!=startPort.getBelongequipment())//不是起始设备上的端口
                        {
		                    if (port.getPosition() == 0)//还没有定位端口位置
		                    {
	                            if (sum1 > 1) //已经定位过端口位置的交叉对端端口数量>1
                            	{
	                                if (sumhis > 1)//端口的时隙交叉对端端口尚未定位的端口数量>1
									{
	                                    if (sumhis != 2)//该端口的交叉对端端口数量不为2,而为3
	                                    {
                                            if (channelport.getPosition() == 3|| channelport.getPosition() == -3) 
                                            {
                                                if (channelport.getPosition() > 0)
                                                {
                                                    port.setPosition(-channelport.getPosition()+ sum- 1);
                                                } 
                                                else 
                                                {
                                                    port.setPosition(-channelport.getPosition()- sum+ 1);
                                                }
                                                sum--;
                                            }
                                            if (channelport.getPosition() == 2|| channelport.getPosition() == -2)
                                            {
                                                if (channelport.getPosition() > 0)
                                                {
                                                	port.setPosition(-channelport.getPosition()+ sum- 2);
                                                } 
                                                else 
                                                {
                                                    port.setPosition(-channelport.getPosition()- sum+ 2);
                                                }
                                                sum--;
                                            }
                                            if (channelport.getPosition() == 1|| channelport.getPosition() == -1)
                                            {
                                                if (channelport.getPosition() > 0)
                                                {
                                                    port.setPosition(-channelport.getPosition()- sum+ 1);
                                                }
                                                else 
                                                {
                                                    port.setPosition(-channelport.getPosition()+ sum- 1);
                                                }
                                                sum--;
                                            }
                                        } 
	                                    else 
	                                    {
                                            if (channelport.getPosition() == 3|| channelport.getPosition() == -3) 
                                            {
                                                if (channelport.getPosition() > 0) 
                                                {
                                                    port.setPosition(-channelport.getPosition()+ sum- k);
                                                    k++;
                                                }
                                                else
                                                {
                                                    port.setPosition(-channelport.getPosition()- sum+ k);
                                                    k++;
                                                }
                                                sum--;
                                            }
                                            if (channelport.getPosition() == 2|| channelport.getPosition() == -2) 
                                            {
                                                if (channelport.getPosition() > 0) 
                                                {
                                                    port.setPosition(-channelport.getPosition()+ sum- l);
                                                    l = 0;
                                                } 
                                                else
                                                {
                                                    port.setPosition(-channelport.getPosition()- sum+ l);
                                                    l++;
                                                }
                                                sum--;
                                            }
                                            if (channelport.getPosition() == 1|| channelport.getPosition() == -1)
                                            {
                                                if (channelport.getPosition() > 0)
                                                {
                                                    port.setPosition(-channelport.getPosition()- sum+ k);
                                                    k++;
                                                }
                                                else
                                                {
                                                    port.setPosition(-channelport.getPosition()+ sum- k);
                                                    k++;
                                                }
                                                sum--;
                                            }

                                        }
                                    }
									 else 
									{
                                        if (positionset.contains(String.valueOf(-channelport.getPosition())))
                                        {
                                        	if (channelport.getPosition() == 1|| channelport.getPosition() == -3)
                                        	{
                                        		  port.setPosition(-channelport.getPosition() - 2);
                                        	}
                                            if (channelport.getPosition() == 3|| channelport.getPosition() == -1)
                                            {  
                                            	port.setPosition(-channelport.getPosition() + 2);
                                            }
                                            if (channelport.getPosition() == 2|| channelport.getPosition() == -2)
                                            { 
                                        		port.setPosition(-channelport.getPosition() + 1);
                                            }
                                        }
                                    }
                                }
	                            else 
                                {
                                    port.setPosition(-channelport.getPosition());
                                }

                               
                            }
                        }
    				}
    			}
    		}
    		
    	}
        for(int equipIndex=0;equipIndex<equipList.size();equipIndex++)
        {
        	List<ChannelLink> ccLinks=equipList.get(equipIndex).getCCLinks();
        	ChannelPort port;
        	if(ccLinks.size()<=1&&ccLinks.size()>0)//判断需要严谨
        	{
        		
        		port=ccLinks.get(0).getPortA();
        		if(port.getPosition()>0)
        		{
        			port.setPosition(position[1]);
        		}
        		else
        		{
        			port.setPosition(-position[1]);
        		}
        		equipList.get(equipIndex).setIsThin(true);
        	}
        }
    
    }

    public void ComputePortPositionFor10M() {
//    	ComputeFirstEquipPortPositionFor10M();// 计算第一个设备上的端口的位置
//        ChannelPort tmp = new ChannelPort();
//        tmp = (ChannelPort) portlist.get(0);
//        String equip = tmp.getBelongequipment().getEquipcode();
//        if (portlist.size() > 0) {
//            channelport = new ChannelPort();
//            for (int i = 1; i < portlist.size(); i++) {
//                channelport = (ChannelPort) portlist.get(i);
//                List<ChannelPort> list = channelport.getConnectport();
//                int sum = judgePortCCandTopoNum(channelport, list);
//                String sumnative = getPostionForPort(channelport, list);
//                int sum1 = Integer.valueOf(sumnative.split("#")[0]);
//                String positionset = "";
//                if (sum1 > sum) {
//                    positionset = sumnative.split("#")[1];
//                }
//                int sumhis = sum;
//                int k = 0;
//                int l = 3;
//                if (list.size() > 0) {
//                    for (int j = 0; j < list.size(); j++) {
//                        ChannelPort portmp = (ChannelPort) list.get(j);
//                        if (!portmp.getBelongequipment().getEquipcode()
//                                .equalsIgnoreCase(equip)) {
//                            if (portmp.getPosition() == 0) {
//                                boolean T = getHasPositionport(portmp);
//                                if (!T
//                                        && !portmp
//                                        .getBelongequipment()
//                                        .getEquipcode()
//                                        .equalsIgnoreCase(
//                                                channelport
//                                                        .getBelongequipment()
//                                                        .getEquipcode())) {
//                                    portmp.setPosition(-channelport
//                                            .getPosition());
//                                }
//
//                                if (!T
//                                        && portmp
//                                        .getBelongequipment()
//                                        .getEquipcode()
//                                        .equalsIgnoreCase(
//                                                channelport
//                                                        .getBelongequipment()
//                                                        .getEquipcode())) {
//                                    if (sum1 > 1) {
//                                        if (sumhis > 1) {
//                                            if (sumhis != 2) {
//                                                if (channelport.getPosition() == 3
//                                                        || channelport
//                                                        .getPosition() == -3) {
//                                                    if (channelport
//                                                            .getPosition() > 0) {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        + sum
//                                                                        - 1);
//                                                    } else {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        - sum
//                                                                        + 1);
//                                                    }
//                                                    sum--;
//                                                }
//                                                if (channelport.getPosition() == 2
//                                                        || channelport
//                                                        .getPosition() == -2) {
//                                                    if (channelport
//                                                            .getPosition() > 0) {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        + sum
//                                                                        - 2);
//                                                    } else {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        - sum
//                                                                        + 2);
//                                                    }
//                                                    sum--;
//                                                }
//                                                if (channelport.getPosition() == 1
//                                                        || channelport
//                                                        .getPosition() == -1) {
//                                                    if (channelport
//                                                            .getPosition() > 0) {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        - sum
//                                                                        + 1);
//                                                    } else {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        + sum
//                                                                        - 1);
//                                                    }
//                                                    sum--;
//                                                }
//                                            } else {
//                                                if (channelport.getPosition() == 3
//                                                        || channelport
//                                                        .getPosition() == -3) {
//                                                    if (channelport
//                                                            .getPosition() > 0) {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        + sum
//                                                                        - k);
//                                                        k++;
//                                                    } else {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        - sum
//                                                                        + k);
//                                                        k++;
//                                                    }
//                                                    sum--;
//                                                }
//                                                if (channelport.getPosition() == 2
//                                                        || channelport
//                                                        .getPosition() == -2) {
//                                                    if (channelport
//                                                            .getPosition() > 0) {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        + sum
//                                                                        - l);
//                                                        l = 0;
//                                                    } else {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        - sum
//                                                                        + l);
//                                                        l++;
//                                                    }
//                                                    sum--;
//                                                }
//                                                if (channelport.getPosition() == 1
//                                                        || channelport
//                                                        .getPosition() == -1) {
//                                                    if (channelport
//                                                            .getPosition() > 0) {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        - sum
//                                                                        + k);
//                                                        k++;
//                                                    } else {
//                                                        portmp
//                                                                .setPosition(-channelport
//                                                                        .getPosition()
//                                                                        + sum
//                                                                        - k);
//                                                        k++;
//                                                    }
//                                                    sum--;
//                                                }
//
//                                            }
//                                        } else {
//                                            if (positionset.contains(String
//                                                    .valueOf(-channelport
//                                                    .getPosition()))) {
//
//                                                if (channelport.getPosition() == 1
//                                                        || channelport
//                                                        .getPosition() == -3)
//                                                    portmp
//                                                            .setPosition(-channelport
//                                                                    .getPosition() - 2);
//                                                if (channelport.getPosition() == 3
//                                                        || channelport
//                                                        .getPosition() == -1)
//                                                    portmp
//                                                            .setPosition(-channelport
//                                                                    .getPosition() + 2);
//                                                if (channelport.getPosition() == 2
//                                                        || channelport
//                                                        .getPosition() == -2)
//                                                    portmp
//                                                            .setPosition(-channelport
//                                                                    .getPosition() + 1);
//
//                                            }
//                                        }
//                                    } else {
//                                        portmp.setPosition(-channelport
//                                                .getPosition());
//                                    }
//                                }
//                                if (portmp.getPosition() != 0) {
//                                    for (int ii = 0; ii < portlist.size(); ii++) {
//                                        ChannelPort channeltmp = (ChannelPort) portlist
//                                                .get(ii);
//                                        if (channeltmp.getPort()
//                                                .equalsIgnoreCase(
//                                                        portmp.getPort())
//                                                && channeltmp.getPosition() == 0
//                                                && channeltmp
//                                                .getSlot()
//                                                .equalsIgnoreCase(
//                                                        portmp
//                                                                .getSlot())) {
//                                            channeltmp.setPosition(portmp
//                                                    .getPosition());
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//            }
//        }
    }
    
    
    /**
     * 计算一个端口的交叉有几个，为计算设备上的端口的相对坐标.
     *
     * @param 端口对象
     * @param 端口对象中的conlist
     * @return 交叉数量
     */
    public int judgePortCCandTopoNum(ChannelPort portParm, List<ChannelPort> conPortList) 
	 {
        int num = 0;
        if (conPortList.size() > 0) 
        {
            for (int i = 0; i < conPortList.size(); i++)
            {
            	ChannelPort portTmp = conPortList.get(i);
                if (portParm.getBelongequipment().getEquipcode()
                        .equalsIgnoreCase(
                                portTmp.getBelongequipment().getEquipcode()))//为设备内部时隙交叉的对端端口
                {
                	String portgroup = "";
                    for (int j = 0; j < portlist.size(); j++)
                    {
                        ChannelPort portJudge =  portlist.get(j);
                        if(circuitRate!=null&&circuitRate.equalsIgnoreCase("10M-100M")){
                        	if(!portgroup.contains(portJudge.getPort())){
                        		if (portTmp.getPort().equalsIgnoreCase(
                                        portJudge.getPort())
                                        && portJudge.getPosition() == 0) {
                                     num++;
                        		}
                        		portgroup += portJudge.getPort()+",";	
                        	}
                        	
                        }else{
                        	 if (portTmp.getPort().equalsIgnoreCase(
                                     portJudge.getPort())
                                     && portJudge.getPosition() == 0
                                     && portTmp.getSlot().equalsIgnoreCase(
                                     portJudge.getSlot())) {
                                 num++;
                             } 	
                        }
                    }
                }
            }
        }
        return num;
    }
    /**
     * 获取该端口所在设备内的已经定位了的端口位置
     *
    * @param  portParm 端口对象
     * @return the postion for port
     */
    public String getPostionForPort(ChannelPort port)
    {
    	int num = 0;//与之相连的时隙对端端口的时隙个数总和
        String positionset = "0";
        List<ChannelLink> links=port.getBelongequipment().getCCLinks();
       
        for (int i = 0; i < links.size(); i++) 
        {
        	if(links.get(i).getPortA()==port)
        	{
        		num++;
        		if(links.get(i).getPortZ().getPosition()!=0)
        		{
        			positionset+=links.get(i).getPortZ().getPosition()+",";
        		}
        	}
        	else if(links.get(i).getPortZ()==port)
        	{
        		num++;
        		if(links.get(i).getPortA().getPosition()!=0)
        		{
        			positionset+=links.get(i).getPortA().getPosition()+",";
        		}
        	}
        	
        }
        String data = "";
        data = num + "#" + positionset;
        return data;
    }
    

   


    /**
     * 计算设备坐标 .
     */
    public void ComputeEquipPosition() 
    {     
        List<ChannelEquipment> tmpList = null;
        if (equipList.size() > 0) 
        {           
            channelequipment = startPort.getBelongequipment();//起始设备
            channelequipment.setX(x);
            channelequipment.setY(y);
            tmpList = new ArrayList<ChannelEquipment>();
            tmpList.add(channelequipment);
            int connectnum = 0;
            for (int i = 0; i < tmpList.size(); i++) 
            {
              
                channelequipment = tmpList.get(i);
                int totalsize = channelequipment.getListconnequip().size();//当前设备关联的设备个数
                if (totalsize > 2)
                {
                    connectnum++;
                }
                int size = getnullitemsize(channelequipment);//获取设备对象中的CONNEQUIP中的坐标为0的个数
                int u = size;
                //k:当前设备的关联设备的下标
                //j:统计已经处理的y坐标为0的关联设备个数
                //u:尚存在的坐标为0的关联设备个数
                for (int j = 0, k = 0; k < channelequipment.getListconnequip().size()&& j < size; k++, j++, u--)
                {
                    ChannelEquipment channeltmp = channelequipment.getListconnequip().get(k);

                    if (channeltmp.getY() == 0&& ((channeltmp.isIsbranchequip() 
                    		&& channelequipment.isIsbranchequip()) || !channeltmp.isIsbranchequip())) 
                    {
                        if (totalsize > 2 && connectnum > 1) 
                        {
                            channeltmp.setIsreset(true);
                        }
                        else 
                        {
                            channeltmp.setIsreset(false);
                        }
                        channeltmp.setX(channelequipment.getX() + dx);
                        if (size < 2)//只关联了一个设备
                        {
                            channeltmp.setY(channelequipment.getY()
                                    + (size - j - 1) * dy / (size));
                        }
                        else
                        {
                        	//start---找到两个设备之间的复用段
                        	List<ChannelLink> aLinks=channelequipment.getTopoLinks();
                        	List<ChannelLink> publicLinks=new ArrayList<ChannelLink>();
                        	for(int linkIndex=0;linkIndex<aLinks.size();linkIndex++)
                        	{
                        		if(aLinks.get(linkIndex).getPortA().getBelongequipment()==channeltmp||
                        		   aLinks.get(linkIndex).getPortZ().getBelongequipment()==channeltmp)//为两个设备间的复用段
                        		{
                        			publicLinks.add(aLinks.get(linkIndex));
                        		}
                        	}    
                        	if(publicLinks.size()>0)//两个设备之间存在复用段，则必为一条（错误的） 有可能为2条，暂时没做处理，用另外的方法弥补该错误add by sjt
                        	{
                        		int position=publicLinks.get(0).getPortA().getPosition();
                        		if ((Math.abs(position) == 1 || Math.abs(position) == 3)) 
                        		{
                        			if (Math.abs(position) == 1)
	                                {
	                                    channeltmp.setY(channelequipment.getY());
	                                }
	                                if (Math.abs(position) == 3) 
	                                {
	                                    channeltmp.setY(channelequipment.getY()+ dy / 2);
	                                }
	                            } 
	                            else
	                            {
	                                channeltmp.setY(channelequipment.getY()+ (size - u) * dy / (size));
	                            }
                        	}
                        	//end-----找到两个设备之间的复用段                      
                            
                        }
                        channeltmp.setTogetherequip(channelequipment);
                        boolean flag = false;//标识在临时保存已经计算过位置的设备列表中是否已经存在，true:存在，false：不存在
                        if (tmpList.size() > 0) 
                        {
                            for (int p = 0; p < tmpList.size(); p++) 
                            {
                                ChannelEquipment tmp = (ChannelEquipment) tmpList.get(p);
                                if (tmp==channeltmp)
                                {
                                    flag = true;
                                    break;
                                }
                            }
                        }
                        else
                        { 
                        	tmpList.add(channeltmp);
                        }
                        if (!flag)
                        {
                            tmpList.add(channeltmp);
                        }
                    }
                    else 
                    {
                        j--;
                        u++;
                    }
                }
                boolean T = reCompute(channelequipment, size, tmpList,connectnum, totalsize);
                if (T) 
                {
                    connectnum = -1;
                }
            }
           
            reComputeEndEquipPostion();// 重新计算支路口终点设备的坐标
        }
    }

    /**
     * 判断是否需要对一些需要特殊处理的设备的坐标进行重新计算.
     *
     * @param tmpList          当前已经遍历过的设备的列表
     * @param connectnum       the connectnum
     * @param channelequipment 当前设备
     * @param size             当前设备关联的设备列表中尚未定位的设备个数
     * @param totalsize        当前设备关联的设备个数
     * @return boolean
     */
    public boolean reCompute(ChannelEquipment channelequipment, int size,
                             List<ChannelEquipment> tmpList, int connectnum, int totalsize)
    {
        boolean T = false;//默认不需要重新计算该设备关联的设备坐标
        if (channelequipment.isHasRest() && connectnum > 1)
        {
            size = getnullitemsize1(channelequipment, tmpList, totalsize);
            for (int j = 0, k = 0; k < channelequipment.getListconnequip().size()&& j < size; k++, j++) 
            {
                ChannelEquipment channeltmp = channelequipment.getListconnequip().get(k);
                if (!channeltmp.isIsbranchequip()) 
                {
                    channeltmp.setX(channelequipment.getX() + dx);
                    channeltmp.setY(channelequipment.getY() + (size - j - 1)* dy / (size));
                    if (tmpList.size() > 0)
                    {
                        for (int p = 0; p < tmpList.size(); p++)
                        {
                            ChannelEquipment tmp = (ChannelEquipment) tmpList.get(p);
                            if (tmp.getEquipcode().equalsIgnoreCase(channeltmp.getEquipcode())&& tmp.isIsreset() && connectnum > 1)
                            {
                                tmp.setY(channeltmp.getY());
                                if (tmp.getTogetherequip() != null)
                                {
                                    for (int i = 0; i < tmpList.size(); i++)
                                    {
                                        ChannelEquipment equiptmp = (ChannelEquipment) tmpList.get(i);
                                        if (equiptmp.getTogetherequip() != null&& equiptmp.getTogetherequip().getEquipcode() != null)
                                        {
                                            if (tmp.getTogetherequip().getEquipcode().equalsIgnoreCase(equiptmp.getTogetherequip().getEquipcode())) {
                                                if (!tmp.getEquipcode().equalsIgnoreCase(equiptmp.getEquipcode()))
                                                    if (equiptmp.isIsreset()) 
                                                    {
                                                        // if(dtmpy>0)
                                                        // equiptmp.setY(equiptmp.getY()-dtmpy);
                                                        // else
                                                        // equiptmp.setY(equiptmp.getY()+dtmpy);
                                                    }
                                            }
                                        }
                                    }
                                }
                                T = true;
                                j++;
                                break;
                            }

                        }
                        if (!T)
                        {
                            j--;
                        }
                    }

                }
            }
        }
        return T;
    }

    /**
     * 重新计算支路口终点设备的坐标.
     */
    public void reComputeEndEquipPostion() 
    {
    	double max_x = 0;
    	double first_y = 0;
    	ChannelEquipment endEquipment=null;//终止设备
        if (equipList.size() > 0&&equipList.size()>2)
        {
            for (int i = 0; i < equipList.size(); i++)
            {
                ChannelEquipment equipment = equipList.get(i);
                if (equipment.getX() > max_x && !equipment.isIsbranchequip())
                {
                    max_x = equipment.getX();
                }
                if (i == 0)
                {
                    first_y = equipment.getY();
                }
                if(i!=0&&equipment.isIsbranchequip())
                {
                	endEquipment=equipment;
                }
            }
            if(endEquipment!=null)
            {
            	endEquipment.setX(max_x + dx);
            	endEquipment.setY(first_y);
            }
            
        }

    }

   
  


   

//    /**
//     * 判断相连的端口是否已经存在.
//     *
//     * @param list    the list
//     * @param channel the channel
//     * @return true, if judge conn port exit
//     */
//    public boolean JudgeConnPortExit(ChannelPort channel, List<ChannelPort> list)
//	 {
//        for (int i = 0; i < list.size(); i++)
//        {
//            ChannelPort tmp = list.get(i);
//            if (tmp==channel)
//            {
//                return true;
//            }
//        }
//        return false;
//    }





    /**
     * 计算第一个设备上的端口的相对位置.
     */
    public void ComputeFirstEquipPortPosition() 
    {
    	ChannelPort porttmp;
    	channelequipment=startPort.getBelongequipment();
    	List<ChannelPort> ports=channelequipment.getPorts();
    	int portnum=ports.size();
    	int j = 1;
	    for (int i = 1; i < ports.size(); i++)
	    { 
	    	porttmp =  ports.get(i);
	    	if (portnum == 2)//只有一个交叉时隙
            {
	    		porttmp.setPosition(-startPort.getPosition());
            }
            if (portnum == 3)//有两个交叉时隙
            {
            	porttmp.setPosition(-startPort.getPosition() - j);
            	j = -1;
            }
            if (portnum == 4) //有三个交叉时隙
            {
            	porttmp.setPosition(-startPort.getPosition() - j);
            	j--;
            }
	         
	      }

    	
    }
    public void ComputeFirstEquipPortPositionFor10M() {// 优化 麻烦
        ChannelPort porttmp = null;
        
        if (portlist.size() > 0) {
        	ChannelPort tt = (ChannelPort)portlist.get(0);
        	tt.setPosition(1);
            channelport = new ChannelPort();
            if(portlist.size()>1)
            	channelport = (ChannelPort) portlist.get(1);	
            else
            	channelport = tt;
            channelport.setPosition(2);
            int portsum = 1;
            String portgroup = "";                                                     
            for (int i = 0; i < portlist.size(); i++) {
                porttmp = new ChannelPort();
                porttmp = (ChannelPort) portlist.get(i);
                if(!portgroup.contains(porttmp.getPort())){
                	 if (channelport.getBelongequipment().getEquipcode() != null && channelport.getBelongequipment().getEquipcode()
                             .equalsIgnoreCase(
                                     porttmp.getBelongequipment().getEquipcode())
                             && !channelport.getPort().equalsIgnoreCase(
                             porttmp.getPort())&&porttmp.getPosition()==0) {
                         portsum++;
                     }
                	 portgroup+=porttmp.getPort()+",";
                }
               
            }
            if (portsum > 0) {
                int j = 1;
                for (int i = 0; i < portlist.size(); i++) {
                
                    porttmp = portlist.get(i);
                    if (channelport
                            .getBelongequipment()
                            .getEquipcode()
                            .equalsIgnoreCase(
                                    porttmp.getBelongequipment().getEquipcode())
                            && !channelport.getPort().equalsIgnoreCase(
                            porttmp.getPort())) {
                    	if(porttmp.getPosition()==0){
	                        if (portsum == 2) {
	                            porttmp.setPosition(-channelport.getPosition());
	                        }
	                        if (portsum == 3) {
	                            porttmp.setPosition(-channelport.getPosition() - j);
	                            j = -1;
	                        }
	                        if (portsum == 4) {
	                            porttmp.setPosition(-channelport.getPosition() - j);
	                            j--;
	                        }
	                        for(int k=0;k<portlist.size();k++){
	                        	ChannelPort tmp = (ChannelPort)portlist.get(k);
	                        	if(tmp.getPort().equalsIgnoreCase(porttmp.getPort())){
	                        		tmp.setPosition(porttmp.getPosition());
	                        	}
	                        }
                    	}
                    }
                }
            }
        }
    }

    /**
     * 判断相同的端口时隙.???????????????
     *
     * @param porttmp  the porttmp
     * @param portlist the portlist
     * @return boolean
     */
    public boolean Judge(List<ChannelPort> portlist, ChannelPort porttmp)
    {
    	for (int i = 0; i < portlist.size(); i++) 
    	{
			ChannelPort judge =  portlist.get(i);
			// 如果加时隙的判断，设备上就可能会出现很多端口，这样串出来的电路问题可看性不高，所以把下面的注释掉，改成直接判断端口是否在列表中存在
			if (circuitRate != null && circuitRate.equalsIgnoreCase("VC4"))
			{
				if ((judge.getPort().equalsIgnoreCase(porttmp.getPort()))&& (judge.getReal_slot().equalsIgnoreCase(porttmp
								.getReal_slot()))) {
					return true;
				}
			} 
			else
			{
				if ((judge.getPort().equalsIgnoreCase(porttmp.getPort()))
						&& (judge.getSlot().equalsIgnoreCase(porttmp.getSlot()))) {
					return true;
				}
			}
		}
		return false;
    }

    /**
     * 获取设备对象中的CONNEQUIP中的坐标为0的个数
     *
     * @param channel   当前设备
     * @return  size 当前设备关联的设备中尚未定位位置的设备个数
     */
    public int getnullitemsize(ChannelEquipment channel)
    {
    	int totalsize=channel.getListconnequip().size();//当前设备关联的设备个数
        int size = 0;//当前设备关联的设备中尚未定位位置的设备个数
        List<ChannelEquipment> list = channel.getListconnequip();//与该设备连接的设备列表
        for (int i = 0; i < list.size(); i++)
        {
        	ChannelEquipment equip =  list.get(i);
        	if(!equip.isIsreset())//尚未定位
        	{
        		size++;
        	}
            if (equip.isIsreset() && totalsize > 1)
            {
                channel.setHasRest(true);
            }
        }
        return size;
    }

    /**??????????????????//
     * Getnullitemsize1.
     *
     * @param tmpList   the tmp list
     * @param channel   the channel
     * @param totalsize the totalsize
     * @return the nullitemsize1
     */
    public int getnullitemsize1(ChannelEquipment channel, List<ChannelEquipment> tmpList,
                                int totalsize)
    {
        int size = 0;
        List<ChannelEquipment> list = channel.getListconnequip();
        if (list != null) {
            if (list.size() > 0) {
                for (int i = 0; i < list.size(); i++) 
                {
                    ChannelEquipment equip = list.get(i);
                    for (int j = 0; j < tmpList.size(); j++) {
                        ChannelEquipment ment =  tmpList.get(j);
                               
                        if (ment.getEquipcode().equalsIgnoreCase(
                                equip.getEquipcode())) {
                            equip.setX(ment.getX());
                            equip.setY(ment.getY());
                            equip.setIsreset(ment.isIsreset());
                        }
                    }
                    if (equip.getY() == 0
                            || (equip.isIsreset() && totalsize > 1)) {
                        size++;
                    }
                }
            }
        }
        return size;
    }


    /**
     * 生成xml.
     *
     * @param filename 电路方式单名称
     * @param isRefresh     
     * @return the xml 生成的电路内容
     * @author 高磊
     */
    public String getXml(boolean isRefresh) 
    {
    	//注册 start
		SerializationSettings.registerGlobalClient("flag", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("isbranch", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("position", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("equipcode", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("portcode", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("topoid", Consts.TYPE_STRING);
		//注册 end
        String xml = "";
        String systemcodes="";
        String systemcodegroup="";
        ChannelEquipment equipment;
        double x = 0;
        double y =0;
        try
        {
        	// 生成设备xml
            box.clear();
        	for (int i = 0; i < equipList.size(); i++)
        	{
        		equipment =  equipList.get(i);
        		//数据库中获取设备x，y 		start  mawj 2013-8-20
        		HashMap paraMap=new HashMap();
        		paraMap.put("cir_code", this.currentCircuitCode);
        		paraMap.put("equipcode", equipment.getEquipcode());
        		HashMap circuitMap=(HashMap)sqlMapClientTemplate.queryForObject("selectXYByCircuitCodeAndEquipCode", paraMap);//获取当前电路编号和业务名称
        		if(circuitMap!=null){
        			String p_x=(String)circuitMap.get("X");
                	String p_y=(String)circuitMap.get("Y");
                	double ep_x=p_x==null?equipment.getX():Double.parseDouble(p_x);
                	double ep_y=p_x==null?equipment.getY():Double.parseDouble(p_y);//取channel_element_position 表中存储的位置，若没有则取默认值
                	equipment.setX(ep_x);equipment.setY(ep_y);
        		}
        		
            	//数据库中获取设备x，y 		end
        		String equipment_image=equipImage;//设备的图片路径
                if(equipment.getIsvirtual()!=null&&!equipment.getIsvirtual().equalsIgnoreCase("")&&!equipment.getIsvirtual().equalsIgnoreCase("null"))
                {
                	
                	equipment_image=virtualEquipImage;//虚拟设备的图片路径
                }
                if(equipment.getSystemcode()!=null&&!systemcodegroup.contains(equipment.getSystemcode()))
                {
                    systemcodegroup += equipment.getSystemcode()+"$$";
                    systemcodes+=equipment.getSystemcode()+",";
                }
                //添加设备节点
                Node node = new Node(equipment.getEquipcode());
                node.setName(equipment.getXmodel());
                node.setImage(equipment_image);
                node.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
          //    node.setLocation(equipment.getX(), equipment.getY());
                       node.setCenterLocation(equipment.getX(), equipment.getY());
                node.setWidth(equip_Width);
                double height=0.0;
                if(equipment.getIsThin())
                {
                	node.setHeight(thinEquip_Height);
                	height=thinEquip_Height;
                }
                else
                {
                	 node.setHeight(equip_Height);
                	 height=equip_Height;
                }
               
                node.setLayerID("equipment");
                node.setClient("flag","equipment");
                node.setClient("isbranch",equipment.isIsbranchequip());
                node.setClient("equipcode",equipment.getEquipcode());
                node.setParent(box.getElementByID(equipment.getSystemcode()));
                node.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
                node.setClient("flag","equipment");
                box.add(node);
                //添加设备的名称，位于设备的顶部
        		x = equipment.getX()+label_x;
        		y = equipment.getY()-label_Height;
        		Follower follower = new Follower(equipment.getEquipcode()+name_ID);
        		follower.setName(equipment.getEquipname());//名称的Follower
        		follower.setParent(node);
        		//follower.setStyle(Styles.LABEL_BOLD, true);
        		follower.setStyle(Styles.LABEL_SIZE, 12);
        		follower.setImage(null);
        		follower.setWidth(0);
        		follower.setHeight(0);
        		follower.setLayerID("port1");
        		follower.setHost(node); 
        	//	follower.setLocation(x,y);
        			follower.setCenterLocation(x, y);
        		follower.setStyle(Styles.LABEL_POSITION, Consts.POSITION_TOP);
        		box.add(follower);
        		//添加设备的型号，位于设备的底部
//        		y = equipment.getY()+node.getHeight()/2+label_Height;
//        		follower = new Follower(equipment.getEquipcode()+model_ID);
//        		follower.setName(equipment.getXmodel());
//        		follower.setStyle(Styles.LABEL_SIZE, 13);
//        		follower.setParent(node);
//        		follower.setImage(null);
//        		follower.setWidth(0);
//        		follower.setHeight(0);
//        		follower.setLayerID("port1");
//        		follower.setHost(node);
//       		//follower.setLocation(x,y);
//       	 		follower.setCenterLocation(x, y);
//        		follower.setStyle(Styles.LABEL_POSITION, Consts.POSITION_BOTTOM);
//        		box.add(follower);
        		//添加设备端口
        		for(int portIndex=0;portIndex<equipment.getPorts().size();portIndex++)
        		{
        			ChannelPort port = equipment.getPorts().get(portIndex);
        			if(port.getPosition()>3){
                    	port.setPosition(port.getPosition()-1);
                    }
                    if(port.getPosition()<-3){
                    	port.setPosition(port.getPosition()+1);
                    }
                    //获取当前端口所属设备的x，y坐标
        			if(equipment.getIsThin())
        			{
        				if (port.getPosition() > 0)//表示在设备的左侧
                        {
                            port.setX(port_x[0]+equipment.getX());
                            port.setY(thinPort_Y+equipment.getY());
                        } 
                        else
                        {
                        	  port.setX(port_x[1]+equipment.getX());
                        	  port.setY(thinPort_Y+equipment.getY());
                          }
                       
        			}
        			else
        			{
        				if (port.getPosition() > 0)//表示在设备的左侧
                        {
                            port.setX(port_x[0]+equipment.getX());
                            port.setY(port_y[port.getPosition() - 1]+equipment.getY());
                        } 
                        else
                        {
                            port.setX(port_x[1]+equipment.getX());
                            
                            if (port.getPosition() != 0)
                            {
                                port.setY(port_y[-port.getPosition() - 1]+equipment.getY());
                            }
                            else
                            {
                            	port.setY(port_y[1]+equipment.getY());
                            }
                        }
        			}
                    
                    String img = portImage;//普通端口的图片
                    if (port.isIsbranch())
                    {
                        img = branchPortImage;//支路口的图片
                    }                
    				
					follower = new Follower(port.getPort());
    				
            		follower.setName(port.getPortlabel());
            		follower.setParent(box.getDataByID(port.getBelongequipment().getEquipcode()).getParent());
            		follower.setStyle(Styles.LABEL_SIZE, 9);
            		follower.setImage(img);
            		follower.setWidth(port_Width);
            		follower.setHeight(port_Height);
            		follower.setLayerID("port");
            		follower.setHost((Node)box.getDataByID(port.getBelongequipment().getEquipcode()));
            		follower.setLocation(port.getX(),port.getY());
            		follower.setClient("flag", "port");
            		follower.setClient("position", String.valueOf(port.getPosition()));
            		String f_portcode = "";
            		if (circuitRate != null
    						&& circuitRate.equalsIgnoreCase("VC4"))
            		{
    					f_portcode = port.getPort() + ","
    							+ port.getReal_slot();
            		}
            		else
            		{
            			f_portcode = port.getPort() + "," + port.getSlot();
            		}
            		follower.setClient("portcode", f_portcode);
            		follower.setClient("isbranch", port.isIsbranch());
            		String toolTip = port.getPortdetail()!=null?port.getPortdetail():"";
            		if (circuitRate != null
    						&& circuitRate.equalsIgnoreCase("VC4"))
            			toolTip =toolTip+"—时隙:"+To373(port.getReal_slot());//+To373(port.getReal_slot())+port.getReal_slot()
            		else
            			toolTip =toolTip+"—时隙:"+To373(port.getSlot());//+To373(port.getSlot());//+port.getSlot()
            		follower.setToolTip(toolTip);
            		String portshow = port.getPortshow()!=null?port.getPortshow():"";
            		follower.setClient("portlabel", portshow);
            		if (circuitRate != null
    						&& circuitRate.equalsIgnoreCase("VC4"))
            			follower.setClient("slot", port.getReal_slot());
            		else
            			follower.setClient("slot", port.getSlot());
            		follower.setClient("flag", "port");
                    box.add(follower);
        		}
    		//添加时隙交叉
    		for(int linkIndex=0;linkIndex<equipment.getCCLinks().size();linkIndex++)
    		{
                boolean arrowfrom = false;
                boolean arrowto = false;
                ChannelPort aport=equipment.getCCLinks().get(linkIndex).getPortA();
                ChannelPort zport=equipment.getCCLinks().get(linkIndex).getPortZ();
                
                if (zport.getDirection() != null)
                {
                    if (zport.getDirection().equalsIgnoreCase("BI")
                            || zport.getDirection().equalsIgnoreCase("-BI")) 
                    {
                        arrowfrom = true;
                        arrowto = true;
                    }

                    if (zport.getDirection().equalsIgnoreCase("-UNI")) 
                    {
                        arrowfrom = true;
                    }
                    if (zport.getDirection().equalsIgnoreCase("UNI")) 
                    {
                        arrowto = true;
                    }
                }
                int strokeWidth = 2;
                int arrowWidth = 9;
              
                if (rate.equalsIgnoreCase("VC12")) 
                {
                    if (!zport.getCrate().equalsIgnoreCase(rate))
                    {
                    	strokeWidth = 3;
                        arrowWidth = 12;
                    }
                }
              
                String topoid = "cc"; 
                Link link= new Link(equipment.getCCLinks().get(linkIndex).getTopoid());
							
			    link.setStyle(Styles.ARROW_FROM, arrowfrom);
                link.setStyle(Styles.ARROW_TO, arrowto);
                link.setStyle(Styles.ARROW_FROM_HEIGHT, arrowWidth);
                link.setStyle(Styles.ARROW_TO_HEIGHT,arrowWidth);
                link.setStyle(Styles.LINK_WIDTH, strokeWidth);
                String color = "0x00CC00";
                link.setStyle(Styles.ARROW_FROM_COLOR, color);
                link.setStyle(Styles.ARROW_TO_COLOR, color);
              
                link.setStyle(Styles.LINK_COLOR, color);
                link.setStyle(Styles.LABEL_XOFFSET, -5);
                link.setStyle(Styles.LABEL_YOFFSET, -17);
                link.setLayerID("port");
                link.setStyle(Styles.LINK_BUNDLE_GAP, 30);
                link.setClient("flag", "cc");
                Follower from=(Follower)box.getDataByID(aport.getPort());
				Follower to=(Follower)box.getDataByID(zport.getPort());						
                link.setFromNode(from);
                link.setToNode(to);
                link.setClient("topoid", topoid);                 
                link.setClient("rate", aport.getCrate());
                link.setClient("flag", "cc");
                box.add(link);
       
              }
			}
        	//添加复用段
        	for (int i = 0; i < equipList.size(); i++)
        	{
        		String slot="";
        		String slotno373="";
        		ChannelLink link;
        		for(int linkIndex=0;linkIndex<equipList.get(i).getTopoLinks().size();linkIndex++)
        		{
        			link=equipList.get(i).getTopoLinks().get(linkIndex);
        			ChannelPort aport=link.getPortA();
        			ChannelPort zport=link.getPortZ();
        			if(box.getDataByID(link.getTopoid())==null)
        			{
        				if (circuitRate != null&& circuitRate.equalsIgnoreCase("VC4")) 
                    	{
    						slot = aport.getReal_slot();
    					} 
                    	else 
                    	{
    					
    						if (aport.getCrate() != null&& aport.getCrate().equalsIgnoreCase("VC4"))
    						{
    							slot = String.valueOf((Integer.valueOf(aport.getReal_slot()) - 1)* 63+ aport.getDslot());
    						}
    						else
    						{
    							slot = aport.getSlot();
    						}
    						slotno373 = slot;
    						slot = To373(slot);
    					}
    					slot = "\n  " + slot + "";
    					int strokeWidth = 2;
                        int arrowWidth = 9;
                        boolean arrowfrom = false;
                        boolean arrowto = false;
                        Link topoLink= new Link(link.getTopoid());;
                        topoLink.setName(slot);
                        topoLink.setStyle(Styles.ARROW_FROM, arrowfrom);
                        topoLink.setStyle(Styles.ARROW_TO, arrowto);
                        topoLink.setStyle(Styles.ARROW_FROM_HEIGHT, arrowWidth);
                        topoLink.setStyle(Styles.ARROW_TO_HEIGHT,arrowWidth);
                        topoLink.setStyle(Styles.LINK_WIDTH, strokeWidth);
                        String color = "0x00CC00";  
                        topoLink.setStyle(Styles.ARROW_FROM_COLOR, color);
                        topoLink.setStyle(Styles.ARROW_TO_COLOR, color);
                        topoLink.setStyle(Styles.LINK_COLOR, color);
                        topoLink.setStyle(Styles.LABEL_XOFFSET, -5);
                        topoLink.setStyle(Styles.LABEL_YOFFSET, -17);
                        topoLink.setLayerID("port");
                        topoLink.setStyle(Styles.LINK_BUNDLE_GAP, 30);
                        topoLink.setClient("flag", "topolink");
                        Follower from= (Follower) box.getDataByID(aport.getPort());
    					Follower to = (Follower) box.getDataByID(zport.getPort());
    					topoLink.setFromNode(from);
    					topoLink.setToNode(to);
    					topoLink.setClient("topoid", link.getTopoid());
                      	if(!("64K").equalsIgnoreCase(circuitRate))
                     	{
                      		topoLink.setClient("timeslot",slotno373);
                      		topoLink.setClient("timeslot373", slot);
                     	}
                      	topoLink.setClient("flag", "topolink");
                        box.add(topoLink);
        			}
        			
        			
        			
        		}
        	}
        	if(systemcodes!=null&&!"".equals(systemcodes)){
        		if(systemcodegroup.length()-2<systemcodes.length())
    	           systemcodes=systemcodes.substring(0, systemcodegroup.length()-2);
	        	else 
	        		systemcodes = systemcodes.substring(0, systemcodes.length()-1);
        		Node node=new Follower("label");
                node.setLayerID("port1");
                node.setLocation(10,10);
                node.setIcon("");
                node.setImage("");
                node.setSize(0, 0);
                node.setName("电路名称："+username+"   电路编码："+currentCircuitCode+"   所属系统："+systemcodes);
//                node.setStyle(Styles.LABEL_POSITION,Consts.POSITION_TOPRIGHT_TOPRIGHT);//在这里设置样式无效，原因尚不知
//                node.setStyle(Styles.LABEL_POINTER_WIDTH,100);
//                node.setStyle(Styles.LABEL_POINTER_LENGTH,50);
//                node.setStyle(Styles.LABEL_FILL, true);
//                node.setStyle(Styles.LABEL_XOFFSET,10);
//                node.setStyle(Styles.LABEL_YOFFSET, 0);
//                node.setStyle(Styles.LABEL_DIRECTION, Consts.ATTACHMENT_DIRECTION_ABOVE_RIGHT);
                node.setLayerID("titleName");
                box.add(node);

       	}
            xml = serializer.serialize();
            equipList.clear();
    		portlist.clear();
    		linkList.clear();
    		box.clear();
        }
        catch(Exception e)
        {
        	e.printStackTrace();
        }
    	System.out.println("xml:"+xml);
        return xml;
    }
    /**
     * 用来存放已经修改完位置的设备
     */
    private List<ChannelEquipment> tmpEquips = null;
    /**
     * 用于修正南网端口重叠与设备重叠
     *@2013-4-10
     *@author jtsun
     */
    private void changePortLocation(){
    	String string="";
    	/**
    	 * 修改端口用的临时设备父设备
    	 */
    	ChannelEquipment tmpEquip =null;
    	/**
    	 * 修改端口用的临时设备子设备
    	 */
    	ChannelEquipment equip =null;
    	/**
    	 * 修改端口重叠
    	 */
    	for(int i=0;i<equipList.size();i++){
    		ChannelEquipment equipment =equipList.get(i); 
    		if(equipment.getPorts().size()>3){
    			if(equipment.getTopoLinks().size()==4){
    				int links=0;
    				for (int k = 0; k < equipment.getTopoLinks().size(); k++) {
    					ChannelLink link = equipment.getTopoLinks().get(k);
    					if(link.getPortA().getBelongequipment().getEquipcode()==equipment.getEquipcode()||link.getPortZ().getBelongequipment().getEquipcode()==equipment.getEquipcode()){
    						links++;
    							if(link.getPortA().getBelongequipment().getEquipcode()==equipment.getEquipcode()){
    								if(link.getPortZ().getBelongequipment().getTopoLinks().size()==2&&
    										link.getPortZ().getBelongequipment().getListconnequip().size()==1
    										&&link.getPortZ().getBelongequipment().getPorts().size()==2){//一个设备A的两条复用段连的同一设备B，并且设备B只与A有复用段,还要继续优化（sjt 20130415）
    									tmpEquip = link.getPortZ().getBelongequipment();
        								equip = link.getPortA().getBelongequipment();	
    								}
    							}else{
    								if(link.getPortA().getBelongequipment().getTopoLinks().size()==2&&
    										link.getPortA().getBelongequipment().getListconnequip().size()==1&&
    										link.getPortA().getBelongequipment().getPorts().size()==2){
        								tmpEquip = link.getPortA().getBelongequipment();
        								equip =link.getPortZ().getBelongequipment();
    								}
    							}
    					}
    					if(tmpEquip!=null){ 
    						tmpEquip.setX(equip.getX());
    						tmpEquip.setY(equip.getY()+200);
//    						for (int j = 0; j < tmpEquip.getPorts().size(); j++) {
//    							if(tmpEquip.getPorts().get(j).getTopoLinkPort()!=null){
//    								tmpEquip.getPorts().get(j).getTopoLinkPort().setPosition(tmpEquip.getPorts().get(j).getTopoLinkPort().getPosition()==2?-3:3);
//    							}
//							}
    						if(tmpEquip.getPorts().get(0).getTopoLinkPort()!=null){
								tmpEquip.getPorts().get(0).getTopoLinkPort().setPosition(tmpEquip.getPorts().get(0).getPosition()>0?3:-3);//左右之分
								tmpEquip.getPorts().get(0).getTopoLinkPort().getCcLinkPort().setPosition(tmpEquip.getPorts().get(0).getPosition()>0?1:-1);
    						}
    						if(tmpEquip.getPorts().get(1).getTopoLinkPort()!=null){
    							tmpEquip.getPorts().get(1).getTopoLinkPort().setPosition(tmpEquip.getPorts().get(1).getPosition()<0?-3:3);
    							tmpEquip.getPorts().get(1).getTopoLinkPort().getCcLinkPort().setPosition(tmpEquip.getPorts().get(1).getPosition()>0?1:-1);
    						}
//    						tmpEquip.getPorts().get(1).getTopoLinkPort().getCcLinkPort().setPosition(position)
    						tmpEquip.setParentEquip(equip);//设置父设备
    						equip.setSonEquip(tmpEquip);//设置子设备
    						tmpEquip=null;
    						equip=null;
    					}
					}
    			}
    			System.out.println(string);
    			System.out.println(equipList.get(i).getEquipname());
    			
    		}else if(equipment.getPorts().size()==3){//3个端口
    			
    			for (ChannelPort port : equipment.getPorts()) {
    				if (port.getCcPortsList().size()==2) {
						if(port.getCcPortsList().get(0).getPosition()==1&&port.getCcPortsList().get(1).getPosition()==3||port.getCcPortsList().get(1).getPosition()==1&&port.getCcPortsList().get(0).getPosition()==3){
							port.setPosition(-2);
						}else if(port.getCcPortsList().get(0).getPosition()==-1&&port.getCcPortsList().get(1).getPosition()==-3||port.getCcPortsList().get(1).getPosition()==-1&&port.getCcPortsList().get(0).getPosition()==-3){
							port.setPosition(2);
						}
					}
				}
    		}
    	}
    	/**
    	 * 修改设备坐标 目前只考虑了最简单的情况
    	 */
    	 List<ChannelEquipment> tmpList = null;
    	 tmpEquips = new ArrayList<ChannelEquipment>();
//    	  tmpEquips.addAll(equipList);
    	  ChannelPort tmPort=null;//临时端口
    	  ChannelEquipment tmEquip = null;//临时设备，用来修改坐标
    	  int tmpIntY = 0;//设置临时偏移量
    	 ChannelEquipment equipmentXY=null;//用来定义偏移量标准的设备
         if (equipList.size() > 0) 
         {           
             channelequipment = startPort.getBelongequipment();//起始设备
             channelequipment.setX(x);
             channelequipment.setY(y);
             tmpList = new ArrayList<ChannelEquipment>();
             tmpList.add(channelequipment);
             for (int i = 0; i < tmpList.size(); i++) {
            	 channelequipment = tmpList.get(i);
            	 tmpEquips.add(channelequipment);
            	 int portsNum=0;//起始端口分散的个数
            	 if(channelequipment.getPorts().size()>0){
            		 if (channelequipment.getPorts().size()>=2) {
            			 Collections.sort(channelequipment.getPorts(), new ComparatorPort());
                		 //该处应把channelequipment.getPorts()数据排序（按照端口的Postion）。
					}
            		 List<ChannelEquipment> ls = new ArrayList<ChannelEquipment>();
            		 for (int m = 0; m < channelequipment.getPorts().size(); m++) {
            			 	tmPort = channelequipment.getPorts().get(m);
            			 	
            			 if(tmPort.getTopoLinkPort()!=null&&channelequipment.getPorts().size()>=3){
            				 portsNum++;
            				 ls.add(tmPort.getTopoLinkPort().getBelongequipment());
            			 }
					}
            		 if(portsNum==2){
            			 if(ls.get(0).equals(ls.get(1))){//判断这两个复用段所连接的设备是不是同一设备
            				 portsNum=0;
            			 }
            		 }else if(portsNum==4){
            			 ChannelEquipment eq=ls.get(0);
            			 int mm=0;
            			 for (int j = 0; j < portsNum; j++) {
							if(!ls.get(j).equals(eq)){
								mm++;
							}
						}
            			 portsNum = mm;
            		 }
//            			 else if(portsNum==3){
//            			 int mm=0;
//            			 for (ChannelEquipment channelEquipment : ls) {
//            				 int mmm=0;
//            				 for (int j = 0; j < portsNum; j++) {
//     							if(!ls.get(j).equals(channelEquipment)){
//     								mmm++;
//     							}
//     							if(mmm==2){
//     								if(isExist(channelEquipment)){
//     									portsNum=0;
//     								}
//     							}
//     						}	
//						}
//            		 }
            		 for (int s = 0; s < channelequipment.getPorts().size(); s++) {
            			 tmPort = channelequipment.getPorts().get(s);
            			 if(portsNum<=1){//只有一个复用段口
            				 if(tmPort.getTopoLinkPort()!=null){
                    				 tmEquip = tmPort.getTopoLinkPort().getBelongequipment();
                        			 if(!isExist(tmEquip)&&tmEquip.getParentEquip()==null){//正常的
                        				 tmEquip.setX(channelequipment.getX()+dx);
                            			 tmEquip.setY(channelequipment.getY());
                            			 tmpEquips.add(tmEquip);
                            			 tmpList.add(tmEquip);
                        			 }else if(!isExist(tmEquip)&&tmEquip.getParentEquip()!=null){//一个设备作为一个环的时候
                        				 tmEquip.setX(tmEquip.getParentEquip().getX());
                        				 tmEquip.setY(tmEquip.getParentEquip().getY()+200);
                        				 tmpEquips.add(tmEquip);
                            			 tmpList.add(tmEquip);
                        			 }
                    		 }
            			 }else if(portsNum>=2){//2个复用段端口
//            				 equipmentXY = channelequipment;
            				 if(tmPort.getTopoLinkPort()!=null){
            					 tmEquip = tmPort.getTopoLinkPort().getBelongequipment();
            					 if(Math.abs(tmPort.getPosition())==1){
            						 tmpIntY = 0;
            					 }else if(Math.abs(tmPort.getPosition())==3){
            						 tmpIntY = 350;
            					 }else{
            						 tmpIntY=0;
            					 }
            						  
            						 if(!isExist(tmEquip)&&tmEquip.getParentEquip()==null){//正常的
                        				 tmEquip.setX(channelequipment.getX()+dx);
                            			 tmEquip.setY(channelequipment.getY()+tmpIntY);
                            			 tmpEquips.add(tmEquip);
                            			 tmpList.add(tmEquip);
                        			 }else if(!isExist(tmEquip)&&tmEquip.getParentEquip()!=null){//一个设备作为一个环的时候
                        				 tmEquip.setX(tmEquip.getParentEquip().getX());
                        				 tmEquip.setY(tmEquip.getParentEquip().getY()+200);
                        				 tmpEquips.add(tmEquip);
                            			 tmpList.add(tmEquip);
                        			 }
            					 
            					 
            				 }
            			 }
					}
            		 portsNum=0;
            	 }
             }
             reComputeEndEquipPostion();// 重新计算支路口终点设备的坐标
             
             tmpEquips = new ArrayList<ChannelEquipment>();
             for (int o = 0; o < equipList.size(); o++) {
            	 equip = equipList.get(o);
            	 for (int oo = 0; oo < equipList.size(); oo++) {
					if(!equip.equals(equipList.get(oo))){ 
						if(equip.getX() ==equipList.get(oo).getX()&&equip.getY()==equipList.get(oo).getY()){
							System.out.println(equip.getEquipname()+"!!!!!!!!!!!!!!!!!"+equipList.get(oo).getEquipname());
							if(!isExist(equip))
							tmpEquips.add(equip);
						}
					}
				}
			}
             if(tmpEquips.size()!=0){
            	 equip = new ChannelEquipment();
            	 for (ChannelEquipment equipmet_ : tmpEquips) {
            		 for (ChannelPort port_ : equipmet_.getPorts()) {
						if(port_.getPosition()>0){
								if(!isExist(port_.getTopoLinkPort().getBelongequipment())){
									System.out.println("找到了"+port_.getBelongequipment().getEquipname());
									equip = port_.getBelongequipment();
								}
						}
					}
				} 
            	 if(equip.getEquipname()!=null){
            		 List<ChannelEquipment> tmpList2 =new ArrayList<ChannelEquipment>() ;
            		 tmpList2.add(equip);
            		 changeEquipsPoint(tmpEquips,tmpList2);
            		 
            	 }
             }
         }
    }
    /**
     * 重新计算设备坐标
     *@2013-4-16
     *@author jtsun
     * @param tmpList 需要重新计算坐标的设备集合
     * @param tmpList2 临时作为起点的设备
     */
    private void changeEquipsPoint(List<ChannelEquipment> tmpList,List<ChannelEquipment> tmpList2){
//    	 tmpEquips = new ArrayList<ChannelEquipment>();
    	 int tmpIntY=0;
    	 ChannelEquipment tmEquip = new ChannelEquipment();
    	 ChannelPort tmPort = new ChannelPort();
        for (int i = 0; i < tmpList2.size(); i++) {
       	 channelequipment = tmpList2.get(i);
       		 //tmpList.get(i);
       		 
//       	 tmpEquips.add(channelequipment);
       	 int portsNum=0;//起始端口分散的个数
       	 if(channelequipment.getPorts().size()>0){
       		 List<ChannelEquipment> ls = new ArrayList<ChannelEquipment>();
       		 for (int m = 0; m < channelequipment.getPorts().size(); m++) {
       			 	tmPort = channelequipment.getPorts().get(m);
       			 	
       			 if(tmPort.getTopoLinkPort()!=null&&channelequipment.getPorts().size()>=3){
       				 portsNum++;
       				 ls.add(tmPort.getTopoLinkPort().getBelongequipment());
       			 }
				}
       		 if(portsNum==2){
       			 if(ls.get(0).equals(ls.get(1))){//判断这两个复用段所连接的设备是不是同一设备
       				 portsNum=0;
       			 }
       		 }else if(portsNum==4){
       			 ChannelEquipment eq=ls.get(0);
       			 int mm=0;
       			 for (int j = 0; j < portsNum; j++) {
						if(!ls.get(j).equals(eq)){
							mm++;
						}
					}
       			 portsNum = mm;
       		 }
       		 for (int s = 0; s < channelequipment.getPorts().size(); s++) {
       			 tmPort = channelequipment.getPorts().get(s);
       			 if(portsNum<=1){//只有一个复用段口
       				 if(tmPort.getTopoLinkPort()!=null){
               				 tmEquip = tmPort.getTopoLinkPort().getBelongequipment();
                   			 if(isExist(tmEquip)&&tmEquip.getParentEquip()==null&&!isExist(tmpList2,tmEquip)){//正常的
                   				 tmEquip.setX(channelequipment.getX()+dx);
                       			 tmEquip.setY(channelequipment.getY());
//                       			 tmpEquips.add(tmEquip);
                       			 tmpList2.add(tmEquip);
                   			 }else if(isExist(tmEquip)&&tmEquip.getParentEquip()!=null&&!isExist(tmpList2,tmEquip)){//一个设备作为一个环的时候
                   				 tmEquip.setX(tmEquip.getParentEquip().getX());
                   				 tmEquip.setY(tmEquip.getParentEquip().getY()+200);
//                   				 tmpEquips.add(tmEquip);
                       			 tmpList2.add(tmEquip);
                   			 }
               		 }
       			 }else if(portsNum>=2){//2个复用段端口
       				 if(tmPort.getTopoLinkPort()!=null){
       					 tmEquip = tmPort.getTopoLinkPort().getBelongequipment();
       					 if(Math.abs(tmPort.getPosition())==1){
       						 tmpIntY = 0;
       					 }else if(Math.abs(tmPort.getPosition())==3){
       						 tmpIntY = 350;
       					 }else{
       						 tmpIntY=0;
       					 }
       						 if(isExist(tmEquip)&&tmEquip.getParentEquip()==null&&!isExist(tmpList2,tmEquip)){//正常的
                   				 tmEquip.setX(channelequipment.getX()+dx);
                       			 tmEquip.setY(channelequipment.getY()+tmpIntY);
//                       			 tmpEquips.add(tmEquip);
//                       			 tmpList.add(tmEquip);
                   			 }else if(isExist(tmEquip)&&tmEquip.getParentEquip()!=null&&!isExist(tmpList2,tmEquip)){//一个设备作为一个环的时候
                   				 tmEquip.setX(tmEquip.getParentEquip().getX());
                   				 tmEquip.setY(tmEquip.getParentEquip().getY()+200);
//                   				 tmpEquips.add(tmEquip);
//                       			 tmpList.add(tmEquip);
                   			 }
       				 }
       			 }
				}
       		 portsNum=0;
       	 }
        }
    }
    private boolean isExist(ChannelEquipment channelEquipment){
    	for (int i = 0; i < tmpEquips.size(); i++) {
			if(channelEquipment.equals(tmpEquips.get(i))){
				return true;
			}
		}
    	return false;
    }
    
    private boolean isExist(List<ChannelEquipment> channelEquipments,ChannelEquipment channelEquipment){
    	for (int i = 0; i < channelEquipments.size(); i++) {
			if(channelEquipment.equals(channelEquipments.get(i))){
				return true;
			}
		}
    	return false;
    }
    private void changPortsEquipsPoint(){

    	String string="";
    	/**
    	 * 修改端口用的临时设备父设备
    	 */
    	ChannelEquipment tmpEquip =null;
    	/**
    	 * 修改端口用的临时设备子设备
    	 */
    	ChannelEquipment equip =null;
    	/**
    	 * 修改端口重叠
    	 */
    	for(int i=0;i<equipList.size();i++){
    		ChannelEquipment equipment =equipList.get(i); 
    		if(equipment.getPorts().size()>3){
    			if(equipment.getTopoLinks().size()==4){
    				for (int k = 0; k < equipment.getTopoLinks().size(); k++) {
    					ChannelLink link = equipment.getTopoLinks().get(k);
    					if(link.getPortA().getBelongequipment().getEquipcode()==equipment.getEquipcode()||link.getPortZ().getBelongequipment().getEquipcode()==equipment.getEquipcode()){
    							if(link.getPortA().getBelongequipment().getEquipcode()==equipment.getEquipcode()){
    								if(link.getPortZ().getBelongequipment().getTopoLinks().size()==2&&
    										link.getPortZ().getBelongequipment().getListconnequip().size()==1
    										&&link.getPortZ().getBelongequipment().getPorts().size()==2){//一个设备A的两条复用段连的同一设备B，并且设备B只与A有复用段,还要继续优化（sjt 20130415）
    									tmpEquip = link.getPortZ().getBelongequipment();
        								equip = link.getPortA().getBelongequipment();	
    								}
    							}else{
    								if(link.getPortA().getBelongequipment().getTopoLinks().size()==2&&
    										link.getPortA().getBelongequipment().getListconnequip().size()==1&&
    										link.getPortA().getBelongequipment().getPorts().size()==2){
        								tmpEquip = link.getPortA().getBelongequipment();
        								equip =link.getPortZ().getBelongequipment();
    								}
    							}
    					}
    					if(tmpEquip!=null){ 
    						tmpEquip.setX(equip.getX());
    						tmpEquip.setY(equip.getY()+200);
    						if(tmpEquip.getPorts().get(0).getTopoLinkPort()!=null){
								tmpEquip.getPorts().get(0).getTopoLinkPort().setPosition(tmpEquip.getPorts().get(0).getPosition()>0?3:-3);//左右之分
								tmpEquip.getPorts().get(0).getTopoLinkPort().getCcLinkPort().setPosition(tmpEquip.getPorts().get(0).getPosition()>0?1:-1);
    						}
    						if(tmpEquip.getPorts().get(1).getTopoLinkPort()!=null){
    							tmpEquip.getPorts().get(1).getTopoLinkPort().setPosition(tmpEquip.getPorts().get(1).getPosition()<0?-3:3);
    							tmpEquip.getPorts().get(1).getTopoLinkPort().getCcLinkPort().setPosition(tmpEquip.getPorts().get(1).getPosition()>0?1:-1);
    						}
    						tmpEquip.setParentEquip(equip);//设置父设备
    						equip.setSonEquip(tmpEquip);//设置子设备
    						tmpEquip=null;
    						equip=null;
    					}
					}
    			}
    		}else if(equipment.getPorts().size()==3){//3个端口
    			for (ChannelPort port : equipment.getPorts()) {
    				if (port.getCcPortsList().size()==2) {
						if(port.getCcPortsList().get(0).getPosition()==1&&port.getCcPortsList().get(1).getPosition()==3||port.getCcPortsList().get(1).getPosition()==1&&port.getCcPortsList().get(0).getPosition()==3){
							port.setPosition(-2);
						}else if(port.getCcPortsList().get(0).getPosition()==-1&&port.getCcPortsList().get(1).getPosition()==-3||port.getCcPortsList().get(1).getPosition()==-1&&port.getCcPortsList().get(0).getPosition()==-3){
							port.setPosition(2);
						}
					}
				}
    		}
    	}
    	/**
    	 * 修改设备坐标 目前只考虑了最简单的情况
    	 */
    	 List<ChannelEquipment> tmpList = null;
    	 tmpEquips = new ArrayList<ChannelEquipment>();
//    	  tmpEquips.addAll(equipList);
    	  ChannelPort tmPort=null;//临时端口
    	  ChannelEquipment tmEquip = null;//临时设备，用来修改坐标
    	  int tmpIntY = 0;//设置临时偏移量
    	 ChannelEquipment equipmentXY=null;//用来定义偏移量标准的设备
         if (equipList.size() > 0) 
         {           
             channelequipment = startPort.getBelongequipment();//起始设备
             channelequipment.setX(x);
             channelequipment.setY(y);
             tmpEquips.add(channelequipment);
             tmpList = new ArrayList<ChannelEquipment>();
             tmpList.add(channelequipment);
             //重新开始串接电路方法
             ChannelPort port_start = new ChannelPort();//第一端口(连接下一设备复用段)
             List<ChannelPort> finishPortsList = new ArrayList<ChannelPort>();//串完电路端口集合
             List<ChannelPort> startPortsList = new ArrayList<ChannelPort>();//待串电路端口集合
             List<ChannelPort> tmpPortsList = new ArrayList<ChannelPort>();//未串接的端口集合
//             if(channelequipment.getPorts().size()>2){//端口多，复用段多
             for(ChannelPort port:channelequipment.getPorts()){//遍历起始设备的端口
            	 if(port.getTopoLinkPort()!=null&&Math.abs(port.getPosition())==1){//如果端口有复用段并且端口在上方
            		 port_start = port;
            		 finishPortsList.add(port_start);
            	 }else if(port.getTopoLinkPort()!=null&&Math.abs(port.getPosition())==3){//作为待遍历端口
            		 tmpPortsList.add(port);
            	 }else if(port.getTopoLinkPort()!=null&&Math.abs(port.getPosition())==2){
            		 port_start = port;
            		 finishPortsList.add(port_start);
            	 }
             }
             for(int i=0;i<finishPortsList.size();i++){
            	 port_start = finishPortsList.get(i);
            	  if(port_start.getBelongequipment()!=null){//开始
                 	 channelequipment = port_start.getBelongequipment();
                 	 if(port_start.getTopoLinkPort()!=null){
                 		tmEquip=port_start.getTopoLinkPort().getBelongequipment();
                    	 if(!isExist(tmEquip)){
                    		tmEquip.setX(channelequipment.getX()+dx);
               			tmEquip.setY(channelequipment.getY());
               			tmpEquips.add(tmEquip);	 
                    	 }
                    	 
            			 if(tmEquip.getPorts().size()<3){//设备端口小于3个即1或者2
            				 if(port_start.getTopoLinkPort().getCcLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().isIsbranch()==false){
            					 finishPortsList.add(port_start.getTopoLinkPort().getCcLinkPort());
            				 }
            			 }else if(tmEquip.getPorts().size()>3){//多种情况，分析：一、设备自环1.分1个设备2.分2个设备 ；二、分道扬镳
            				 if(port_start.getTopoLinkPort().getCcLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().isIsbranch()==false){
            					 //有为空错误
            					 if(port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort().getTopoLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getBelongequipment().equals(port_start.getTopoLinkPort().getBelongequipment())){
            						 	//说名是一个设备的设备自环形态
            						port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getBelongequipment().setY(port_start.getTopoLinkPort().getBelongequipment().getY()+200);
            						finishPortsList.add(port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort());
            					 }
//            					 finishPortsList.add(port_start.getTopoLinkPort().getCcLinkPort());
            				 }
            			 }
                 	 }
                 	 
                  }
             }
             if(tmpPortsList.size()>0){
            	 port_start = tmpPortsList.get(0);
            	 tmEquip= port_start.getTopoLinkPort().getBelongequipment();
            	 channelequipment = port_start.getBelongequipment();
            	 if(!isExist(tmEquip)){
            	 tmEquip.setX(channelequipment.getX()+dx);
      			 tmEquip.setY(channelequipment.getY()+100);
      			 tmpEquips.add(tmEquip);
            	 }
      			 if(port_start.getTopoLinkPort().getCcLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().isIsbranch()==false)
      				 tmpPortsList.add(port_start.getTopoLinkPort().getCcLinkPort());
             }
             for(int i=1;i<tmpPortsList.size();i++){
            	 port_start = tmpPortsList.get(i);
            	  if(port_start.getBelongequipment()!=null){//开始
                  	 channelequipment = port_start.getBelongequipment();
                  	 if(port_start.getTopoLinkPort()!=null){
                  		tmEquip=port_start.getTopoLinkPort().getBelongequipment();
                  	 }
                  	if(!isExist(tmEquip)){
                  	 tmEquip.setX(channelequipment.getX()+dx);
          			 tmEquip.setY(channelequipment.getY());
          			 tmpEquips.add(tmEquip);
                  	}
          			 if(tmEquip.getPorts().size()<3){//设备端口小于3个即1或者2
          				 if(port_start.getTopoLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().isIsbranch()==false){
          					tmpPortsList.add(port_start.getTopoLinkPort().getCcLinkPort());
          				 }
          			 }else if(tmEquip.getPorts().size()>3){//多种情况，分析：一、设备自环1.分1个设备2.分2个设备 ；二、分道扬镳
         				 if(port_start.getTopoLinkPort().getCcLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().isIsbranch()==false){
         					 if(port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort().getTopoLinkPort()!=null&&port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getBelongequipment()!=null&&port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getBelongequipment().equals(port_start.getTopoLinkPort().getBelongequipment())){
         						 	//说名是一个设备的设备自环形态
         						port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getBelongequipment().setY(port_start.getTopoLinkPort().getBelongequipment().getY()+200);
         						tmpPortsList.add(port_start.getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort().getTopoLinkPort().getCcLinkPort());
         					 }
//         					 finishPortsList.add(port_start.getTopoLinkPort().getCcLinkPort());
         				 }
         			 }
                   }
             }
//      }
             
//             for (int i = 0; i < tmpList.size(); i++) {
//            	 channelequipment = tmpList.get(i);
//            	 tmpEquips.add(channelequipment);
//            	 int portsNum=0;//起始端口分散的个数
//            	 if(channelequipment.getPorts().size()>0){
//            		 if (channelequipment.getPorts().size()>=2) {
//            			 Collections.sort(channelequipment.getPorts(), new ComparatorPort());
//                		 //该处应把channelequipment.getPorts()数据排序（按照端口的Postion）。
//					}
//            		 List<ChannelEquipment> ls = new ArrayList<ChannelEquipment>();
//            		 for (int m = 0; m < channelequipment.getPorts().size(); m++) {
//            			 	tmPort = channelequipment.getPorts().get(m);
//            			 	
//            			 if(tmPort.getTopoLinkPort()!=null&&channelequipment.getPorts().size()>=3){
//            				 portsNum++;
//            				 ls.add(tmPort.getTopoLinkPort().getBelongequipment());
//            			 }
//					}
//            		 if(portsNum==2){
//            			 if(ls.get(0).equals(ls.get(1))){//判断这两个复用段所连接的设备是不是同一设备
//            				 portsNum=0;
//            			 }
//            		 }else if(portsNum==4){
//            			 ChannelEquipment eq=ls.get(0);
//            			 int mm=0;
//            			 for (int j = 0; j < portsNum; j++) {
//							if(!ls.get(j).equals(eq)){
//								mm++;
//							}
//						}
//            			 portsNum = mm;
//            		 }
//            		 for (int s = 0; s < channelequipment.getPorts().size(); s++) {
//            			 tmPort = channelequipment.getPorts().get(s);
//            			 if(portsNum<=1){//只有一个复用段口
//            				 if(tmPort.getTopoLinkPort()!=null){
//                    				 tmEquip = tmPort.getTopoLinkPort().getBelongequipment();
//                        			 if(!isExist(tmEquip)&&tmEquip.getParentEquip()==null){//正常的
//                        				 tmEquip.setX(channelequipment.getX()+dx);
//                            			 tmEquip.setY(channelequipment.getY());
//                            			 tmpEquips.add(tmEquip);
//                            			 tmpList.add(tmEquip);
//                        			 }else if(!isExist(tmEquip)&&tmEquip.getParentEquip()!=null){//一个设备作为一个环的时候
//                        				 tmEquip.setX(tmEquip.getParentEquip().getX());
//                        				 tmEquip.setY(tmEquip.getParentEquip().getY()+200);
//                        				 tmpEquips.add(tmEquip);
//                            			 tmpList.add(tmEquip);
//                        			 }
//                    		 }
//            			 }else if(portsNum>=2){//2个复用段端口
//            				 if(tmPort.getTopoLinkPort()!=null){
//            					 tmEquip = tmPort.getTopoLinkPort().getBelongequipment();
//            					 if(Math.abs(tmPort.getPosition())==1){
//            						 tmpIntY = 0;
//            					 }else if(Math.abs(tmPort.getPosition())==3){
//            						 tmpIntY = 350;
//            					 }else{
//            						 tmpIntY=0;
//            					 }
//            						 if(!isExist(tmEquip)&&tmEquip.getParentEquip()==null){//正常的
//                        				 tmEquip.setX(channelequipment.getX()+dx);
//                            			 tmEquip.setY(channelequipment.getY()+tmpIntY);
//                            			 tmpEquips.add(tmEquip);
//                            			 tmpList.add(tmEquip);
//                        			 }else if(!isExist(tmEquip)&&tmEquip.getParentEquip()!=null){//一个设备作为一个环的时候
//                        				 tmEquip.setX(tmEquip.getParentEquip().getX());
//                        				 tmEquip.setY(tmEquip.getParentEquip().getY()+200);
//                        				 tmpEquips.add(tmEquip);
//                            			 tmpList.add(tmEquip);
//                        			 }
//            				 }
//            			 }
//					}
//            		 portsNum=0;
//            	 }
//             }
             
             
             reComputeEndEquipPostion();// 重新计算支路口终点设备的坐标
//             tmpEquips = new ArrayList<ChannelEquipment>();
//             for (int o = 0; o < equipList.size(); o++) {
//            	 equip = equipList.get(o);
//            	 for (int oo = 0; oo < equipList.size(); oo++) {
//					if(!equip.equals(equipList.get(oo))){ 
//						if(equip.getX() ==equipList.get(oo).getX()&&equip.getY()==equipList.get(oo).getY()){
//							System.out.println(equip.getEquipname()+"!!!!!!!!!!!!!!!!!"+equipList.get(oo).getEquipname());
//							if(!isExist(equip))
//							tmpEquips.add(equip);
//						}
//					}
//				}
//			}
//             if(tmpEquips.size()!=0){
//            	 equip = new ChannelEquipment();
//            	 for (ChannelEquipment equipmet_ : tmpEquips) {
//            		 for (ChannelPort port_ : equipmet_.getPorts()) {
//						if(port_.getPosition()>0){
//								if(!isExist(port_.getTopoLinkPort().getBelongequipment())){
//									System.out.println("找到了"+port_.getBelongequipment().getEquipname());
//									equip = port_.getBelongequipment();
//								}
//						}
//					}
//				} 
//            	 if(equip.getEquipname()!=null){
//            		 List<ChannelEquipment> tmpList2 =new ArrayList<ChannelEquipment>() ;
//            		 tmpList2.add(equip);
//            		 changeEquipsPoint(tmpEquips,tmpList2);
//            	 }
//             }
         }
    }
    
    
    
    public String getXmlFor10M(boolean isRefresh) {
        String xml = "";
        // 生成设备xml
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
        layer = new Layer("titleName");
        layer.setVisible(true);
        layer.setEditable(false);
        layer.setMovable(false);
        layer.setName("titleName");
        
        box.getLayerBox().add(layer);
        
        SerializationSettings.registerGlobalClient("flag", Consts.TYPE_STRING);//值为equipment，port，cc，分别标志为元素为设备，端口，交叉
		SerializationSettings.registerGlobalClient("isbranch", Consts.TYPE_STRING);//
		SerializationSettings.registerGlobalClient("position", Consts.TYPE_STRING);//保存端口的位置
		SerializationSettings.registerGlobalClient("equipcode", Consts.TYPE_STRING);//设备编号
		SerializationSettings.registerGlobalClient("portcode", Consts.TYPE_STRING);//端口编号
		SerializationSettings.registerGlobalClient("topoid", Consts.TYPE_STRING);//复用段编号
		SerializationSettings.registerGlobalClient("portlabel", Consts.TYPE_STRING);//端口的标签
		SerializationSettings.registerGlobalClient("timeslot", Consts.TYPE_STRING);//时隙
		SerializationSettings.registerGlobalClient("timeslot373", Consts.TYPE_STRING);//373格式时隙
		SerializationSettings.registerGlobalClient("systemcode", Consts.TYPE_STRING);//系统编码
		SerializationSettings.registerGlobalClient("rate", Consts.TYPE_STRING);//速率
		String systemcodegroup="";
        if (equipList.size() > 0) 
        {
            for (int i = 0; i < equipList.size(); i++) 
            {
                ChannelEquipment equipment = equipList.get(i);
                
                double x = 0;
                double y =0;
                String equipment_image=equipImage;
                if(equipment.getIsvirtual()!=null&&!equipment.getIsvirtual().equalsIgnoreCase("")&&!equipment.getIsvirtual().equalsIgnoreCase("null")){
                	
                	equipment_image=virtualEquipImage;
                }
                
                
                if(equipment.getSystemcode()!=null&&!systemcodegroup.contains(equipment.getSystemcode()))
                {
                    systemcodegroup += equipment.getSystemcode()+"$$";
                    Group group = new Group(equipment.getSystemcode());
                    group.setStyle(Styles.TREE_LABEL, "group");
    				 group.setExpanded(true);
    				 group.setImage("twaverImages/channelroute/cloud.png");
    				 group.setName(equipment.getSystemcode());
    				 group.setWidth(130);
    				 group.setHeight(90);
    				 group.setStyle(Styles.OUTER_ALPHA, 0.01);
    				 group.setStyle(Styles.GROUP_OUTLINE_ALPHA,0.01);
    				 
    				 group.setStyle(Styles.GROUP_SHAPE, Consts.SHAPE_ROUNDRECT);
    				 group.setStyle(Styles.GROUP_GRADIENT, Consts.GRADIENT_RADIAL_NORTHEAST);
    				 group.setStyle(Styles.GROUP_FILL_ALPHA, 0.01);
    				 group.setStyle(Styles.GROUP_GRADIENT_ALPHA, 0.01);
    				 
    				 group.setStyle(Styles.GROUP_PADDING, 10);
    				 group.setStyle(Styles.VECTOR_SHAPE, Consts.SHAPE_OVAL);
    				 group.setStyle(Styles.VECTOR_GRADIENT, Consts.GRADIENT_RADIAL_NORTHEAST);
    				 box.add(group);
                }
                
                Node node = new Node(equipment.getEquipcode());
                node.setName("");
                node.setImage(equipment_image);
                node.setLocation(equipment.getX(), equipment.getY());
                node.setWidth(equip_Width);
                node.setHeight(equip_Height);
                node.setLayerID("equipment");
                node.setClient("flag","equipment");
                node.setClient("isbranch",equipment.isIsbranchequip());
                node.setClient("equipcode",equipment.getEquipcode());
                node.setParent(box.getElementByID(equipment.getSystemcode()));
                node.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
                box.add(node);
                //添加设备的名称伴随节点(follower)
        		x = equipment.getX()+label_x;
        		y = equipment.getY()-equip_Height/2-label_Height;
        		Follower follower = new Follower(equipment.getEquipcode()+name_ID);
        		follower.setName(equipment.getEquipname());
        		follower.setParent(node);
        		follower.setStyle(Styles.LABEL_SIZE, 12);
        		follower.setImage(null);
        		follower.setWidth(0);
        		follower.setHeight(0);
        		follower.setLayerID("port1");
        		follower.setHost(node);        		
        		follower.setLocation(x,y);	
        		box.add(follower);
        		
        		//添加设备的型号的伴随节点(follower)
        		y = equipment.getY()+equip_Height/2;        		
        		follower = new Follower(equipment.getEquipcode()+model_ID);
        		follower.setName(equipment.getXmodel());
        		follower.setStyle(Styles.LABEL_SIZE, 13);
        		follower.setParent(box.getDataByID(equipment.getEquipcode()));
        		follower.setImage(null);
        		follower.setWidth(0);
        		follower.setHeight(0);
        		follower.setLayerID("port1");
        		follower.setHost(node);
        		follower.setLocation(x,y);
        		box.add(follower);
            }
        } 
        // 生成端口xml
        if (portlist.size() > 0)
        {
        	String portgroup = "";
            for (int i = 0; i < portlist.size(); i++) 
            {
                ChannelPort port =  portlist.get(i);
                if(!portgroup.contains(port.getPort()))
                {
                	if (!isRefresh) 
                	{
                		double x = port.getBelongequipment().getX();
                		double y =port.getBelongequipment().getY();
	                	for(int j=0;j<equipList.size();j++)
	                	{
	                		ChannelEquipment equipment = equipList.get(j);
	                		if(equipment.getEquipcode().equalsIgnoreCase(port.getBelongequipment().getEquipcode())){
	                			x = equipment.getX();
	                			y = equipment.getY();
	                		}
	                	}
	                    if (port.getPosition() > 0) 
	                    {
	                        port.setX(port_x[0]+x);
	                        port.setY(port_y[port.getPosition() - 1]+y);
	                    }
	                    else 
	                    {
	                        port.setX(port_x[1]+x);
	                        if (port.getPosition() != 0)
	                        {
	                        	 port.setY(port_y[-port.getPosition() - 1]+y);
	                        }	                           
	                        else
	                        {
	                        	port.setY(port_y[1]+y);
	                        }
	                    }
                	}
	                String img =portImage;
	                if (port.isIsbranch()) 
	                {
	                    img = branchPortImage;
	                }  
                
	                Follower follower = new Follower(port.getPort());
					
	        		follower.setName(port.getPortlabel());
	        		follower.setParent(box.getDataByID(port.getBelongequipment().getEquipcode()).getParent());
	        		follower.setStyle(Styles.LABEL_SIZE, 9);
	        		follower.setImage(img);
	        		follower.setWidth(port_Width);
	        		follower.setHeight(port_Height);
	        		follower.setLayerID("port");
	        		follower.setHost((Node)box.getDataByID(port.getBelongequipment().getEquipcode()));
	        		follower.setLocation(port.getX(),port.getY());
	        		follower.setClient("flag", "port");
	        		follower.setClient("position", String.valueOf(port.getPosition()));
	        		String f_portcode = "";
	        		if (circuitRate != null
							&& circuitRate.equalsIgnoreCase("VC4"))
						f_portcode = port.getPort() + ","
								+ port.getReal_slot();
					else
						f_portcode = port.getPort() + "," + port.getSlot();
	        		follower.setClient("portcode", f_portcode);
	        		follower.setClient("isbranch", port.isIsbranch());
	        		String toolTip = port.getPortdetail()!=null?port.getPortdetail():"";
	        		follower.setToolTip(toolTip);
	        		String portshow = port.getPortshow()!=null?port.getPortshow():"";
	        		follower.setClient("portlabel", portshow);
	        		
	                box.add(follower);
                }
                portgroup += port.getPort()+",";
            }
        }
        // 生成复用段,交叉
        if (portlist.size() > 0) {
        	String groupFlag = "";// 判断该条交叉或复用段是否已经生成过xml
        	String linkGroup = ""; 
            for (int i = 0; i < portlist.size(); i++) {
                ChannelPort portchannel = (ChannelPort) portlist.get(i);
                List<ChannelPort> tmpList = portchannel.getConnectport();
                if (tmpList != null && tmpList.size() > 0) {
                    for (int j = 0; j < tmpList.size(); j++) {
                        ChannelPort channeltopo = (ChannelPort) tmpList.get(j);
                        String systemcode = "";
                        boolean T = false;
					    if (!groupFlag.contains(portchannel
									.getPort()
									+ ","
									+ portchannel.getSlot()
									+ "#"
									+ channeltopo.getPort()
									+ ","
									+ channeltopo.getSlot())
									&& !groupFlag.contains(channeltopo
											.getPort()
											+ ","
											+ channeltopo.getSlot()
											+ "#"
											+ portchannel.getPort()
											+ ","
											+ portchannel.getSlot())) {
								T = true;
							}
                        if (T) {
                            systemcode = "";
                            boolean arrowfrom = false;
                            boolean arrowto = false;
                            if (portchannel.getBelongequipment().getEquipcode()
                                    .equalsIgnoreCase(
                                            channeltopo.getBelongequipment()
                                                    .getEquipcode())) {
                                if (channeltopo.getDirection() != null) {
                                    if (channeltopo.getDirection()
                                            .equalsIgnoreCase("BI")
                                            || channeltopo.getDirection()
                                            .equalsIgnoreCase("-BI")) {
                                        arrowfrom = true;
                                        arrowto = true;
                                    }

                                    if (channeltopo.getDirection()
                                            .equalsIgnoreCase("-UNI")) {
                                        arrowfrom = true;
                                    }
                                    if (channeltopo.getDirection()
                                            .equalsIgnoreCase("UNI")) {
                                        arrowto = true;
                                    }
                                }
                            } else {
                                if (channeltopo.getSystemcode() != null)
                                    systemcode = channeltopo.getSystemcode();
                                else
                                    systemcode = portchannel.getSystemcode();
                            }
                            String slot = "";
                            String slotno373="";
                            if ((channeltopo.isIstopo() || portchannel.isIstopo()) && systemcode != null && !systemcode.equalsIgnoreCase(""))
                            {
                            	if (circuitRate != null
										&& circuitRate
												.equalsIgnoreCase("VC4")) 
                            	{
									slot = portchannel.getReal_slot();
								}
                            	else
                            	{
									slot = portchannel.getSlot();
									if (portchannel.getCrate() != null
											&& portchannel.getCrate()
													.equalsIgnoreCase(
															"VC4")) 
									{
										slot = String
												.valueOf((Integer
														.valueOf(portchannel
																.getReal_slot()) - 1)
														* 63
														+ portchannel
																.getDslot());
									} 
									else
									{
										slot = portchannel.getSlot();
									}
									slotno373 = slot;
									slot = To373(slot);
								}
								slot = "\n" + slot + "";
                            }
                            int strokeWidth = 2;
                            int arrowWidth = 9;
                            if (portchannel.getBelongequipment().getEquipcode().equalsIgnoreCase(channeltopo.getBelongequipment().getEquipcode())) 
                            {//为内部交叉
                                if (rate.equalsIgnoreCase("VC12"))
                                {
                                    if (!portchannel.getCrate().equalsIgnoreCase(rate)) 
                                    {
                                    	strokeWidth = 3;
                                        arrowWidth = 12;
                                    }
                                }
                            }
                            String topoid = "cc";
                            if (channeltopo.getTopoid() != null && !channeltopo.getTopoid().equalsIgnoreCase("")&&!channeltopo.getBelongequipment().getEquipcode().equalsIgnoreCase(portchannel.getBelongequipment().getEquipcode()))
                            {//为复用段
                                topoid = channeltopo.getTopoid();
                            }
                            boolean isJudge = true;
                            if(circuitRate!=null&&circuitRate.equalsIgnoreCase("64K")){
                            	isJudge = !topoid.equalsIgnoreCase("cc");
                            }
                            if(isJudge)
                            {
	                            if(!linkGroup.contains(portchannel.getPort()+"#"+channeltopo.getPort())&&!linkGroup.contains(channeltopo.getPort()+"#"+portchannel.getPort()))
	                            {
	                            	Link link;
	    							link = new Link(portchannel.getPort()
	    										+ '#' + channeltopo.getPort()
	    										);
	//    							link.setName(systemcode+slot);
	    							link.setName(slot);
	                                link.setStyle(Styles.ARROW_FROM, arrowfrom);
	                                link.setStyle(Styles.ARROW_TO, arrowto);
	                                link.setStyle(Styles.ARROW_FROM_HEIGHT, arrowWidth);
	                                link.setStyle(Styles.ARROW_TO_HEIGHT,arrowWidth);
	                                link.setStyle(Styles.LINK_WIDTH, strokeWidth);
	                                String color = "0x00CC00";
	//                                if(portchannel.getIslord()!=null&&!topoid.equalsIgnoreCase("cc"))
	//                                {
	//	                                if(portchannel.getIslord().equalsIgnoreCase("1")){
	//	                                	color="0x00A0E9 ";
	//	                                }else if(portchannel.getIslord().equalsIgnoreCase("0")){
	//	                                	color="0x6A5F92";
	//	                                }else{
	//	                                	color = "0x00CC00";
	//	                                }
	//                                }
	//                                if(channeltopo.getIslord()!=null&&!topoid.equalsIgnoreCase("cc")){
	//                                    if(channeltopo.getIslord().equalsIgnoreCase("1")){
	//                                    	color="0x00A0E9 ";
	//                                    }else if(channeltopo.getIslord().equalsIgnoreCase("0")){
	//                                    	color="0x6A5F92";
	//                                    }else{
	//                                    	color = "0x00CC00";
	//                                    }
	//                                    }
	                                color = "0x00CC00";
	                                link.setStyle(Styles.ARROW_FROM_COLOR, color);
	                                link.setStyle(Styles.ARROW_TO_COLOR, color);
	                              
	                                link.setStyle(Styles.LINK_COLOR, color);
	                                link.setStyle(Styles.LABEL_XOFFSET, -5);
	                                link.setStyle(Styles.LABEL_YOFFSET, -17);
	                                link.setLayerID("port");
	                                link.setStyle(Styles.LINK_BUNDLE_GAP, 30);
	                                if(!topoid.equalsIgnoreCase("cc"))
	                                	link.setClient("flag", "topolink");
	                                else
	                                    link.setClient("flag", "cc");
	                                Follower from;
	    							Follower to;
	    							from = (Follower) box
	    										.getDataByID(portchannel
	    												.getPort()
	    												);
	    							to = (Follower) box
	    										.getDataByID(channeltopo
	    												.getPort()
	    												);
	                                link.setFromNode(from);
	                                link.setToNode(to);
	                                link.setClient("topoid", topoid);
	                                
	                                if(!topoid.equalsIgnoreCase("cc"))//复用段
	                                {
	                                	if(link.getClient("timeslot")!=null)
	                                	{
	                                		link.setClient("timeslot", link.getClient("timeslot")+"\n"+slotno373);
	                                	}
	                                	else
	                                	{
	                                		link.setClient("timeslot", slotno373);
	                                	}
	                                	if(link.getClient("timeslot373")!=null)
	                                	{
	                                		link.setClient("timeslot373", link.getClient("timeslot373")+"\n"+slot);
	                                	}
	                                	else
	                                	{
	                                		link.setClient("timeslot373", slot);	
	                                	}
	                                    
	                                    link.setClient("systemcode", systemcode);
	                               }
	                               else
	                               {
	                            	   link.setClient("rate", portchannel.getCrate());	
	                               }
	                               box.add(link);
	                            }
	                            else
	                            {
	                            	Link link = (Link)box.getDataByID(portchannel.getPort()+"#"+channeltopo.getPort());
	                            	if(null == link)
	                            	{
	                            		link = (Link)box.getDataByID(channeltopo.getPort()+"#"+portchannel.getPort());
	                            	}
	                            	
	                            	if(null!=link)
	                            	{
	                            		slot = "";
	                                    slotno373="";
	                                    if ((channeltopo.isIstopo() || portchannel.isIstopo()))
	                                    {
        									slot = portchannel.getSlot();
        									slotno373 = slot;
        									slot = To373(slot);
        								}
	                                    
	                                    if(!"cc".equalsIgnoreCase((String)link.getClient("flag")))
	                                    {
	                                    	link.setName(link.getName()+"\n"+slot);
	                                    	if(link.getClient("timeslot")!=null)
	                                    	{
	                                    		link.setClient("timeslot", link.getClient("timeslot")+"\n"+slotno373);
	                                    	}
	                                    	else
	                                    	{
	                                    		link.setClient("timeslot", slotno373);
	                                    	}
	                                    	if(link.getClient("timeslot373")!=null)
	                                    	{
	                                    		link.setClient("timeslot373", link.getClient("timeslot373")+"\n"+slot);
	                                    	}
	                                    	else
	                                    	{
	                                    		link.setClient("timeslot373", slot);	
	                                    	}
                                    	}
	                            	}
	                            	
	                            }	
	                            linkGroup +=portchannel.getPort()+"#"+channeltopo.getPort()+"&";
								groupFlag += portchannel.getPort()
											+ "," + portchannel.getSlot()
											+ '#' + channeltopo.getPort()
											+ "," + channeltopo.getSlot()
											+ "&";
                          }
                        }
                    }
                 }
              }
           }
        
       
        xml = serializer.serialize();
		
        return xml;
    }
    
    
    
    
    
    
    
    
    public String getXmlNoDrawCC(String filename) {
        String xml = "";
        port_x = new double[]{-6, 86};

            /**
             * 端口相对设备的y坐标
             */
        port_y = new double[]{25.7, 48.85, 72};
//        String equipgroup = "";

        double dx = 22;
        double dy1 = 70.00;
        double dy2 = -7.00;
        // 生成设备xml
        int k=1;
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
        layer = new Layer("linklayer");
        layer.setVisible(true);
        layer.setEditable(true);
        layer.setMovable(true);
        layer.setName("linklayer");
        box.getLayerBox().add(layer);
        SerializationSettings.registerGlobalClient("flag", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("isbranch", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("position", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("equipcode", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("portcode", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("topoid", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("portlabel", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("timeslot", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("timeslot373", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("systemcode", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("rate", Consts.TYPE_STRING);
		String systemcodegroup="";
        if (equipList.size() > 0) {
            for (int i = 0; i < equipList.size(); i++) {
                ChannelEquipment equipment = (ChannelEquipment) equipList
                        .get(i);
                String a = "1";
                String b = "2";
                String c = "3";
                double x = 0;
                double y =0;
                String equipment_image="twaverImages/channelroute/luyou_bgnocc.png";
                if(equipment.getIsvirtual()!=null&&!equipment.getIsvirtual().equalsIgnoreCase("")&&!equipment.getIsvirtual().equalsIgnoreCase("null")){
                	equipment_image="twaverImages/channelroute/luyou_bgnocc.png";
                }
                if(equipment.getSystemcode()!=null&&!systemcodegroup.contains(equipment.getSystemcode())){
                    systemcodegroup += equipment.getSystemcode()+"$$";
                     Group group = new Group(equipment.getSystemcode());
                     group.setStyle(Styles.TREE_LABEL, "group");
    				 group.setExpanded(true);
    				 group.setImage("twaverImages/channelroute/cloud.png");
    				 group.setName(equipment.getSystemcode());
    				 group.setWidth(130);
    				 group.setHeight(90);
    				 group.setStyle(Styles.OUTER_ALPHA, 0.01);
    				 group.setStyle(Styles.GROUP_OUTLINE_ALPHA,0.01);
    				 group.setStyle(Styles.GROUP_SHAPE, Consts.SHAPE_ROUNDRECT);
    				 group.setStyle(Styles.GROUP_GRADIENT, Consts.GRADIENT_RADIAL_NORTHEAST);
    				 group.setStyle(Styles.GROUP_FILL_ALPHA, 0.01);
    				 group.setStyle(Styles.GROUP_GRADIENT_ALPHA, 0.01);
    				 group.setStyle(Styles.GROUP_PADDING, 10);
    				 group.setStyle(Styles.VECTOR_SHAPE, Consts.SHAPE_OVAL);
    				 group.setStyle(Styles.VECTOR_GRADIENT, Consts.GRADIENT_RADIAL_NORTHEAST);
    				 box.add(group);
                   }
                
                Node node = new Node(equipment.getEquipcode());
                node.setName("");
                node.setImage(equipment_image);
                node.setLocation(equipment.getX(), equipment.getY());
                node.setWidth(140);
                node.setHeight(140);
                node.setLayerID("equipment");
                node.setClient("flag","equipment");
                node.setClient("isbranch",equipment.isIsbranchequip());
                node.setClient("equipcode",equipment.getEquipcode());
                node.setParent(box.getElementByID(equipment.getSystemcode()));
                box.add(node);
        	    k++;  
        		x = equipment.getX()+dx;
        		y = equipment.getY()-dy1;
        		String name = equipment.getEquipname();
        		if(name!=null&&name.length()>6){
        			String name1 = name.substring(0,6);
        			String name2 = name.substring(6,name.length()-1);
        			Follower follower = new Follower(equipment.getEquipcode()+a);
            		follower.setName(name1);
            		follower.setParent(box.getDataByID(equipment.getEquipcode()));
            		follower.setStyle(Styles.LABEL_BOLD, true);
            		follower.setStyle(Styles.LABEL_COLOR, Consts.COLOR_WHITE);
            		follower.setStyle(Styles.LABEL_SIZE, 12);
            		follower.setImage(null);
            		follower.setWidth(0);
            		follower.setHeight(0);
            		follower.setLayerID("port1");
            		follower.setHost((Node)box.getDataByID(equipment.getEquipcode()));
            		follower.setLocation(x,y);
            		box.add(follower);
            		follower = new Follower(equipment.getEquipcode()+a+a);
            		follower.setName(name2);
            		follower.setParent(box.getDataByID(equipment.getEquipcode()));
            		follower.setStyle(Styles.LABEL_BOLD, true);
            		follower.setStyle(Styles.LABEL_COLOR, Consts.COLOR_WHITE);
            		follower.setStyle(Styles.LABEL_SIZE, 12);
            		follower.setImage(null);
            		follower.setWidth(0);
            		follower.setHeight(0);
            		follower.setLayerID("port1");
            		follower.setHost((Node)box.getDataByID(equipment.getEquipcode()));
            		follower.setLocation(x,y+10);
            		box.add(follower);
        		}else{
        		Follower follower = new Follower(equipment.getEquipcode()+a);
        		follower.setName(equipment.getEquipname());
        		follower.setParent(box.getDataByID(equipment.getEquipcode()));
        		follower.setStyle(Styles.LABEL_BOLD, true);
        		follower.setStyle(Styles.LABEL_COLOR, Consts.COLOR_WHITE);
        		follower.setStyle(Styles.LABEL_SIZE, 12);
        		follower.setImage(null);
        		follower.setWidth(0);
        		follower.setHeight(0);
        		follower.setLayerID("port1");
        		follower.setHost((Node)box.getDataByID(equipment.getEquipcode()));
        		follower.setLocation(x,y);
        		box.add(follower);
        		}
//        		String aa = "\n";
        		y = equipment.getY()-dy2;
        		k++;
        		Follower follower = new Follower(equipment.getEquipcode()+b);
        		follower.setName(equipment.getVendor());
        		follower.setStyle(Styles.LABEL_SIZE, 12);
        		follower.setStyle(Styles.LABEL_COLOR, Consts.COLOR_WHITE);
        		follower.setParent(box.getDataByID(equipment.getEquipcode()));
        		follower.setImage(null);
        		follower.setWidth(0);
        		follower.setHeight(0);
        		follower.setLayerID("port1");
        		follower.setHost((Node)box.getDataByID(equipment.getEquipcode()));
        		follower.setLocation(x,y);
        		box.add(follower);
        		follower = new Follower(equipment.getEquipcode()+c);
        		follower.setName(equipment.getXmodel());
        		follower.setStyle(Styles.LABEL_SIZE, 12);
        		follower.setStyle(Styles.LABEL_COLOR, Consts.COLOR_WHITE);
        		//follower.setStyle(Styles.LABEL_POSITION, Consts.POSITION_TOPLEFT_BOTTOMRIGHT);
        		follower.setParent(box.getDataByID(equipment.getEquipcode()));
        		follower.setImage(null);
        		follower.setWidth(0);
        		follower.setHeight(0);
        		follower.setLayerID("port1");
        		follower.setHost((Node)box.getDataByID(equipment.getEquipcode()));
        		follower.setLocation(x,y+15);
        		box.add(follower);

        		
            }
        }
        // 生成端口xml
        if (portlist.size() > 0) {
            for (int i = 0; i < portlist.size(); i++) {
                ChannelPort port = (ChannelPort) portlist.get(i);
                double x = port.getBelongequipment().getX();
                double y =port.getBelongequipment().getY();
                	
                	for(int j=0;j<equipList.size();j++){
                		ChannelEquipment equipment = (ChannelEquipment)equipList.get(j);
                		if(equipment.getEquipcode().equalsIgnoreCase(port.getBelongequipment().getEquipcode())){
                			x = equipment.getX();
                			y = equipment.getY();
                		}
                	}
                	
                    if (port.getPosition() > 0) {
                        port.setX(port_x[0]+x);
                        port.setY(port_y[port.getPosition() - 1]+y);
                    } else {
                        port.setX(port_x[1]+x);
                        if (port.getPosition() != 0)
                            port.setY(port_y[-port.getPosition() - 1]+y);
                        else
                            port.setY(port_y[1]+y);
                    }
//                String portcode = port.getPort();
//                String timeslot = To373(port.getSlot());
                String img = portImage;
                if (port.isIsbranch()) {
                    img = branchPortImage;
                }
//                String a = port.getPort()+port.getSlot();
                k++;
                
                
                Follower follower = new Follower(port.getPort() + "," + port.getSlot());
        		follower.setName(port.getPortlabel());
        		follower.setParent(box.getDataByID(port.getBelongequipment().getEquipcode()).getParent());
        		follower.setStyle(Styles.LABEL_SIZE, 9);
        		follower.setImage(img);
        		follower.setWidth(12);
        		follower.setHeight(12);
        		follower.setLayerID("port");
        		follower.setHost((Node)box.getDataByID(port.getBelongequipment().getEquipcode()));
        		follower.setLocation(port.getX(),port.getY());
        		follower.setClient("flag", "port");
        		follower.setClient("position", String.valueOf(port.getPosition()));
        		follower.setClient("portcode", port.getPort()+","+port.getSlot());
        		follower.setClient("isbranch", port.isIsbranch());
        		String toolTip = port.getPortdetail()!=null?port.getPortdetail():"";
        		follower.setToolTip(toolTip);
        		String portshow = port.getPortshow()!=null?port.getPortshow():"";
        		follower.setClient("portlabel", portshow);
                box.add(follower);
                
            }
        }
        // 生成复用段,交叉
        String groupFlag = "";// 判断该条交叉或复用段是否已经生成过xml
        if (portlist.size() > 0) {
            for (int i = 0; i < portlist.size(); i++) {
                ChannelPort portchannel = (ChannelPort) portlist.get(i);
                List<ChannelPort> tmpList = portchannel.getConnectport();
                if (tmpList != null && tmpList.size() > 0) {
                    for (int j = 0; j < tmpList.size(); j++) {
                    	
                    	
                        ChannelPort channeltopo = (ChannelPort) tmpList.get(j);
                        if(!portchannel.getBelongequipment().getEquipcode().equalsIgnoreCase(channeltopo.getBelongequipment().getEquipcode())){
                        String systemcode = "";
                        if (!groupFlag.contains(portchannel.getPort() + ","
                                + portchannel.getSlot() + "#"
                                + channeltopo.getPort() + ","
                                + channeltopo.getSlot())
                                && !groupFlag.contains(channeltopo.getPort()
                                + "," + channeltopo.getSlot() + "#"
                                + portchannel.getPort() + ","
                                + portchannel.getSlot())) {
                            systemcode = "";
                            boolean arrowfrom = false;
                            boolean arrowto = false;
                            if (portchannel.getBelongequipment().getEquipcode()
                                    .equalsIgnoreCase(
                                            channeltopo.getBelongequipment()
                                                    .getEquipcode())) {
                                if (channeltopo.getDirection() != null) {
                                    if (channeltopo.getDirection()
                                            .equalsIgnoreCase("BI")
                                            || channeltopo.getDirection()
                                            .equalsIgnoreCase("-BI")) {
                                        arrowfrom = true;
                                        arrowto = true;
                                    }

                                    if (channeltopo.getDirection()
                                            .equalsIgnoreCase("-UNI")) {
                                        arrowfrom = true;
                                    }
                                    if (channeltopo.getDirection()
                                            .equalsIgnoreCase("UNI")) {
                                        arrowto = true;
                                    }
                                }
                            } else {
                                if (channeltopo.getSystemcode() != null)
                                    systemcode = channeltopo.getSystemcode();
                                else
                                    systemcode = portchannel.getSystemcode();
                            }
                            String slot = "";
                            String slotno373 = "";
                            if ((channeltopo.isIstopo() || portchannel.isIstopo()) && systemcode != null && !systemcode.equalsIgnoreCase("")) {
                            	slot = portchannel.getSlot();
                                if(portchannel.getCrate()!=null&&portchannel.getCrate().equalsIgnoreCase("VC4")){
                                	slot = String.valueOf((Integer.valueOf(portchannel.getSlot())-1)*63+portchannel.getDslot()); 
                                }
                                slotno373 = slot;
                            	slot = To373(slot);
                                slot = "\n " + slot + "";
                            }
                            int strokeWidth = 2;
                            int arrowWidth = 9;
                            if (portchannel.getBelongequipment().getEquipcode().equalsIgnoreCase(channeltopo.getBelongequipment().getEquipcode())) {
                                if (rate.equalsIgnoreCase("VC12")) {
                                    if (!portchannel.getCrate().equalsIgnoreCase(rate)) {
                                    	strokeWidth = 3;
                                        arrowWidth = 12;
                                    }
                                }
                            }
                            String topoid = "cc";
                            if (channeltopo.getTopoid() != null && !channeltopo.getTopoid().equalsIgnoreCase("")) {
                                topoid = channeltopo.getTopoid();
                            }
                            k++;
                            Link link = new Link(portchannel.getPort() + ","+ portchannel.getSlot()+ '#'+ channeltopo.getPort() + ","+ channeltopo.getSlot());
                            link.setName(systemcode);
                            link.setStyle(Styles.ARROW_FROM, arrowfrom);
                            link.setStyle(Styles.ARROW_TO, arrowto);
                            link.setStyle(Styles.ARROW_FROM_HEIGHT, arrowWidth);
                            link.setStyle(Styles.ARROW_TO_HEIGHT,arrowWidth);
                            link.setStyle(Styles.LINK_WIDTH, strokeWidth);
                            String color = "0x00CC00";
                            if(portchannel.getIslord()!=null&&!topoid.equalsIgnoreCase("cc")){
                            if(portchannel.getIslord().equalsIgnoreCase("1")){
                            	color="0x00A0E9 ";
                            }else if(portchannel.getIslord().equalsIgnoreCase("0")){
                            	color="0x6A5F92";
                            }else{
                            	color = "0x00CC00";
                            }
                            }
                            if(channeltopo.getIslord()!=null&&!topoid.equalsIgnoreCase("cc")){
                                if(channeltopo.getIslord().equalsIgnoreCase("1")){
                                	color="0x00A0E9 ";
                                }else if(channeltopo.getIslord().equalsIgnoreCase("0")){
                                	color="0x6A5F92";
                                }else{
                                	color = "0x00CC00";
                                }
                                }
                            link.setStyle(Styles.ARROW_FROM_COLOR, color);
                            link.setStyle(Styles.ARROW_TO_COLOR, color);
                          
                            link.setStyle(Styles.LINK_COLOR, color);
                            link.setStyle(Styles.LABEL_XOFFSET, -5);
                            link.setStyle(Styles.LABEL_YOFFSET, -17);
                            link.setLayerID("port");
                            link.setStyle(Styles.LINK_BUNDLE_GAP, 30);
                            if(!topoid.equalsIgnoreCase("cc")){
                            	link.setClient("flag", "topolink");
                            Follower from = (Follower)box.getDataByID(portchannel.getPort() + "," + portchannel.getSlot());
                            Follower to = (Follower)box.getDataByID(channeltopo.getPort() + "," + channeltopo.getSlot()); 
                            link.setFromNode(from);
                            link.setToNode(to);
                            link.setClient("topoid", topoid);
                            if(!topoid.equalsIgnoreCase("cc")){
                                link.setClient("timeslot", slotno373);
                                link.setClient("timeslot373", slot);
                                link.setClient("systemcode", systemcode);
                                box.add(link);
                                }else{
                                link.setClient("rate", portchannel.getCrate());	
                                }                           
                            groupFlag += portchannel.getPort() + ","
                            + portchannel.getSlot() + '#'
                            + channeltopo.getPort() + ","
                            + channeltopo.getSlot() + "&";
                            }
                         
                        }
                    }
                    }
                }

            }

        }
        
      
        xml = serializer.serialize();
		
        return xml;
    }
    
    
    public String To373(String slot) {
        String realtimeslot = "";
        if (slot != null) {
            int timeslot = (Integer.valueOf(slot));
            int a = 0, b = 0, c = 0, d = 0, x1 = 0, x2 = 0;
            a = timeslot / 63;
            x1 = timeslot % 63;
//            b = x1 / 21;
//            x2 = x1 % 21;
//            c = x2 / 3;
//            d = x2 % 3;
//            if (x1 == 0) {
//                b = b + 3;
//                c = c + 7;
//                d = d + 3;
//            } else if (x2 == 0) {
//                a = a + 1;
//                c = c + 7;
//                d = d + 3;
//            } else if (d == 0) {
//                a = a + 1;
//                b = b + 1;
//                d = d + 3;
//            } else {
//                a = a + 1;
//                b = b + 1;
//                c = c + 1;
//            }
//            realtimeslot = String.valueOf(a) + "-" + String.valueOf(b)
//            + String.valueOf(c) + String.valueOf(d);
            realtimeslot = String.valueOf(a+1) + "-" + String.valueOf(x1);
        }

        return realtimeslot;
    }

  
    
    
  
   
  
  
   
    /**
     * 获取光口下面的vc4或者vc12的业务
     *
     * @param vc4,portcode,vc12,flag(vc12或者vc4)
     * @return String（电路编号）
     * @author 高磊
     */
    @SuppressWarnings("unchecked")
	public String getCircuitcodeForPackGraph(String vc4,String portcode,String vc12,String flag){
    	String circuitcode="";
    	if(flag!=null){
    		if(flag.equalsIgnoreCase("VC12")){
    	if(portcode!=null&&vc4!=null&&vc12!=null){
    		
    		String slot = vc4.replaceAll("VC4-", "");
    	    int a = Integer.valueOf(vc12);
    	    int b = 0;
    		if(slot!=null){
    		 b = Integer.valueOf(slot); 	
    		}
    		if(b>0){
    		a = a+(b-1)*63;
    		}
    		Map map = new HashMap();
    		map.put("portcode", portcode);
    		map.put("slot", a);
    		Map resultMap = (Map)sqlMapClientTemplate.queryForObject("getCircuitcodeForPackGraphvc12", map);
    		if(resultMap!=null){
    			circuitcode=(String)resultMap.get("CIRCUITCODE");
    		}
    	}
    		}if(flag.equalsIgnoreCase("VC4")){
    			if(portcode!=null&&vc4!=null){
    			Map map = new HashMap();
        		map.put("portcode", portcode);
        		map.put("slot", vc4);
        		Map resultMap = (Map)sqlMapClientTemplate.queryForObject("getCircuitcodeForPackGraphvc4", map);
        		if(resultMap!=null){
        			circuitcode=(String)resultMap.get("CIRCUITCODE");
        		   }
    			}
    		}
    	}
    	
    	return circuitcode;
    	
    }
    
    @SuppressWarnings("unchecked")
	public List getFixAlarmPort(String circuitcode){
    	//System.out.print(circuitcode+"====================");
    	try{
    		return sqlMapClientTemplate.queryForList("getFixAlarmPort", circuitcode);
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	return null;
    }
  
    private boolean isExistTopolink(ChannelEquipment channelequipment,ChannelLink channelLink){
    	for (ChannelLink link : channelequipment.getTopoLinks()) {
			if(link.getTopoid().equalsIgnoreCase(channelLink.getTopoid()))
				return true;
		}
    	return false;
    }
    
    /**
     * @author xgyin
     * @param circuitcode
     * @return string
     * @name getPortAandPortZ
     */
    public String getPortAandPortZ(String circuitcode){
    	String result="";
    	List<Circuit> lst = this.getSqlMapClientTemplate().queryForList("getCircuitLstByCode",circuitcode);
    	if(lst.size()>0){
    		result = lst.get(0).getPortserialno1()+"="+lst.get(lst.size()-1).getPortserialno2()+
    				"="+lst.get(0).getSlot1()+"="+lst.get(lst.size()-1).getSlot2();
    	}
    	return result;
    }
    
}
