@isTest
private class LoanDoc_DocTransfer_HelperTest {
    
    @isTest  
    static void testCallout_DocTransfer_DocTransfer(){
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
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        
        insert loan;
        
        
         //Create contentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        ContentDocument ContentDoc =[SELECT Id,Title FROM ContentDocument WHERE Id=:cvList[0].ContentDocumentId];
        ContentDoc.title='abc';
        update ContentDoc;
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = loan.id;
        cdl.ContentDocumentId = cvList[0].ContentDocumentId;
        cdl.shareType = 'V';
        insert cdl;  
        
        LLC_BI__ClosingChecklist__c closeCheck = new LLC_BI__ClosingChecklist__c();
        closeCheck.Name= 'abc';
        closeCheck.LLC_BI__Type__c='Standard';
        closeCheck.LLC_BI__Criteria__c='Approve Opportunity';
        //closeCheck.LLC_BI__docManager__r = 'a0V1j000005UzHHEA0';
        insert closeCheck;
        
       LLC_BI__LLC_LoanDocument__c LoanDoc = new LLC_BI__LLC_LoanDocument__c();
       LoanDoc.Name = 'abc';
       LoanDoc.LLC_BI__reviewStatus__c='Open' ;
       LoanDoc.LLC_BI__closingChecklist__c= closeCheck.id;
       LoanDoc.LLC_BI__Loan__c=loan.id;
       
       insert LoanDoc;
        
    }
    
        @isTest  
    static void testCallout_DocTransfer_DocTransfer2(){
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
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        
        insert loan;
        
        
         //Create contentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        ContentDocument ContentDoc =[SELECT Id,Title FROM ContentDocument WHERE Id=:cvList[0].ContentDocumentId];
        ContentDoc.title='abc';
        update ContentDoc;
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = loan.id;
        cdl.ContentDocumentId = cvList[0].ContentDocumentId;
        cdl.shareType = 'V';
        insert cdl;  
        
        LLC_BI__ClosingChecklist__c closeCheck = new LLC_BI__ClosingChecklist__c();
        closeCheck.Name= 'abc';
        closeCheck.LLC_BI__Type__c='Standard';
        closeCheck.LLC_BI__Criteria__c='Approve Opportunity';
        //closeCheck.LLC_BI__docManager__r = 'a0V1j000005UzHHEA0';
        insert closeCheck;
        
         LLC_BI__LLC_LoanDocument__c LoanDoc = new LLC_BI__LLC_LoanDocument__c();
       LoanDoc.Name = 'cdf';
       LoanDoc.LLC_BI__reviewStatus__c='Open' ;
       LoanDoc.LLC_BI__closingChecklist__c= closeCheck.id;
       LoanDoc.LLC_BI__Loan__c=loan.id;
       
       insert LoanDoc;
        
 
        
    }
}