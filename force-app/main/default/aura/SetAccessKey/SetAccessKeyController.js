({
    sendOTP : function(component, event, helper) {
        var Action = component.get("c.mailVerification");
        Action.setParams({
            customUserId : component.get("v.recordId")
        });
        Action.setCallback(this,function(response){
            var state = response.getState();
            console.log('sendOTP State--->'+state);
            if(state==='SUCCESS'){
                //console.log('OTP--->'+response.getReturnValue());
                component.set("v.OTP",response.getReturnValue());
                component.set("v.sendMailFlag",false);
                component.set("v.OTPVerifyFlag",true);
                component.set("v.AccessKeyFlag",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "SUCCESS",
                    "message": "OTP Send to Your Email Successfully."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(Action);
    },
    
    verifyOTP : function(component, event, helper) {
        var actualOTP = component.get("v.OTP");
        var checkOTP = component.get("v.inputOTP");
        if(actualOTP == checkOTP){
            component.set("v.sendMailFlag",false);
            component.set("v.OTPVerifyFlag",false);
            component.set("v.AccessKeyFlag",true);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type": "Error",
                "message": "Invalid OTP!!!"
            });
            toastEvent.fire();
        }
    },
    
    accessKeySet : function(component, event, helper) {
        var accessKey = component.get("v.AccessKey");
        var verifyAccessKey = component.get("v.verifyAccessKey");
        if(accessKey == verifyAccessKey){
            var Action = component.get("c.setAccessKey");
            Action.setParams({
                customUserId : component.get("v.recordId"),
                keyValue : component.get("v.AccessKey")
            });
            Action.setCallback(this,function(response){
                var state = response.getState();
                console.log('accessKeySet State--->'+state);
                if(state==='SUCCESS'){
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "SUCCESS",
                        "message": "Access Key Set successfully."
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(Action);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type": "Error",
                "message": "Confirm AccessKey is Wrong!!!"
            });
            toastEvent.fire();
        }
        
    }
})