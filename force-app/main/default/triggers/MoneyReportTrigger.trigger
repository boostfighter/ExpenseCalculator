trigger MoneyReportTrigger on ETSelf__Money_Report__c (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        //MoneyReportTriggerHelper.setName(trigger.new);
    }

}