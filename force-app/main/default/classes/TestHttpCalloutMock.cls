@isTest
global class TestHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        // Create a fake response
        
        if(req.getEndpoint().contains('https://test.sandbox.mpo.mambu.com/api/1/json/P')){
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "ops": [ { "proc": "ok", "data": { "budgetDetails": { "branchId": "IIC", "schemeName": "EIS", "amountReserved": "3000", "currency": "USD", "isSuccess": "true" } } } ] }');
            res.setStatusCode(200);
        } if(req.getEndpoint().contains('https://test.sandbox.mpo.mambu.com/api/1/json/F')){
             res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "request_proc": "ok", "ops": [ { "proc": "ok", "data": { "errors": [ { "errorCode": 4, "errorSource": "reservation amount greater than available budget", "errorReason": "RESERVATION_AMOUNT_NOT_AVAILABLE" } ] } } ] }');
            	res.setStatusCode(200);
        } if(req.getEndpoint().contains('https://test.sandbox.mpo.mambu.com/api/1/json/E')){ 
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "request_proc": "ok", "ops": [ { "proc": "ok", "data": { "errors": [ { "errorCode": 4, "errorSource": "reservation amount greater than available budget", "errorReason": "RESERVATION_AMOUNT_NOT_AVAILABLE" } ] } } ] }');
            res.setStatusCode(101);
        }
         if(req.getEndpoint().contains('https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/P')){ 
            res.setHeader('Content-Type', 'application/json');
             res.setBody('{ "request_proc": "ok", "ops": [ { "proc": "ok", "data": {  "loanDetails":{ "productName":"EIS Term Loan Product with Insurance", "loanAmount":10000, "loanId":"IIYVDR897", "loanEncodedKey":"8a19baf17ffbff03018003764f250e6f" },"installments": [ { "encodedKey": "8a19c4b0809316570180948df1c50f8a", "parentAccountKey": "8a19c4b0809316570180948be98c0f85", "number": "1", "dueDate": "2022-09-06T02:00:00+02:00", "state": "PENDING", "isPaymentHoliday": false, "principal": { "amount": { "expected": 5000.0, "paid": 0, "due": 5000.0 } }, "interest": { "amount": { "expected": 205.74, "paid": 0, "due": 205.74 }, "tax": { "expected": 0, "paid": 0, "due": 0 } }, "fee": { "amount": { "expected": 0, "paid": 0, "due": 0 }, "tax": { "expected": 0, "paid": 0, "due": 0 } }, "penalty": { "amount": { "expected": 0, "paid": 0, "due": 0 }, "tax": { "expected": 0, "paid": 0, "due": 0 } } }, { "encodedKey": "8a19c4b0809316570180948df1c50f8b", "parentAccountKey": "8a19c4b0809316570180948be98c0f85", "number": "2", "dueDate": "2022-10-06T02:00:00+02:00", "state": "PENDING", "isPaymentHoliday": false, "principal": { "amount": { "expected": 5000.0, "paid": 0, "due": 5000.0 } }, "interest": { "amount": { "expected": 28.71, "paid": 0, "due": 28.71 }, "tax": { "expected": 0, "paid": 0, "due": 0 } }, "fee": { "amount": { "expected": 0, "paid": 0, "due": 0 }, "tax": { "expected": 0, "paid": 0, "due": 0 } }, "penalty": { "amount": { "expected": 0, "paid": 0, "due": 0 }, "tax": { "expected": 0, "paid": 0, "due": 0 } } } ]}}] }');
            res.setStatusCode(200);
        }
        if(req.getEndpoint().contains('https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/E')){ 
            res.setHeader('Content-Type', 'application/json');
             res.setBody('{ "request_proc": "ok", "ops": [ { "proc": "ok", "data": { "errors": [ { "errorCode": 4, "errorSource": "group member - client key is duplicated", "errorReason": "INVALID_PARAMETERS" } ] } } ] }');
            res.setStatusCode(200);
        }
       	if(req.getEndpoint().contains('https://testLoanSync.sandbox.mpo.mambu.com/api/1/json/Ex')){ 
            res.setHeader('Content-Type', 'application/json');
             res.setBody('{ "request_proc": "ok", "ops": [ { "proc": "ok", "data": { "errors": [ { "errorCode": 4, "errorSource": "group member - client key is duplicated", "errorReason": "INVALID_PARAMETERS" } ] } } ] }');
            res.setStatusCode(101);
        }
        return res;
    }
}