package com.psycheguard.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "psych_scale")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PsychScale {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(nullable = false)
  private String name;

  @Column
  private String description;

  @Column(name = "is_enabled")
  private Boolean isEnabled = true;

  /**
   * 危险阈值 - 达到或超过此分数视为高风险
   * 默认值为 6，确保向后兼容
   */
  @Column(name = "danger_threshold")
  private Integer dangerThreshold = 6;

  /**
   * 量表满分 - 用于前端展示和验证
   * 可选字段
   */
  @Column(name = "max_score")
  private Integer maxScore;

  /**
   * 量表类型 - 区分自评量表和他评量表
   * SELF: 自评量表,来访者可见
   * OBSERVER: 他评量表,咨询师可见
   */
  @Column(length = 20)
  private String type = "SELF";

  @org.hibernate.annotations.CreationTimestamp
  @Column(name = "create_time", updatable = false)
  private java.time.OffsetDateTime createTime;

  @org.hibernate.annotations.UpdateTimestamp
  @Column(name = "update_time")
  private java.time.OffsetDateTime updateTime;

  @JsonIgnore
  @OneToMany(mappedBy = "scale", cascade = CascadeType.ALL, orphanRemoval = true)
  private java.util.List<ScaleQuestion> questions = new java.util.ArrayList<>();
}
