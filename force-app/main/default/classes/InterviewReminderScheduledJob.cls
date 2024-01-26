public class InterviewReminderScheduledJob implements Schedulable {
    
    public void execute(SchedulableContext ctx) {

        // Query events (interviews) with a start date of tomorrow and the Reminder_Sent__c field unchecked
        List<Event> interviewsTomorrow = [SELECT 
                                            Id, 
                                            Subject, 
                                            StartDateTime, 
                                            Location,
                                            Reminder_Sent__c, 
                                            Owner.Email,
                                            Owner.FirstName
                                        FROM Event
                                        WHERE StartDateTime = TOMORROW
                                        AND Reminder_Sent__c = false
                                        ];

        //create list of email reminders to send
        List<Messaging.SingleEmailMessage> reminderEmails = new List<Messaging.SingleEmailMessage>();

        // Iterate over the events (interviews) and send reminders
        for (Event event : interviewsTomorrow) {            
            
            //create the email message subject and body
            String subject = 'Interview Reminder for: ' + event.Subject;
            String body = 'Hi ' + event.Owner.FirstName + ',\n\n'
            + 'This is a reminder for your interview scheduled for tomorrow: ' + event.StartDateTime.format('yyyy-MM-dd HH:mm:ss') + '\n'
            + 'Best of luck! \n' 
            + 'You got this!';
            
            //set Reminder_Sent__c = true to avoid re-sending reminder
            event.Reminder_Sent__c = true;

            //create the email message and add to list
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{event.Owner.Email});
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            reminderEmails.add(mail);
            }

            // Send the email
          if(!reminderEmails.isEmpty()) {
            Messaging.sendEmail(reminderEmails);
                } 

            update interviewsTomorrow;
        }
    
    public static void scheduleJob() {
        String jobName = 'ReminderScheduledJob';
        String cronExpression = '0 0 12 * * ?';

        // Schedule the job
        System.schedule(jobName, cronExpression, new InterviewReminderScheduledJob());
    }
    
}