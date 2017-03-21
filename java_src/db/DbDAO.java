package db;


import java.util.List;
import java.util.Map;


//数据库通用操作
public interface DbDAO {

    public Object queryForObject(String sqlKey,Object param);
    public List queryForList(String sqlKey,Object param);
    public Map queryForMap(String sqlKey,Object param,String keyProperty);

    public Object insert(String sqlKey,Object param);

    public int update(String sqlKey,Object param);

    public int delete(String sqlKey,Object param);

}