package vaibhav.bahadur.practice;

import android.content.Context;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;

import vaibhav.bahadur.practice.database.AppDatabase;
import vaibhav.bahadur.practice.domain.PracticeType;
import vaibhav.bahadur.practice.domain.question.Question;
import vaibhav.bahadur.practice.domain.question.QuestionDao;
import vaibhav.bahadur.practice.domain.question.QuestionType;
import vaibhav.bahadur.practice.util.Util;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    final Context context = this;
    private AppDatabase database;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        setupDatabase();
        setupNavigationView();
    }

    private void setupDatabase() {
        database = AppDatabase.getDatabase(getApplicationContext());
        QuestionDao questionDao = database.questionDao();
        boolean isEmpty = questionDao.getAll().size() == 0;
        if (isEmpty) {
            questionDao.add(new Question("Write a joke", QuestionType.TEXT, PracticeType.JOKES));
            questionDao.add(new Question("Write something new you are grateful for in the last 24 hours", QuestionType.TEXT, PracticeType.GRATITUDE));
            questionDao.add(new Question("Why is it important?", QuestionType.TEXT, PracticeType.GRATITUDE));
        }
    }

    private void setupNavigationView() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.addDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.nav_history) {
            Util.displayAlert("History touched", context, MainActivity.this);
        }
        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    @Override
    protected void onDestroy() {
        AppDatabase.destroyInstance();
        super.onDestroy();
    }
}
