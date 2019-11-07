package bahadur.vaibhav.practice;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.List;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import bahadur.vaibhav.practice.activity.PracticeSkillActivity;
import bahadur.vaibhav.practice.activity.adapter.HistoryItem;
import bahadur.vaibhav.practice.activity.adapter.ListViewAdapter;
import bahadur.vaibhav.practice.activity.dialog.SelectSkillDialog;
import bahadur.vaibhav.practice.database.AppDatabase;
import bahadur.vaibhav.practice.domain.Form;
import bahadur.vaibhav.practice.domain.PracticeType;
import bahadur.vaibhav.practice.domain.Question;
import bahadur.vaibhav.practice.domain.QuestionType;
import bahadur.vaibhav.practice.domain.dao.QuestionDao;

import static bahadur.vaibhav.practice.util.Constants.INTENT_EXTRA_FORM_ID;
import static bahadur.vaibhav.practice.util.Constants.INTENT_EXTRA_SKILL;
import static bahadur.vaibhav.practice.util.Constants.LOG_INFORMATION;

public class MainActivity extends AppCompatActivity {

    private AppDatabase database;
    ListViewAdapter listViewAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        setupDatabase();
        setupToolbar();
        setupHistoryView();
        setupStartSessionButton();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onResume() {
        super.onResume();
        refreshHistoryView();
    }

    private void setupDatabase() {
        database = AppDatabase.getDatabase(getApplicationContext());
        QuestionDao questionDao = database.questionDao();
        int size = questionDao.getAll().size();
        Log.i(LOG_INFORMATION, "Database questions size: " + size);
        if (size == 0) {
            questionDao.add(new Question("Write a joke", QuestionType.EXPANDABLE_ANSWER_TEXT, PracticeType.JOKE, 1));
            questionDao.add(new Question("Rate this", QuestionType.RATING, PracticeType.JOKE, 3));
            questionDao.add(new Question("Why is this funny?", QuestionType.EXPANDABLE_ANSWER_TEXT, PracticeType.JOKE, 2));

            questionDao.add(new Question("Write something new you are grateful for in the last 24 hours", QuestionType.EXPANDABLE_ANSWER_TEXT, PracticeType.GRATITUDE, 1));
            questionDao.add(new Question("Why is it important?", QuestionType.EXPANDABLE_ANSWER_TEXT, PracticeType.GRATITUDE, 2));

            questionDao.add(new Question("Pick any random object, thing, person from the surrounding", QuestionType.ANSWER_TEXT, PracticeType.STORY_OBJECT, 1));
            questionDao.add(new Question("Write a story based on above selection", QuestionType.EXPANDABLE_ANSWER_TEXT, PracticeType.STORY_OBJECT, 2));
            questionDao.add(new Question("Rate this", QuestionType.RATING, PracticeType.STORY_OBJECT, 3));
            questionDao.add(new Question("Critique / Feedback / Improvements", QuestionType.EXPANDABLE_ANSWER_TEXT, PracticeType.STORY_OBJECT, 4));

            questionDao.add(new Question("DHV Spikes: \n 1. Being a leader of men \n 2. Being the protector of loved ones \n 3. Being pre-selected by other women \n 4. Having a willingness to emote \n 5. Being a successful risk taker \n 6. Willingness to walk away", QuestionType.TEXT, PracticeType.STORY_DHV, 1));
            questionDao.add(new Question("Write a story demonstrating high value", QuestionType.EXPANDABLE_ANSWER_TEXT, PracticeType.STORY_DHV, 2));
            questionDao.add(new Question("Rate this", QuestionType.RATING, PracticeType.STORY_DHV, 3));
            questionDao.add(new Question("Critique / Feedback / Improvements", QuestionType.EXPANDABLE_ANSWER_TEXT, PracticeType.STORY_DHV, 4));

            // TODO: Summarize a book you read, or some topic, article that you read or a speech you heard (in your own words). Could be used for subjects your are studying. writing what it means to you helps you remember and also notice what you understand and missed out on.
            // Cornell Note Taking System: Topic, Notes, Keywords/Questions, Summary

            // TODO: Record 10 jokes or funny things from today that you read somewhere or noticed someone say

            // TODO: Blessings, Forgive, CBT, What Went Well?, Self-Awareness Techniques (Why?, etc.), Face Reading, Palm Reading
        }
    }


    private void setupStartSessionButton() {
        FloatingActionButton fab = findViewById(R.id.startSession);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SelectSkillDialog dialog = new SelectSkillDialog();
                dialog.show(getSupportFragmentManager(), "SelectSkillDialog");
            }
        });
    }

    private void setupHistoryView() {
        // Setup the list view
        final ListView newsEntryListView = (ListView) findViewById(R.id.history_list);
        listViewAdapter = new ListViewAdapter(this, R.layout.history_item);
        newsEntryListView.setAdapter(listViewAdapter);
        newsEntryListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(MainActivity.this, PracticeSkillActivity.class);
                HistoryItem item = listViewAdapter.getItem(position);
                intent.putExtra(INTENT_EXTRA_FORM_ID, item.getFormId());
                intent.putExtra(INTENT_EXTRA_SKILL, item.getPracticeType().getDisplayName());
                Log.i(LOG_INFORMATION, "Starting EditAnswersActivity with Form id: " + item.getFormId());
                startActivity(intent);
            }
        });
        refreshHistoryView();
    }

    private void refreshHistoryView() {
        listViewAdapter.clear();
        // Populate the list, through the adapter
        List<Form> forms = database.formDao().getAll();
        Log.i(LOG_INFORMATION, "No. of forms filled: " + forms.size());
        for (Form form : forms) {
            HistoryItem entry = new HistoryItem(form.getId(), form.getPracticeType(), form.getCreatedDate());
            listViewAdapter.add(entry);
        }
    }

    private void setupToolbar() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
    }
}
