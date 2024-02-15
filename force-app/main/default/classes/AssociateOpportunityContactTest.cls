@isTest
private class AssociateOpportunityContactTest {
    
    @isTest
    static void testCopyPrimaryContactFromAccount() {
        // Create test data: Account and Opportunity records
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = acc.Id);
        insert opp;
        
        // Ensure that Primary_Contact__c on Account is populated
        acc.Primary_Contact__c = '003Hp00002xjzxgIAA';
        update acc;
        
        // Ensure that Primary_Contact__c on Opportunity is null
        opp.Primary_Contact__c = null;
        update opp;
        
        // Call the method to be tested
        List<Opportunity> opportunities = new List<Opportunity>{opp};
        AssociateOpportunityContactHandler.copyPrimaryContactFromAccount(opportunities);
        
        // Retrieve the updated Opportunity record
        Opportunity updatedOpp = [SELECT Id, Primary_Contact__c FROM Opportunity WHERE Id = :opp.Id];
        
        // Assert that the Primary_Contact__c field on the Opportunity is populated with the value from the Account
        System.assertEquals('003Hp00002xjzxgIAA', updatedOpp.Primary_Contact__c, 'Primary contact not copied correctly');
    }
}