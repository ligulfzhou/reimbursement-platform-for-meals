package org.ligulfzhou.dingcan.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import org.ligulfzhou.dingcan.R;
import org.ligulfzhou.dingcan.bean.Statistic;

import java.util.List;


/**
 * Created by ligulfzhou on 1/3/16.
 */
public class StatisticAdapter extends ArrayAdapter<Statistic> {

    Context _context;
    List <Statistic> data;
    LayoutInflater inflater;
    public StatisticAdapter(Context context, int resource, List<Statistic> objects) {
        super(context, resource, objects);
        _context = context;
        data = objects;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Statistic statistic = getItem(position);

        View view = convertView;
        if (view == null) {
            LayoutInflater inflater = LayoutInflater.from(getContext());
            view = inflater.inflate(R.layout.listitem_statistic, parent, false);
        }
        TextView tvDate = (TextView) view.findViewById(R.id.tv_date);
        TextView tvMoney = (TextView) view.findViewById(R.id.tv_money);
        tvDate.setText(statistic.getDate());
        tvMoney.setText(String.valueOf(statistic.getMoney()));
        return view;
    }
}
