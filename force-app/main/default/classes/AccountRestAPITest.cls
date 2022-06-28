@isTest
private class AccountRestAPITest {
    
    @isTest static void testCallout2() {
        
        
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('httpMethod', 'POST');
        req.requestURI = '/services/apexrest/AccountInsert'; //Request URL
        //req.httpMethod = 'POST';
         
        req.requestBody = Blob.valueOf('{ "accountInformationList" : [ { "accountData":{ "Name":"John Doe", "Type":"Individual", "BillingStreet":"674,BAker street" } } ] }');
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        //String actual = null; //HttpClass.createAccount();
        AccountRestAPI.createAccount();
        Test.stopTest();
        
        //System.assertEquals('expected value', actual, 'Value is incorrect');
        
    }

}