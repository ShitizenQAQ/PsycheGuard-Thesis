package com.psycheguard.web;

import com.psycheguard.domain.PsychScale;
import com.psycheguard.domain.SysUser;
import com.psycheguard.repository.PsychScaleRepository;
import com.psycheguard.repository.SysUserRepository;
import com.psycheguard.service.AssessService;
import com.psycheguard.web.dto.AssessmentSubmitDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import com.psycheguard.domain.AssessRecord;
import com.psycheguard.web.dto.AssessmentResultDTO;
import com.psycheguard.web.dto.AssessmentListItemDTO;
import com.psycheguard.repository.AssessRecordRepository;
import org.springframework.web.bind.annotation.RequestParam;
import com.psycheguard.web.dto.AssessmentNotificationDTO;
import com.psycheguard.web.dto.AssessmentRecentHighRiskDTO;
import com.psycheguard.web.dto.AssessmentInterventionItemDTO;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/api/assessments")
public class AssessRecordController {
  private final AssessService assessService;
  private final SysUserRepository userRepository;
  private final PsychScaleRepository scaleRepository;
  private final AssessRecordRepository recordRepository;

  public AssessRecordController(AssessService assessService, SysUserRepository userRepository,
      PsychScaleRepository scaleRepository, AssessRecordRepository recordRepository) {
    this.assessService = assessService;
    this.userRepository = userRepository;
    this.scaleRepository = scaleRepository;
    this.recordRepository = recordRepository;
  }

