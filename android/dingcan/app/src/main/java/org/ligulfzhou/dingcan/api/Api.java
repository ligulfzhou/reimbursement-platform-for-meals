package org.ligulfzhou.dingcan.api;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.ligulfzhou.dingcan.AppContext;
import org.ligulfzhou.dingcan.common.Constant;

import static org.ligulfzhou.dingcan.api.AsyncHttpHelp.getHttpClient;


public class Api {
    public final static String HOST = "192.168.1.100:8888/";
    public final static String HTTP = "http://";
    public final static String BASE_URL = HTTP + HOST;

    public final static String USERLIST = BASE_URL + "api/users";
    public final static String LOGIN = BASE_URL + "api/login";
    public final static String STATISTIC = BASE_URL + "api/statistics";
    public final static String CANFEI = BASE_URL + "api/add_canfei";


    public static void getUserList(AsyncHttpResponseHandler handler){
        AsyncHttpHelp.get(USERLIST, handler);
    }

    public static void login(String mobile, String passwd, AsyncHttpResponseHandler handler){
        RequestParams params = new RequestParams();
        params.put("mobile", mobile);
        params.put("password", passwd);
        AsyncHttpHelp.post(LOGIN, params, handler);
    }

    public static void getStatistics(int flag, AsyncHttpResponseHandler handler){
        String token = AppContext.getInstance().getProperty(Constant.PROP_KEY_PRIVATE_TOKEN);
        AsyncHttpClient httpClient = getHttpClient();
        httpClient.addHeader("Authorization", "Basic " + token);

        RequestParams params = new RequestParams();
        params.put("flag", flag);
        httpClient.get(STATISTIC, params, handler);
    }

    public static void postCanfei(String date, int money, AsyncHttpResponseHandler handler){
        RequestParams params = new RequestParams();
        params.put("date", date);
        params.put("money", money);
        String token = AppContext.getInstance().getProperty(Constant.PROP_KEY_PRIVATE_TOKEN);
        AsyncHttpClient httpClient = getHttpClient();
        httpClient.addHeader("Authorization", "Basic " + token);

        httpClient.post(CANFEI, params, handler);
    }
}
