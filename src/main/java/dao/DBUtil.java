package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    private static String URL = "jdbc:mysql://localhost:3306/bookmarker_ecommerce?serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8";
    private static String USER = "root";
    private static String PASSWORD = "Bookmarker09!";
    private static String DRIVER = "com.mysql.cj.jdbc.Driver";

    public static void setConnectionConfig(String url, String user, String password, String driver) {
        URL = url;
        USER = user;
        PASSWORD = password;
        DRIVER = driver;
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver non trovato", e);
        }
    }
}