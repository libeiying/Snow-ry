package com.snow.business.user.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.snow.business.user.domain.UserAddress;

/**
 * 用户收货地址 Mapper
 */
public interface UserAddressMapper
{
    public List<UserAddress> selectAddressListByUserId(@Param("userId") Long userId);

    public UserAddress selectAddressByIdAndUserId(@Param("addressId") Long addressId, @Param("userId") Long userId);

    public UserAddress selectDefaultAddressByUserId(@Param("userId") Long userId);

    public int insertAddress(UserAddress address);

    public int updateAddress(UserAddress address);

    public int clearDefaultByUserId(@Param("userId") Long userId);

    public int setDefaultById(@Param("addressId") Long addressId, @Param("userId") Long userId);

    public int deleteAddressById(@Param("addressId") Long addressId, @Param("userId") Long userId);
}
