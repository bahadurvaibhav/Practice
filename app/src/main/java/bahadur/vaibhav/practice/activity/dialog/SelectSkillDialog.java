package bahadur.vaibhav.practice.activity.dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.DialogFragment;
import bahadur.vaibhav.practice.MainActivity;
import bahadur.vaibhav.practice.R;
import bahadur.vaibhav.practice.activity.PracticeSkillActivity;
import bahadur.vaibhav.practice.databinding.DialogSelectSkillBinding;

import static bahadur.vaibhav.practice.util.Constants.INTENT_EXTRA_SKILL;

public class SelectSkillDialog extends DialogFragment {

    DialogSelectSkillBinding binding;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_FRAME, android.R.style.Theme_Dialog);
    }

    @Override
    public void onStart() {
        super.onStart();
        Dialog dialog = getDialog();
        if (dialog != null) {
            WindowManager manager = (WindowManager) getActivity().getSystemService(Activity.WINDOW_SERVICE);
            int width;
            width = manager.getDefaultDisplay().getWidth();
            getDialog().getWindow().setBackgroundDrawable(null);
            WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
            lp.copyFrom(getDialog().getWindow().getAttributes());
            lp.width = width - 100;
            lp.gravity = Gravity.CENTER;
            lp.dimAmount = 0.6f;
            getDialog().getWindow().setBackgroundDrawableResource(android.R.color.transparent);
            getDialog().getWindow().setAttributes(lp);
        }
    }

    @NonNull
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        binding = DataBindingUtil.inflate(getActivity().getLayoutInflater(), R.layout.dialog_select_skill, null, false);
        binding.setDialog(this);
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setView(binding.getRoot());
        return builder.create();
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setView(binding.getRoot());
    }

    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.start_button:
                String selectedSkill = binding.spSkill.getSelectedItem().toString();
                Intent intent = new Intent(getParentActivity(), PracticeSkillActivity.class);
                intent.putExtra(INTENT_EXTRA_SKILL, selectedSkill);
                startActivity(intent);
                dismiss();
                break;
            case R.id.close:
                dismiss();
                break;
        }
    }

    public MainActivity getParentActivity() {
        if (getActivity() instanceof MainActivity)
            return (MainActivity) getActivity();
        else
            return null;
    }
}
