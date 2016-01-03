package org.ligulfzhou.dingcan.ui;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpResponseHandler;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.ligulfzhou.dingcan.AppContext;
import org.ligulfzhou.dingcan.R;
import org.ligulfzhou.dingcan.api.Api;

import java.util.ArrayList;
import java.util.HashMap;

import cz.msebera.android.httpclient.Header;

public class LoginActivity extends AppCompatActivity {

    Spinner spinner;
    Button btn_login;
    EditText et_password;
    android.support.v7.app.ActionBar actionBar;
    HashMap<String, String> userList;
    ArrayList<String> spinnerStringArray;
    ArrayAdapter<String> dataAdapter;
    String mobile, username, password;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        actionBar = getSupportActionBar();
        assert actionBar != null;
        actionBar.setTitle("请登录");
        String isLogin = AppContext.getInstance().getToken();
        Toast.makeText(getBaseContext(), "token: " + isLogin, Toast.LENGTH_LONG).show();

        if(isLogin != null && !isLogin.equals("")){
            Intent intent = new Intent(this, MainActivity.class);
            startActivity(intent);
            finish();
        }else {
            et_password = (EditText) findViewById(R.id.et_password);
            spinner = (Spinner) findViewById(R.id.spinner_select_user);
            userList = new HashMap<String, String>();
            spinnerStringArray = new ArrayList<String>();

            Api.getUserList(new AsyncHttpResponseHandler() {
                @Override
                public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                    String str = new String(responseBody);
                    JSONObject jsonObject;
                    JSONArray jsonArray;

                    try {
                        jsonObject = new JSONObject(str);
                        jsonArray = jsonObject.getJSONArray("users");

                        for(int i = 0; i < jsonArray.length(); i++){
                            spinnerStringArray.add(jsonArray.getJSONObject(i).getString("username"));
                            userList.put(jsonArray.getJSONObject(i).getString("username"), jsonArray.getJSONObject(i).getString("mobile"));
                        }

                        dataAdapter = new ArrayAdapter<String>(getBaseContext(), android.R.layout.simple_spinner_item, spinnerStringArray);
                        spinner.setAdapter(dataAdapter);


                        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                            @Override
                            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                                username = (String) parent.getItemAtPosition(position);
                                mobile = userList.get(username);
//                                Toast.makeText(parent.getContext(), username + " : " + mobile, Toast.LENGTH_LONG).show();
                            }

                            @Override
                            public void onNothingSelected(AdapterView<?> parent) {

                            }
                        });
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

//                    Toast.makeText(getApplicationContext(), userList.toString(), Toast.LENGTH_LONG).show();
                }

                @Override
                public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
                    Toast.makeText(getApplicationContext(), "获取用户列表失败", Toast.LENGTH_LONG).show();
                }
            });

            btn_login = (Button) findViewById(R.id.btn_login);
            btn_login.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    checkLogin();
                }
            });
        }

    }

    private void checkLogin(){
        password = et_password.getText().toString();
        if (password == null || password.equals("")){
            Toast.makeText(getBaseContext(), "请填写密码", Toast.LENGTH_LONG).show();
            return;
        }
        AppContext.getInstance().saveAccountInfo(mobile, username, password);
        login();
    }

    private void login(){
        Api.login(mobile, password, new AsyncHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                String res = new String(responseBody);
                JSONObject jsonObject, jsonObject1;

                try {
                    jsonObject = new JSONObject(res);
                    jsonObject1 = jsonObject.getJSONObject("user");
                    AppContext.getInstance().saveToken(jsonObject1.getString("token"));
                    Toast.makeText(getBaseContext(), "token: "+jsonObject1.getString("token"), Toast.LENGTH_LONG).show();

                    Intent intent = new Intent(getBaseContext(), MainActivity.class);
                    startActivity(intent);
                    finish();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
                Toast.makeText(getApplicationContext(), "登陆失败", Toast.LENGTH_LONG).show();
            }
        });
    }
}
