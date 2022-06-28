public with sharing class productDetailsFetch {
    @AuraEnabled
    public static List<LLC_BI__Product__c> fetchProductDetials(String loanId){
        List<LLC_BI__Loan__c> loanDetails = [SELECT LLC_BI__Product_Line__c,LLC_BI__Product_Type__c,LLC_BI__Product__c from LLC_BI__Loan__c Where Id =:loanId ];
        String product = loanDetails[0].LLC_BI__Product__c;
        String productType = loanDetails[0].LLC_BI__Product_TYPE__c;
        String productLine = loanDetails[0].LLC_BI__Product_LINE__c;

        List<LLC_BI__Product__c> productDetails= [SELECT Name,LLC_BI__Product_Type__r.Name, LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.Name,Description__c,Product_ID__c FROM LLC_BI__Product__c WHERE (Name =:product AND LLC_BI__Product_Type__r.Name=:productType AND LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.Name=:productLine) ];
        //System.debug('Name'+productDetails[0].LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.Name);
        return productDetails;
    }
    
    @AuraEnabled
    public static String updateProductRecord(String loanId, String productId)
    {
        List<LLC_BI__Loan__c> loanUpdated= new List<LLC_BI__Loan__c>();
        System.debug('Id'+loanId);
        List<LLC_BI__Loan__c> loansToBeUpdated = [Select LLC_BI__Product_Reference__c from LLC_BI__Loan__c WHERE Id=:loanId ];
        System.debug('loansUpdated'+loansToBeUpdated);
        for(LLC_BI__Loan__c loan:loansToBeUpdated){
            loan.LLC_BI__Product_Reference__c = productId;
            loanUpdated.add(loan);
        }
        System.debug('loansToUpdated'+loanUpdated);
        update loanUpdated;
        return 'Success';
    }
    
}