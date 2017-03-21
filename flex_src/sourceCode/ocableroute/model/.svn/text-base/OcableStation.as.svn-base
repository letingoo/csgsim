package sourceCode.ocableroute.model
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="ocableroute.model.OcableStation")] 
	public class OcableStation
	{
		/** 局站或T接编码*/
		private var stationcode:String;
		
		/**局站或T接名称*/
		private var stationname:String;
		
		/** 标记  station:局站  tnode：T接*/
		private var type:String;
		
		/** 局站或T接坐标X*/
		private var x:Number;
		
		/** 局站或T接坐标y*/
		private var y:Number;
		
		/** 连接的局站或T接列表*/
		private  var listconnstation:ArrayCollection;
		
		public function OcableStation()
		{
			this.stationcode="";
			this.stationname="";
			this.type="";
			this.x=0;
			this.y=0;
			this.listconnstation= new ArrayCollection();
		}
	}
}