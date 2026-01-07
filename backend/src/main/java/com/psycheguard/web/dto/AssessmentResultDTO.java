package com.psycheguard.web.dto;

import java.util.Map;

public class AssessmentResultDTO {
  private Long id;
  private Integer totalScore;
  private String riskLevel;
  private Map<String, Object> dimensionScore;
  private Boolean isTeachingCase;
  private String expertAnnotation;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Integer getTotalScore() {
    return totalScore;
  }

  public void setTotalScore(Integer totalScore) {
    this.totalScore = totalScore;
  }

  public String getRiskLevel() {
    return riskLevel;
  }

  public void setRiskLevel(String riskLevel) {
    this.riskLevel = riskLevel;
  }

  public Map<String, Object> getDimensionScore() {
    return dimensionScore;
  }

  public void setDimensionScore(Map<String, Object> dimensionScore) {
    this.dimensionScore = dimensionScore;
  }

  public Boolean getIsTeachingCase() {
    return isTeachingCase;
  }

  public void setIsTeachingCase(Boolean isTeachingCase) {
    this.isTeachingCase = isTeachingCase;
  }

  public String getExpertAnnotation() {
    return expertAnnotation;
  }

  public void setExpertAnnotation(String expertAnnotation) {
    this.expertAnnotation = expertAnnotation;
  }
}
