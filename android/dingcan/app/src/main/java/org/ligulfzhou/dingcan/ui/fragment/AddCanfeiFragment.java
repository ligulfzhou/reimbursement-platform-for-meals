package org.ligulfzhou.dingcan.ui.fragment;

import android.app.DatePickerDialog;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.InputType;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpResponseHandler;

import org.ligulfzhou.dingcan.R;
import org.ligulfzhou.dingcan.api.Api;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

//import cz.msebera.android.httpclient.Header;
import org.apache.http.Header;

public class AddCanfeiFragment extends Fragment {

    EditText et_date, et_money;
    Button btn_submit;
    DatePickerDialog datePickerDialog;
    Calendar calendar;
    SimpleDateFormat dateFormat;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_add_canfei, container, false);

        et_date = (EditText) view.findViewById(R.id.et_date);
        et_date.requestFocus();
        et_date.setInputType(InputType.TYPE_NULL);
        et_date.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                datePickerDialog.show();
            }
        });
        calendar = Calendar.getInstance();
        et_money = (EditText) view.findViewById(R.id.et_money);
        btn_submit = (Button) view.findViewById(R.id.btn_submit);
        btn_submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                check_submit();
            }
        });
        calendar = Calendar.getInstance();
        dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.US);


        datePickerDialog = new DatePickerDialog(getActivity(), new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                Calendar newDate = Calendar.getInstance();
                newDate.set(year, monthOfYear, dayOfMonth);
                et_date.setText(dateFormat.format(newDate.getTime()));
            }
        }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));

        return view;
    }

    private void check_submit(){
        String date = et_date.getText().toString();
        int money = Integer.parseInt(et_money.getText().toString());
        if(date != null && !date.equals("") && money != 0){
            Api.postCanfei(date, money, new AsyncHttpResponseHandler() {
                @Override
                public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                    String res = new String(responseBody);

                    Toast.makeText(getActivity().getBaseContext(), res, Toast.LENGTH_LONG).show();
                }

                @Override
                public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {

                }
            });
        }else{
            Toast.makeText(getActivity().getBaseContext(), "请先选择时间/填写金额", Toast.LENGTH_LONG).show();
        }
    }
}
