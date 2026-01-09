package com.psycheguard.web.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotEmpty;
import java.util.Map;

public class AssessmentSubmitDTO {
  @NotNull(message = "用户ID不能为空")
  private Long userId;

  @NotNull(message = "量表ID不能为空")
  private Long scaleId;

  @NotEmpty(message = "答案不能为空")
  private Map<Long, Integer> answers;

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public Long getScaleId() {
    return scaleId;
  }

  public void setScaleId(Long scaleId) {
    this.scaleId = scaleId;
  }

  public Map<Long, Integer> getAnswers() {
    return answers;
  }

  public void setAnswers(Map<Long, Integer> answers) {
    this.answers = answers;
  }
}
