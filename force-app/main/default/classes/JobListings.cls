public with sharing class JobListings {

    private static final String JOOBLE_API_URL_KEY = 'https://jooble.org/api/467b2fde-136e-44c0-a06d-6f35638424cb';
  
    public static void getJobListingsFromJooble(String keywords, String location) {

        // Set search criteria
        Map<String, String> searchParameters = new Map<String, String>();
        searchParameters.put('keywords', 'Salesforce Developer');
        searchParameters.put('location', 'Alaska');
        searchParameters.put('salary', '80000');

        //Call out to Jooble Web Site
        HttpRequest request = new HttpRequest();
        request.setEndpoint('JOOBLE_API_URL_KEY');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(searchParameters));
        
        Http http = new Http();

    try {
        // Send the request and get the response
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        System.debug(response.getStatusCode());
        System.debug(response.getStatus());

        // Check if the request was successful (status code 200)
        if (response.getStatusCode() == 200) {
            // Parse and return the response body
            return response.getBody();
            } else {
                // Handle error responses
                System.debug('HTTP Request failed with status code: ' + response.getStatusCode());
                System.debug('Response Body: ' + response.getBody());
                return null;
            }
        } catch (Exception e) {
            // Handle exceptions
            System.debug('Exception occurred: ' + e.getMessage());
            return null;
        }

    }
}