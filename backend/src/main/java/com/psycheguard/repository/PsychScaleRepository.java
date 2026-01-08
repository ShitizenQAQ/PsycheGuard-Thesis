package com.psycheguard.repository;

import com.psycheguard.domain.PsychScale;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PsychScaleRepository extends JpaRepository<PsychScale, Long> {
    /**
     * 根据量表类型查询
     * 
     * @param type 量表类型 (SELF/OBSERVER)
     * @return 符合类型的量表列表
     */
    List<PsychScale> findByType(String type);
}
