/*global class NotestoDocMan_Handler {
    
    public static void test(List<ID> loanId, String fn){
        Id loansId=loanId[0];
        System.debug('Hello to loan Id'+loanId[0]);
        List<ContentDocumentLink> cdls=[SELECT LinkedEntityId, Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=:loansId];
        for(ContentDocumentLink cdl:cdls){
            String DocId=cdl.ContentDocumentId;
            List<ContentDocument> cds=[SELECT Title FROM ContentDocument WHERE Id=:DocId];
            String fileName=cds[0].Title;
            //if(fileName != fn){continue;}
        	LLC_BI__Document_Store__c newdsrecord=new LLC_BI__Document_Store__c();
        	insert newdsrecord;
        	Id docstoreid=newdsrecord.Id;
        	ContentDocumentLink newcdlrecord=new ContentDocumentLink(LinkedEntityId=docstoreid, ContentDocumentId=DocId );
        	insert newcdlrecord;
        	LLC_BI__Document_Store_Index__c newdtirecord=new LLC_BI__Document_Store_Index__c(LLC_BI__Document_Store__c=docstoreid);
        	insert newdtirecord;

        	List<LLC_BI__LLC_LoanDocument__c> loandocuments=[SELECT Id, LLC_BI__Loan__c, LLC_BI__reviewStatus__c,LLC_BI__docClass__c,LLC_BI__Document_Store_Index__c  FROM LLC_BI__LLC_LoanDocument__c WHERE Name=:fileName and LLC_BI__Loan__c=:loansId];
        	System.debug('Hello to me'+loandocuments.size());
            if(loandocuments.size()==0 ){
                LLC_BI__LLC_LoanDocument__c newld=new LLC_BI__LLC_LoanDocument__c(LLC_BI__attachmentId__c=DocId,LLC_BI__Document_Store_Index__c=newdtirecord.Id, LLC_BI__reviewStatus__c='In-File' , LLC_BI__Loan__c=loansId);
                 List<LLC_BI__LLC_LoanDocument__c> newloandocuments=new List<LLC_BI__LLC_LoanDocument__c>();
                newloandocuments.add(newld);
                insert newloandocuments;
                System.debug('No Loan Document'+newloandocuments);
            	} else {
       			LLC_BI__LLC_LoanDocument__c loandocument=loandocuments[0];
                
               // if(loandocument.LLC_BI__reviewStatus__c=='In-File'){
               //     continue;
                //}
                System.debug('Loan Document Found');
        	loandocument.LLC_BI__Document_Store_Index__c=newdtirecord.Id;
        	loandocument.LLC_BI__reviewStatus__c='In-File';
        	List<LLC_BI__LLC_LoanDocument__c> updatedloandocuments=new List<LLC_BI__LLC_LoanDocument__c>();
        	updatedloandocuments.add(loandocument);
            update updatedloandocuments;
            }
        }    
    }

}*/
global class NotestoDocMan_Handler {
    
}