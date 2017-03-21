package com;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

/**
 * Created by IntelliJ IDEA.
 * User: gaolei
 * Date: 2010-4-26
 * Time: 16:13:33
 *  str  judgeStr returnStr
 */
public class ReadFile { 
	public ReadFile() {} 
	/** 
	* 删除某个文件夹下的所有文件夹和文件 
	* @param delpath String 
	* @throws FileNotFoundException 
	* @throws IOException 
	* @return boolean 
	*/ 
	public static boolean deletefile(String delpath) throws FileNotFoundException, 
	IOException { 
	try { 

	File file = new File(delpath); 
	if (!file.isDirectory()) { 
		file.delete(); 
	} 
	else if (file.isDirectory()) { 
		System.out.println("2"); 
		String[] filelist = file.list(); 
	for (int i = 0; i < filelist.length; i++) { 
		File delfile = new File(delpath + "\\" + filelist[i]); 
	if (!delfile.isDirectory()) { 
		delfile.delete(); 
	} 
	else if (delfile.isDirectory()) { 
		deletefile(delpath + "\\" + filelist[i]); 
	} 
	} 
	} 

	} 
	catch (FileNotFoundException e) { 
	System.out.println("deletefile() Exception:" + e.getMessage()); 
	} 
	return true; 
	} 
	/** 
	* 删除某个文件夹下的所有文件夹和文件 
	* @param delpath String 
	* @throws FileNotFoundException 
	* @throws IOException 
	* @return boolean 
	*/ 
	public static boolean readfile(String filepath) throws FileNotFoundException, 
	IOException { 
	try { 

	File file = new File(filepath); 
	if (!file.isDirectory()) { 
	} 
	else if (file.isDirectory()) { 
		//System.out.println("文件夹"); 
		String[] filelist = file.list(); 
		for (int i = 0; i < filelist.length; i++) { 
		File readfile = new File(filepath + "\\" + filelist[i]); 
		if (!readfile.isDirectory()) { 
	} 
	else if (readfile.isDirectory()) { 
		readfile(filepath + "\\" + filelist[i]); 
	} 
	} 

	} 
	} 
	catch (FileNotFoundException e) { 
		System.out.println("readfile() Exception:" + e.getMessage()); 
	} 
	return true; 
	} 
	}
