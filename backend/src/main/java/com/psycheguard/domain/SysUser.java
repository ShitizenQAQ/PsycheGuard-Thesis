package com.psycheguard.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.util.List;
import java.util.ArrayList;

@Entity
@Table(name = "sys_user")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SysUser {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(nullable = false, unique = true)
  private String username;

  @Column(name = "real_name")
  private String realName;

  @Column(nullable = false)
  private String password;

  @Column(nullable = false)
  private String role;

  @JdbcTypeCode(SqlTypes.ARRAY)
  @Column(name = "tags", columnDefinition = "text[]")
  private List<String> tags;

  @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
  private List<AssessRecord> records = new ArrayList<>();

  @org.hibernate.annotations.CreationTimestamp
  @Column(name = "create_time", updatable = false)
  private java.time.OffsetDateTime createTime;

  @org.hibernate.annotations.UpdateTimestamp
  @Column(name = "update_time")
  private java.time.OffsetDateTime updateTime;
}
