package logintest.dwr;


import logintest.dao.LoginDAO;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import sysManager.user.model.UserModel;




public class LoginDwr {
	
	private final static Log log = LogFactory.getLog(LoginDwr.class);
	
	public LoginDAO loginDao;

	public LoginDAO getLoginDao()
	{
		return this.loginDao;
	}
	public void setLoginDao(LoginDAO loginDao)
	{
		this.loginDao=loginDao;
	}
	
	public LoginDwr() {
		super();
		// TODO Auto-generated constructor stub
	}

	
	public int login(UserModel user)
	{
		UserModel resultuser = this.getLoginDao().login(user);

		if(resultuser != null)
		{

			return 1;
		}
		else
		{
			return 0;
		}
	}
	
	
	
}
