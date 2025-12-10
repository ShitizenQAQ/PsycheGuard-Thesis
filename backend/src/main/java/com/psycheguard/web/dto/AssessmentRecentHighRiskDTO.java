package com.psycheguard.web.dto;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class AssessmentRecentHighRiskDTO {
  private Long id;
  private String prisonerName;
  private OffsetDateTime createTime;
}

