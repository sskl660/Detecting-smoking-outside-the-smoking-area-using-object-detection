package st;

import java.sql.*;

public class AdminDAO {

    // 로그인 성공시 DB에서 id와 일치하는 행의 id, pw의 속성값을 조회하는 메소드
    public AdminVO GetForSession(String in_id) {

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        AdminVO vo = new AdminVO();

        try {
            conn = Config.getInstance().sqlLogin();
            pstmt = conn.prepareStatement("select id, pw from sys.Admin where id=?");
            pstmt.setString(1, in_id);
            rs = pstmt.executeQuery();

            if(rs.next()) {
                vo.setId(rs.getString("id"));
                vo.setPw(rs.getString("pw"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return vo;
    }

    // 로그인 성공, 비번확인, 아이디 확인하는 메소드
    public int LoginCheck(String in_id, String in_pw) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int ok = 0;

        try {
            conn = Config.getInstance().sqlLogin();
            pstmt = conn.prepareStatement("select pw from sys.Admin where id=?");
            pstmt.setString(1, in_id);
            rs = pstmt.executeQuery();

            if(rs.next()) {
                if(rs.getString("pw").equals(in_pw)) {
                    System.out.println("로그인 성공");
                    ok = 1;
                } else {
                    System.out.println("비밀번호 불일치");
                    ok = 2;
                }
            } else {
                System.out.println("아이디 불일치");
                ok = 3;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return ok;
    }

}
