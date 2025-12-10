package com.psycheguard.web.dto;

import java.util.Map;

public class AssessmentSubmitDTO {
  private Long userId;
  private Long scaleId;
  private Map<Long, Integer> answers;

  public Long getUserId() { return userId; }
  public void setUserId(Long userId) { this.userId = userId; }
  public Long getScaleId() { return scaleId; }
  public void setScaleId(Long scaleId) { this.scaleId = scaleId; }
  public Map<Long, Integer> getAnswers() { return answers; }
  public void setAnswers(Map<Long, Integer> answers) { this.answers = answers; }
}
