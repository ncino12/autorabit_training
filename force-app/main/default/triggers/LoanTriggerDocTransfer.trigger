trigger LoanTriggerDocTransfer on LLC_BI__Loan__c (after insert,before Insert,before Update,after Update) {
   
    // Calling Fucntion for creating ContentDocumentLink for Loan
    if(Trigger.isInsert && Trigger.isAfter ){
        LoanTriggerDocTransferHelper.refToLoanDocTransfer(Trigger.New);
        String jsonStringLoans = json.serialize(Trigger.New);
		LoanTriggerHandler.reserveBudgetMethod(jsonStringLoans);
        
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        List<LLC_BI__loan__c> loansForReservation = new List<LLC_BI__loan__c>();
        for(LLC_BI__loan__c loan:Trigger.NEW){
            if(loan.LLC_BI__Amount__c!=Trigger.oldMap.get(loan.Id).LLC_BI__Amount__c && loan.LLC_BI__Amount__c>loan.Reserved_Amount__c && loan.Budget_Reserved__c ){
                loansForReservation.add(loan);
                
            }
        }
        if(loansForReservation.size()>0){
            String jsonStringLoans = json.serialize(loansForReservation);
			LoanTriggerHandler.reserveBudgetMethod(jsonStringLoans);
        }
    	
    }
}