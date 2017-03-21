package indexEvaluation.model;

import org.apache.commons.logging.LogFactory;
import org.apache.commons.logging.Log;
import org.springframework.jdbc.datasource.ConnectionProxy;

import javax.sql.DataSource;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.Connection;

import com.ibatis.common.jdbc.logging.ConnectionLogProxy;
import com.ibatis.common.beans.ClassInfo;

/**
 * ˵��: �����õ���¼��־��jdbc���ӵ�DataSource����
 * ��ר�Ÿ�JSTL��SQL��ǩ�õ�DataSource
 * ����ʱ��: 2005-4-2 5:50:19
 *
 * @author: WangBei
 */
public class DataSourceLogProxy implements InvocationHandler {

    private DataSource ds;

    private DataSourceLogProxy(DataSource ds) {
        this.ds = ds;
    }

    public Object invoke(Object proxy, Method method, Object[] params) throws Throwable {
        try {
            if ("getConnection".equals(method.getName())) {
                Connection conn = (Connection) method.invoke(ds, params);
                conn = ConnectionLogProxy.newInstance(conn);
                return conn;
            } else {
                return method.invoke(ds, params);
            }
        } catch (Throwable t) {
            throw t;
        }
    }

    /**
     * ����һ�����Լ�¼��־��DataSource����
     */
    public static DataSource newInstance(DataSource ds) {
        InvocationHandler handler = new DataSourceLogProxy(ds);
        ClassLoader cl = DataSource.class.getClassLoader();
        return (DataSource) Proxy.newProxyInstance(cl, new Class[]{DataSource.class}, handler);
    }
}
