# Salesforce-StartQuiz
The testing system allows you to create tests with
different number of questions create / modify / delete questions for
a specific test, pass the tests and save the result
passing.
Data Model System:
-Test (Quiz)
-Question
-Session
-Test (Quiz):
An object that should contain the test subject (mathematics, biology and
etc.), questions, the number of questions in this test.
-Question:
An object that should contain a link to a particular test, question, 4
answer options and the correct answer for this question.
Note: The link to the test must be required.
-Session:
The object that should contain a link to the selected test, the number of questions in
test, the number of correct answers, the number of incorrect answers and the percentage
completion of the test.

Система тестирования позволяет составлять тесты с
различным количеством вопросов, создавать/изменять/удалять вопросы для
определенного теста, проходить составленные тесты и сохранять результат
прохождения.
Data Model системы :
-Test(Quiz)
-Question
-Session
-Test(Quiz):
Объект, который должен содержать в себе тематику теста(математика, биология и
т.д.), вопросы, количество вопросов в данном тесте.
-Question:
Объект, который должен содержать в себе ссылку на тот или иной тест, вопрос, 4
варианта ответа и правильный вариант ответа для этого вопроса.
Note: ссылка на тест должна быть required.
-Session:
Объект, который должен содержать ссылку на выбранный тест, количество вопросов в
тесте, количество правильных ответов, количество неправильных ответов и процент
завершенности теста.
