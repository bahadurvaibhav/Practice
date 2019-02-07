package vaibhav.bahadur.practice.domain.question;

import android.arch.persistence.room.ColumnInfo;
import android.arch.persistence.room.Entity;
import android.arch.persistence.room.PrimaryKey;
import android.arch.persistence.room.TypeConverters;

import vaibhav.bahadur.practice.domain.PracticeType;

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

    public Question(String description, QuestionType questionType, PracticeType practiceType) {
        this.description = description;
        this.questionType = questionType;
        this.practiceType = practiceType;
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
}