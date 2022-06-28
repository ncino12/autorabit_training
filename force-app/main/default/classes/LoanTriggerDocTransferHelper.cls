public class LoanTriggerDocTransferHelper {
	@AuraEnabled(cacheable=true)
    public static String refToLoanDocTransfer(List<LLC_BI__Loan__c> loans){
        List<String> leadIdSet = new List<String>();
        for(LLC_BI__Loan__c loan : loans){
            if(loan.Lead_Id__c != null){
                 leadIdSet.add(loan.Lead_Id__c);
            }
           
        }
        if(leadIdSet.size()>0){
        List<ContentDocumentLink> cdls = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN : leadIdSet];
        Map<String,List<String>> loanIdDocuemntMap = new Map<String,List<String>>();
        
        // Filling Map with ContentDocumentLink id list and lead id
        for(ContentDocumentLink cls :cdls){
            
                if(loanIdDocuemntMap.containsKey(cls.LinkedEntityId)){
                    List<String> newcdls = loanIdDocuemntMap.get(cls.LinkedEntityId);
                    newcdls.add(cls.ContentDocumentId);
                    loanIdDocuemntMap.put(cls.LinkedEntityId,newcdls);
                }else{
                    List<String> newcdls =new List<String>();
                    newcdls.add(cls.ContentDocumentId);
                    loanIdDocuemntMap.put(cls.LinkedEntityId,newcdls);
                }
        }
        
        List<ContentDocumentLink> contentDocumentForLoan =new List<ContentDocumentLink>();
        
        //Creating new instance for ContentDocumentLink for loan
       for(LLC_BI__Loan__c loan : loans )
       {
           if(loanIdDocuemntMap.containsKey(loan.Lead_Id__c) && loan.Lead_Id__c !=null){
               for(String documentId : loanIdDocuemntMap.get(loan.Lead_Id__c)){
        				contentDocumentForLoan.add(new ContentDocumentLink(LinkedEntityId=loan.Id , ContentDocumentId=documentId));
               }
           }
       }
        
        System.debug('contentDocumentForLoan'+contentDocumentForLoan);
        String returnMeaasge = '';
        
        try{
            if(contentDocumentForLoan.size() > 0){
                Insert contentDocumentForLoan;
                returnMeaasge = 'success';
            } 
        }catch(Exception e){
            returnMeaasge = e.getMessage();
        }
         return returnMeaasge;
        }
        return 'message';
    }
}