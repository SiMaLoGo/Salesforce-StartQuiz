@isTest
public class Test_QuestionTrigger {
    @isTest
    public static void testInsertUpdate() {
        Test__c test1 = new Test__c(Subject__c = 'Unit1', Question_Count__c = 0);
        insert test1;
        
        System.assertEquals(0, test1.Question_Count__c, 'Question Count is not 0');
        
        Question__c question1 = new Question__c(Question__c = 'Test Question', Variant_1__c = 'forward',
                                 Variant_2__c = 'behind', Variant_3__c = 'right', Variant_4__c = 'left',
                                                         Right_Variant__c = 'right', Test__c = test1.Id);
        insert question1;
        
        test1 = [SELECT Question_Count__c FROM Test__c];
        System.assertEquals(1, test1.Question_Count__c, 'Question Count is not 1');      
        
        //test update
        Test__c test2 = new Test__c(Subject__c = 'Unit2', Question_Count__c = 0);
        insert test2;
        
        question1.Test__c = test2.Id;
        update question1;
        
        test1 = [SELECT Question_Count__c FROM Test__c WHERE Subject__c = 'Unit1'];
        System.assertEquals(0, test1.Question_Count__c, 'Question Count is not 2');
    }
    
    
    @isTest
    public static void testDelete() {
        Test__c test = new Test__c(Subject__c = 'Unit', Question_Count__c = 0);
        insert test;
        
        Question__c question = new Question__c(Question__c = 'Test Question', Variant_1__c = 'forward',
                                 Variant_2__c = 'behind', Variant_3__c = 'right', Variant_4__c = 'left',
                                                         Right_Variant__c = 'right', Test__c = test.Id);
        insert question;
        delete question;
        
        test = [SELECT Question_Count__c FROM Test__c WHERE Subject__c = 'Unit'];
        System.assertEquals(0, test.Question_Count__c, 'Deletion of test is incorrect');
    }
	
}