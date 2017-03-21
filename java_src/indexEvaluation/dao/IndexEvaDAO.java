/**
 * 自愈仿真指标评价接口类
 */
package indexEvaluation.dao;

import indexEvaluation.model.IndexEvaModel;

import java.util.List;
import java.util.Map;

import netres.model.ComboxDataModel;

/**
 * @author xgyin
 *
 */
public interface IndexEvaDAO {

	List getSETData(IndexEvaModel model);//查询业务支撑度指标

	List getOperationQualityData(IndexEvaModel model);//查询通信网络运行质量指标

	List getMaintainQualityData(IndexEvaModel model);//查询通信网络运维质量指标

	List<ComboxDataModel> getDeptLst();
	
	List getQualityEvaluationData(IndexEvaModel model);
	
	public void setQualityEvaluationData(String id,String first_level,String name,String num);

	void updateBasticData(Map map);

	void updateIndexValueByMap(Map mp);

	void insertIndexValueByMap(Map mp);

	String getIndexValueByMap(Map mp);

	List<IndexEvaModel> getIndexEvalValueLst(IndexEvaModel model);

	String getRESID(String label);

	String getMaxTimeByTableUnion();

	String getIndexValueBymap(Map map);

	void insertIndexValueModel(IndexEvaModel key);

	List<String> getIndexEvalNameLst(IndexEvaModel key);

	void updateIndexEvalModel(IndexEvaModel key);

}
