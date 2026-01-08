package com.psycheguard.backend.controller;

import com.psycheguard.backend.entity.Notification;
import com.psycheguard.backend.security.JwtUtils;
import com.psycheguard.backend.service.NotificationService;
import com.psycheguard.domain.SysUser;
import com.psycheguard.repository.SysUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;
    private final SysUserRepository userRepository;
    private final JwtUtils jwtUtils;

    /**
     * 从 token 中提取用户 ID(兼容旧 token)
     */
    private Long getUserIdFromToken(String token) {
        String cleanToken = token.replace("Bearer ", "");

        // 尝试从 token 中获取 userId
        Long userId = JwtUtils.getUserIdFromToken(cleanToken);

        // 如果 userId 为 null(旧 token),则从 username 查询
        if (userId == null) {
            String username = jwtUtils.extractUsername(cleanToken);
            SysUser user = userRepository.findByUsername(username).orElse(null);
            if (user != null) {
                userId = user.getId();
            }
        }

        return userId;
    }

    /**
     * 获取当前用户的所有通知
     */
    @GetMapping
    public ResponseEntity<List<Notification>> getNotifications(@RequestHeader("Authorization") String token) {
        Long userId = getUserIdFromToken(token);
        if (userId == null) {
            return ResponseEntity.ok(List.of()); // 返回空列表
        }
        List<Notification> notifications = notificationService.getUserNotifications(userId);
        return ResponseEntity.ok(notifications);
    }

    /**
     * 获取当前用户的未读通知数量
     */
    @GetMapping("/unread-count")
    public ResponseEntity<Map<String, Object>> getUnreadCount(@RequestHeader("Authorization") String token) {
        Long userId = getUserIdFromToken(token);
        Long count = (userId != null) ? notificationService.getUnreadCount(userId) : 0L;

        Map<String, Object> response = new HashMap<>();
        response.put("count", count);
        return ResponseEntity.ok(response);
    }

    /**
     * 标记单条通知为已读
     */
    @PutMapping("/{id}/read")
    public ResponseEntity<Void> markAsRead(@PathVariable Long id) {
        notificationService.markAsRead(id);
        return ResponseEntity.ok().build();
    }

    /**
     * 标记所有通知为已读
     */
    @PutMapping("/read-all")
    public ResponseEntity<Void> markAllAsRead(@RequestHeader("Authorization") String token) {
        Long userId = getUserIdFromToken(token);
        if (userId != null) {
            notificationService.markAllAsRead(userId);
        }
        return ResponseEntity.ok().build();
    }
}
