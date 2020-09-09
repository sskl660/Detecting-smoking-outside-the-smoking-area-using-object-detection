package st;

import java.sql.*;
import java.util.*;
import java.lang.*;


public class stDAO {

//    //db접속
//    public Connection dbConn() {
//        Connection conn = null;
//
//        try {
//            Class.forName("com.mysql.jdbc.Driver");
//
//            String server = "54.180.102.130"; // MySQL 서버 주소
//            String database = "sys"; // MySQL DATABASE 이름
//            String user_name = "root";
//            String password = "qkr21730";
//
//            conn = DriverManager.getConnection("jdbc:mysql://" + server + "/" + database + "?useSSL=false", user_name, password);
//
//        } catch (ClassNotFoundException | SQLException e) {
//            e.printStackTrace();
//        }
//
//        return conn;
//
//    }

    public ArrayList<stVO> stList() {

        ArrayList<stVO> list = new ArrayList<stVO>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = Config.getInstance().sqlLogin();
//            conn = dbConn()
//            Config.getInstance().sqlLogin();

            String sql = "select * from sys.students";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                stVO vo = new stVO();

                vo.setDate(rs.getString("date"));
                vo.setName(rs.getString("name"));
                vo.setId(rs.getString("id"));
                vo.setMajor(rs.getString("major"));
                vo.setAddr(rs.getString("addr"));
                vo.setMail(rs.getString("mail"));
                vo.setImg(rs.getString("img"));

                list.add(vo);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public ArrayList<stVO> searchSt(String id) {

        ArrayList<stVO> list = new ArrayList<stVO>();
        Connection conn = null;
        Statement st = null;
        ResultSet rs = null;

        try {
                conn = Config.getInstance().sqlLogin();
                String sql = "";
                sql = "select * from sys.students where id LIKE '%" + id.trim() + "%'";
                st = conn.createStatement();
                rs = st.executeQuery(sql);

            while (rs.next()) {
                stVO vo = new stVO();

                vo.setDate(rs.getString("date"));
                vo.setName(rs.getString("name"));
                vo.setId(rs.getString("id"));
                vo.setMajor(rs.getString("major"));
                vo.setAddr(rs.getString("addr"));
                vo.setMail(rs.getString("mail"));
                vo.setImg(rs.getString("img"));

                list.add(vo);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;

    }


public ArrayList<stVO> findStudent(String keyField, String keyword) {
    ArrayList<stVO> list = new ArrayList<stVO>();
    Connection conn = null;
    Statement st = null;
//    PreparedStatement pstmt = null;
    ResultSet rs = null;

    System.out.println(keyField + " " + keyword);

    try{
        conn = Config.getInstance().sqlLogin();

//        String sql = "select date, time, name, id, major from sys.students";
        String sql = "";

        if(keyword != null && !keyword.equals("")) {
//            sql = "select datetime, name, id, major from sys.students where " + keyField.trim() + " LIKE ?";
            sql = "select * from sys.students where " + keyField.trim() + " LIKE '%" + keyword.trim() + "%'";
        }
//         else {
//            sql += "order by name";
//        }

//        pstmt = conn.prepareStatement(sql);
//        pstmt.setString(1, "%" + keyword + "%");

        System.out.println(sql);
        st = conn.createStatement();
//        rs = pstmt.executeQuery();
        rs = st.executeQuery(sql);

        while(rs.next()) {
            stVO vo = new stVO();

            vo.setDate(rs.getString("date"));
            vo.setName(rs.getString("name"));
            vo.setId(rs.getString("id"));
            vo.setMajor(rs.getString("major"));
            vo.setAddr(rs.getString("addr"));
            vo.setMail(rs.getString("mail"));
            vo.setImg(rs.getString("img"));

            list.add(vo);
        }

    } catch(Exception e) {
        e.printStackTrace();
    }

    return list;
    }
}