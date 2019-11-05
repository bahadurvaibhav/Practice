package bahadur.vaibhav.practice.activity;

import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;
import bahadur.vaibhav.practice.R;
import bahadur.vaibhav.practice.activity.fragment.GratitudeFragment;
import bahadur.vaibhav.practice.activity.fragment.JokeFragment;
import bahadur.vaibhav.practice.databinding.ActivityPracticeSkillBinding;

import static bahadur.vaibhav.practice.util.Constants.INTENT_EXTRA_SKILL;
import static bahadur.vaibhav.practice.util.Constants.SKILL_TYPE_GRATITUDE;
import static bahadur.vaibhav.practice.util.Constants.SKILL_TYPE_JOKE;

public class PracticeSkillActivity extends BaseActivity {

    ActivityPracticeSkillBinding binding;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = DataBindingUtil.setContentView(this, R.layout.activity_practice_skill);
        binding.setActivity(this);

        if (getIntent() != null) {
            if (getIntent().hasExtra(INTENT_EXTRA_SKILL)) {
                String skill = getIntent().getStringExtra(INTENT_EXTRA_SKILL);
                switch (skill) {
                    case SKILL_TYPE_JOKE:
                        binding.mToolbar.title.setText(SKILL_TYPE_JOKE);
                        replaceFragment(R.id.fragment, new JokeFragment());
                        break;
                    case SKILL_TYPE_GRATITUDE:
                        binding.mToolbar.title.setText(SKILL_TYPE_GRATITUDE);
                        replaceFragment(R.id.fragment, new GratitudeFragment());
                        break;
                }
            }
        }
    }
}
