package com.psycheguard.service;

import com.psycheguard.domain.AssessRecord;
import com.psycheguard.domain.PsychScale;
import com.psycheguard.domain.SysUser;
import com.psycheguard.repository.AssessRecordRepository;
import com.psycheguard.repository.ScaleQuestionRepository;
import com.psycheguard.domain.ScaleQuestion;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class AssessService {
  private final AssessRecordRepository recordRepository;
  private final ScaleQuestionRepository questionRepository;

  public AssessService(AssessRecordRepository recordRepository, ScaleQuestionRepository questionRepository) {
    this.recordRepository = recordRepository;
    this.questionRepository = questionRepository;
  }

  public AssessRecord submit(SysUser user, PsychScale scale, Map<Long, Integer> answers) {
    int total = 0;
    if (answers != null) {
      for (Integer v : answers.values())
        total += v == null ? 0 : v;
    }

    // 使用量表配置的危险阈值，如果未设置则使用默认值 6
    int threshold = (scale.getDangerThreshold() != null) ? scale.getDangerThreshold() : 6;
    String risk = total >= threshold ? "HIGH" : "LOW";
    Map<String, Object> ans = new HashMap<>();
    if (answers != null) {
      for (Map.Entry<Long, Integer> e : answers.entrySet()) {
        ans.put(String.valueOf(e.getKey()), e.getValue());
      }
    }
    Map<String, Object> dim = new HashMap<>();
    if (answers != null) {
      for (Map.Entry<Long, Integer> e : answers.entrySet()) {
        ScaleQuestion q = questionRepository.findById(e.getKey()).orElse(null);
        String d = extractDimension(q);
        int prev = ((Number) dim.getOrDefault(d, 0)).intValue();
        dim.put(d, prev + (e.getValue() == null ? 0 : e.getValue()));
      }
    }
    AssessRecord rec = new AssessRecord();
    rec.setUser(user);
    rec.setScale(scale);
    rec.setTotalScore(total);
    rec.setRiskLevel(risk);
    rec.setAnswers(ans);
    rec.setDimensionAnalysis(dim);
    rec.setStatus("PENDING");
    return recordRepository.save(rec);
  }

  private String extractDimension(ScaleQuestion q) {
    if (q == null || q.getContent() == null)
      return "Unknown";
    String c = q.getContent();
    int idx = c.indexOf("维度:");
    if (idx >= 0) {
      String tail = c.substring(idx + 3).trim();
      // 取第一个空格前的部分作为维度名，如果没空格则取全部
      int spaceIdx = tail.indexOf(" ");
      String dim = spaceIdx >= 0 ? tail.substring(0, spaceIdx) : tail;
      // 移除末尾可能的标点符号
      return dim.replaceAll("[\\)\\]\\}：:，,。.]+$", "").trim();
    }
    return "Unknown";
  }
}
