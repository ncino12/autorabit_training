({
	doInit: function(component, event, helper) {
        debugger;
		var action = component.get('c.createAccountOnMambu'); 
        // method name i.e. getEntity should be same as defined in apex class
        // params name i.e. entityType should be same as defined in getEntity method
        action.setParams({
            "loanId" : component.get('v.recordId') 
        }); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
				console.log(a.getReturnValue());
				var responseValue = a.getReturnValue();
				if(responseValue.isError == false){
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Success!",
						"type" : "success",
						"variant" : 'success',
						"message": responseValue.message
					});
					toastEvent.fire();
                    window.setTimeout(
                        $A.getCallback(function() {
                            window.location.reload();
                        }), 5000
                    );
                    
				}else{
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Error!",
						"type" : "error",
						"variant" : 'error',
						"message": responseValue.message
					});
					toastEvent.fire();
				}
					
               // component.set('v.sObjList', a.getReturnValue());
			   var dismissActionPanel = $A.get("e.force:closeQuickAction");
			   dismissActionPanel.fire();
            }
			else{
				var responseValue = a.getReturnValue();
				var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Error!",
						"type" : "error",
						"variant" : 'error',
						"message": responseValue.message
					});
					toastEvent.fire();
					var dismissActionPanel = $A.get("e.force:closeQuickAction");
					dismissActionPanel.fire();
			}
        });
        $A.enqueueAction(action);

    }
})