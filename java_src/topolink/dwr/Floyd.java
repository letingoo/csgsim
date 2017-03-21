package topolink.dwr;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

//以无向图G为入口，得出任意两点之间的路径长度length[i][j]，路径path[i][j][k]，
//途中无连接得点距离用0表示，点自身也用0表示
public class Floyd {
	double[][] length = null;// 任意两点之间路径长度
	int[][][] path = null;// 任意两点之间的路径
	private static int max = Integer.MAX_VALUE;

	public Floyd(double[][] G) {
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
		String filename = "F:/Flex_project/calculation/src/delay.txt";
        File file = new File(filename);
        String tempstr;
        String[] temp;
        BufferedReader reader = null;
        try{
            reader = new BufferedReader(new FileReader(file));
            while((tempstr=reader.readLine())!=null){
                temp=tempstr.split(" ");
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
		String filename = "F:/Flex_project/calculation/src/level.txt";
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
		String filename = "F:/Flex_project/calculation/src/pressure.txt";
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
	
	public  static	List<HashMap<Object,Object>> result =new ArrayList<HashMap<Object,Object>>();
    public static void route(double[][] a,double[][] b,double[][] c,int  d,int e)
   {   result.clear();      
		double[][] delay = a;
		double[][] level = b;
		double[][] pressure =c;
//	int i = 10;
//	int j = 36;	
	int i = d;
	int j = e;	
		calroute(delay,pressure,level,i,j);
	}

	public static void calroute(double a[][],double b[][],double c[][],int i,int j) {
		int k,m,n,index_i,index_j,minpressure,minindex,bypass_index;
		int num = 5;
//		double bypass_delay;
		int[][] respath = new int[num][a.length];
		double[] reslen = new double[num];
		int main_route[],backup_route[],bypass_route[];
		String mainroute,backuproute,bypassroute;
		String mainroute_press,backuproute_press,bypassroute_press;
		double main_delay,backup_delay,bypass_delay,main_press,backup_press,bypass_press;
		
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
		        orl.put("mainroute_press","无");
		        orl.put("backuproute",backuproute);
		        orl.put("backuproute_press","无");
		        orl.put("bypassroute",bypassroute);
		        orl.put("bypassroute_press","无");
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
		
		for(int l=0;l<num;l++){
			Floyd test = new Floyd(a);
			if(test.length[i][j] >= max){
				break;
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
			// for (int i = 0; i < a.length; i++){
			// 	for (int j = i; j < a[i].length; j++) {
			// 		System.out.println();
			// 		System.out.print("From " + i + " to " + j + " path is: ");
			// 		for (int k = 0; k < test.path[i][j].length; k++){
						// respath[l][k] = test.path[i][j][k];
						// System.out.print(test.path[i][j][k] + " ");
			// 		}
					// System.out.println();

					// System.out.println("From " + i + " to " + j + " length :"
					// 		+ test.length[i][j]);
			// 	}
			// }
		}
		main_delay=backup_delay=bypass_delay=main_press=backup_press=bypass_press=-1;
		main_route = backup_route = bypass_route = null;
		if(respath[0][0]!=respath[0][1]){
			main_route = respath[0];//领接矩阵用max表示无路径，但是当获取的路径数num大于真正存在的路径时，respath中会出先0,0,0,0,0,0...这类数组
			main_delay = reslen[0];
			main_press = 0;
			for(m=0;m<respath[0].length-1;m++){
				index_i = respath[0][m];
				index_j = respath[0][m+1];
				main_press += b[index_i][index_j] * c[index_i][index_j];
				if(index_j==j){
					break;//到达了目的端j!
				}
				if(index_j==0){
					main_press = max;
					break;//开始节点0的后面节点全部为默认值0！说明本路径不存在！
				}
			}
		}
		
		int channel_pressure[] = new int[num];
		for(k=1;k<respath.length;k++){
			channel_pressure[k] = index_i = index_j = 0;
			for(m=0;m<respath[k].length-1;m++){
				index_i = respath[k][m];
				index_j = respath[k][m+1];
				channel_pressure[k] += b[index_i][index_j] * c[index_i][index_j];
				if(index_j==j){
					break;//到达了目的端j!
				}
				if(index_j==0){
					channel_pressure[k] = max;
					break;//开始节点0的后面节点全部为默认值0！说明本路径不存在！
				}
			}
//			System.out.println(k+": "+respath[k]);
			System.out.println(k+": "+channel_pressure[k]);
		}

		minindex = minpressure = max;
		for(k=1;k<respath.length;k++){
			if(minpressure>channel_pressure[k]){
				if(respath[k][0]!=respath[k][1]){
					minpressure = channel_pressure[k];
					minindex = k;
				}
			}
		}
		
		if(minindex!=max){
			backup_route = respath[minindex];
			backup_delay = reslen[minindex];
			backup_press = channel_pressure[minindex]; 
		}
		
		bypass_index = max;
		bypass_delay = max;
		for(k=1;k<num;k++){
			if(k!=minindex){
				if(reslen[k] < bypass_delay){
					if(respath[k][0]!=respath[k][1]){
						bypass_delay = reslen[k];
						bypass_index = k;
					}
				}
			}
		}
		if(bypass_index!=max){
			bypass_route = respath[bypass_index];
			bypass_delay = reslen[bypass_index];
			bypass_press = channel_pressure[bypass_index];
		}
		mainroute_press=backuproute_press=bypassroute_press="";
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
			mainroute += "a"+String.valueOf(main_press);
			mainroute_press += b[main_route[0]][main_route[1]];
			for(k=1;k<main_route.length-1;k++){
				if(main_route[k]==j){
					break;
				}
				mainroute_press += ","+b[main_route[k]][main_route[k+1]];
			}
			
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
			backuproute += "a"+String.valueOf(backup_press);
			backuproute_press += b[backup_route[0]][backup_route[1]];
			for(k=1;k<backup_route.length-1;k++){
				if(backup_route[k]==j){
					break;
				}
				backuproute_press += ","+b[backup_route[k]][backup_route[k+1]];
			}
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
			bypassroute += "a"+String.valueOf(bypass_press);
			bypassroute_press += b[bypass_route[0]][bypass_route[1]];
			for(k=1;k<bypass_route.length-1;k++){
				if(bypass_route[k]==j){
					break;
				}
				bypassroute_press += ","+b[bypass_route[k]][bypass_route[k+1]];
			}
		}
		//System.out.println(mainroute);
		System.out.println(backuproute);
		//System.out.println(bypassroute);
	    	 HashMap<Object, Object> orl = new HashMap<Object, Object>();
	        orl.put("mainroute",mainroute);
	        orl.put("mainroute_press",mainroute_press);
	        orl.put("backuproute",backuproute);
	        orl.put("backuproute_press",backuproute_press);
	        orl.put("bypassroute",bypassroute);
	        orl.put("bypassroute_press",bypassroute_press);
              result.add(orl);
		
		
//		for(k=0;k<main_route.length;k++){
//			System.out.print(main_route[k]+" ");
//		}
//		System.out.println();
//		
//		for(k=0;k<backup_route.length;k++){
//			System.out.print(backup_route[k]+" ");
//		}
//		System.out.println();
//
//		for(k=0;k<bypass_route.length;k++){
//			System.out.print(bypass_route[k]+" ");
//		}
//		System.out.println();
	}
}