import { LightningElement, wire } from 'lwc';
import createAccountOnMambu from '@salesforce/apex/MPOAccountSync.createAccountOnMambu';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class MpoAccountSync extends LightningElement {
    toastMessage = ''
    @wire(createAccountOnMambu) responseData;
    handleClick(){
        createAccountOnMambu().then((result)=>{
          window.console.log(result);
        }).catch(e=>{
            window.console.log(e.body.message);
            this.toastMessage = e.body.message;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'hjkhkjh',
                    variant: 'error',
                })
            );
        })
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}