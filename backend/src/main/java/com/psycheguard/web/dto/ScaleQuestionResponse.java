package com.psycheguard.web.dto;

import java.util.List;
import java.util.Map;

public class ScaleQuestionResponse {
  private Long id;
  private Long scaleId;
  private String content;
  private List<Map<String, Object>> options;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public Long getScaleId() { return scaleId; }
  public void setScaleId(Long scaleId) { this.scaleId = scaleId; }
  public String getContent() { return content; }
  public void setContent(String content) { this.content = content; }
  public List<Map<String, Object>> getOptions() { return options; }
  public void setOptions(List<Map<String, Object>> options) { this.options = options; }
}
