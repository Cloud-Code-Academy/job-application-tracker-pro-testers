trigger JobApplicationsTrigger on Opportunity (before insert, after insert, after update) {
    if (Trigger.isBefore && Trigger.isInsert) {
         JobListings scheduledJob = new JobListings();
        scheduledJob.execute(null);
    }
    
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        JobApplicationTaskCreator.createTasks(Trigger.new);
    }
}
