import { LightningElement,api,wire,track } from 'lwc';
import returnPresentStatus from '@salesforce/apex/disqualifyLoan.returnPresentStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import STAGE_FIELD from '@salesforce/schema/LLC_BI__Loan__c.LLC_BI__Stage__c';
import {
    subscribe,
    unsubscribe,
    onError,
    setDebugFlag,
    isEmpEnabled,
} from 'lightning/empApi';


export default class ShowToast extends LightningElement {
        @api recordId;
        @track
        stages = [];
        subscription='';

        // connectedCallback(){
        //     window.console.log('yes');
        //     const messageCallback = function (response) {
        //         window.console.log('New message received: ', JSON.stringify(response));
        //         // Response contains the payload of the new message received
        //     };
    
        //     // Invoke subscribe method of empApi. Pass reference to messageCallback
        //     subscribe(this.channelName, -1, messageCallback).then((response) => {
        //         // Response contains the subscription information on subscribe call
        //         window.console.log(
        //             'Subscription request sent to: ',
        //             JSON.stringify(response.channel)
        //         );
        //         this.subscription = response;
               
        //     });
        //     window.console.log(this.subscription);
        // }

        @wire(getRecord, { recordId: '$recordId', fields: [STAGE_FIELD] })
        record({error,data}){
            if(data){
                
                getRecordNotifyChange([{recordId: this.recordId}]);
                window.console.log('no please',data.fields.LLC_BI__Stage__c.value);
                //window.console.log(data);
                
                this.stages.push(data.fields.LLC_BI__Stage__c.value);
                window.console.log('this',this.stages);
                 var i =this.stages.length;
                 window.console.log(i);
                 if(this.stages[i-1]=='Perform Assessment' && this.stages[i-2]=='Pre-Close Contract'){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Warning',
                            message: 'Stage changed to Perform Assessment. The IIC Approval will be required again.',
                            variant: 'warning',
                        })
                    );
                 }
            }else if(error){
                window.console.log(error);
            }
        };
     
        // async handler() {
        //   // Update the record via Apex.
        //   await apexUpdateRecord(this.recordId);
        //   // Notify LDS that you've changed the record outside its mechanisms.
        //   getRecordNotifyChange([{recordId: this.recordId}]);
        // }

        // renderedCallback(){
        //     window.console.log('yes');
        //      returnPresentStatus({loanId : this.recordId}).then((result)=>{
        //          window.console.log(result);
        //      });

        // }


}