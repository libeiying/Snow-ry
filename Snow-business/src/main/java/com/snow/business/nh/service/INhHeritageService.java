package com.snow.business.nh.service;

import com.snow.business.nh.domain.NhHeritage;
import java.util.List;

/**
 * Non-heritage service.
 */
public interface INhHeritageService
{
    public NhHeritage selectNhHeritageById(Long id);

    public List<NhHeritage> selectNhHeritageList(NhHeritage nhHeritage);

    public int insertNhHeritage(NhHeritage nhHeritage);

    public int updateNhHeritage(NhHeritage nhHeritage);

    public int updateNhHeritageStatus(Long id, String status, String updateBy);

    public int deleteNhHeritageById(Long id);

    public int deleteNhHeritageByIds(Long[] ids);
}
