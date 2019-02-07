package vaibhav.bahadur.practice.domain.question;

import android.arch.persistence.room.Dao;
import android.arch.persistence.room.Insert;
import android.arch.persistence.room.OnConflictStrategy;
import android.arch.persistence.room.Query;

import java.util.List;

@Dao
public interface QuestionAnswerDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void add(QuestionAnswer questionAnswer);

    @Query("SELECT * FROM question_answer")
    List<QuestionAnswer> getAll();

    @Query("select * from question_answer where id = :questionAnswerId")
    List<QuestionAnswer> get(int questionAnswerId);

    @Query("delete from question_answer")
    void removeAll();
}
