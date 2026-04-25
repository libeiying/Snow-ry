package com.snow.business.nh.service.impl;

import com.snow.business.nh.domain.NhHeritage;
import com.snow.business.nh.mapper.NhHeritageMapper;
import com.snow.business.nh.service.INhHeritageService;
import com.snow.common.exception.ServiceException;
import com.snow.common.utils.StringUtils;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Non-heritage service implementation.
 */
@Service
public class NhHeritageServiceImpl implements INhHeritageService
{
    @Autowired
    private NhHeritageMapper nhHeritageMapper;

    @Override
    public NhHeritage selectNhHeritageById(Long id)
    {
        return nhHeritageMapper.selectNhHeritageById(id);
    }

    @Override
    public List<NhHeritage> selectNhHeritageList(NhHeritage nhHeritage)
    {
        return nhHeritageMapper.selectNhHeritageList(nhHeritage);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertNhHeritage(NhHeritage nhHeritage)
    {
        validateForSave(nhHeritage, false);
        if (StringUtils.isEmpty(nhHeritage.getStatus()))
        {
            nhHeritage.setStatus("0");
        }
        nhHeritage.setDelFlag("0");
        return nhHeritageMapper.insertNhHeritage(nhHeritage);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateNhHeritage(NhHeritage nhHeritage)
    {
        if (nhHeritage.getId() == null)
        {
            throw new ServiceException("ID cannot be null");
        }
        validateForSave(nhHeritage, true);
        return nhHeritageMapper.updateNhHeritage(nhHeritage);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateNhHeritageStatus(Long id, String status, String updateBy)
    {
        if (id == null)
        {
            throw new ServiceException("ID cannot be null");
        }
        if (StringUtils.isEmpty(status) || (!"0".equals(status) && !"1".equals(status)))
        {
            throw new ServiceException("Invalid status value");
        }
        NhHeritage data = new NhHeritage();
        data.setId(id);
        data.setStatus(status);
        data.setUpdateBy(updateBy);
        return nhHeritageMapper.updateNhHeritageStatus(data);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteNhHeritageById(Long id)
    {
        if (id == null)
        {
            throw new ServiceException("ID cannot be null");
        }
        return nhHeritageMapper.deleteNhHeritageById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteNhHeritageByIds(Long[] ids)
    {
        if (ids == null || ids.length == 0)
        {
            throw new ServiceException("IDs cannot be empty");
        }
        return nhHeritageMapper.deleteNhHeritageByIds(ids);
    }

    private void validateForSave(NhHeritage nhHeritage, boolean isUpdate)
    {
        if (nhHeritage == null)
        {
            throw new ServiceException("Request body cannot be null");
        }
        if (StringUtils.isEmpty(nhHeritage.getHeritageCode()))
        {
            throw new ServiceException("heritageCode cannot be empty");
        }
        if (StringUtils.isEmpty(nhHeritage.getName()))
        {
            throw new ServiceException("name cannot be empty");
        }

        NhHeritage exists = nhHeritageMapper.selectNhHeritageByHeritageCode(nhHeritage.getHeritageCode());
        if (exists != null && (!isUpdate || !exists.getId().equals(nhHeritage.getId())))
        {
            throw new ServiceException("heritageCode already exists");
        }
    }
}
