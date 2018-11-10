@isTest
private class Test_QuizController {
    private static void initData() {
        insert new Test__c(Subject__c = 'Unit1');
        Test__c test1 = [SELECT Question_Count__c FROM Test__c];
        
        List<Question__c> questions = new List<Question__c>();
        Question__c question1 = new Question__c(Question__c = 'Test Question',
                                               Test__c = test1.Id,
                                               Right_Variant__c = '2',
                                               Variant_1__c = '1',
                                               Variant_2__c = '2',
                                               Variant_3__c = '3',
                                               Variant_4__c = '4');
        questions.add(question1);
        
        Question__c question2 = new Question__c(Question__c = 'Test Question2',
                                               Test__c = test1.Id,
                                               Right_Variant__c = '4',
                                               Variant_1__c = '1',
                                               Variant_2__c = '2',
                                               Variant_3__c = '3',
                                               Variant_4__c = '4');
        questions.add(question2);
        insert questions;
    }

	@isTest
    static void testMethod1() {
        initData();
        StartQuizController quizController = new StartQuizController();
        
        System.assertEquals(1, quizController.existingTests.size());
        System.assertEquals(0, quizController.indexOfQuestion);
        System.assert(!quizController.isTestSelected);
        System.assert(!quizController.isTestFinished);
        System.assert(!quizController.indicator);
        
        // imitation click "Start Test" button
        quizController.selectedTestId = quizController.existingTests[0].Id;
        quizController.startTest();
        
        System.assert(quizController.isTestSelected);
        System.assertNotEquals(null, quizController.currentQuestion);
        System.assertEquals(4, quizController.variants.size());
        
        quizController.nextQuestion();
        System.assertEquals(0, quizController.indexOfQuestion);
        // Error block-message
        System.assert(ApexPages.getMessages().size() > 0);
        
        quizController.selectedVariant = '2';
        quizController.nextQuestion();
        System.assertEquals(1, quizController.indexOfQuestion);
        System.assertEquals(1, quizController.session.Right_Answers__c);
        
        quizController.selectedVariant = '2';
        quizController.nextQuestion();
        System.assertEquals(1, quizController.indexOfQuestion);
        System.assertEquals(1, quizController.session.Right_Answers__c);
        
        System.assert(quizController.isTestFinished);
        
        Session__c session = [SELECT Id, Right_Answers__c FROM Session__c];
        
        System.assertNotEquals(null, session);
        System.assertEquals(1, session.Right_Answers__c);
    }

        
    @isTest
    static void testMethodBacks() {
        initData();
        StartQuizController quizController = new StartQuizController();
        // imitation click "Start Test" button
        quizController.selectedTestId = quizController.existingTests[0].Id;
        quizController.startTest();
        
        System.assert(quizController.isTestSelected);
        System.assertNotEquals(null, quizController.currentQuestion);
        System.assertEquals(4, quizController.variants.size());
        
        quizController.nextQuestion();
        System.assertEquals(0, quizController.indexOfQuestion);
        
        // imitation click "Previous" similar "Cancel" button
        quizController.back();

        System.assert(!quizController.isTestSelected);
        System.assertEquals(null, quizController.currentQuestion);

        // imitation click "Start Test" button
        quizController.selectedTestId = quizController.existingTests[0].Id;
        quizController.startTest();
        
        System.assert(quizController.isTestSelected);
        System.assertNotEquals(null, quizController.currentQuestion);
        System.assertEquals(4, quizController.variants.size());
        
        quizController.nextQuestion();
        System.assertEquals(0, quizController.indexOfQuestion);
        // Error block-message
        System.assert(ApexPages.getMessages().size() > 0);

        quizController.selectedVariant = '2';
        quizController.nextQuestion();
        System.assertEquals(1, quizController.indexOfQuestion);
        System.assertEquals(1, quizController.session.Right_Answers__c);

        // imitation click "Previous" button
        quizController.back();
        System.assertEquals(0, quizController.indexOfQuestion);
        System.assertEquals(0, quizController.session.Right_Answers__c);
        
        quizController.selectedVariant = '2';
        quizController.nextQuestion();
        System.assertEquals(1, quizController.indexOfQuestion);
        System.assertEquals(1, quizController.session.Right_Answers__c);
        
        quizController.selectedVariant = '2';
        quizController.nextQuestion();
        System.assertEquals(1, quizController.indexOfQuestion);
        System.assertEquals(1, quizController.session.Right_Answers__c);
        
        System.assert(quizController.isTestFinished);
        
        Session__c session = [SELECT Id, Right_Answers__c FROM Session__c];
        
        System.assertNotEquals(null, session);
        System.assertEquals(1, session.Right_Answers__c);
    }
}