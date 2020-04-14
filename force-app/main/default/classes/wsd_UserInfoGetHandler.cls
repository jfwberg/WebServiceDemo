public with sharing class wsd_UserInfoGetHandler implements wsd_IWebServiceResponseHandler{
	
	/**
	 * Method for handling response logic
	 */
	public static void handleRequest(RestRequest req, RestResponse res){

		// Create a web service response object
		wsd_WebServiceResponse responseBody = new wsd_WebServiceResponse('userInfoDetails');

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
			
			// Get federation identifier from the URI
			String userFederationIdentifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

			// Select basic user, profile and permission set information
			User u = [SELECT Id, Name,UserName,Alias, Email,FederationIdentifier,IsActive,LanguageLocaleKey,LastLoginDate,LocaleSidKey,TimeZoneSidKey FROM User WHERE FederationIdentifier = :userFederationIdentifier  WITH SECURITY_ENFORCED LIMIT 1 ];
			Profile p = [SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()  WITH SECURITY_ENFORCED LIMIT 1 ];
			permissionSetAssignment[] ps = [SELECT PermissionSet.Id, PermissionSet.Name, PermissionSet.Label FROM permissionsetassignment WHERE AssigneeId = :UserInfo.getUserId() AND (NOT PermissionSet.Name LIKE 'X00%') WITH SECURITY_ENFORCED];

			// Get user permission set names
			Set<String> psNames = new Set<String>{};
			for(permissionSetAssignment psa : ps){
				psNames.add(psa.PermissionSet.Label);
			}

			// Query mappings
			ad_mapping__c	profileMapping		= [SELECT Name__c, Ad_Group_Name__c FROM ad_mapping__c WHERE Type__c = 'Profile' AND Name__c = :p.Name LIMIT 1];
			ad_mapping__c[] permissionSetMapping= [SELECT Name__c, Ad_Group_Name__c FROM ad_mapping__c WHERE Type__c = 'Permission Set' AND Name__c IN :psNames];

			// Add data to the response
			responseBody.data.put('userInfo', u);
			responseBody.data.put('profileInfo:', p);
			responseBody.data.put('adProfileInfo:', profileMapping);
			responseBody.data.put('permissionSetInfo:', ps);
			responseBody.data.put('adPermissionSetInfo:', permissionSetMapping);
		
			// Set request data so the the demo looks more fancy
			wsd_WebServiceUtil.setRequestInfo(responseBody, req);
			
			// Set succes flags
			wsd_WebServiceUtil.setSuccess(responseBody, res, 200);
			
		}catch(Exception e){
			// Set the exception details
			wsd_WebServiceUtil.setException(responseBody, res, e, 400);	
		}
	}

}
