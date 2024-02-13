public with sharing class JobApplicationTaskCreator{
    public static void createTasks(List<Opportunity> jobApplications){
        List<Task> tasksToInsert = new List<Task>();

        for (Opportunity ja : jobApplications){
            // Check the job application stage and create tasks
            if (ja.StageName == 'Saved'){
                tasksToInsert.add(createTask(ja.Id, 'Check if the job description aligns with my interests and values'));
                tasksToInsert.add(createTask(ja.Id, 'Review the highlighted skills to see if the role is a good fit'));
                tasksToInsert.add(createTask(ja.Id, 'Research the company or role and mark my excitement level'));
            } else if (ja.StageName == 'Applying'){
                tasksToInsert.add(createTask(ja.Id, 'Find and research someone who works at the company and add them as a contact'));
                tasksToInsert.add(createTask(ja.Id, 'Set up an informational interview to learn more about the role/company'));
                tasksToInsert.add(createTask(ja.Id, 'Identify potential referrals to help with my application'));
                tasksToInsert.add(createTask(ja.Id, 'Customize my work achievements using the job description keywords'));
                tasksToInsert.add(createTask(ja.Id, 'Submit your application on the company website if possible'));
            } else if (ja.StageName == 'Applied'){
                tasksToInsert.add(createTask(ja.Id, 'Reach out to the hiring manager or recruiter'));
                tasksToInsert.add(createTask(ja.Id, 'Follow up on my application via email weekly'));
                tasksToInsert.add(createTask(ja.Id, 'Continue identifying and saving similar job opportunities'));
                tasksToInsert.add(createTask(ja.Id, 'Set up weekly networking calls to explore similar companies/roles'));
            } else if (ja.StageName == 'Interviewing'){
                tasksToInsert.add(createTask(ja.Id, 'Prepare my blurb or “tell me about yourself” response'));
                tasksToInsert.add(createTask(ja.Id, 'Practice answering behavioral interview questions'));
                tasksToInsert.add(createTask(ja.Id, 'Research the company and my interviewers'));
                tasksToInsert.add(createTask(ja.Id, 'Set up my virtual interview space and test tech'));
                tasksToInsert.add(createTask(ja.Id, 'Send thank you emails within 24 hours'));
            } else if (ja.StageName == 'Negotiating'){
                tasksToInsert.add(createTask(ja.Id, 'Research my market value and salary range'));
                tasksToInsert.add(createTask(ja.Id, 'Prepare negotiation scripts'));
                tasksToInsert.add(createTask(ja.Id, 'Evaluate the offer - decline or accept'));
            } else if (ja.StageName == 'Accepted'){
                tasksToInsert.add(createTask(ja.Id, 'Plan my resignation'));
                tasksToInsert.add(createTask(ja.Id, 'Plan a short vacation before starting the new job'));
                tasksToInsert.add(createTask(ja.Id, 'Prepare for my first day of onboarding'));
                //Send thank you email to primary contact
                EmailAutomation.sendThankYouEmailOnAccept();
            } else if (ja.StageName == 'Closed'){
                tasksToInsert.add(createTask(ja.Id, 'Send a follow-up email thanking the interviewer and asking for feedback'));
                tasksToInsert.add(createTask(ja.Id, 'Review my notes and reflect on areas of improvement'));
            }
        }

        if (!tasksToInsert.isEmpty()){
            insert tasksToInsert;
        }
    }

    @testVisible
    private static Task createTask(Id parentId, String taskSubject){
        Task newTask = new Task();
        newTask.WhatId = parentId; // Set the opportunity as the task's parent
        newTask.Subject = taskSubject;
        newTask.Status = 'Not Started'; // You can set other fields as needed
        newTask.Priority = 'Normal';
        newTask.ActivityDate = Date.today();
        return newTask;
    }

}