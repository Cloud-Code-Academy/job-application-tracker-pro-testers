/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class tax {
    @AuraEnabled(cacheable=true)
    public static Tax getTax(){
        return [SELECT Id, Name, X10_Tax_Bracket__c, X12_Tax_Bracket__c,
        X22_Tax_Bracket__c, X24_Tax_Bracket__c, X32_Tax_Bracket__c,
        X35_Tax_Bracket__c, X37_Tax_Bracket__c
        FROM Tax LIMIT 1];
    }
 
}