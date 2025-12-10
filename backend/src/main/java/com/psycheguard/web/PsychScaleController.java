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

  @GetMapping
  public List<PsychScale> list() {
    return scaleRepository.findAll();
  }

  @GetMapping("/{id}")
  public PsychScale get(@PathVariable Long id) {
    return scaleRepository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "scale not found"));
  }

  @PostMapping
  public ResponseEntity<PsychScale> create(@RequestBody Map<String, Object> body) {
    String name = String.valueOf(body.getOrDefault("name", "")).trim();
    String description = body.get("description") == null ? null : String.valueOf(body.get("description"));
    if (name.isEmpty()) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "name required");
    PsychScale s = new PsychScale();
    s.setName(name);
    s.setDescription(description);
    PsychScale saved = scaleRepository.save(s);
    return ResponseEntity.status(HttpStatus.CREATED).body(saved);
  }

  @PutMapping("/{id}")
  public PsychScale update(@PathVariable Long id, @RequestBody Map<String, Object> body) {
    PsychScale s = scaleRepository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "scale not found"));
    if (body.containsKey("name")) {
      String name = String.valueOf(body.get("name")).trim();
      if (name.isEmpty()) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "name required");
      s.setName(name);
    }
    if (body.containsKey("description")) {
      s.setDescription(body.get("description") == null ? null : String.valueOf(body.get("description")));
    }
    return scaleRepository.save(s);
  }

  @GetMapping("/{id}/questions")
  public List<com.psycheguard.web.dto.ScaleQuestionResponse> questions(@PathVariable Long id) {
    PsychScale s = scaleRepository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "scale not found"));
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

