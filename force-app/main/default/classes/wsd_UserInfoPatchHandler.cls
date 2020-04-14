public with sharing class wsd_UserInfoPatchHandler implements wsd_IWebServiceResponseHandler{
	
	/**
	 * Method for handling response logic
	 */
	public static void handleRequest(RestRequest req, RestResponse res){

		// Create a web service response object
		wsd_WebServiceResponse responseBody = new wsd_WebServiceResponse('userInfoUpdate');

		// Step 01, validate if the request URL has the valid format
		if(validateRequestUrl(req.requestURI)){

			// Step 02, validate the request body
			if(validateRequestBody(req.requestBody)){

				// Step 03, execute response logic
				executeLogic(responseBody, req, res);

			}else{
				// Add error handling
				wsd_WebServiceUtil.setError(responseBody, res, wsd_WebServiceUtil.ERR_MSG_INVALID_BODY, 400);
			}
		}else{
			// Add error handling
			wsd_WebServiceUtil.setError(responseBody, res, wsd_WebServiceUtil.ERR_MSG_INVALID_URI, 400);
		}

		// Set the response body
		res.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
	}


	/**
	 * Method for validating the request URL
	 */
	public static Boolean validateRequestUrl(String url){
		return true;
	}


	/**
	 * Method for validating the request Body
	 */
	public static Boolean validateRequestBody(Blob body){
		return true;
	}


	/**
	 * Method for executing the logic
	 */
	public static void executeLogic(wsd_WebServiceResponse responseBody, RestRequest req, RestResponse res){
		// Exception handling
		try{

			/* LOGIC GOES IN HERE */
						
			// Set request data so the the demo looks more fancy
			wsd_WebServiceUtil.setRequestInfo(responseBody, req);
			
			// Set succes flags
			wsd_WebServiceUtil.setSuccess(responseBody, res, 201);
			
		}catch(Exception e){
			// Set the exception details
			wsd_WebServiceUtil.setException(responseBody, res, e, 400);	
		}
	}

}
