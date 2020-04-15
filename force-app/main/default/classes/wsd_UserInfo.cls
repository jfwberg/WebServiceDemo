/**
 *	@author			:	Justus van den Berg (jfwberg@gmail.com)
 *	@date			:	2020-04-10 22:00
 *	@description	:	Example Rest Webservice to Map active directory groups to profiles and permsisson sets
 *						in order to create new users. Example only to demonstrate a principle.
 *
 *	Copyright 2020 Justus van den Berg
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
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
