package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConfig {

    private static final String DB_NAME = "auraluxe";
    private static final String USER     = "root";
    private static final String PASSWORD = "";
    private static final String URL      = "jdbc:mysql://localhost:3306/" + DB_NAME
                                         + "?useSSL=false&serverTimezone=UTC";

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
