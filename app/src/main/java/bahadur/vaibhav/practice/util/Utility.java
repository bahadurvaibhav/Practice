package bahadur.vaibhav.practice.util;

import android.content.res.Resources;
import android.util.TypedValue;
import android.view.View;

import com.google.android.material.snackbar.Snackbar;

public class Utility {

    public void showSnackbarMessage(View view, String message) {
        Snackbar.make(view, message, Snackbar.LENGTH_LONG)
                .setAction("Action", null).show();
    }

    public static int convertToPixels(int dp, Resources resources) {
        return Math.round(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, resources.getDisplayMetrics()));
    }
}
