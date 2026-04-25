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
  private String scaleName;
  private java.util.Map<String, Object> dimensionScore;

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
  public String getScaleName() { return scaleName; }
  public void setScaleName(String scaleName) { this.scaleName = scaleName; }
  public java.util.Map<String, Object> getDimensionScore() { return dimensionScore; }
  public void setDimensionScore(java.util.Map<String, Object> dimensionScore) { this.dimensionScore = dimensionScore; }
}
