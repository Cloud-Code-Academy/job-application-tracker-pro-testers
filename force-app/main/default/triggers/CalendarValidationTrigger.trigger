trigger CalendarValidationTrigger on Event(before insert ){
    CalendarValidation.checkforExistingInterviews(Trigger.new );
}