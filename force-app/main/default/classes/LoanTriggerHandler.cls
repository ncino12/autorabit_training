public class LoanTriggerHandler {
    @future (callout=true) 
    public static void reserveBudgetMethod(String jsonStringLoans){
        List<LLC_BI__Loan__c> loanList = (List<LLC_BI__Loan__c>)Json.deserialize(jsonStringLoans,List<LLC_BI__Loan__c>.class);
        System.debug(loanList.size());
        for(LLC_BI__Loan__c loan:loanList){
            
            Reservedbudget.reserveBud(loan);
            
        }
    }
    
    /*@future (callout=true) 
    public static void releaseBudgetMethod(String jsonStringLoans){
        List<LLC_BI__Loan__c> loanList = (List<LLC_BI__Loan__c>)Json.deserialize(jsonStringLoans,List<LLC_BI__Loan__c>.class);
        
        for(LLC_BI__Loan__c loan:loanList){
            ReleaseBudget.releaseBud(loan);
           // Reservedbudget.reserveBud(loan);
            
        }
    }*/
}