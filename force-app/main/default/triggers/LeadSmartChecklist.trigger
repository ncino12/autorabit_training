trigger LeadSmartChecklist on Lead (after insert, after update) {
  String beanName = 'LLC_BI.ChecklistAutoGenTriggerHandlerXPkg';
  nFORCE.BeanFactory beanFactory = nFORCE.BeanFactory.getInstance();
  nFORCE.ACrossPackageService service = (nFORCE.ACrossPackageService) beanFactory.getBeanByUniqueName(beanName);
  System.debug('Hello to Lead Trigger');
  String dmlType;
  if (Trigger.isInsert) {
    dmlType = 'insert';
  } else if (Trigger.isUpdate) {
    dmlType = 'update';
  }

  List<SObject> objects = Trigger.new;
  Set<Id> objectIds = new Set<Id>();
  for (Integer i = 0; i < objects.size(); i++) {
    objectIds.add(objects[i].Id);
  }

  service.setInputParameter('objects', objects);
  service.setInputParameter('objectIds', objectIds);
  service.setInputParameter('dmlType', dmlType);
  service.execute();
}