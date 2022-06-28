@isTest
private class BudgetLineItemCountFetchTest {
	
    static testmethod void Test(){
        LLC_BI__Budget__c budgetnewrecord=new LLC_BI__Budget__c();
        insert budgetnewrecord;
        LLC_BI__Budget_Line_Item__c blinewrecord = new LLC_BI__Budget_Line_Item__c(LLC_BI__Budget__c=budgetnewrecord.id);
        insert blinewrecord;
		BudgetLineItemCountFetch.blicount(blinewrecord.id);  
    }
}