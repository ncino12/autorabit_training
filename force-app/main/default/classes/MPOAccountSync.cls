public class MPOAccountSync {
    public static Callout_Service_Attributes__c getCalloutAttr(String name){
        Callout_Service_Attributes__c attrReq = [SELECT Id, Username__c, Timeout__c, Service_Name__c, Process_Id__c, Named_Credentials__c,Password__c, Label__c, Endpoint__c, Api_Login__c, Name FROM Callout_Service_Attributes__c where Label__c=:name ];
        return attrReq;
    }
    
    @AuraEnabled
    public static responseWrap createAccountOnMambu(String loanId) {
        responseWrap responseData = new responseWrap();
        LLC_BI__Loan__c loanData =  [SELECT Id,LLC_BI__Product_Reference__c, Name,Mambu_Loan_Id__c,Insufficient_Budget__c,Budget_Reserved__c,LLC_BI__Account__r.ShippingPostalCode,LLC_BI__Account__r.ShippingCountry,LLC_BI__Account__r.ShippingState,LLC_BI__Account__r.ShippingStreet,LLC_BI__Account__r.cm_Email_Address__c,LLC_BI__Account__r.Phone,LLC_BI__Budget__c,LLC_BI__Product__c,LLC_BI__Account__r.Name,LLC_BI__Account__r.Group_ID__c, LLC_BI__Account_Officer__c, LLC_BI__Account__c, LLC_BI__Stage__c,LLC_BI__Amount__c,LLC_BI__InterestRate__c,arrears_Tolerance_Period__c,Repayment_Period_Unit__c,Repayment_Installments__c,Penalty_Rate__c,Tranche_Amount__c,Tranche_expected_disbursement_date__c,loanTenor__c,LLC_BI__Product_Line__c,LLC_BI__Product_Reference__r.Legal_Entity__c, LLC_BI__Product_Reference__r.Product_ID__c,LLC_BI__Product_Reference__r.Mambu_Product_Name__c,Number_of_Installments__c,Interest_spread__c,Limit_Expiry_Date__c,First_Repayment_Date__c,Loan_Expiry_Date__c FROM LLC_BI__Loan__c where id=: loanId];
        List<LLC_BI__Budget_Line_Item__c> trancheRecords = [SELECT Id, LLC_BI__Budget__c, LLC_BI__Amount_Budgeted__c, Expected_tranche_date__c FROM LLC_BI__Budget_Line_Item__c where LLC_BI__Budget__c=:loanData.LLC_BI__Budget__c];
        System.debug('ldd'+loanData.Tranche_expected_disbursement_date__c);
        
        
        List<tranchesClass> TrancheData = new List<tranchesClass>();
        for(LLC_BI__Budget_Line_Item__c trancheRecord:trancheRecords)
        {
            tranchesClass trancheDetail = new tranchesClass();
            trancheDetail.amount = trancheRecord.LLC_BI__Amount_Budgeted__c;
            disbursementDetails dDetail = new disbursementDetails();
            DateTime trancheExpectedDisbursementDateTime = trancheRecord.Expected_tranche_date__c;
            System.debug('reqDate'+trancheExpectedDisbursementDateTime);
            Date trancheExpectedDisbursementDate;
            if(trancheExpectedDisbursementDateTime != null){
                trancheExpectedDisbursementDate    = date.newInstance(trancheExpectedDisbursementDateTime.year(),trancheExpectedDisbursementDateTime.month(),trancheExpectedDisbursementDateTime.day());
                
            }
            String trancheExpectedDisbursementDateVal = String.valueOf(trancheExpectedDisbursementDate);
            String trancheExpectedDisbursementTimeVal = '';
            if(trancheExpectedDisbursementDateTime!=null){
            	trancheExpectedDisbursementTimeVal = trancheExpectedDisbursementDateTime.format('HH:mm:ss');
            }
            String trancheExpectedDisbursementDateTimeApi = trancheExpectedDisbursementDateVal+'T'+trancheExpectedDisbursementTimeVal+'+02:00';
            dDetail.expectedDisbursementDate = trancheExpectedDisbursementDateTimeApi;
            //dDetail.expectedDisbursementDate = '2022-05-06T13:37:50+02:00';
            System.debug('ttddeetta****'+trancheExpectedDisbursementDateTimeApi);
            trancheDetail.disbursementDetails = dDetail;
            TrancheData.add(trancheDetail);
        }
        DateTime firstRepaymentDateTime = loanData.First_Repayment_Date__c;
        
        Date firstRepaymentDate;
        if(firstRepaymentDateTime != null){
            firstRepaymentDate    = date.newInstance(firstRepaymentDateTime.year(),firstRepaymentDateTime.month(),firstRepaymentDateTime.day());
            
        }
        String firstRepaymentDateVal = String.valueOf(firstRepaymentDate);
        String firstRepaymentTimeVal='';
        if(loanData.First_Repayment_Date__c!=null){
         firstRepaymentTimeVal = loanData.First_Repayment_Date__c.format('HH:mm:ss');
        }
        String firstRepaymentDateTimeApi = firstRepaymentDateVal+'T'+firstRepaymentTimeVal+'+02:00';
        System.debug('fpdd'+firstRepaymentDateTimeApi);
        System.debug('td'+TrancheData);
        
        DateTime loanExpiryDateTime = loanData.Loan_Expiry_Date__c;
        
        Date loanExpiryDate;
        if(loanExpiryDateTime != null){
            loanExpiryDate    = date.newInstance(loanExpiryDateTime.year(),loanExpiryDateTime.month(),loanExpiryDateTime.day());
            
        }
        String loanExpiryDateVal = String.valueOf(loanExpiryDate);
        String loanExpiryTimeVal='';
        if(loanData.Loan_Expiry_Date__c!=null){
         loanExpiryTimeVal = loanData.Loan_Expiry_Date__c.format('HH:mm:ss');
        }
        String loanExpiryDateTimeApi = loanExpiryDateVal+'T'+loanExpiryTimeVal+'+02:00';
        System.debug('ledt**************'+loanExpiryDateTimeApi);
        
        
        
        
        System.debug('product****************'+loanData.LLC_BI__Product_Reference__r.Product_ID__c);
        
        if(loanData.LLC_BI__Product__c == 'Term Loans' && loanData.LLC_BI__Budget__c == null){
            responseData.message = 'Please create the disbursment schedule for the loan';
            responseData.isError = true;
            return responseData;
        }
        
        if(loanData.Budget_Reserved__c == false){
            responseData.message = 'You cannot sync loan, until the budget is reserved';
            responseData.isError = true;
            return responseData;
        }
        if(loanData.Insufficient_Budget__c == true){
            responseData.message = 'You cannot sync loan, because there is insufficient budget';
            responseData.isError = true;
            return responseData;
        }
        
        List<LLC_BI__LLC_LoanDocument__c> loanDocs = new List<LLC_BI__LLC_LoanDocument__c>();
        if(loanId!=null){
             loanDocs= [SELECT LLC_BI__Loan__c,Name  from LLC_BI__LLC_LoanDocument__c where  LLC_BI__Loan__c =:loanId];
        }
        List<String> loanDocNames = new List<String>();
        if(loanDocs.size()>0){
            for(LLC_BI__LLC_LoanDocument__c ld:loanDocs){
                loanDocNames.add(ld.Name);
            }
        }
        System.debug(loanDocNames);
        
        LLC_BI__LLC_LoanDocument__c loanAgreementRecord = new LLC_BI__LLC_LoanDocument__c() ;
        if(loanId!=null && loanDocNames.contains('Loan Agreement')){
         loanAgreementRecord = [Select LLC_BI__Loan__c,LLC_BI__reviewStatus__c,Name from LLC_BI__LLC_LoanDocument__c where (LLC_BI__Loan__c=:loanId And Name ='Loan Agreement')];
        }
        if(loanAgreementRecord!=null){
        if(loanAgreementRecord.LLC_BI__reviewStatus__c != 'Signed')
        {
            responseData.message = 'Loan agreement in document manager needs to be signed!';
            responseData.isError = true;
            return responseData;
        }
        }
        else{
            responseData.message = 'Loan agreement in document manager needs to be signed!';
            responseData.isError = true;
            return responseData;
        }
        system.debug('loanData'+loanData);
        //Below Switch case code is to check if mandatory fields are filled depending on the Product ID chosen.
        if(loanData.LLC_BI__Product_Reference__c !=null || Test.isRunningTest()){
            switch on loanData.LLC_BI__Product_Reference__r.Product_ID__c
            {
                when 'EIS_TLI_EUR_1'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.LLC_BI__InterestRate__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Rate,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TL_EUR_1'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.LLC_BI__InterestRate__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Rate,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TLI_EUR_2'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.Interest_spread__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Spread,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TLI_EUR_3'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.Interest_spread__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Spread,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TLI_EUR_4'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.Interest_spread__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Spread,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TL_EUR_2'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.Interest_spread__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Spread,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TL_EUR_3'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.Interest_spread__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Spread,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TL_EUR_4'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.Interest_spread__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Spread,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TLI_USD_1'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.LLC_BI__InterestRate__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Rate,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TLI_USD_2'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.Interest_spread__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Spread,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TL_USD_1'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.LLC_BI__InterestRate__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Rate,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_TL_USD_2'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c == null || loanData.Interest_spread__c == null || loanData.Repayment_Period_Unit__c==null || loanData.Repayment_Installments__c==null || loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Spread,Repayment Period Unit,Repayment Installments,Penalty Rate,arrears Tolerance period,Tranche Amount & Expected Tranche Disbursement Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_RC_EUR_1'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c==null || loanData.LLC_BI__InterestRate__c==null ||loanData.Repayment_Period_Unit__c==null|| loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null || loanData.loanTenor__c==null || loanData.Limit_Expiry_Date__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Rate,Repayment Period Unit,Penalty Rate,arrears Tolerance period,Loan Tenor & Limit Expiry Date';
                        responseData.isError = true;
                        return responseData;
                    }
                }
                when 'EIS_RC_EUR_2'{
                    if(loanData.LLC_BI__Account__c==null || loanData.LLC_BI__Product_Reference__r.Mambu_Product_Name__c==null || loanData.LLC_BI__Amount__c==null || loanData.Interest_spread__c == null ||loanData.Repayment_Period_Unit__c==null|| loanData.Penalty_Rate__c==null || loanData.arrears_Tolerance_Period__c==null || loanData.loanTenor__c==null || loanData.Limit_Expiry_Date__c==null){
                        responseData.message = 'For the selected Product Id, Please make sure Account Recipient, Product Reference, Loan Amount, Interest Rate,Repayment Period Unit,Penalty Rate,arrears Tolerance period,Loan Tenor & Limit Expiry Date';
                        responseData.isError = true;
                        return responseData;
                    }
            }
            }}
        else {
            responseData.message = 'You have not selected the product associated with this Loan. The Product Reference needs to be filled.';
            responseData.isError = true;
            return responseData;   
        }
        
        if(loanData.LLC_BI__Stage__c != 'Close Contract'){
            responseData.message = 'Loan can be synced only after close contract stage';
            responseData.isError = true;
            return responseData;
        }
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        String namedCredentials = '';
        if(Test.isRunningTest()){
            namedCredentials = 'Loan Creation';
        }else{
          namedCredentials  = Label.Loan_Creation;
        }
         
        Callout_Service_Attributes__c callAttrReq = getCalloutAttr(namedCredentials);
        System.debug('6565+654+65+65+656465'+callAttrReq.Endpoint__c);
        String endPoint = callAttrReq.Endpoint__c;//'https://ireland2-syncapi.sandbox.mpo.mambu.com/api/1/json';
        String ProcessID =string.valueOf(callAttrReq.Process_Id__c);// '23322';
        String apiLogin = callAttrReq.Api_Login__c;//'321';
        String apiSecret = callAttrReq.Password__c;
        
        String unixTime = String.valueof(DateTime.now().getTime()/1000);
        
        system.debug('unixTime'+unixTime);
        
        jsonBody wrapBody = new jsonBody();
        
        List<oppsData> oppsList = new List<oppsData>();
        oppsData oppData = new oppsData();
        oppData.type = 'create';
        oppData.obj = 'task';
        oppData.conv_id = Integer.valueOf(callAttrReq.Process_Id__c);
        
        dataV data = new dataV();
        clientDetailsClass clientDetails = new clientDetailsClass();
        
        clientDetails.firstName = 'Test With MPO';
        clientDetails.middleName = 'Test ';
        clientDetails.lastName = 'Test';
        clientDetails.clientId = 'CLI11223SHNS';
        clientDetails.gender = 'Male';
        clientDetails.birthDate = '2002-01-10';
        clientDetails.mobilePhone = '+9198773485';
        clientDetails.emailAddress = 'abcd@gmail';
        clientDetails.mobilePhone2 = '';
        clientDetails.preferredLanguage = 'ENGLISH';
        
        addressClass address = new addressClass();
        address.line1 = '14, Argyll Street';
        address.line2 = 'Malvern East';
        address.city = 'Melbourne';
        address.region = 'Victoria';
        address.country = 'Australia';
        address.postcode = '3145';
        clientDetails.address = address;
        
        data.clientDetails =  clientDetails;
        
        groupDetailsClass groupDetails = new groupDetailsClass();
        
        groupDetails.groupId = loanData.LLC_BI__Account__r.Group_ID__c;
        groupDetails.groupName = loanData.LLC_BI__Account__r.Name;
        groupDetails.mobilePhone = loanData.LLC_BI__Account__r.Phone;
        groupDetails.homePhone = '';
        groupDetails.emailAddress = loanData.LLC_BI__Account__r.cm_Email_Address__c;
        groupDetails.preferredLanguage = 'ENGLISH';
        
        addressClass clAddress = new addressClass();
        clAddress.line1 = loanData.LLC_BI__Account__r.ShippingStreet; 
        clAddress.line2 = '';
        clAddress.city = 'Melbourne';
        clAddress.region = loanData.LLC_BI__Account__r.ShippingState;
        clAddress.country = loanData.LLC_BI__Account__r.ShippingCountry;
        
        clAddress.postcode = loanData.LLC_BI__Account__r.ShippingPostalCode;
        groupDetails.address = clAddress;
        
        data.groupDetails = groupDetails;
        
        loanDetailsClass loanDetails = new loanDetailsClass();
        //loanDetails.productId = 'EIS_TL_EUR_10';
        //loanDetails.productId = loanData.LLC_BI__Product_Reference__r.Product_ID__c;
        loanDetails.productId = String.valueOf(loanData.LLC_BI__Product_Reference__r.Product_ID__c);
        loanDetails.loanAmount = loanData.LLC_BI__Amount__c;
        loanDetails.arrearsTolerancePeriod = loanData.arrears_Tolerance_Period__c;
        interestSettingsClass interestSettings = new interestSettingsClass();
        interestSettings.interestRate = loanData.LLC_BI__InterestRate__c;
        interestSettings.interestSpread = null;
        if(String.valueOf(loanData.LLC_BI__Product_Reference__r.Product_ID__c) == 'EIS_TLI_EUR_2' || String.valueOf(loanData.LLC_BI__Product_Reference__r.Product_ID__c) == 'EIS_TL_EUR_2' ){
            interestSettings.interestSpread = loanData.Interest_spread__c;
            interestSettings.interestRate = null;
        }
        
        loanDetails.interestSettings = interestSettings;
        scheduleSettingsClass scheduleSettings = new scheduleSettingsClass();
        scheduleSettings.repaymentPeriodUnit = loanData.Repayment_Period_Unit__c;
        scheduleSettings.repaymentInstallments = loanData.Repayment_Installments__c;
        scheduleSettings.repaymentPeriodCount = 2;
        if(String.valueOf(loanData.LLC_BI__Product_Reference__r.Product_ID__c) == 'EIS_RC_EUR_1')
        {
         	scheduleSettings.repaymentInstallments = null;
        }
        loanDetails.scheduleSettings = scheduleSettings;
        penaltySettingsClass penaltySettings = new penaltySettingsClass();
        penaltySettings.penaltyRate = loanData.Penalty_Rate__c;
       
        loanDetails.penaltySettings = penaltySettings;
        disbursementDetailsClass disbursementDetails = new disbursementDetailsClass();
        disbursementDetails.firstRepaymentDate = firstRepaymentDateTimeApi;//'2022-09-06T13:37:50+02:00'; //2022-04-28 07:00:00
      
        loanDetails.disbursementDetails = disbursementDetails;
     
        loanDetails.tranches = TrancheData;
        loanDetails.loanTenor = null;
        loanDetails.loanExpiryDate = null; 
        if(String.valueOf(loanData.LLC_BI__Product_Reference__r.Product_ID__c) == 'EIS_RC_EUR_1'){
            loanDetails.loanTenor = loanData.loanTenor__c;
            loanDetails.loanExpiryDate = loanExpiryDateTimeApi;
             
            loanDetails.tranches = null;
        }
       
        
        
        data.loanDetails = loanDetails;
        
        budgetDetailsClass  budgetDetails = new budgetDetailsClass();
        budgetDetails.schemeName = loanData.LLC_BI__Product_Line__c;
        budgetDetails.branchId = loanData.LLC_BI__Product_Reference__r.Legal_Entity__c;
        budgetDetails.budgetAmount = loanData.LLC_BI__Amount__c;
        System.debug('branchId'+loanData.LLC_BI__Product_Reference__r.Legal_Entity__c);
        
        data.budgetDetails = budgetDetails;
        
        oppData.data = data;
        
        oppsList.add(oppData);
        
        wrapBody.ops = oppsList;
        String body = JSON.serialize(wrapBody);
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
        if(!Test.isRunningTest()){
            req.setTimeout(Integer.valueOf(callAttrReq.Timeout__c));
        }
        
        //req.setCompressed(true); // otherwise we hit a limit of 32000
        
        try {
            res = http.send(req);
            System.debug('status'+res.getStatusCode());
            if(res.getStatusCode()==200){
                System.debug('body'+res.getBody());
                String responseBodyString = res.getBody();
                responseBodyString = responseBodyString.replaceAll('number','num');
                jsonBodyRes jsonResponse = (jsonBodyRes)JSON.deserialize(responseBodyString, jsonBodyRes.class);
                //system.debug('errorResponse'+errorResponse.ops[0].data.errors[0].errorReason);
                
                if(jsonResponse.ops[0].data.errors != null){
                    String errorMessage = '';
                    if(jsonResponse.ops[0].data.errors[0].errorSource!=null){
                        errorMessage = jsonResponse.ops[0].data.errors[0].errorSource;
                    } if(jsonResponse.ops[0].data.errors[0].errorReason!=null){
                        errorMessage+= jsonResponse.ops[0].data.errors[0].errorReason; 
                    }
                    responseData.message = errorMessage;
                    responseData.isError = true;
                    Error_Logs__c newrecord=new Error_Logs__c();
                    newrecord.Error_Message__c=errorMessage;
                    newrecord.Occurance_Date_Time__c=System.now();
                    newrecord.Object__c='LLC_BI__Loan__c';
                    newrecord.Location__c='MPOAccountSync';
                    newrecord.Record_ID__c=loanId;
                    
                    insert newrecord;
                }else if(jsonResponse.ops[0].data!=null){
                    responseData.message = 'The Loan is Synced successfully.';
                    responseData.isError = false;
                    responseData.responseCode = 200;
                    loanData.LLC_BI__Stage__c = 'Monitoring and Servicing';
                    loanData.Mambu_Loan_Id__c = jsonResponse.ops[0].data.loanDetails.loanId;
                    //System.debug('loanId'+jsonResponse.ops[0].data.loanDetails.loanId);
                    if(jsonResponse.ops[0].data!=null && jsonResponse.ops[0].data.installments!=null && jsonResponse.ops[0].data.installments.size()>0){
                        List<Installment__c> newInstallmentsList = new List<Installment__c>();
                        for(installmentClass installment: jsonResponse.ops[0].data.installments){
                            
                            Installment__c newInstallment = new Installment__c();
                         	String dt = installment.dueDate.split('T')[0];
                            String tm = installment.dueDate.split('T')[1].split('\\+')[0];
                            String dttm = dt+' '+tm;
                            DateTime dt1 = DateTime.valueOf(dttm);
                            newInstallment.Due_date__c = dt1;
                            newInstallment.Loan__c = loanId;
                            newInstallment.Paid_principal_amount__c = installment.principal.amount.paid;
                            newInstallment.Due_fee_amount__c = installment.fee.amount.due;
                            newInstallment.Due_fee_tax__c = installment.fee.tax.due;
                            newInstallment.due_interest_amount__c = installment.interest.amount.due;
                            newInstallment.due_interest_tax__c = installment.interest.tax.due;
                            newInstallment.Due_penalty_amount__c = installment.penalty.amount.due;
                            newInstallment.Due_penalty_tax__c = installment.penalty.tax.due;
                            newInstallment.Due_principal_amount__c = installment.principal.amount.due;
                            //newInstallment.Due_tax_amount__c = installment.principal.amount.due;
							newInstallment.Expected_fee_amount__c = installment.fee.amount.expected; 
                            newInstallment.expected_fee_tax__c = installment.fee.tax.expected; 
                            newInstallment.Expected_interest_amount__c = installment.interest.amount.expected;
                            newInstallment.Expected_interest_tax__c = installment.interest.tax.expected;
                            newInstallment.Expected_penalty_amount__c = installment.penalty.amount.expected;
                            newInstallment.Expected_penalty_tax__c = installment.penalty.tax.expected;
                            newInstallment.Expected_principal_amount__c = installment.principal.amount.expected;
                            //newInstallment.Expected_tax_amount__c = installment.principal.amount.expected;
                            newInstallment.isPaymentHoliday__c = installment.isPaymentHoliday;
                            //newInstallment.Number__c = installment.isPaymentHoliday;
                            newInstallment.Paid_fee_amount__c = installment.fee.amount.paid;
                            newInstallment.Paid_fee_tax__c = installment.fee.tax.paid;
                            newInstallment.paid_interest_amount__c = installment.interest.amount.paid;
                            newInstallment.paid_interest_tax__c = installment.interest.tax.paid;
                            newInstallment.Paid_penalty_amount__c = installment.penalty.amount.paid;
                            //newInstallment.Paid_tax_amount__c = installment.penalty.amount.paid;
                            newInstallment.Paid_penalty_tax__c = installment.penalty.tax.paid;
                            newInstallment.Parent_Account_Key__c = installment.parentAccountKey;
                            newInstallment.State__c = installment.state;
                            newInstallment.Encoded_key__c = installment.encodedKey;
                            newInstallment.Number__c = installment.num;
                            newInstallmentsList.add(newInstallment);
                            
                           
                            
                        }
                        insert newInstallmentsList;
                    }
                          
                    update loanData;
                    
                }
            }else{
                responseData.message = res.getBody();
                responseData.isError = true;
                Error_Logs__c newrecord=new Error_Logs__c();
                newrecord.Error_Message__c=res.getBody();
                newrecord.Occurance_Date_Time__c=System.now();
                newrecord.Object__c='LLC_BI__Loan__c';
                newrecord.Location__c='ReserveBudget';
                newrecord.Record_ID__c=loanId;
                
                insert newrecord;
            }
            
            
            system.debug('res'+res.getBody());
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
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
        clientDetailsClass clientDetails;
        groupDetailsClass groupDetails;
        loanDetailsClass loanDetails;
        budgetDetailsClass budgetDetails;
    }
    
    public class clientDetailsClass{
        String firstName;
        String middleName;
        String lastName;
        String clientId;
        String gender;
        String birthDate;
        String mobilePhone;
        String emailAddress;
        String mobilePhone2;
        String preferredLanguage;
        addressClass address;
    }
    
    
    public class groupDetailsClass{
        String groupId;
        String groupName;
        String mobilePhone;
        String homePhone;
        String emailAddress;
        String preferredLanguage;
        addressClass address;
    }
    
    public class addressClass{
        String line1;
        String line2;
        String city;
        String region;
        String country;
        String postcode;
    }
    
    public class loanDetailsClass{
        String productId;
        Decimal loanAmount;
        Decimal arrearsTolerancePeriod;
        interestSettingsClass interestSettings;
        scheduleSettingsClass scheduleSettings;
        penaltySettingsClass penaltySettings;
        disbursementDetailsClass disbursementDetails;
        List<tranchesClass> tranches;
        Decimal loanTenor;
        String loanExpiryDate;
    }
    
    public class interestSettingsClass{
        Double interestRate;
        Double interestSpread;
    }
    
    public class scheduleSettingsClass{
        String repaymentPeriodUnit;
        Decimal  repaymentInstallments;
        Integer repaymentPeriodCount;
    }
    
    public class penaltySettingsClass{
        Double penaltyRate;
    }
    
    public class disbursementDetailsClass{
        String firstRepaymentDate;
    }
    
    public class tranchesClass{
        Decimal amount;
        disbursementDetails disbursementDetails;
    }
    
    public class disbursementDetails{
        String expectedDisbursementDate;
    }
    
    public class budgetDetailsClass{
        String schemeName;
        String branchId;
        Decimal budgetAmount;
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
        String request_proc {get; set;}
        List<oppsDataRes> ops {get; set;}
    }
    public class oppsDataRes{
        String proc {get; set;}
        dataVRes data {get; set;}
    }
    
    public class dataVRes{
        List<error> errors {get; set;}
        loanDetialsClass loanDetails {get; set;}
        List<installmentClass> installments;
    }
    public class installmentClass{
        String encodedKey;
        String parentAccountKey;
        String num;
        String dueDate;
        String state;
        Boolean isPaymentHoliday;
        principalClass principal;
        interestClass interest;
        feeClass fee;
        penaltyClass penalty;
    }
    public class principalClass{
        amountClass amount;
    }
    public class interestClass{
        amountClass amount;
        taxClass tax;
    }
    public class feeClass{
        amountClass amount;
        taxClass tax;
    }
    public class penaltyClass{
        amountClass amount;
        taxClass tax;
    }
    public class amountClass{
        Double expected;
        Double paid;
        Double due;
    }
    public class taxClass{
        Double expected;
        Double paid;
        Double due;
    }
    public class loanDetialsClass{
        String loanId {get; set;}
    }
    
    public class error{
        String errorCode {get; set;}
        String errorSource {get; set;}
        String errorReason {get; set;}
    }
}