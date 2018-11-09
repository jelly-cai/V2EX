package com.v2ex.flutterv2ex.parsehtml;

public class TopicModel {

    private int id;
    private String title;
    private int replies;
    private MemberModel member;
    private NodeModel node;
    private long last_modified;
    private long created;
    private String createdString;
    private String last_modified_string;
    private String content;
    private String content_rendered;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getReplies() {
        return replies;
    }

    public void setReplies(int replies) {
        this.replies = replies;
    }

    public MemberModel getMember() {
        return member;
    }

    public void setMember(MemberModel member) {
        this.member = member;
    }

    public NodeModel getNode() {
        return node;
    }

    public void setNode(NodeModel node) {
        this.node = node;
    }

    public long getLast_modified() {
        return last_modified;
    }

    public void setLast_modified(long last_modified) {
        this.last_modified = last_modified;
    }

    public void setCreated(long created) {
        this.created = created;
    }

    public long getCreated() {
        return created;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setContent_rendered(String content_rendered) {
        this.content_rendered = content_rendered;
    }

    public String getContent_rendered() {
        return content_rendered;
    }

    public void setLast_modified_string(String last_modified_string) {
        this.last_modified_string = last_modified_string;
    }

    public String getLast_modified_string() {
        return last_modified_string;
    }

    public void setCreatedString(String createdString) {
        this.createdString = createdString;
    }

    public String getCreatedString() {
        return createdString;
    }
}
