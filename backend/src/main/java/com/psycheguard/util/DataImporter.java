package com.psycheguard.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

@Component
public class DataImporter implements CommandLineRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        // 读取 data.sql
        ClassPathResource resource = new ClassPathResource("data.sql");
        StringBuilder sql = new StringBuilder();

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                // 跳过注释行
                line = line.trim();
                if (line.isEmpty() || line.startsWith("--")) {
                    continue;
                }
                sql.append(line).append(" ");

                // 执行完整的 SQL 语句
                if (line.endsWith(";")) {
                    String statement = sql.toString().trim();
                    if (!statement.isEmpty()) {
                        try {
                            jdbcTemplate.execute(statement);
                            System.out.println(
                                    "✅ 执行成功: " + statement.substring(0, Math.min(50, statement.length())) + "...");
                        } catch (Exception e) {
                            System.err.println("❌ 执行失败: " + statement.substring(0, Math.min(50, statement.length())));
                            System.err.println("错误: " + e.getMessage());
                        }
                    }
                    sql = new StringBuilder();
                }
            }
        }

        System.out.println("========================================");
        System.out.println("✅ data.sql 导入完成！");
        System.out.println("========================================");
    }
}
