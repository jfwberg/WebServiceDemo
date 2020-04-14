public with sharing class wsd_UserInfoPostHandler implements wsd_IWebServiceResponseHandler{
	
	/**
	 * Method for handling response logic
	 */
	public static void handleRequest(RestRequest req, RestResponse res){

		// Create a web service response object
		wsd_WebServiceResponse responseBody = new wsd_WebServiceResponse('userInfoCreate');

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

			// Parse the request body JSON string to something the machine can read
			Map<String, Object> requestBodyMap = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
			
			// Get the profile Id group name
			String profileAdGroup = (String) requestBodyMap.get('profileAdGroup');

			// Get the list of permission sets
			Object[] permissionSetAdGroups = (Object[]) requestBodyMap.get('permissionSetAdgroups');

			// Set a savepoint so for the demo we won't create tons of users
			Savepoint sp = Database.setSavepoint();

			// Create a new user object
			User u = new user();

			// populate the user object with data from the request body
			u.firstName	= (String) requestBodyMap.get('firstName');
			u.lastName	= (String) requestBodyMap.get('lastName');
			u.userName	= (String) requestBodyMap.get('userName');
			u.Email		= (String) requestBodyMap.get('Email');
			u.Alias		= (String) requestBodyMap.get('Alias');
			u.FederationIdentifier = (String) requestBodyMap.get('FederationIdentifier');

			// Get the profile Id using a mapping utility
			u.ProfileId = wsd_WebServiceUtil.getProfileIdBasedOnAdName(profileAdGroup);

			// Standard system data (could make this work for UK/INDIA/USA time zones)
			u.TimeZoneSidKey ='Europe/London';
			u.LocaleSidKey='en_GB';
			u.EmailEncodingKey='ISO-8859-1';
			u.LanguageLocaleKey='en_US';

			// Insert the user to the database
			insert u;

			// Create permission set assignments
			PermissionSetAssignment[] newPermissionSetAssignments = new PermissionSetAssignment[]{};
			for(Object permissionSetAdGroup : permissionSetAdGroups){
				newPermissionSetAssignments.add(new PermissionSetAssignment(
					AssigneeId = u.Id,
					PermissionSetId = wsd_WebServiceUtil.getPermissionSetIdBasedOnAdName((String) permissionSetAdGroup)
				));
			}

			// Insert he new permission set assignments
			Insert newPermissionSetAssignments;
			
			// Get info on the profile and permission set assignments for the newly created user
			Profile p = [SELECT Id, Name FROM Profile WHERE Id=:u.ProfileId  WITH SECURITY_ENFORCED LIMIT 1 ];
			permissionSetAssignment[] ps = [SELECT PermissionSet.Id, PermissionSet.Name, PermissionSet.Label FROM permissionsetassignment WHERE AssigneeId = :u.Id AND (NOT PermissionSet.Name LIKE 'X00%') WITH SECURITY_ENFORCED];

			// Add data to the response
			responseBody.data.put('userInfo', u);
			responseBody.data.put('profileInfo:', p);
			responseBody.data.put('permissionSetInfo:', ps);
			
			// Roll back changes so user does not actually gets created
			Database.rollback(sp);
						
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
