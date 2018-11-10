trigger QuestionTrigger on Question__c (before insert, before update, before delete,
                            after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            Set<Id> testIds = new Set<Id>();
            
            for(Question__c item: Trigger.new) {
                testIds.add(item.Test__c);
            }
            
            if(!Trigger.isInsert) {
            	for(Question__c item: Trigger.old) {
                	testIds.add(item.Test__c);
            	}
            }
            
            List<Test__c> tests = new List<Test__c>();
            tests = [SELECT Question_Count__c, (SELECT Id FROM Questions__r)
                     FROM Test__c WHERE Id IN: testIds];
            
            
            for(Test__c item: tests) {
                item.Question_Count__c = item.Questions__r.size();
            }
            
            update tests;
        } else if(Trigger.isDelete) {
            Set<Id> testIds = new Set<Id>();
            
            for(Question__c item: Trigger.old) {
                testIds.add(item.Test__c);
            }
            
            List<Test__c> tests = new List<Test__c>();
            tests = [SELECT Question_Count__c, (SELECT Id FROM Questions__r)
                     FROM Test__c WHERE Id IN: testIds];
            
            for(Test__c item: tests) {
                item.Question_Count__c = item.Questions__r.size();
            }
            
            update tests;
        }
    }
}