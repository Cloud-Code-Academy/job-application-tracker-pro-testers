@IsTest
global class TestJobListingsMock implements HttpCalloutMock {    
    //mocks a HTTP callout
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"jobs": {"title": "Salesforce Engineer", "company": "Acme Corp", "link": "https://example.com/job/123", "snippet": "Exciting job opportunity", "location": "Alaska", "type": "Full-Time", "source": "Jooble", "salary": "$100,000 - $120,000", "id":"1234567","updated":"2024-12-31T23:59:59Z"}}}');
        res.setStatusCode(200);
        return res;
    }
}