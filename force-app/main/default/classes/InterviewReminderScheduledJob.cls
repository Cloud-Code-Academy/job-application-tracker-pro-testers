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
                                            WHERE DAY_ONLY(StartDateTime) = :tomorrow];
        System.debug(interviewsTomorrow);

        List<Messaging.SingleEmailMessage> reminderEmails = new List<Messaging.SingleEmailMessage>();

        //Retrieve the email address(es) of the event owner(s)


        // Iterate over the events (interviews) and send reminders
        for (Event event : interviewsTomorrow) {            
            String subject = 'Reminder: ' + event.Subject;
            String body = 'Hi ' + event.OwnerId + ',\n\n'
            + 'This is a reminder for your interview scheduled for tomorrow: ' + event.StartDateTime.format('yyyy-MM-dd HH:mm:ss') + '\n'
            + 'Best of luck! \n' 
            + 'You got this!';
            System.debug(event.Owner.Email);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{event.Owner.Email});
            mail.setSubject(subject);
            mail.setPlainTextBody(body);

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
    public static void scheduleJob() {
        String jobName = 'ReminderScheduledJob';
        String cronExpression = '0 0 12 * * ?';

        // Schedule the job
        System.schedule(jobName, cronExpression, new InterviewReminderScheduledJob());
    }
}