@isTest
public class MoneytrackingControllerTest {
    @testSetup
    static void setup(){
        Custom_User__c cu = new Custom_User__c(Name='Debabrata Ghosh',Email__c='avroghosh333@gmail.com');
        Insert cu;
        
        Custom_User__c cu2 = new Custom_User__c(Name='Avro Ghosh',Email__c='avroghosh3333@gmail.com');
        Insert cu2;
        
        Money_Report__c mr = new Money_Report__c(Custom_User__c=cu.Id);
        Insert mr;
        
        List<Money_Tracking__c> mtList = new List<Money_Tracking__c>();
        Money_Tracking__c mt = new Money_Tracking__c(Money_Report__c=mr.Id,Amount__c=34,Type__c='Due',Why__c='test',Entry_User__c=cu.Id,Target_User__c=cu2.Id);
        mtList.add(mt);
        Money_Tracking__c mt2 = new Money_Tracking__c(Money_Report__c=mr.Id,Amount__c=34,Type__c='Due',Why__c='test',Entry_User__c=cu2.Id,Target_User__c=cu.Id);
        mtList.add(mt2);
        Money_Tracking__c mt3 = new Money_Tracking__c(Money_Report__c=mr.Id,Amount__c=34,Type__c='Paid',Why__c='test',Entry_User__c=cu.Id,Target_User__c=cu2.Id);
        mtList.add(mt3);
        Money_Tracking__c mt4 = new Money_Tracking__c(Money_Report__c=mr.Id,Amount__c=34,Type__c='Paid',Why__c='test',Entry_User__c=cu2.Id,Target_User__c=cu.Id);
        mtList.add(mt4);
        
        Insert mtList;
        
    }
    @isTest static void test() {
        Money_Report__c mr = [Select Id,Name,Custom_User__c From Money_Report__c Limit 1];
        List<Custom_User__c> lu = [Select Id From Custom_User__c];
        Test.startTest();
        String recId = mr.Id;
        String accessKey = '123456';
        AccessKeyController.mailVerification(mr.Custom_User__c);
        AccessKeyController.setAccessKey(mr.Custom_User__c, accessKey);
        MoneytrackingController.AccessKeyVerify( recId, accessKey);
        MoneytrackingController.getObjDetails(recId);
        MoneytrackingController.fetchMoneyTrackingDetails(lu[0].Id,lu[1].Id);
        MoneytrackingController.fetchPreviousMoneyTrackingDetails(lu[0].Id,lu[1].Id,'34','0','0');//String entryUserId, String targetUserId, String totalValue, String rowNumberMin, String rowNumberMax
        reusableLookupApexController.findRecords('abc', 'Custom_User__c', 'Name');
        reusableLookupApexController.fetchLookUpValues('','', 'Custom_User__c','','', '', '');
        Test.stopTest();
    }

}