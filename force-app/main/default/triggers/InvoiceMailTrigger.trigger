trigger InvoiceMailTrigger on Invoice__c (before insert) {
    InvoiceGenartionHandler.sendInvoiceEmail(trigger.new);
}