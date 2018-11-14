package com.v2ex.flutterv2ex.parsehtml;

import android.text.TextUtils;

import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.select.Elements;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by yw on 2015/5/28.
 */
public class ContentUtils {

    public static String formatContent(String content) {
        return content.replace("href=\"/member/", "href=\"http://www.v2ex.com/member/")
                .replace("href=\"/i/", "href=\"https://i.v2ex.co/")
                .replace("href=\"/t/", "href=\"http://www.v2ex.com/t/")
                .replace("href=\"/go/", "href=\"http://www.v2ex.com/go/");
    }

    public static int[] parsePage(Element body) {
        int currentPage = 1, totalPage = 1;
        Elements elements = body.getElementsByClass("page_current");
        for (Element el : elements) {
            String text = el.text();
            try {
                currentPage = Integer.parseInt(text);
                break;
            } catch (Exception e) {
            }
        }

        elements = body.getElementsByClass("page_normal");
        totalPage = currentPage;
        for (Element el : elements) {
            String text = el.text();
            try {
                int page = Integer.parseInt(text);
                if (totalPage < page)
                    totalPage = page;
            } catch (Exception e) {
            }
        }
        return new int[]{currentPage, totalPage};
    }

    public static long toTimeLong(String dateString) {
        String[] stringArray = dateString.split(" ");
        long created = System.currentTimeMillis() / 1000;
        int how = Integer.parseInt(stringArray[0]);
        String subString = stringArray[1].substring(0, 1);
        if (subString.equals("分")) {
            created -= 60 * how;
        } else if (subString.equals("小")) {
            created -= 3600 * how;
        } else if (subString.equals("天")) {
            created -= 24 * 3600 * how;
        } else {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
                Date date = sdf.parse(dateString);
                created = date.getTime() / 1000;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return created;
    }

    /**
     * 解析node的名字
     * @param title
     * @return
     */
    public static String parseNodeTitle(String title){
        String[] strings = title.split("  ");
        if(strings.length > 1){
            return strings[1];
        }else{
            return title;
        }
    }

    /**
     * 解析标题
     * @param title
     * @return
     */
    public static String parseTitle(String title) {
        String[] strings = title.split(" ");
        if (isNumeric(strings[strings.length - 1])) {
            return title.replace(" " + strings[strings.length - 1], "");
        }else{
            return title;
        }
    }

    /**
     * 判断是否为数字
     * @param str
     * @return
     */
    public static boolean isNumeric(String str){
        for (int i = str.length();--i>=0;){
            if (!Character.isDigit(str.charAt(i))){
                return false;
            }
        }
        return true;
    }

}
