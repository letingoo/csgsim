
import mx.controls.Alert;

import sourceCode.resourcesChanges.model.ResultModel;

public var pageIndex:int=0;
public var pageSize:int=50;



public function init():void
{
	serverPagingBar1.dataGrid=updatehistorylist;
	serverPagingBar1.pagingFunction=pagingFunction;
	serverPagingBar1.pageSize=50;

	
}



private function pagingFunction(pageIndex:int, pageSize:int):void
{
	this.pageSize=pageSize;
	this.pageIndex=pageIndex;
	parentDocument.dispatchEvent(new Event("getResult"));
}

public function reLoadData():void
{
	
	serverPagingBar1.navigateButtonClick("firstPage");
}

public function onResult(result:ResultModel):void
{
	serverPagingBar1.orgData=result.orderList;
	serverPagingBar1.totalRecord=result.totalCount;
	serverPagingBar1.dataBind(true);
}