package bahadur.vaibhav.practice.domain.dao;

import java.util.List;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import bahadur.vaibhav.practice.domain.Form;

@Dao
public interface FormDao {

    @Query("SELECT * FROM form ORDER BY created_at desc")
    List<Form> getAll();

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    long add(Form form);

}
