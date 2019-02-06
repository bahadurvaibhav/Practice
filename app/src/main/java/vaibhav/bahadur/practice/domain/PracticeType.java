package vaibhav.bahadur.practice.domain;

public enum PracticeType {
    GRATITUDE("Gratitude"), JOKES("Jokes");

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
        for (int i=0; i<length; i++) {
            names[i] = values[i].name();
        }
        return names;
    }

    public static final String[] getAllDisplayNames() {
        String[] displayNames;
        PracticeType[] values = PracticeType.values();
        int length = values.length;
        displayNames = new String[length];
        for (int i=0; i<length; i++) {
            displayNames[i] = values[i].getDisplayName();
        }
        return displayNames;
    }
}
