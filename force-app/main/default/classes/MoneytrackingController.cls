public without sharing class MoneytrackingController {
    @AuraEnabled
    public static Boolean AccessKeyVerify(String recId,String accessKey){
        boolean isAccessable = false;
        ETSelf__Money_Report__c MR = [Select Id,ETSelf__Custom_User__c,ETSelf__Custom_User__r.ETSelf__Access_Key__c From ETSelf__Money_Report__c Where Id=:recId Limit 1];
        system.debug('--->'+MR.ETSelf__Custom_User__r.ETSelf__Access_Key__c);
        if(MR.ETSelf__Custom_User__r.ETSelf__Access_Key__c != '' && MR.ETSelf__Custom_User__r.ETSelf__Access_Key__c !=null){
            Blob encryptedData = EncodingUtil.base64decode(MR.ETSelf__Custom_User__r.ETSelf__Access_Key__c); 
            String keyString = 'MG6+kr7jRH9CIA/FPx0ZcUg/BiPF7j23kw5Yujp7daM=';
            Blob cryptoKey = EncodingUtil.base64decode(keyString);
            // Decrypt the data - the first 16 bytes contain the initialization vector
            Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedData);
            
            // Decode the decrypted data for subsequent use
            String decryptedDataString = decryptedData.toString();
            
            if(decryptedDataString == accessKey){
                isAccessable = true;
            }
        }
        return isAccessable;
    }
    
    @AuraEnabled
    public static ETSelf__Money_Report__c getObjDetails(String recId){
        ETSelf__Money_Report__c mr = new ETSelf__Money_Report__c();
        mr = [Select Id,Name,ETSelf__Custom_User__c,ETSelf__Custom_User__r.Name From ETSelf__Money_Report__c Where Id=:recId];
        return mr;
    }
    
    @AuraEnabled
    public static void saveMoneyEntry(ETSelf__Money_Tracking__c moneyTracking){
        Insert moneyTracking;
    }
    
    @AuraEnabled
    public static List<wrapperClass> fetchMoneyTrackingDetails(String entryUserId, String targetUserId){
        List<wrapperClass> Wrapper = new List<wrapperClass>();
        Decimal DueAmount = 0;
        Decimal PaidAmount = 0;
        Decimal TotalEntryUserDue = 0;
        Decimal TotalTargetUserPaid = 0;
        Decimal TotalEntryUserPaid = 0;
        Decimal TotalTargetUserDue = 0;
        Decimal CalculatedFinalAmount = 0;
        String TargetUsserName = '';
        try{
            List<ETSelf__Money_Tracking__c> MoneyTackingList = new List<ETSelf__Money_Tracking__c>();
            List<ETSelf__Money_Tracking__c> MoneyTackingListAll = new List<ETSelf__Money_Tracking__c>();
            MoneyTackingList = [Select id,Name,ETSelf__Amount__c,ETSelf__Type__c,ETSelf__Entry_User__c,ETSelf__Entry_User__r.Name,ETSelf__Target_User__c,ETSelf__Target_User__r.Name,ETSelf__Why__c,ETSelf__Money_Report__c,CreatedDate,ETSelf__Row_Number__c From ETSelf__Money_Tracking__c Where (ETSelf__Entry_User__c=:entryUserId AND ETSelf__Target_User__c=:targetUserId) OR (ETSelf__Entry_User__c=:targetUserId AND ETSelf__Target_User__c=:entryUserId) ORDER by CreatedDate DESC Limit 5];
            MoneyTackingListAll = [Select id,Name,ETSelf__Amount__c,ETSelf__Type__c,ETSelf__Entry_User__c,ETSelf__Entry_User__r.Name,ETSelf__Target_User__c,ETSelf__Target_User__r.Name,ETSelf__Why__c,ETSelf__Money_Report__c,CreatedDate,ETSelf__Row_Number__c From ETSelf__Money_Tracking__c Where (ETSelf__Entry_User__c=:entryUserId AND ETSelf__Target_User__c=:targetUserId) OR (ETSelf__Entry_User__c=:targetUserId AND ETSelf__Target_User__c=:entryUserId) ORDER by CreatedDate DESC];
            TargetUsserName = [Select Id,Name From ETSelf__Custom_User__c Where Id=:targetUserId Limit 1].Name;
            
            if(MoneyTackingListAll.size()>0){
                for(ETSelf__Money_Tracking__c mt : MoneyTackingListAll){
                    //-------------calculate total amount-------------
                    if(mt.ETSelf__Entry_User__c==entryUserId){
                        if(mt.ETSelf__Type__c == 'Due'){
                            TotalEntryUserDue = TotalEntryUserDue + mt.ETSelf__Amount__c;
                        }
                        if(mt.ETSelf__Type__c == 'Paid'){
                            TotalEntryUserPaid = TotalEntryUserPaid + mt.ETSelf__Amount__c;
                        }
                    }
                    else if(mt.ETSelf__Entry_User__c==targetUserId){
                        if(mt.ETSelf__Type__c == 'Due'){
                            TotalTargetUserDue = TotalTargetUserDue + mt.ETSelf__Amount__c;
                        }
                        if(mt.ETSelf__Type__c == 'Paid'){
                            TotalTargetUserPaid = TotalTargetUserPaid + mt.ETSelf__Amount__c;
                        }
                        
                    }
                }
                //-------------------------------------------------
                CalculatedFinalAmount = (TotalEntryUserDue - TotalTargetUserPaid) + (TotalEntryUserPaid - TotalTargetUserDue) ;
                TargetUsserName = TargetUsserName.Substring(0,TargetUsserName.indexOf(' '));
                wrapperClass Wrap = new wrapperClass();
                if(CalculatedFinalAmount>0){
                    Wrap.UserName = 'Get From ' +TargetUsserName+ '--->'+CalculatedFinalAmount;
                }
                else{
                    CalculatedFinalAmount = -CalculatedFinalAmount;
                    Wrap.UserName = 'Pay To ' +TargetUsserName+ '--->'+CalculatedFinalAmount;
                }
                Wrapper.add(Wrap);
                wrapperClass Wrapp = new wrapperClass();
                Wrapp.UserName = '----------------------------';
                Wrapper.add(Wrapp);
            }
            if(MoneyTackingList.size()>0){
                for(ETSelf__Money_Tracking__c mt : MoneyTackingList){
                    wrapperClass Wrap = new wrapperClass();
                    Wrap.mtId = mt.Id;
                    Wrap.UserName = mt.ETSelf__Entry_User__r.Name;
                    Wrap.DateTimeValue = mt.CreatedDate.format('MMM dd | hh:mm a');
                    Wrap.Why = mt.ETSelf__Why__c;
                    Wrap.rowNumber = String.valueof(mt.ETSelf__Row_Number__c);
                    if(mt.ETSelf__Type__c == 'Due'){
                        Wrap.DueAmount = mt.ETSelf__Amount__c;
                    }
                    if(mt.ETSelf__Type__c == 'Paid'){
                        Wrap.PaidAmount = mt.ETSelf__Amount__c;
                    }
                    Wrapper.add(Wrap);
                }
            } 
        }
        catch(Exception e){
            String v1 = 'Exception : '+ e.getMessage()+' at line number : '+e.getLineNumber();
            System.debug(v1);
        }
        return Wrapper;
    }
    
    @AuraEnabled
    public static List<wrapperClass> fetchPreviousMoneyTrackingDetails(String entryUserId, String targetUserId, String totalValue, String rowNumberMin, String rowNumberMax){
        system.debug('rowNumberMin--->'+rowNumberMin);
        system.debug('rowNumberMax--->'+rowNumberMax);
        List<wrapperClass> Wrapper = new List<wrapperClass>();
        try{
            List<ETSelf__Money_Tracking__c> MoneyTackingList = new List<ETSelf__Money_Tracking__c>();
            if(rowNumberMin != null){
                MoneyTackingList = [Select id,Name,ETSelf__Amount__c,ETSelf__Type__c,ETSelf__Entry_User__c,ETSelf__Entry_User__r.Name,ETSelf__Target_User__c,ETSelf__Target_User__r.Name,Why__c,ETSelf__Money_Report__c,CreatedDate,ETSelf__Row_Number__c From ETSelf__Money_Tracking__c Where ((ETSelf__Entry_User__c=:entryUserId AND ETSelf__Target_User__c=:targetUserId) OR (ETSelf__Entry_User__c=:targetUserId AND ETSelf__Target_User__c=:entryUserId)) AND ETSelf__Row_Number__c<:integer.valueof(rowNumberMin) ORDER by CreatedDate DESC Limit 5];
            }
            if(rowNumberMax != null){
                MoneyTackingList = [Select id,Name,ETSelf__Amount__c,ETSelf__Type__c,ETSelf__Entry_User__c,ETSelf__Entry_User__r.Name,ETSelf__Target_User__c,ETSelf__Target_User__r.Name,ETSelf__Why__c,ETSelf__Money_Report__c,CreatedDate,ETSelf__Row_Number__c From ETSelf__Money_Tracking__c Where ((ETSelf__Entry_User__c=:entryUserId AND ETSelf__Target_User__c=:targetUserId) OR (ETSelf__Entry_User__c=:targetUserId AND ETSelf__Target_User__c=:entryUserId)) AND ETSelf__Row_Number__c>:integer.valueof(rowNumberMax) ORDER by CreatedDate ASC Limit 5];
            }
            
            if(MoneyTackingList.size()>0 && rowNumberMin != null){
                wrapperClass Wrap = new wrapperClass();
                Wrap.UserName = totalValue;
                Wrapper.add(Wrap);
                
                wrapperClass Wrapp = new wrapperClass();
                Wrapp.UserName = '----------------------------';
                Wrapper.add(Wrapp);
            }
            if(MoneyTackingList.size()>0){
                for(ETSelf__Money_Tracking__c mt : MoneyTackingList){
                    system.debug('MoneyTackingList row no--->'+mt.Row_Number__c);
                    wrapperClass Wrap = new wrapperClass();
                    Wrap.mtId = mt.Id;
                    Wrap.UserName = mt.Entry_User__r.Name;
                    Wrap.DateTimeValue = mt.CreatedDate.format('MMM dd | hh:mm a');
                    Wrap.Why = mt.ETSelf__Why__c;
                    Wrap.rowNumber = String.valueof(mt.ETSelf__Row_Number__c);
                    if(mt.ETSelf__Type__c == 'Due'){
                        Wrap.DueAmount = mt.ETSelf__Amount__c;
                    }
                    if(mt.ETSelf__Type__c == 'Paid'){
                        Wrap.PaidAmount = mt.ETSelf__Amount__c;
                    }
                    Wrapper.add(Wrap);
                }
            } 
            if(MoneyTackingList.size()>0 && rowNumberMax != null){
                wrapperClass Wrapp = new wrapperClass();
                Wrapp.UserName = '----------------------------';
                Wrapper.add(Wrapp);
                
                wrapperClass Wrap = new wrapperClass();
                Wrap.UserName = totalValue;
                Wrapper.add(Wrap);
            }
        }
        catch(Exception e){
            String v1 = 'Exception : '+ e.getMessage()+' at line number : '+e.getLineNumber();
            System.debug(v1);
        }
        return Wrapper;
    }
    
    public class wrapperClass{
        @AuraEnabled public String UserName;
        @AuraEnabled public Decimal DueAmount;
        @AuraEnabled public Decimal PaidAmount;
        @AuraEnabled public String DateTimeValue;
        @AuraEnabled public String Why;
        @AuraEnabled public String rowNumber;
        @AuraEnabled public String mtId;
    }
}