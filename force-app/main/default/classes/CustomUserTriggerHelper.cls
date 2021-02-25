public class CustomUserTriggerHelper {
    public static void createMoneyReport(List<ETSelf__Custom_User__c> newCustomUser){
        List<ETSelf__Money_Report__c> moneyReportList = new List<ETSelf__Money_Report__c>();
        
        for(ETSelf__Custom_User__c cu:newCustomUser){
            ETSelf__Money_Report__c mr = new ETSelf__Money_Report__c();
            mr.ETSelf__Custom_User__c = cu.Id;
            mr.Name = cu.Name;
            moneyReportList.add(mr);
        }
        If(moneyReportList.size()>0){
            Insert moneyReportList;
        }
    }

}