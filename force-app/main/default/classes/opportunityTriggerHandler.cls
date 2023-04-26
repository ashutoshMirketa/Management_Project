public with sharing class opportunityTriggerHandler {

    public static void manageOpportunity(List<Opportunity> opportunities) {

        // an account can have multiple opportunities - so i will take a list of opportunity and map it with the accountId - this map will contain both open and close opp
        Map<Id, List<Opportunity>> opportunityMap = new Map<Id, List<Opportunity>>();
        
        //This map is to check if there are multiple open opportunities
        Map<Id, Integer> openOpportunityForAccount = new Map<Id, Integer>();

        /* FILTERING OUT NEW RECORD -> SUCH THAT MULTIPLE OPEN OPPORTUNITIES FOR A CUSTOMER IS NOT THERE */

        for (Opportunity opp : opportunities) {
            boolean open = false;

            if (!opp.IsClosed) {
                open = true;
            }

            Id accId = opp.AccountId;
            // if there is already an existing open opportunity
            if (openOpportunityForAccount.containsKey(accId)) {
                // if the current opportunity is open -> add an error
                if (open) {
                    opp.addError('Cannot add multiple open opportunities');
                }
            }

            // if everything is fine -> single open opportunity or a closed opportunity is there
            if (opportunityMap.containsKey(accId)) {
                opportunityMap.get(accId).add(opp);
            } else {
                opportunityMap.put(accId, new List<Opportunity>{opp});
            }

            // if it is a single opportunity we need to make sure that there is no other open opportunity -> so i will update the open opportunity map
            if (open) {
                openOpportunityForAccount.put(accId, 1);
            }
        }

        /* CHECKING WITH OLD RECORD */

        // getting list of old opportunities that are related to the accounts and are open :
        List<Opportunity> oldOpportunities = [SELECT Id, Name, StageName, AccountId FROM Opportunity WHERE AccountId IN: opportunityMap.keySet()  AND IsClosed = false];

        // map to put old opportunities so that we can lookup using the related accountId
        Map<Id, List<Opportunity>> oldOpportunityMap = new Map<Id, List<Opportunity>>();

        // Filling in the oldOpportunity Map
        for (Opportunity opp : oldOpportunities) {
            Id accId = opp.AccountId;
            if (oldOpportunityMap.containsKey(accId)) {
                oldOpportunityMap.get(accId).add(opp);
            } else {
                oldOpportunityMap.put(accId, new List<Opportunity>{opp});
            }
        }


        // matching all the new opportunities with old opportunities -> if there is already an open opportunity for an account we will add an error
        for (List<Opportunity> opportunityList : opportunityMap.values()) {
            for (Opportunity opp : opportunityList) {
                if (!opp.IsClosed && oldOpportunityMap.containsKey(opp.AccountId)) {
                    opp.addError('There is already an Open Opportunity for this Customer');
                }
            }
        }

    }
}