import { LightningElement, api ,track,wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import releaseBud from '@salesforce/apex/ReleaseBudget2.releaseBud';

export default class DisqualificationPopup extends LightningElement {

    @api recordId;
    @track record;
    @track error;
    @track loanDisqualificationReason = '';
    @track disqualificationComments = '';
    @track updating = false;
    
    handleCommentChange(event) {
        console.log('event.target.value'+event.target.value);
        this.disqualificationComments = event.target.value;
    }
    handleReasonChange(event) {
        console.log('event.target.value'+event.target.value);
        this.loanDisqualificationReason = event.target.value;
    }
   handleclick(event){
  
        this.updating = true;
        window.console.log(this.recordId);
        releaseBud({loanId : this.recordId, disqualificationComments : this.disqualificationComments, loanDisqualificationReason : this.loanDisqualificationReason}).then((result)=>{
            window.console.log(result);
            if(result.isError != 'true'){
                var delayInMilliseconds = 100; //1 second

                setTimeout(function() {
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: result.message,
                        variant: 'success',
                    });
                    this.dispatchEvent(evt);
                   
                    this.updating = false;
                    
                }, delayInMilliseconds);
                
                
                
            }else{
                var delayInMilliseconds = 100; //1 second

                    setTimeout(function() {
                        const evt = new ShowToastEvent({
                            title: 'Error',
                            message: result.message,
                            variant: 'error',
                        });
                        this.dispatchEvent(evt);
                       
                        this.updating = false;
                    }, delayInMilliseconds);
                
                   
            }
            
            this.dispatchEvent(new CloseActionScreenEvent());
            var delayInMilliseconds = 500; //1 second

                    setTimeout(function() {
                        window.location.reload();
                    }, delayInMilliseconds);
                
           
        });
        
       
        
   }
  
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}