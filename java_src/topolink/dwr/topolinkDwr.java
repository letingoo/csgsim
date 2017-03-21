package topolink.dwr;

import ocableResources.model.newStationModel;

import java.text.DecimalFormat;
import java.text.NumberFormat;

import org.apache.activemq.filter.function.inListFunction;
import org.apache.axis.transport.http.QSHandler;
import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.dom4j.Document;

import java.awt.print.Printable;
import java.lang.SuppressWarnings;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import login.model.VersionModel;

public class topolinkDwr {
	private SqlMapClientTemplate sqlMapClientTemplate;

	public SqlMapClientTemplate getSqlMapClientTemplate() {
		return sqlMapClientTemplate;
	}

	public void setSqlMapClientTemplate(
			SqlMapClientTemplate sqlMapClientTemplate) {
		this.sqlMapClientTemplate = sqlMapClientTemplate;
	}

	public static List<HashMap<Object, Object>> reresult = new ArrayList<HashMap<Object, Object>>();
	public static List<HashMap<Object, Object>> bus_name = new ArrayList<HashMap<Object, Object>>();

	public void getTopolabel() {
		if (reresult.size() == 0) {
			bus_name.clear();
			List<HashMap<Object, Object>> label = sqlMapClientTemplate
					.queryForList("getTopolabel");

			for (int i = 0; i < label.size(); i++) {
				int counts = 0;
				List<HashMap<Object, Object>> result = sqlMapClientTemplate
						.queryForList("getTopo_business",
								label.get(i).get("LABEL").toString());
				List<HashMap<Object, Object>> results = sqlMapClientTemplate
						.queryForList("getreTopo_business",
								label.get(i).get("LABEL").toString());
				if (result.size() == 0) {
					continue;
				}
				for (int j = 0; j < result.size(); j++) {
					int count = 0;
					boolean flag = true;
					for (int k = 0; k < results.size(); k++) {
						if (result
								.get(j)
								.get("BUSINESS_ID")
								.toString()
								.equals(results.get(k).get("BUSINESS_ID")
										.toString())) {
							count = count + 1;
							if (count >= 2) {
								flag = false;
								counts = counts + 1;
								break;
							}

						}
					}
					if (flag == false) {
						HashMap<Object, Object> orl = new HashMap<Object, Object>();
						orl.put("label", label.get(i).get("LABEL").toString());
						orl.put("labelname", label.get(i).get("NAME")
								.toString());
						orl.put("business_id", result.get(j).get("BUSINESS_ID")
								.toString());
						orl.put("business_name",
								result.get(j).get("BUSINESS_NAME").toString());
						bus_name.add(orl);
					}
				}
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("label", label.get(i).get("LABEL").toString());
				orl.put("labelname", label.get(i).get("NAME").toString());
				orl.put("num", Integer.toString(counts));
				reresult.add(orl);
			}
		}
	}

	// 求解全网的通道压力指数
	public static List<HashMap<Object, Object>> recons = new ArrayList<HashMap<Object, Object>>();

