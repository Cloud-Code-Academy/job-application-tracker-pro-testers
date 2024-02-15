trigger CloseStaleJobApplicationsTrigger on Opportunity (after insert, after update) {
    CloseStaleJobApplications.scheduleJob();
}