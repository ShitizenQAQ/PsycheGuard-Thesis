package com.psycheguard.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import org.hibernate.annotations.CreationTimestamp;

import java.util.Map;
import java.time.OffsetDateTime;

@Entity
@Table(name = "assess_record")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AssessRecord {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "user_id", nullable = false)
  private SysUser user;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "scale_id", nullable = false)
  private PsychScale scale;

  @Column(name = "total_score", nullable = false)
  private Integer totalScore;

  @Column(name = "risk_level", nullable = false)
  private String riskLevel;

  @JdbcTypeCode(SqlTypes.JSON)
  @Column(name = "answers", columnDefinition = "jsonb", nullable = false)
  private Map<String, Object> answers;

  @JdbcTypeCode(SqlTypes.JSON)
  @Column(name = "dimension_analysis", columnDefinition = "jsonb", nullable = false)
  private Map<String, Object> dimensionAnalysis;

  @Column(name = "is_teaching_case")
  private Boolean isTeachingCase = false;

  @Column(name = "expert_annotation", columnDefinition = "text")
  private String expertAnnotation;

  @Column(name = "status")
  private String status = "PENDING";

  @CreationTimestamp
  @Column(name = "create_time", updatable = false)
  private OffsetDateTime createTime;
}
