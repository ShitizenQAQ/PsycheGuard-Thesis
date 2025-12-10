package com.psycheguard.web.dto;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class AssessmentNotificationDTO {
  private Long id;
  private String prisonerName;
  private OffsetDateTime createTime;
  private String riskLevel;
}

