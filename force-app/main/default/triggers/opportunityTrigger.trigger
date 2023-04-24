trigger opportunityTrigger on Opportunity (before insert, before update) {
    opportunityTriggerHandler.manageOpportunity(trigger.new);
}