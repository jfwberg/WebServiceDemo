public interface wsd_IWebServiceResponseHandler {
	
	// Standard methods that need to be included
	void handleRequest(RestRequest req, RestResponse res);
	Boolean validateRequestUrl(String url);
	Boolean validateRequestBody(Blob body);
	void executeLogic(wsd_WebServiceResponse responseBody, RestRequest req, RestResponse res);
}
