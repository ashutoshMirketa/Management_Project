@isTest
private class InvoiceMailTriggerTest {

    @isTest
    private static void testingInvoiceMail() {
        Account testAccount = new Account(Name = 'test Account');
        insert testAccount;

        Id standardPricebook = Test.getStandardPricebookId();

        Opportunity testOpportunity = new Opportunity(Name = 'test Opportunity', AccountId = testAccount.Id, CloseDate = Date.today() + 3, Pricebook2Id = standardPricebook, StageName = 'Prospecting');
        insert testOpportunity;

        Contact testContact = new Contact(LastName = 'test Contact', AccountId = testAccount.Id);
        insert testContact;

        testAccount.Primary_contact__c = testContact.Id;
        update testAccount;

        Product2 testProduct = new Product2(Name = 'test Product', IsActive = true);
        insert testProduct;

        PricebookEntry testPricebookEntry = new PricebookEntry(IsActive = true, Product2Id = testProduct.Id, Pricebook2Id = standardPricebook, UnitPrice = 16.24);
        insert testPricebookEntry;

        OpportunityLineItem testLineItem = new OpportunityLineItem(Product2Id = testProduct.Id, OpportunityId = testOpportunity.Id, Quantity = 1, TotalPrice = 16.24);
        insert testLineItem;

        testOpportunity.StageName = 'Closed Won';
        update testOpportunity;

        List<Invoice__c> testInvoice = [SELECT Id FROM Invoice__c WHERE Opportunity__c =: testOpportunity.Id];
        System.assertEquals(1, testInvoice.size(), 'Invoice is being Created');

        System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');

        
    }
    
}