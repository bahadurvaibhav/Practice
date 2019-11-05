package bahadur.vaibhav.practice.activity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RatingBar;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;
import bahadur.vaibhav.practice.R;
import bahadur.vaibhav.practice.database.AppDatabase;
import bahadur.vaibhav.practice.databinding.ActivityPracticeSkillBinding;
import bahadur.vaibhav.practice.domain.Form;
import bahadur.vaibhav.practice.domain.PracticeType;
import bahadur.vaibhav.practice.domain.Question;
import bahadur.vaibhav.practice.domain.QuestionAnswer;
import bahadur.vaibhav.practice.domain.QuestionType;

import static bahadur.vaibhav.practice.util.Constants.INTENT_EXTRA_FORM_ID;
import static bahadur.vaibhav.practice.util.Constants.INTENT_EXTRA_SKILL;
import static bahadur.vaibhav.practice.util.Constants.LOG_INFORMATION;
import static bahadur.vaibhav.practice.util.Utility.convertToPixels;

public class PracticeSkillActivity extends BaseActivity {

    ActivityPracticeSkillBinding binding;
    private PracticeType practiceType;
    private List<Question> question;
    private AppDatabase database;
    private List<EditText> editTextViews = new ArrayList<>();
    private List<RatingBar> ratingBarViews = new ArrayList<>();
    private int lastIndex = 0;
    private int formId;
    Map<Integer, QuestionAnswer> questionIdToQuestionAnswerMap = new HashMap<>();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.database = AppDatabase.getDatabase(this);
        binding = DataBindingUtil.setContentView(this, R.layout.activity_practice_skill);
        binding.setActivity(this);

