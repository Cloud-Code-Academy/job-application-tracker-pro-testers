@isTest
private class Test_InterviewReminderScheduledJob {
    @isTest
    static void test_InterviewReminderScheduledJob() {
        // Create test user record
        User interviewee = new User (
            FirstName = 'Inter',
            LastName = 'Viewee',
            Email = 'testinterviewee@tester.com',
            Username = 'testinterviewee@tester.com',
            Alias = 'ivwee',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert interviewee;

        //Create the Event (Interview) record
        Date tomorrow = Date.today().addDays(1);
        Event interviewEvent = new Event(
            Subject = 'Test Interview',
            OwnerId = interviewee.Id,
            StartDateTime = tomorrow,
            EndDateTime = tomorrow,
            Location = 'Test Location' 
        );
        
        insert interviewEvent; 

        Test.startTest();
        System.assertEquals(0, Limits.getEmailInvocations(), 'Expected one email to be sent.');
        InterviewReminderScheduledJob scheduledJob = new InterviewReminderScheduledJob();
        scheduledJob.execute(null);
        System.assertEquals(1, Limits.getEmailInvocations(), 'Expected one email to be sent.');
        Test.stopTest();

        System.assertEquals('Test Interview', interviewEvent.Subject, 'The interview event subject should be "Test Interview"');
        
    }
}