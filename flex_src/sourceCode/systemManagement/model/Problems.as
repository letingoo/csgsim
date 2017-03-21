package sourceCode.systemManagement.model
{
	[Bindable]	
	[RemoteClass(alias="netres.model.Problems")]  
	public class Problems
	{
		public var no:String;
		public var problemid:String;
		public var pmodule:String;
		public var pdescription:String;
		public var pdealer:String;
		public var pstatus:String;
		public var ptreatmethod:String;
		public var premark:String;
		public var ppopperson:String;
		public var pmakedate:String;
		public var phelper:String;
		public var start:String;
		public var end:String;
		public var sort:String;
		public var dir:String;
		public var pmakedatestart:String;
		public var pmakedateend:String;
		public var pproperty:String;
		public var deadlinedate:String;
		public var finisheddate:String;
		public var reSort:String;

		public function Problems():void{
			this.no = "";
			this.problemid = "";
			this.pmodule = "";
			this.pdescription = "";
			this.pdealer = "";
			this.pstatus = "";
			this.ptreatmethod = "";
			this.premark = "";
			this.ppopperson = "";
			this.pmakedate = "";
			this.phelper = "";
			this.start="0";
			this.end="50";
			this.sort="";
			this.pproperty="";
			this.deadlinedate = "";
			this.finisheddate = "";
			this.dir="ASC";
			this.pmakedatestart ="";
			this.pmakedateend = "";
			this.reSort = "pstatus";
		}
		
		public function getreSort():String{
			return this.reSort;
		}
		public function setreSort(value:String):void{
			this.reSort = value;
		}
		public function getpmakedateend():String
		{
			return this.pmakedateend;
		}

		public function setpmakedateend(value:String):void
		{
			this.pmakedateend = value;
		}

		public function getpmakedatestart():String
		{
			return this.pmakedatestart;
		}

		public function setpmakedatestart(value:String):void
		{
			this.pmakedatestart = value;
		}

		public function getdir():String
		{
			return this.dir;
		}

		public function setdir(value:String):void
		{
			this.dir = value;
		}

		public function getsort():String
		{
			return this.sort;
		}

		public function setsort(value:String):void
		{
			this.sort = value;
		}

		public function getend():String
		{
			return this.end;
		}

		public function setend(value:String):void
		{
			this.end = value;
		}

		public function getstart():String
		{
			return this.start;
		}

		public function setstart(value:String):void{
		
			this.start = value;
		}

		public function getphelper():String
		{
			return this.phelper;
		}

		public function setphelper(value:String):void
		{
			this.phelper = value;
		}

		public function getpmakedate():String
		{
			return this.pmakedate;
		}

		public function setpmakedate(value:String):void
		{
			this.pmakedate = value;
		}

		public function getppopperson():String
		{
			return this.ppopperson;
		}

		public function setppopperson(value:String):void
		{
			this.ppopperson = value;
		}

		public function getpremark():String
		{
			return this.premark;
		}

		public function setpremark(value:String):void
		{
			this.premark = value;
		}

		public function getptreatmethod():String
		{
			return this.ptreatmethod;
		}

		public function setptreatmethod(value:String):void
		{
			this.ptreatmethod = value;
		}

		public function getpstatus():String
		{
			return this.pstatus;
		}

		public function setpstatus(value:String):void
		{
			this.pstatus = value;
		}

		public function getpdealer():String
		{
			return this.pdealer;
		}

		public function setpdealer(value:String):void
		{
			this.pdealer = value;
		}

		public function getpdescription():String
		{
			return this.pdescription;
		}

		public function setpdescription(value:String):void
		{
			this.pdescription = value;
		}

		public function getNo():String
		{
			return this.no;
		}

		public function setNo(value:String):void
		{
			this.no = value;
		}
		
		public function getproblemid():String
		{
			return this.problemid;
		}
		
		public function setproblemid(value:String):void
		{
			this.problemid = value;
		}

		public function getpmodule():String
		{
			return this.pmodule;
		}
		
		public function setpmodule(value:String):void
		{
			this.pmodule = value;
		}
		
		public function getfinisheddate():String
		{
			return this.finisheddate;
		}
		
		public function setfinisheddate(value:String):void
		{
			this.finisheddate = value;
		}
		
		public function getdeadlinedate():String
		{
			return this.deadlinedate;
		}
		
		public function setdeadlinedate(value:String):void
		{
			this.deadlinedate = value;
		}
		
		public function getpproperty():String
		{
			return this.pproperty;
		}
		
		public function setpproperty(value:String):void
		{
			this.pproperty = value;
		}
   }
}