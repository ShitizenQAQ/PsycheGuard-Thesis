package com.psycheguard.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.util.List;
import java.util.Map;

@Entity
@Table(name = "scale_question")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ScaleQuestion {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @JsonIgnore
  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "scale_id", nullable = false)
  private PsychScale scale;

  @Column(nullable = false)
  private String content;

  @Column(name = "dimension")
  private String dimension;

  @Column(name = "sort_order")
  private Integer sortOrder;

  @JdbcTypeCode(SqlTypes.JSON)
  @Column(name = "options", columnDefinition = "jsonb", nullable = false)
  private List<Map<String, Object>> options;
}
