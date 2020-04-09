global with sharing virtual class wsd_WebServiceResponse {
	
	global map<String,Object> data {get;set;}

	global wsd_WebServiceResponse(){
		this.data = new map<String,Object>();
	}

}
