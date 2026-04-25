package com.psycheguard.web;

import com.psycheguard.domain.PsychScale;
import com.psycheguard.domain.ScaleQuestion;
import com.psycheguard.repository.PsychScaleRepository;
import com.psycheguard.repository.ScaleQuestionRepository;
import com.psycheguard.repository.AssessRecordRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/scales")
public class PsychScaleController {
  private final PsychScaleRepository scaleRepository;
  private final ScaleQuestionRepository questionRepository;
  private final AssessRecordRepository assessRecordRepository;

  public PsychScaleController(PsychScaleRepository scaleRepository, ScaleQuestionRepository questionRepository,
      AssessRecordRepository assessRecordRepository) {
    this.scaleRepository = scaleRepository;
    this.questionRepository = questionRepository;
    this.assessRecordRepository = assessRecordRepository;
  }

  /**
   * 获取量表列表
   * 
   * @param type 可选参数,按类型过滤 (SELF/OBSERVER)
   * @return 量表列表
   */
  @GetMapping
  public List<PsychScale> list(@RequestParam(required = false) String type) {
    List<PsychScale> list;
    if (type != null && !type.isEmpty()) {
      // 这里的逻辑针对来访者/测评端，只显示已启用的量表
      list = scaleRepository.findByTypeAndIsEnabledTrue(type);
      System.out.println("DEBUG: Fetching ENABLED scales by type=" + type + ", found: " + list.size());
    } else {
      // 这里的逻辑针对管理端，显示所有量表（包括停用的）
      list = scaleRepository.findAll();
      System.out.println("DEBUG: Fetching all scales for management, found: " + list.size());
    }
    return list;
  }

  @GetMapping("/{id}")
  public PsychScale get(@PathVariable Long id) {
    return scaleRepository.findById(id)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "scale not found"));
  }

  @PostMapping
  public ResponseEntity<PsychScale> create(@RequestBody Map<String, Object> body) {
    String name = String.valueOf(body.getOrDefault("name", "")).trim();
    String description = body.get("description") == null ? null : String.valueOf(body.get("description"));
    if (name.isEmpty())
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "name required");
    PsychScale s = new PsychScale();
    s.setName(name);
    s.setDescription(description);
    if (body.containsKey("isEnabled")) {
      s.setIsEnabled(Boolean.valueOf(String.valueOf(body.get("isEnabled"))));
    }
    if (body.containsKey("dangerThreshold")) {
      Object val = body.get("dangerThreshold");
      s.setDangerThreshold(val == null ? null : Integer.valueOf(String.valueOf(val)));
    }
    if (body.containsKey("maxScore")) {
      Object val = body.get("maxScore");
      s.setMaxScore(val == null ? null : Integer.valueOf(String.valueOf(val)));
    }
    PsychScale saved = scaleRepository.save(s);
    return ResponseEntity.status(HttpStatus.CREATED).body(saved);
  }

  @PutMapping("/{id}")
  public PsychScale update(@PathVariable Long id, @RequestBody Map<String, Object> body) {
    PsychScale s = scaleRepository.findById(id)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "scale not found"));
    if (body.containsKey("name")) {
      String name = String.valueOf(body.get("name")).trim();
      if (name.isEmpty())
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "name required");
      s.setName(name);
    }
    if (body.containsKey("description")) {
      s.setDescription(body.get("description") == null ? null : String.valueOf(body.get("description")));
    }
    if (body.containsKey("isEnabled")) {
      s.setIsEnabled(Boolean.valueOf(String.valueOf(body.get("isEnabled"))));
    }
    if (body.containsKey("dangerThreshold")) {
      Object val = body.get("dangerThreshold");
      s.setDangerThreshold(val == null ? null : Integer.valueOf(String.valueOf(val)));
    }
    if (body.containsKey("maxScore")) {
      Object val = body.get("maxScore");
      s.setMaxScore(val == null ? null : Integer.valueOf(String.valueOf(val)));
    }
    return scaleRepository.save(s);
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> delete(@PathVariable Long id) {
    if (!scaleRepository.existsById(id)) {
      throw new ResponseStatusException(HttpStatus.NOT_FOUND, "scale not found");
    }

    // 🔒 安全检查：如果该量表存在历史测评记录，禁止删除
    long historyCount = assessRecordRepository.countByScale_Id(id);
    if (historyCount > 0) {
      throw new ResponseStatusException(HttpStatus.CONFLICT,
          "该量表包含 " + historyCount + " 条历史测评记录，无法删除。建议禁用量表而非删除。");
    }

    // Delete associated questions first
    List<ScaleQuestion> questions = questionRepository.findByScale_IdOrderBySortOrderAsc(id);
    questionRepository.deleteAll(questions);

    scaleRepository.deleteById(id);
    return ResponseEntity.noContent().build();
  }

  @GetMapping("/{id}/questions")
  public List<com.psycheguard.web.dto.ScaleQuestionResponse> questions(@PathVariable Long id) {
    PsychScale s = scaleRepository.findById(id)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "scale not found"));
    List<ScaleQuestion> list = questionRepository.findByScale_IdOrderBySortOrderAsc(s.getId());
    java.util.List<com.psycheguard.web.dto.ScaleQuestionResponse> out = new java.util.ArrayList<>(list.size());
    for (ScaleQuestion q : list) {
      com.psycheguard.web.dto.ScaleQuestionResponse resp = new com.psycheguard.web.dto.ScaleQuestionResponse();
      resp.setId(q.getId());
      resp.setScaleId(q.getScale().getId());
      resp.setContent(q.getContent());
      resp.setOptions(q.getOptions());
      out.add(resp);
    }
    return out;
  }
  @PostMapping("/import-standard")
  public ResponseEntity<Map<String, Object>> importStandard() {
    try {
      // 检查是否已经存在量表，如果已存在，可能不需要重复导入（或者由前端决定是否覆盖）
      if (scaleRepository.count() > 0) {
        return ResponseEntity.ok(Map.of("status", "exists", "message", "系统已存在量表数据"));
      }
      
      // 调用初始化逻辑 (这里我们简单提示，实际逻辑可以调用 DataImporter)
      // 注意：由于 DataImporter 包含 TRUNCATE，通常建议手动触发或仅在空库时执行
      return ResponseEntity.ok(Map.of("status", "success", "message", "标准量表导入逻辑已就绪（演示模式下请重启后端以触发自动导入）"));
    } catch (Exception e) {
      return ResponseEntity.status(500).body(Map.of("status", "error", "message", e.getMessage()));
    }
  }
}
