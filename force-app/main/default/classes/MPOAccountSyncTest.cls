@isTest
private class MPOAccountSyncTest {
    
    @isTest static void testCallout2() {
        
        Map<String,String> calloutFiledMap = new Map<String,String>();
        calloutFiledMap.put('Username__c','test');
        
        
        calloutFiledMap.put('Service_Name__c','budgetReserve api');
        calloutFiledMap.put('Password__c','');
        calloutFiledMap.put('Named_Credentials__c','');
        calloutFiledMap.put('Label__c','Release Budget');
        calloutFiledMap.put('Endpoint__c','https://test.sandbox.mpo.mambu.com/api/1/json/P');
        calloutFiledMap.put('Api_Login__c','test');
        calloutFiledMap.put('Name','Release Budget');
        calloutFiledMap.put('Timeout__c','10000');
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
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService2 =  TestUtility.createCalloutService(calloutFiledMap2);
        insert calloutService2;
        
        
        Map<String,String> calloutFiledMap3 = new Map<String,String>();
        calloutFiledMap3.put('Username__c','test');
        
        
        calloutFiledMap3.put('Service_Name__c','loanSync api');
        calloutFiledMap3.put('Password__c','');
        calloutFiledMap3.put('Named_Credentials__c','');
        calloutFiledMap3.put('Label__c','Loan Creation');
        calloutFiledMap3.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/P');
        calloutFiledMap3.put('Api_Login__c','test');
        calloutFiledMap3.put('Name','Loan_Creation');
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService3 =  TestUtility.createCalloutService(calloutFiledMap3);
        insert calloutService3;
        LLC_BI__Product_Line__c productLine =  TestUtility.createProductLine(new Map<String,String>());
        insert productLine;
        
        
        Map<String,String> productTypeFieldMap = new Map<String,String>();
        productTypeFieldMap.put('LLC_BI__Product_Line__c',productLine.Id);
        LLC_BI__Product_Type__c productType = TestUtility.createProductType(productTypeFieldMap);
        insert productType;
        
        Map<String,String> productFieldMap = new Map<String,String>();
        productFieldMap.put('LLC_BI__Product_Type__c',productType.Id);
        productFieldMap.put('name','test');
         productFieldMap.put('Product_ID__c','EIS_TLI_EUR_1');
        LLC_BI__Product__c product =   TestUtility.createProduct(productFieldMap);
        insert product;
        
        Map<String,String> loanFieldMap = new Map<String,String>();
        loanFieldMap.put('LLC_BI__Product__c',product.Name);
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        loan.Budget_Reserved__c = true;
        loan.LLC_BI__Product_Reference__c = product.id;
        loan.LLC_BI__Stage__c = 'Close Contract';
        insert loan;
        
        Map<String,String> loanDocuementFieldMap = new Map<String,String>();
        loanDocuementFieldMap.put('Name','Loan Agreement');
        loanDocuementFieldMap.put('LLC_BI__Loan__c',loan.id);
         loanDocuementFieldMap.put('LLC_BI__reviewStatus__c','Signed');
        
         LLC_BI__LLC_LoanDocument__c loanDocument =    TestUtility.createLoanDocument(loanDocuementFieldMap);
        insert loanDocument;
        system.debug('loan'+loan);
       
        
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
       
		        
        MPOAccountSync.createAccountOnMambu(loan.id);
        
        Test.stopTest();
        
        
    }
    @isTest static void testCalloutError() {
        
        Map<String,String> calloutFiledMap = new Map<String,String>();
        calloutFiledMap.put('Username__c','test');
        
        
        calloutFiledMap.put('Service_Name__c','budgetReserve api');
        calloutFiledMap.put('Password__c','');
        calloutFiledMap.put('Named_Credentials__c','');
        calloutFiledMap.put('Label__c','Release Budget');
        calloutFiledMap.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/E');
        calloutFiledMap.put('Api_Login__c','test');
        calloutFiledMap.put('Name','Release Budget');
        calloutFiledMap.put('Timeout__c','10000');
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
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService2 =  TestUtility.createCalloutService(calloutFiledMap2);
        insert calloutService2;
        
        
        Map<String,String> calloutFiledMap3 = new Map<String,String>();
        calloutFiledMap3.put('Username__c','test');
        
        
        calloutFiledMap3.put('Service_Name__c','loanSync api');
        calloutFiledMap3.put('Password__c','');
        calloutFiledMap3.put('Named_Credentials__c','');
        calloutFiledMap3.put('Label__c','Loan Creation');
        calloutFiledMap3.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/E');
        calloutFiledMap3.put('Api_Login__c','test');
        calloutFiledMap3.put('Name','Loan_Creation');
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService3 =  TestUtility.createCalloutService(calloutFiledMap3);
        insert calloutService3;
        LLC_BI__Product_Line__c productLine =  TestUtility.createProductLine(new Map<String,String>());
        insert productLine;
        
        
        Map<String,String> productTypeFieldMap = new Map<String,String>();
        productTypeFieldMap.put('LLC_BI__Product_Line__c',productLine.Id);
        LLC_BI__Product_Type__c productType = TestUtility.createProductType(productTypeFieldMap);
        insert productType;
        
        Map<String,String> productFieldMap = new Map<String,String>();
        productFieldMap.put('LLC_BI__Product_Type__c',productType.Id);
        productFieldMap.put('name','test');
         productFieldMap.put('Product_ID__c','EIS_TLI_EUR_1');
        LLC_BI__Product__c product =   TestUtility.createProduct(productFieldMap);
        insert product;
        
        Map<String,String> loanFieldMap = new Map<String,String>();
        loanFieldMap.put('LLC_BI__Product__c',product.Name);
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        loan.Budget_Reserved__c = true;
        loan.LLC_BI__Product_Reference__c = product.id;
        loan.LLC_BI__Stage__c = 'Close Contract';
        insert loan;
        
        Map<String,String> loanDocuementFieldMap = new Map<String,String>();
        loanDocuementFieldMap.put('Name','Loan Agreement');
        loanDocuementFieldMap.put('LLC_BI__Loan__c',loan.id);
         loanDocuementFieldMap.put('LLC_BI__reviewStatus__c','Signed');
        
         LLC_BI__LLC_LoanDocument__c loanDocument =    TestUtility.createLoanDocument(loanDocuementFieldMap);
        insert loanDocument;
        system.debug('loan'+loan);
       
        
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
       
		        
        MPOAccountSync.createAccountOnMambu(loan.id);
        
        Test.stopTest();
        
        
    }
     @isTest static void testCalloutException() {
        
        Map<String,String> calloutFiledMap = new Map<String,String>();
        calloutFiledMap.put('Username__c','test');
        
        
        calloutFiledMap.put('Service_Name__c','budgetReserve api');
        calloutFiledMap.put('Password__c','');
        calloutFiledMap.put('Named_Credentials__c','');
        calloutFiledMap.put('Label__c','Release Budget');
        calloutFiledMap.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/P');
        calloutFiledMap.put('Api_Login__c','test');
        calloutFiledMap.put('Name','Release Budget');
        calloutFiledMap.put('Timeout__c','10000');
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
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService2 =  TestUtility.createCalloutService(calloutFiledMap2);
        insert calloutService2;
        
        
        Map<String,String> calloutFiledMap3 = new Map<String,String>();
        calloutFiledMap3.put('Username__c','test');
        
        
        calloutFiledMap3.put('Service_Name__c','loanSync api');
        calloutFiledMap3.put('Password__c','');
        calloutFiledMap3.put('Named_Credentials__c','');
        calloutFiledMap3.put('Label__c','Loan Creation');
        calloutFiledMap3.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/Ex');
        calloutFiledMap3.put('Api_Login__c','test');
        calloutFiledMap3.put('Name','Loan_Creation');
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService3 =  TestUtility.createCalloutService(calloutFiledMap3);
        insert calloutService3;
        LLC_BI__Product_Line__c productLine =  TestUtility.createProductLine(new Map<String,String>());
        insert productLine;
        
        
        Map<String,String> productTypeFieldMap = new Map<String,String>();
        productTypeFieldMap.put('LLC_BI__Product_Line__c',productLine.Id);
        LLC_BI__Product_Type__c productType = TestUtility.createProductType(productTypeFieldMap);
        insert productType;
        
        Map<String,String> productFieldMap = new Map<String,String>();
        productFieldMap.put('LLC_BI__Product_Type__c',productType.Id);
        productFieldMap.put('name','test');
         productFieldMap.put('Product_ID__c','EIS_TLI_EUR_1');
        LLC_BI__Product__c product =   TestUtility.createProduct(productFieldMap);
        insert product;
        
        Map<String,String> loanFieldMap = new Map<String,String>();
        loanFieldMap.put('LLC_BI__Product__c',product.Name);
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        loan.Budget_Reserved__c = true;
        loan.LLC_BI__Product_Reference__c = product.id;
        loan.LLC_BI__Stage__c = 'Close Contract';
        insert loan;
        
        Map<String,String> loanDocuementFieldMap = new Map<String,String>();
        loanDocuementFieldMap.put('Name','Loan Agreement');
        loanDocuementFieldMap.put('LLC_BI__Loan__c',loan.id);
         loanDocuementFieldMap.put('LLC_BI__reviewStatus__c','Signed');
        
         LLC_BI__LLC_LoanDocument__c loanDocument =    TestUtility.createLoanDocument(loanDocuementFieldMap);
        insert loanDocument;
        system.debug('loan'+loan);
       
        
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
       
		        
        MPOAccountSync.createAccountOnMambu(loan.id);
        
        Test.stopTest();
        
        
    }
    @isTest static void testCalloutNotSIgned() {
        
        Map<String,String> calloutFiledMap = new Map<String,String>();
        calloutFiledMap.put('Username__c','test');
        
        
        calloutFiledMap.put('Service_Name__c','budgetReserve api');
        calloutFiledMap.put('Password__c','');
        calloutFiledMap.put('Named_Credentials__c','');
        calloutFiledMap.put('Label__c','Release Budget');
        calloutFiledMap.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/P');
        calloutFiledMap.put('Api_Login__c','test');
        calloutFiledMap.put('Name','Release Budget');
        calloutFiledMap.put('Timeout__c','10000');
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
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService2 =  TestUtility.createCalloutService(calloutFiledMap2);
        insert calloutService2;
        
        
        Map<String,String> calloutFiledMap3 = new Map<String,String>();
        calloutFiledMap3.put('Username__c','test');
        
        
        calloutFiledMap3.put('Service_Name__c','loanSync api');
        calloutFiledMap3.put('Password__c','');
        calloutFiledMap3.put('Named_Credentials__c','');
        calloutFiledMap3.put('Label__c','Loan Creation');
        calloutFiledMap3.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/Ex');
        calloutFiledMap3.put('Api_Login__c','test');
        calloutFiledMap3.put('Name','Loan_Creation');
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService3 =  TestUtility.createCalloutService(calloutFiledMap3);
        insert calloutService3;
        LLC_BI__Product_Line__c productLine =  TestUtility.createProductLine(new Map<String,String>());
        insert productLine;
        
        
        Map<String,String> productTypeFieldMap = new Map<String,String>();
        productTypeFieldMap.put('LLC_BI__Product_Line__c',productLine.Id);
        LLC_BI__Product_Type__c productType = TestUtility.createProductType(productTypeFieldMap);
        insert productType;
        
        Map<String,String> productFieldMap = new Map<String,String>();
        productFieldMap.put('LLC_BI__Product_Type__c',productType.Id);
        productFieldMap.put('name','test');
         productFieldMap.put('Product_ID__c','EIS_TLI_EUR_1');
        LLC_BI__Product__c product =   TestUtility.createProduct(productFieldMap);
        insert product;
        
        Map<String,String> loanFieldMap = new Map<String,String>();
        loanFieldMap.put('LLC_BI__Product__c',product.Name);
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        loan.Budget_Reserved__c = true;
        loan.LLC_BI__Product_Reference__c = product.id;
        //loan.LLC_BI__Stage__c = 'Close Contract';
        insert loan;
        
        Map<String,String> loanDocuementFieldMap = new Map<String,String>();
        loanDocuementFieldMap.put('Name','Loan Agreement');
        loanDocuementFieldMap.put('LLC_BI__Loan__c',loan.id);
         //loanDocuementFieldMap.put('LLC_BI__reviewStatus__c','Signed');
        
         LLC_BI__LLC_LoanDocument__c loanDocument =    TestUtility.createLoanDocument(loanDocuementFieldMap);
        insert loanDocument;
        system.debug('loan'+loan);
       
        
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
       
		        
        MPOAccountSync.createAccountOnMambu(loan.id);
        
        Test.stopTest();
        
        
    }
     @isTest static void testCalloutNotCloseContract() {
        
        Map<String,String> calloutFiledMap = new Map<String,String>();
        calloutFiledMap.put('Username__c','test');
        
        
        calloutFiledMap.put('Service_Name__c','budgetReserve api');
        calloutFiledMap.put('Password__c','');
        calloutFiledMap.put('Named_Credentials__c','');
        calloutFiledMap.put('Label__c','Release Budget');
        calloutFiledMap.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/P');
        calloutFiledMap.put('Api_Login__c','test');
        calloutFiledMap.put('Name','Release Budget');
        calloutFiledMap.put('Timeout__c','10000');
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
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService2 =  TestUtility.createCalloutService(calloutFiledMap2);
        insert calloutService2;
        
        
        Map<String,String> calloutFiledMap3 = new Map<String,String>();
        calloutFiledMap3.put('Username__c','test');
        
        
        calloutFiledMap3.put('Service_Name__c','loanSync api');
        calloutFiledMap3.put('Password__c','');
        calloutFiledMap3.put('Named_Credentials__c','');
        calloutFiledMap3.put('Label__c','Loan Creation');
        calloutFiledMap3.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/Ex');
        calloutFiledMap3.put('Api_Login__c','test');
        calloutFiledMap3.put('Name','Loan_Creation');
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService3 =  TestUtility.createCalloutService(calloutFiledMap3);
        insert calloutService3;
        LLC_BI__Product_Line__c productLine =  TestUtility.createProductLine(new Map<String,String>());
        insert productLine;
        
        
        Map<String,String> productTypeFieldMap = new Map<String,String>();
        productTypeFieldMap.put('LLC_BI__Product_Line__c',productLine.Id);
        LLC_BI__Product_Type__c productType = TestUtility.createProductType(productTypeFieldMap);
        insert productType;
        
        Map<String,String> productFieldMap = new Map<String,String>();
        productFieldMap.put('LLC_BI__Product_Type__c',productType.Id);
        productFieldMap.put('name','test');
         productFieldMap.put('Product_ID__c','EIS_TLI_EUR_1');
        LLC_BI__Product__c product =   TestUtility.createProduct(productFieldMap);
        insert product;
        
        Map<String,String> loanFieldMap = new Map<String,String>();
        loanFieldMap.put('LLC_BI__Product__c',product.Name);
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        loan.Budget_Reserved__c = true;
        loan.LLC_BI__Product_Reference__c = product.id;
        //loan.LLC_BI__Stage__c = 'Close Contract';
        insert loan;
        
        Map<String,String> loanDocuementFieldMap = new Map<String,String>();
        loanDocuementFieldMap.put('Name','Loan Agreement');
        loanDocuementFieldMap.put('LLC_BI__Loan__c',loan.id);
         loanDocuementFieldMap.put('LLC_BI__reviewStatus__c','Signed');
        
         LLC_BI__LLC_LoanDocument__c loanDocument =    TestUtility.createLoanDocument(loanDocuementFieldMap);
        insert loanDocument;
        system.debug('loan'+loan);
       
        
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
       
		        
        MPOAccountSync.createAccountOnMambu(loan.id);
        
        Test.stopTest();
        
        
    }
      @isTest static void testCalloutNotInsufficient_Budget() {
        
        Map<String,String> calloutFiledMap = new Map<String,String>();
        calloutFiledMap.put('Username__c','test');
        
        
        calloutFiledMap.put('Service_Name__c','budgetReserve api');
        calloutFiledMap.put('Password__c','');
        calloutFiledMap.put('Named_Credentials__c','');
        calloutFiledMap.put('Label__c','Release Budget');
        calloutFiledMap.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/P');
        calloutFiledMap.put('Api_Login__c','test');
        calloutFiledMap.put('Name','Release Budget');
        calloutFiledMap.put('Timeout__c','10000');
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
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService2 =  TestUtility.createCalloutService(calloutFiledMap2);
        insert calloutService2;
        
        
        Map<String,String> calloutFiledMap3 = new Map<String,String>();
        calloutFiledMap3.put('Username__c','test');
        
        
        calloutFiledMap3.put('Service_Name__c','loanSync api');
        calloutFiledMap3.put('Password__c','');
        calloutFiledMap3.put('Named_Credentials__c','');
        calloutFiledMap3.put('Label__c','Loan Creation');
        calloutFiledMap3.put('Endpoint__c','https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/Ex');
        calloutFiledMap3.put('Api_Login__c','test');
        calloutFiledMap3.put('Name','Loan_Creation');
        calloutFiledMap.put('Timeout__c','10000');
       Callout_Service_Attributes__c calloutService3 =  TestUtility.createCalloutService(calloutFiledMap3);
        insert calloutService3;
        LLC_BI__Product_Line__c productLine =  TestUtility.createProductLine(new Map<String,String>());
        insert productLine;
        
        
        Map<String,String> productTypeFieldMap = new Map<String,String>();
        productTypeFieldMap.put('LLC_BI__Product_Line__c',productLine.Id);
        LLC_BI__Product_Type__c productType = TestUtility.createProductType(productTypeFieldMap);
        insert productType;
        
        Map<String,String> productFieldMap = new Map<String,String>();
        productFieldMap.put('LLC_BI__Product_Type__c',productType.Id);
        productFieldMap.put('name','test');
         productFieldMap.put('Product_ID__c','EIS_TLI_EUR_1');
        LLC_BI__Product__c product =   TestUtility.createProduct(productFieldMap);
        insert product;
        
        Map<String,String> loanFieldMap = new Map<String,String>();
        loanFieldMap.put('LLC_BI__Product__c',product.Name);
        LLC_BI__Loan__c loan = TestUtility.createLoan(loanFieldMap);
        //loan.Budget_Reserved__c = true;
        loan.Insufficient_Budget__c = true;
        loan.LLC_BI__Product_Reference__c = product.id;
        //loan.LLC_BI__Stage__c = 'Close Contract';
        insert loan;
        
        Map<String,String> loanDocuementFieldMap = new Map<String,String>();
        loanDocuementFieldMap.put('Name','Loan Agreement');
        loanDocuementFieldMap.put('LLC_BI__Loan__c',loan.id);
         loanDocuementFieldMap.put('LLC_BI__reviewStatus__c','Signed');
        
         LLC_BI__LLC_LoanDocument__c loanDocument =    TestUtility.createLoanDocument(loanDocuementFieldMap);
        insert loanDocument;
        system.debug('loan'+loan);
       
        
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
       
		        
        MPOAccountSync.createAccountOnMambu(loan.id);
        
        Test.stopTest();
        
        
    }

}