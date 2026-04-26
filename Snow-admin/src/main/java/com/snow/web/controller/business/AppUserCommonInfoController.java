package com.snow.web.controller.business;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Collections;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.snow.business.user.domain.UserAddress;
import com.snow.business.user.service.IUserAddressService;
import com.snow.common.annotation.Anonymous;
import com.snow.common.constant.HttpStatus;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.domain.entity.SysUser;
import com.snow.common.core.domain.model.LoginUser;
import com.snow.common.exception.ServiceException;
import com.snow.common.utils.SecurityUtils;
import com.snow.common.utils.StringUtils;
import com.snow.framework.web.service.TokenService;
import com.snow.system.service.ISysUserService;

/**
 * 用户端常用信息接口
 */
@RestController
@RequestMapping("/app/user")
public class AppUserCommonInfoController extends BaseController
{
    @Autowired
    private ISysUserService userService;

    @Autowired
    private IUserAddressService userAddressService;

    @Autowired
    private TokenService tokenService;

    @Anonymous
    @GetMapping("/profile")
    public AjaxResult profile()
    {
        Long userId = getCurrentUserIdOrNull();
        if (userId == null)
        {
            return success(new HashMap<>());
        }
        SysUser user = userService.selectUserById(userId);
        if (user == null)
        {
            return success(new HashMap<>());
        }
        Map<String, Object> data = new HashMap<>();
        data.put("userId", user.getUserId());
        data.put("userName", user.getUserName());
        data.put("nickName", user.getNickName());
        data.put("phonenumber", user.getPhonenumber());
        data.put("email", user.getEmail());
        data.put("sex", user.getSex());
        data.put("avatar", user.getAvatar());
        return success(data);
    }

    @GetMapping("/common-info")
    public AjaxResult commonInfo()
    {
        Long userId = getCurrentUserIdOrNull();
        if (userId == null)
        {
            Map<String, Object> data = new HashMap<>();
            data.put("user", new HashMap<>());
            data.put("addresses", Collections.emptyList());
            data.put("defaultAddress", null);
            return success(data);
        }
        SysUser user = userService.selectUserById(userId);
        List<UserAddress> addressList = userAddressService.selectAddressListByUserId(userId);
        UserAddress defaultAddress = userAddressService.selectDefaultAddressByUserId(userId);
        Map<String, Object> userData = new HashMap<>();
        if (user != null)
        {
            userData.put("userId", user.getUserId());
            userData.put("userName", user.getUserName());
            userData.put("nickName", user.getNickName());
            userData.put("phonenumber", user.getPhonenumber());
            userData.put("email", user.getEmail());
            userData.put("sex", user.getSex());
            userData.put("avatar", user.getAvatar());
        }
        Map<String, Object> data = new HashMap<>();
        data.put("user", userData);
        data.put("addresses", addressList);
        data.put("defaultAddress", defaultAddress);
        return success(data);
    }

    @PutMapping("/profile")
    public AjaxResult updateProfile(@RequestBody ProfileUpdateReq req)
    {
        if (req == null)
        {
            throw new ServiceException("参数不能为空");
        }
        LoginUser loginUser = getCurrentLoginUserOrNull();
        if (loginUser == null)
        {
            return AjaxResult.error(HttpStatus.UNAUTHORIZED, "请先登录后再操作");
        }
        SysUser current = userService.selectUserById(loginUser.getUserId());
        if (current == null)
        {
            throw new ServiceException("用户不存在");
        }
        current.setNickName(req.getNickName());
        current.setPhonenumber(req.getPhonenumber());
        current.setEmail(req.getEmail());
        current.setSex(req.getSex());
        if (StringUtils.isNotEmpty(current.getPhonenumber()) && !userService.checkPhoneUnique(current))
        {
            return error("手机号已被其他用户使用");
        }
        if (StringUtils.isNotEmpty(current.getEmail()) && !userService.checkEmailUnique(current))
        {
            return error("邮箱已被其他用户使用");
        }
        if (userService.updateUserProfile(current) <= 0)
        {
            return error("修改失败，请稍后重试");
        }
        loginUser.setUser(current);
        tokenService.setLoginUser(loginUser);
        return success("保存成功");
    }

    @GetMapping("/address/list")
    public AjaxResult addressList()
    {
        Long userId = getCurrentUserIdOrNull();
        if (userId == null)
        {
            return success(Collections.emptyList());
        }
        return success(userAddressService.selectAddressListByUserId(userId));
    }

    @GetMapping("/address/default")
    public AjaxResult defaultAddress()
    {
        Long userId = getCurrentUserIdOrNull();
        if (userId == null)
        {
            return success();
        }
        return success(userAddressService.selectDefaultAddressByUserId(userId));
    }

    @PostMapping("/address")
    public AjaxResult addAddress(@RequestBody AddressReq req)
    {
        Long userId = getCurrentUserIdOrNull();
        if (userId == null)
        {
            return AjaxResult.error(HttpStatus.UNAUTHORIZED, "请先登录后再操作");
        }
        UserAddress address = toAddress(req);
        address.setUserId(userId);
        return toAjax(userAddressService.addAddress(address));
    }

    @PutMapping("/address")
    public AjaxResult updateAddress(@RequestBody AddressReq req)
    {
        if (req == null || req.getAddressId() == null)
        {
            throw new ServiceException("addressId不能为空");
        }
        Long userId = getCurrentUserIdOrNull();
        if (userId == null)
        {
            return AjaxResult.error(HttpStatus.UNAUTHORIZED, "请先登录后再操作");
        }
        UserAddress address = toAddress(req);
        address.setAddressId(req.getAddressId());
        address.setUserId(userId);
        return toAjax(userAddressService.updateAddress(address));
    }

