({
    doInit : function(component, event, helper) {
        //console.log('it is doinit');
        var Bid=component.get("v.BrokerId");
        var recordId = component.get("v.recordId");
        var objName=component.get("v.objectAPIName"); 
        
        ////console.log("Record Id----->"+recordId);
        //console.log("This BrokerId------->"+Bid);
        ////console.log("This ObjeAPIName------->"+objName );
        
        // ////console.log(component.get("v.BrokerId"));
        ////console.log("Enter");
        
        var action = component.get("c.populatelookupValue");
        ////console.log(action);
        action.setParams({
            BroId :component.get("v.BrokerId"),
            ObjectName :component.get("v.objectAPIName")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.selectedRecord" , response.getReturnValue());
                var forclose = component.find("lookup-pill");
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');
                
                var forclose = component.find("searchRes");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
                
                var lookUpTarget = component.find("lookupField");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
                var utilitySearch=component.find("utilitySearch");
                $A.util.addClass(utilitySearch,'slds-hide');
                $A.util.removeClass(utilitySearch,'slds-show');
                ////console.log(response.getReturnValue());
            }
        });
        var require=component.get("v.require");
        ////console.log("--->"+require);
        
        
        $A.enqueueAction(action);
    },
    
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
        //////console.log("hello onfocus");
    },
    onblur : function(component,event,helper){       
        
        // ////console.log("hello onblur");
        var name = component.find("NameHover");
        //  ////console.log('onBlur------>'+name.class); 
        $A.util.addClass(name, 'slds-hide');
        $A.util.removeClass(name, 'slds-show');
        
    }, 
    onhover : function(component,event,helper){       
        
        ////console.log("hello hover");
        var name = component.find("NameHover");
        //  ////console.log('hover---->'+name.class); 
        $A.util.addClass(name, 'slds-show');
        $A.util.removeClass(name, 'slds-hide');
        
    },
    
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var readOnly = component.get("v.readOnly");
        if(!readOnly){
            var pillTarget = component.find("lookup-pill");
            var lookUpTarget = component.find("lookupField"); 
            
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            
            component.set("v.SearchKeyWord",null);
            component.set("v.listOfSearchRecords", null );
            component.set("v.selectedRecord", {} );   
        }
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        var utilitySearch=component.find("utilitySearch");
        $A.util.addClass(utilitySearch,'slds-hide');
        $A.util.removeClass(utilitySearch,'slds-show');
        
    },
    create : function(component,event,helper){
        ////console.log('---->create record');
        helper.createRecord(component,event,helper);
    },
    MessageBlur :function(component,event,helper){
        ////console.log('Message OnmouseLeave---->');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    }
})