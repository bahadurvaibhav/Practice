package vaibhav.bahadur.practice.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import java.io.FileOutputStream;
import java.util.List;

import vaibhav.bahadur.practice.R;
import vaibhav.bahadur.practice.domain.PracticeType;
import vaibhav.bahadur.practice.domain.Question;
import vaibhav.bahadur.practice.domain.QuestionRepository;
import vaibhav.bahadur.practice.util.Util;

public class PracticeActivity extends AppCompatActivity {

    public static final String USER_DATA_FILE_NAME = "data";
    final Context context = this;
    private PracticeType practiceType;
    private List<Question> questions;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_practice);
        setupQuestions();
    }

    private void setupQuestions() {
        Intent intent = getIntent();
        this.practiceType = PracticeType.valueOf(intent.getStringExtra("practiceType"));
        Log.d("myTag", "In Practice Activity with type " + this.practiceType.name());
        this.questions = QuestionRepository.getQuestions(this.practiceType);
    }

    public void submit(View view) {
        int editText1Id = R.id.editText1;
        TextView editText1 = findViewById(editText1Id);
        String editText1Text = editText1.getText().toString();
        addToFile(USER_DATA_FILE_NAME, editText1Text);
        Util.displayAlert(editText1Text, context, PracticeActivity.this);
    }

    private void addToFile(String filename, String content) {
        FileOutputStream outputStream;
        try {
            outputStream = openFileOutput(filename, Context.MODE_PRIVATE);
            outputStream.write(content.getBytes());
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
