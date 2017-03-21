package messagepush.util;

import flex.messaging.MessageBroker;  
import flex.messaging.messages.AsyncMessage;  
import flex.messaging.util.UUIDUtils;  
public class DaemonMessage {  
    private static FeedThread thread;  
    private static String mans;
    private static String type;
    //开始传递消息  
   
    public void startSendMessage(String person)  
    {   
    	 mans=person;
    	 type="";
    	 if(thread==null)
         {
	        thread = new FeedThread();  
	        thread.start();
         }
      
    }  
    //停止消息发布  
    public void stopSendMessage(String flags)  
    {  
       System.out.println("消息结束");
     
       thread.running=false;  
       thread=null;  
       
    }  
    public static  class FeedThread extends Thread   
    {  
       public boolean running = true;  
       public int i=0;
       public void run() {  
           MessageBroker msgBroker = MessageBroker.getMessageBroker(null);  
           String clientID = UUIDUtils.createUUID();  
           System.out.println("clientID="+clientID);  
           System.out.println("消息开");
           while (running) {  
              //异步消息  
              AsyncMessage msg = new AsyncMessage();  
              msg.setDestination("monitor");  
              msg.setHeader(AsyncMessage.SUBTOPIC_HEADER_NAME,"tick"); 
              msg.setClientId(clientID);  
              msg.setMessageId(UUIDUtils.createUUID());  
              msg.setTimestamp(System.currentTimeMillis());  
              String  flag="1";
              if(type!=null&&!"".equals(type)){
            	  msg.setBody(flag+";;"+mans+";;"+type);  
              }else{
            	  msg.setBody(flag+";;"+mans);  
              }
              msgBroker.routeMessageToService(msg, null);
              ++i;
              try {  
                  Thread.sleep(500);  
              } catch (InterruptedException e) {}}}
       }
    //增加类别属性 用于弹出不同的窗口
    public void startSendMessage(String person,String typename)  
    {   
    	 mans=person;
    	 type=typename;
    	 if(thread==null)
         {
	        thread = new FeedThread();  
	        thread.start();
         }
      
    }
}  


