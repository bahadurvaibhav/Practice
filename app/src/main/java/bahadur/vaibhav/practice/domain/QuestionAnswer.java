package bahadur.vaibhav.practice.domain;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity(tableName = "question_answer")
public class QuestionAnswer {

    @PrimaryKey(autoGenerate = true)
    private int id;

    @ColumnInfo(name = "form_id")
    private int formId;

    @ColumnInfo(name = "question_id")
    private int questionId;

    @ColumnInfo(name = "answer_text")
    private String answerText;

    public QuestionAnswer(int formId, int questionId, String answerText) {
        this.formId = formId;
        this.questionId = questionId;
        this.answerText = answerText;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getFormId() {
        return formId;
    }

    public void setFormId(int formId) {
        this.formId = formId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getAnswerText() {
        return answerText;
    }

    public void setAnswerText(String answerText) {
        this.answerText = answerText;
    }
}
