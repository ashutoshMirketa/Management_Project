public with sharing class opportunityTriggerHandler {

    public static void manageOpportunity(List<Opportunity> opportunities) {
        Map<Id, List<Opportunity>> opportunityMap = new Map<Id, List<Opportunity>>();
        Map<Id, Integer> openOpportunityForAccount = new Map<Id, Integer>();

        for (Opportunity opp : opportunities) {
            boolean open = false;

            if (opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost') {
                open = true;
            }

            Id accId = opp.AccountId;
            if (openOpportunityForAccount.containsKey(accId)) {
                if (open) {
                    opp.addError('There is already an Open Opportunity for this Customer');
                }
            }

            if (opportunityMap.containsKey(accId)) {
                opportunityMap.get(accId).add(opp);
            } else {
                opportunityMap.put(accId, new List<Opportunity>{opp});
            }

            if (open) {
                openOpportunityForAccount.put(accId, 1);
            }
        }



        // old opportunities :
        List<Opportunity> oldOpportunities = [SELECT Id, Name, StageName, AccountId FROM Opportunity WHERE AccountId IN: opportunityMap.keySet()  AND StageName != 'Closed Won' AND StageName != 'Closed Lost'];

        Map<Id, List<Opportunity>> oldOpportunityMap = new Map<Id, List<Opportunity>>();

        for (Opportunity opp : oldOpportunities) {
            Id accId = opp.AccountId;
            if (oldOpportunityMap.containsKey(accId)) {
                oldOpportunityMap.get(accId).add(opp);
            } else {
                oldOpportunityMap.put(accId, new List<Opportunity>{opp});
            }
        }


        for (List<Opportunity> opportunityList : opportunityMap.values()) {
            for (Opportunity opp : opportunityList) {
                if (opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost' && oldOpportunityMap.containsKey(opp.AccountId)) {
                    opp.addError('There is already an Open Opportunity for this Customer');
                }
            }
        }

    }
}


        // Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();
        // Map<Id, Integer> openCounter = new Map<Id, Integer>();

        // for (Opportunity opp : opportunities) {
        //     if (opportunityMap.containsKey(opp.AccountId)) {
        //         if (openCounter.containsKey(opp.AccountId)) {
        //             opp.addError('Can\'t add duplicate');
        //         } else {
        //             if (opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost') {
        //                 openCounter.put(opp.AccountId, 1);
        //             }
        //         }
        //     }

        //     opportunityMap.put(opp.AccountId, opp);
        // }

        // List<Opportunity> oldOpportunities = [SELECT Id, Name, StageName, AccountId FROM Opportunity WHERE AccountId IN: opportunityMap.keySet()  AND (StageName != 'Closed Won' AND StageName != 'Closed Lost')];

        // Map<Id, Opportunity> oldOpportunityMap = new Map<Id, Opportunity>();

        // for (Opportunity opp : oldOpportunities) {
        //     oldOpportunityMap.put(opp.AccountId, opp);
        // }

        // for (Opportunity opp : opportunities) {
        //     if (oldOpportunityMap.containsKey(opp.AccountId)) {
        //         if (opp.StageName != 'Closed Won' || opp.StageName != 'Closed Lost') {
        //             opp.addError('Can\'t add duplicate');
        //         }
        //     }
        // }