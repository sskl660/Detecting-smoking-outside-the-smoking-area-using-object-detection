package st;

import java.sql.Connection;
import java.sql.DriverManager;

// Enum Singleton
public class Config {

    private Config() {}
    private static class Singleton {
        private static final Config instance = new Config();
    }

    public static Config getInstance() {
        return Singleton.instance;
    }
    // DB 커넥션 Variable
    private Connection conn = null;

    // DB 정보
    private final String tool = "jdbc:mysql://";

    private final String domain = "54.180.102.130";
    private final String id = "root";
    private final String pw = "qkr21730";
    private final String dbname = "sys";


    private String url = tool + domain + "/" + dbname
            + "?autoReconnect=true&useSSL=false&validationQuery=select 1&useUnicode=true&characterEncoding=UTF-8";

    public Connection sqlLogin() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, id, pw);
            // System.out.println("DB 연결 완료");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DB 연결 실패");
        }
        return conn;
    }
}
