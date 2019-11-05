package bahadur.vaibhav.practice.domain;

import java.util.Date;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;
import androidx.room.TypeConverters;

@Entity(tableName = "form")
public class Form {

    @PrimaryKey(autoGenerate = true)
    private int id;

    @ColumnInfo(name = "created_at")
    @TypeConverters({TimestampConverter.class})
    private Date createdDate;

    public Form() {
        this.createdDate = new Date();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}
