package com.psycheguard.backend.repository;

import com.psycheguard.backend.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {

    /**
     * 查询用户的所有通知,按创建时间倒序
     */
    List<Notification> findByUserIdOrderByCreatedAtDesc(Long userId);

    /**
     * 统计用户的未读通知数量
     */
    Long countByUserIdAndIsReadFalse(Long userId);

    /**
     * 查询用户的未读通知
     */
    List<Notification> findByUserIdAndIsReadFalseOrderByCreatedAtDesc(Long userId);
}
