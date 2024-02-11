public with sharing class EmailAutomation {
public static void sendThankYouEmailOnAccept(List <Opportunity> emailOfferAccepted, Map<Id, Contact> conMap) {
        List <Messaging.Email> emailList = new List <Messaging.Email>();
        for (Opportunity ja : emailOfferAccepted) {
            Contact con = conMap.get(ja.Primary_Contact__c);
            if(ja.StageName == 'Accepted' && ja.Primary_Contact__c != null && con.Email != null) {
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                String[] toAddress = new String[] {con.Email};
                emailMsg.setToAddresses(toAddress);
                String emailSub = 'Thank You!';
                
                emailMsg.setSubject(emailSub);
                String disName = UserInfo.getName();
                emailMsg.setSenderDisplayName(disName);
                String content = 'Dear ' + con.FirstName + ',<br/><br/>' 
                    +'I am thrilled and honored to have been selected for this opportunity.' + '<br/>'
                    + 'Thank you for believing in me and for having confidence in my abilities.' + '<br/><br/>'
                    + 'Please let me know the next steps regarding the onboarding process and any additional paperwork or documentation required from my end.' + '<br/><br/>'
                    + 'Warm regards,';                    
                    
                emailMsg.setHtmlBody(content);
                emailList.add(emailMsg);
            }
        }
        Messaging.sendEmail(emailList);
    }
}