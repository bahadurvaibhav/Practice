package bahadur.vaibhav.practice.database;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import bahadur.vaibhav.practice.domain.Form;
import bahadur.vaibhav.practice.domain.FormDao;
import bahadur.vaibhav.practice.domain.Question;
import bahadur.vaibhav.practice.domain.QuestionAnswer;
import bahadur.vaibhav.practice.domain.QuestionAnswerDao;
import bahadur.vaibhav.practice.domain.QuestionDao;

@Database(entities = {Form.class, QuestionAnswer.class, Question.class}, version = 1, exportSchema = false)
public abstract class AppDatabase extends RoomDatabase {
    private static AppDatabase INSTANCE;

    public abstract QuestionAnswerDao questionAnswerDao();

    public abstract QuestionDao questionDao();

    public abstract FormDao formDao();

    public static AppDatabase getDatabase(Context context) {
        if (INSTANCE == null) {
            INSTANCE = Room
                    .databaseBuilder(context, AppDatabase.class, "practice")
                    .allowMainThreadQueries()
                    .fallbackToDestructiveMigration()
                    .build();
        }
        return INSTANCE;
    }

    public static void destroyInstance() {
        INSTANCE = null;
    }
}
