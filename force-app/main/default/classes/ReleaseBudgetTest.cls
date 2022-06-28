@isTest
private class ReleaseBudgetTest {
    @isTest static void testCallout() {
        
       
        Map<String,String> calloutFiledMap = new Map<String,String>();
        calloutFiledMap.put('Username__c','test');
        
        
        calloutFiledMap.put('Service_Name__c','budgetReserve api');
        calloutFiledMap.put('Password__c','');
        calloutFiledMap.put('Named_Credentials__c','');
        calloutFiledMap.put('Label__c','Release Budget');
        calloutFiledMap.put('Endpoint__c','https://test.sandbox.mpo.mambu.com/api/1/json/P');
        calloutFiledMap.put('Api_Login__c','test');
        calloutFiledMap.put('Name','Release Budget');
       Callout_Service_Attributes__c calloutService =  TestUtility.createCalloutService(calloutFiledMap);
        insert calloutService;
        Map<String,String> calloutFiledMap2 = new Map<String,String>();
        calloutFiledMap2.put('Username__c','test');
        
        
        calloutFiledMap2.put('Service_Name__c','budgetReserve api');
        calloutFiledMap2.put('Password__c','');
        calloutFiledMap2.put('Named_Credentials__c','');
        calloutFiledMap2.put('Label__c','Budget_Reserve');
        calloutFiledMap2.put('Endpoint__c','https://test.sandbox.mpo.mambu.com/api/1/json/P');
        calloutFiledMap2.put('Api_Login__c','test');
        calloutFiledMap2.put('Name','Budget_Reserve');
       Callout_Service_Attributes__c calloutService2 =  TestUtility.createCalloutService(calloutFiledMap2);
        insert calloutService2;
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
        system.debug('loan'+loan);
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        ReleaseBudget2.releaseBud(loan.Id,'test','test');
        ReleaseBudget2.getLoanData(loan.Id);
        Test.stopTest();
        
        
        
    }
    @isTest static void testCalloutError() {
        
       
        Map<String,String> calloutFiledMap = new Map<String,String>();
        calloutFiledMap.put('Username__c','test');
        
        
        calloutFiledMap.put('Service_Name__c','budgetReserve api');
        calloutFiledMap.put('Password__c','');
        calloutFiledMap.put('Named_Credentials__c','');
        calloutFiledMap.put('Label__c','Release Budget');
        calloutFiledMap.put('Endpoint__c','https://test.sandbox.mpo.mambu.com/api/1/json/F');
        calloutFiledMap.put('Api_Login__c','test');
        calloutFiledMap.put('Name','Release Budget');
       Callout_Service_Attributes__c calloutService =  TestUtility.createCalloutService(calloutFiledMap);
        insert calloutService;
        Map<String,String> calloutFiledMap2 = new Map<String,String>();
        calloutFiledMap2.put('Username__c','test');
        
        
        calloutFiledMap2.put('Service_Name__c','budgetReserve api');
        calloutFiledMap2.put('Password__c','');
        calloutFiledMap2.put('Named_Credentials__c','');
        calloutFiledMap2.put('Label__c','Budget_Reserve');
        calloutFiledMap2.put('Endpoint__c','https://test.sandbox.mpo.mambu.com/api/1/json/F');
        calloutFiledMap2.put('Api_Login__c','test');
        calloutFiledMap2.put('Name','Budget_Reserve');
       Callout_Service_Attributes__c calloutService2 =  TestUtility.createCalloutService(calloutFiledMap2);
        insert calloutService2;
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
        system.debug('loan'+loan);
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        ReleaseBudget2.releaseBud(loan.Id,'test','test');
        Test.stopTest();
        
        
        
    }
     @isTest static void testCalloutException() {
        
        
        Map<String,String> calloutFiledMap = new Map<String,String>();
        calloutFiledMap.put('Username__c','test');
        
        
        calloutFiledMap.put('Service_Name__c','budgetReserve api');
        calloutFiledMap.put('Password__c','');
        calloutFiledMap.put('Named_Credentials__c','');
        calloutFiledMap.put('Label__c','Release Budget');
        calloutFiledMap.put('Endpoint__c','https://test.sandbox.mpo.mambu.com/api/1/json/E');
        calloutFiledMap.put('Api_Login__c','test');
        calloutFiledMap.put('Name','Release Budget');
       Callout_Service_Attributes__c calloutService =  TestUtility.createCalloutService(calloutFiledMap);
        insert calloutService;
        Map<String,String> calloutFiledMap2 = new Map<String,String>();
        calloutFiledMap2.put('Username__c','test');
        
        
        calloutFiledMap2.put('Service_Name__c','budgetReserve api');
        calloutFiledMap2.put('Password__c','');
        calloutFiledMap2.put('Named_Credentials__c','');
        calloutFiledMap2.put('Label__c','Budget_Reserve');
        calloutFiledMap2.put('Endpoint__c','https://test.sandbox.mpo.mambu.com/api/1/json/E');
        calloutFiledMap2.put('Api_Login__c','test');
        calloutFiledMap2.put('Name','Budget_Reserve');
       Callout_Service_Attributes__c calloutService2 =  TestUtility.createCalloutService(calloutFiledMap2);
        insert calloutService2;
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
        system.debug('loan'+loan);
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        ReleaseBudget2.releaseBud(loan.Id,'test','test');
        Test.stopTest();
        
     }
    
   
}