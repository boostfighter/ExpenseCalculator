({
    selectRecord : function(component, event, helper){      
     // get the selected record from list  
       var getSelectRecord = component.get("v.oRecord");
        //console.log(getSelectRecord);
     // call the event   
       var compEvent = component.getEvent("oSelectedRecordEvent");
     // set the Selected sObject Record to the event attribute.  
          compEvent.setParams({"recordByEvent" : getSelectRecord }); 
          //console.log("hello result component");
     // fire the event  
          compEvent.fire();
     },
     onkeydown :function (component,event,helper){
         consol.log("key has been down");
     },
      onkeyup :function (component,event,helper){
         consol.log("key has been up");
     }
 })