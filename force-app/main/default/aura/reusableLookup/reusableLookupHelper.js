({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
	  var orgId=component.get("v.SelectedOrgRecordId");
      var portfolioId=component.get("v.SelectedPortfolioRecordId");  
      var SprogramId=component.get("v.SelectedProgramRecordId");
      var SprojectId=component.get("v.SelectedProjectRecordId");  
      var SDeliverableId=component.get("v.SelectedDeliverableRecordId");  
      var SSourceSystemId=component.get("v.SelectedSourceSystemRecordId");
      var SSourceDataStoreId=component.get("v.SelectedSourceDataStoreRecordId");      
      var SSourceDataStoreElementId=component.get("v.SelectedSourceDataStoreElementRecordId");
      var STargetSystemId=component.get("v.SelectedTargetSystemRecordId");
      var STargetDataStoreId=component.get("v.SelectedTargetDataStoreRecordId");    
      var STargetDataStoreElementId=component.get("v.SelectedTargetDataStoreElementRecordId");
      var userId=component.get("v.uId");
      var BpIdforBPSandBPP=component.get("v.bpIdforSuccesorAndPredecessorRecordId"); 
      var sucessOrPredeces=component.get("v.sucessorOrPredecessor");  
      var SWp=component.get("v.SelectedWorkPackageRecordId");  
      var action = component.get("c.fetchLookUpValues");
      var ProgId=  component.get("v.IssueId");
      var UsablityLookup = component.get("v.usablity");
      var BusinessProcessLevel=component.get("v.BusinessLevel");
        if(BusinessProcessLevel!=undefined || BusinessProcessLevel!=null){ 
       var bl =BusinessProcessLevel.toString();
        }
            var BusinessProcessPrefix=component.get("v.BusinessPrefix");  
      // var selectedProgRecord=component.get("v.selectedProgramRecord");
        var elementry_pro=component.get("v.elementry");
        
       // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'userid':userId,
            'onRecordId':component.get("v.onRecordId"),
            'onObjectName':component.get("v.onObjectName"),
            'parentRecordId': component.get('v.parentRecord'),
            'FilterId' : component.get('v.FilterId')
          });
        
        
         // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                  /*  var obj=component.get("v.objectAPIName");
                    if(obj=='PlatinumPMO__Work_Package__c'){
                    component.set("v.Message", 'Create New Record');
                    }else{*/
                    component.set("v.Message", 'No Result Founds, Please Contact your Administrator');
                        
                   // }
                    component.set("v.listOfSearchRecords", null );
                    var forclose = component.find("searchRes");
                  //  $A.util.addClass(forclose, 'slds-is-close');
                //    $A.util.removeClass(forclose, 'slds-is-open');
                  
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
                
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    createRecord : function(component,event,helper){
        var r=component.get("v.objectAPIName");
        if(r=='PlatinumPMO__Work_Package__c'){
           var modalBody;
            $A.createComponent("PlatinumPMO:WorkPackageNewANDEditButtonOverRide", { },
           function(content, status) {
               if (status === "SUCCESS") {
                
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Add Work Package",
                       body: modalBody, 
                       showCloseButton: true,
                       cssClass: "mymodal",
                       closeCallback: function() {
                         //  alert('You closed the alert!');
                       }
                   })
               }                               
           });
           
        }
    }
})