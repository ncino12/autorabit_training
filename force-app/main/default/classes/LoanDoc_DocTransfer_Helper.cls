public class LoanDoc_DocTransfer_Helper {
   
    public static String loanDocTransfer(List<LLC_BI__LLC_LoanDocument__c> loanDocuments){
        system.debug('loanDocuments'+loanDocuments);
        List<String> loanSetID = new List<String>();
        List<String> loanDocumentSetId = new List<String>();
        Map<String,String> loanDocNameMap = new Map<String,String>(); 
        Map<String,String> loanDocLoanMap = new Map<String,String>(); 
        Map<String,LLC_BI__LLC_LoanDocument__c> documentLoanMap = new Map<String,LLC_BI__LLC_LoanDocument__c>();
       // List<String> titles = new List<String>();
        Map<String,List<String>> loanLoanDocName = new Map<String,List<String>>();
        for(LLC_BI__LLC_LoanDocument__c loanDocument:loanDocuments){
            //titles.add(loanDocument.Name);
            if(loanDocument.LLC_BI__reviewStatus__c=='Open'){
                loanSetID.add(loanDocument.LLC_BI__Loan__c);
                loanDocNameMap.put(loanDocument.Id,loanDocument.Name);
                loanDocumentSetId.add(loanDocument.Id);
                loanDocLoanMap.put(loanDocument.Id,loanDocument.LLC_BI__Loan__c);
                
                documentLoanMap.put(loanDocument.Name+'##'+loanDocument.LLC_BI__Loan__c,loanDocument);
            }
            if(loanLoanDocName.containsKey(loanDocument.LLC_BI__Loan__c)){
               List<String> strldl= loanLoanDocName.get(loanDocument.LLC_BI__Loan__c);
                strldl.add(loanDocument.Name);
                loanLoanDocName.put(loanDocument.LLC_BI__Loan__c,strldl);
            }else{
                List<String> strldl=new List<String>();
                 strldl.add(loanDocument.Name);
                loanLoanDocName.put(loanDocument.LLC_BI__Loan__c,strldl);
            }
        }
        
        List<LLC_BI__ClosingChecklist__c> Checklist = [SELECT Name,LLC_BI__Criteria__c   FROM LLC_BI__ClosingChecklist__c Where LLC_BI__docManager__r.name = 'llc_bi__loan__c'];
        List<String> ChecklistNames = new List<String>();
        for(LLC_BI__ClosingChecklist__c cl :Checklist ){
            if(cl.LLC_BI__Criteria__c.contains('Approve Opportunity')){
                 ChecklistNames.add(cl.Name);
            }
           
        }
        System.debug('ChecklistNames'+ChecklistNames);
       
       if(loanSetID.size()>0){
        
       List<ContentDocumentLink> cdls=[SELECT LinkedEntityId, Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :loanSetID];
     //   List<LLC_BI__LLC_LoanDocument__c> laonDocsOnLoan = [SELECT Name,LLC_BI__Loan__c FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__Loan__c IN :loanSetID];
     /*   Map<String,List<String>> loanLoanDocName = new Map<String,List<String>>();
        for(LLC_BI__LLC_LoanDocument__c ldol:loanDocuments){
            if(loanLoanDocName.containsKey(ldol.LLC_BI__Loan__c)){
               List<String> strldl= loanLoanDocName.get(ldol.LLC_BI__Loan__c);
                strldl.add(ldol.Name);
                loanLoanDocName.put(ldol.LLC_BI__Loan__c,strldl);
            }else{
                List<String> strldl=new List<String>();
                 strldl.add(ldol.Name);
                loanLoanDocName.put(ldol.LLC_BI__Loan__c,strldl);
            }
        }
        System.debug(loanLoanDocName);
       */
        
        Map<String,String> cdlContentDocumentIdMap = new Map<String,String>();
        Map<String,List<String>> loanCdls = new Map<String,List<String>> ();
        List<String> ContentDocIds = new List<String>();
        for(ContentDocumentLink cdl:cdls){
            cdlContentDocumentIdMap.put(cdl.Id,cdl.ContentDocumentId);
            ContentDocIds.add(cdl.ContentDocumentId);
            if(loanCdls.containsKey(cdl.LinkedEntityId)){
                List<String> ncdls = loanCdls.get(cdl.LinkedEntityId);
                ncdls.add(cdl.Id);
                loanCdls.put(cdl.LinkedEntityId,ncdls);
            }else{
                List<String> ncdls = new List<String>();
                ncdls.add(cdl.Id);
                loanCdls.put(cdl.LinkedEntityId,ncdls);
            }
        }
        
        List<ContentDocument> cds=[SELECT Id,Title FROM ContentDocument WHERE Id In :ContentDocIds];
        Map<String,String> contentDocTitleMap = new Map<String,String>();
        for(ContentDocument cd:cds){
            contentDocTitleMap.put(cd.Id,cd.Title);
        }
        Map<String,String> contentDocLinkTitleMap = new Map<String,String>();
        for(String cdlId: cdlContentDocumentIdMap.keySet()){
            String cdId = cdlContentDocumentIdMap.get(cdlId);
            String titleCd = contentDocTitleMap.get(cdId);
            contentDocLinkTitleMap.put(cdlId,titleCd);
        }
        Map<String,wrapperData> wrapDataMap  = new Map<String,wrapperData>();
         //List<LLC_BI__LLC_LoanDocument__c> newloandocuments=new List<LLC_BI__LLC_LoanDocument__c>();
         Map<String,LLC_BI__LLC_LoanDocument__c> loanStaging = new Map<String,LLC_BI__LLC_LoanDocument__c>();
        
        for(LLC_BI__LLC_LoanDocument__c loanDocument:loanDocuments)
        {
            String LoanId = loanDocument.LLC_BI__Loan__c;
            
            List<String> cdlsLoan= new List<String>();
            if(loanCdls.containsKey(loanDocument.LLC_BI__Loan__c)){
                
               cdlsLoan = loanCdls.get(LoanId);
                for(String cdlId:loanCdls.get(loanDocument.LLC_BI__Loan__c)){
                    String LoanDocName = loanDocument.Name;
                    String cdTitle = contentDocLinkTitleMap.get(cdlId);
                    if(LoanDocName==cdTitle && loanDocument.createdFromTrigger__c == false ){
                        wrapperData wrap = new wrapperData();
                        wrap.newdsrecord = new LLC_BI__Document_Store__c();
                        wrap.newcdlrecord=new ContentDocumentLink( ContentDocumentId=cdlContentDocumentIdMap.get(cdlId) );
                        wrap.newdtirecord=new LLC_BI__Document_Store_Index__c();
                        
                        if(documentLoanMap.containsKey(cdTitle+'##'+LoanId)){
                            documentLoanMap.get(cdTitle+'##'+LoanId).LLC_BI__reviewStatus__c='Approved';
                        }
                        wrap.keyData = cdTitle+'##'+LoanId;
                        wrapDataMap.put(cdTitle+'##'+LoanId, wrap);
                    }else if(loanDocument.createdFromTrigger__c == false){
                        //List<LLC_BI__LLC_LoanDocument__c> ifExistPL = [Select Id From LLC_BI__LLC_LoanDocument__c Where (Name=:cdTitle) ];
                        
                      //  List<String> titlesOnLoan = loanLoanDocName.get(LoanId);
                        //if(!titlesOnLoan.contains(cdTitle))
                        if(!ChecklistNames.contains(cdTitle))
                        {
                            
                               /* LLC_BI__Document_Store__c newdsrecord=new LLC_BI__Document_Store__c();
                                insert newdsrecord;
                                Id docstoreid=newdsrecord.Id;
                                ContentDocumentLink newcdlrecord=new ContentDocumentLink(LinkedEntityId=docstoreid, ContentDocumentId=cdlContentDocumentIdMap.get(cdlId) );
                                insert newcdlrecord;
                                LLC_BI__Document_Store_Index__c newdtirecord=new LLC_BI__Document_Store_Index__c(LLC_BI__Document_Store__c=docstoreid);
                                insert newdtirecord;
                                LLC_BI__LLC_LoanDocument__c newld=new LLC_BI__LLC_LoanDocument__c(LLC_BI__attachmentId__c=cdlContentDocumentIdMap.get(cdlId),LLC_BI__Document_Store_Index__c=newdtirecord.Id, LLC_BI__reviewStatus__c='In-File' , LLC_BI__Loan__c=LoanId);
                                List<LLC_BI__LLC_LoanDocument__c> newloandocuments=new List<LLC_BI__LLC_LoanDocument__c>();
                                newloandocuments.add(newld);
                                insert newloandocuments;*/
                                wrapperData wrap = new wrapperData();
                        		wrap.newdsrecord = new LLC_BI__Document_Store__c();
                        		wrap.newcdlrecord=new ContentDocumentLink( ContentDocumentId=cdlContentDocumentIdMap.get(cdlId) );
                        		wrap.newdtirecord=new LLC_BI__Document_Store_Index__c();
                                LLC_BI__LLC_LoanDocument__c newld=new LLC_BI__LLC_LoanDocument__c(LLC_BI__attachmentId__c=cdlContentDocumentIdMap.get(cdlId), LLC_BI__reviewStatus__c='In-File' , LLC_BI__Loan__c=LoanId,createdFromTrigger__c = true);
                                loanStaging.put(cdTitle+'##'+LoanId,newld);
                            
                            system.debug('loanStaging'+loanStaging);
                         		wrap.keyData = cdTitle+'##'+LoanId;
                        		wrapDataMap.put(cdTitle+'##'+LoanId, wrap);
                                
                            
                        }
                        
                    }
                }
            }
        }
       // System.debug(titles);
        System.debug('loanStaging');
        System.debug(loanStaging);
        Map<String,LLC_BI__Document_Store__c> documentStorList = new Map<String,LLC_BI__Document_Store__c>();
        
        for(wrapperData wrap:wrapDataMap.values()){
            documentStorList.put(wrap.keyData,wrap.newdsrecord);
        }
        if(documentStorList.values().size() > 0){
            Insert documentStorList.values();
        }
        Map<String,ContentDocumentLink> contentDocumentLinkMap = new Map<String,ContentDocumentLink>();
        for(wrapperData wrap:wrapDataMap.values()){
            if(documentStorList.containsKey(wrap.keyData)){
                wrap.newcdlrecord.LinkedEntityId = documentStorList.get(wrap.keyData).Id;
                contentDocumentLinkMap.put(wrap.keyData,wrap.newcdlrecord);
            }
            
        }
        if(contentDocumentLinkMap.values().size() > 0){
            insert contentDocumentLinkMap.values();
        }
        Map<String,LLC_BI__Document_Store_Index__c> documentStoreIndexMap = new Map<String,LLC_BI__Document_Store_Index__c>();
        for(wrapperData wrap:wrapDataMap.values()){
            if(contentDocumentLinkMap.containsKey(wrap.keyData)){
                wrap.newdtirecord.LLC_BI__Document_Store__c = documentStorList.get(wrap.keyData).Id;
                documentStoreIndexMap.put(wrap.keyData,wrap.newdtirecord);
            }
            
        }
        if(documentStoreIndexMap.values().size() > 0){
            insert documentStoreIndexMap.values();
        }
        
        for(wrapperData wrap:wrapDataMap.values()){
            if(documentLoanMap.containsKey(wrap.keyData) && documentStoreIndexMap.containsKey(wrap.keyData)){
                documentLoanMap.get(wrap.keyData).LLC_BI__Document_Store_Index__c = documentStoreIndexMap.get(wrap.keyData).id;
            }else if(loanStaging.containsKey(wrap.keyData) && documentStoreIndexMap.containsKey(wrap.keyData) ){
                loanStaging.get(wrap.keyData).LLC_BI__Document_Store_Index__c = documentStoreIndexMap.get(wrap.keyData).id;
            }
        }
        
        // List<LLC_BI__LLC_LoanDocument__c> attchmentsLoan = [SELECT LLC_BI__attachmentId__c,LLC_BI__Loan__c FROM LLC_BI__LLC_LoanDocument__c WHERE LLC_BI__Loan__c IN :loanSetID];
        
        Map<String,List<String>> loanAttID = new Map<String,List<String>>();
        for(LLC_BI__LLC_LoanDocument__c ldatid:loanDocuments){
            if(loanAttID.containsKey(ldatid.LLC_BI__Loan__c)){
                List<String> nlattids = loanAttID.get(ldatid.LLC_BI__Loan__c);
                nlattids.add(ldatid.LLC_BI__attachmentId__c);
                loanAttID.put(ldatid.LLC_BI__Loan__c,nlattids);
            }else{
                List<String> nlattids = new List<String>();
                nlattids.add(ldatid.LLC_BI__attachmentId__c);
                loanAttID.put(ldatid.LLC_BI__Loan__c,nlattids);
            }
        }
        List<LLC_BI__LLC_LoanDocument__c> loanStagingToInsert = new List<LLC_BI__LLC_LoanDocument__c>();
        
        for(LLC_BI__LLC_LoanDocument__c ls:loanStaging.values())
        {
            String loanIdLS = ls.LLC_BI__Loan__c;
            String attachIdLS = ls.LLC_BI__attachmentId__c;
            List<String> attIdPresent = loanAttID.get(loanIdLS);
            if(!attIdPresent.contains(attachIdLS)  ){
                loanStagingToInsert.add(ls);
            }
        }
        
        
        System.debug(loanAttID);
        System.debug(loanStagingToInsert);
       if(loanStagingToInsert.size()>0 ){
          insert(loanStagingToInsert);
          // String jsonString = json.serialize(loanStagingToInsert);
           // loanStagingDocTransfer(jsonString);
       }
        
        }
        return 'abd';
    }
    
    Public class wrapperData{
        Public  LLC_BI__Document_Store__c newdsrecord;
        public ContentDocumentLink newcdlrecord;
        public LLC_BI__Document_Store_Index__c newdtirecord;
        public string keyData;
    }
    
    
    public static void loanStagingDocTransfer(String jsonString){
         List<LLC_BI__LLC_LoanDocument__c> toInsertList = (List<LLC_BI__LLC_LoanDocument__c>)Json.deserialize(jsonString,List<LLC_BI__LLC_LoanDocument__c>.class);
        insert(toInsertList);
    }
    
    
}