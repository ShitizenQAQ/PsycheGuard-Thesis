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

    // 动态获取阈值：优先使用数据库配置,如果未配置则使用满分的60%作为默认值
    int threshold;
    if (scale.getDangerThreshold() != null && scale.getDangerThreshold() > 0) {
      threshold = scale.getDangerThreshold();
    } else if (scale.getMaxScore() != null && scale.getMaxScore() > 0) {
      threshold = (scale.getMaxScore() * 6) / 10; // 满分的60%
    } else {
      threshold = 6; // 兜底默认值
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
    if (q == null)
      return "Unknown";

    // 优先使用 dimension 字段
    if (q.getDimension() != null && !q.getDimension().trim().isEmpty()) {
      return q.getDimension().trim();
    }

    // 回退到内容解析(兼容旧数据)
    if (q.getContent() == null)
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
