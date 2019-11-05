package bahadur.vaibhav.practice.activity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

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

import static bahadur.vaibhav.practice.util.Constants.INTENT_EXTRA_SKILL;
import static bahadur.vaibhav.practice.util.Constants.LOG_INFORMATION;
import static bahadur.vaibhav.practice.util.Utility.convertToPixels;

public class PracticeSkillActivity extends BaseActivity {

    ActivityPracticeSkillBinding binding;
    private PracticeType practiceType;
    private List<Question> question;
    private AppDatabase database;
    private List<EditText> answerViews = new ArrayList<>();

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
            if (getIntent().hasExtra(INTENT_EXTRA_SKILL)) {
                initQuestions();
                boolean questionsExist = this.question != null && this.question.size() > 0;
                Log.i(LOG_INFORMATION, "No. of Questions: " + (questionsExist ? this.question.size() : 0));
                if (questionsExist) {
                    for (int i = 0; i < this.question.size(); i++) {
                        Question question = this.question.get(i);
                        populateQuestion(question, i);
                    }
                }
            }
        }
    }

    private void initQuestions() {
        String skill = getIntent().getStringExtra(INTENT_EXTRA_SKILL);
        Log.i(LOG_INFORMATION, "Practice Type: " + skill);
        this.practiceType = PracticeType.toTypeFromDisplayName(skill);
        this.question = database.questionDao().get(this.practiceType.name());
    }

    private void populateQuestion(Question question, int index) {
        if (QuestionType.TEXT.equals(question.getQuestionType())) {
            populateTextQuestion(question, index);
        }
    }

    private void populateTextQuestion(Question question, int index) {
        LinearLayout linearLayout = this.findViewById(R.id.questionnaire);

        TextView textView = new TextView(PracticeSkillActivity.this);
        LinearLayout.LayoutParams textViewLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        textViewLayoutParams.setMargins(convertToPixels(22, getResources()), convertToPixels(20, getResources()), 0, 0);
        textView.setLayoutParams(textViewLayoutParams);
        textView.setText(question.getDescription());
        textView.setId(index);
        linearLayout.addView(textView, 2 * index);

        EditText editText = new EditText(PracticeSkillActivity.this);
        LinearLayout.LayoutParams editTextLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        editTextLayoutParams.setMargins(convertToPixels(20, getResources()), convertToPixels(10, getResources()), 0, 0);
        editText.setLayoutParams(editTextLayoutParams);
        editText.setEms(15);
        editText.setId(index);
        linearLayout.addView(editText, (2 * index) + 1);
        answerViews.add(editText);
    }

    public void submit(View view) {
        long insertId = this.database.formDao().add(new Form());
        int insertIdInt = (int) insertId;
        int size = answerViews.size();
        for (int i = 0; i < size; i++) {
            EditText answerView = answerViews.get(i);
            int index = answerView.getId();
            String answerText = answerView.getText().toString();
            Log.i(LOG_INFORMATION, "Question " + i + " with answer value: " + answerText);
            QuestionAnswer questionAnswer = new QuestionAnswer(insertIdInt, this.question.get(index).getId(), answerText);
            this.database.questionAnswerDao().add(questionAnswer);
        }
        Log.i(LOG_INFORMATION, "Form submitted successfully with id: " + insertIdInt);
        finish();
    }
}
