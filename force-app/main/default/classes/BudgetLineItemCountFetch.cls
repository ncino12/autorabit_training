public class BudgetLineItemCountFetch {
    public static Integer blicount(String budgetid)
    {
        List<LLC_BI__Budget_Line_Item__c> blirecords=[SELECT id, LLC_BI__Budget__c FROM LLC_BI__Budget_Line_Item__c WHERE LLC_BI__Budget__c=:budgetid];
        Integer blicount=blirecords.size();
        return blicount;
    }

}