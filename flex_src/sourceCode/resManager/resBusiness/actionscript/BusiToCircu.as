package sourceCode.resManager.resBusiness.actionscript{
	
	import common.actionscript.ModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.resManager.resBusiness.model.ResultModel;
	import sourceCode.resManager.resBusiness.views.RouteStatisticsAnalyse;
	

public class BusiToCircu{	
	import sourceCode.resManager.resBusiness.model.Circuit;	
	import sourceCode.resManager.resBusiness.model.BusinessRessModel;
	import sourceCode.resManager.resBusiness.model.CircuitBusinessModel;	
	
	public static var circuit:Circuit = new Circuit();//电路
	private static var businessModel:BusinessRessModel = new BusinessRessModel();//业务
	//电路业务关系
	private static var circuitBusinessModel:CircuitBusinessModel = new CircuitBusinessModel();

	private static var CircuitBusinessLength:int;//业务数目
	private static var CircuitLength:int;//电路数量
	private static var CircuitBusiness:ArrayCollection = new ArrayCollection();
	private static var CircuitArr:ArrayCollection = new ArrayCollection();
	
	private static var BusinessToCircuit:Array = new Array();
	public static var CircuitToBusiness:Array = new Array();//
	public static var flag:int=0;
	
	public static function init():void{
		CircuitBusiness = new ArrayCollection();
		CircuitArr = new ArrayCollection();
		
		BusinessToCircuit = new Array();
		CircuitToBusiness = new Array();
		 getCircuitBusinessLength();//查询电路业务关系数量
		
	}
	private static function getCircuitBusinessLength():void{
		var rmObj:RemoteObject = new RemoteObject("resBusinessDwr");
		circuitBusinessModel.end = "1";
		rmObj.endpoint = ModelLocator.END_POINT;
		rmObj.showBusyCursor = true;
		rmObj.addEventListener(ResultEvent.RESULT,getCircuitBusinessLengthresultHandler);
		rmObj.getCircuitBusiness(circuitBusinessModel);  //查数量
	}
	private static function getCircuitBusinessLengthresultHandler(event:ResultEvent):void{
		var result:ResultModel = event.result as ResultModel;
		if(null != result){
			CircuitBusinessLength = result.totalCount;
			getCircuitBusiness();
		}
		
	}
	
	private static function getCircuitBusiness():void{
		var rmObj:RemoteObject = new RemoteObject("resBusinessDwr");
		circuitBusinessModel.end = CircuitBusinessLength.toString();
		rmObj.endpoint = ModelLocator.END_POINT;
		rmObj.showBusyCursor = true;
		rmObj.addEventListener(ResultEvent.RESULT,getCircuitBusinessresultHandler);
		rmObj.getCircuitBusiness(circuitBusinessModel);  //查总的电路业务关系数据
	}	
	private static function getCircuitBusinessresultHandler(event:ResultEvent):void{
		var result:ResultModel = event.result as ResultModel;
		if(null != result){
			CircuitBusiness.addAll(result.orderList);//电路业务关系数据
			
			getCircuitLength();	//获取链路数	量	
		}
	}
	
	private static function getCircuitLength():void{
		//Alert.show(CircuitBusiness.length.toString(),"222222"); 
		var rmObj:RemoteObject = new RemoteObject("resBusinessDwr");
		circuit.end = "1";
		rmObj.endpoint = ModelLocator.END_POINT;
		rmObj.showBusyCursor = true;
		rmObj.addEventListener(ResultEvent.RESULT,getCircuitLengthresultHandler);
		rmObj.MygetCircuit(circuit);
	}	
	private static function getCircuitLengthresultHandler(event:ResultEvent):void{	
		var result:ResultModel = event.result as ResultModel;
		if(null != result){
			CircuitLength = result.totalCount;//电路数量
			
			getCircuit();
		}
	}
	
	private static function getCircuit():void{
		var rmObj:RemoteObject = new RemoteObject("resBusinessDwr");
		circuit.end = CircuitLength.toString();
		rmObj.endpoint = ModelLocator.END_POINT;
		rmObj.showBusyCursor = true;
		rmObj.addEventListener(ResultEvent.RESULT,getCircuitresultHandler);
		rmObj.MygetCircuit(circuit);//获取电路数据
	}
	private static function getCircuitresultHandler(event:ResultEvent):void{
		var result:ResultModel = event.result as ResultModel;
		if(null != result){
			CircuitArr.addAll(result.orderList);	//电路数据
			
			BusinessToCircuitHandler();
		}
	}
	
	private static function BusinessToCircuitHandler():void{	
		//Alert.show(CircuitLength.toString(),"CircuitLength"); 

		for(var i:int = 0; i< CircuitArr.length; i++){
			BusinessToCircuit[i] =0;
			for(var j:int=0; j<CircuitBusiness.length; j++){
				if(CircuitBusiness.getItemAt(j).circuitcode.indexOf( CircuitArr.getItemAt(i).circuitcode)>=0){//业务电路关系表中  一个业务对应多个电路
					BusinessToCircuit[i]++;//电路承载的业务数关系数组
				}
					
			}
		}
		
		getBusinessLength();//获取业务数量
		//CircuitToBusinessHandler(5);
	}
	private static function CircuitToBusinessHandler(BusinessLength:int):void{	
		for(var i:int = 0; i<= BusinessLength; i++)
			CircuitToBusiness[i]=0;
		
		for(var i:int = 0; i< BusinessToCircuit.length; i++){
			var num:int = BusinessToCircuit[i];
			CircuitToBusiness[num]++;	//电路业务关系			
		}
		
		flag=1;
		
		//RouteStatisticsAnalyse.Max=BusiToCircu.CircuitToBusiness.length/RouteStatisticsAnalyse.gap;
		// Alert.show(CircuitToBusiness.toString()+"||"+CircuitToBusiness.length+"||"+RouteStatisticsAnalyse.Max,"showCircuitToBusiness");
	}

	private static function getBusinessLength():void{	
		var obj:RemoteObject = new RemoteObject("resBusinessDwr");
		businessModel.start = "0";
		businessModel.end = "1" ;
		obj.endpoint = ModelLocator.END_POINT;
		obj.showBusyCursor = true;
		obj.MygetRess(businessModel);
		obj.addEventListener(ResultEvent.RESULT,getBusinessLengthresultHandler); 
	}
	private static function getBusinessLengthresultHandler(e:ResultEvent):void{
		var result:ResultModel = e.result as ResultModel;
		if(result!=null){
			var Businessnum:int = result.totalCount;
			//modify by xgyin
			Businessnum=100;//业务的数量
			CircuitToBusinessHandler(Businessnum);
		}
	}
	



}
}