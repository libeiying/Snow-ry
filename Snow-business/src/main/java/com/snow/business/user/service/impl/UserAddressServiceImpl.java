package com.snow.business.user.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.snow.business.user.domain.UserAddress;
import com.snow.business.user.mapper.UserAddressMapper;
import com.snow.business.user.service.IUserAddressService;
import com.snow.common.exception.ServiceException;
import com.snow.common.utils.StringUtils;

/**
 * 用户收货地址服务实现
 */
@Service
public class UserAddressServiceImpl implements IUserAddressService
{
    @Autowired
    private UserAddressMapper userAddressMapper;

    @Override
    public List<UserAddress> selectAddressListByUserId(Long userId)
    {
        return userAddressMapper.selectAddressListByUserId(userId);
    }

    @Override
    public UserAddress selectDefaultAddressByUserId(Long userId)
    {
        return userAddressMapper.selectDefaultAddressByUserId(userId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int addAddress(UserAddress address)
    {
        validateAddress(address);
        if ("Y".equals(address.getIsDefault()))
        {
            userAddressMapper.clearDefaultByUserId(address.getUserId());
        }
        else
        {
            UserAddress currentDefault = userAddressMapper.selectDefaultAddressByUserId(address.getUserId());
            if (currentDefault == null)
            {
                address.setIsDefault("Y");
            }
        }
        return userAddressMapper.insertAddress(address);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateAddress(UserAddress address)
    {
        if (address.getAddressId() == null)
        {
            throw new ServiceException("addressId不能为空");
        }
        validateAddress(address);
        UserAddress exists = userAddressMapper.selectAddressByIdAndUserId(address.getAddressId(), address.getUserId());
        if (exists == null)
        {
            throw new ServiceException("地址不存在");
        }
        if ("Y".equals(address.getIsDefault()))
        {
            userAddressMapper.clearDefaultByUserId(address.getUserId());
        }
        return userAddressMapper.updateAddress(address);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteAddress(Long addressId, Long userId)
    {
        UserAddress exists = userAddressMapper.selectAddressByIdAndUserId(addressId, userId);
        if (exists == null)
        {
            throw new ServiceException("地址不存在");
        }
        int rows = userAddressMapper.deleteAddressById(addressId, userId);
        if (rows > 0 && "Y".equals(exists.getIsDefault()))
        {
            List<UserAddress> list = userAddressMapper.selectAddressListByUserId(userId);
            if (!list.isEmpty())
            {
                userAddressMapper.setDefaultById(list.get(0).getAddressId(), userId);
            }
        }
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int setDefaultAddress(Long addressId, Long userId)
    {
        UserAddress exists = userAddressMapper.selectAddressByIdAndUserId(addressId, userId);
        if (exists == null)
        {
            throw new ServiceException("地址不存在");
        }
        userAddressMapper.clearDefaultByUserId(userId);
        return userAddressMapper.setDefaultById(addressId, userId);
    }

    private void validateAddress(UserAddress address)
    {
        if (address == null)
        {
            throw new ServiceException("地址参数不能为空");
        }
        if (address.getUserId() == null)
        {
            throw new ServiceException("用户信息缺失");
        }
        if (StringUtils.isBlank(address.getReceiverName()) || StringUtils.isBlank(address.getReceiverPhone()) || StringUtils.isBlank(address.getDetailAddress()))
        {
            throw new ServiceException("收货人、手机号、详细地址不能为空");
        }
        if (!"Y".equals(address.getIsDefault()) && !"N".equals(address.getIsDefault()))
        {
            address.setIsDefault("N");
        }
        if (StringUtils.isBlank(address.getAddressStatus()))
        {
            address.setAddressStatus("0");
        }
    }
}