	public List<HashMap<Object, Object>> Fylevel() {
		int topo_sum = 0;
		int business_sum = 0;
		List<HashMap<Object, Object>> channel_topo = new ArrayList<HashMap<Object, Object>>();
		getTopolabel();
		if (recons.size() == 0) {
			List<HashMap<Object, Object>> cons = new ArrayList<HashMap<Object, Object>>();
			DecimalFormat df = new DecimalFormat("######0.00");
			recons.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
				
					cons = business(reresult.get(i).get("label").toString());
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("TDNAME", cons.get(0).get("TDNAME").toString());
					orl.put("LABELNAME", cons.get(0).get("LABELNAME")
							.toString());
					orl.put("MAJOR", cons.get(0).get("MAJOR").toString());
					orl.put("WEG",
							df.format(Double.valueOf(cons.get(0).get("WEG")
									.toString())));
					orl.put("num",reresult.get(i).get("num").toString());
					recons.add(orl);
				}
			}
		}
		/* 统计复用段数量 */
		for(int i=0;i<recons.size();i++)
		{	
			topo_sum = topo_sum + 1;
			business_sum = business_sum
					+ Integer.parseInt(recons.get(i).get("num")
							.toString());
			if (topo_sum % 50 == 0 && topo_sum > 0) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("LEVEL", Integer.toString(topo_sum));
				orl.put("SUM", Integer.toString(business_sum));
				channel_topo.add(orl);
			} 
			if (topo_sum == recons.size()
					&& topo_sum % 50 != 0) {
				for (int s = 0;;s++) {
					topo_sum += 1;
					if (topo_sum % 50 == 0) {
						break;
					}
				}
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("LEVEL", Integer.toString(topo_sum));
				orl.put("SUM", Integer.toString(business_sum));
				channel_topo.add(orl);
			}			
		}
		/* 结束 */
		int level0 = 0;
		int level1 = 0;
		int level2 = 0;
		int level3 = 0;
		for (int i = 0; i < recons.size(); i++) {
			if (Double.valueOf(recons.get(i).get("WEG").toString()) < 35.0
					&& Double.valueOf(recons.get(i).get("WEG").toString()) > 0.0) {
				level0 = level0 + 1;
			}
			if (Double.valueOf(recons.get(i).get("WEG").toString()) >= 35.0
					&& Double.valueOf(recons.get(i).get("WEG").toString()) < 45.0) {
				level1 = level1 + 1;
			}
			if (Double.valueOf(recons.get(i).get("WEG").toString()) >= 45.0
					&& Double.valueOf(recons.get(i).get("WEG").toString()) < 50.0) {
				level2 = level2 + 1;
			}
			if (Double.valueOf(recons.get(i).get("WEG").toString()) >= 50.0) {
				level3 = level3 + 1;
			}
		}

		List<HashMap<Object, Object>> levels = new ArrayList<HashMap<Object, Object>>();
		HashMap<Object, Object> orl0 = new HashMap<Object, Object>();
		orl0.put("LEVEL", "Ⅰ级");
		orl0.put("SUM", Integer.toString(level3));
		levels.add(orl0);
		HashMap<Object, Object> orl1 = new HashMap<Object, Object>();
		orl1.put("LEVEL", "Ⅱ级");
		orl1.put("SUM", Integer.toString(level2));
		levels.add(orl1);
		HashMap<Object, Object> orl2 = new HashMap<Object, Object>();
		orl2.put("LEVEL", "Ⅲ级");
		orl2.put("SUM", Integer.toString(level1));
		levels.add(orl2);
		HashMap<Object, Object> orl3 = new HashMap<Object, Object>();
		orl3.put("LEVEL", "Ⅳ级");
		orl3.put("SUM", Integer.toString(level0));
		levels.add(orl3);
		// return levels;
		return channel_topo;
	}

	// 计算每条复用段的压力指数
	public List<HashMap<Object, Object>> business(String id) {
		List<HashMap<Object, Object>> deresult = new ArrayList<HashMap<Object, Object>>();
		List<HashMap<Object, Object>> deresults = new ArrayList<HashMap<Object, Object>>();
		List<HashMap<Object, Object>> debusiness = new ArrayList<HashMap<Object, Object>>();
		for (int i = 0; i < bus_name.size(); i++) {
			if (id.equals(bus_name.get(i).get("label").toString())) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("TDNAME", bus_name.get(i).get("label").toString());
				orl.put("LABELNAME", bus_name.get(i).get("labelname")
						.toString());
				orl.put("BUSID", bus_name.get(i).get("business_id").toString());
				orl.put("BUSNAME", bus_name.get(i).get("business_name")
						.toString());
				debusiness.add(orl);
			}
		}
		for (int i = 0; i < debusiness.size(); i++) {
			boolean flag = false;
			if (deresult.size() > 0) {
				for (int j = 0; j < deresult.size(); j++) {
					if (deresult.get(j).get("BUSID").toString()
							.equals(debusiness.get(i).get("BUSID").toString())) {
						flag = true;
						break;
					}
				}
			}
			if (flag == true) {
				continue;
			}

			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("TDNAME", debusiness.get(i).get("TDNAME").toString());
			orl.put("LABELNAME", debusiness.get(i).get("LABELNAME").toString());
			orl.put("BUSID", debusiness.get(i).get("BUSID").toString());
			orl.put("BUSNAME", debusiness.get(i).get("BUSNAME").toString());
			deresult.add(orl);
		}
		double weg = 0.0;
		int s4 = 0;
		for (int i = 0; i < deresult.size(); i++) {
			List<String> bus_type = sqlMapClientTemplate.queryForList(
					"business_type", deresult.get(i).get("BUSNAME").toString());
			if (bus_type.size() == 0||bus_type.get(0).toString().equals("(220kV开元变～220kV固店变)综合数据网业务01")) {
				continue;
			}
			if (bus_type.get(0).toString().contains("继电保护")) {
				s4 = s4 + 1;
				weg = weg + 10.0;
			} else if (bus_type.get(0).toString().contains("安稳业务")) {
				s4 = s4 + 1;
				weg = weg + 10.0;
			} else if (bus_type.get(0).toString().contains("调度电话")) {
				weg = weg + 9.38;
			} else if (bus_type.get(0).toString().contains("调度数据网")) {
				weg = weg + 5.98;
			} else if (bus_type.get(0).toString().contains("会议电视")) {
				weg = weg + 5.05;
			} else if (bus_type.get(0).toString().contains("行政电话")) {
				weg = weg + 0.8;
			} else if (bus_type.get(0).toString().contains("综合数据网")) {
				weg = weg + 2.9;
			} else if (bus_type.get(0).toString().contains("网管业务")
					|| bus_type.get(0).toString().contains("故障信息远传业务")
					|| bus_type.get(0).toString().contains("MIS业务")
					|| bus_type.get(0).toString().contains("通信监控业务")
					|| bus_type.get(0).toString().contains("光设备互联业务")
					|| bus_type.get(0).toString().contains("通信监测业务")
					|| bus_type.get(0).toString().contains("用户用电信息采集")
					|| bus_type.get(0).toString().contains("网管业务")) {
				weg = weg + 1.5;
			}

			else {
				weg = weg + 0.62;
			}
		}
		HashMap<Object, Object> orl = new HashMap<Object, Object>();
		orl.put("TDNAME", id);
		orl.put("MAJOR", s4);
		orl.put("LABELNAME", deresult.get(0).get("LABELNAME").toString());
		orl.put("WEG", Double.toString(weg));
		deresults.add(orl);
		return deresults;
	}

	public static List<HashMap<Object, Object>> businessname(String id) {
		List<HashMap<Object, Object>> deresult = new ArrayList<HashMap<Object, Object>>();
		List<HashMap<Object, Object>> deresults = new ArrayList<HashMap<Object, Object>>();
		List<HashMap<Object, Object>> debusiness = new ArrayList<HashMap<Object, Object>>();
		for (int i = 0; i < bus_name.size(); i++) {
			if (id.equals(bus_name.get(i).get("label").toString())) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("TDNAME", bus_name.get(i).get("label").toString());
				orl.put("LABELNAME", bus_name.get(i).get("labelname")
						.toString());
				orl.put("BUSID", bus_name.get(i).get("business_id").toString());
				orl.put("BUSNAME", bus_name.get(i).get("business_name")
						.toString());
				debusiness.add(orl);
			}
		}
		for (int i = 0; i < debusiness.size(); i++) {
			boolean flag = false;
			if (deresult.size() > 0) {
				for (int j = 0; j < deresult.size(); j++) {
					if (deresult.get(j).get("BUSID").toString()
							.equals(debusiness.get(i).get("BUSID").toString())) {
						flag = true;
						break;
					}
				}
			}
			if (flag == true) {
				continue;
			}
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("TDNAME", debusiness.get(i).get("TDNAME").toString());
			orl.put("LABELNAME", debusiness.get(i).get("LABELNAME").toString());
			orl.put("BUSID", debusiness.get(i).get("BUSID").toString());
			orl.put("BUSNAME", debusiness.get(i).get("BUSNAME").toString());
			deresult.add(orl);
		}
		return deresult;
	}

	// 复用段承载的业务和关键业务个数
	public static List<HashMap<Object, Object>> details = new ArrayList<HashMap<Object, Object>>();

	public List<HashMap<Object, Object>> detail(int a) {
		if (a == 1) {
			details.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons.get(j).get("TDNAME").toString())) {
							List<String> rate = sqlMapClientTemplate
									.queryForList("getTopoV", reresult.get(i)
											.get("label").toString());
							HashMap<Object, Object> orl = new HashMap<Object, Object>();
							// orl.put("sum",reresult.get(j).get("num").toString());
							orl.put("label", reresult.get(i).get("label")
									.toString());
							orl.put("labelname",
									reresult.get(i).get("labelname").toString());
							orl.put("sum", reresult.get(i).get("num")
									.toString());
							orl.put("rate", rate.get(0).toString());
							orl.put("major", recons.get(j).get("MAJOR")
									.toString());
							orl.put("result", recons.get(j).get("WEG")
									.toString()); // 可以添加等级值 属于哪一级
							details.add(orl);
							break;
						}
					}
				}
			}
		}
		if (a == 2) {
			details.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons.get(j).get("WEG")
									.toString()) >= 50.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("major", recons.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons.get(j).get("WEG")
										.toString()); // 可以添加等级值 属于哪一级
								details.add(orl);
							}
							break;
						}
					}
				}
			}

		}
		if (a == 3) {
			details.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons.get(j).get("WEG")
									.toString()) >= 45.0
									&& Double.valueOf(recons.get(j).get("WEG")
											.toString()) < 50.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("major", recons.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons.get(j).get("WEG")
										.toString());
								details.add(orl);
							}
							break;
						}
					}
				}
			}

		}
		if (a == 4) {
			details.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons.get(j).get("WEG")
									.toString()) >= 35.0
									&& Double.valueOf(recons.get(j).get("WEG")
											.toString()) < 45.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("major", recons.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons.get(j).get("WEG")
										.toString());
								details.add(orl);
							}
							break;
						}
					}
				}
			}

		}
		if (a == 5) {
			details.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons.get(j).get("WEG")
									.toString()) > 0.0
									&& Double.valueOf(recons.get(j).get("WEG")
											.toString()) < 35.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("major", recons.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons.get(j).get("WEG")
										.toString());
								details.add(orl);
							}
							break;
						}
					}
				}
			}

		}

		if (details.size() == 0) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("sum", "无");
			orl.put("label", "无");
			orl.put("rate", "无");
			orl.put("labelname", "无");
			orl.put("major", "无");
			orl.put("result", "无"); // 可以添加等级值 属于哪一级
			details.add(orl);

		}
		return details;
	}

	// 传入拓扑图的数据 上午的工作把数据存到 字符串里

	public String color()

	{

		// Fylevel();
		String id = "";
		String id1 = "";
		String id2 = "";
		String id3 = "";
		for (int i = 0; i < recons.size(); i++) {
			if (Double.valueOf(recons.get(i).get("WEG").toString()) < 35.0) { 
				if (id == "") {
					String[] a = recons.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id = sds.get(0).toString();
					id = id + "-->" + sdss.get(0).toString();
				}
				if (id != "") {
					String[] a = recons.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id = id + "," + sds.get(0).toString();
					id = id + "-->" + sdss.get(0).toString();
				}
			}

			if (Double.valueOf(recons.get(i).get("WEG").toString()) >= 35.0
					&& Double.valueOf(recons.get(i).get("WEG").toString()) < 45.0) {
				if (id1 == "") {
					String[] a = recons.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id1 = sds.get(0).toString();
					id1 = id1 + "-->" + sdss.get(0).toString();
				}
				if (id1 != "") {
					String[] a = recons.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id1 = id1 + "," + sds.get(0).toString();
					id1 = id1 + "-->" + sdss.get(0).toString();
				}
			}

			if (Double.valueOf(recons.get(i).get("WEG").toString()) >= 45.0
					&& Double.valueOf(recons.get(i).get("WEG").toString()) < 50.0)

			{
				if (id2 == "") {
					String[] a = recons.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id2 = sds.get(0).toString();
					id2 = id2 + "-->" + sdss.get(0).toString();
				}
				if (id2 != "") {
					String[] a = recons.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id2 = id2 + "," + sds.get(0).toString();
					id2 = id2 + "-->" + sdss.get(0).toString();
				}

			}
			if (Double.valueOf(recons.get(i).get("WEG").toString()) >= 50.0) {
				if (id3 == "") {
					String[] a = recons.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}
					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id3 = sds.get(0).toString();
					id3 = id3 + "-->" + sdss.get(0).toString();
				}
				if (id3 != "") {
					String[] a = recons.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id3 = id3 + "," + sds.get(0).toString();
					id3 = id3 + "-->" + sdss.get(0).toString();
				}
			}

		}
		String jGuo = id + "&" + id1 + "&" + id2 + "&" + id3;

		return jGuo;
	}

	public List<HashMap<Object, Object>> curve() {
		Fylevel();
		DecimalFormat df = new DecimalFormat("######0.00");
		NumberFormat num = NumberFormat.getPercentInstance();
		num.setMaximumIntegerDigits(3);
		num.setMaximumFractionDigits(2);
		List<HashMap<Object, Object>> zhexian = new ArrayList<HashMap<Object, Object>>();
		double[] a = new double[recons.size()];
		for (int i = 0; i < recons.size(); i++) {
			a[i] = Double.valueOf(recons.get(i).get("WEG").toString());
		}
		double temp = 0.0;

		for (int i = 0; i < a.length; i++) {

			for (int j = i + 1; j < a.length; j++) {
				if (a[i] > a[j]) {
					temp = a[i];
					a[i] = a[j];
					a[j] = temp;
				}
			}
		}
		double max = 0.0;
		for (int j = 0; j < (int) a[a.length - 1] + 2; j++) {
			int count = 0;
			for (int i = 0; i < a.length; i++) {
				if (a[i] <= max) {
					count = count + 1;
					if (i == a.length - 1) {
						HashMap<Object, Object> orl = new HashMap<Object, Object>();
						orl.put("yali", Double.toString(max));
						orl.put("sum", num.format(((double) count / a.length)));
						zhexian.add(orl);
						max = max + 1.0;
						break;
					}
				}
				if (a[i] > max) {
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("yali", Double.toString(max));
					orl.put("sum", num.format(((double) count / a.length)));
					zhexian.add(orl);
					max = max + 1.0;
					break;
				}
			}

		}
		return zhexian;
		/*
		 * double a=3.7; double b=2.4; int as=(int)a; int bs=(int)b;
		 * System.out.println("as:"+as+"bs"+bs);
		 */
	}

	// 业务设置、业务生成、业务调整
	public static List<HashMap<Object, Object>> local = new ArrayList<HashMap<Object, Object>>();
	public static List<HashMap<Object, Object>> link = new ArrayList<HashMap<Object, Object>>();
	public static List<String> type = new ArrayList<String>();// 用于筛选全网还是唐山的拓扑

	public List<HashMap<Object, Object>> birthroutes(String name, String start,
			String end, int combox) {
		if (recons.size() == 0) {
			Fylevel();
		}
		local.clear();
		link.clear();
		List<HashMap<Object, Object>> path = new ArrayList<HashMap<Object, Object>>();
		local = sqlMapClientTemplate.queryForList("getsbnameaa");

		link = sqlMapClientTemplate.queryForList("getsbzbaa");
		int potnum = local.size();
		double[][] matrixOrigs = new double[potnum][potnum];
		double[][] pressure = new double[potnum][potnum];
		double[][] gj = new double[potnum][potnum];
		double[][] jg = new double[potnum][potnum];
		double[][] level = new double[potnum][potnum];
		for (int i = 0; i < potnum; i++) {
			for (int j = 0; j < potnum; j++) {
				matrixOrigs[i][j] = -1.0;
				pressure[i][j] = 5000.0;
				gj[i][j] = 0.0;
				jg[i][j] = 1.0;
				level[i][j] = 5000.0;
			}
		}

		double[][] potpos = new double[potnum][2];
		for (int i = 0; i < link.size(); i++) {
			boolean tc = false;
			int a = -1;
			int b = -1;
			for (int j = 0; j < local.size(); j++) {
				if (link.get(i).get("NAME_A").toString()
						.equals(local.get(j).get("S_SBMC").toString())) {
					a = j;
					break;
				}
			}
			for (int j = 0; j < local.size(); j++) {
				if (link.get(i).get("NAME_Z").toString()
						.equals(local.get(j).get("S_SBMC").toString())) {
					b = j;
					break;
				}
			}
			if (a != -1 && b != -1) {
				potpos[a][0] = Double.valueOf(local.get(a).get("X").toString());
				potpos[a][1] = Double.valueOf(local.get(a).get("Y").toString());
				potpos[b][0] = Double.valueOf(local.get(b).get("X").toString());
				potpos[b][1] = Double.valueOf(local.get(b).get("Y").toString());
				matrixOrigs[a][b] = 0.019 + 0.005 * Math.sqrt(Math.pow(
						(potpos[a][0] - potpos[b][0]), 2)
						+ Math.pow((potpos[a][1] - potpos[b][1]), 2));
				matrixOrigs[b][a] = 0.019 + 0.005 * Math.sqrt(Math.pow(
						(potpos[a][0] - potpos[b][0]), 2)
						+ Math.pow((potpos[a][1] - potpos[b][1]), 2));
				for (int s = 0; s < recons.size(); s++) {
					if (recons.get(s).get("TDNAME").toString()
							.equals(link.get(i).get("LABEL").toString())) {
						tc = true;
						pressure[a][b] = Double.valueOf(recons.get(s)
								.get("WEG").toString());
						pressure[b][a] = Double.valueOf(recons.get(s)
								.get("WEG").toString());
						pressure[b][a] = Double.valueOf(recons.get(s)
								.get("MAJOR").toString());
						pressure[a][b] = Double.valueOf(recons.get(s)
								.get("MAJOR").toString());
					}
				}
				if (tc == false) {
					pressure[a][b] = 0.0;
					pressure[b][a] = 0.0;
					gj[a][b] = 0.0;
					gj[b][a] = 0.0;
				}
				if (pressure[a][b] == 0.0) {
					level[a][b] = 0.0;
					level[b][a] = 0.0;
				}
				if (pressure[a][b] < 50.0 && pressure[a][b] > 0) {
					level[a][b] = 0.1; // 1.0
					level[b][a] = 0.1;
				}
				if (pressure[a][b] >= 50.0 && pressure[a][b] < 80.0) {
					level[a][b] = 0.2; // 2.0
					level[b][a] = 0.2;
				}
				if (pressure[a][b] >= 80.0 && pressure[a][b] < 150.0) {
					level[a][b] = 0.3; // 3.0
					level[b][a] = 0.3;
				}
				if (pressure[a][b] >= 150.0) // 4.0
				{
					level[a][b] = 0.4;
					level[b][a] = 0.4;
				}

			}
		}
		int qs = 0;
		int zz = 0;
		for (int i = 0; i < local.size(); i++) // 这个过程可以简化为rowid求解
		{
			if (local.get(i).get("S_SBMC").toString().equals(start)) {
				qs = i;
			}
			if (local.get(i).get("S_SBMC").toString().equals(end)) {
				zz = i;
			}
		}
		if (combox == 1) {
			Floyds.routes(matrixOrigs, level, pressure, qs, zz);
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";
			if (Floyds.floydresult.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("stress", "无");
				mainorl.put("chdelay", "无");
				path.add(mainorl);
			}
			if (!Floyds.floydresult.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyds.floydresult.get(0).get("mainroute")
						.toString().split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("code", maincode);
				mainorl.put("delay", na[1]);
				mainorl.put("stress", "无");
				mainorl.put("chdelay", "0.0");
				path.add(mainorl);
			}
			if (Floyds.floydresult.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("delay", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyds.floydresult.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyds.floydresult.get(0).get("backuproute")
						.toString().split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}
				}
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", "无");
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);
			}
			if (Floyds.floydresult.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}

			if (!Floyds.floydresult.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyds.floydresult.get(0).get("bypassroute")
						.toString().split("a");
				String bypasspath[] = na[0].split(",");
				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", "无");
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
			}
		}
		if (combox == 2) {
			Floyd.route(matrixOrigs, level, pressure, qs, zz);
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";

			if (Floyd.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("stress", "无");
				mainorl.put("chdelay", "无");
				path.add(mainorl);
			}
			if (!Floyd.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyd.result.get(0).get("mainroute").toString()
						.split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("code", maincode);
				mainorl.put("delay", na[1]);
				mainorl.put("stress", na[2]);
				mainorl.put("chdelay", "0.0");
				path.add(mainorl);
			}
			if (Floyd.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("delay", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyd.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyd.result.get(0).get("backuproute").toString()
						.split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}
				}
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", na[2]);
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);
			}
			if (Floyd.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}

			if (!Floyd.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyd.result.get(0).get("bypassroute").toString()
						.split("a");
				String bypasspath[] = na[0].split(",");
				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", na[2]);
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
			}
		}
		if (combox == 3) {
			Floyd.route(matrixOrigs, jg, gj, qs, zz);
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";

			if (Floyd.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("stress", "无");
				mainorl.put("chdelay", "无");
				path.add(mainorl);
			}
			if (!Floyd.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyd.result.get(0).get("mainroute").toString()
						.split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				double sfg = Double.valueOf(na[2]);
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("delay", na[1]);
				mainorl.put("stress", Integer.toString((int) sfg));
				mainorl.put("chdelay", "0.0");
				mainorl.put("code", maincode);
				path.add(mainorl);
			}
			if (Floyd.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("delay", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyd.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyd.result.get(0).get("backuproute").toString()
						.split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}
				}
				double sfg = Double.valueOf(na[2]);
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", Integer.toString((int) sfg));
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);

			}
			if (Floyd.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}

			if (!Floyd.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyd.result.get(0).get("bypassroute").toString()
						.split("a");
				String bypasspath[] = na[0].split(",");
				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				double sfg = Double.valueOf(na[2]);
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", Integer.toString((int) sfg));
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
			}
		}
		return path;
	}

	public List<HashMap<Object, Object>> birthroutess(String q, String aeq,
			String beq, int combox) {
		if (recons.size() == 0) {
			Fylevel();
		}
		local.clear();
		link.clear();
		List<HashMap<Object, Object>> path = new ArrayList<HashMap<Object, Object>>();
		local = sqlMapClientTemplate.queryForList("getsbnameaa");
		link = sqlMapClientTemplate.queryForList("getsbzbaa");
		int potnum = local.size();
		double[][] matrixOrigs = new double[potnum][potnum];
		double[][] pressure = new double[potnum][potnum];
		double[][] gj = new double[potnum][potnum];
		double[][] jg = new double[potnum][potnum];
		double[][] level = new double[potnum][potnum];
		for (int i = 0; i < potnum; i++) {
			for (int j = 0; j < potnum; j++) {
				matrixOrigs[i][j] = -1.0;
				pressure[i][j] = 5000.0;
				gj[i][j] = 0.0;
				jg[i][j] = 1.0;
				level[i][j] = 5000.0;
			}
		}

		double[][] potpos = new double[potnum][2];
		for (int i = 0; i < link.size(); i++) {
			boolean tc = false;
			int a = -1;
			int b = -1;
			for (int j = 0; j < local.size(); j++) {
				if (link.get(i).get("NAME_A").toString()
						.equals(local.get(j).get("S_SBMC").toString())) {
					a = j;
					break;
				}
			}
			for (int j = 0; j < local.size(); j++) {
				if (link.get(i).get("NAME_Z").toString()
						.equals(local.get(j).get("S_SBMC").toString())) {
					b = j;
					break;
				}
			}
			if (a != -1 && b != -1) {
				potpos[a][0] = Double.valueOf(local.get(a).get("X").toString());
				potpos[a][1] = Double.valueOf(local.get(a).get("Y").toString()); // 0.156
																					// ms
																					// 收发时延
				potpos[b][0] = Double.valueOf(local.get(b).get("X").toString());
				potpos[b][1] = Double.valueOf(local.get(b).get("Y").toString());
				matrixOrigs[a][b] = 0.019 + 0.005 * Math.sqrt(Math.pow(
						(potpos[a][0] - potpos[b][0]), 2)
						+ Math.pow((potpos[a][1] - potpos[b][1]), 2));
				matrixOrigs[b][a] = 0.019 + 0.005 * Math.sqrt(Math.pow(
						(potpos[a][0] - potpos[b][0]), 2)
						+ Math.pow((potpos[a][1] - potpos[b][1]), 2));
				for (int s = 0; s < recons.size(); s++) {
					if (recons.get(s).get("TDNAME").toString()
							.equals(link.get(i).get("LABEL").toString())) {
						tc = true;
						pressure[a][b] = Double.valueOf(recons.get(s)
								.get("WEG").toString());
						pressure[b][a] = Double.valueOf(recons.get(s)
								.get("WEG").toString());
						gj[b][a] = Double.valueOf(recons.get(s).get("MAJOR")
								.toString());
						gj[b][a] = Double.valueOf(recons.get(s).get("MAJOR")
								.toString());
					}
				}
				if (tc == false) {
					pressure[a][b] = 0.0;
					pressure[b][a] = 0.0;
					gj[b][a] = 0.0;
					gj[a][b] = 0.0;
				}
				if (pressure[a][b] == 0.0) {
					level[a][b] = 0.0;
					level[b][a] = 0.0;
				}
				if (pressure[a][b] < 50.0 && pressure[a][b] > 0) {
					level[a][b] = 0.1; // 1.0
					level[b][a] = 0.1;
				}
				if (pressure[a][b] >= 50.0 && pressure[a][b] < 80.0) {
					level[a][b] = 0.2; // 2.0
					level[b][a] = 0.2;
				}
				if (pressure[a][b] >= 80.0 && pressure[a][b] < 150.0) {
					level[a][b] = 0.3; // 3.0
					level[b][a] = 0.3;
				}
				if (pressure[a][b] >= 150.0) {
					level[a][b] = 0.4; // 4.0
					level[b][a] = 0.4;
				}

			}
		}

		int qs = 0;
		int zz = 0;
		for (int i = 0; i < local.size(); i++) {
			if (local.get(i).get("S_SBMC").toString().equals(aeq)) {
				qs = i;
			}
			if (local.get(i).get("S_SBMC").toString().equals(beq)) {
				zz = i;
			}
		}
		if (combox == 1) {
			Floyds.routes(matrixOrigs, level, pressure, qs, zz);
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";
			if (Floyds.floydresult.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("chdelay", "无");
				mainorl.put("stress", "无");
				path.add(mainorl);
			}

			if (!Floyds.floydresult.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyds.floydresult.get(0).get("mainroute")
						.toString().split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("delay", na[1]);
				mainorl.put("stress", "无");
				mainorl.put("chdelay", "0.0");
				mainorl.put("code", maincode);
				path.add(mainorl);
			}
			if (Floyds.floydresult.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("delay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyds.floydresult.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyds.floydresult.get(0).get("backuproute")
						.toString().split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", "无");
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);
			}

			if (Floyds.floydresult.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}
			if (!Floyds.floydresult.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyds.floydresult.get(0).get("bypassroute")
						.toString().split("a");
				String bypasspath[] = na[0].split(",");

				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", "无");
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
			}
		}
		if (combox == 2) {
			Floyd.route(matrixOrigs, level, pressure, qs, zz);
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";

			if (Floyd.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("chdelay", "无");
				mainorl.put("stress", "无");
				path.add(mainorl);
			}

			if (!Floyd.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyd.result.get(0).get("mainroute").toString()
						.split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("delay", na[1]);
				mainorl.put("stress", na[2]);
				mainorl.put("chdelay", "0.0");
				mainorl.put("code", maincode);
				path.add(mainorl);
			}
			if (Floyd.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("delay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyd.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyd.result.get(0).get("backuproute").toString()
						.split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", na[2]);
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);
			}

			if (Floyd.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}
			if (!Floyd.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyd.result.get(0).get("bypassroute").toString()
						.split("a");
				String bypasspath[] = na[0].split(",");

				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", na[2]);
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
			}
		}
		if (combox == 3) {
			Floyd.route(matrixOrigs, jg, gj, qs, zz);
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";

			if (Floyd.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("chdelay", "无");
				mainorl.put("stress", "无");
				path.add(mainorl);
			}

			if (!Floyd.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyd.result.get(0).get("mainroute").toString()
						.split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				double sfg = Double.valueOf(na[2]);
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("delay", na[1]);
				mainorl.put("stress", Integer.toString((int) sfg));
				mainorl.put("chdelay", "0.0");
				mainorl.put("code", maincode);
				path.add(mainorl);

			}
			if (Floyd.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("delay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyd.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyd.result.get(0).get("backuproute").toString()
						.split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				double sfg = Double.valueOf(na[2]);

				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", Integer.toString((int) sfg));
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);

			}

			if (Floyd.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}
			if (!Floyd.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyd.result.get(0).get("bypassroute").toString()
						.split("a");
				String bypasspath[] = na[0].split(",");

				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				double sfg = Double.valueOf(na[2]);
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", Integer.toString((int) sfg));
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);

			}
		}
		return path;
	}

	public static List<HashMap<Object, Object>> zhandian = new ArrayList<HashMap<Object, Object>>();
	public static List<HashMap<Object, Object>> shebei = new ArrayList<HashMap<Object, Object>>();

	public List<HashMap<Object, Object>> station() {
		List<String> station = sqlMapClientTemplate.queryForList("getqszd");

		for (int i = 0; i < station.size(); i++) {
			String station1 = "";

			if (station.get(i).toString().contains("鑫汇电厂"))
				continue;

			if (station.get(i).toString().contains("110kV")) {
				station1 = station.get(i).toString().substring(5, 8);
				List<String> equip = sqlMapClientTemplate.queryForList(
						"getqssb", station1);
				if (equip.size() > 0) {
					String ch = "";
					HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
					backuporl.put("name", station.get(i).toString());
					zhandian.add(backuporl);
					for (int j = 0; j < equip.size(); j++) {
						if (j == 0) {
							ch = equip.get(j).toString();
						} else {
							ch = ch + "," + equip.get(j).toString();
						}
					}
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("name", ch);
					shebei.add(orl);
				}
			} else if (station.get(i).toString().contains("220kV")) {
				station1 = station.get(i).toString().substring(5, 8);
				List<String> equip = sqlMapClientTemplate.queryForList(
						"getqssb", station1);
				if (equip.size() > 0) {
					String ch = "";
					HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
					backuporl.put("name", station.get(i).toString());
					zhandian.add(backuporl);
					for (int j = 0; j < equip.size(); j++) {
						if (j == 0) {
							ch = equip.get(j).toString();
						} else {
							ch = ch + "," + equip.get(j).toString();
						}
					}
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("name", ch);
					shebei.add(orl);
				}
			} else if (station.get(i).toString().contains("500kV")) {
				station1 = station.get(i).toString().substring(5, 8);
				List<String> equips = sqlMapClientTemplate.queryForList(
						"getqssb", station1);
				if (equips.size() > 0) {
					String ch = "";
					HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
					backuporl.put("name", station.get(i).toString());
					zhandian.add(backuporl);
					for (int j = 0; j < equips.size(); j++) {
						if (j == 0) {
							ch = equips.get(j).toString();
						} else {
							ch = ch + "," + equips.get(j).toString();
						}
					}
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("name", ch);
					shebei.add(orl);
				}
			} else {
				station1 = station.get(i).toString();
				List<String> equips = sqlMapClientTemplate.queryForList(
						"getqssb", station1);
				if (equips.size() > 0) {
					String ch = "";
					HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
					backuporl.put("name", station.get(i).toString());
					zhandian.add(backuporl);
					for (int j = 0; j < equips.size(); j++) {
						if (j == 0) {
							ch = equips.get(j).toString();
						} else {
							ch = ch + "," + equips.get(j).toString();
						}
					}
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("name", ch);
					shebei.add(orl);
				}
			}
		}
		return zhandian;
	}

	public List<HashMap<Object, Object>> qsse(String ace) {
		List<HashMap<Object, Object>> sss = new ArrayList<HashMap<Object, Object>>();
		for (int i = 0; i < shebei.size(); i++) {
			if (shebei.get(i).get("name").toString()
					.contains(ace.substring(5, 8))) {
				String[] a = shebei.get(i).get("name").toString().split(",");
				for (int j = 0; j < a.length; j++) {
					boolean sfs = false;
					if (j == 0) {
						HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
						backuporl.put("names", a[j]);
						sss.add(backuporl);
					} else {
						for (int k = 0; k < sss.size(); k++) {
							if (a[j].equals(sss.get(k).get("names").toString())) {
								sfs = true;
								break;
							}
						}
						if (sfs == false) {
							HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
							backuporl.put("names", a[j]);
							sss.add(backuporl);
						}
					}
				}
			}
		}
		/*
		 * for(int i=0;i<sss.size();i++) {
		 * System.out.println(sss.get(i).get("names").toString()); }
		 */
		return sss;
	}

	public List<HashMap<Object, Object>> qqs(String q) {
		List<HashMap<Object, Object>> eqname = new ArrayList<HashMap<Object, Object>>();
		List<String> aa = new ArrayList<String>(); // 起始设备
		List<String> aaa = new ArrayList<String>(); // 终止设备
		List<String> aaaaa = new ArrayList<String>(); // 业务速率
		List<String> aaaa = sqlMapClientTemplate.queryForList("getsqsl", q);// 业务类型
		List<String> circuitcode = sqlMapClientTemplate.queryForList("getywmc",
				q);
		for (int i = 0; i < circuitcode.size(); i++) {
			aa = sqlMapClientTemplate.queryForList("getsqsb", circuitcode
					.get(i).toString());
			aaa = sqlMapClientTemplate.queryForList("getsqsbs", circuitcode
					.get(i).toString());

			if (aa.size() > 0 && aaa.size() > 0) {
				aaaaa = sqlMapClientTemplate.queryForList("getsqsls",
						circuitcode.get(i).toString());
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("BUSINESS_NAME", q);
				bypassorl.put("PA", aa.get(0).toString());
				bypassorl.put("PB", aaa.get(0).toString());
				bypassorl.put("BUSINESS_RATE", aaaa.get(0).toString());
				bypassorl.put("BUSINESS_TYPE_ID", aaaaa.get(0).toString());
				eqname.add(bypassorl);
				break;
			}
		}
		return eqname;
	}

	/* 路由每条复用段的通道压力 */
	public List<HashMap<Object, Object>> chuan(String a, String b, int c)

	{
		List<HashMap<Object, Object>> st = new ArrayList<HashMap<Object, Object>>();
		if (c == 3) {
			if (a.equals("无")) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("topo", "无");
				orl.put("weg", "无");
				st.add(orl);
			} else {
				String v[] = new String[50];
				if (b.equals("主路由")) {
					v = Floyd.result.get(0).get("mainroute_press").toString()
							.split(",");
				}
				if (b.equals("备用路由")) {
					v = Floyd.result.get(0).get("backuproute_press").toString()
							.split(",");
				}
				if (b.equals("迂回路由")) {
					v = Floyd.result.get(0).get("bypassroute_press").toString()
							.split(",");
				}
				String equip[] = a.split("-->");
				for (int i = 0; i < equip.length - 1; i++) {
					String sd = equip[i] + "——" + equip[i + 1];
					double ssf = Double.valueOf(v[i]);
					int ssd = (int) ssf;
					if (ssd >= 8) {
						ssd = 4;
					}
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("topo", sd);
					orl.put("weg", ssd);
					st.add(orl);
				}
			}
		}
		if (c == 2) {
			if (a.equals("无")) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("topo", "无");
				orl.put("weg", "无");
				st.add(orl);
			} else {
				String v[] = new String[50];
				if (b.equals("主路由")) {
					v = Floyd.result.get(0).get("mainroute_press").toString()
							.split(",");
				}
				if (b.equals("备用路由")) {
					v = Floyd.result.get(0).get("backuproute_press").toString()
							.split(",");
				}
				if (b.equals("迂回路由")) {
					v = Floyd.result.get(0).get("bypassroute_press").toString()
							.split(",");
				}
				String equip[] = a.split("-->");
				for (int i = 0; i < equip.length - 1; i++) {
					String sd = equip[i] + "——" + equip[i + 1];
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("topo", sd);
					orl.put("weg", v[i]);
					st.add(orl);
				}
			}
		}
		return st;
	}

	/* 光缆段承载业务信息 */
	public static List<HashMap<Object, Object>> ocas = new ArrayList<HashMap<Object, Object>>();

	public List<HashMap<Object, Object>> ocable(int a) {
		ocas.clear();
		List<HashMap<Object, Object>> oca = new ArrayList<HashMap<Object, Object>>();
		if (a == 1) {
			oca.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons.get(j).get("TDNAME").toString())) {
							List<String> rate = sqlMapClientTemplate
									.queryForList("getTopoV", reresult.get(i)
											.get("label").toString());
							HashMap<Object, Object> orl = new HashMap<Object, Object>();
							// orl.put("sum",reresult.get(j).get("num").toString());
							orl.put("label", reresult.get(i).get("label")
									.toString());
							orl.put("labelname",
									reresult.get(i).get("labelname").toString());
							orl.put("sum", reresult.get(i).get("num")
									.toString());
							orl.put("rate", rate.get(0).toString());
							orl.put("major", recons.get(j).get("MAJOR")
									.toString());
							orl.put("result", recons.get(j).get("WEG")
									.toString()); // 可以添加等级值 属于哪一级
							oca.add(orl);
							break;
						}
					}
				}
			}
		}
		if (a == 2) {
			oca.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons.get(j).get("WEG")
									.toString()) >= 50.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("major", recons.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons.get(j).get("WEG")
										.toString()); // 可以添加等级值 属于哪一级
								oca.add(orl);
							}
							break;
						}
					}
				}
			}

		}
		if (a == 3) {
			oca.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons.get(j).get("WEG")
									.toString()) >= 45.0
									&& Double.valueOf(recons.get(j).get("WEG")
											.toString()) < 50.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("major", recons.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons.get(j).get("WEG")
										.toString()); // 可以添加等级值 属于哪一级
								oca.add(orl);
							}
							break;
						}
					}
				}
			}

		}
		if (a == 4) {
			oca.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons.get(j).get("WEG")
									.toString()) >= 35.0
									&& Double.valueOf(recons.get(j).get("WEG")
											.toString()) < 45.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("major", recons.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons.get(j).get("WEG")
										.toString()); // 可以添加等级值 属于哪一级
								oca.add(orl);
							}
							break;
						}
					}
				}
			}

		}
		if (a == 5) {
			oca.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons.get(j).get("WEG")
									.toString()) > 0.0
									&& Double.valueOf(recons.get(j).get("WEG")
											.toString()) < 35.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("major", recons.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons.get(j).get("WEG")
										.toString()); // 可以添加等级值 属于哪一级
								oca.add(orl);
							}
							break;
						}
					}
				}
			}

		}
		if (oca.size() > 0) {
			for (int s = 0; s < oca.size(); s++) {
				boolean flag = false;
				if (s == 0) {
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("sum", oca.get(s).get("sum").toString());
					orl.put("label", oca.get(s).get("label").toString());
					orl.put("labelname", oca.get(s).get("labelname").toString());
					orl.put("major", oca.get(s).get("major").toString());
					orl.put("result", oca.get(s).get("result").toString());
					ocas.add(orl);
				} else {
					for (int h = 0; h < ocas.size(); h++) {
						if (oca.get(s)
								.get("labelname")
								.toString()
								.equals(ocas.get(h).get("labelname").toString())) {
							flag = true;
							int allsum = Integer.parseInt(ocas.get(h)
									.get("sum").toString())
									+ Integer.parseInt(oca.get(s).get("sum")
											.toString());
							int mainsum = Integer.parseInt(ocas.get(h)
									.get("major").toString())
									+ Integer.parseInt(oca.get(s).get("major")
											.toString());
							double mainresult = Double.valueOf(ocas.get(h)
									.get("result").toString())
									+ Double.valueOf(oca.get(s).get("result")
											.toString());
							HashMap<Object, Object> orl = new HashMap<Object, Object>();
							orl.put("sum", Integer.toString(allsum));
							orl.put("label", oca.get(s).get("label").toString());
							orl.put("labelname", oca.get(s).get("labelname")
									.toString());
							orl.put("major", Integer.toString(mainsum));
							orl.put("result", Double.valueOf(mainresult));
							ocas.add(h, orl);
							ocas.remove(h + 1);
						}
					}
					if (flag == false) {
						HashMap<Object, Object> orl = new HashMap<Object, Object>();
						orl.put("sum", oca.get(s).get("sum").toString());
						orl.put("label", oca.get(s).get("label").toString());
						orl.put("labelname", oca.get(s).get("labelname")
								.toString());
						orl.put("major", oca.get(s).get("major").toString());
						orl.put("result", oca.get(s).get("result").toString());
						ocas.add(orl);
					}
				}
			}

		}
		if (ocas.size() == 0) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("sum", "无");
			orl.put("label", "无");
			orl.put("rate", "无");
			orl.put("labelname", "无");
			orl.put("major", "无");
			orl.put("result", "无"); // 可以添加等级值 属于哪一级
			ocas.add(orl);

		}
		return ocas;

	}

	/* 光缆段名称 */
	public List<HashMap<Object, Object>> ocabledetail(int a) {
		List<HashMap<Object, Object>> ocableList = new ArrayList<HashMap<Object, Object>>();
		List<String> ocablename = new ArrayList<String>();
		// List<String>name
		// =sqlMapClientTemplate.queryForList("getTopoV",reresult.get(i).get("label").toString());
		ocable(a);
		for (int i = 0; i < ocas.size(); i++) {

			String start = "";
			String end = "";
			String jieguo = "";
			String[] b = ocas.get(i).get("label").toString().split("#");
			start = (String) sqlMapClientTemplate.queryForObject(
					"getocablecode", b[0]);
			end = (String) sqlMapClientTemplate.queryForObject("getocablecode",
					b[1]);

			/*
			 * 冀北：周营子~隆城 唐山：韩城~车轴山 洼里~河车 姜家营~常庄 承德：热河~营子 承德变~高寺台
			 */

			/*
			 * Map map =new HashMap(); map.put("sta", start);
			 * map.put("stz",end);
			 * ocablename=sqlMapClientTemplate.queryForList("getocablename"
			 * ,map); HashMap<Object, Object> orl = new HashMap<Object,
			 * Object>(); orl.put("sum",ocas.get(i).get("sum").toString());
			 * orl.put("label",ocas.get(i).get("label").toString());
			 * orl.put("labelname",jieguo);
			 * orl.put("major",ocas.get(i).get("major").toString());
			 * orl.put("result",ocas.get(i).get("result").toString());
			 * ocableList.add(orl);
			 */
		}
		return ocableList;
	}
	/**以下为通道压力及安全预警分析**/
	// 求解全网的通道压力指数
	public static List<HashMap<Object, Object>> recons1 = new ArrayList<HashMap<Object, Object>>();
	public List<HashMap<Object, Object>> Fylevel1() {
		getTopolabel();
		if (recons1.size() == 0) {
			List<HashMap<Object, Object>> cons = new ArrayList<HashMap<Object, Object>>();
			DecimalFormat df = new DecimalFormat("######0.00");
			recons1.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					cons = business1(reresult.get(i).get("label").toString());
					HashMap<Object, Object> orl = new HashMap<Object, Object>();
					orl.put("TDNAME", cons.get(0).get("TDNAME").toString());
					orl.put("LABELNAME", cons.get(0).get("LABELNAME")
							.toString());
					orl.put("MAJOR", cons.get(0).get("MAJOR").toString());
					orl.put("WEG",
							df.format(Double.valueOf(cons.get(0).get("WEG")
									.toString())));
					recons1.add(orl);
				}
			}
		}
		int level0 = 0;
		int level1 = 0;
		int level2 = 0;
		int level3 = 0;
		for (int i = 0; i < recons1.size(); i++) {
			if (Double.valueOf(recons1.get(i).get("WEG").toString()) < 90.0
					&& Double.valueOf(recons1.get(i).get("WEG").toString()) > 0.0) {
				level0 = level0 + 1;
			}
			if (Double.valueOf(recons1.get(i).get("WEG").toString()) >= 90.0
					&& Double.valueOf(recons1.get(i).get("WEG").toString()) < 120.0) {
				level1 = level1 + 1;
			}
			if (Double.valueOf(recons1.get(i).get("WEG").toString()) >= 120.0
					&& Double.valueOf(recons1.get(i).get("WEG").toString()) < 160.0) {
				level2 = level2 + 1;
			}
			if (Double.valueOf(recons1.get(i).get("WEG").toString()) >= 160.0) {
				level3 = level3 + 1;
			}
		}

		List<HashMap<Object, Object>> levels = new ArrayList<HashMap<Object, Object>>();
		HashMap<Object, Object> orl0 = new HashMap<Object, Object>();
		orl0.put("LEVEL", "Ⅰ级");
		orl0.put("SUM", Integer.toString(level3));
		levels.add(orl0);
		HashMap<Object, Object> orl1 = new HashMap<Object, Object>();
		orl1.put("LEVEL", "Ⅱ级");
		orl1.put("SUM", Integer.toString(level2));
		levels.add(orl1);
		HashMap<Object, Object> orl2 = new HashMap<Object, Object>();
		orl2.put("LEVEL", "Ⅲ级");
		orl2.put("SUM", Integer.toString(level1));
		levels.add(orl2);
		HashMap<Object, Object> orl3 = new HashMap<Object, Object>();
		orl3.put("LEVEL", "Ⅳ级");
		orl3.put("SUM", Integer.toString(level0));
		levels.add(orl3);
