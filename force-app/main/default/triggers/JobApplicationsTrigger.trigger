trigger JobApplicationsTrigger on Opportunity (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        JobApplicationTaskCreator.createTasks(Trigger.new);
    }
}
