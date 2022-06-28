public class Reservedbudget {
    public static Callout_Service_Attributes__c getCalloutAttr(String name){
        Callout_Service_Attributes__c attrReq = [SELECT Id, Username__c, Timeout__c,Process_Id__c, Service_Name__c,Password__c, Named_Credentials__c, Label__c, Endpoint__c, Api_Login__c, Name FROM Callout_Service_Attributes__c where Label__c=:name ];
        return attrReq;
    }
    @AuraEnabled
    public static LLC_BI__Loan__c reserveBud(LLC_BI__Loan__c loan) {
        responseWrap responseData = new responseWrap();
        system.debug('loan'+loan);
        LLC_BI__Product__c brId = new LLC_BI__Product__c();
        brId = [Select Name,Legal_Entity__c from LLC_BI__Product__c where Name =:loan.LLC_BI__Product__c  limit 1];
        String branchIdAssigend='';
        if(brId!=null){
           branchIdAssigend = brId.Legal_Entity__c;
        }
        System.debug('dsadas********'+branchIdAssigend);
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
         String namedCredentials = '';
        if(!Test.isRunningTest()){
           namedCredentials =  Label.Budget_Reserve;
        }else{
            namedCredentials = 'Budget_Reserve';
        }
       
        Callout_Service_Attributes__c callAttrReq = getCalloutAttr(namedCredentials);
        System.debug('6565+654+65+65+656465'+callAttrReq.Endpoint__c);
        String endPoint = callAttrReq.Endpoint__c;
        String ProcessID =String.valueOf(callAttrReq.Process_Id__c);
        String apiLogin = callAttrReq.Api_Login__c;
        String apiSecret = callAttrReq.Password__c;//'t6Ps5ZqJfyX9yT9zPtpJnx4BJqVXPeMlLiyLSIGlvkXyqeBd3B';
        
        /*String endPoint = 'https://ireland2-syncapi.sandbox.mpo.mambu.com/api/1/json';
        String ProcessID = '23449';
        String apiLogin = '321';
        String apiSecret = 't6Ps5ZqJfyX9yT9zPtpJnx4BJqVXPeMlLiyLSIGlvkXyqeBd3B';*/
        
        String unixTime = String.valueof(DateTime.now().getTime()/1000);
        
        system.debug('unixTime'+unixTime);
        
        jsonBody wrapBody = new jsonBody();
        
        loan.Reserved_Amount__c = loan.LLC_BI__Amount__c;
        List<oppsData> oppsList = new List<oppsData>();
        oppsData oppData = new oppsData();
        oppData.type = 'create';
        oppData.obj='task';
        oppData.conv_id = Integer.valueOf(callAttrReq.Process_Id__c);
        dataV data = new dataV();
        budgetDetailsCLass budgetDetails = new budgetDetailsCLass();
        System.debug('loanBudget'+loan.LLC_BI__Product_Reference__r.Legal_Entity__c);
        budgetDetails.branchId = branchIdAssigend; //loan.LLC_BI__Product_Reference__r.Legal_Entity__c;
        budgetDetails.schemeName = 'EIS';//loan.LLC_BI__Product_Line__c;
        budgetDetails.currencyData = loan.Currency_New__c;
        budgetDetails.reservationAmount = loan.Reserved_Amount__c;
        if(loan.LLC_BI__Amount__c>loan.Reserved_Amount__c ){
            budgetDetails.updateReservedAmount = true;
        }else{
            budgetDetails.updateReservedAmount = false;
        }
        if(budgetDetails.updateReservedAmount == true){
            budgetDetails.newReservationAmount = loan.LLC_BI__Amount__c;
        }
        
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
        req.setTimeout(120000);
        //req.setCompressed(true); // otherwise we hit a limit of 32000
        
        try {
            res = http.send(req);
            system.debug(res.getStatusCode());
            if(res.getStatusCode()==200)
            {
                jsonBodyRes jsonResponse = (jsonBodyRes)JSON.deserialize(res.getBody(), jsonBodyRes.class);
                system.debug('errorResponse'+jsonResponse);
                
                if(jsonResponse.ops[0].data.errors != null){
                    
                    if(jsonResponse.ops[0].data.errors[0].errorCode=='E-204'){
                        Map<Id, LLC_BI__Loan__c> loans = new Map<Id, LLC_BI__Loan__c>();
                        if (loan != null) {
                            LLC_BI__Loan__c c = new LLC_BI__Loan__c(Id = loan.Id, Insufficient_Budget__c=true,Budget_Reserved__c = false);
                            loans.put(c.Id, c);
                        }
                        system.debug('loans.values***' + loans.values());
                        update loans.values();
                    }
                    
                    String errorMessage = '';
                    if(jsonResponse.ops[0].data.errors[0].errorSource!=null){
                        errorMessage = jsonResponse.ops[0].data.errors[0].errorSource;
                    }else if(jsonResponse.ops[0].data.errors[0].errorReason!=null){
                        errorMessage+= jsonResponse.ops[0].data.errors[0].errorReason; 
                    }
                    responseData.message = errorMessage;
                    responseData.isError = true;
                    Error_Logs__c newrecord=new Error_Logs__c();
                    newrecord.Error_Message__c=errorMessage;
                    newrecord.Occurance_Date_Time__c=System.now();
                    newrecord.Object__c='LLC_BI__Loan__c';
                    newrecord.Location__c='ReserveBudget';
                    newrecord.Record_ID__c=loan.Id;
                    
                    insert newrecord;
                }else if(jsonResponse.ops[0].data!=null &&  jsonResponse.ops[0].data.budgetDetails.isSuccess == 'true'){
                    responseData.message = 'Budget reserved successfully.';
                    responseData.isError = false;
                    responseData.responseCode = 200;
                    System.debug('loanId***************************************'+loan.Id);
                    System.debug('loan record***************************************'+loan);
                    Map<Id, LLC_BI__Loan__c> loans = new Map<Id, LLC_BI__Loan__c>();
                    if (loan != null) {
                         LLC_BI__Loan__c c = new LLC_BI__Loan__c(Id = loan.Id, Budget_Reserved__c = true, Insufficient_Budget__c=false,Reserved_Amount__c = Decimal.valueOf(jsonResponse.ops[0].data.budgetDetails.amountReserved));
                         loans.put(c.Id, c);
                     }
                    system.debug('loans.values***' + loans.values());
    				update loans.values();
                   // loan.Budget_Reserved__c = true;
                    
                    
                    //loan.Reserved_Amount__c = Decimal.valueOf(jsonResponse.ops[0].data.budgetDetails.amountReserved);
                    //update loan;
                }
            }else{
                responseData.message = res.getBody();
                responseData.isError = true;
                Error_Logs__c newrecord=new Error_Logs__c();
                newrecord.Error_Message__c=res.getBody();
                newrecord.Occurance_Date_Time__c=System.now();
                newrecord.Object__c='LLC_BI__Loan__c';
                newrecord.Location__c='ReserveBudget';
                newrecord.Record_ID__c=loan.Id;
                
                insert newrecord;
            }
            system.debug('res'+res.getBody());
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
        return null;
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
        Decimal reservationAmount;
        Boolean updateReservedAmount;
        Decimal newReservationAmount;
    }
    
    
    public class responseWrap{
        @AuraEnabled
        public  String message;
        @AuraEnabled
        public  Boolean isError;
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
        String currencyData;
        String amountReserved;
        String isSuccess;
    }
    
    public class errorClass{
        String errorCode;
        String errorSource;
        String errorReason ;
    }
    
    
}