package vaibhav.bahadur.practice.domain;

public class Question {
    private String description;
    private String answer;
    private QuestionType questionType;
    private PracticeType practiceType;

    public Question(String description, String answer, QuestionType questionType, PracticeType practiceType) {
        this.description = description;
        this.answer = answer;
        this.questionType = questionType;
        this.practiceType = practiceType;
    }

    public String getDescription() {
        return description;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public QuestionType getQuestionType() {
        return questionType;
    }

    public PracticeType getPracticeType() {
        return practiceType;
    }
}
