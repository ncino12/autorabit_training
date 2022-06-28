public class ReleaseBudget2 {
    public static Callout_Service_Attributes__c getCalloutAttr(String name){
        Callout_Service_Attributes__c attrReq = [SELECT Id,Password__c,Process_Id__c, Username__c, Timeout__c, Service_Name__c, Named_Credentials__c, Label__c, Endpoint__c, Api_Login__c, Name FROM Callout_Service_Attributes__c where Label__c=:name ];
        return attrReq;
    }
    
   
    //fetch picklist values from custom object in lwc
   /*  @AuraEnabled
     public static list < customValueWrapper > pickListValueDynamically(sObject customObjInfo, string selectPicklistApi) {
        initWrapper returnWrapper = new initWrapper();
         Schema.DescribeSObjectResult objDescribe = customObjInfo.getSObjectType().getDescribe();     
        map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();      
        list < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
        list < customValueWrapper > customObjWrapper = new list < customValueWrapper > ();
        for (Schema.PicklistEntry myCustPick: custPickValues) {
          customValueWrapper selectOptionValueWrapper = new customValueWrapper();
             selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
             selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
            customObjWrapper.add(selectOptionValueWrapper);
        }
       
         
         returnWrapper.customObjWrapper = customObjWrapper;
        return customObjWrapper;
  
      } */
    @auraEnabled
    public static LLC_BI__Loan__c getLoanData(String recordId){
        system.debug('recordId'+recordId);
        return   [Select Id,Budget_Reserved__c,Loan_Disqualification_Reason__c,Disqualification_Comments__c,is_disqualified__c, LLC_BI__Status__c,LLC_BI__Product__c,Currency_New__c,LLC_BI__Product_Line__c,LLC_BI__Product_Reference__r.Legal_Entity__c,Reserved_Amount__c from LLC_BI__Loan__c  where Id=:recordId];

    }
    public with sharing class initWrapper{
		@auraEnabled public List < customValueWrapper > customObjWrapper;
        @auraEnabled public LLC_BI__Loan__c loanData;
       
    }
      // wrapper class 
        public with sharing class customValueWrapper {
          @auraEnabled public string custFldlabel {get;set;}
          @auraEnabled public string custFldvalue {get;set;}
        }
    @AuraEnabled
    public static responseWrap releaseBud(String loanId, String loanDisqualificationReason, String disqualificationComments) {
        system.debug('loanId'+loanId);
         system.debug('loanDisqualificationReason'+loanDisqualificationReason);
         system.debug('disqualificationComments'+disqualificationComments);
       responseWrap responseData = new responseWrap();
        LLC_BI__Loan__c loan = [Select Id,Budget_Reserved__c,is_disqualified__c, LLC_BI__Status__c,LLC_BI__Product__c,Currency_New__c,LLC_BI__Product_Line__c,LLC_BI__Product_Reference__r.Legal_Entity__c,Reserved_Amount__c from LLC_BI__Loan__c where Id=:loanId ];
        LLC_BI__Product__c brId = new LLC_BI__Product__c();
        brId = [Select Name,Legal_Entity__c from LLC_BI__Product__c where Name =:loan.LLC_BI__Product__c  limit 1];
        String branchIdAssigend='';
        if(brId!=null){
           branchIdAssigend = brId.Legal_Entity__c;
        }
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        String namedCredentials = '';
        if(Test.isRunningTest()){
           namedCredentials = 'Release Budget';
        }else{
           namedCredentials = Label.Release_Budget;
        }
         
        Callout_Service_Attributes__c callAttrReq = getCalloutAttr(namedCredentials);
        System.debug('6565+654+65+65+656465'+callAttrReq.Endpoint__c);
        String endPoint = callAttrReq.Endpoint__c;
        String ProcessID =string.valueOf(callAttrReq.Process_Id__c);
        String apiLogin = callAttrReq.Api_Login__c;
        String apiSecret = callAttrReq.Password__c;//'t6Ps5ZqJfyX9yT9zPtpJnx4BJqVXPeMlLiyLSIGlvkXyqeBd3B';
        
        /*String endPoint = 'https://ireland2-syncapi.sandbox.mpo.mambu.com/api/1/json';
        String ProcessID = '23456';
        String apiLogin = '321';
        String apiSecret = 't6Ps5ZqJfyX9yT9zPtpJnx4BJqVXPeMlLiyLSIGlvkXyqeBd3B';*/
        
        String unixTime = String.valueof(DateTime.now().getTime()/1000);
        
        system.debug('unixTime'+unixTime);
        
        jsonBody wrapBody = new jsonBody();
        
        List<oppsData> oppsList = new List<oppsData>();
        oppsData oppData = new oppsData();
        oppData.type = 'create';
        oppData.obj='task';
        oppData.conv_id = Integer.valueOf(callAttrReq.Process_Id__c);
        dataV data = new dataV();
        budgetDetailsCLass budgetDetails = new budgetDetailsCLass();
        budgetDetails.branchId = branchIdAssigend;//loan.LLC_BI__Product_Reference__r.Legal_Entity__c;
        budgetDetails.schemeName = 'EIS';//loan.LLC_BI__Product_Line__c;
        budgetDetails.currencyData = loan.Currency_New__c;
        budgetDetails.cancellationAmount = loan.Reserved_Amount__c;
        
        
        data.budgetDetails = budgetDetails;
        oppData.data = data;
        
        oppsList.add(oppData);
        
        wrapBody.ops = oppsList;
        String body = JSON.serialize(wrapBody);
        body = body.replace('currencyData', 'currency');
        system.debug(body);
        req.setBody(body);
        String finalString = unixTime+apiSecret+req.getBody()+apiSecret;
        system.debug('finalString'+finalString);
        
        // body = body.replace('/{processID}/ig', ProcessID);
        Blob mac = Crypto.generateDigest('SHA1',Blob.valueOf(finalString));
        System.debug('After SHA1 Convert '+mac);
        // Blob hmac = Crypto.generateMac('hmacSHA1', Blob.valueOf(finalString), Blob.valueOf(apiSecret));
        // System.debug('After SHA1 Convert '+mac);
        String signature = EncodingUtil.convertToHex(mac);
        System.debug('After Hex Convert '+signature);
        
        
        system.debug('signature'+signature);
        endPoint = endPoint +'/'+apiLogin;
        endPoint = endPoint +'/'+unixTime;
        endPoint = endPoint +'/'+signature;
        system.debug('endPoint'+endPoint);
        req.setEndpoint(endPoint);
        //req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        // req.setHeader('Authorization', 'Inherit Authorization');
        req.setHeader('Content-Type','application/json');
        
        
        req.setHeader('Accept', 'application/json');
        
        req.setMethod('POST');
        req.setBody(body);
        //req.setCompressed(true); // otherwise we hit a limit of 32000
        req.setTimeout(120000);
        
        try {
            res = http.send(req);
            if(res.getStatusCode()==200){
                jsonBodyRes jsonResponse = (jsonBodyRes)JSON.deserialize(res.getBody(), jsonBodyRes.class);
                system.debug('errorResponse'+jsonResponse);
                
                if(jsonResponse.ops[0].data.errors != null){
                    String errorMessage = '';
                    if(jsonResponse.ops[0].data.errors[0].errorSource!=null){
                        errorMessage = jsonResponse.ops[0].data.errors[0].errorSource;
                    }else if(jsonResponse.ops[0].data.errors[0].errorReason!=null){
                        errorMessage+= jsonResponse.ops[0].data.errors[0].errorReason; 
                    }
                    responseData.message = errorMessage;
                    responseData.isError = 'true';
                    Error_Logs__c newrecord=new Error_Logs__c();
                    newrecord.Error_Message__c=errorMessage;
                    newrecord.Occurance_Date_Time__c=System.now();
                    newrecord.Object__c='LLC_BI__Loan__c';
                    newrecord.Location__c='ReleaseBudget';
                    newrecord.Record_ID__c=loan.Id;
                    
                    insert newrecord;
                }else{
                    responseData.message = 'The budget is released successfully.';
                    responseData.isError = 'false';
                    responseData.responseCode = 200;
                    try{
                        loan.Loan_Disqualification_Reason__c = loanDisqualificationReason;
                    loan.Disqualification_Comments__c = disqualificationComments;
                    loan.Budget_Reserved__c=false;
                    loan.LLC_BI__Status__c = 'Loan Disqualified';
                    loan.is_disqualified__c = true;
                   
                    update loan;
                    }catch(Exception e){
                        responseData.message = e.getMessage();
                        responseData.isError = 'true';
                        responseData.responseCode = 101;
                    }
                    
                    
                }
            }else{
                responseData.message = res.getBody();
                responseData.isError = 'true';
                Error_Logs__c newrecord=new Error_Logs__c();
                newrecord.Error_Message__c=res.getBody();
                newrecord.Occurance_Date_Time__c=System.now();
                newrecord.Object__c='LLC_BI__Loan__c';
                newrecord.Location__c='ReleaseBudget';
                newrecord.Record_ID__c=loan.Id;
                
                insert newrecord;
            }
            system.debug('res'+res.getBody());
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
        System.debug(responseData.message);
        return responseData;
    }
    public class jsonBody{
        List<oppsData> ops;
    }
    
    public class oppsData{
        String type;
        String obj;
        Integer conv_id;
        dataV data;
    }
    
    public class dataV{
        budgetDetailsCLass budgetDetails;
    }
    
    public class budgetDetailsCLass{
        String branchId;
        String schemeName;
        String currencyData;
        Decimal cancellationAmount;
        
    }
    public class responseWrap{
        @AuraEnabled
        public  String message;
        @AuraEnabled
        public  String isError;
        @AuraEnabled
        public Integer responseCode;
    }
    public class jsonBodyRes{
        String request_proc;
        List<oppsDataRes> ops;
    }
    public class oppsDataRes{
        String proc;
        dataVRes data;
    }
    
    public class dataVRes{
        List<errorClass> errors;
        budgetDetailsClassRes budgetDetails;
    }
    public class budgetDetailsClassRes{
        String branchId;
        String schemeName;
        String amountCancelled;
        String isSuccess;
    }
    
    public class errorClass{
        String errorCode;
        String errorSource;
        String errorReason ;
    }
}