package com.brainhub;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class Database {
    
    private static final String DEFAULT_URL = 
        "jdbc:mariadb://127.0.0.1:3306/brain_hub?connectTimeout=3000";

    private Database() {}

    /**
     * Establishes a database connection using system environment variables 
     * or defaults if they are not provided.
     */
    public static Connection getConnection() throws SQLException {
        String url = getSetting("BRAINHUB_DB_URL", DEFAULT_URL);
        String user = getSetting("BRAINHUB_DB_USER", "root");
        String password = getSetting("BRAINHUB_DB_PASSWORD", "");
        
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Checks if the database is accessible.
     */
    public static boolean isAvailable() {
        try (Connection ignored = getConnection()) {
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * Helper method to fall back to a default value if the environment variable is unset.
     */
    private static String getSetting(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.isBlank()) ? value : defaultValue;
    }
}
