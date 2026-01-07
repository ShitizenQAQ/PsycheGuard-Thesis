package com.psycheguard.web;

import com.psycheguard.domain.SysUser;
import com.psycheguard.repository.SysUserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dev/users")
public class SysUserDevController {
  private final SysUserRepository userRepository;

  public SysUserDevController(SysUserRepository userRepository) {
    this.userRepository = userRepository;
  }

  @PostMapping("/seed")
  public ResponseEntity<Long> seed() {
    if (userRepository.count() == 0) {
      SysUser u = new SysUser();
      u.setUsername("prisoner");
      u.setRole("CLIENT");
      u.setTags(java.util.List.of("测试"));
      SysUser saved = userRepository.save(u);
      return ResponseEntity.ok(saved.getId());
    }
    return ResponseEntity.ok(userRepository.findAll().get(0).getId());
  }
}
