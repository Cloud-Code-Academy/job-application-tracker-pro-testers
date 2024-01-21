public with sharing class JobListings {

    private static final String JOOBLE_API_URL = 'https://jooble.org/api';
    private static final String JOOBLE_API_KEY = '467b2fde-136e-44c0-a06d-6f35638424cb';
    
    public static void getJobListingsFromJooble() {
        //Callout to Jooble
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('JOOBLE_API_URL');
        request.setHeader('Authorization' + JOOBLE_API_KEY);
        request.setMethod('GET');

        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        System.debug(response.getStatusCode());
        System.debug(response.getStatus());

       /*try {
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
        */

    }
}