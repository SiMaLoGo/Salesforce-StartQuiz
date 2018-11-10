public class StartQuizController {
    //List of tests which exists in the DB
    public List<Test__c> existingTests { get{
        return [SELECT Subject__c, Question_Count__c FROM Test__c];
    } set; }
    
    //Current session of passing selected test
    public Session__c session { get; set; } 
    //List of Questions from selected Test
    public List<Question__c> questions { get; set; }
    //Variable for storing of a question which displayed on the vf page
    public Question__c currentQuestion { get; set; }
    //List of options which defines variant of an answer
    public List<SelectOption> variants { get; set; }
    //Map for storing answered variants
    public Map<Id, String> answerByQuestion { get; set; }
    //Variable for switching of questions
    public Integer indexOfQuestion { get; set; }
    //Variable for starting test
    public Boolean isTestSelected { get; set; }
    //Variable for finish test
    public Boolean isTestFinished { get; set; }
    //Id of selected Test
    public String selectedTestId { get; set; }
    //Variable for storing selected variant of currentQuestion
    public String selectedVariant { get; set; }
    // Indicator of answer correct/incorrect
    public Boolean indicator  { get; set; }
    public Boolean isModalOpened  { get; set; }
    public Decimal percentOfCompleteness { get; set; }
    
    public StartQuizController() {
        this.answerByQuestion = new Map<Id, String>();
        this.session = new Session__c();
        this.session.Right_Answers__c = 0;
        this.indexOfQuestion = 0;
        this.percentOfCompleteness = 0;
        this.isTestSelected = false;
        this.isTestFinished = false;
        this.indicator = false;
        this.isModalOpened = false;
        this.questions = new List<Question__c>();
    }
    
    //Method which starts selected test and defines list of questions
    public void startTest() {
        this.isTestSelected = true;
        this.session.Selected_Test__c = this.selectedTestId;
        this.questions = [SELECT Question__c, Right_Variant__c, Variant_1__c, Variant_2__c, Variant_3__c,
                    Variant_4__c FROM Question__c WHERE Test__c =: this.selectedTestId ORDER BY CreatedDate ASC];
        
        if(!this.questions.isEmpty()) {
            this.currentQuestion = this.questions[this.indexOfQuestion];
            this.getRadioValues();
        }
    }
    
    //Method which cancels the Test
    public void cancelTest() {
        this.isTestSelected = false;
        this.currentQuestion = null;
    }
    
    //Method which redirects to the previous step
    public void back() {
        if(this.indexOfQuestion > 0) {
            this.indexOfQuestion--;
            this.currentQuestion = this.questions[this.indexOfQuestion];
            this.getRadioValues();
            
            if(this.indicator) {
                this.session.Right_Answers__c--;
            }
        } else {
            this.cancelTest();
        }
    }
    
    //Method which switches to the next question
    public void nextQuestion() {
        if(String.isBlank(this.selectedVariant)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select an answer'));
            return;
        }
        
        this.checkQuestion();
        this.answerByQuestion.put(this.questions[indexOfQuestion].Id, this.selectedVariant == null ? '' : this.selectedVariant);
        
        if(this.indexOfQuestion < this.questions.size() - 1) {
            this.indexOfQuestion++;
            this.currentQuestion = this.questions[this.indexOfQuestion];
            this.selectedVariant = '';
            this.getRadioValues();
        }
        // Last question
        else {
            this.percentOfCompleteness = (this.session.Right_Answers__c * 100 / this.questions.size()).setScale(0);
            // Switch to the "Result Table section" outputPanel
            this.isTestFinished = true;
            try {
                insert this.session;
            } catch(DmlException e) {
                System.debug('Erro Quiz Page : ' + e.getMessage());
            }
        }
    }
    
    //Method which validates selected variant
    public void checkQuestion() {
        if(this.selectedVariant == this.currentQuestion.Right_Variant__c) {
            this.session.Right_Answers__c++;
            this.indicator = true;
        } else {
            this.indicator = false;
        }
    }
    
    //Method which prepares variants
    public void getRadioValues() {
        this.variants = new List<SelectOption>();
        this.variants.add(new SelectOption(currentQuestion.Variant_1__c, currentQuestion.Variant_1__c));
        this.variants.add(new SelectOption(currentQuestion.Variant_2__c, currentQuestion.Variant_2__c));
        this.variants.add(new SelectOption(currentQuestion.Variant_3__c, currentQuestion.Variant_3__c));
        this.variants.add(new SelectOption(currentQuestion.Variant_4__c, currentQuestion.Variant_4__c));
    }
    
    public void closeModal() {
        this.isModalOpened = false;
    }
    
    public void openModal() {
        this.isModalOpened = true;
    }
}