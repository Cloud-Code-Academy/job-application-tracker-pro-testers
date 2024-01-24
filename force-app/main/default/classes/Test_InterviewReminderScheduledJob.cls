@isTest
public class Test_InterviewReminderScheduledJob {
    @isTest
    static void Test_InterviewReminderScheduledJob() {
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

        //Create Event (Interview) record
        Date tomorrow = Date.today().addDays(1);
        Event interviewEvent = new Event(
            Subject = 'Test Interview',
            OwnerId = interviewee.Id,
            StartDateTime = DateTime.now(),
            EndDateTime = tomorrow,
            Location = 'Test Location' 
        );
        insert interviewEvent;

        Test.startTest();
        InterviewReminderScheduledJob testReminder = new InterviewReminderScheduledJob();
        testReminder.execute(null);
        Test.stopTest();

        List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage WHERE ToAddress = 'testinterviewee@tester.com'];
        System.assertEquals(1, sentEmails.size(), 'Expected one email to be sent.');
        System.assertEquals('Test Interview', interviewEvent.Subject, 'The interview event subject should be "Test Interview"');
    }
}
