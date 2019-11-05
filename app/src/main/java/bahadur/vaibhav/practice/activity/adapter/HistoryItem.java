package bahadur.vaibhav.practice.activity.adapter;

import java.util.Date;

import bahadur.vaibhav.practice.domain.PracticeType;

public class HistoryItem {

    private PracticeType practiceType;
    private Date currentDate;

    public HistoryItem(PracticeType practiceType, Date currentDate) {
        this.practiceType = practiceType;
        this.currentDate = currentDate;
    }

    public PracticeType getPracticeType() {
        return practiceType;
    }

    public void setPracticeType(PracticeType practiceType) {
        this.practiceType = practiceType;
    }

    public Date getCurrentDate() {
        return currentDate;
    }

    public void setCurrentDate(Date currentDate) {
        this.currentDate = currentDate;
    }
}
