import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateStatus from '@salesforce/apex/disqualifyLoan.updateStatus';
import releaseBud from '@salesforce/apex/ReleaseBudget.releaseBud';

import { updateRecord } from 'lightning/uiRecordApi';

export default class DisqualificationPopup extends LightningElement {

    @api recordId;

    
    updating = false;
     toastMessage = 'this';
    

    
    
   handleclick(event){
    const comment = this.template.querySelector('.comment-sec').value;
    window.console.log(comment);
    if(comment!="" && comment!=null){
    this.updating = true;
    }
   }
   
   handleError(event){
    this.updating = false;
    this.dispatchEvent(new CloseActionScreenEvent());
   }


    handlesuccess(event){
     
        
        this.dispatchEvent(new CloseActionScreenEvent());
        this.updating = false;
        window.console.log(this.recordId);
        releaseBud({loanId : this.recordId}).then((result)=>{
            window.console.log(result);
            if(result.isError != 'true'){
                var delayInMilliseconds = 1000; //1 second

                setTimeout(function() {
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: result.message,
                        variant: 'success',
                    });
                    this.dispatchEvent(evt);
                   
                    window.location.reload();
                    
                }, delayInMilliseconds);
                
                
                
            }else{
                var delayInMilliseconds = 1000; //1 second

                    setTimeout(function() {
                        const evt = new ShowToastEvent({
                            title: 'Error',
                            message: result.message,
                            variant: 'error',
                        });
                        this.dispatchEvent(evt);
                        
                    }, delayInMilliseconds);
                
                   
            }
            
            this.updating = false;
            this.dispatchEvent(new CloseActionScreenEvent());
        });
       

        //eval("$A.get('e.force:refreshView').fire();");
        updateRecord({fields: { Id: this.recordId }});
        

    }

    saveAction(){
        window.console.log(this.recordId);
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}