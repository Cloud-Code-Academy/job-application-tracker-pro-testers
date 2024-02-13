@isTest
private class Test_JobApplicationTaskCreator {

    // Test method for createTasks
    @isTest
    static void testCreateTasks() {
        // Create test data
        List<Opportunity> jobApplications = new List<Opportunity>();
        Opportunity opp1 = new Opportunity(Name = 'Opp1', CloseDate = System.today().addDays(11), StageName = 'Saved');
        Opportunity opp2 = new Opportunity(Name = 'Opp2', CloseDate = System.today().addDays(11), StageName = 'Applying');
        Opportunity opp3 = new Opportunity(Name = 'Opp3', CloseDate = System.today().addDays(11), StageName = 'Applied');
        Opportunity opp4 = new Opportunity(Name = 'Opp4', CloseDate = System.today().addDays(11), StageName = 'Interviewing');
        Opportunity opp5 = new Opportunity(Name = 'Opp5', CloseDate = System.today().addDays(11), StageName = 'Negotiating');
        Opportunity opp6 = new Opportunity(Name = 'Opp6', CloseDate = System.today().addDays(11), StageName = 'Accepted');
        jobApplications.add(opp1);
        jobApplications.add(opp2);
        jobApplications.add(opp3);
        jobApplications.add(opp4);
        jobApplications.add(opp5);
        jobApplications.add(opp6);
        insert jobApplications;

        Test.startTest();

        // Call the method
        JobApplicationTaskCreator.createTasks(jobApplications);

        Test.stopTest();

        // Verify task creation
        List<Task> tasks = [SELECT Id, WhatId, Subject, Status, Priority, ActivityDate FROM Task];
        System.assertEquals(23, tasks.size(), 'Incorrect number of tasks created');
    }

    // Test method for createTask
    @isTest
    static void testCreateTask() {
        // Create test opportunity record
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', StageName = 'Saved', CloseDate = System.today().addDays(11));
        insert testOpp;

        // Call the method
        Task task = JobApplicationTaskCreator.createTask(testOpp.Id, 'Test Task');

        // Verify task creation
        System.assertEquals(testOpp.Id, task.WhatId, 'Wrong Id');
        System.assertEquals('Test Task', task.Subject, 'Wrong subject');
        System.assertEquals('Not Started', task.Status, 'Wrong status');
        System.assertEquals('Normal', task.Priority, 'Wrong priority');
        System.assertEquals(Date.today(), task.ActivityDate, 'Wrong activity date');
    }
}
