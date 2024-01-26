/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class OpportunityTriggerHandler {
    public static void handleBeforeInsertUpdate(List<Opportunity> opportunities) {
        setPrimaryContact(opportunities);
        // Add any other logic you need to perform before insert/update
    }

    private static void setPrimaryContact(List<Opportunity> opportunities) {
        Set<Id> opportunityIds = new Set<Id>();
        for (Opportunity opp : opportunities) {
            if (opp.primary_contact__c == null) {
                opportunityIds.add(opp.Id);
            }
        }

        if (!opportunityIds.isEmpty()) {
            Map<Id, Contact> opportunityIdToPrimaryContactMap = new Map<Id, Contact>();
            for (Opportunity opp : [SELECT Id, AccountId, Account.primary_contact__c 
                                    FROM Opportunity 
                                    WHERE Id IN :opportunityIds 
                                    AND AccountId != null]) {
                opportunityIdToPrimaryContactMap.put(opp.Id, opp.primary_contact__c);

            for (Opportunity opp1 : opportunities) {
                if (opportunityIdToPrimaryContactMap.containsKey(opp1.Id)) {
                    opp1.primary_contact__c = opportunityIdToPrimaryContactMap.get(opp.primary_contact__c);
                }
            }
        }
    }
}
}