package com.psycheguard.web;

import com.psycheguard.domain.PsychScale;
import com.psycheguard.domain.ScaleQuestion;
import com.psycheguard.repository.PsychScaleRepository;
import com.psycheguard.repository.ScaleQuestionRepository;
import com.psycheguard.web.dto.ScaleQuestionRequest;
import com.psycheguard.web.dto.ScaleQuestionResponse;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

@RestController
@RequestMapping("/api/questions")
public class ScaleQuestionController {
  private final ScaleQuestionRepository questionRepository;
  private final PsychScaleRepository scaleRepository;

  public ScaleQuestionController(ScaleQuestionRepository questionRepository, PsychScaleRepository scaleRepository) {
    this.questionRepository = questionRepository;
    this.scaleRepository = scaleRepository;
  }

  @PostMapping
  public ResponseEntity<ScaleQuestionResponse> create(@Valid @RequestBody ScaleQuestionRequest request) {
    PsychScale scale = scaleRepository.findById(request.getScaleId())
      .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "scaleId not found"));

    ScaleQuestion q = new ScaleQuestion();
    q.setScale(scale);
    q.setContent(request.getContent());
    q.setOptions(request.getOptions());

    ScaleQuestion saved = questionRepository.save(q);
    ScaleQuestionResponse resp = toResponse(saved);
    return ResponseEntity.status(HttpStatus.CREATED).body(resp);
  }

  @org.springframework.web.bind.annotation.GetMapping
  public java.util.List<ScaleQuestionResponse> all() {
    java.util.List<ScaleQuestion> list = questionRepository.findAll();
    java.util.List<ScaleQuestionResponse> out = new java.util.ArrayList<>(list.size());
    for (ScaleQuestion q : list) out.add(toResponse(q));
    return out;
  }

  @PutMapping("/{id}")
  public ScaleQuestionResponse update(@PathVariable Long id, @Valid @RequestBody ScaleQuestionRequest request) {
    ScaleQuestion q = questionRepository.findById(id)
      .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "question not found"));
    PsychScale scale = scaleRepository.findById(request.getScaleId())
      .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "scaleId not found"));
    q.setScale(scale);
    q.setContent(request.getContent());
    q.setOptions(request.getOptions());
    ScaleQuestion saved = questionRepository.save(q);
    return toResponse(saved);
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> delete(@PathVariable Long id) {
    ScaleQuestion q = questionRepository.findById(id)
      .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "question not found"));
    questionRepository.delete(q);
    return ResponseEntity.noContent().build();
  }

  private ScaleQuestionResponse toResponse(ScaleQuestion q) {
    ScaleQuestionResponse resp = new ScaleQuestionResponse();
    resp.setId(q.getId());
    resp.setScaleId(q.getScale().getId());
    resp.setContent(q.getContent());
    resp.setOptions(q.getOptions());
    return resp;
  }
}
