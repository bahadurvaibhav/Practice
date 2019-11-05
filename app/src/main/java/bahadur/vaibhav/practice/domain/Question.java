package bahadur.vaibhav.practice.domain;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;
import androidx.room.TypeConverters;

@Entity(tableName = "question")
public class Question {

    @PrimaryKey(autoGenerate = true)
    private int id;

    @ColumnInfo(name = "description")
    private String description;

    @TypeConverters(QuestionType.class)
    @ColumnInfo(name = "question_type")
    private QuestionType questionType;

    @TypeConverters(PracticeType.class)
    @ColumnInfo(name = "practice_type")
    private PracticeType practiceType;

    @ColumnInfo(name = "order")
    private int order;

    public Question(String description, QuestionType questionType, PracticeType practiceType, int order) {
        this.description = description;
        this.questionType = questionType;
        this.practiceType = practiceType;
        this.order = order;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public QuestionType getQuestionType() {
        return questionType;
    }

    public void setQuestionType(QuestionType questionType) {
        this.questionType = questionType;
    }

    public PracticeType getPracticeType() {
        return practiceType;
    }

    public void setPracticeType(PracticeType practiceType) {
        this.practiceType = practiceType;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }
}