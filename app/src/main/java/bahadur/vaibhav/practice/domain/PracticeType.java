package bahadur.vaibhav.practice.domain;

import androidx.room.TypeConverter;

import static bahadur.vaibhav.practice.util.Constants.SKILL_TYPE_GRATITUDE;
import static bahadur.vaibhav.practice.util.Constants.SKILL_TYPE_JOKE;

public enum PracticeType {
    GRATITUDE(SKILL_TYPE_GRATITUDE), JOKE(SKILL_TYPE_JOKE);

    private String displayName;

    PracticeType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static final String[] getAllNames() {
        String[] names;
        PracticeType[] values = PracticeType.values();
        int length = values.length;
        names = new String[length];
        for (int i = 0; i < length; i++) {
            names[i] = values[i].name();
        }
        return names;
    }

    public static final String[] getAllDisplayNames() {
        String[] displayNames;
        PracticeType[] values = PracticeType.values();
        int length = values.length;
        displayNames = new String[length];
        for (int i = 0; i < length; i++) {
            displayNames[i] = values[i].getDisplayName();
        }
        return displayNames;
    }

    @TypeConverter
    public static PracticeType toType(String type) {
        return PracticeType.valueOf(type);
    }

    @TypeConverter
    public static String toString(PracticeType type) {
        return type.name();
    }

    public static PracticeType toTypeFromDisplayName(String displayName) {
        PracticeType[] values = PracticeType.values();
        for (int i = 0; i < values.length; i++) {
            PracticeType value = values[i];
            if (value.getDisplayName().equals(displayName)) {
                return value;
            }
        }
        return null;
    }
}