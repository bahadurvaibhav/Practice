package bahadur.vaibhav.practice.activity.adapter;

import java.util.Date;

import bahadur.vaibhav.practice.domain.PracticeType;

public class HistoryItem {

    private int formId;
    private PracticeType practiceType;
    private Date currentDate;

    public HistoryItem(int formId, PracticeType practiceType, Date currentDate) {
        this.formId = formId;
        this.practiceType = practiceType;
        this.currentDate = currentDate;
    }

    public int getFormId() {
        return formId;
    }

    public void setFormId(int formId) {
        this.formId = formId;
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
