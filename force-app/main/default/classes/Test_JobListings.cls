@isTest
private class Test_JobListings {

    @isTest
    static void testGetJobListingsFromJooble_Success() {
        // Prepare HTTP mock with successful response
        Test.setMock(HttpCalloutMock.class, new JobListingsHttpMock(200, '{"jobs":[{"title":"Job 1","company":"Company A","link":"http://example.com/job1","snippet":"Job description 1","location":"Alaska","type":"Full-time","source":"Jooble","salary":"120,000"}]}'));
        
        Test.startTest();
        // Call the method under test
        JobListings.getJobListingsFromJooble();
        Test.stopTest();

        // Assert that job listings were created
        Integer actualListingsCount = [SELECT COUNT() FROM Opportunity WHERE StageName = 'Saved'];
        System.assertEquals(1, actualListingsCount, 'Job listings were not created');
    }

    @isTest
    static void testGetJobListingsFromJooble_HTTPError() {
        // Prepare HTTP mock with HTTP error response
        Test.setMock(HttpCalloutMock.class, new JobListingsHttpMock(500, 'Internal Server Error'));
        
        Test.startTest();
        // Call the method under test
        JobListings.getJobListingsFromJooble();
        Test.stopTest();

        // Assert no job listings were created due to HTTP error
        Integer actualListingsCount = [SELECT COUNT() FROM Opportunity WHERE StageName = 'Saved'];
        System.assertEquals(0, actualListingsCount, 'Job listings should not be created due to HTTP error');
    }

    // Inner class for mocking HTTP callout
    private class JobListingsHttpMock implements HttpCalloutMock {
        Integer statusCode;
        String responseBody;

        JobListingsHttpMock(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }

        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock HTTP response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
            return res;
        }
    }
}