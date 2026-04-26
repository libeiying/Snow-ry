package com.snow.business.scenic.service.impl;

import com.snow.business.scenic.domain.NhScenicSpot;
import com.snow.business.scenic.mapper.NhScenicSpotMapper;
import com.snow.business.scenic.service.INhScenicSpotService;
import com.snow.common.exception.ServiceException;
import com.snow.common.utils.StringUtils;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class NhScenicSpotServiceImpl implements INhScenicSpotService
{
    @Autowired
    private NhScenicSpotMapper nhScenicSpotMapper;

    @Override
    public NhScenicSpot selectNhScenicSpotById(Long id)
    {
        return nhScenicSpotMapper.selectNhScenicSpotById(id);
    }

    @Override
    public List<NhScenicSpot> selectNhScenicSpotList(NhScenicSpot nhScenicSpot)
    {
        return nhScenicSpotMapper.selectNhScenicSpotList(nhScenicSpot);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertNhScenicSpot(NhScenicSpot nhScenicSpot)
    {
        validateForSave(nhScenicSpot);
        return nhScenicSpotMapper.insertNhScenicSpot(nhScenicSpot);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateNhScenicSpot(NhScenicSpot nhScenicSpot)
    {
        if (nhScenicSpot.getId() == null)
        {
            throw new ServiceException("ID cannot be null");
        }
        validateForSave(nhScenicSpot);
        return nhScenicSpotMapper.updateNhScenicSpot(nhScenicSpot);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteNhScenicSpotById(Long id)
    {
        if (id == null)
        {
            throw new ServiceException("ID cannot be null");
        }
        return nhScenicSpotMapper.deleteNhScenicSpotById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteNhScenicSpotByIds(Long[] ids)
    {
        if (ids == null || ids.length == 0)
        {
            throw new ServiceException("IDs cannot be empty");
        }
        return nhScenicSpotMapper.deleteNhScenicSpotByIds(ids);
    }

    private void validateForSave(NhScenicSpot nhScenicSpot)
    {
        if (nhScenicSpot == null)
        {
            throw new ServiceException("Request body cannot be null");
        }
        if (StringUtils.isEmpty(nhScenicSpot.getSpotName()))
        {
            throw new ServiceException("spotName cannot be empty");
        }
    }
}
