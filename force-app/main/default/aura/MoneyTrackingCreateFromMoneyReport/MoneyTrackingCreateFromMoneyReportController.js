({
    doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
        var Action = component.get("c.getObjDetails");
        Action.setParams({
            recId : component.get("v.recordId")
        });
        Action.setCallback(this,function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                var res = response.getReturnValue();
                component.set("v.EntryUserId",res.ETSelf__Custom_User__c);
                console.log('EntryUserId',+res.ETSelf__Custom_User__c);
                component.set("v.MoneyReportId",res.Id);
                component.set("v.Spinner", false);
            }
            else{
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(Action);
    },
    
    AKValidate : function(component, event, helper) {
        component.set("v.Spinner", true);
        var Action = component.get("c.AccessKeyVerify");
        Action.setParams({
            recId : component.get("v.recordId"),
            accessKey : component.get("v.inputAccessKey")
        });
        Action.setCallback(this,function(response){
            var state = response.getState();
            console.log('AKValidate State--->'+state);
            if(state==='SUCCESS'){
                console.log('isAccessable--->'+response.getReturnValue());
                if(response.getReturnValue()==true){
                    component.set("v.AccessOrNot",false);
                    component.set("v.isAccess",true);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "Error",
                        "message": "Invalid Access Key!!!"
                    });
                    toastEvent.fire();
                }
                component.set("v.Spinner", false);
            }
            else{
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(Action);
    },
    
    handleOnSubmit : function(component, event, helper) {
        component.set("v.Spinner", true);
        var Histo = component.find("whyId");
        var value = Histo.get("v.value");
        if (value==null || value=="") {
            //show error 'please fill why field'
            component.set("v.Spinner",false);
            alert('Please Fill Historical Comment');
            event.preventDefault();
        }
    },
    
    saveRecord : function(component, event, helper){
        component.set("v.Spinner", true);
        var isValid = true;
        var mtObj = component.get("v.MoneyTrackingObj");
        var entryUser = component.get("v.EntryUserId");
        var targetUser = component.get("v.selectedTargetUserLookUpRecord").Id;
        var moneyReport = component.get("v.MoneyReportId");
        var amount = component.get("v.Amount");
        var type = component.get("v.Type");
        var why = component.get("v.Why");
        
        mtObj.ETSelf__Entry_User__c = entryUser;
        mtObj.ETSelf__Target_User__c = targetUser;
        mtObj.ETSelf__Money_Report__c = moneyReport;
        mtObj.ETSelf__Amount__c = amount;
        mtObj.ETSelf__Type__c = type;
        mtObj.ETSelf__Why__c = why;
        
        if(isValid){
            var action = component.get("c.saveMoneyEntry");
            action.setParams({
                moneyTracking: mtObj
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.Spinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : "Success!",
                        type : "SUCCESS",
                        message : "Money Entry Successfully Inserted.",
                        duration: "3000",
                        key: "info_alt",
                        mode: "pester"
                    });
                    toastEvent.fire();
                }
                else{
                    component.set("v.Spinner", false);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            component.set("v.Spinner", false);
        }
    }
    
})