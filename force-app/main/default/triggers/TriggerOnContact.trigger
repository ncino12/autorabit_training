trigger TriggerOnContact on Contact (after insert) {
    /*if(Trigger.isBefore && Trigger.isInsert){
        List<Contact> newcontactlist=new List<Contact>();
	for(Contact contact:Trigger.new){
        String contactid=contact.id;
        Contact contactrecord=[SELECT Id,AccountId FROM Contact WHERE Id=:contactid LIMIT 1];
        String accountid=contactrecord.AccountId;
        LLC_BI__Connection__c record=[SELECT Id, LLC_BI__Connected_From__c, LLC_BI__Connected_To__c FROM LLC_BI__Connection__c WHERE LLC_BI__Connected_From__c=:accountid LIMIT 1];
        contactrecord.Business_Relationship__c=record.LLC_BI__Connected_To__c;
        newcontactlist.add(contactrecord); 
    }
        update newcontactlist;
}*/
}