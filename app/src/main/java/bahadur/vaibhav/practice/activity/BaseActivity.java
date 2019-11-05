package bahadur.vaibhav.practice.activity;

import android.os.Bundle;

import androidx.annotation.IdRes;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;

public class BaseActivity extends AppCompatActivity {

    public void replaceFragment(@IdRes int container, Fragment fragment) {
        replaceFragment(container, fragment, null);
    }

    public void replaceFragment(@IdRes int container,
                                Fragment fragment, Bundle arguments) {
        if (arguments != null) {
            fragment.setArguments(arguments);
        }
        getSupportFragmentManager().beginTransaction().replace(container, fragment).commit();
    }
}
