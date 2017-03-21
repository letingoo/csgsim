package topolink.dwr;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
//以无向图G为入口，得出任意两点之间的路径长度length[i][j]，路径path[i][j][k]，
//途中无连接得点距离用-1表示，点自身也用0表示
public class Floyds1 {
	double[][] length = null;// 任意两点之间路径长度
	int[][][] path = null;// 任意两点之间的路径
	private static int max = Integer.MAX_VALUE;

	public Floyds1(double[][] G) {
		int row = G.length;// 图G的行数
		int[][] spot = new int[row][row];// 定义任意两点之间经过的点
		int[] onePath = new int[row];// 记录一条路径
		length = new double[row][row];
		path = new int[row][row][];
		for (int i = 0; i < row; i++){
			// 处理图两点之间的路径
			for (int j = 0; j < row; j++) {
				if (G[i][j] == -1){
					G[i][j] = max;// 没有路径的两个点之间的路径为默认最大
				}
				if (i == j)
					G[i][j] = max;// 本身的路径长度为0
			}
		}
		for (int i = 0; i < row; i++)
			// 初始化为任意两点之间没有路径
			for (int j = 0; j < row; j++)
				spot[i][j] = -1;
		for (int i = 0; i < row; i++)
			// 假设任意两点之间的没有路径
			onePath[i] = -1;
		for (int v = 0; v < row; ++v)
			for (int w = 0; w < row; ++w)
				length[v][w] = G[v][w];
		for (int u = 0; u < row; ++u){
			for (int v = 0; v < row; ++v){
				for (int w = 0; w < row; ++w){
					if (length[v][w] > length[v][u] + length[u][w]) {
						length[v][w] = length[v][u] + length[u][w];// 如果存在更短路径则取更短路径
						spot[v][w] = u;// 把经过的点加入
					}
				}
			}
		}
		for (int i = 0; i < row; i++) {// 求出所有的路径
			int[] point = new int[1];
			for (int j = 0; j < row; j++) {
				point[0] = 0;
				onePath[point[0]++] = i;//i到j的路径，初始节点为i
				outputPath(spot, i, j, onePath, point);
				path[i][j] = new int[point[0]];
				for (int s = 0; s < point[0]; s++)
					path[i][j][s] = onePath[s];
			}
		}
	}

	void outputPath(int[][] spot, int i, int j, int[] onePath, int[] point) {// 输出i//
																				// 到j//
																				// 的路径的实际代码，point[0]记录一条路径的长度
		if (i == j)
			return;
		if (spot[i][j] == -1)
			onePath[point[0]++] = j;
		// System.out.print(" "+j+" ");
		else {
			outputPath(spot, i, spot[i][j], onePath, point);
			outputPath(spot, spot[i][j], j, onePath, point);
		}
	}

	public void free(double a[][]){
//		path = null;
//		length = null;
		 int i,j,k;
		 for(i=0;i<a.length;i++){
		 	for(j=0;j<a.length;j++){
		 		length[i][j]=0;
		 		for(k=0;k<path[i][j].length;k++){
		 			path[i][j][k]=-1;
		 		}
		 	}
		 }
	}
	
	public static void read_delay(double delay[][]){
		int index = 0;
//		String filename = "F:/Flex_project/calculation/src/paper/delay.txt";
		String filename = "E:/delay.txt";
        File file = new File(filename);
        String tempstr;
        String[] temp;
        BufferedReader reader = null;
        try{
            reader = new BufferedReader(new FileReader(file));
            while((tempstr=reader.readLine())!=null){
                temp=tempstr.split(" ");
//                System.out.println(tempstr);
                for(int i=0;i<temp.length;i++){
                	delay[index][i] = Double.parseDouble(temp[i]);
                }
                index++;
            }
            reader.close();
        }catch(IOException e){
            e.printStackTrace();
        }
	}
	
	public static void read_level(double level[][]){
		int index = 0;
//		String filename = "F:/Flex_project/calculation/src/paper/level.txt";
		String filename = "E:/level.txt";
        File file_0 = new File(filename);
        String tempstr;
        String[] temp;
        BufferedReader reader = null;
        try{
            reader = new BufferedReader(new FileReader(file_0));
            while((tempstr=reader.readLine())!=null){
                temp=tempstr.split(" ");
//                System.out.println(tempstr);
                for(int i=0;i<temp.length;i++){
                	level[index][i] = Double.parseDouble(temp[i]);
                }
                index++;
            }
            reader.close();
        }catch(IOException e){
            e.printStackTrace();
        }
	}
	
	public static void read_pressure(double pressure[][]){
		int index = 0;
//		String filename = "F:/Flex_project/calculation/src/paper/pressure.txt";
		String filename = "E:/pressure.txt";
        File file_1 = new File(filename);
        String tempstr;
        String[] temp;
        BufferedReader reader = null;
        try{
            reader = new BufferedReader(new FileReader(file_1));
            while((tempstr=reader.readLine())!=null){
                temp=tempstr.split(" ");
//                System.out.println(tempstr);
                for(int i=0;i<temp.length;i++){
                	pressure[index][i] = Double.parseDouble(temp[i]);
                }
                index++;
            }
            reader.close();
        }catch(IOException e){
            e.printStackTrace();
        }
	}

