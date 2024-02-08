@isTest
public class Test_CloseStaleJobApplications {

    @isTest
    static void testCloseStaleJobApplications() {
        // Create a test Job Application (Opportunity) record with follow-up date over 30 days
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Open',
            CloseDate = Date.today().addDays(1),
            follow_up_date__c = System.today().addDays(-31)
        );
        insert testOpportunity;

        Test.startTest();
        // Execute the scheduled job immediately
        CloseStaleJobApplications scheduledJob = new CloseStaleJobApplications();
        scheduledJob.execute(null);
        Test.stopTest();

        // Verify that the opportunity is closed
        List<Opportunity> updatedOpportunity = [SELECT Id, StageName, Description FROM Opportunity WHERE Id = :testOpportunity.Id];
        System.assertEquals(1, updatedOpportunity.size(), 'Expected one Opportunity that was cloaed due to inactivity.');
    }
}
