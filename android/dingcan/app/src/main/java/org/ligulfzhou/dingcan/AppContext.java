package org.ligulfzhou.dingcan;

import android.app.Application;
import java.util.Properties;
import org.ligulfzhou.dingcan.common.Constant;

public class AppContext extends Application {
	private boolean login = false; // 登录状态
	private int loginUid = 0; // 登录用户的id

    private static AppContext appContext;

	@Override
	public void onCreate() {
		super.onCreate();
		init();
        appContext = this;

        //initialize the sqlite
//		db = new AddToCart(this);
	}

    public static AppContext getInstance() {
        return appContext;
    }

	/**
	 * 初始化Application
	 */
	private void init() {
		// 初始化用记的登录信息
//		User loginUser = getLoginInfo();
//
//		if (null != loginUser && loginUser.getUserid() > 0
//				&& !StringUtils.isEmpty(getProperty(PROP_KEY_PRIVATE_TOKEN))) {
//			// 记录用户的id和状态
//			this.loginUid = loginUser.getUserid();
//			this.login = true;
//		}
	}


	public void setProperties(Properties ps) {
		AppConfig.getAppConfig(this).set(ps);
	}

	public Properties getProperties() {
		return AppConfig.getAppConfig(this).get();
	}

	public void setProperty(String key, String value) {
		AppConfig.getAppConfig(this).set(key, value);
	}

	public String getProperty(String key) {
		String res = AppConfig.getAppConfig(this).get(key);
		return res;
	}

	public void removeProperty(String... key) {
		AppConfig.getAppConfig(this).remove(key);
	}


	/**
	 * 获取登录信息
	 *
	 * @return
	 */
//	public User getLoginInfo() {
//		User user = new User();
//		user.setUserid(StringUtils.toInt(getProperty(PROP_KEY_UID)));
//		user.setUsername((getProperty(PROP_KEY_NAME)));
//		user.setCreate_at(StringUtils.toInt((getProperty(PROP_KEY_CREATE_AT))));
//		user.setUseremail(getProperty(PROP_KEY_EMAIL));
//		user.setUserrole(StringUtils.toInt(getProperty(PROP_KEY_ROLE)));
//
//		return user;
//	}

	/**
	 * 保存用户的email和pwd
	 * @param mobile
	 * @param username
	 */
	public void saveAccountInfo(String mobile, String username, String pwd) {
		setProperty(Constant.ACCOUNT_MOBILE, mobile);
		setProperty(Constant.ACCOUNT_USERNAME, username);
		setProperty(Constant.ACCOUNT_PASSWD, pwd);
	}

	public void saveToken(String token){
		setProperty(Constant.PROP_KEY_PRIVATE_TOKEN, token);
		login=true;
	}

//	/**
//	 * 保存登录用户的信息
//	 *
//	 * @param user
//	 */
//	@SuppressWarnings("serial")
//	public void saveLoginInfo(final User user) {
//		if (null == user) {
//			return;
//		}
//		// 保存用户的信息
//
////		this.loginUid = user.getUserid();
//
//		this.login = true;
////		setProperties(new Properties() {
////			{
////				setProperty(PROP_KEY_UID, String.valueOf(user.getUserid()));
////				setProperty(PROP_KEY_NAME, String.valueOf(user.getUsername()));
////				setProperty(PROP_KEY_CREATE_AT, String.valueOf(user.getCreate_at()));
////				setProperty(PROP_KEY_EMAIL, String.valueOf(user.getUseremail()));
////				setProperty(PROP_KEY_ROLE, String.valueOf(user.getUserrole()));
////			}
////		});
//	}

	/**
	 * 清除登录信息，用户的私有token也一并清除
	 */
	private void cleanLoginInfo() {
		this.loginUid = 0;
		this.login = false;
		removeProperty(Constant.PROP_KEY_PRIVATE_TOKEN, Constant.ACCOUNT_USERNAME, Constant.ACCOUNT_MOBILE,
				Constant.ACCOUNT_PASSWD);
	}

	/**
	 * 用户是否登录
	 *
	 * @return
	 */
	public boolean isLogin() {
		return login;
	}

	/**
	 * 获取登录用户id
	 *
	 * @return
	 */
	public int getLoginUid() {
		return this.loginUid;
	}

	/**
	 * 用户注销
	 */
	public void logout() {
		// 清除已登录用户的信息
		cleanLoginInfo();
//		this.login = false;
//		this.loginUid = 0;
		// 发送广播通知
//		BroadcastController.sendUserChangeBroadcase(this);
	}



    public String getToken() {
        String private_token = AppContext.getInstance().getProperty(Constant.PROP_KEY_PRIVATE_TOKEN);
        return private_token;
    }
}
