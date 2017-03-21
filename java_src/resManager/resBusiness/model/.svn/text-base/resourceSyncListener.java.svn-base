package resManager.resBusiness.model;

import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class resourceSyncListener implements ServletContextListener{

	private Timer timer = null;
	
	@Override
	public void contextDestroyed(ServletContextEvent event) {
		// TODO Auto-generated method stub
		timer.cancel();
	    event.getServletContext().log("定时器销毁");
	}

	public static Date addDay(Date date,int num){
		Calendar  calendar  =  Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(calendar.DAY_OF_MONTH, 1);
		return calendar.getTime();
	} 

	@Override
	public void contextInitialized(ServletContextEvent event) {
		// TODO Auto-generated method stub
		timer = new Timer(true);
	    event.getServletContext().log("资源同步定时器已启动");
	    TimerTask task = new resourceSyncTimer();
	    Calendar  calendar  =  Calendar.getInstance();
		calendar.set(calendar.HOUR_OF_DAY,23);
		calendar.set(calendar.MINUTE,59);
		calendar.set(calendar.SECOND,59);
		Date date = calendar.getTime();
		if(date.before(new Date())){
			date = addDay(date,1);
		}
        timer.schedule(task, date, 1000L*60*60*24);//60分钟执行一次
	}

	
}
