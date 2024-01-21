global class InterviewReminderScheduledJob implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        sendInterviewReminders();
    }

    public static void sendInterviewReminders() {
        // Query events (interviews) with a start date of tomorrow
        Date tomorrow = System.today().addDays(1);
        List<Event> interviewsTomorrow = [SELECT Id, Subject, StartDateTime, Location, Owner.Email
                                       FROM Event
                                       WHERE StartDateTime = :tomorrow];

        // Iterate over the events (interviews) and send reminders
        for (Event event : interviewsTomorrow) {
            sendReminderEmail(event);
        }
    }

    private static void sendReminderEmail(Event event) {
        String subject = 'Reminder: ' + event.Subject;
        String body = getReminderEmailBody(event);

        // Retrieve the owner's email address
        String toAddress = event.Owner.email;

        // Send the email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { toAddress });
        mail.setSubject(subject);
        mail.setHtmlBody(body);

        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    private static String getReminderEmailBody(Event event) {
        // Retrieve template text from metadata 
        String templateText = getTemplateText();

        // Replace merge fields in the template with event details
        templateText = templateText.replace('{!Event.Subject}', event.Subject);
        templateText = templateText.replace('{!Event.StartDateTime}', String.valueOf(event.StartDateTime));
        templateText = templateText.replace('{!Event.Location}', event.Location);

        return templateText;
    }

    // 
    private static String getTemplateText() {
        
        return '<html><body><p>Interview Reminder: {!Event.Subject}</p><p>Date: {!Event.StartDateTime}</p><p>Location: {!Event.Location}</p></body></html>';
    }
}
