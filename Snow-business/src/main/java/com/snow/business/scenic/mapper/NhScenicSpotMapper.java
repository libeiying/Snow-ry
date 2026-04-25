package com.snow.business.scenic.mapper;

import com.snow.business.scenic.domain.NhScenicSpot;
import java.util.List;

public interface NhScenicSpotMapper
{
    public NhScenicSpot selectNhScenicSpotById(Long id);

    public List<NhScenicSpot> selectNhScenicSpotList(NhScenicSpot nhScenicSpot);

    public int insertNhScenicSpot(NhScenicSpot nhScenicSpot);

    public int updateNhScenicSpot(NhScenicSpot nhScenicSpot);

    public int deleteNhScenicSpotById(Long id);

    public int deleteNhScenicSpotByIds(Long[] ids);
}
