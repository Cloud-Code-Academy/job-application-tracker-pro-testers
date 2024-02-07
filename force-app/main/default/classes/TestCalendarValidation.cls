@isTest
public class TestCalendarValidation {

    // Test method for checkforExistingInterviews
    @isTest
    static void testCheckforExistingInterviews() {
        // Create test data
        List<Event> newInterviews = new List<Event>();
        Event e1 = new Event(StartDateTime = DateTime.newInstance(2023, 12, 11, 10, 0, 0), EndDateTime = DateTime.newInstance(2023, 12, 11, 11, 0, 0));
        Event e2 = new Event(StartDateTime = DateTime.newInstance(2023, 12, 12, 10, 0, 0), EndDateTime = DateTime.newInstance(2023, 12, 12, 11, 0, 0));
        Event e3 = new Event(StartDateTime = DateTime.newInstance(2023, 12, 13, 10, 0, 0), EndDateTime = DateTime.newInstance(2023, 12, 13, 11, 0, 0));
        newInterviews.add(e1);
        newInterviews.add(e2);
        newInterviews.add(e3);
        insert newInterviews;

        Test.startTest();

        // Call the method
        CalendarValidation.checkforExistingInterviews(newInterviews);

        Test.stopTest();

        // Verify errors
        System.assertEquals(1, newInterviews[0].getErrors().size());
        System.assertEquals('This time slot is not available. Please choose a different one.', newInterviews[1].getErrors()[0].getMessage());
        System.assertEquals('This time slot is not available. Please choose a different one.', newInterviews[2].getErrors()[0].getMessage());
    }
}
