package bahadur.vaibhav.practice.domain.dao;

import java.util.List;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import bahadur.vaibhav.practice.domain.QuestionAnswer;

@Dao
public interface QuestionAnswerDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void add(QuestionAnswer questionAnswer);

    @Query("SELECT * FROM question_answer")
    List<QuestionAnswer> getAll();

    @Query("select * from question_answer where id = :questionAnswerId")
    List<QuestionAnswer> get(int questionAnswerId);

    @Query("select * from question_answer where form_id = :formId")
    List<QuestionAnswer> getForFormId(int formId);

    @Query("delete from question_answer")
    void removeAll();
}
