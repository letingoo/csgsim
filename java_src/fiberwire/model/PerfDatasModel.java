package fiberwire.model;

public class PerfDatasModel {
	public String name_en;// 性能参数的英文名称
	public String pf_time;// 采集时刻
	public String pf_value;// 性能的数据结果
	public String pf_unit;// 性能数据单位
    public String pf_valueiop;//输入结果
    public String pf_valueoop;//输出结果
    
	public String getPf_valueiop() {
		return pf_valueiop;
	}  

	public void setPf_valueiop(String pfValueiop) {
		pf_valueiop = pfValueiop;
	}

	public String getPf_valueoop() {
		return pf_valueoop;
	}

	public void setPf_valueoop(String pfValueoop) {
		pf_valueoop = pfValueoop;
	}

	public String getName_en() {
		return name_en;
	}

	public void setName_en(String name_en) {
		this.name_en = name_en;
	}

	public String getPf_time() {
		return pf_time;
	}

	public void setPf_time(String pf_time) {
		this.pf_time = pf_time;
	}

	public String getPf_value() {
		return pf_value;
	}

	public void setPf_value(String pf_value) {
		this.pf_value = pf_value;
	}

	public String getPf_unit() {
		return pf_unit;
	}

	public void setPf_unit(String pf_unit) {
		this.pf_unit = pf_unit;
	}
}
