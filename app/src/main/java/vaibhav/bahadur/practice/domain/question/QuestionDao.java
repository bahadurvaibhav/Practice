package vaibhav.bahadur.practice.domain.question;

import android.arch.persistence.room.Dao;
import android.arch.persistence.room.Insert;
import android.arch.persistence.room.OnConflictStrategy;
import android.arch.persistence.room.Query;

import java.util.List;

@Dao
public interface QuestionDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void add(Question question);

    @Query("SELECT * FROM question")
    List<Question> getAll();

    @Query("select * from question where id = :questionId")
    List<Question> get(int questionId);

    @Query("select * from question where practice_type = :practiceType")
    List<Question> get(String practiceType);

    @Query("delete from question")
    void removeAll();
}
