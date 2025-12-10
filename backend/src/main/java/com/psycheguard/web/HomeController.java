package com.psycheguard.web;

import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {
  @GetMapping("/")
  public ResponseEntity<Map<String, Object>> root() {
    Map<String, Object> body = new LinkedHashMap<>();
    body.put("name", "PsycheGuard Backend");
    body.put("version", "0.0.1-SNAPSHOT");
    body.put("endpoints", new String[]{"GET /api/questions", "POST /api/questions"});
    return ResponseEntity.ok(body);
  }
}
