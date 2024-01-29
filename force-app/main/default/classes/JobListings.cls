public class JobListings implements Schedulable {

    private static final String JOOBLE_API_URL_KEY = 'https://jooble.org/api/467b2fde-136e-44c0-a06d-6f35638424cb';
  
    @future(callout=true)
    public static void getJobListingsFromJooble() {

        // Set search criteria
        Map<String, String> searchParameters = new Map<String, String>();
        searchParameters.put('keywords', 'Salesforce Developer');
        searchParameters.put('location', 'Alaska');
        searchParameters.put('salary', '120000');

        //Call out to Jooble Web Site
        HttpRequest request = new HttpRequest();
        request.setEndpoint(JOOBLE_API_URL_KEY);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(searchParameters));
        
        Http http = new Http();

        // Send the request and get the response
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        System.debug(response.getStatusCode());
        System.debug(response.getStatus());

        // Check if the request was successful (status code 200)
        if (response.getStatusCode() == 200 || response.getStatusCode() <= 299) {
            // Parse the response body and create Lead (job listing records)
            processJoobleResponse(response.getBody());
            }
    }
        public void execute(SchedulableContext sc) {
            getJobListingsFromJooble();
        }

    public static void processJoobleResponse(String responseBody) {

        Map<String, Object> joobleResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        List<Lead> jobListings = new List<Lead>();

        // Create list to access the 'jobs' key in joobleResponse
        List<Object> jobs = (List<Object>) joobleResponse.get('jobs');
        if (jobs != null) {
            for (Object job : jobs) {
                if (job instanceof Map<String, Object>) {
                    Map<String, Object> jobMap = (Map<String, Object>) job;
                    if(jobMap.get('company') != null) {
                        Lead listing = new Lead();
                    listing.LastName = (String) jobMap.get('title');
                    listing.Company = (String) jobMap.get('company');
                    listing.Website = (String) jobMap.get('link');
                    listing.Description = (String) jobMap.get('snippet');
                    listing.Location__c = (String) jobMap.get('location');
                    listing.Type__c = (String) jobMap.get('type');
                    listing.Job_Listing_Source__c = (String) jobMap.get('source');
                    listing.Salary__c = (String) jobMap.get('salary');
    
                    jobListings.add(listing);
                    }
                    
                }
            }
        }
    if(!jobListings.isEmpty()) {
        insert jobListings;
        }
    }
}
