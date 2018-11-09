package com.v2ex.flutterv2ex.parsehtml;

public class ReplyModel{

    private String content;
    private String contentRendered;
    private MemberModel member;
    private long created;
    private String createdString;

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getContentRendered() {
        return contentRendered;
    }

    public void setContentRendered(String contentRendered) {
        this.contentRendered = contentRendered;
    }

    public MemberModel getMember() {
        return member;
    }

    public void setMember(MemberModel member) {
        this.member = member;
    }

    public long getCreated() {
        return created;
    }

    public void setCreated(long created) {
        this.created = created;
    }

    public void setCreatedString(String createdString) {
        this.createdString = createdString;
    }

    public String getCreatedString() {
        return createdString;
    }
}
