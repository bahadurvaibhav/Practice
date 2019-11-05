package bahadur.vaibhav.practice.domain;

import java.util.Date;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;
import androidx.room.TypeConverters;
import bahadur.vaibhav.practice.domain.converter.TimestampConverter;

@Entity(tableName = "form")
public class Form {

    @PrimaryKey(autoGenerate = true)
    private int id;

    @TypeConverters(PracticeType.class)
    @ColumnInfo(name = "practice_type")
    private PracticeType practiceType;

    @ColumnInfo(name = "created_at")
    @TypeConverters({TimestampConverter.class})
    private Date createdDate;

    public Form(PracticeType practiceType) {
        this.practiceType = practiceType;
        this.createdDate = new Date();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public PracticeType getPracticeType() {
        return practiceType;
    }

    public void setPracticeType(PracticeType practiceType) {
        this.practiceType = practiceType;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}
