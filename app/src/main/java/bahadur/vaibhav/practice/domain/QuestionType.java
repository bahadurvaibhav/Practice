package bahadur.vaibhav.practice.domain;

import androidx.room.TypeConverter;

public enum QuestionType {
    ANSWER_TEXT, RATING, TEXT, EXPANDABLE_ANSWER_TEXT;

    @TypeConverter
    public static QuestionType toType(String type) {
        return QuestionType.valueOf(type);
    }

    @TypeConverter
    public static String toString(QuestionType type) {
        return type.name();
    }
}
