package com.psycheguard.web.dto;

import java.time.OffsetDateTime;

public class AssessmentListItemDTO {
  private Long id;
  private String userRealName;
  private OffsetDateTime createTime;
  private Integer totalScore;
  private String riskLevel;
  private Boolean isTeachingCase;
  private String expertAnnotation;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getUserRealName() { return userRealName; }
  public void setUserRealName(String userRealName) { this.userRealName = userRealName; }
  public OffsetDateTime getCreateTime() { return createTime; }
  public void setCreateTime(OffsetDateTime createTime) { this.createTime = createTime; }
  public Integer getTotalScore() { return totalScore; }
  public void setTotalScore(Integer totalScore) { this.totalScore = totalScore; }
  public String getRiskLevel() { return riskLevel; }
  public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }
  public Boolean getIsTeachingCase() { return isTeachingCase; }
  public void setIsTeachingCase(Boolean isTeachingCase) { this.isTeachingCase = isTeachingCase; }
  public String getExpertAnnotation() { return expertAnnotation; }
  public void setExpertAnnotation(String expertAnnotation) { this.expertAnnotation = expertAnnotation; }
}
