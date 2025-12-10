package com.psycheguard.repository;

import com.psycheguard.domain.SysUser;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SysUserRepository extends JpaRepository<SysUser, Long> {
  java.util.List<SysUser> findByUsernameContainingIgnoreCase(String keyword);
  java.util.Optional<SysUser> findByUsername(String username);
  com.psycheguard.domain.SysUser findByUsernameIgnoreCase(String username);
}