        setupQuestionnaire();
    }

    private void setupQuestionnaire() {
        if (getIntent() != null) {
            if (getIntent().hasExtra(INTENT_EXTRA_FORM_ID)) {
                formId = getIntent().getIntExtra(INTENT_EXTRA_FORM_ID, 0);
                List<QuestionAnswer> questionAnswers = database.questionAnswerDao().getForFormId(formId);
                for (QuestionAnswer questionAnswer : questionAnswers) {
                    questionIdToQuestionAnswerMap.put(questionAnswer.getQuestionId(), questionAnswer);
                }
                binding.submitButton.setText(getResources().getString(R.string.update));
            }
            if (getIntent().hasExtra(INTENT_EXTRA_SKILL)) {
                initQuestions();
                boolean questionsExist = this.question != null && this.question.size() > 0;
                Log.i(LOG_INFORMATION, "No. of Questions: " + (questionsExist ? this.question.size() : 0));
                if (questionsExist) {
                    for (int i = 0; i < this.question.size(); i++) {
                        Question question = this.question.get(i);
                        populateQuestion(question, question.getId());
                    }
                }
            }
        }
    }

    private void initQuestions() {
        String skill = getIntent().getStringExtra(INTENT_EXTRA_SKILL);
        Log.i(LOG_INFORMATION, "Practice Type: " + skill);
        binding.mToolbar.title.setText(skill);
        this.practiceType = PracticeType.toTypeFromDisplayName(skill);
        this.question = database.questionDao().get(this.practiceType.name());
    }

    private void populateQuestion(Question question, int index) {
        if (QuestionType.ANSWER_TEXT.equals(question.getQuestionType())) {
            populateAnswerTextQuestion(question, index);
        }
        if (QuestionType.RATING.equals(question.getQuestionType())) {
            populateRatingQuestion(question, index);
        }
        if (QuestionType.TEXT.equals(question.getQuestionType())) {
            populateTextQuestion(question, index);
        }
        if (QuestionType.EXPANDABLE_ANSWER_TEXT.equals(question.getQuestionType())) {
            populateExpandableAnswerTextQuestion(question, index);
        }
    }

    private void populateExpandableAnswerTextQuestion(Question question, int index) {
        LinearLayout linearLayout = this.findViewById(R.id.questionnaire);

        TextView textView = getTextView(question, index);
        linearLayout.addView(textView, lastIndex);
        lastIndex++;

        EditText editText = getEditText(index);
        editText.setMinLines(3);
        linearLayout.addView(editText, lastIndex);
        editTextViews.add(editText);
        lastIndex++;
    }

    private EditText getEditText(int index) {
        EditText editText = new EditText(PracticeSkillActivity.this);
        LinearLayout.LayoutParams editTextLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        editTextLayoutParams.setMargins(convertToPixels(20, getResources()), convertToPixels(10, getResources()), 0, 0);
        editText.setLayoutParams(editTextLayoutParams);
        editText.setEms(15);
        editText.setId(index);
        QuestionAnswer questionAnswer = questionIdToQuestionAnswerMap.get(index);
        if (questionAnswer != null) {
            String answerText = questionAnswer.getAnswerText();
            Log.i(LOG_INFORMATION, "Answer to question " + index + " is: " + answerText);
            editText.setText(answerText, TextView.BufferType.EDITABLE);
        }
        return editText;
    }

    private void populateTextQuestion(Question question, int index) {
        LinearLayout linearLayout = this.findViewById(R.id.questionnaire);
        TextView textView = getTextView(question, index);
        linearLayout.addView(textView, lastIndex);
        lastIndex++;
    }

    private void populateRatingQuestion(Question question, int index) {
        LinearLayout linearLayout = this.findViewById(R.id.questionnaire);

        TextView textView = getTextView(question, index);
        linearLayout.addView(textView, lastIndex);
        lastIndex++;

        RatingBar ratingBar = new RatingBar(PracticeSkillActivity.this);
        LinearLayout.LayoutParams editTextLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        editTextLayoutParams.setMargins(convertToPixels(20, getResources()), convertToPixels(10, getResources()), 0, 0);
        ratingBar.setLayoutParams(editTextLayoutParams);
        ratingBar.setId(index);
        QuestionAnswer questionAnswer = questionIdToQuestionAnswerMap.get(index);
        if (questionAnswer != null) {
            String answerText = questionAnswer.getAnswerText();
            Log.i(LOG_INFORMATION, "Answer to question " + index + " is: " + answerText);
            ratingBar.setRating(Float.parseFloat(answerText));
        }
        linearLayout.addView(ratingBar, lastIndex);
        ratingBarViews.add(ratingBar);
        lastIndex++;
    }

    private TextView getTextView(Question question, int index) {
        TextView textView = new TextView(PracticeSkillActivity.this);
        LinearLayout.LayoutParams textViewLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        textViewLayoutParams.setMargins(convertToPixels(22, getResources()), convertToPixels(20, getResources()), 0, 0);
        textView.setLayoutParams(textViewLayoutParams);
        textView.setText(question.getDescription());
        textView.setId(index);
        return textView;
    }

    private void populateAnswerTextQuestion(Question question, int index) {
        LinearLayout linearLayout = this.findViewById(R.id.questionnaire);

        TextView textView = getTextView(question, index);
        linearLayout.addView(textView, lastIndex);
        lastIndex++;

        EditText editText = getEditText(index);
        linearLayout.addView(editText, lastIndex);
        editTextViews.add(editText);
        lastIndex++;
    }

    public void submit(View view) {
        int insertIdInt = createForm();
        submitEditTextAnswers(insertIdInt);
        submitRatingBarAnswers(insertIdInt);
        Log.i(LOG_INFORMATION, "Form submitted successfully with id: " + insertIdInt);
        finish();
    }

    private int createForm() {
        long insertId = this.database.formDao().add(new Form(this.practiceType));
        return (int) insertId;
    }

    private void submitRatingBarAnswers(int insertIdInt) {
        for (RatingBar ratingBar : ratingBarViews) {
            int index = ratingBar.getId();
            float rating = ratingBar.getRating();
            Log.i(LOG_INFORMATION, "Question " + index + " with rating: " + rating);
            Question question = this.question.get(index);
            QuestionAnswer questionAnswer = new QuestionAnswer(insertIdInt, question.getId(), String.valueOf(rating));
            this.database.questionAnswerDao().add(questionAnswer);
        }
    }

    private void submitEditTextAnswers(int insertIdInt) {
        for (EditText answerView : editTextViews) {
            int index = answerView.getId();
            String answerText = answerView.getText().toString();
            Log.i(LOG_INFORMATION, "Question " + index + " with answer text: " + answerText);
            Question question = this.question.get(index);
            QuestionAnswer questionAnswer = new QuestionAnswer(insertIdInt, question.getId(), answerText);
            this.database.questionAnswerDao().add(questionAnswer);
        }
    }
}
