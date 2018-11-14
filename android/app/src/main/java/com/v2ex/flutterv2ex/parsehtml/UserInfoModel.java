package com.v2ex.flutterv2ex.parsehtml;

import android.util.Log;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.util.ArrayList;
import java.util.List;

/**
 * 用户信息界面数据解析
 */
public class UserInfoModel {
    MemberModel member;
    List<TopicModel> topics = new ArrayList<>();

    public void parseResponse(String responseBody) {
        Document doc = Jsoup.parse(responseBody);
        Element body = doc.body();
        parseMember(body);
        parseQuestion(body);
    }

    /**
     * 解析会员信息
     *
     * @param body
     */
    private void parseMember(Element body) {
        member = new MemberModel();
        Elements cellElements = body.select("tbody");
        //会员信息
        Element memberElement = cellElements.get(1);
        //头像
        Elements avatarElements = memberElement.select("img.avatar");
        member.setAvatar_normal(avatarElements.attr("src"));
        //姓名
        Elements nameElements = memberElement.select("h1");
        member.setUsername(nameElements.text());
        //info
        Elements infoElements = memberElement.select("span.gray");
        member.setInfo(infoElements.text());
    }

    private void parseQuestion(Element body) {
        Elements questionElements = body.select(".cell.item");
        for (int i = 0; i < questionElements.size(); i++) {
            TopicModel topicModel = new TopicModel();
            Element questionElement = questionElements.get(i);
            //主题标题和回复数
            Elements titleElements = questionElement.select("a[href^=/t/]");
            topicModel.setTitle(ContentUtils.parseTitle(titleElements.text()));
            String[] hrefStrings = titleElements.attr("href").split("#");
            topicModel.setId(Integer.parseInt(hrefStrings[0].replace("/t/","")));
            topicModel.setReplies(Integer.parseInt(hrefStrings[1].replace("reply","")));

            Elements topicInfoElements = questionElement.select(".topic_info");
            String[] splits = topicInfoElements.text().split("  •  ");
            //topicNode
            topicModel.setNode(new NodeModel());
            if(splits.length > 0){
                topicModel.getNode().setName(ContentUtils.parseNodeTitle(splits[0].replace(" ","")));
            }
            //发布者name
            topicModel.setMember(new MemberModel());
            if(splits.length > 1){
                topicModel.getMember().setUsername(splits[1].replace(" ",""));
            }
            //创建时间
            if(splits.length > 2){
                topicModel.setCreatedString(splits[2].replace(" ",""));
            }
            //最后回复
            if(splits.length > 3){
                topicModel.setLastReply(splits[3].replace(" ","").replace("最后回复来自",""));
            }

            topics.add(topicModel);
        }
    }


}
