package org.ligulfzhou.dingcan.ui.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpResponseHandler;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.ligulfzhou.dingcan.AppContext;
import org.ligulfzhou.dingcan.R;
import org.ligulfzhou.dingcan.adapter.StatisticAdapter;
import org.ligulfzhou.dingcan.api.Api;
import org.ligulfzhou.dingcan.bean.Statistic;
import org.ligulfzhou.dingcan.ui.LoginActivity;

import java.util.ArrayList;
//import cz.msebera.android.httpclient.Header;
import org.apache.http.Header;

public class StatisticFragment extends Fragment {

    ListView listview;
    TextView tv_total;
    ArrayList<Statistic> statistics;
    StatisticAdapter adapter;
    Button btn_logout, btn_refresh, btn_lastmonth;
    int current = 0;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_statistic, container, false);

        tv_total = (TextView) view.findViewById(R.id.tv_total);
        listview = (ListView) view.findViewById(R.id.listview_statistic);
        btn_logout = (Button) view.findViewById(R.id.btn_logout);
        btn_logout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppContext.getInstance().logout();
                Intent intent = new Intent(getActivity().getBaseContext(), LoginActivity.class);
                startActivity(intent);
                getActivity().finish();
            }
        });
        btn_refresh = (Button) view.findViewById(R.id.btn_refresh);
        btn_refresh.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                refresh(current);
            }
        });
        btn_lastmonth = (Button) view.findViewById(R.id.btn_lastmonth);
        btn_lastmonth.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(current == 0){
                    btn_lastmonth.setText("本月");
                    current = 1;
                }else{
                    btn_lastmonth.setText("上个月");
                    current = 0;
                }
                refresh(current);
            }
        });
        statistics = new ArrayList<Statistic>();
        Api.getStatistics(0, new AsyncHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                String res = new String(responseBody);

                JSONObject jsonObject;
                JSONArray jsonArray;

                try {
                    jsonObject = new JSONObject(res);
                    jsonArray = jsonObject.getJSONArray("statistics");
                    tv_total.setText(String.valueOf(jsonObject.getInt("total")));

                    Toast.makeText(getContext(), jsonArray.toString(), Toast.LENGTH_LONG).show();
                    JSONObject jsontmp;
                    for (int i = 0; i < jsonArray.length(); i++) {
                        jsontmp = jsonArray.getJSONObject(i);
                        statistics.add(new Statistic(jsontmp.getString("month") + "-" + jsontmp.getString("day"), jsontmp.getInt("money")));
                    }

                    adapter = new StatisticAdapter(getActivity().getBaseContext(), R.id.listview_statistic, statistics);
                    listview.setAdapter(adapter);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {

            }
        });
        return view;
    }

    private void refresh(int flag){
        statistics = new ArrayList<Statistic>();
        Api.getStatistics(flag, new AsyncHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                String res = new String(responseBody);

                JSONObject jsonObject;
                JSONArray jsonArray;

                try {
                    jsonObject = new JSONObject(res);
                    jsonArray = jsonObject.getJSONArray("statistics");
                    tv_total.setText(String.valueOf(jsonObject.getInt("total")));

//                    Toast.makeText(getContext(), jsonArray.toString(), Toast.LENGTH_LONG).show();
                    JSONObject jsontmp;
                    for (int i = 0; i < jsonArray.length(); i++) {
                        jsontmp = jsonArray.getJSONObject(i);
                        statistics.add(new Statistic(jsontmp.getString("month") + "-" + jsontmp.getString("day"), jsontmp.getInt("money")));
                    }

                    adapter = new StatisticAdapter(getActivity().getBaseContext(), R.id.listview_statistic, statistics);
                    listview.setAdapter(adapter);
//                    adapter.clear();
//                    adapter.addAll(statistics);
//                    adapter.notifyDataSetChanged();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {

            }
        });
    }
}
