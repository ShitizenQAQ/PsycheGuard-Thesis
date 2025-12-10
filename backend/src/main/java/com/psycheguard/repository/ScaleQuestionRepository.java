package com.psycheguard.repository;

import com.psycheguard.domain.ScaleQuestion;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ScaleQuestionRepository extends JpaRepository<ScaleQuestion, Long> {
  java.util.List<ScaleQuestion> findByScale_Id(Long scaleId);
}
