public class disqualifyLoan {
    /*@AuraEnabled
    public static String updateStatus(String loanId)
    {
        List<LLC_BI__Loan__c> loansToUpdate = new List<LLC_BI__Loan__c>();
        List<LLC_BI__Loan__c> loans = [SELECT Id,is_disqualified__c, LLC_BI__Status__c From LLC_BI__Loan__c Where Id=:loanId];
        for(LLC_BI__Loan__c loan:loans)
        {
            loan.LLC_BI__Status__c = 'Loan Disqualified';
            loan.is_disqualified__c = true;
            loansToUpdate.add(loan);
        }
        System.debug('loans'+loans);
        upsert loansToUpdate;
        return 'Success';
    }*/
      @AuraEnabled
    public static string returnPresentStatus(String loanId){
        List<LLC_BI__Loan__c> loanStage = [SELECT LLC_BI__Stage__c From LLC_BI__Loan__c Where Id=:loanId];
        return loanStage[0].LLC_BI__Stage__c;
        
    }
}