package sourceCode.ocableResource.model
{
	import mx.controls.Alert;
	import mx.controls.Tree;
	import mx.core.Application;
	import mx.events.ListEvent;
	
	import sourceCode.ocableResource.views.link.ElementCreator;

	public class ocableModelLocator
	{
		public function ocableModelLocator(){}
		
		private static var modelLocator:ocableModelLocator;
		
		public static function getInstance():ocableModelLocator{
			if(modelLocator == null)
				modelLocator = new ocableModelLocator();
			return modelLocator;
		}
		
		[Embed(source="assets/images/pin.gif")]
		public static const separator:Class;
		
		[Embed(source='assets/images/pagetoolbar/pre.jpg')]
		[Bindable]
		private var preIcon:Class;
		
		[Embed(source='assets/images/pagetoolbar/next.jpg')]
		[Bindable]
		private var nextIcon:Class;
		
		//地图
		[Embed(source="assets/images/swf/ocable/Map_Shanxi.swf")]
		public static const province:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Changzhi-01.swf")]
		public static const changzhi:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Changzhi-01.swf")]
		public static const pingshun:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Datong-01.swf")]
		public static const datong:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Jincheng-01.swf")]
		public static const jincheng:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Jinzhong-01.swf")]
		public static const jinzhong:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Linfen-01.swf")]
		public static const linfen:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Lvliang-01.swf")]
		public static const lvliang:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Shuozhou-01.swf")]
		public static const shuozhou:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Taiyuan-01.swf")]
		public static const taiyuan:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Xinzhou-01.swf")]
		public static const xinzhou:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Yangquan-01.swf")]
		public static const yangquan:Class;
		
		[Embed(source="assets/images/swf/ocable/Map_Yuncheng-01.swf")]
		public static const yuncheng:Class;
		
		//县地图
//		[Embed(source="assets/images/swf/ocable/Map_Yuncheng-01.swf")]
//		public static const yuncheng:Class;
//		
//		[Embed(source="assets/images/swf/ocable/Map_Yuncheng-01.swf")]
//		public static const yuncheng:Class;
//		
//		[Embed(source="assets/images/swf/ocable/Map_Yuncheng-01.swf")]
//		public static const yuncheng:Class;
		//太原
		[Embed(source="assets/images/swf/ocable/map/taiyuan/gujiaoshi.swf")]
		public static const gujiaoshi:Class;
		[Embed(source="assets/images/swf/ocable/map/taiyuan/loufanxian.swf")]
		public static const loufanxian:Class;
		[Embed(source="assets/images/swf/ocable/map/taiyuan/qingxuxian.swf")]
		public static const qingxuxian:Class;
		[Embed(source="assets/images/swf/ocable/map/taiyuan/taiyuanshi.swf")]
		public static const taiyuanshi:Class;
		[Embed(source="assets/images/swf/ocable/map/taiyuan/yangquxian.swf")]
		public static const yangquxian:Class;
		//阳泉
		
		[Embed(source="assets/images/swf/ocable/map/yangquan/yangquanshi.swf")]
		public static const yangquanshi:Class;
		[Embed(source="assets/images/swf/ocable/map/yangquan/mengxian.swf")]
		public static const mengxian:Class;
		
		[Embed(source="assets/images/swf/ocable/map/yangquan/pingdingxian.swf")]
		public static const pingdingxian:Class;
		
		
		
		//方向标
		[Embed(source="assets/images/swf/ocable/方向标.swf")]
		public static const direction:Class;
		//图例
		[Embed(source="assets/images/swf/ocable/光缆图例.swf")]
		public static const ocable:Class;
		//提示图标
		[Embed(source="assets/images/swf/ocable/提示.swf")]
		public static const showPointer:Class;
		
		//变电站图片
		//站点类型图例
		[Embed(source="assets/images/swf/ocable/legend/s_35kV.swf")]
		public static const  station_1000kV:Class;	
		[Embed(source="assets/images/swf/ocable/legend/110_s.swf")]
		public static const  station_500kV:Class;	
		[Embed(source="assets/images/swf/ocable/legend/220_s.swf")]
		public static const  station_200kV:Class;	
		[Embed(source="assets/images/swf/ocable/legend/500_s.swf")]
		public static const  station_110kV:Class;	
		[Embed(source="assets/images/swf/powermap/10_s.swf")]
		public static const  station_10kV:Class;	
		[Embed(source="assets/images/swf/powermap/20_s.swf")]
		public static const  station_20kV:Class;	
		[Embed(source="assets/images/swf/powermap/35_s.swf")]
		public static const  station_35kV:Class;	
		[Embed(source="assets/images/swf/powermap/50_s.swf")]
		public static const  station_50kV:Class;	
		[Embed(source="assets/images/swf/powermap/66_s.swf")]
		public static const station_66kV:Class;
		
		//电厂图片
		[Embed(source="assets/images/swf/ocable/500kV电厂.swf")]
		public static const  power_500kV:Class;	
		[Embed(source="assets/images/swf/ocable/legend/yonghuzhan.swf")]
		public static const  power_220kV:Class;	
		[Embed(source="assets/images/swf/ocable/legend/s_10kV.swf")]
		public static const  power_110kV:Class;
		
		
		//其他类型站图片
		[Embed(source="assets/images/swf/ocable/中心站.swf")]
		public static const  zhongxinzhan:Class;
		[Embed(source="assets/images/swf/ocable/地调.swf")]
		public static const  didiao:Class;
		[Embed(source="assets/images/swf/ocable/legend/qita.swf")]
		public static const  other:Class;
		[Embed(source="assets/images/swf/ocable/串补站.swf")]
		public static const  CB:Class;
		[Embed(source="assets/images/swf/ocable/开闭站.swf")]
		public static const  KB:Class;
		[Embed(source="assets/images/swf/ocable/微波站.swf")]
		public static const  WB:Class;
		[Embed(source="assets/images/swf/ocable/用户站.swf")]
		public static const  YH:Class;
		[Embed(source="assets/images/swf/ocable/GLZJD.swf")]
		public static const  GLZJ:Class;
		
		
		
		//光缆图例
		[Embed(source="assets/images/swf/mapswf/OPGW500KV.swf")]
		public static const OPGW500KV:Class;
		
		[Embed(source="assets/images/swf/mapswf/OPGW220KV.swf")]
		public static const OPGW220KV:Class;
		
		[Embed(source="assets/images/swf/mapswf/OPGW110KV.swf")]
		public static const OPGW110KV:Class;
		
		[Embed(source="assets/images/swf/mapswf/ADSS110KV.swf")]
		public static const ADSS110KV:Class;
		
		[Embed(source="assets/images/swf/mapswf/ADSS35KV.swf")]
		public static const ADSS35KV:Class;
		
		[Embed(source="assets/images/swf/mapswf/ADSS10KV.swf")]
		public static const ADSS10KV:Class;
		
		[Embed(source="assets/images/swf/mapswf/其他线路.swf")]
		public static const otherOcable:Class;
		
		//光缆图例 站点
		[Embed(source="assets/images/swf/ocable/legend/zhongxinzhan.swf")]
		public static const zhongxinzhanswf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/didiao.swf")]
		public static const didiaoswf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/1000_s.swf")]
		public static const s1000swf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/500_s.swf")]
		public static const s500swf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/220_s.swf")]
		public static const s220swf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/110_s.swf")]
		public static const s110swf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/500_d.swf")]
		public static const d500swf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/220_d.swf")]
		public static const d220swf:Class;
	
		[Embed(source="assets/images/swf/ocable/legend/110_d.swf")]
		public static const d110swf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/chuanbuzhan.swf")]
		public static const chuanbuzhanswf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/kaibizhan.swf")]
		public static const kaibizhanswf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/yonghuzhan.swf")]
		public static const yonghuzhanswf:Class;
		
		[Embed(source="assets/images/swf/ocable/legend/qita.swf")]
		public static const qitaswf:Class;
		
		//线
		[Embed(source="assets/images/element/link_icon.png")]
		public static const LINK_TYPE_ARC:Class;
		
		[Embed(source="assets/images/element/link_flexional_icon.png")]
		public static const LINK_TYPE_FLEXIONAL:Class;
		
		[Embed(source="assets/images/element/link_orthogonal_h_icon.png")]
		public static const LINK_TYPE_ORTHOGONAL:Class;
		
		[Embed(source="assets/images/element/link_orthogonal_h_v_icon.png")]
		public static const LINK_TYPE_HORIZONTAL_VERTICAL:Class;
		
		[Embed(source="assets/images/element/link_orthogonal_left_icon.png")]
		public static const LINK_TYPE_EXTEND_LEFT:Class;
		
		[Embed(source="assets/images/element/link_orthogonal_right_icon.png")]
		public static const LINK_TYPE_EXTEND_RIGHT:Class;
		
		[Embed(source="assets/images/element/link_orthogonal_bottom_icon.png")]
		public static const LINK_TYPE_EXTEND_BOTTOM:Class;
		
		[Embed(source="assets/images/element/link_orthogonal_top_icon.png")]
		public static const LINK_TYPE_EXTEND_TOP:Class;
		
		[Embed(source="assets/images/element/link_orthogonal_v_h_icon.png")]
		public static const LINK_TYPE_VERTICAL_HORIZONTAL:Class;
		
		[Embed(source="assets/images/element/link_orthogonal_v_icon.png")]
		public static const LINK_TYPE_ORTHOGONAL_VERTICAL:Class;
		
		//站点电压等级
		public static function getStationType(isTnode:String,type:String):String
		{
			var stationType:String = '';
			if(isTnode == '1'){
				if(type=="变一变电站"){
					stationType = "station_110kV";
				}else if(type=="变二变电站"){
					stationType = "station_200kV";
				}else if(type=="电厂"){
					stationType = "station_500kV";
				}else if(type=="行政单位"){
					stationType = "station_1000kV";
				}else if(type=="用户站"){
					stationType = "power_110kV";
//				}else if(type=="220kV电厂"){
//					stationType = "power_220kV";
//				}else if(type=="500kV电厂"){
//					stationType = "power_500kV";
//				}else if(type=="中心站"){
//					stationType = "zhongxinzhan";
//				}else if(type=="地调"){
//					stationType = "didiao";
//				}else if(type=="串补站"){
//					stationType = "CB";
//				}else if(type=="开闭站"){
//					stationType = "KB";
//				}else if(type=="微波站"){
//					stationType = "WB";
//				}else if(type=="用户站"){
//					stationType = "YH";
				}else{
					stationType = "other";
				}
			}else if(isTnode =='2'){
				stationType = 'GLZJ';
			}
			return stationType;
			
		}

		
	}
}