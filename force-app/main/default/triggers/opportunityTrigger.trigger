trigger opportunityTrigger on Opportunity (before insert, before update) {
    if (Trigger.isUpdate) {

        Map<Id, boolean> isClosedOld = new Map<Id, boolean>();

        for (Opportunity opp : Trigger.old) {
            isClosedOld.put(opp.Id, opp.IsClosed);
        }

        for (Opportunity opp : Trigger.new) {
            if (!opp.IsClosed && !isClosedOld.get(opp.Id)) {
                continue;
            } else {
                opportunityTriggerHandler.manageOpportunity(trigger.new);
            }
        }
    }


    if (Trigger.isInsert) {
        opportunityTriggerHandler.manageOpportunity(trigger.new);
    }
    
}