package vaibhav.bahadur.practice.domain.question;

import android.arch.persistence.room.TypeConverter;

public enum QuestionType {
    TEXT, RATING;

    @TypeConverter
    public static QuestionType toType(String type) {
        return QuestionType.valueOf(type);
    }

    @TypeConverter
    public static String toString(QuestionType type) {
        return type.name();
    }
}
