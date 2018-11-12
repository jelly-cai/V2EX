package com.v2ex.flutterv2ex.parsehtml;

import android.text.TextUtils;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.util.ArrayList;
import java.util.regex.Pattern;

/**
 * Created by yw on 2015/5/26.
 */
public class TopicWithReplyListModel {

    public TopicModel topic;
    public ArrayList<ReplyModel> replies;
    public int totalPage;
    public int currentPage;

    public void parse(String responseBody, int id) {
        Document doc = Jsoup.parse(responseBody);
        Element body = doc.body();

        topic = new TopicModel();
        topic.setId(id);
        try {
            parseTopicModel(doc, body);
        } catch (Exception e) {
            e.printStackTrace();
        }
        replies = new ArrayList();
        Elements elements = body.getElementsByAttributeValueMatching("id", Pattern.compile("r_(.*)"));
        for (Element el : elements) {
            try {
                ReplyModel reply = parseReplyModel(el);
                replies.add(reply);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        int[] pages = ContentUtils.parsePage(body);
        currentPage = pages[0];
        totalPage = pages[1];
    }

    /**
     * 解析回复列表
     * @param element
     * @return
     */
    private ReplyModel parseReplyModel(Element element) {
        ReplyModel reply = new ReplyModel();
        reply.setMember(new MemberModel());
        //头像
        Elements avatarElements = element.select("img.avatar");
        if(avatarElements.size() != 0){
            reply.getMember().setAvatar_normal(avatarElements.attr("src"));
        }
        //内容
        Elements contentElements = element.select("div.reply_content");
        reply.setContent(contentElements.text());
        reply.setContentRendered(contentElements.html().replace("@\n","@"));
        //名称
        Elements userNameElements = element.select("a.dark");
        reply.getMember().setUsername(userNameElements.attr("href").replace("/member/",""));
        //时间
        Elements createdElements = element.select("span.ago");
        reply.setCreatedString(createdElements.text());
        return reply;
    }

    /**
     * 解析主题
     * @param doc
     * @param body
     * @throws Exception
     */
    private void parseTopicModel(Document doc, Element body) throws Exception {
        Elements header = body.getElementsByClass("header");
        if (header.size() == 0) throw new Exception("fail to parse topic");

        topic.setMember(new MemberModel());
        topic.setNode(new NodeModel());
        //头像
        Elements avatarElements = header.select("img.avatar");
        if(avatarElements.size() != 0){
            topic.getMember().setAvatar_normal(avatarElements.attr("src"));
        }
        //会员名
        Elements memberElements = header.select("a[href^=/member/]");
        if(memberElements.size() != 0){
            topic.getMember().setUsername(memberElements.attr("href").replace("/member/", ""));
        }
        //node名称和标题
        Elements nodeElements = doc.select("a[href^=/go/]");
        if(nodeElements.size() != 0){
            topic.getNode().setName(nodeElements.attr("href").replace("/go/", ""));
            topic.getNode().setTitle(nodeElements.text());
        }
        //主题标题
        Elements hNodes = header.get(0).getElementsByTag("h1");
        if (hNodes != null) {
            topic.setTitle(hNodes.text());
        }
        //时间created
        String dateString = header.get(0).getElementsByClass("gray").text();
        String[] components = dateString.split("·");
        if (components.length >= 2) {
            dateString = components[1].trim();
            topic.setCreatedString(dateString);
        }
        //内容
        Elements contentNodes = body.getElementsByClass("topic_content");
        if (contentNodes != null && contentNodes.size() > 0) {
            topic.setContent(contentNodes.get(0).text());
            topic.setContent_rendered(ContentUtils.formatContent(contentNodes.get(0).children().html()));
            if(TextUtils.isEmpty(topic.getContent_rendered())){
                topic.setContent_rendered(contentNodes.get(0).html());
            }
        }
        //回复数
        Elements boxNodes = body.getElementsByClass("box");
        Elements repliesElements  = boxNodes.select("span.gray");
        String[] repliesSplit = repliesElements.text().split("  \\|  ");
        if(repliesSplit.length == 2){
            String replyCount = repliesSplit[0].replace("回复", "");
            replyCount = replyCount.trim();
            topic.setReplies(Integer.parseInt(replyCount));
        }
    }
}
