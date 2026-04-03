package com.psycheguard.web;

import com.psycheguard.backend.security.JwtUtils;
import com.psycheguard.domain.SysUser;
import com.psycheguard.repository.SysUserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class AuthController {
  private final SysUserRepository userRepository;
  private final JwtUtils jwtUtils;
  private final PasswordEncoder passwordEncoder;

  public AuthController(SysUserRepository userRepository, JwtUtils jwtUtils, PasswordEncoder passwordEncoder) {
    this.userRepository = userRepository;
    this.jwtUtils = jwtUtils;
    this.passwordEncoder = passwordEncoder;
  }

  @PostMapping("/login")
  public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> payload) {
    try {
      String username = payload.get("username");
      String password = payload.get("password");

      if (username == null || password == null) {
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "username/password required");
      }

      // Temporary logic: Ensure admin exists but handle concurrency/constraints
      // safely
      // Better to remove this in production and rely on data.sql
      if ("doctor".equals(username)) {
        try {
          ensureUserExists(username, "123456", "ROLE_COUNSELOR");
        } catch (Exception ignored) {
          // Ignore if already exists (avoids Unique Constraint violation)
        }
      }

      SysUser user = userRepository.findByUsername(username)
          .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "用户不存在"));

      // Debug
      System.out.println("Login: " + username + " | DB Hash: " + user.getPassword());

      // Password Check
      boolean matches = passwordEncoder.matches(password, user.getPassword());
      // Fallback for plain text (migration only)
      if (!matches && password.equals(user.getPassword())) {
        matches = true;
      }

      if (!matches) {
        throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "密码错误");
      }

      String token = jwtUtils.generateToken(user.getUsername(), user.getRole(), user.getId());

      Map<String, Object> body = new HashMap<>();
      body.put("token", token);
      body.put("user", Map.of(
          "id", user.getId(),
          "username", user.getUsername(),
          "realName", user.getRealName() == null ? user.getUsername() : user.getRealName(),
          "role", user.getRole()));

      return ResponseEntity.ok(body);

    } catch (ResponseStatusException rse) {
      throw rse;
    } catch (Exception e) {
      e.printStackTrace();
      Map<String, Object> err = new HashMap<>();
      err.put("error", "Internal Server Error");
      err.put("message", e.getMessage());
      err.put("class", e.getClass().getName());
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(err);
    }
  }

  private void ensureUserExists(String username, String rawPassword, String role) {
    if (userRepository.findByUsername(username).isEmpty()) {
      SysUser u = new SysUser();
      u.setUsername(username);
      u.setPassword(passwordEncoder.encode(rawPassword));
      u.setRole(role);
      u.setRealName(role.equals("ROLE_COUNSELOR") ? "咨询师" : "来访者");
      userRepository.save(u);
    }
  }
}
