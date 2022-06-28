@isTest
private class productDetailsFetchTest {
     static String loanIdUniv;
    @isTest  
    static void testCallout1(){
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
        
        Map<String,String> productLineFieldMap = new Map<String,String>();
        productLineFieldMap.put('Name','Test');
        LLC_BI__Product_Line__c productLine =  TestUtility.createProductLine(new Map<String,String>());
        insert productLine;
        
        
        Map<String,String> productTypeFieldMap = new Map<String,String>();
        productTypeFieldMap.put('LLC_BI__Product_Line__c',productLine.Id);
        productTypeFieldMap.put('Name','Test2');
        LLC_BI__Product_Type__c productType = TestUtility.createProductType(productTypeFieldMap);
        insert productType;
        
        Map<String,String> productFieldMap = new Map<String,String>();
        productFieldMap.put('LLC_BI__Product_Type__c',productType.Id);
        productFieldMap.put('Name','Test3');
        LLC_BI__Product__c product =   TestUtility.createProduct(productFieldMap);
        insert product;
        
        
        Map<String,String> loanFieldMap = new Map<String,String>();
        loanFieldMap.put('LLC_BI__Product__c',product.Name);
        loanFieldMap.put('LLC_BI__Product_Type__c',productType.Name);
        loanFieldMap.put('LLC_BI__Product_Line__c',productLine.Name);
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        
        insert loan;
        loanIdUniv = loan.id;
        productDetailsFetch.fetchProductDetials(loan.id);
}
    @IsTest
    static void testCallout2(){
        /* Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
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
        
        Map<String,String> productLineFieldMap = new Map<String,String>();
        productLineFieldMap.put('Name','Test');
        LLC_BI__Product_Line__c productLine =  TestUtility.createProductLine(productLineFieldMap);
        insert productLine;
        
        
        Map<String,String> productTypeFieldMap = new Map<String,String>();
        productTypeFieldMap.put('LLC_BI__Product_Line__c',productLine.Id);
        productTypeFieldMap.put('Name','Test2');
        LLC_BI__Product_Type__c productType = TestUtility.createProductType(productTypeFieldMap);
        insert productType;
        
        Map<String,String> productFieldMap = new Map<String,String>();
        productFieldMap.put('LLC_BI__Product_Type__c',productType.Id);
        productFieldMap.put('Name','Test3');
        LLC_BI__Product__c product =   TestUtility.createProduct(productFieldMap);
        insert product;
        
        
        Map<String,String> loanFieldMap = new Map<String,String>();
        loanFieldMap.put('LLC_BI__Product__c',product.Name);
        loanFieldMap.put('LLC_BI__Product_Type__c',productType.Name);
        loanFieldMap.put('LLC_BI__Product_Line__c',productLine.Name);
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        
        insert loan;*/
        
        Map<String,String> productLineFieldMap = new Map<String,String>();
        productLineFieldMap.put('Name','Test');
        LLC_BI__Product_Line__c productLine =  TestUtility.createProductLine(productLineFieldMap);
        insert productLine;
        
        
        Map<String,String> productTypeFieldMap = new Map<String,String>();
        productTypeFieldMap.put('LLC_BI__Product_Line__c',productLine.Id);
        productTypeFieldMap.put('Name','Test2');
        LLC_BI__Product_Type__c productType = TestUtility.createProductType(productTypeFieldMap);
        insert productType;
        
        Map<String,String> productFieldMap = new Map<String,String>();
        productFieldMap.put('LLC_BI__Product_Type__c',productType.Id);
        productFieldMap.put('Name','Test3');
        LLC_BI__Product__c product =   TestUtility.createProduct(productFieldMap);
        insert product;
        productDetailsFetch.updateProductRecord(loanIdUniv, product.id);
        
}
}