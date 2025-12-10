package com.psycheguard.web.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.util.List;
import java.util.Map;

public class ScaleQuestionRequest {
  @NotNull
  private Long scaleId;

  @NotEmpty
  private String content;

  @NotNull
  private List<Map<String, Object>> options;

  public Long getScaleId() { return scaleId; }
  public void setScaleId(Long scaleId) { this.scaleId = scaleId; }
  public String getContent() { return content; }
  public void setContent(String content) { this.content = content; }
  public List<Map<String, Object>> getOptions() { return options; }
  public void setOptions(List<Map<String, Object>> options) { this.options = options; }
}

