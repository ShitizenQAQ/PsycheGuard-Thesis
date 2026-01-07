package com.psycheguard.domain;

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
}
