trigger InterviewReminderScheduledJobTrigger on Event (after insert, after update) {
    InterviewReminderScheduledJob.scheduleJob();
}