global with sharing virtual class wsd_WebServiceResponse {
	
	// Map for storing all sorts of response data
	global map<String,Object> data = new map<String,Object>();

	// Constructor
	global wsd_WebServiceResponse(String type){
		
		// All requests have a random Id generated (check on how this is done)
		data.put('id',String.valueOf(Crypto.getRandomLong()));

		// All requests have a type to identify the response types
		data.put('type',type);
	}

}
