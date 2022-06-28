@isTest
private class LoanTriggerDocTransferhelperTest {
    
    @isTest 
    static void testCallout_docTransfer() {
        
        nRE__Referral__c ref1 = new nRE__Referral__c();
        ref1.nRE__Company__c='Company1';
        ref1.nRE__First_Name__c ='abc';
        ref1.nRE__Last_Name__c ='pqr';
        ref1.nRE__Referral_Source__c='Netherlands';
        ref1.ISO_Code__c='NL';
        ref1.nRE__Product_Line__c='EIS';
        ref1.Activity_on_the_FMO_exclusion_list__c='No';
        ref1.Currency__c ='USD';
        ref1.nRE__Email_Address__c='abc@fmak.com';
        insert ref1;
        
        //ContentDocument contentDoc = new ContentDocument();
        //insert contentDoc;
        
         //Create contentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = ref1.id;
        cdl.ContentDocumentId = cvList[0].ContentDocumentId;
        cdl.shareType = 'V';
        insert cdl;  
        
        
         Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
       
        Map<String,String> calloutFiledMap = new Map<String,String>();
        calloutFiledMap.put('Username__c','test');
        
        
        calloutFiledMap.put('Service_Name__c','budgetReserve api');
        calloutFiledMap.put('Password__c','');
        calloutFiledMap.put('Named_Credentials__c','');
        calloutFiledMap.put('Label__c','Budget_Reserve');
        calloutFiledMap.put('Endpoint__c','https://test.sandbox.mpo.mambu.com/api/1/json/P');
        calloutFiledMap.put('Api_Login__c','test');
        calloutFiledMap.put('Name','Budget_Reserve');
       Callout_Service_Attributes__c calloutService =  TestUtility.createCalloutService(calloutFiledMap);
        insert calloutService;
        
        
        LLC_BI__Product_Line__c productLine =  TestUtility.createProductLine(new Map<String,String>());
        insert productLine;
        
        
        Map<String,String> productTypeFieldMap = new Map<String,String>();
        productTypeFieldMap.put('LLC_BI__Product_Line__c',productLine.Id);
        LLC_BI__Product_Type__c productType = TestUtility.createProductType(productTypeFieldMap);
        insert productType;
        
        Map<String,String> productFieldMap = new Map<String,String>();
        productFieldMap.put('LLC_BI__Product_Type__c',productType.Id);
         productFieldMap.put('Name','ESI');
        LLC_BI__Product__c product =   TestUtility.createProduct(productFieldMap);
        insert product;
        
        Map<String,String> loanFieldMap = new Map<String,String>();
        loanFieldMap.put('LLC_BI__Product__c',product.Name);
        loanFieldMap.put('Lead_Id__c',ref1.id);
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        
        insert loan;
        
        List<LLC_BI__Loan__c> list_loan =new List<LLC_BI__Loan__c>();
        list_loan.add(loan);
        
        system.debug('loan'+loan);
        
        LoanTriggerDocTransferHelper.refToLoanDocTransfer(list_loan);
        
        
        
        
    }

}