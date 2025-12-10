package com.psycheguard.web;

import com.psycheguard.domain.SysUser;
import com.psycheguard.repository.SysUserRepository;
import com.psycheguard.repository.AssessRecordRepository;
import com.psycheguard.web.dto.SysUserDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {
  private final SysUserRepository userRepository;
  private final AssessRecordRepository recordRepository;

  public UserController(SysUserRepository userRepository, AssessRecordRepository recordRepository) {
    this.userRepository = userRepository;
    this.recordRepository = recordRepository;
  }

  @GetMapping
  public List<SysUserDTO> list(@RequestParam(value = "keyword", required = false) String keyword,
                               @RequestParam(value = "role", required = false) String role) {
    List<SysUser> users;
    if (keyword != null && !keyword.isBlank()) {
      users = userRepository.findByUsernameContainingIgnoreCase(keyword);
    } else {
      users = userRepository.findAll();
    }
    if (role != null && !role.isBlank()) {
      String r = role.toUpperCase();
      users = users.stream().filter(u -> r.equalsIgnoreCase(u.getRole())).toList();
    }
    return users.stream().map(u -> {
      SysUserDTO dto = new SysUserDTO();
      dto.setId(u.getId());
      dto.setUsername(u.getUsername());
      dto.setRealName(u.getRealName());
      dto.setRole(u.getRole());
      dto.setTags(u.getTags());
      com.psycheguard.domain.AssessRecord last = recordRepository.findTopByUser_IdOrderByCreateTimeDesc(u.getId());
      dto.setLastRiskLevel(last == null ? null : last.getRiskLevel());
      return dto;
    }).toList();
  }

  @GetMapping("/{id}")
  public SysUser get(@PathVariable Long id) {
    return userRepository.findById(id)
      .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "user not found"));
  }

  @PostMapping
  public ResponseEntity<SysUser> create(@RequestBody SysUser input) {
    if (input.getUsername() == null || input.getUsername().isBlank()) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "username required");
    }
    if (userRepository.findByUsername(input.getUsername()).isPresent()) {
      throw new ResponseStatusException(HttpStatus.CONFLICT, "username exists");
    }
    SysUser u = new SysUser();
    u.setUsername(input.getUsername());
    u.setRealName(input.getRealName());
    // TODO: Use BCryptPasswordEncoder to hash passwords instead of storing plain text
    u.setPassword(input.getPassword() == null || input.getPassword().isBlank() ? "123456" : input.getPassword());
    u.setRole(input.getRole() == null ? "PRISONER" : input.getRole());
    u.setTags(input.getTags());
    SysUser saved = userRepository.save(u);
    return ResponseEntity.status(HttpStatus.CREATED).body(saved);
  }

  @PutMapping("/{id}")
  public SysUser update(@PathVariable Long id, @RequestBody SysUser input) {
    SysUser u = userRepository.findById(id)
      .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "user not found"));
    if (input.getUsername() != null) u.setUsername(input.getUsername());
    if (input.getRealName() != null) u.setRealName(input.getRealName());
    if (input.getRole() != null) u.setRole(input.getRole());
    if (input.getTags() != null) u.setTags(input.getTags());
    return userRepository.save(u);
  }

  @DeleteMapping("/{id}")
  @org.springframework.transaction.annotation.Transactional
  public ResponseEntity<java.util.Map<String, Long>> delete(@PathVariable Long id) {
    SysUser u = userRepository.findById(id)
      .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "user not found"));
    if ("DOCTOR".equalsIgnoreCase(u.getRole())) {
      throw new ResponseStatusException(HttpStatus.FORBIDDEN, "doctor cannot be deleted");
    }
    try {
      recordRepository.deleteByUser_Id(id);
      userRepository.delete(u);
      return ResponseEntity.ok(java.util.Map.of("id", id));
    } catch (Exception e) {
      throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "delete failed");
    }
  }
}
