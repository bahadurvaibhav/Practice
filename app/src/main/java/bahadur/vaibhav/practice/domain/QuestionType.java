package bahadur.vaibhav.practice.domain;

import androidx.room.TypeConverter;

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
