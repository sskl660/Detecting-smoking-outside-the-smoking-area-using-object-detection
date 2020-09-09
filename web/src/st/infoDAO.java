package st;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

public class infoDAO {

        public infoVO getInfo(String id) {
            System.out.println(id);
            if(id == null || id == "") {
                System.out.println("id 매개변수가 없습니다.");
                return null;
            }

            infoVO info = new infoVO();
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                conn = Config.getInstance().sqlLogin();

                String sql = "select * from sys.info where id = " + id.trim();
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                if (rs.next()) {

                    info.setName(rs.getString("name"));
                    info.setId(rs.getString("id"));
                    info.setMajor(rs.getString("major"));
                    info.setMail(rs.getString("mail"));
                    info.setImg(rs.getString("img"));
                    info.setDetectnum(rs.getInt("detectnum"));

                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            return info;
        }

    }


