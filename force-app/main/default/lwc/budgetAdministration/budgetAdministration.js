import { LightningElement,api,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord,getFieldValue } from 'lightning/uiRecordApi';
import AMOUNT_FIELD from '@salesforce/schema/LLC_BI__Budget__c.LLC_BI__Total_Budget_Amount__c';
import ALLOCATED_FIELD from '@salesforce/schema/LLC_BI__Budget__c.LLC_BI__Total_Allocated__c';
import REMAINING_FIELD from '@salesforce/schema/LLC_BI__Budget__c.LLC_BI__Total_Remaining__c';
import PERCENT_ALLOCATED_FIELD from '@salesforce/schema/LLC_BI__Budget__c.LLC_BI__Percent_Allocated__c';
import PERCENT_REMAINING_FIELD from '@salesforce/schema/LLC_BI__Budget__c.LLC_BI__Percent_Remaining__c';
import PERCENT_HARD_COSTS_FIELD from '@salesforce/schema/LLC_BI__Budget__c.LLC_BI__Percent_Hard_Costs__c';
import PERCENT_SOFT_COSTS_FIELD from '@salesforce/schema/LLC_BI__Budget__c.LLC_BI__Percent_Soft_Costs__c';
import PERCENT_OTHER_COSTS_FIELD from '@salesforce/schema/LLC_BI__Budget__c.LLC_BI__Percent_Other_Costs__c';
import BUDGET_NAME from '@salesforce/schema/LLC_BI__Budget__c.Name';

const FIELDS_REQUIRED= [AMOUNT_FIELD,ALLOCATED_FIELD,REMAINING_FIELD,
                        PERCENT_ALLOCATED_FIELD,PERCENT_REMAINING_FIELD,PERCENT_HARD_COSTS_FIELD,PERCENT_SOFT_COSTS_FIELD,PERCENT_OTHER_COSTS_FIELD,
                        BUDGET_NAME ]

export default class BudgetAdministration  extends NavigationMixin(LightningElement) {
    @api recordId;
    budgetId='';
    mapBudget={};

    @wire(getRecord, {recordId:'a251j000000ha2cAAA',fields:FIELDS_REQUIRED})
    budgetFields;

    get amountField(){
        return getFieldValue(this.budgetFields.data,AMOUNT_FIELD);
    }

    get allocatedAmount(){
        return getFieldValue(this.budgetFields.data,ALLOCATED_FIELD);
    }

    get remainingAmount(){
        return getFieldValue(this.budgetFields.data,REMAINING_FIELD);
    }
    
    get percentAllocated(){
        return getFieldValue(this.budgetFields.data,PERCENT_ALLOCATED_FIELD);
    }

    get percentRemaining(){
        return getFieldValue(this.budgetFields.data,PERCENT_REMAINING_FIELD);
    }

    get percentHardCosts(){
        return getFieldValue(this.budgetFields.data,PERCENT_HARD_COSTS_FIELD);
    }

    get percentSoftCosts(){
        return getFieldValue(this.budgetFields.data,PERCENT_SOFT_COSTS_FIELD);
    }

    get percentOtherCosts(){
        return getFieldValue(this.budgetFields.data,PERCENT_OTHER_COSTS_FIELD);
    }

    get budgetName(){
        return getFieldValue(this.budgetFields.data,BUDGET_NAME);
    }


    handleOpenBudget(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: 'a251j000000ha2cAAA',
                objectApiName: 'Account',
                actionName: 'view'
            },
        });

    }
}