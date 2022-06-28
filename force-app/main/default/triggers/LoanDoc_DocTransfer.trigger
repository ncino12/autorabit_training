trigger LoanDoc_DocTransfer on LLC_BI__LLC_LoanDocument__c (after insert, before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        System.debug(Trigger.New.size());
        LoanDoc_DocTransfer_Helper.loanDocTransfer(Trigger.New);
    }
}