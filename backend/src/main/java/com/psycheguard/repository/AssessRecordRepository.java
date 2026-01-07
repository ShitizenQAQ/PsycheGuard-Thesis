package com.psycheguard.repository;

import com.psycheguard.domain.AssessRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AssessRecordRepository extends JpaRepository<AssessRecord, Long> {
  List<AssessRecord> findByUser_UsernameContainingIgnoreCase(String keyword);

  List<AssessRecord> findByUserId(Long userId);

  List<AssessRecord> findTop5ByRiskLevelOrderByCreateTimeDesc(String riskLevel);

  List<AssessRecord> findByRiskLevelOrderByCreateTimeDesc(String riskLevel);

  List<AssessRecord> findByStatusOrderByCreateTimeDesc(String status);

  List<AssessRecord> findByRiskLevelAndStatusOrderByCreateTimeDesc(String riskLevel, String status);

  long countByUser_Id(Long userId);

  void deleteByUser_Id(Long userId);

  List<AssessRecord> findByIsTeachingCaseTrueOrderByCreateTimeDesc();

  AssessRecord findTopByUser_IdOrderByCreateTimeDesc(Long userId);
}
