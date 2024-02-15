@IsTest
private class Test_EmailAutomation {
    @IsTest
    static void testSendThankYouEmailOnAccept() {
        // Create test data
        List<Opportunity> opportunities = new List<Opportunity>();
        Contact contact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'kadir.suleymanoglu@gmail.com');
        insert contact;
        Opportunity opportunity = new Opportunity(
            Name = 'Test Record',
            StageName = 'Accepted',
            Primary_Contact__c = contact.Id,
	        CloseDate = System.today().addDays(11),
            ThankYouEmailSent__c = false
        );
        opportunities.add(opportunity);
        insert opportunities;

        // Create a mock for the custom metadata query result
        Email_Template_Id__mdt metadataRecord = new Email_Template_Id__mdt(Template_Id__c = '00XHp000002WmQf');

        
        // Set up mock for the custom metadata query
        Test.setMock(CustomMetadataLoader.class, new CustomMetadataLoaderImpl(metadataRecord));
        
        Test.startTest();
        // Call the method under test
        EmailAutomation.sendThankYouEmailOnAccept();
        Test.stopTest();

        // Assert that the email was sent
        List<Messaging.SingleEmailMessage> sentEmails = [SELECT Id FROM Messaging.SingleEmailMessage ];
        System.assertEquals(1, sentEmails.size(), 'Email should be sent');
    }

// Interface for custom metadata loader
    private interface CustomMetadataLoader {
        Email_Template_Id__mdt loadCustomMetadataRecord();
    }

    // Mock class for the custom metadata query
    private class CustomMetadataLoaderImpl implements CustomMetadataLoader {
        private Email_Template_Id__mdt metadataRecord;

        public CustomMetadataLoaderImpl(Email_Template_Id__mdt metadataRecord) {
            this.metadataRecord = metadataRecord;
        }

        public Email_Template_Id__mdt loadCustomMetadataRecord() {
            return metadataRecord;
        }
    }  
    
}