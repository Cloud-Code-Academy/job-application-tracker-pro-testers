public with sharing class CalendarValidation{
    public static void checkforExistingInterviews(List<Event> newInterviews){

        Set<DateTime> InterviewDateTime = new Set<DateTime>();

        for (Event newInterview : newInterviews){
            InterviewDateTime.add(newInterview.StartDateTime);
        }

        List<Event> interviews = [SELECT Id
                                  FROM Event
                                  WHERE StartDateTime IN:InterviewDateTime];

        for (Event newInterview : newInterviews){
            if (newInterview.StartDateTime.format('EEEE') == 'Sunday' || newInterview.StartDateTime.format('EEEE') == 'Saturday'){

                newInterview.addError('Please choose a timeslot on a weekday. Weekends are unavailable.');

            } else if (!interviews.isEmpty()){

                newInterview.addError('This time slot is not available. Please choose a different one.');
            }
        }
    }

}