/**
 * 自愈仿真评价模型
 */
package indexEvaluation.model;

import indexEvaluation.dwr.BaseForm;

/**
 * @author xgyin
 *
 */
public class IndexEvaModelForm extends BaseForm{

	private String id;
	private String type;
	private String name;
	private String value;
	private String unit;
	private String no;
	
	private String dept;
	
	private String network;
	private String relateType;//相关类型
	private String self_healing_value;//自愈值
	private String weight;//权重
	private String first_level;
	private String score;//专家打分值
	
	private String start;//查询开始
	private String end;//总共查询数目
	private String sort;//排序字段
	private String dir;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public String getNo() {
		return no;
	}
	public void setNo(String no) {
		this.no = no;
	}
	public String getStart() {
		return start;
	}
	public void setStart(String start) {
		this.start = start;
	}
	public String getEnd() {
		return end;
	}
	public void setEnd(String end) {
		this.end = end;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}
	public String getDir() {
		return dir;
	}
	public void setDir(String dir) {
		this.dir = dir;
	}
	public String getNetwork() {
		return network;
	}
	public void setNetwork(String network) {
		this.network = network;
	}
	public String getDept() {
		return dept;
	}
	public void setDept(String dept) {
		this.dept = dept;
	}
	public String getRelateType() {
		return relateType;
	}
	public void setRelateType(String relateType) {
		this.relateType = relateType;
	}
	public String getSelf_healing_value() {
		return self_healing_value;
	}
	public void setSelf_healing_value(String self_healing_value) {
		this.self_healing_value = self_healing_value;
	}
	public String getWeight() {
		return weight;
	}
	public void setWeight(String weight) {
		this.weight = weight;
	}
	public String getFirst_level() {
		return first_level;
	}
	public void setFirst_level(String first_level) {
		this.first_level = first_level;
	}
	public String getScore() {
		return score;
	}
	public void setScore(String score) {
		this.score = score;
	}
}
