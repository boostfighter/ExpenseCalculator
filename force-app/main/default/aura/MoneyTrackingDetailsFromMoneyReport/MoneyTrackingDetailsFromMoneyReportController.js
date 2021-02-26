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
                component.set("v.EntryUserName",res.ETSelf__Custom_User__r.Name);//FullName.split(' ').slice(0, -1).join(' ')
                component.set("v.Spinner", false);
            }
            else{
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(Action);
    },
    
    getDetails : function(component, event, helper) {
        component.set("v.Spinner",true);
        var Action = component.get("c.AccessKeyVerify");
        Action.setParams({
            recId : component.get("v.recordId"),
            accessKey : component.get("v.inputAccessKey")
        });
        Action.setCallback(this,function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                if(response.getReturnValue()==true){
                    //----------------get Details--------------
                    //-----------------------------------------
                    component.set("v.TargetUserFlag",false);
                    component.set("v.TargetUserName",component.get("v.selectedTargetUserLookUpRecord").Name);//FullName.split(' ').slice(0, -1).join(' ')
                    var recId = component.get("v.recordId");
                    var action = component.get("c.fetchMoneyTrackingDetails");
                    action.setParams({
                        entryUserId : component.get("v.EntryUserId"),
                        targetUserId : component.get("v.selectedTargetUserLookUpRecord").Id
                    });
                    action.setCallback(this,function(response){
                        var state = response.getState();
                        if(state=='SUCCESS'){
                            var resp = response.getReturnValue();
                            var res = resp.reverse();
                            if(res.length>0){
                                component.set("v.LastTotal",res[res.length-1].UserName);
                                component.set("v.Line",res[res.length-2].UserName);
                                component.set("v.rowNumberMin",res[0].rowNumber);
                                component.set("v.rowNumberMax",res[res.length-3].rowNumber);
                                console.log('rowNumberMin-->'+res[0].rowNumber);
                                console.log('rowNumberMax-->'+res[res.length-3].rowNumber);
                                component.set("v.MTListAvailable",true);
                                component.set("v.MoneyTrackingList",res);
                                component.set("v.Spinner",false);
                            }else{
                                component.set("v.MTListAvailable",false);
                                component.set("v.EmptyCheck",true);
                                component.set("v.Spinner",false);
                            }
                        }
                        else{
                            component.set("v.Spinner",false);
                        }
                    });
                    $A.enqueueAction(action);
                    //-----------------------------------------
                    //-----------------------------------------
                }else{
                    component.set("v.Spinner",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "Error",
                        "message": "Invalid Access Key!!!"
                    });
                    toastEvent.fire();
                }
            }
            else{
                component.set("v.Spinner",false);
            }
        });
        $A.enqueueAction(Action);
    },
    
    previousClick : function(component, event, helper) {
        component.set("v.Spinner",true);
        var recId = component.get("v.recordId");
        var action = component.get("c.fetchPreviousMoneyTrackingDetails");
        action.setParams({
            entryUserId : component.get("v.EntryUserId"),
            targetUserId : component.get("v.selectedTargetUserLookUpRecord").Id,
            totalValue : component.get("v.LastTotal"),
            rowNumberMin : component.get("v.rowNumberMin")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state-------------'+state);
            if(state=='SUCCESS'){
                var resp = response.getReturnValue();
                var res = resp.reverse();
                if(res.length>0){
                    component.set("v.Spinner",false);
                    component.set("v.rowNumberMin",res[0].rowNumber);
                    component.set("v.rowNumberMax",res[res.length-3].rowNumber);
                    console.log('prev rowNumberMin-->'+res[0].rowNumber);
                    console.log('prev rowNumberMax-->'+res[res.length-3].rowNumber);
                    component.set("v.MoneyTrackingList",res);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "Error",
                        "message": "No More Row Available!!!"
                    });
                    toastEvent.fire();
                    component.set("v.Spinner",false);
                }
            }
            else{
                component.set("v.Spinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    
    nextClick : function(component, event, helper) {
        component.set("v.Spinner",true);
        console.log('next row no max--->'+component.get("v.rowNumberMax"));
        var recId = component.get("v.recordId");
        var action = component.get("c.fetchPreviousMoneyTrackingDetails");
        action.setParams({
            entryUserId : component.get("v.EntryUserId"),
            targetUserId : component.get("v.selectedTargetUserLookUpRecord").Id,
            totalValue : component.get("v.LastTotal"),
            rowNumberMax : component.get("v.rowNumberMax")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=='SUCCESS'){
                var res = response.getReturnValue();
                component.set("v.Spinner",false);
                //var res = resp.reverse();
                if(res.length>0){
                    component.set("v.rowNumberMin",res[0].rowNumber);
                    component.set("v.rowNumberMax",res[res.length-3].rowNumber);
                    console.log('prev rowNumberMin-->'+res[0].rowNumber);
                    console.log('prev rowNumberMax-->'+res[res.length-3].rowNumber);
                    component.set("v.MoneyTrackingList",res);
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "Error",
                        "message": "No More Row Available!!!"
                    });
                    toastEvent.fire();
                    component.set("v.Spinner",false);
                }
            }
            else{
                component.set("v.Spinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    
    reset : function(component, event, helper) {
        component.set("v.TargetUserFlag",true);
        component.set("v.MTListAvailable",false);
        component.set("v.EmptyCheck",false);
    },
    
    moreClick : function(component, event, helper) {
        var getAllId = component.find("boxPack");
        alert('More Click');
        //var moneyTrackingId = event.getSource().get("v.value");
        //alert('More Clickk--->'+component.find("boxPack")[1].get("v.valuee"));
    }
})