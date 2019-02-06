package vaibhav.bahadur.practice.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import vaibhav.bahadur.practice.R;
import vaibhav.bahadur.practice.domain.PracticeType;

public class MainListFragment extends ListFragment {
    private Activity activity;
    private ListAdapter listAdapter;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.list_fragment, container, false);
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof Activity){
            this.activity = (Activity) context;
        }
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        setupListView();
    }

    private void setupListView() {
        listAdapter = new ListAdapter(PracticeType.values());
        setListAdapter(listAdapter);
        setupSelector();
    }

    private void setupSelector() {
        getListView().setSelector(R.drawable.list_selector);
        getListView().setDrawSelectorOnTop(false);
        getListView().invalidateViews();
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);
        PracticeType type = listAdapter.getType(position);
        Log.d("myTag", "Selected " + type.name());
        Intent myIntent = new Intent(activity.getBaseContext(), PracticeActivity.class);
        myIntent.putExtra("practiceType", type.name());
        startActivity(myIntent);
    }

    private class ListAdapter extends BaseAdapter {

        private PracticeType[] data;

        public ListAdapter(PracticeType[] data) {
            this.data = data;
        }

        @Override
        public int getCount() {
            return data.length;
        }

        @Override
        public String getItem(int position) {
            return getType(position).getDisplayName();
        }

        public PracticeType getType(int position) {
            return data[position];
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            TextView result;
            if (convertView == null) {
                result = (TextView) getLayoutInflater().inflate(R.layout.text_item, parent, false);
                result.setTextColor(Color.BLACK);
            } else {
                result = (TextView) convertView;
            }
            final String cheese = getItem(position);
            result.setText(cheese);
            result.setBackgroundResource(R.drawable.list_item_selector_normal);
            return result;
        }
    }
}
