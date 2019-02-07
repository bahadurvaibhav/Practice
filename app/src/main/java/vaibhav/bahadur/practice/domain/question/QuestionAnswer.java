package vaibhav.bahadur.practice.domain.question;

import android.arch.persistence.room.ColumnInfo;
import android.arch.persistence.room.Entity;
import android.arch.persistence.room.PrimaryKey;

@Entity(tableName = "question_answer")
public class QuestionAnswer {

    @PrimaryKey(autoGenerate = true)
    private int id;

    @ColumnInfo(name = "question_id")
    private int questionId;

    @ColumnInfo(name = "answer_text")
    private String answerText;

    public QuestionAnswer(int questionId, String answerText) {
        this.questionId = questionId;
        this.answerText = answerText;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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
