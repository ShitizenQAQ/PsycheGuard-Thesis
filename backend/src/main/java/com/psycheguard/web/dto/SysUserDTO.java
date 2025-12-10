package com.psycheguard.web.dto;

import lombok.Data;
import java.util.List;

@Data
public class SysUserDTO {
  private Long id;
  private String username;
  private String realName;
  private String role;
  private List<String> tags;
  private String lastRiskLevel;
}