    @PutMapping("/address/{addressId}/default")
    public AjaxResult setDefault(@PathVariable("addressId") Long addressId)
    {
        Long userId = getCurrentUserIdOrNull();
        if (userId == null)
        {
            return AjaxResult.error(HttpStatus.UNAUTHORIZED, "请先登录后再操作");
        }
        return toAjax(userAddressService.setDefaultAddress(addressId, userId));
    }

    @DeleteMapping("/address/{addressId}")
    public AjaxResult deleteAddress(@PathVariable("addressId") Long addressId)
    {
        Long userId = getCurrentUserIdOrNull();
        if (userId == null)
        {
            return AjaxResult.error(HttpStatus.UNAUTHORIZED, "请先登录后再操作");
        }
        return toAjax(userAddressService.deleteAddress(addressId, userId));
    }

    private UserAddress toAddress(AddressReq req)
    {
        if (req == null)
        {
            throw new ServiceException("地址参数不能为空");
        }
        UserAddress address = new UserAddress();
        address.setReceiverName(req.getReceiverName());
        address.setReceiverPhone(req.getReceiverPhone());
        address.setProvinceCode(req.getProvinceCode());
        address.setProvinceName(req.getProvinceName());
        address.setCityCode(req.getCityCode());
        address.setCityName(req.getCityName());
        address.setDistrictCode(req.getDistrictCode());
        address.setDistrictName(req.getDistrictName());
        address.setDetailAddress(req.getDetailAddress());
        address.setPostalCode(req.getPostalCode());
        address.setIsDefault(req.getIsDefault());
        address.setAddressStatus(req.getAddressStatus());
        address.setRemark(req.getRemark());
        return address;
    }

    public static class ProfileUpdateReq
    {
        private String nickName;
        private String phonenumber;
        private String email;
        private String sex;

        public String getNickName()
        {
            return nickName;
        }

        public void setNickName(String nickName)
        {
            this.nickName = nickName;
        }

        public String getPhonenumber()
        {
            return phonenumber;
        }

        public void setPhonenumber(String phonenumber)
        {
            this.phonenumber = phonenumber;
        }

        public String getEmail()
        {
            return email;
        }

        public void setEmail(String email)
        {
            this.email = email;
        }

        public String getSex()
        {
            return sex;
        }

        public void setSex(String sex)
        {
            this.sex = sex;
        }
    }

    public static class AddressReq
    {
        private Long addressId;
        private String receiverName;
        private String receiverPhone;
        private String provinceCode;
        private String provinceName;
        private String cityCode;
        private String cityName;
        private String districtCode;
        private String districtName;
        private String detailAddress;
        private String postalCode;
        private String isDefault;
        private String addressStatus;
        private String remark;

        public Long getAddressId()
        {
            return addressId;
        }

        public void setAddressId(Long addressId)
        {
            this.addressId = addressId;
        }

        public String getReceiverName()
        {
            return receiverName;
        }

        public void setReceiverName(String receiverName)
        {
            this.receiverName = receiverName;
        }

        public String getReceiverPhone()
        {
            return receiverPhone;
        }

        public void setReceiverPhone(String receiverPhone)
        {
            this.receiverPhone = receiverPhone;
        }

        public String getProvinceCode()
        {
            return provinceCode;
        }

        public void setProvinceCode(String provinceCode)
        {
            this.provinceCode = provinceCode;
        }

        public String getProvinceName()
        {
            return provinceName;
        }

        public void setProvinceName(String provinceName)
        {
            this.provinceName = provinceName;
        }

        public String getCityCode()
        {
            return cityCode;
        }

        public void setCityCode(String cityCode)
        {
            this.cityCode = cityCode;
        }

        public String getCityName()
        {
            return cityName;
        }

        public void setCityName(String cityName)
        {
            this.cityName = cityName;
        }

        public String getDistrictCode()
        {
            return districtCode;
        }

        public void setDistrictCode(String districtCode)
        {
            this.districtCode = districtCode;
        }

        public String getDistrictName()
        {
            return districtName;
        }

        public void setDistrictName(String districtName)
        {
            this.districtName = districtName;
        }

        public String getDetailAddress()
        {
            return detailAddress;
        }

        public void setDetailAddress(String detailAddress)
        {
            this.detailAddress = detailAddress;
        }

        public String getPostalCode()
        {
            return postalCode;
        }

        public void setPostalCode(String postalCode)
        {
            this.postalCode = postalCode;
        }

        public String getIsDefault()
        {
            return isDefault;
        }

        public void setIsDefault(String isDefault)
        {
            this.isDefault = isDefault;
        }

        public String getAddressStatus()
        {
            return addressStatus;
        }

        public void setAddressStatus(String addressStatus)
        {
            this.addressStatus = addressStatus;
        }

        public String getRemark()
        {
            return remark;
        }

        public void setRemark(String remark)
        {
            this.remark = remark;
        }
    }

    private Long getCurrentUserIdOrNull()
    {
        LoginUser loginUser = getCurrentLoginUserOrNull();
        return loginUser == null ? null : loginUser.getUserId();
    }

    private LoginUser getCurrentLoginUserOrNull()
    {
        Authentication authentication = SecurityUtils.getAuthentication();
        if (authentication == null)
        {
            return null;
        }
        Object principal = authentication.getPrincipal();
        if (!(principal instanceof LoginUser))
        {
            return null;
        }
        return (LoginUser) principal;
    }
}
