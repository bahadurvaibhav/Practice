package bahadur.vaibhav.practice.domain.dao;

import java.util.List;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import bahadur.vaibhav.practice.domain.Question;

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
