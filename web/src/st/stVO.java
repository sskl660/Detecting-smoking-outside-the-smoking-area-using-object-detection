package st;

import java.sql.*;

public class stVO {

    private String date;
    private String name;
    private String id;
    private String major;
    private String addr;
    private String mail;
    private String img;

    public String getDate() { return date; }

    public void setDate(String date) { this.date = date; }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }


    public String getMajor() { return major; }

    public void setMajor(String major) {
        this.major = major;
    }


    public String getAddr() { return addr; }

    public void setAddr(String addr) {this.addr = addr; }

    public String getMail() {return mail;}

    public void setMail(String mail) {this.mail = mail;}

    public String getImg() {return img;}

    public void setImg(String img) {this.img = img;}

    // 기본생성자
    public stVO() {}

}
