package tuopu.dao;
import java.util.*;
public interface tuopuDAO {
public List<String>getEqName(String sysname);
public List<HashMap<Object,Object>>getNbmc(Object obj);
public List<HashMap<Object,Object>>getRep(Object obj);

public List<HashMap<Object,Object>>getOp();
public  List<String>getID(String name);

 }