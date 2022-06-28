public with sharing class budgetAdminClass {
    @AuraEnabled
    public static String getBudgetId(String loanId){

        List<LLC_BI__Loan__c> loans = [SELECT Id, LLC_BI__Budget__c From LLC_BI__Loan__c Where Id=:loanId];
        return loans[0].LLC_BI__Budget__c;
        
    }
    
}