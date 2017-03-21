/**
 * 自愈仿真指标评价实现类
 * 与数据库接口
 */
package indexEvaluation.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import netres.model.ComboxDataModel;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.ibatis.sqlmap.client.SqlMapClient;

import indexEvaluation.model.IndexEvaModel;

/**
 * @author xgyin
 *
 */
public class IndexEvaDAOImpl extends SqlMapClientDaoSupport implements IndexEvaDAO {

	@Override
	public List getSETData(IndexEvaModel model) {
		List<IndexEvaModel> lst = new ArrayList<IndexEvaModel>();
		String time = model.getStarttime();
		String tablename = "index_evaluation";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			if(time==null||"".equals(time)){
				//获取当前最大时间
				time = (String) sqlMap.queryForObject("getMaxTimeByTable", tablename);
				model.setStarttime(time);
			}
			
			lst = sqlMap.queryForList("getSETDataOfBusiness",model);
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return lst;
	}

	@Override
	public List getOperationQualityData(IndexEvaModel model) {
		List<IndexEvaModel> lst = new ArrayList<IndexEvaModel>();
		String time = model.getStarttime();
		String tablename = "operation_quality";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			if(time==null||"".equals(time)){
				//获取当前最大时间
				time = (String) sqlMap.queryForObject("getMaxTimeByTable", tablename);
				model.setStarttime(time);
			}
			
			lst = sqlMap.queryForList("getOperationQualityData",model);
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return lst;
	}

	@Override
	public List getMaintainQualityData(IndexEvaModel model) {
		
		List<IndexEvaModel> lst = new ArrayList<IndexEvaModel>();
		String time = model.getStarttime();
		String tablename = "index_evaluation";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			if(time==null||"".equals(time)){
				//获取当前最大时间
				time = (String) sqlMap.queryForObject("getMaxTimeByTable", tablename);
				model.setStarttime(time);
			}
			
			lst = sqlMap.queryForList("getMaintainQualityData",model);
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return lst;
	}

	@Override
	public List<ComboxDataModel> getDeptLst() {
		return this.getSqlMapClientTemplate().queryForList("getDeptLst");
	}

	@Override
	public List getQualityEvaluationData(IndexEvaModel model) {
		List<IndexEvaModel> lst = new ArrayList<IndexEvaModel>();
		String time = model.getStarttime();
//		String tablename = "index_evaluation";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try {
			sqlMap.startTransaction();
			if(time==null||"".equals(time)){
				//获取当前最大时间
				time = (String) sqlMap.queryForObject("getMaxTimeByTableUnion");
				model.setStarttime(time);
			}
			
			lst = sqlMap.queryForList("getQualityEvaluationData",model);
			sqlMap.commitTransaction();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return lst;
	}

	@Override
	public void setQualityEvaluationData(String id, String first_level,
			String name,String num) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("id", id);
		map.put("name", name);
		map.put("num", num);
		if("通信网络运行质量指标".equals(first_level)){
			map.put("tableName", "operation_quality");
		}else{
			map.put("tableName", "index_evaluation");
		}
		this.getSqlMapClientTemplate().update("setQualityEvaluationData", map);
	}

	@Override
	public void updateBasticData(Map map) {

		this.getSqlMapClientTemplate().update("updateBasticData", map);
	}

	@Override
	public String getIndexValueByMap(Map mp) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getIndexValueByMap", mp);
	}

	@Override
	public void insertIndexValueByMap(Map mp) {

		this.getSqlMapClientTemplate().insert("insertIndexValueByMap", mp);
	}

	@Override
	public void updateIndexValueByMap(Map mp) {

		this.getSqlMapClientTemplate().update("updateIndexValueByMap", mp);
	}

	@Override
	public List<IndexEvaModel> getIndexEvalValueLst(IndexEvaModel model) {
		return this.getSqlMapClientTemplate().queryForList("getIndexEvalValueLst", model);
	}

	@Override
	public String getRESID(String label) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getRESID", label);
	}

	@Override
	public String getMaxTimeByTableUnion() {
		return (String) this.getSqlMapClientTemplate().queryForObject("getMaxTimeByTableUnion");
	}

	@Override
	public String getIndexValueBymap(Map map) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getIndexValueBymap", map);
	}

	@Override
	public void insertIndexValueModel(IndexEvaModel key) {

		String tablename = key.getTablename();
		if("index_evaluation".equals(tablename)){
			this.getSqlMapClientTemplate().insert("insertBusIndexValue",key);
		}else{
			this.getSqlMapClientTemplate().insert("insertQulityIndexValue",key);
		}
	}

	@Override
	public List<String> getIndexEvalNameLst(IndexEvaModel key) {

		List<String> lst = new ArrayList<String>();
		if("index_evaluation".equals(key.getTablename())){
			//业务支撑度指标查找
			lst = this.getSqlMapClientTemplate().queryForList("getIndexEvalNameLst_yewu", key);
		}else{
			lst = this.getSqlMapClientTemplate().queryForList("getIndexEvalNameLst", key);
		}
		return lst;
	}

	@Override
	public void updateIndexEvalModel(IndexEvaModel key) {

		if("index_evaluation".equals(key.getTablename())){
			this.getSqlMapClientTemplate().update("updateIndexEvalModel_yewu", key);
		}else{
			this.getSqlMapClientTemplate().update("updateIndexEvalModel", key);
		}
	}

}
