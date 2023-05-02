@isTest
private class opportunityTriggerTest {
    @isTest
    private static void opportunityTriggerTest() {
        Account acc = new Account(Name = 'Team 4');
        insert acc;
        
        Contact testContact = new Contact(LastName = 'test Contact', AccountId = acc.Id);
        insert testContact;
        
        acc.Primary_contact__c = testContact.Id;
        update acc;

        Opportunity opportunity1 = new Opportunity(
            Name = 'opp1',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = date.today() + 3
        );

        Opportunity opportunity2 = new Opportunity(
            Name = 'opp2',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = date.today() + 3
        );

        Opportunity opportunity3 = new Opportunity(
            Name = 'opp3',
            AccountId = acc.Id,
            StageName = 'Closed Won',
            CloseDate = date.today() + 3
        );

        Opportunity opportunity4 = new Opportunity(
            Name = 'opp4',
            AccountId = acc.Id,
            StageName = 'Closed Lost',
            CloseDate = date.today() + 3
        );

        List<Opportunity> insertMultipleOpen = new List<Opportunity>();
        insertMultipleOpen.add(opportunity1);
        insertMultipleOpen.add(opportunity2);

        try {
            insert insertMultipleOpen;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('Cannot add multiple open opportunities'));
        }


        try {
            insert opportunity1;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        List<Opportunity> opportunityList = [SELECT Id, Name FROM Opportunity];

        System.assertEquals(1, opportunityList.size(), 'Condition 1 - success');

        try {
            insert opportunity3;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
        opportunityList = [SELECT Id, Name FROM Opportunity];

        System.assertEquals(2, opportunityList.size(), 'Condition 2 - success');

        try {
            insert opportunity2;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('There is already an Open Opportunity for this Customer'));
            // System.debug(e.getMessage());
        }
        
        opportunityList = [SELECT Id, Name FROM Opportunity];

        System.assertEquals(2, opportunityList.size(), 'Condition 3 - success');


        try {
            insert opportunity4;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
        opportunityList = [SELECT Id, Name FROM Opportunity];

        System.assertEquals(3, opportunityList.size(), 'Condition 4 - success');


        Opportunity fetchedOpp = [SELECT Id, Name, StageName FROM Opportunity WHERE Name = 'opp3'];
        fetchedOpp.StageName = 'Prospecting';

        try {
            update fetchedOpp;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        opportunityList = [SELECT Id, Name FROM Opportunity WHERE StageName = 'Prospecting'];
        System.assertEquals(1, opportunityList.size(), 'Condition 5 - success');

    }
}