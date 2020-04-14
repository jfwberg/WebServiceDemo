public with sharing class wsd_WebServiceUtil {
	
	// Messages
	public static final String ERR_MSG_INT_SVR_ERR = 'Internal Server Error';
	public static final String ERR_MSG_INVALID_URI = 'Invalid URL format provided';
	public static final String ERR_MSG_INVALID_BODY= 'Invalid Request Body provided';

	public static void setSuccess(wsd_WebServiceResponse responseBody, RestResponse res, Integer statusCode){
		responseBody.data.put('success',true);
		res.statusCode = statusCode;
	}

	public static void setError(wsd_WebServiceResponse responseBody, RestResponse res, String message, Integer statusCode){
		responseBody.data.put('success',false);
		responseBody.data.put('errorMessage',message);
		res.statusCode = statusCode;
	}

	public static void setException(wsd_WebServiceResponse responseBody, RestResponse res, Exception e, Integer statusCode){
		responseBody.data.put('success',false);
		responseBody.data.put('errorMessage',e.getMessage());
		responseBody.data.put('stackTraceString',e.getStackTraceString());
		res.statusCode = statusCode;
	}

	public static void setRequestInfo(wsd_WebServiceResponse responseBody, RestRequest req){
		Map<String,Object> requestInfo = new Map<String,Object>();
		requestInfo.put('httpMethod',	req.httpMethod);
		requestInfo.put('requestURI',	req.requestURI);
		requestInfo.put('remoteAddress',req.remoteAddress);
		responseBody.data.put('requestInfo', requestInfo);
	}

	// Very bad method, not bulkyfied, DEMO ONLY never implement this way
	public static String getProfileIdBasedOnAdName(String adName){
		ad_mapping__c profileMapping	= [SELECT Name__c, Ad_Group_Name__c FROM ad_mapping__c WHERE Type__c = 'Profile' AND Ad_Group_Name__c = :adName LIMIT 1];
		return [SELECT Id FROM Profile WHERE Name = :profileMapping.Name__c LIMIT 1].Id;
	}

	// Even worse method, not bulkyfied, DEMO ONLY never implement this way
	public static String getPermissionSetIdBasedOnAdName(String adName){
		ad_mapping__c permissionSetMapping= [SELECT Name__c, Ad_Group_Name__c FROM ad_mapping__c WHERE Type__c = 'Permission Set' AND Ad_Group_Name__c = :adName LIMIT 1];
		return [SELECT Id FROM PermissionSet WHERE Label = :permissionSetMapping.Name__c LIMIT 1].Id;
	}
}