	public static void bubblesort(double a[],int old_index[]){
		double temp;
		for(int i=0;i<a.length;i++){
			old_index[i]=i;
		}
		
		for(int i=0;i<a.length;i++){
			for(int j=i+1;j<a.length;j++){
				// System.out.println("i:"+old_index[i]);
				// System.out.println("j:"+old_index[j]);

				if(a[i]>a[j]){
					temp=a[i];
					a[i]=a[j];
					a[j]=temp;
					temp=old_index[i];
					old_index[i]=old_index[j];
					old_index[j]=(int) temp;
				}
			}
		}
	}

	public  static	List<HashMap<Object,Object>> result =new ArrayList<HashMap<Object,Object>>();
	public static void routes(double[][] a,double[][] b,double[][] c,double[][] crit,int  d,int e,int combox)
	   {   result.clear();      
			double[][] delay = a;
			double[][] pressure = b;
			double[][] level =c;
//		int i = 10;
//		int j = 36;	
		// int i = d;
		// int j = e;	
			calroute(delay,pressure,level,crit,d,e,combox);
			// calroute(a,c,b,d,e,combox);
		}

	public static void calroute(double a[][],double b[][],double c[][],double crit[][],int i,int j,int combox) {//a:delay,b:pressuew,c:level/
		int k,m,n,index_i,index_j;
		double delay_weight,channel_weight,crit_weight;
		int realnum=0;//实际拥有的候选路径数目，取值为0-5
		int num = 5;
//		double bypass_delay;
		int[][] respath = new int[num][a.length];
		double[] reslen = new double[num];
		int main_route[],backup_route[],bypass_route[];
		String mainroute,backuproute,bypassroute;
		double mainroute_press,backuproute_press,bypassroute_press;
		double main_delay,backup_delay,bypass_delay;
		
		if(i==j){
			mainroute = "No main route exists!";
			backuproute = "No backup route exists!";
			bypassroute = "No bypass route exists!";
			System.out.println(i+"&&&"+j);
			System.out.println(mainroute+"&&&1");
			System.out.println(backuproute+"&&&2");
			System.out.println(bypassroute+"&&&3");
	   	    HashMap<Object, Object> orl = new HashMap<Object, Object>();
	        orl.put("mainroute",mainroute);
	        orl.put("backuproute",backuproute);
	        orl.put("bypassroute",bypassroute);    
	        result.add(orl);
			return;
		}
		
		for (m = 0; m < a.length; m++){
			for (n = m; n < a.length; n++){
				if (a[m][n] != a[m][n]){
					System.out.println(m+" "+n+" "+a[m][n]+"   "+a[n][m]);
//					return;
				}
			}
		}
		
		for(int l=0;l<num;l++){//先考虑时延因素筛选出num条候选路径
			Floyds test = new Floyds(a);
			if(test.length[i][j] >= max){
				break;
			}
			else{
				realnum++;
			}
			for(k=0;k<test.path[i][j].length; k++){
				respath[l][k] = test.path[i][j][k];
				System.out.print(test.path[i][j][k] + " ");
			}
			reslen[l] = test.length[i][j]; 

			System.out.println();
			System.out.println("From " + i + " to " + j + " length :"+ test.length[i][j]);
			
			for(m=0;m<respath[l].length-1;m++){
				a[respath[l][m]][respath[l][m+1]] = -1;
			}

			test.free(a);
		}

		double channel_pressure[] = new double[realnum];
		for(k=0;k<realnum;k++){//然后计算realnum条候选路径的通道压力值
			channel_pressure[k] = index_i = index_j = 0;
			for(m=0;m<respath[k].length-1;m++){
				index_i = respath[k][m];
				index_j = respath[k][m+1];
				channel_pressure[k] += b[index_i][index_j]*c[index_i][index_j];
				if(index_j==j){
					break;//到达了目的端j!
				}
				if(index_i==0 && index_j==0){
					channel_pressure[k] = max;
					break;//开始节点0的后面节点全部为默认值0！说明本路径不存在！
				}
			}
		}

		int crit_business[] = new int[realnum];
		for(k=0;k<realnum;k++){//最后计算每条候选路径的关键业务数量
			crit_business[k] = index_i = index_j = 0;
			for (m=0;m<respath[k].length-1;m++) {
				index_i = respath[k][m];
				index_j = respath[k][m+1];
				crit_business[k] +=  crit[index_i][index_j];
				if(index_j==j){
					break;//到达了目的端j!
				}
				if(index_i==0 && index_j==0){
					crit_business[k]=max;
					break;//开始节点0的后面节点全部为默认值0！说明本路径不存在！
				}                                                                                                                                      
			}
		}

		main_delay=backup_delay=bypass_delay=-1;
		main_route = backup_route = bypass_route = null;
		delay_weight = channel_weight = crit_weight = 0;
		double final_weight[] = new double[realnum]; 
		if(combox==1){
			delay_weight=3.0;
			channel_weight=2.0;
			crit_weight=1.0;
		}
		if(combox==2){
			delay_weight=2.0;
			channel_weight=3.0;
			crit_weight=1.0;
		}
		if(combox==3){
			delay_weight=2.0;
			channel_weight=1.0;
			crit_weight=100.0;
		}

		for(k=0;k<realnum;k++){
			final_weight[k] = reslen[k]*delay_weight + channel_pressure[k]*channel_weight + crit_business[k]*crit_weight;
			System.out.println("delay："+reslen[k]+",,,channel_pressure："+channel_pressure[k]+",,,critical_business："+crit_business[k]);
			// System.out.println("K::"+final_weight[k]+",,,,"+reslen[k]+",,,,"+channel_pressure[k]+",,,,"+crit_business[k]);
		}

		int old_index[] = new int[realnum];

		bubblesort(final_weight,old_index);

		if(realnum>=1){
			main_route = respath[old_index[0]];
			main_delay = reslen[old_index[0]];
			System.out.println("The old index is "+old_index[0]+",The final_weight is :"+final_weight[0]);
			if(realnum>=2){
				backup_route = respath[old_index[1]];
				backup_delay = reslen[old_index[1]];
				System.out.println("The old index is "+old_index[1]+",The final_weight is :"+final_weight[1]);
				if(realnum>=3){
					bypass_route = respath[old_index[2]];
					bypass_delay = reslen[old_index[2]];
					System.out.println("The old index is "+old_index[2]+",The final_weight is :"+final_weight[2]);
				}
			}
		}


		// if(respath[0][0]!=respath[0][1]){
		// 	main_route = respath[0];//领接矩阵用max表示无路径，但是当获取的路径数num大于真正存在的路径时，respath中会出先0,0,0,0,0,0...这类数组
		// 	main_delay = reslen[0];
		// }
		
		// if(respath[1][0]!=respath[1][1]){
		// 	backup_route = respath[1];//领接矩阵用max表示无路径，但是当获取的路径数num大于真正存在的路径时，respath中会出先0,0,0,0,0,0...这类数组
		// 	backup_delay = reslen[1];
		// }
		
		// if(respath[2][0]!=respath[2][1]){
		// 	bypass_route = respath[2];//领接矩阵用max表示无路径，但是当获取的路径数num大于真正存在的路径时，respath中会出先0,0,0,0,0,0...这类数组
		// 	bypass_delay = reslen[2];
		// }
		
		
		mainroute_press=backuproute_press=bypassroute_press=-1;
		mainroute = backuproute = bypassroute = "";
		if(main_route==null){
			mainroute = "No main route exists!";
		}
		else{
			for(k=0;k<main_route.length;k++){
				mainroute += main_route[k];
				if(main_route[k]==j){
					break;
				}
				else{
					mainroute += ",";
				}
			}
			mainroute += "a"+String.valueOf(main_delay);
			mainroute_press = channel_pressure[old_index[0]];
			mainroute += "a"+String.valueOf(mainroute_press);
		}
		
		if(backup_route==null){
			backuproute = "No backup route exists!";
		}
		else{
			for(k=0;k<backup_route.length;k++){
				backuproute += backup_route[k];
				if(backup_route[k]==j){
					break;
				}
				else{
					backuproute += ",";
				}
			}
			backuproute += "a"+String.valueOf(backup_delay);
			backuproute_press = channel_pressure[old_index[1]];
			backuproute += "a"+String.valueOf(backuproute_press);
		}
		
		if(bypass_route==null){
			bypassroute = "No bypass route exists!";
		}
		else{
			for(k=0;k<bypass_route.length;k++){
				bypassroute += bypass_route[k];
				if(bypass_route[k]==j){
					break;
				}
				else{
					bypassroute += ",";
				}
			}
			bypassroute += "a"+String.valueOf(bypass_delay);
			bypassroute_press = channel_pressure[old_index[2]];
			bypassroute += "a"+String.valueOf(bypassroute_press);
		}
		System.out.println("The main route is: "+mainroute);
		System.out.println("The backup route is: "+backuproute);
		System.out.println("The bypass route is: "+bypassroute);
			
   	    HashMap<Object, Object> orl = new HashMap<Object, Object>();
        orl.put("mainroute",mainroute);
        orl.put("mainroute_press",String.valueOf(mainroute_press));
        orl.put("backuproute",backuproute);
        orl.put("backuproute_press",String.valueOf(backuproute_press));
        orl.put("bypassroute",bypassroute);
        orl.put("bypassroute_press",String.valueOf(bypassroute_press)); 
        result.add(orl);
	}
	
	// public static void main(String args[]){
	// 	double[][] delay = new double[5][5];
	// 	double[][] level = new double[5][5];
	// 	double[][] pressure = new double[5][5];
	// 	int combox,i,j;
	// 	combox=1;
	// 	i=1;
	// 	j=2;
	// 	read_delay(delay);
	// 	read_pressure(pressure);
	// 	read_level(level);
	// 	calroute(delay,pressure,level,i,j,combox);

	// }
}