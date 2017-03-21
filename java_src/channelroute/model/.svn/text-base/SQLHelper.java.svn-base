package channelroute.model;
import java.sql.*;

/**
 * SQL帮助类
 * 
 * @author 
 * 
 */
public class SQLHelper {
	/**
	 * 关闭结果集
	 * 
	 * @param result 结果集
	 * @return 关闭结果
	 */
	public static boolean close(ResultSet result) {
		boolean closed = false;
		if (result != null) {
			try {
				result.close();
				closed = true;
			}
			catch (SQLException ignore) {
			}
		}
		return closed;
	}

	/**
	 * 关闭声明
	 * 
	 * @param statement 声明
	 * @return 关闭结果
	 */
	public static boolean close(Statement statement) {
		boolean closed = false;
		if (statement != null) {
			try {
				statement.close();
				closed = true;
			}
			catch (SQLException ignore) {
			}
		}
		return closed;
	}

	/**
	 * 关闭连接
	 * 
	 * @param connection 连接
	 * @return 关闭结果
	 */
	public static boolean close(Connection connection) {
		boolean closed = false;
		if (connection != null) {
			try {
				connection.close();
				closed = true;
			}
			catch (SQLException ignore) {
			}
		}
		return closed;
	}


}
