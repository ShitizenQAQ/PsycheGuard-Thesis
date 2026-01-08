package com.psycheguard.web;

import com.psycheguard.domain.PsychScale;
import com.psycheguard.domain.ScaleQuestion;
import com.psycheguard.repository.PsychScaleRepository;
import com.psycheguard.repository.ScaleQuestionRepository;
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

  public PsychScaleController(PsychScaleRepository scaleRepository, ScaleQuestionRepository questionRepository) {
    this.scaleRepository = scaleRepository;
    this.questionRepository = questionRepository;
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
      list = scaleRepository.findByType(type);
      System.out.println("DEBUG: Fetching scales by type=" + type + ", found: " + list.size());
    } else {
      list = scaleRepository.findAll();
      System.out.println("DEBUG: Fetching all scales, found: " + list.size());
    }
    if (list.size() > 0) {
      System.out.println("DEBUG: First scale: " + list.get(0).getName());
    } else {
      System.out.println("DEBUG: List is empty. Count from DB: " + scaleRepository.count());
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
    // Delete associated questions first if cascade is not set, but assuming simple
    // delete for now
    // Ideally use CascadeType.ALL or delete manually
    List<ScaleQuestion> questions = questionRepository.findByScale_Id(id);
    questionRepository.deleteAll(questions);

    scaleRepository.deleteById(id);
    return ResponseEntity.noContent().build();
  }

  @GetMapping("/{id}/questions")
  public List<com.psycheguard.web.dto.ScaleQuestionResponse> questions(@PathVariable Long id) {
    PsychScale s = scaleRepository.findById(id)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "scale not found"));
    List<ScaleQuestion> list = questionRepository.findByScale_Id(s.getId());
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
}
