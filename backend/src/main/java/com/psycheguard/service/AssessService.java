package com.psycheguard.service;

import com.psycheguard.domain.AssessRecord;
import com.psycheguard.domain.PsychScale;
import com.psycheguard.domain.SysUser;
import com.psycheguard.repository.AssessRecordRepository;
import com.psycheguard.repository.ScaleQuestionRepository;
import com.psycheguard.domain.ScaleQuestion;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
@Transactional
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

    // 动态获取阈值：优先使用数据库配置,如果未配置则使用满分的60%作为默认值
    int threshold;
    if (scale.getDangerThreshold() != null && scale.getDangerThreshold() > 0) {
      threshold = scale.getDangerThreshold();
    } else if (scale.getMaxScore() != null && scale.getMaxScore() > 0) {
      // 【通用降级策略】使用满分的60%作为评估阈值
      threshold = (scale.getMaxScore() * 6) / 10;
    } else {
      // 【通用降级策略】绝对值兜底逻辑
      threshold = 6;
    }

    // 风险等级判定：HIGH (高风险) / MEDIUM (中度风险) / LOW (低风险)
    // HIGH: 达到或超过阈值
    // MEDIUM: 达到阈值的70%-99%
    // LOW: 低于阈值的70%
    String risk;
    if (total >= threshold) {
      risk = "HIGH";
    } else if (total >= (threshold * 7) / 10) {
      risk = "MEDIUM";
    } else {
      risk = "LOW";
    }
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
    if (q == null) {
      return "默认维度";
    }

    // 优先并仅使用 dimension 字段。不再依赖基于字符串 "维度:" 的脆弱解析逻辑。
    if (q.getDimension() != null && !q.getDimension().trim().isEmpty()) {
      return q.getDimension().trim();
    }

    return "默认维度";
  }
}