  @PostMapping
  public ResponseEntity<java.util.Map<String, Long>> submit(@RequestBody AssessmentSubmitDTO dto) {
    try {
      Long uid = dto.getUserId() != null ? dto.getUserId() : 1L;
      Long sid = dto.getScaleId() != null ? dto.getScaleId() : 1L;
      SysUser user = userRepository.findById(uid)
          .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId not found"));
      PsychScale scale = scaleRepository.findById(sid)
          .orElseGet(() -> {
            java.util.Optional<PsychScale> any = scaleRepository.findAll().stream().findFirst();
            if (any.isPresent())
              return any.get();
            PsychScale def = new PsychScale();
            def.setName("PCL-R");
            def.setDescription("Default scale");
            return scaleRepository.save(def);
          });
      Long id = assessService.submit(user, scale, dto.getAnswers()).getId();
      return ResponseEntity.ok(java.util.Map.of("id", id));
    } catch (ResponseStatusException rse) {
      throw rse;
    } catch (Exception ex) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage());
    }
  }

  @GetMapping("/{id}")
  public ResponseEntity<AssessmentResultDTO> get(@PathVariable Long id, java.security.Principal principal) {
    AssessRecord rec = recordRepository.findById(id)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "记录不存在"));

    // 🔒 安全校验：获取当前登录用户
    if (principal == null || principal.getName() == null) {
      throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "用户未登录");
    }
    String currentUsername = principal.getName();
    SysUser currentUser = userRepository.findByUsername(currentUsername)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "用户不存在"));

    // 规则：如果是咨询师，或者是本人，才允许查看
    String role = (currentUser.getRole() != null) ? currentUser.getRole().trim().toUpperCase() : "";
    boolean isCounselor = role.endsWith("COUNSELOR") || role.endsWith("ADMIN") || role.endsWith("DOCTOR");
    boolean isOwner = rec.getUser().getUsername().equals(currentUsername);

    if (!isCounselor && !isOwner) {
      throw new ResponseStatusException(HttpStatus.FORBIDDEN, "无权查看此档案");
    }

    AssessmentResultDTO dto = new AssessmentResultDTO();
    dto.setId(rec.getId());
    dto.setTotalScore(rec.getTotalScore());
    dto.setRiskLevel(rec.getRiskLevel());
    dto.setDimensionScore(rec.getDimensionAnalysis());
    dto.setIsTeachingCase(rec.getIsTeachingCase());
    dto.setExpertAnnotation(rec.getExpertAnnotation());
    if (rec.getScale() != null) {
      dto.setMaxScore(rec.getScale().getMaxScore());
      dto.setScaleName(rec.getScale().getName());
    }
    return ResponseEntity.ok(dto);
  }

  @GetMapping
  public java.util.List<AssessmentListItemDTO> list(
      @RequestParam(value = "keyword", required = false) String keyword,
      java.security.Principal principal) {

    // 强制鉴权
    if (principal == null || principal.getName() == null) {
      throw new org.springframework.web.server.ResponseStatusException(org.springframework.http.HttpStatus.UNAUTHORIZED,
          "用户未登录或令牌无效");
    }

    String currentUsername = principal.getName();
    SysUser currentUser = userRepository.findByUsername(currentUsername)
        .orElseThrow(() -> new org.springframework.web.server.ResponseStatusException(
            org.springframework.http.HttpStatus.UNAUTHORIZED, "用户不存在"));

    java.util.List<com.psycheguard.domain.AssessRecord> list;

    // 权限控制逻辑 (增加 .trim() 防止数据库空格导致判定失效)
    String role = (currentUser.getRole() != null) ? currentUser.getRole().trim().toUpperCase() : "";

    if (role.endsWith("CLIENT")) {
      // 来访者只能看到自己的记录
      list = recordRepository.findByUserId(currentUser.getId());
    } else if (role.endsWith("COUNSELOR") || role.endsWith("ADMIN") || role.endsWith("DOCTOR")) {
      // 咨询师/管理员可以看到所有记录
      if (keyword != null && !keyword.isBlank()) {
        list = recordRepository.findByUser_UsernameContainingIgnoreCase(keyword);
      } else {
        list = recordRepository.findAll();
      }
    } else {
      // 未知角色提示权限不足
      throw new org.springframework.web.server.ResponseStatusException(org.springframework.http.HttpStatus.FORBIDDEN,
          "未授权的角色访问");
    }

    java.util.List<AssessmentListItemDTO> out = new java.util.ArrayList<>(list.size());
    for (com.psycheguard.domain.AssessRecord rec : list) {
      AssessmentListItemDTO dto = new AssessmentListItemDTO();
      dto.setId(rec.getId());
      dto.setUserRealName(
          rec.getUser().getRealName() != null ? rec.getUser().getRealName() : rec.getUser().getUsername());
      dto.setCreateTime(rec.getCreateTime());
      dto.setTotalScore(rec.getTotalScore());
      dto.setRiskLevel(rec.getRiskLevel());
      dto.setIsTeachingCase(rec.getIsTeachingCase());
      dto.setExpertAnnotation(rec.getExpertAnnotation());
      out.add(dto);
    }
    return out;
  }

  @GetMapping("/notifications")
  public java.util.List<AssessmentNotificationDTO> notifications() {
    java.util.List<com.psycheguard.domain.AssessRecord> list = recordRepository
        .findTop5ByRiskLevelOrderByCreateTimeDesc("HIGH");
    java.util.List<AssessmentNotificationDTO> out = new java.util.ArrayList<>(list.size());
    for (com.psycheguard.domain.AssessRecord rec : list) {
      AssessmentNotificationDTO dto = new AssessmentNotificationDTO();
      dto.setId(rec.getId());
      dto.setPrisonerName(
          rec.getUser().getRealName() != null ? rec.getUser().getRealName() : rec.getUser().getUsername());
      dto.setCreateTime(rec.getCreateTime());
      dto.setRiskLevel(rec.getRiskLevel());
      out.add(dto);
    }
    return out;
  }

  @GetMapping("/recent-high-risk")
  public java.util.List<AssessmentRecentHighRiskDTO> recentHighRisk() {
    try {
      java.util.List<com.psycheguard.domain.AssessRecord> list = recordRepository
          .findTop5ByRiskLevelOrderByCreateTimeDesc("HIGH");
      java.util.List<AssessmentRecentHighRiskDTO> out = new java.util.ArrayList<>(list.size());
      for (com.psycheguard.domain.AssessRecord rec : list) {
        AssessmentRecentHighRiskDTO dto = new AssessmentRecentHighRiskDTO();
        dto.setId(rec.getId());
        dto.setPrisonerName(
            rec.getUser().getRealName() != null ? rec.getUser().getRealName() : rec.getUser().getUsername());
        dto.setCreateTime(rec.getCreateTime());
        out.add(dto);
      }
      return out;
    } catch (Exception ex) {
      return java.util.Collections.emptyList();
    }
  }

  @GetMapping("/high-risk")
  public java.util.List<AssessmentRecentHighRiskDTO> highRisk() {
    try {
      java.util.List<com.psycheguard.domain.AssessRecord> list = recordRepository
          .findByRiskLevelOrderByCreateTimeDesc("HIGH");
      java.util.List<AssessmentRecentHighRiskDTO> out = new java.util.ArrayList<>(list.size());
      for (com.psycheguard.domain.AssessRecord rec : list) {
        AssessmentRecentHighRiskDTO dto = new AssessmentRecentHighRiskDTO();
        dto.setId(rec.getId());
        dto.setPrisonerName(
            rec.getUser().getRealName() != null ? rec.getUser().getRealName() : rec.getUser().getUsername());
        dto.setCreateTime(rec.getCreateTime());
        out.add(dto);
      }
      return out;
    } catch (Exception ex) {
      return java.util.Collections.emptyList();
    }
  }

  @GetMapping("/interventions/high-risk")
  public java.util.List<AssessmentInterventionItemDTO> interventionsHighRisk() {
    try {
      java.util.List<com.psycheguard.domain.AssessRecord> list = recordRepository
          .findByRiskLevelOrderByCreateTimeDesc("HIGH");
      java.util.List<AssessmentInterventionItemDTO> out = new java.util.ArrayList<>(list.size());
      for (com.psycheguard.domain.AssessRecord rec : list) {
        AssessmentInterventionItemDTO dto = new AssessmentInterventionItemDTO();
        dto.setId(rec.getId());
        dto.setPrisonerName(
            rec.getUser().getRealName() != null ? rec.getUser().getRealName() : rec.getUser().getUsername());
        dto.setTotalScore(rec.getTotalScore());
        dto.setCreateTime(rec.getCreateTime());
        dto.setStatus(rec.getStatus());
        out.add(dto);
      }
      return out;
    } catch (Exception ex) {
      return java.util.Collections.emptyList();
    }
  }

  @GetMapping("/interventions")
  public java.util.List<AssessmentInterventionItemDTO> interventions(
      @RequestParam(value = "status", required = false) String status) {
    java.util.List<com.psycheguard.domain.AssessRecord> list;
    if (status != null && !status.isBlank()) {
      list = recordRepository.findByRiskLevelAndStatusOrderByCreateTimeDesc("HIGH", status.toUpperCase());
    } else {
      list = recordRepository.findByRiskLevelOrderByCreateTimeDesc("HIGH");
    }
    java.util.List<AssessmentInterventionItemDTO> out = new java.util.ArrayList<>(list.size());
    for (com.psycheguard.domain.AssessRecord rec : list) {
      AssessmentInterventionItemDTO dto = new AssessmentInterventionItemDTO();
      dto.setId(rec.getId());
      dto.setPrisonerName(
          rec.getUser().getRealName() != null ? rec.getUser().getRealName() : rec.getUser().getUsername());
      dto.setTotalScore(rec.getTotalScore());
      dto.setCreateTime(rec.getCreateTime());
      dto.setStatus(rec.getStatus());
      out.add(dto);
    }
    return out;
  }

  @PutMapping("/{id}/status")
  public ResponseEntity<java.util.Map<String, Object>> updateStatus(@PathVariable Long id,
      @RequestBody java.util.Map<String, String> body) {
    com.psycheguard.domain.AssessRecord rec = recordRepository.findById(id)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "record not found"));
    String status = String.valueOf(body.getOrDefault("status", rec.getStatus()));
    status = status == null ? rec.getStatus() : status.toUpperCase();
    if (!java.util.Set.of("PENDING", "PROCESSING", "ARCHIVED").contains(status)) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid status");
    }
    rec.setStatus(status);
    recordRepository.save(rec);
    return ResponseEntity.ok(java.util.Map.of("id", rec.getId(), "status", rec.getStatus()));
  }

  @PutMapping("/{id}/annotate")
  public ResponseEntity<java.util.Map<String, Object>> annotate(@PathVariable Long id,
      @RequestBody java.util.Map<String, Object> body) {
    AssessRecord rec = recordRepository.findById(id)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "record not found"));
    Object tc = body.get("isTeachingCase");
    Object ann = body.get("annotation");
    boolean isTc = false;
    if (tc instanceof Boolean)
      isTc = (Boolean) tc;
    else if (tc instanceof String)
      isTc = Boolean.parseBoolean((String) tc);
    // one-way add: once added to teaching library, cannot be removed
    rec.setIsTeachingCase(Boolean.TRUE.equals(rec.getIsTeachingCase()) || isTc);
    rec.setExpertAnnotation(ann == null ? null : String.valueOf(ann));
    recordRepository.save(rec);
    return ResponseEntity.ok(java.util.Map.of(
        "id", rec.getId(),
        "isTeachingCase", rec.getIsTeachingCase(),
        "expertAnnotation", rec.getExpertAnnotation()));
  }

  @GetMapping("/teaching-cases")
  public java.util.List<AssessmentListItemDTO> teachingCases() {
    java.util.List<com.psycheguard.domain.AssessRecord> list = recordRepository
        .findByIsTeachingCaseTrueOrderByCreateTimeDesc();
    java.util.List<AssessmentListItemDTO> out = new java.util.ArrayList<>(list.size());
    for (com.psycheguard.domain.AssessRecord rec : list) {
      AssessmentListItemDTO dto = new AssessmentListItemDTO();
      dto.setId(rec.getId());
      dto.setUserRealName(
          rec.getUser().getRealName() != null ? rec.getUser().getRealName() : rec.getUser().getUsername());
      dto.setCreateTime(rec.getCreateTime());
      dto.setTotalScore(rec.getTotalScore());
      dto.setRiskLevel(rec.getRiskLevel());
      dto.setIsTeachingCase(true);
      dto.setExpertAnnotation(rec.getExpertAnnotation());
      out.add(dto);
    }
    return out;
  }
}
