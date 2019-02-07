package vaibhav.bahadur.practice.database;

import android.arch.persistence.room.Database;
import android.arch.persistence.room.Room;
import android.arch.persistence.room.RoomDatabase;
import android.content.Context;

import vaibhav.bahadur.practice.domain.question.Question;
import vaibhav.bahadur.practice.domain.question.QuestionAnswer;
import vaibhav.bahadur.practice.domain.question.QuestionAnswerDao;
import vaibhav.bahadur.practice.domain.question.QuestionDao;

@Database(entities = {QuestionAnswer.class, Question.class}, version = 3, exportSchema = false)
public abstract class AppDatabase extends RoomDatabase {
    private static AppDatabase INSTANCE;

    public abstract QuestionAnswerDao questionAnswerDao();

    public abstract QuestionDao questionDao();

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
