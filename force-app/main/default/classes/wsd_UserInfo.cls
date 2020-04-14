@RestResource(urlMapping='/UserInfo/*')
global with sharing class wsd_UserInfo {
	
	/**
	 * GET
	 */
	@HttpGet
	global static void handleGet(){

		// Set default response
		setupResponse(RestContext.response);
		
		// Handle response logic
		wsd_UserInfoGetHandler.handleRequest(RestContext.request, RestContext.response);

		// Save log to the database
		saveLog(RestContext.request, RestContext.response);
	}


	/**
	 * POST
	 */
	@HttpPost
	global static void handlePost(){
		
		// Set default response
		setupResponse(RestContext.response);

		// Handle response logic
		wsd_UserInfoPostHandler.handleRequest(RestContext.request, RestContext.response);

		// Save log to the database
		saveLog(RestContext.request, RestContext.response);
	}


	/**
	 * PATCH
	 */
	@HttpPatch
	global static void handlePatch(){
		
		// Set default response
		setupResponse(RestContext.response);

		// Handle response logic
		wsd_UserInfoPatchHandler.handleRequest(RestContext.request, RestContext.response);

		// Save log to the database
		saveLog(RestContext.request, RestContext.response);
	}


	/**
	 * Method for setting default response codes
	 */
	private static void setupResponse(RestResponse res){
		
		// Null check
		if(res == null){res = new RestResponse();}

		// Create a web service response object
		wsd_WebServiceResponse responseBody = new wsd_WebServiceResponse('error');
		wsd_WebServiceUtil.setError(responseBody, res, wsd_WebServiceUtil.ERR_MSG_INT_SVR_ERR, 500);

		// Set the response body
		res.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
	}


	/**
	 * Method for saving the request to the logs 
	 */
	private static void saveLog(RestRequest req, RestResponse res){

	}
	

}
