package com.psycheguard.backend.config;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.util.StreamUtils;

import java.nio.charset.StandardCharsets;

@Slf4j
@Configuration
public class DatabaseInitializer {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostConstruct
    public void initializeDatabase() {
        try {
            log.info("开始执行数据库初始化脚本...");

            // 读取 data.sql 文件
            ClassPathResource resource = new ClassPathResource("data.sql");
            String sql = StreamUtils.copyToString(resource.getInputStream(), StandardCharsets.UTF_8);

            // 按分号分割 SQL 语句
            String[] statements = sql.split(";");

            int successCount = 0;
            int skipCount = 0;

            for (String statement : statements) {
                String trimmed = statement.trim();
                if (trimmed.isEmpty() || trimmed.startsWith("--")) {
                    continue;
                }

                try {
                    jdbcTemplate.execute(trimmed);
                    successCount++;
                } catch (Exception e) {
                    // 忽略已存在的数据错误
                    if (e.getMessage() != null &&
                            (e.getMessage().contains("duplicate key") ||
                                    e.getMessage().contains("already exists"))) {
                        skipCount++;
                        log.debug("跳过已存在的数据: {}", e.getMessage());
                    } else {
                        log.warn("执行 SQL 语句失败: {}", trimmed.substring(0, Math.min(100, trimmed.length())));
                        log.warn("错误信息: {}", e.getMessage());
                    }
                }
            }

            log.info("数据库初始化完成! 成功: {}, 跳过: {}", successCount, skipCount);

        } catch (Exception e) {
            log.error("数据库初始化失败", e);
            // 不抛出异常,允许应用继续启动
        }
    }
}
