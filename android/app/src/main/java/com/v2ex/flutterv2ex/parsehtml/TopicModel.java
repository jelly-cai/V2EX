package com.v2ex.flutterv2ex.parsehtml;

public class TopicModel {

    private int id;
    private String title;
    private int replies;
    private MemberModel member;
    private NodeModel node;
    private long last_modified;

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
}
