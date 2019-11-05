package bahadur.vaibhav.practice;

import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ListView;

import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.List;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import bahadur.vaibhav.practice.activity.adapter.HistoryItem;
import bahadur.vaibhav.practice.activity.adapter.ListViewAdapter;
import bahadur.vaibhav.practice.activity.dialog.SelectSkillDialog;
import bahadur.vaibhav.practice.database.AppDatabase;
import bahadur.vaibhav.practice.domain.Form;
import bahadur.vaibhav.practice.domain.PracticeType;
import bahadur.vaibhav.practice.domain.Question;
import bahadur.vaibhav.practice.domain.dao.QuestionDao;
import bahadur.vaibhav.practice.domain.QuestionType;

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
            questionDao.add(new Question("Write a joke", QuestionType.TEXT, PracticeType.JOKE, 1));
            questionDao.add(new Question("Why is this funny?", QuestionType.TEXT, PracticeType.JOKE, 2));

            questionDao.add(new Question("Write something new you are grateful for in the last 24 hours", QuestionType.TEXT, PracticeType.GRATITUDE, 2));
            questionDao.add(new Question("Why is it important?", QuestionType.TEXT, PracticeType.GRATITUDE, 3));
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
        refreshHistoryView();
    }

    private void refreshHistoryView() {
        listViewAdapter.clear();
        // Populate the list, through the adapter
        List<Form> forms = database.formDao().getAll();
        Log.i(LOG_INFORMATION, "No. of forms filled: " + forms.size());
        for (Form form : forms) {
            HistoryItem entry = new HistoryItem(form.getPracticeType(), form.getCreatedDate());
            listViewAdapter.add(entry);
        }
    }

    private void setupToolbar() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
    }
}
