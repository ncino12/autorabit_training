trigger BudgetLineItemTrigger on LLC_BI__Budget_Line_Item__c (before delete) {
    for(LLC_BI__Budget_Line_Item__c bli : trigger.old){
        Integer blicount=BudgetLineItemCountFetch.blicount(bli.LLC_BI__Budget__c);
        If(blicount==1){
        bli.adderror('You need to have atleast one Disbursement Line Item.');
        }
    }
}