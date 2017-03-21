package db;

import java.util.Properties;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.FileOutputStream;

/**
 * Created by IntelliJ IDEA.
 * User: gaolei
 * Date: 2010-4-9
 * Time: 14:20:55
 * To change this template use File | Settings | File Templates.
 */
public class GetAndSetProperty {
     /**
     *取得对应KEY的属性值
     *@param 路径path String
     *@param 关键字propertyName String
     *@return 关键字对应的属性值 String
     */
    public static String getPropertyValue(String path,String propertyName){
        String propertyValue = "";
        Properties prop = new Properties();
        try{
            FileInputStream in = new FileInputStream(path);
            prop.load(in);
            propertyValue = prop.getProperty(propertyName);
            in.close();
        }
        catch(FileNotFoundException e){
            System.out.println("没有提供的属性文件！");
            e.printStackTrace();
        }
        catch(IOException e){
            System.out.println("读取属性文件有误，请检查属性文件！");
            e.printStackTrace();
        }
        return propertyValue;
    }

    /**
     *修改对应KEY的属性值
     *@param 路径path String
     *@param 关键字propertyName String
     *@param 关键字对应的属性值 String
     *@return void
     */
    public static void setPorpertyValue(String path,String porpertyName,
                                        String porpertyValue){
        Properties prop = new Properties();
        try{
            FileInputStream in = new FileInputStream(path);
            prop.load(in);
            prop.setProperty(porpertyName,porpertyValue);
            in.close();
            FileOutputStream out = new FileOutputStream(path);
            prop.store(out,null);
            out.close();
        }
        catch(FileNotFoundException e){
            System.out.println("没有提供的属性文件！");
            e.printStackTrace();
        }
        catch(IOException e){
            System.out.println("存取属性文件有误，请检查属性文件！");
            e.printStackTrace();
        }
    }
}
