package dao; 

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DBUtil {

    private static DataSource ds;

    static {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            ds = (DataSource) envCtx.lookup("jdbc/ecommerceDB");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        if (ds == null) {
            throw new SQLException("DataSource non inizializzato");
        }
        return ds.getConnection();
    }
}