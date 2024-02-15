public class CloseStaleJobApplications implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Query for stale job applications
        List<Opportunity> staleJobApplications = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE (StageName NOT IN ('Closed', 'Accepted'))
            AND follow_up_date__c < LAST_N_DAYS:30
        ];

        // Close stale job applications
        if (!staleJobApplications.isEmpty()) {
            List<Opportunity> applicationsToUpdate = new List<Opportunity>();
            for (Opportunity application : staleJobApplications) {
                application.StageName = 'Closed';
                application.Notes__c = 'Closed due to inactivity.';
                applicationsToUpdate.add(application);
        }
        // Update the status of stale job applications        
        update applicationsToUpdate;
    } else {
        System.debug('There are no job applications to close due to inactivity.');
        }
    }
    public static void scheduleJob() {
        String jobName = 'CloseStaleApplicationsJob';
        String cronExpression = '0 0 12 * * ?';

        // Schedule the job
        System.schedule(jobName, cronExpression, new CloseStaleJobApplications());
    }
}