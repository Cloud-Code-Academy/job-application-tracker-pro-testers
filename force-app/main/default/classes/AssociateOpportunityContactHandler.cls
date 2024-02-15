 // Apex Class to copy Primary_Contact__c field from Account to Opportunity
public with sharing class AssociateOpportunityContactHandler {
    
    public static void copyPrimaryContactFromAccount(List<Opportunity> opportunities) {
        // Create a set to hold the Account Ids to retrieve Primary_Contact__c field
        Set<Id> accountIds = new Set<Id>();
        
        // Collect Account Ids from the Opportunities
        for (Opportunity opp : opportunities) {
            if (opp.Primary_Contact__c == null) {
                accountIds.add(opp.AccountId);
            }
        }
        
        // Query Accounts to get the Primary_Contact__c field
        Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, Primary_Contact__c FROM Account WHERE Id IN :accountIds]);
        
        // Update Opportunity records with Primary_Contact__c from related Account
        for (Opportunity opp : opportunities) {
            if (opp.Primary_Contact__c == null && accountsMap.containsKey(opp.AccountId)) {
                opp.Primary_Contact__c = accountsMap.get(opp.AccountId).Primary_Contact__c;
            }
        }
    }
}