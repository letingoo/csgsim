package sourceCode.ocableResource.model
{
	import mx.rpc.remoting.mxml.RemoteObject;

	[Bindable]
	[RemoteClass(alias="ocableResources.model.OcableSection")] 
	public class OcableSection
	{	
		public var no:String;
		public var serialNO:String;
		public var sectioncode:String;
		public var a_point:String;
		public var a_pointtype:String;
		public var a_pointname:String;
		public var z_point:String;
		public var z_pointtype:String;
		public var z_pointname :String
		public var ocablemodel:String;
		public var length :String;
		public var property:String;	
		public var buildmode:String;
		public var laymode :String;
		public var updateperson :String;
		public var updatedate :String;
		public var comcores:String;
		public var protectcores:String;
		public var fibercount:String;
		public var occupyfibercount :String;
		public var rundate:String;
		public var agentvendor:String;
		public var one_name :String;
		public var run_unit:String;
		public var check_unit:String;
		public var voltlevel:String;
		public var ocablesectionname:String;
		public var rule:String;
		public var isbuilding:String;
		public var laymodelen:String;
		public var function_unit:String;
		public var remark:String;
		public var sort:String;
		public var dir:String;
		public var start:String;
		public var end:String;
		public var updatedate_start:String;
		public var updatedate_end:String;		
		public var secvolt:String;
		public var province:String;
		public var provincename:String;
		public var platelong:String;
		public var powerstationdate:String;
		public var money:String;
		public function OcableSection()
		{
			this.no = "";
			this.serialNO="";
			this.sectioncode = "";
			this.a_point = "";
			this.a_pointtype = "";
			this.z_pointname = "";
			this.z_point = "";
			this.z_pointtype = "";
			this.a_pointname = "";
			this.ocablemodel = "";
			this.length = "";
			this.property = "";
			this.agentvendor="";
			this.check_unit="";
			this.comcores="";
			this.isbuilding="";
			this.laymodelen="";
			this.protectcores="";
			this.rule="";
			this.rundate="";
			this.laymode = "";
			this.fibercount ="";
			this.occupyfibercount="";
			this.run_unit="";
			this.one_name="";
			this.voltlevel="";
			this.ocablesectionname="";
			this.function_unit="";
			this.sort="ocablesectionname";
			this.end="";
			this.updatedate="";
			this.updateperson="";
			this.remark="";
			this.start="";
			this.dir ="asc";
			this.updatedate_start="";
			this.updatedate_end="";
			this.secvolt = "";
			this.province = "";
			this.platelong="";
			this.powerstationdate="";
			this.money="";
		    this.provincename="";
		}
	}
}