package com.psycheguard.web.dto;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class AssessmentInterventionItemDTO {
  private Long id;
  private String prisonerName;
  private Integer totalScore;
  private OffsetDateTime createTime;
  private String status;
}

