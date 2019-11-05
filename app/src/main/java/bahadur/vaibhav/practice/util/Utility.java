package bahadur.vaibhav.practice.util;

import android.view.View;

import com.google.android.material.snackbar.Snackbar;

public class Utility {

    public void showSnackbarMessage(View view, String message) {
         Snackbar.make(view, message, Snackbar.LENGTH_LONG)
         .setAction("Action", null).show();
    }
}
