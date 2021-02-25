trigger CustomUserTrigger on ETSelf__Custom_User__c (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        CustomUserTriggerHelper.createMoneyReport(trigger.new);
    }

}