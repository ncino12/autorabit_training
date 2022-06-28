public class TestUtility {

    public static sObject setFiledValue(sObject sobj, Map<String,String> filedalueMap){
        for(String key : filedalueMap.keySet()){
            if(filedalueMap.containsKey(key)){
                sobj.put(key,filedalueMap.get(key));
                if(filedalueMap.get(key)=='true'){
                 sobj.put(key,true);
                }
                else if(filedalueMap.get(key)=='false'){
                   sobj.put(key,false); 
                }
            }
            
            
        }
        return sobj;
    }
    public static Callout_Service_Attributes__c createCalloutService(Map<String,String> filedalueMap){
        Callout_Service_Attributes__c callOutService = new Callout_Service_Attributes__c();
        return (Callout_Service_Attributes__c)setFiledValue((sObject)callOutService,filedalueMap);
    }
    public static LLC_BI__Loan__c createLoan(Map<String,String> filedalueMap){
        
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        return (LLC_BI__Loan__c)setFiledValue((sObject)loan,filedalueMap);
    }
    
    public static LLC_BI__Product__c createProduct(Map<String,String> filedalueMap){
        LLC_BI__Product__c product = new LLC_BI__Product__c();
         return (LLC_BI__Product__c)setFiledValue((sObject)product,filedalueMap);
    }
    public Static LLC_BI__Product_Line__c createProductLine(Map<String,String> filedalueMap){
        LLC_BI__Product_Line__c productLine=new LLC_BI__Product_Line__c();
         return (LLC_BI__Product_Line__c)setFiledValue((sObject)productLine,filedalueMap);
    }
    public static LLC_BI__Product_Type__c createProductType(Map<String,String> filedalueMap){
        LLC_BI__Product_Type__c productType=new LLC_BI__Product_type__c();
        return (LLC_BI__Product_Type__c)setFiledValue((sObject)productType,filedalueMap);
    }
    public static LLC_BI__LLC_LoanDocument__c createLoanDocument(Map<String,String> filedalueMap){
        LLC_BI__LLC_LoanDocument__c loanDocument=new LLC_BI__LLC_LoanDocument__c();
        return (LLC_BI__LLC_LoanDocument__c)setFiledValue((sObject)loanDocument,filedalueMap);
    }
    
}