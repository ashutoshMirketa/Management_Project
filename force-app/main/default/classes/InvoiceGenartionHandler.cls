public with sharing class InvoiceGenartionHandler {
    public static void sendInvoiceEmail(List<Invoice__c> newRecordList){

        Id opportunityId;
        Id accountId;

        for (Invoice__c customInvoice : newRecordList) {
            opportunityId = customInvoice.Opportunity__c;
            accountId = customInvoice.Account__c;
        }

        
        List<OpportunityLineItem> OpportunityList = [SELECT Name, Product2.Name, Quantity, UnitPrice FROM OpportunityLineItem WHERE opportunityId =: opportunityId];


        Id primaryContactId = [SELECT Primary_contact__c FROM Account WHERE Id =: accountId].Primary_contact__c;
        Contact primaryContact = [SELECT Id, Email FROM Contact Where Id =: primaryContactId];

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();


        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setSubject('Invoice Generated');

        List<String> toAddress = new List<String>();
        toAddress.add(primaryContact.Email);
        mail.setToAddresses( toAddress );

        String table = '<table border="1"><thead><tr><th>Product Name</th><th>Price</th><th>Quantity</th></tr></thead><tbody>';

        for(OpportunityLineItem opp:OpportunityList){
            table+='<tr><td>' + opp.Product2.Name + '</td><td>' + opp.UnitPrice + '</td><td>' + opp.Quantity + '</td></tr>';
        }

        table += '</tbody></table>';
        mail.setHtmlBody(table);
        emailList.add(mail);


        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailList,false);
        
    }
}