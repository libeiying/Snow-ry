package com.snow.business.nh.mapper;

import com.snow.business.nh.domain.NhHeritage;
import java.util.List;

/**
 * Heritage mapper.
 */
public interface NhHeritageMapper
{
    public NhHeritage selectNhHeritageById(Long id);

    public NhHeritage selectNhHeritageByHeritageCode(String heritageCode);

    public List<NhHeritage> selectNhHeritageList(NhHeritage nhHeritage);

    public int insertNhHeritage(NhHeritage nhHeritage);

    public int updateNhHeritage(NhHeritage nhHeritage);

    public int updateNhHeritageStatus(NhHeritage nhHeritage);

    public int deleteNhHeritageById(Long id);

    public int deleteNhHeritageByIds(Long[] ids);
}
