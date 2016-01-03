package org.ligulfzhou.dingcan.bean;

/**
 * Created by ligulfzhou on 1/3/16.
 */
public class Statistic {
    String date;
    int money;

    public Statistic(String date, int money){
        this.date = date;
        this.money = money;
    }
    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getMoney() {
        return money;
    }

    public void setMoney(int money) {
        this.money = money;
    }
}
