package com.v2ex.flutterv2ex.parsehtml;

import android.util.Log;


import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.regex.Pattern;

/**
 * 话题列表类,网页解析得到
 * Created by yw on 2015/5/19.
 */
public class TopicListModel extends ArrayList<TopicModel> {

    private static final long serialVersionUID = 2015050107L;

    public int mCurrentPage = 1;
    public int mTotalPage = 1;

    public void parse(String responseBody) throws Exception {
        Document doc = Jsoup.parse(responseBody);
        Element body = doc.body();
        Elements elements = body.getElementsByAttributeValue("class", "cell item");
        for (Element el : elements) {
            TopicModel model = parseTopicModel(el, true, null);
            add(model);
        }

        int[] pages = ContentUtils.parsePage(body);
        mCurrentPage = pages[0];
        mTotalPage = pages[1];
    }

    private TopicModel parseTopicModel(Element el, boolean parseNode, NodeModel node) throws Exception {
        Elements tdNodes = el.getElementsByTag("td");
        TopicModel topic = new TopicModel();
        MemberModel member = new MemberModel();
        if (parseNode) node = new NodeModel();
        //UserName
        Elements memberElements = el.select("a[href^=/member/]");
        member.setUsername(memberElements.attr("href").replace("/member/",""));
        //头像
        Elements avatarElements = el.select("img.avatar");
        member.setAvatar_normal(avatarElements.attr("src"));
        //nodename
        Elements nodeNameElements = el.select("a.node");
        node.setName(nodeNameElements.attr("href").replace("/go/", ""));
        node.setTitle(nodeNameElements.text());
        //主题
        Elements topicTitleElements = el.select("a[href^=/t/]");
        topic.setTitle(topicTitleElements.text());
        String[] subArray = topicTitleElements.attr("href").split("#");
        topic.setId(Integer.parseInt(subArray[0].replace("/t/", "")));
        topic.setReplies(Integer.parseInt(subArray[1].replace("reply", "")));
        //Last_modified
        Elements createdElements = el.select("span.topic_info");
        String[] createdArray = createdElements.text().split("  •  ");
        if(createdArray.length < 3){
            topic.setLast_modified_string("");
        }else{
            topic.setLast_modified_string(createdArray[2]);
        }
        topic.setMember(member);
        topic.setNode(node);

        return topic;
    }
}
