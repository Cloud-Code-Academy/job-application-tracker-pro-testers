public with sharing class EmailAutomation {
    public static void sendThankYouEmailOnAccept() {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        List<Opportunity> emailOfferAccepted = [SELECT Id, StageName, Primary_Contact__c, ThankYouEmailSent__c, Owner_First_Name__c FROM Opportunity WHERE StageName = 'Accepted'];
        Map<Id, Contact> conMap = new Map<Id, Contact>();

        for (Opportunity opp : emailOfferAccepted) {
            conMap.put(opp.Primary_Contact__c, null);
        }

    // Retrieve contact records associated with the job applications
    conMap.putAll([SELECT Id, Email, FirstName FROM Contact WHERE Id IN :conMap.keySet()]);
    
    // Query custom metadata record to retrieve the email template ID
    String emailTemplateId = getCustomMetadataTemplateId();

        for (Opportunity opp : emailOfferAccepted) {
            Contact con = conMap.get(opp.Primary_Contact__c);
            if (opp.StageName == 'Accepted' && opp.Primary_Contact__c != null && !opp.ThankYouEmailSent__c && con != null && con.Email != null) {
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                emailMsg.setTemplateId(emailTemplateId);
                emailMsg.setTargetObjectId(con.Id);
                emailMsg.setSaveAsActivity(false); // Set to true if email is to be saved as an activity

                //Check the ThankYouEmailSent__c field to prevent resending email
                opp.ThankYouEmailSent__c = true;

                emailList.add(emailMsg);                
            }
        }

        Messaging.sendEmail(emailList);
    }

    private static String getCustomMetadataTemplateId() {
        Email_Template_Id__mdt emailTemplateId = [SELECT Template_Id__c FROM Email_Template_Id__mdt LIMIT 1];
        return emailTemplateId.Template_Id__c;
    }
}