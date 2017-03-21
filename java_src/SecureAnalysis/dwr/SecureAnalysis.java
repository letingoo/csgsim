package SecureAnalysis.dwr;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;

import tuopu.dao.*;

import java.util.HashMap;
import java.util.List;

import org.apache.activemq.filter.function.inListFunction;
import org.omg.CORBA.PUBLIC_MEMBER;
import org.springframework.orm.ibatis.SqlMapClientTemplate;

import login.dao.LoginDAO;
import tuopu.dao.tuopuDAOImpl;
import channelroute.dwr.ChannelRouteAction;
import channelroute.model.ChannelLink;
import channelroute.model.ChannelPort;
public class SecureAnalysis {
	 private SqlMapClientTemplate sqlMapClientTemplate;

	 
	 public SqlMapClientTemplate getSqlMapClientTemplate() {
	    return sqlMapClientTemplate;
	 }

	 public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	    this.sqlMapClientTemplate = sqlMapClientTemplate;
	 }
public static  List<HashMap<Object, Object>>result= new ArrayList<HashMap<Object, Object>>();
	 public List<HashMap<Object, Object>> equipname()
	 {
		     List<String> equipname=sqlMapClientTemplate.queryForList("getMcname");
		     for(int i=0;i<equipname.size();i++)
		     {
		    	 List<String> ocablename=sqlMapClientTemplate.queryForList("getMcocalble",equipname.get(i).toString());
		    	 
		    	   if(ocablename.size()>0)
		    	   {   
		    			    HashMap<Object, Object> orl = new HashMap<Object, Object>();	    			    
		    			     orl.put("name",equipname.get(i).toString());
		    			     orl.put("num",Integer.toString(ocablename.size()));
		    			     result.add(orl);	 				    		   
		    	   }
		     	   if(ocablename.size()==0)            //如果设备上不承载光缆段 那么直接跳过处理
		    	   {   
		    			       	continue;			    		   
		    	   }	    	 
		     }
		      return result;
	 }
	 
	 public    List<HashMap<Object, Object>>  value(String s,String a,String b)
	 {   
		 DecimalFormat    df   = new DecimalFormat("######0.00");
		 System.out.println("srffwfwfwf"+s);
		 
		 
		 double sbmajor =0.0;
	 double yewu =3.9;
		 double sc=Double.valueOf(b);
		 double fw=Double.valueOf(a);
		 double time=0.0;
		 double va=0.0;
		 if(sc>0&&sc<=2)
		 {
			   time=1.0;
		 }
		 if(sc>2&&sc<=4)
		 {
			   time=1.5;
		 }
		 if(sc>4&&sc<=8)
		 {
			   time=2.0;
		 }
		 if(sc>8&&sc<=12)
		 {
			   time=4.0;
		 }
		 if(sc>12)
		 {
			   time=8.0;
		 }
		   
		 if(s.contains("省调"))
		 {
			 sbmajor=3.09;
		 }
		 else if(s.contains("区调"))
		 {
			 sbmajor=5.8;
		 }
		 else if(s.contains("县局"))
		 {
			 sbmajor=0.73;
		 }
		 else if(s.contains("500kV"))
		 {
			 sbmajor=2.22;
		 }
		 else if(s.contains("220kV"))
		 {
			 sbmajor=1.86;
		 }
		 else if(s.contains("110kV"))
		 {
			 sbmajor=0.97;
		 }
		 else {
			 sbmajor=1.34;
		}
		 List<String> type=sqlMapClientTemplate.queryForList("getMctype",s);
		   String cc="";
		   for(int i=0;i<type.size();i++)
		   {
			     if(i==0)
			     {cc=type.get(i).toString();}
			     else {
			    	 cc=cc+","+type.get(i).toString();
				}		   
		   }
		   System.out.println("wfwf"+cc);
		 if(cc.contains("继电保护"))
		 {
			 yewu=yewu+10.0;
		 }
		 if(cc.contains("安稳业务"))
		 {
			 yewu=yewu+10.0;
		 }
		 if((cc.contains("调度数据网")||cc.contains("调度电话"))&&cc.contains("综合数据网"))
		 {
			 yewu=yewu+7.97;
		 }
		 if((cc.contains("调度数据网")||cc.contains("调度电话"))&&!cc.contains("综合数据网"))
		 {
			 yewu=yewu+7.97;
		 }
		 if(!(cc.contains("调度数据网")||cc.contains("调度电话"))&&cc.contains("综合数据网"))
		 {
			 yewu=yewu+3.9;
		 }
		 va=yewu*time*fw*sbmajor*4;
		 String thing="无事件";
		 if(va<0.15548)
		 {
			 thing="无事件";
		 }
		 if(va>=0.15548&&va<10.4)
		 {
			 thing="八级事件";
		 }
		 if(va>=10.5312&&va<11.9808)
		 {
			 thing="七级事件";
		 }
		 if(va>=13.0&&va<11.9808)
		 {
			 thing="七级事件";
		 }
		 if(va>=10.5312&&va<27.6559)
		 {
			 thing="六级事件";
		 }
		 if(va>=34.97236)
		 {
			 thing="五级事件";
		 }
		 List<HashMap<Object, Object>>  ivi=new ArrayList<HashMap<Object, Object>>();
		 HashMap<Object, Object> orl = new HashMap<Object, Object>();	    			    
	     orl.put("name",s);
	     orl.put("value",df.format(va));
	     orl.put("thing",thing);
	     ivi.add(orl);	 
	    return ivi;
		 
		 
		 
		 
		  //for()
	/*	    List<String> type=sqlMapClientTemplate.queryForList("getMctype");
		      s.get(0).get("name").toString();   */   
		 
	 }
	 
	 public    List<HashMap<Object, Object>>  ocable(String s)
	 {   List<HashMap<Object, Object>> sg= new ArrayList<HashMap<Object,Object>>();
		 System.out.println("liqnming"+s);
		 List<String> mds=sqlMapClientTemplate.queryForList("getMcocalble",s);	  
		 for(int i=0;i<mds.size();i++)
		 {
			  HashMap<Object, Object> orl = new HashMap<Object, Object>();	    			    
			     orl.put("name",s);
			     orl.put("ocable",mds.get(i).toString());
			     sg.add(orl);	    			    
		 }
/*		  String code="";
	      for(int i=0;i<result.size();i++)
	      {
	    	    if(s==result.get(i).get("name").toString())
	    	    {
	    	    	code=result.get(i).get("ocable").toString();	  
	    	    }
	    	break;
	      }
	      System.out.println("linan"+code);
	          String[] a=code.split(",");
		      for(int j=0;j<a.length;j++)
		      {
		    	  HashMap<Object, Object> orl = new HashMap<Object, Object>();	    			    
 			     orl.put("name",s);
 			     orl.put("ocable",a[j]);
 			     sg.add(orl);	    
		      }*/
		      return sg;		 
	 }	 
}