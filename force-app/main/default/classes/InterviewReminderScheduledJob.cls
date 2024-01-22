public class InterviewReminderScheduledJob implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
     
        //Calculate the date of the day before the interview
        Date tomorrow = Date.today().addDays(1);

        // Query events (interviews) with a start date of tomorrow
        List<Event> interviewsTomorrow = [  SELECT 
                                                Id, 
                                                Subject, 
                                                StartDateTime, 
                                                Location, 
                                                Owner.Email
                                            FROM Event
                                            WHERE StartDateTime = :tomorrow];

        List<Messaging.SingleEmailMessage> reminderEmails = new List<Messaging.SingleEmailMessage>();

        // Iterate over the events (interviews) and send reminders
        for (Event event : interviewsTomorrow) {
            String subject = 'Reminder: ' + event.Subject;
            String body = 'Hi ' + event.OwnerId + ',\n\n'
            + 'This is a reminder for your interview scheduled for tomorrow: ' + event.StartDateTime + '\n'
            + 'Best of luck! \n' 
            + 'You got this!';
    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{event.Assigned_To_Email__c});
            mail.setSubject(subject);
            mail.setHtmlBody(body);

            reminderEmails.add(mail);
        }
          // Send the email and handle errors
          if(!reminderEmails.isEmpty()) {
            Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(reminderEmails);
            for (Messaging.SendEmailResult result : sendResults) {
                if (result.isSuccess()) {
                    System.debug('Email reminder sent successfully.');
                } else {
                    System.debug('Failed to send email reminder. Error message: ' + result.getErrors()[0].getMessage());
                }
            }
        
       }
    }
}