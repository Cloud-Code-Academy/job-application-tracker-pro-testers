/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class OpportunityTriggerHandlerTest {
    @isTest
    static void testSetPrimaryContact() {
        // Create an Account with a Contact
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        // Create an Opportunity with a null primary_contact__c field
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            Amount = 10000,
            CloseDate = Date.today()
            // primary_contact__c is intentionally left null
        );
        insert testOpportunity;

        // Verify that the primary_contact__c field is updated based on the related Account's primary_contact__c
        Opportunity updatedOpportunity = [SELECT Id, primary_contact__c FROM Opportunity WHERE Id = :testOpportunity.Id];
        System.assertNotEquals(null, updatedOpportunity.primary_contact__c, 'Primary contact should not be null');
        System.assertEquals(testContact.Id, updatedOpportunity.primary_contact__c, 'Primary contact should match the related Account\'s primary_contact__c');
    }
}