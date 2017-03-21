package indexEvaluation.model;

import org.springframework.context.ApplicationContextAware;
import org.springframework.context.ApplicationContext;
import org.springframework.beans.BeansException;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.jdbc.CannotGetJdbcConnectionException;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import javax.sql.DataSource;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 说明: 将WebApplicationContext封装在一个singleton类中, 使得原有代码可以方便的调用.
 * 虽然没有使用IoC模式, 但是却可以最大限度的保留原来代码的结构.
 * 建立时间: 2005-4-2 3:39:34
 *
 * @author WangBei
 */
public class SpringContextUtils implements ApplicationContextAware, Map {
    private static final Log log = LogFactory.getLog(SpringContextUtils.class);
    public static final String LOG_DATA_SOURCE="logDataSource";
    public static final String DATA_SOURCE="dataSource";
    public static final String SECURITY_DATA_SOURCE="securityDataSource";
    public static final String TRANSFER_DATA_SOURCE="transferDataSource";
    public static final String REPORT_DATA_SOURCE="reportDataSource";

    private static ApplicationContext applicationContext;

    /** 单例模式的实现.
     *  虽然applicationContext已经是静态全局唯一的了, 但是这是singleton的标准实现,
     *  此外要实现Map接口, 达到JSTL调用的目的, 也必须这么做.
     */
    private static final SpringContextUtils instance = new SpringContextUtils();

    /** 得到全局唯一的实例.
     * 　这个方法会被spring通过factory-method设置自动调用,
     * 　从而实现spring管理的singleton和普通singleton的共用.
     */
    public static SpringContextUtils instance() {
        return instance;
    }

    /** 防止初始化 **/
    private SpringContextUtils() {}

    /** ApplicationContextAware的接口, 由spring调用 **/
    public void setApplicationContext(ApplicationContext _applicationContext) throws BeansException {
        applicationContext = _applicationContext;
    }

    /** 得到spring的context对象 **/
    public ApplicationContext getContext() {
        return applicationContext;
    }

    /** 便捷方法, 可以得到spring管理的bean **/
    public static Object getBean(String beanName) {
        return applicationContext.getBean(beanName);
    }

    /** 得到链接的方法, 如果log处于debug模式, 则得到Log连接, 否则得到的仍然是普通连接. */
    public static Connection getConnection() {
        try {
//            TestRunTimeUtil timeUtil = new TestRunTimeUtil();
            Connection conn = DataSourceUtils.getConnection((DataSource) getBean(DATA_SOURCE));
//            if(log.isDebugEnabled()) return com.ibatis.common.jdbc.logging.ConnectionLogProxy.newInstance(conn);
            conn = com.ibatis.common.jdbc.logging.ConnectionLogProxy.newInstance(conn);
//            System.out.println("SpringContextUtils.getConnection() cost " + timeUtil.getElapseTimeStandardFormat());
            return conn;
        } catch(CannotGetJdbcConnectionException e) {
            log.error("由数据源获取连接失败:" + e.getMessage());
            if(log.isDebugEnabled()) e.printStackTrace();
            throw e;
        }
    }

    /** 得到链接的方法, 如果log处于debug模式, 则得到Log连接, 否则得到的仍然是普通连接. */
    public static Connection getConnection(String DataSourceName) {
        try {
            Connection conn = DataSourceUtils.getConnection((DataSource) getBean(DataSourceName));
//            if(log.isDebugEnabled())
                return com.ibatis.common.jdbc.logging.ConnectionLogProxy.newInstance(conn);
//            return conn;
        } catch(CannotGetJdbcConnectionException e) {
            log.error("由数据源获取连接失败:" + e.getMessage());
            if(log.isDebugEnabled()) e.printStackTrace();
            throw e;
        }
    }
    
  //更改释放链接方法：zhhuang
    public static void closeConnection(Connection conn) {
        DataSourceUtils.releaseConnection(conn, (DataSource) getBean(DATA_SOURCE));
    }

    public static void closeConnection(Connection conn, Statement stmt) {
        closeConnection(conn, stmt, null);
    }

    ///这个方法应该是会实际删除一个数据库联接，比较消耗资源，建议少用；add comment by tyh,071113
    public static void closeConnection(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null){
                rs.close();
            }
            if (stmt != null){
                stmt.close();
            }
        } catch (SQLException e) {
            log.error("关闭结果集或语句失败:", e);
        }
        DataSourceUtils.releaseConnection(conn, (DataSource) getBean(DATA_SOURCE));
    }
    /** 这是专门给JSTL的SQL标签用的DataSource **/
    public DataSource getLogDataSource() {
        try {
            DataSource ds = (DataSource) getBean(DATA_SOURCE);
            return DataSourceLogProxy.newInstance(ds);
        } catch (RuntimeException e) {
            log.error("数据源尚未建立, 请检查spring配置文件和数据库连接.");
            throw e;
        }
    }

    /** 让JSTL方便调用的封装. 为了达到目的, 必须实现Map接口, 所以拖了一长串. **/
    public Object get(Object beanName) {
        if(beanName.equals(LOG_DATA_SOURCE)) return getLogDataSource();
        return applicationContext.getBean((String) beanName);
    }
    public int size() { return 0; }
    public void clear() { }
    public boolean isEmpty() { return false; }
    public boolean containsKey(Object key) { return false; }
    public boolean containsValue(Object value) { return false; }
    public Collection values() { return null; }
    public void putAll(Map t) { }
    public Set entrySet() { return null; }
    public Set keySet() { return null; }
    public Object remove(Object key) { return null; }
    public Object put(Object key, Object value) { return null; }
}
