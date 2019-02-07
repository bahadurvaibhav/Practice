package vaibhav.bahadur.practice.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import vaibhav.bahadur.practice.R;
import vaibhav.bahadur.practice.database.AppDatabase;
import vaibhav.bahadur.practice.domain.PracticeType;
import vaibhav.bahadur.practice.domain.question.Question;
import vaibhav.bahadur.practice.domain.question.QuestionAnswer;
import vaibhav.bahadur.practice.domain.question.QuestionType;

import static vaibhav.bahadur.practice.util.Util.convertToPixels;

public class PracticeActivity extends AppCompatActivity {

    private PracticeType practiceType;
    private List<Question> question;
    private View view;
    private List<EditText> answerViews = new ArrayList<>();
    private AppDatabase database;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LayoutInflater vi = (LayoutInflater) getApplicationContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        this.view = vi.inflate(R.layout.activity_practice, null);
        this.database = AppDatabase.getDatabase(this);
        setContentView(R.layout.activity_practice);
        setupQuestions();
    }

    private void setupQuestions() {
        init();
        boolean questionsExist = this.question != null && this.question.size() > 0;
        Log.d("myTag", "No. of Questions: " + (questionsExist ? this.question.size() : 0));
        if (questionsExist) {
            for (int i = 0; i < this.question.size(); i++) {
                Question question = this.question.get(i);
                populateQuestion(question, i);
            }
        }
    }

    private void init() {
        Intent intent = getIntent();
        this.practiceType = PracticeType.valueOf(intent.getStringExtra("practiceType"));
        Log.d("myTag", "In Practice Activity with type " + this.practiceType.name());
        this.question = database.questionDao().get(this.practiceType.name());
    }

    private void populateQuestion(Question question, int index) {
        if (QuestionType.TEXT.equals(question.getQuestionType())) {
            populateTextQuestion(question, index);
        }
    }

    private void populateTextQuestion(Question question, int index) {
        LinearLayout linearLayout = this.findViewById(R.id.questionnaire);

        TextView textView = new TextView(PracticeActivity.this);
        LinearLayout.LayoutParams textViewLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        textViewLayoutParams.setMargins(convertToPixels(22, getResources()), convertToPixels(20, getResources()), 0, 0);
        textView.setLayoutParams(textViewLayoutParams);
        textView.setText(question.getDescription());
        textView.setId(index);
        linearLayout.addView(textView, 2 * index);

        EditText editText = new EditText(PracticeActivity.this);
        LinearLayout.LayoutParams editTextLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        editTextLayoutParams.setMargins(convertToPixels(20, getResources()), convertToPixels(10, getResources()), 0, 0);
        editText.setLayoutParams(editTextLayoutParams);
        editText.setEms(15);
        editText.setId(index);
        linearLayout.addView(editText, (2 * index) + 1);
        answerViews.add(editText);
    }

    public void submit(View view) {
        for (int i = 0; i < answerViews.size(); i++) {
            EditText answerView = answerViews.get(i);
            int index = answerView.getId();
            QuestionAnswer questionAnswer = new QuestionAnswer(this.question.get(index).getId(), answerView.getText().toString());
            this.database.questionAnswerDao().add(questionAnswer);
        }
        Log.d("myTag", "Submitted successfully");
    }
}
