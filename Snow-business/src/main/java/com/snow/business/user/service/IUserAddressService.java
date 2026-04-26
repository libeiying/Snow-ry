package com.snow.business.user.service;

import java.util.List;
import com.snow.business.user.domain.UserAddress;

/**
 * 用户收货地址服务
 */
public interface IUserAddressService
{
    public List<UserAddress> selectAddressListByUserId(Long userId);

    public UserAddress selectDefaultAddressByUserId(Long userId);

    public int addAddress(UserAddress address);

    public int updateAddress(UserAddress address);

    public int deleteAddress(Long addressId, Long userId);

    public int setDefaultAddress(Long addressId, Long userId);
}