//		for (int i = 0; i < levels.size(); i++) {
//			System.out.println(levels.get(i).get("LEVEL").toString()
//					+ "&&&&&&&&&&&" + levels.get(i).get("SUM").toString());
//		}

		return levels;

	}
	
	public List<HashMap<Object, Object>> business1(String id) {
		List<HashMap<Object, Object>> deresult = new ArrayList<HashMap<Object, Object>>();
		List<HashMap<Object, Object>> deresults = new ArrayList<HashMap<Object, Object>>();
		List<HashMap<Object, Object>> debusiness = new ArrayList<HashMap<Object, Object>>();
		for (int i = 0; i < bus_name.size(); i++) {
			if (id.equals(bus_name.get(i).get("label").toString())) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				orl.put("TDNAME", bus_name.get(i).get("label").toString());
				orl.put("LABELNAME", bus_name.get(i).get("labelname")
						.toString());
				orl.put("BUSID", bus_name.get(i).get("business_id").toString());
				orl.put("BUSNAME", bus_name.get(i).get("business_name")
						.toString());
				debusiness.add(orl);
			}
		}
		for (int i = 0; i < debusiness.size(); i++) {
			boolean flag = false;
			if (deresult.size() > 0) {
				for (int j = 0; j < deresult.size(); j++) {
					if (deresult.get(j).get("BUSID").toString()
							.equals(debusiness.get(i).get("BUSID").toString())) {
						flag = true;
						break;
					}
				}
			}
			if (flag == true) {
				continue;
			}

			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("TDNAME", debusiness.get(i).get("TDNAME").toString());
			orl.put("LABELNAME", debusiness.get(i).get("LABELNAME").toString());
			orl.put("BUSID", debusiness.get(i).get("BUSID").toString());
			orl.put("BUSNAME", debusiness.get(i).get("BUSNAME").toString());
			deresult.add(orl);
		}
		double weg = 0.0;
		int s4 = 0;
		int count1 = 0, count2 = 0, count3 = 0, count4 = 0, count5 = 0, count6 = 0, count7 = 0, count8 = 0, count9 = 0;
		for (int i = 0; i < deresult.size(); i++) {
			List<String> bus_type = sqlMapClientTemplate.queryForList(
					"business_type", deresult.get(i).get("BUSNAME").toString());
			if (bus_type.size() == 0) {
				continue;
			}
			if (bus_type.get(0).toString().contains("继电保护")) {
				s4 = s4 + 1;
				count1++;
			} else if (bus_type.get(0).toString().contains("安稳业务")) {
				s4 = s4 + 1;
				count2++;
			} else if (bus_type.get(0).toString().contains("调度电话")) {
				count3++;
			} else if (bus_type.get(0).toString().contains("调度数据网")) {
				count4++;
			} else if (bus_type.get(0).toString().contains("会议电视")) {
				count5++;
			} else if (bus_type.get(0).toString().contains("行政电话")) {
				count6++;
			} else if (bus_type.get(0).toString().contains("综合数据网")) {
				count7++;
			} else if (bus_type.get(0).toString().contains("网管业务")
					|| bus_type.get(0).toString().contains("故障信息远传业务")
					|| bus_type.get(0).toString().contains("MIS业务")
					|| bus_type.get(0).toString().contains("通信监控业务")
					|| bus_type.get(0).toString().contains("光设备互联业务")
					|| bus_type.get(0).toString().contains("通信监测业务")
					|| bus_type.get(0).toString().contains("用户用电信息采集")
					|| bus_type.get(0).toString().contains("网管业务")) {
				count8++;
			}

			else {
				count9++;
			}
		}
		weg = count1 * 10.0 + count2 * 10.0 + count3 * 9.38 + count4 * 5.98
				+ count5 * 5.05 + count6 * 0.8 + count7 * 2.9 + count8 * 1.5
				+ count9 * 0.62;
		HashMap<Object, Object> orl = new HashMap<Object, Object>();
		orl.put("TDNAME", id);
		orl.put("MAJOR", s4);
		orl.put("LABELNAME", deresult.get(0).get("LABELNAME").toString());
		orl.put("WEG", Double.toString(weg));
		deresults.add(orl);
		return deresults;
	}


	// 复用段承载的业务和关键业务个数
	public static List<HashMap<Object, Object>> details1 = new ArrayList<HashMap<Object, Object>>();

	public List<HashMap<Object, Object>> detail1(int a) {
		if (a == 1) {
			details1.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons1.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons1.get(j).get("TDNAME").toString())) {
							List<String> rate = sqlMapClientTemplate
									.queryForList("getTopoV", reresult.get(i)
											.get("label").toString());
							HashMap<Object, Object> orl = new HashMap<Object, Object>();
							// orl.put("sum",reresult.get(j).get("num").toString());
							orl.put("label", reresult.get(i).get("label")
									.toString());
							orl.put("labelname",
									reresult.get(i).get("labelname").toString());
							orl.put("sum", reresult.get(i).get("num")
									.toString());
							orl.put("rate", rate.get(0).toString());
							orl.put("major", recons1.get(j).get("MAJOR")
									.toString());
							orl.put("result", recons1.get(j).get("WEG")
									.toString()); // 可以添加等级值 属于哪一级
							details1.add(orl);
							break;
						}
					}
				}
			}
		}
		if (a == 2) {
			details1.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons1.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons1.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons1.get(j).get("WEG")
									.toString()) >= 160.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("major", recons1.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons1.get(j).get("WEG")
										.toString()); // 可以添加等级值 属于哪一级
								details1.add(orl);
							}
							break;
						}
					}
				}
			}

		}
		if (a == 3) {
			details1.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons1.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons1.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons1.get(j).get("WEG")
									.toString()) >= 120.0
									&& Double.valueOf(recons1.get(j).get("WEG")
											.toString()) < 160.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("major", recons1.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons1.get(j).get("WEG")
										.toString()); // 可以添加等级值 属于哪一级
								details1.add(orl);
							}
							break;
						}
					}
				}
			}

		}
		if (a == 4) {
			details1.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons1.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons1.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons1.get(j).get("WEG")
									.toString()) >= 90.0
									&& Double.valueOf(recons1.get(j).get("WEG")
											.toString()) < 120.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("major", recons1.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons1.get(j).get("WEG")
										.toString()); // 可以添加等级值 属于哪一级
								details1.add(orl);
							}
							break;
						}
					}
				}
			}

		}
		if (a == 5) {
			details1.clear();
			for (int i = 0; i < reresult.size(); i++) {
				if (Integer.parseInt(reresult.get(i).get("num").toString()) > 0) {
					for (int j = 0; j < recons1.size(); j++) {
						if (reresult.get(i).get("label").toString()
								.equals(recons1.get(j).get("TDNAME").toString())) {
							if (Double.valueOf(recons1.get(j).get("WEG")
									.toString()) > 0.0
									&& Double.valueOf(recons1.get(j).get("WEG")
											.toString()) < 90.0) {
								List<String> rate = sqlMapClientTemplate
										.queryForList("getTopoV",
												reresult.get(i).get("label")
														.toString());
								HashMap<Object, Object> orl = new HashMap<Object, Object>();
								// orl.put("sum",reresult.get(j).get("num").toString());
								orl.put("sum", reresult.get(i).get("num")
										.toString());
								orl.put("label", reresult.get(i).get("label")
										.toString());
								orl.put("labelname",
										reresult.get(i).get("labelname")
												.toString());
								orl.put("rate", rate.get(0).toString());
								orl.put("major", recons1.get(j).get("MAJOR")
										.toString());
								orl.put("result", recons1.get(j).get("WEG")
										.toString()); // 可以添加等级值 属于哪一级
								details1.add(orl);
							}
							break;
						}
					}
				}
			}

		}

		if (details1.size() == 0) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("sum", "无");
			orl.put("label", "无");
			orl.put("rate", "无");
			orl.put("labelname", "无");
			orl.put("major", "无");
			orl.put("result", "无"); // 可以添加等级值 属于哪一级
			details1.add(orl);

		}
		return details1;
	}

	public String color1()

	{

		// Fylevel();
		String id = "";
		String id1 = "";
		String id2 = "";
		String id3 = "";
		for (int i = 0; i < recons1.size(); i++) {
			if (Double.valueOf(recons1.get(i).get("WEG").toString()) < 90.0) { /*
																			 * if(
																			 * !
																			 * recons
																			 * .
																			 * get
																			 * (
																			 * i
																			 * )
																			 * .
																			 * get
																			 * (
																			 * "TDNAME"
																			 * )
																			 * .
																			 * toString
																			 * (
																			 * )
																			 * .
																			 * equals
																			 * (
																			 * "96C6A91C-1A30-4E4F-9934-1E5DA931C6B0-88237#96C6A91C-1A30-4E4F-9934-1E5DA931C6B0-88363"
																			 * )
																			 * )
																			 * {
																			 */
				if (id == "") {
					String[] a = recons1.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id = sds.get(0).toString();
					id = id + "-->" + sdss.get(0).toString();
				}
				if (id != "") {
					String[] a = recons1.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id = id + "," + sds.get(0).toString();
					id = id + "-->" + sdss.get(0).toString();
				}
			}

			if (Double.valueOf(recons1.get(i).get("WEG").toString()) >= 90.0
					&& Double.valueOf(recons1.get(i).get("WEG").toString()) < 120.0) {
				/*
				 * if(!recons.get(i).get("TDNAME").toString().equals(
				 * "FAD75593-6E83-49DC-9A53-A3DF9EF63A36-07416#8E663D35-8130-4AFC-A233-172A1AFF61C1-01951"
				 * )) {
				 */
				if (id1 == "") {
					String[] a = recons1.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id1 = sds.get(0).toString();
					id1 = id1 + "-->" + sdss.get(0).toString();
				}
				if (id1 != "") {
					String[] a = recons1.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id1 = id1 + "," + sds.get(0).toString();
					id1 = id1 + "-->" + sdss.get(0).toString();
				}
			}

			if (Double.valueOf(recons1.get(i).get("WEG").toString()) >= 120.0
					&& Double.valueOf(recons1.get(i).get("WEG").toString()) < 160.0)

			{
				if (id2 == "") {
					String[] a = recons1.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id2 = sds.get(0).toString();
					id2 = id2 + "-->" + sdss.get(0).toString();
				}
				if (id2 != "") {
					String[] a = recons1.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id2 = id2 + "," + sds.get(0).toString();
					id2 = id2 + "-->" + sdss.get(0).toString();
				}

			}
			if (Double.valueOf(recons1.get(i).get("WEG").toString()) >= 160.0) {
				if (id3 == "") {
					String[] a = recons1.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}
					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id3 = sds.get(0).toString();
					id3 = id3 + "-->" + sdss.get(0).toString();
				}
				if (id3 != "") {
					String[] a = recons1.get(i).get("TDNAME").toString()
							.split("#");
					List<String> sds = sqlMapClientTemplate.queryForList(
							"getToponame", a[0]);
					if (sds.size() == 0) {
						continue;
					}

					List<String> sdss = sqlMapClientTemplate.queryForList(
							"getToponame", a[1]);
					if (sdss.size() == 0) {
						continue;
					}
					id3 = id3 + "," + sds.get(0).toString();
					id3 = id3 + "-->" + sdss.get(0).toString();
				}
			}

		}
		String jGuo = id + "&" + id1 + "&" + id2 + "&" + id3;

		return jGuo;
	}

	// 业务设置、业务生成、业务调整
	public static List<HashMap<Object, Object>> local1 = new ArrayList<HashMap<Object, Object>>();
	public static List<HashMap<Object, Object>> link1 = new ArrayList<HashMap<Object, Object>>();

	public List<HashMap<Object, Object>> birthroutes1(String name, String start,
			String end, int combox) {
		if (recons1.size() == 0) {
			Fylevel1();
		}
		local1.clear();
		link1.clear();
		List<HashMap<Object, Object>> path = new ArrayList<HashMap<Object, Object>>();
		local1 = sqlMapClientTemplate.queryForList("getsbnameaa");

		link1 = sqlMapClientTemplate.queryForList("getsbzbaa");
		int potnum = local1.size();
		double[][] matrixOrigs = new double[potnum][potnum];
		double[][] pressure = new double[potnum][potnum];
		double[][] gj = new double[potnum][potnum];
		double[][] jg = new double[potnum][potnum];
		double[][] level = new double[potnum][potnum];
		for (int i = 0; i < potnum; i++) {
			for (int j = 0; j < potnum; j++) {
				matrixOrigs[i][j] = -1.0;
				pressure[i][j] = 5000.0;
				gj[i][j] = 0.0;
				jg[i][j] = 1.0;
				level[i][j] = 5000.0;
			}
		}

		double[][] potpos = new double[potnum][2];
		for (int i = 0; i < link1.size(); i++) {
			boolean tc = false;
			int a = -1;
			int b = -1;
			for (int j = 0; j < local1.size(); j++) {
				if (link1.get(i).get("NAME_A").toString()
						.equals(local1.get(j).get("S_SBMC").toString())) {
					a = j;
					break;
				}
			}
			for (int j = 0; j < local1.size(); j++) {
				if (link1.get(i).get("NAME_Z").toString()
						.equals(local1.get(j).get("S_SBMC").toString())) {
					b = j;
					break;
				}
			}
			if (a != -1 && b != -1) {
				potpos[a][0] = Double.valueOf(local1.get(a).get("X").toString());
				potpos[a][1] = Double.valueOf(local1.get(a).get("Y").toString());
				potpos[b][0] = Double.valueOf(local1.get(b).get("X").toString());
				potpos[b][1] = Double.valueOf(local1.get(b).get("Y").toString());
				matrixOrigs[a][b] = 0.019 + 0.005 * Math.sqrt(Math.pow(
						(potpos[a][0] - potpos[b][0]), 2)
						+ Math.pow((potpos[a][1] - potpos[b][1]), 2));
				matrixOrigs[b][a] = 0.019 + 0.005 * Math.sqrt(Math.pow(
						(potpos[a][0] - potpos[b][0]), 2)
						+ Math.pow((potpos[a][1] - potpos[b][1]), 2));
				for (int s = 0; s < recons1.size(); s++) {
					if (recons1.get(s).get("TDNAME").toString()
							.equals(link1.get(i).get("LABEL").toString())) {
						tc = true;
						pressure[a][b] = Double.valueOf(recons1.get(s)
								.get("WEG").toString());
						pressure[b][a] = Double.valueOf(recons1.get(s)
								.get("WEG").toString());
						pressure[b][a] = Double.valueOf(recons1.get(s)
								.get("MAJOR").toString());
						pressure[a][b] = Double.valueOf(recons1.get(s)
								.get("MAJOR").toString());
					}
				}
				if (tc == false) {
					pressure[a][b] = 0.0;
					pressure[b][a] = 0.0;
					gj[a][b] = 0.0;
					gj[b][a] = 0.0;
				}
				if (pressure[a][b] == 0.0) {
					level[a][b] = 0.0;
					level[b][a] = 0.0;
				}
				if (pressure[a][b] < 50.0 && pressure[a][b] > 0) {
					level[a][b] = 0.1; // 1.0
					level[b][a] = 0.1;
				}
				if (pressure[a][b] >= 50.0 && pressure[a][b] < 80.0) {
					level[a][b] = 0.2; // 2.0
					level[b][a] = 0.2;
				}
				if (pressure[a][b] >= 80.0 && pressure[a][b] < 150.0) {
					level[a][b] = 0.3; // 3.0
					level[b][a] = 0.3;
				}
				if (pressure[a][b] >= 150.0) // 4.0
				{
					level[a][b] = 0.4;
					level[b][a] = 0.4;
				}

			}
		}
		int qs = 0;
		int zz = 0;
		for (int i = 0; i < local1.size(); i++) // 这个过程可以简化为rowid求解
		{
			if (local1.get(i).get("S_SBMC").toString().equals(start)) {
				qs = i;
			}
			if (local1.get(i).get("S_SBMC").toString().equals(end)) {
				zz = i;
			}
		}
		if (combox == 1) {
			Floyds1.routes(matrixOrigs, pressure, level, gj, qs, zz, combox);
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";
			if (Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("stress", "无");
				mainorl.put("chdelay", "无");
				path.add(mainorl);
			}
			if (!Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyds1.result.get(0).get("mainroute").toString()
						.split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local1.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local1.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("code", maincode);
				mainorl.put("delay", na[1]);
				mainorl.put("stress", "无");
				mainorl.put("chdelay", "0.0");
				path.add(mainorl);
			}
			if (Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("delay", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyds1.result.get(0).get("backuproute")
						.toString().split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local1.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local1.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}
				}
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", "无");
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);
			}
			if (Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}

			if (!Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyds1.result.get(0).get("bypassroute")
						.toString().split("a");
				String bypasspath[] = na[0].split(",");
				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local1.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local1.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", "无");
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
			}
		}
		if (combox == 2) {
			Floyds1.routes(matrixOrigs, pressure, level, gj, qs, zz, combox);
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";

			if (Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("stress", "无");
				mainorl.put("chdelay", "无");
				path.add(mainorl);
			}
			if (!Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyds1.result.get(0).get("mainroute").toString()
						.split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local1.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local1.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("code", maincode);
				mainorl.put("delay", na[1]);
				mainorl.put("stress", na[2]);
				mainorl.put("chdelay", "0.0");
				path.add(mainorl);
			}
			if (Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("delay", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyds1.result.get(0).get("backuproute")
						.toString().split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local1.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local1.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}
				}
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", na[2]);
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);
			}
			if (Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}

			if (!Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyds1.result.get(0).get("bypassroute")
						.toString().split("a");
				String bypasspath[] = na[0].split(",");
				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local1.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local1.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", na[2]);
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
			}
		}
		if (combox == 3) {
			Floyds1.routes(matrixOrigs, pressure, level, gj, qs, zz, combox);
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";

			if (Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("stress", "无");
				mainorl.put("chdelay", "无");
				path.add(mainorl);
			}
			if (!Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyds1.result.get(0).get("mainroute").toString()
						.split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local1.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local1.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				double sfg = Double.valueOf(na[2]);
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("delay", na[1]);
				mainorl.put("stress", Integer.toString((int) sfg));
				mainorl.put("chdelay", "0.0");
				mainorl.put("code", maincode);
				path.add(mainorl);
			}
			if (Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("delay", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyds1.result.get(0).get("backuproute")
						.toString().split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local1.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local1.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}
				}
				double sfg = Double.valueOf(na[2]);
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", Integer.toString((int) sfg));
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);

			}
			if (Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}

			if (!Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyds1.result.get(0).get("bypassroute")
						.toString().split("a");
				String bypasspath[] = na[0].split(",");
				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local1.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local1.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				double sfg = Double.valueOf(na[2]);
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", Integer.toString((int) sfg));
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
			}
		}
		return path;
	}

	public List<HashMap<Object, Object>> birthroutess1(String q, String aeq,
			String beq, int combox) {
		if (recons1.size() == 0) {
			Fylevel1();
		}
		local1.clear();
		link1.clear();
		List<HashMap<Object, Object>> path = new ArrayList<HashMap<Object, Object>>();
		local1 = sqlMapClientTemplate.queryForList("getsbnameaa");
		link1 = sqlMapClientTemplate.queryForList("getsbzbaa");
		int potnum = local1.size();
		double[][] matrixOrigs = new double[potnum][potnum];
		double[][] pressure = new double[potnum][potnum];
		double[][] gj = new double[potnum][potnum];
		double[][] jg = new double[potnum][potnum];
		double[][] level = new double[potnum][potnum];
		for (int i = 0; i < potnum; i++) {
			for (int j = 0; j < potnum; j++) {
				matrixOrigs[i][j] = -1.0;
				pressure[i][j] = 5000.0;
				gj[i][j] = 0.0;
				jg[i][j] = 1.0;
				level[i][j] = 5000.0;
			}
		}

		double[][] potpos = new double[potnum][2];
		for (int i = 0; i < link1.size(); i++) {
			boolean tc = false;
			int a = -1;
			int b = -1;
			for (int j = 0; j < local1.size(); j++) {
				if (link1.get(i).get("NAME_A").toString()
						.equals(local1.get(j).get("S_SBMC").toString())) {
					a = j;
					break;
				}
			}
			for (int j = 0; j < local1.size(); j++) {
				if (link1.get(i).get("NAME_Z").toString()
						.equals(local1.get(j).get("S_SBMC").toString())) {
					b = j;
					break;
				}
			}
			if (a != -1 && b != -1) {
				potpos[a][0] = Double.valueOf(local1.get(a).get("X").toString());
				potpos[a][1] = Double.valueOf(local1.get(a).get("Y").toString()); // 0.156
																					// ms
																					// 收发时延
				potpos[b][0] = Double.valueOf(local1.get(b).get("X").toString());
				potpos[b][1] = Double.valueOf(local1.get(b).get("Y").toString());
				matrixOrigs[a][b] = 0.019 + 0.005 * Math.sqrt(Math.pow(
						(potpos[a][0] - potpos[b][0]), 2)
						+ Math.pow((potpos[a][1] - potpos[b][1]), 2));
				matrixOrigs[b][a] = 0.019 + 0.005 * Math.sqrt(Math.pow(
						(potpos[a][0] - potpos[b][0]), 2)
						+ Math.pow((potpos[a][1] - potpos[b][1]), 2));
				for (int s = 0; s < recons1.size(); s++) {
					if (recons1.get(s).get("TDNAME").toString()
							.equals(link1.get(i).get("LABEL").toString())) {
						tc = true;
						pressure[a][b] = Double.valueOf(recons1.get(s)
								.get("WEG").toString());
						pressure[b][a] = Double.valueOf(recons1.get(s)
								.get("WEG").toString());
						gj[b][a] = Double.valueOf(recons1.get(s).get("MAJOR")
								.toString());
						gj[b][a] = Double.valueOf(recons1.get(s).get("MAJOR")
								.toString());
					}
				}
				if (tc == false) {
					pressure[a][b] = 0.0;
					pressure[b][a] = 0.0;
					gj[b][a] = 0.0;
					gj[a][b] = 0.0;
				}
				if (pressure[a][b] == 0.0) {
					level[a][b] = 0.0;
					level[b][a] = 0.0;
				}
				if (pressure[a][b] < 50.0 && pressure[a][b] > 0) {
					level[a][b] = 0.1; // 1.0
					level[b][a] = 0.1;
				}
				if (pressure[a][b] >= 50.0 && pressure[a][b] < 80.0) {
					level[a][b] = 0.2; // 2.0
					level[b][a] = 0.2;
				}
				if (pressure[a][b] >= 80.0 && pressure[a][b] < 150.0) {
					level[a][b] = 0.3; // 3.0
					level[b][a] = 0.3;
				}
				if (pressure[a][b] >= 150.0) {
					level[a][b] = 0.4; // 4.0
					level[b][a] = 0.4;
				}

			}
		}

		int qs = 0;
		int zz = 0;
		for (int i = 0; i < local1.size(); i++) {
			if (local1.get(i).get("S_SBMC").toString().equals(aeq)) {
				qs = i;
			}
			if (local1.get(i).get("S_SBMC").toString().equals(beq)) {
				zz = i;
			}
		}
		if (combox == 1) {
			Floyds1.routes(matrixOrigs, pressure, level, gj, qs, zz, combox);
			int ii, jj;
			for (ii = 0; ii < gj.length; ii++)
				for (jj = 0; jj < gj.length; jj++) {
					if (gj[ii][ii] != 0)
						System.out.print(ii + " " + jj + "; ");
				}
			System.out.println("*******************done*****************");
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";
			if (Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("chdelay", "无");
				mainorl.put("stress", "无");
				path.add(mainorl);
			}

			if (!Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyds1.result.get(0).get("mainroute").toString()
						.split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local1.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local1.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("delay", na[1]);
				mainorl.put("stress", "无");
				mainorl.put("chdelay", "0.0");
				mainorl.put("code", maincode);
				path.add(mainorl);
				System.out.println("!!!!!!!!!!!mainname: " + mainname);
				System.out.println("!!!!!!!!!!!!!code: " + maincode);
			}
			if (Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("delay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyds1.result.get(0).get("backuproute")
						.toString().split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local1.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local1.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", "无");
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);
				System.out.println("!!!!!!!!!!!backupname: " + backupname);
				System.out.println("!!!!!!!!!!!!!code: " + backupcode);
			}

			if (Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}
			if (!Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyds1.result.get(0).get("bypassroute")
						.toString().split("a");
				String bypasspath[] = na[0].split(",");

				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local1.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local1.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", "无");
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
				System.out.println("!!!!!!!!!!!bypassname: " + bypassname);
				System.out.println("!!!!!!!!!!!!!code: " + bypasscode);
			}
		}
		if (combox == 2) {
			Floyds1.routes(matrixOrigs, pressure, level, gj, qs, zz, combox);
			int ii, jj;
			for (ii = 0; ii < gj.length; ii++)
				for (jj = 0; jj < gj.length; jj++) {
					if (gj[ii][ii] != 0)
						System.out.print(ii + " " + jj + "; ");
				}
			System.out.println("*******************done*****************");
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";

			if (Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				System.out.println("**********************************main: ");
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("chdelay", "无");
				mainorl.put("stress", "无");
				path.add(mainorl);
			}

			if (!Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				System.out.println("%%%%%%%%%%%%%%%%%main: ");
				String na[] = Floyds1.result.get(0).get("mainroute").toString()
						.split("a");
				System.out.println("%%%%%%%%%%%%%%%%%main: "
						+ Floyds1.result.get(0).get("mainroute").toString());
				String mainpath[] = na[0].split(",");
				System.out.println("%%%%%%%%%%%%%%%%%na[0]: " + na[0]);
				System.out.println("%%%%%%%%%%%%%%%%%na[1]: " + na[1]);
				System.out.println("%%%%%%%%%%%%%%%%%mainpath.length: "
						+ mainpath.length);
				for (int i = 0; i < mainpath.length; i++) {
					System.out
							.println("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
					if (i == 0) {
						mainname = local1.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local1.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("delay", na[1]);
				mainorl.put("stress", na[2]);
				mainorl.put("chdelay", "0.0");
				mainorl.put("code", maincode);
				path.add(mainorl);
				System.out.println("!!!!!!!!!!!mainname: " + mainname);
				System.out.println("!!!!!!!!!!!!!code: " + maincode);
			}
			if (Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				System.out
						.println("**********************************backup: ");
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("delay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				System.out.println("%%%%%%%%%%%%%%%%%backup: ");
				String na[] = Floyds1.result.get(0).get("backuproute")
						.toString().split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local1.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local1.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", na[2]);
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);
				System.out.println("!!!!!!!!!!!backupname: " + backupname);
				System.out.println("!!!!!!!!!!!!!code: " + backupcode);
			}

			if (Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				System.out
						.println("**********************************bypass: ");
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}
			if (!Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				System.out.println("%%%%%%%%%%%%%%%%%bypass: ");
				String na[] = Floyds1.result.get(0).get("bypassroute")
						.toString().split("a");
				String bypasspath[] = na[0].split(",");

				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local1.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local1.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", na[2]);
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
				System.out.println("!!!!!!!!!!!bypassname: " + bypassname);
				System.out.println("!!!!!!!!!!!!!code: " + bypasscode);
			}
		}
		if (combox == 3) {
			Floyds1.routes(matrixOrigs, pressure, level, gj, qs, zz, combox);
			int ii, jj;
			for (ii = 0; ii < gj.length; ii++)
				for (jj = 0; jj < gj.length; jj++) {
					if (gj[ii][ii] != 0)
						System.out.print(ii + " " + jj + "; ");
				}
			System.out.println("*******************done*****************");
			String maincode = "";
			String mainname = "";
			String backupcode = "";
			String backupname = "";
			String bypasscode = "";
			String bypassname = "";

			if (Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", "无");
				mainorl.put("route", "主路由");
				mainorl.put("code", "无");
				mainorl.put("delay", "无");
				mainorl.put("chdelay", "无");
				mainorl.put("stress", "无");
				path.add(mainorl);
			}

			if (!Floyds1.result.get(0).get("mainroute").toString()
					.equals("No main route exists!")) {
				String na[] = Floyds1.result.get(0).get("mainroute").toString()
						.split("a");
				String mainpath[] = na[0].split(",");
				for (int i = 0; i < mainpath.length; i++) {
					if (i == 0) {
						mainname = local1.get(Integer.parseInt(mainpath[i]))
								.get("S_SBMC").toString();
						// System.out.println(mainname);
						maincode = local1.get(Integer.parseInt(mainpath[i]))
								.get("EQUIPCODE").toString();
						// System.out.println(maincode);
					}
					if (i > 0) {
						{
							mainname = mainname
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("S_SBMC").toString();
							// System.out.println(mainname);
							maincode = maincode
									+ "-->"
									+ local1.get(Integer.parseInt(mainpath[i]))
											.get("EQUIPCODE").toString();
							// System.out.println(maincode);
						}
					}

				}
				double sfg = Double.valueOf(na[2]);
				HashMap<Object, Object> mainorl = new HashMap<Object, Object>();
				mainorl.put("name", mainname);
				mainorl.put("route", "主路由");
				mainorl.put("delay", na[1]);
				mainorl.put("stress", Integer.toString((int) sfg));
				mainorl.put("chdelay", "0.0");
				mainorl.put("code", maincode);
				path.add(mainorl);
				System.out.println("!!!!!!!!!!!mainname: " + mainname);
				System.out.println("!!!!!!!!!!!!!code: " + maincode);

			}
			if (Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", "无");
				backuporl.put("route", "备用路由");
				backuporl.put("code", "无");
				backuporl.put("chdelay", "无");
				backuporl.put("delay", "无");
				backuporl.put("stress", "无");
				path.add(backuporl);
			}
			if (!Floyds1.result.get(0).get("backuproute").toString()
					.equals("No backup route exists!")) {
				String na[] = Floyds1.result.get(0).get("backuproute")
						.toString().split("a");
				String backuppath[] = na[0].split(",");
				for (int i = 0; i < backuppath.length; i++) {
					if (i == 0) {
						backupname = local1.get(Integer.parseInt(backuppath[i]))
								.get("S_SBMC").toString();
						backupcode = local1.get(Integer.parseInt(backuppath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							backupname = backupname
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("S_SBMC").toString();
							backupcode = backupcode
									+ "-->"
									+ local1.get(Integer.parseInt(backuppath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				double sfg = Double.valueOf(na[2]);

				HashMap<Object, Object> backuporl = new HashMap<Object, Object>();
				backuporl.put("name", backupname);
				backuporl.put("route", "备用路由");
				backuporl.put("code", backupcode);
				backuporl.put("delay", na[1]);
				backuporl.put("stress", Integer.toString((int) sfg));
				backuporl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(backuporl);
				System.out.println("!!!!!!!!!!!backupname: " + backupname);
				System.out.println("!!!!!!!!!!!!!code: " + backupcode);

			}

			if (Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", "无");
				bypassorl.put("route", "迂回路由");
				bypassorl.put("delay", "无");
				bypassorl.put("stress", "无");
				bypassorl.put("chdelay", "无");
				bypassorl.put("code", "无");
				path.add(bypassorl);
			}
			if (!Floyds1.result.get(0).get("bypassroute").toString()
					.equals("No bypass route exists!")) {
				String na[] = Floyds1.result.get(0).get("bypassroute")
						.toString().split("a");
				String bypasspath[] = na[0].split(",");

				for (int i = 0; i < bypasspath.length; i++) {
					if (i == 0) {
						bypassname = local1.get(Integer.parseInt(bypasspath[i]))
								.get("S_SBMC").toString();
						bypasscode = local1.get(Integer.parseInt(bypasspath[i]))
								.get("EQUIPCODE").toString();
					}
					if (i > 0) {
						{
							bypassname = bypassname
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("S_SBMC").toString();
							bypasscode = bypasscode
									+ "-->"
									+ local1.get(Integer.parseInt(bypasspath[i]))
											.get("EQUIPCODE").toString();
						}
					}

				}
				double sfg = Double.valueOf(na[2]);
				HashMap<Object, Object> bypassorl = new HashMap<Object, Object>();
				bypassorl.put("name", bypassname);
				bypassorl.put("route", "迂回路由");
				bypassorl.put("code", bypasscode);
				bypassorl.put("delay", na[1]);
				bypassorl.put("stress", Integer.toString((int) sfg));
				bypassorl.put(
						"chdelay",
						Double.parseDouble(na[1])
								- Double.parseDouble(path.get(0).get("delay")
										.toString()));
				path.add(bypassorl);
				System.out.println("!!!!!!!!!!!bypassname: " + bypassname);
				System.out.println("!!!!!!!!!!!!!code: " + bypasscode);
			}
		}

		return path;
	}

}
