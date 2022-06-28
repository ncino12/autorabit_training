@RestResource(urlMapping='/AccountInsert')
global with sharing class AccountRestAPI {
    
    @HttpPost
    global static wrapperData createAccount() {
        String jsonresp = '';
        RestRequest     request    = RestContext.request;
        RestResponse    response   = RestContext.response;    
        response.addHeader('Content-Type','application/json');
        system.debug(request.requestBody.toString());
       
        wrapperData wrapData = (wrapperData)JSON.deserialize(request.requestBody.toString(),wrapperData.class);
      	// List<accountInformation> accountInformationDattaWrap = (List<accountInformation>)JSON.deserialize(dryptData,List<accountInformation>.class);
        system.debug(wrapData.accountInformationList);
        List<Account> accountListForInsert = new List<Account>();
        if(wrapData.accountInformationList.size()>0){
            
            for(accountInformation accountInfo :wrapData.accountInformationList){
                accountListForInsert.add(accountInfo.accountData);
            }
            if(accountListForInsert.size() > 0){
                upsert accountListForInsert;
            }
        }
        for(Account newAccountInfo :accountListForInsert){
            
            for(accountInformation accountInfo :wrapData.accountInformationList){
                
                if(newAccountInfo.Id != null){
                    accountInfo.status = 'success';
                    accountInfo.accexception = '';
                    accountInfo.accountData = newAccountInfo;
                }
                
            }
            
        }
        return wrapData;
    }
   
    global  class wrapperData{
        public List<accountInformation> accountInformationList;
    }
    // account Information data wrapper 
    global  class accountInformation{
        public Account accountData;
        public String status;
        public String accexception;
    }
}