public with sharing class reusableLookupApexController {
    public reusableLookupApexController() {
        
    }
    
    
    
    @AuraEnabled(cacheable = true)
    public static List<SObject> findRecords(String searchKey, String objectName, String searchField){
        String key = '%' + searchKey + '%';
        String QUERY = 'Select Id, '+searchField+' From '+objectName +' Where '+searchField +' LIKE :key';
        System.debug(System.LoggingLevel.DEBUG, QUERY);
        List<SObject> sObjectList = Database.query(QUERY);
        return sObjectList;
    }
    
    
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String onRecordId,String searchKeyWord, String ObjectName,String userid,String onObjectName, String parentRecordId, String FilterId) {
        try{
            system.debug('FilterId---->'+FilterId);
            system.debug('parent record id---->'+parentRecordId);
            system.debug('onObjectName---->'+onObjectName);
            
            String searchKey = searchKeyWord + '%';
            String sQuery = '';
            Set<Id> orgIdSet = new Set<Id>();
            Set<Id> portIdSet = new Set<Id>();
            Set<Id> progIdSet = new Set<Id>();
            Set<Id> projIdSet = new Set<Id>();
            Set<Id> accessibleUserIdSet = new Set<Id>();
            Id programRecordId = null;
            Id portfolioRecordId = null;
            Id organizationRecordId = null;
            List<Id> notIdList = new List<Id>();
            notIdList.add(FilterId);
            
            if(ObjectName == 'Target_User__c'){
                String currentUserId = UserInfo.getUserId();
                sQuery = 'Select Id, Name From ETSelf__Custom_User__c Where (Id NOT in:notIdList) And (Name Like: searchKey) With SECURITY_ENFORCED';
            }
            else if(ObjectName == 'Entry_User__c'){
                String currentUserId = UserInfo.getUserId();
                sQuery = 'Select Id, Name From ETSelf__Custom_User__c Where (Name Like: searchKey) With SECURITY_ENFORCED';
            }
            else if(ObjectName == 'Money_Report__c'){
                String currentUserId = UserInfo.getUserId();
                sQuery = 'Select Id, Name From ETSelf__Money_Report__c Where (Name Like: searchKey) With SECURITY_ENFORCED';
            }
            system.debug('the sQuery--->'+sQuery);
            List<SObject> sObjectList = Database.query(sQuery);
            system.debug('the sObjectList--->'+sObjectList);
            return sObjectList;
        }
        catch(Exception e){
            system.debug('Exception: '+e.getMessage()+' at line number '+e.getLineNumber());
            List<SObject> sObjectList = new List<SObject>();
            return sObjectList;
        }
    }
    
    @AuraEnabled
    public static Sobject populatelookupValue(String BroId,String ObjectName){
        System.debug(ObjectName);
        System.debug('BroId--->'+BroId);
        sObject o;
        if(ObjectName == 'Entry_User__c'){
            ObjectName = 'ETSelf__Custom_User__c';
        }
        if(ObjectName!= '' && BroId!= null && BroId!= ''){
            String objAPIName = String.escapeSingleQuotes(ObjectName);
            String sQuery = 'select id,Name from' +' '+objAPIName+' '+ 'where id=:BroId With SECURITY_ENFORCED LIMIT 1';
            System.debug(sQuery);
            o=Database.query(sQuery);
        }
        return o;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value, List<String> selectedRecId) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        system.debug(fieldName+'-------------'+ObjectName+'---++----------'+value+'====='+selectedRecId);
        if(selectedRecId == null)
            selectedRecId = new List<String>();
        if(String.isNotEmpty(value)) {
            String query = 'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId';
            system.debug(query);
            for(sObject so : Database.Query(query)) {
                String fieldvalue = (String)so.get(fieldName);
                sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
            }
        }
        return sObjectResultList;
    }
    
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
        public SObJectResult() {
        }
    }
}