package com.snow.business.cultural.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.snow.business.cultural.domain.CulturalCreativeComment;
import com.snow.business.cultural.domain.CulturalCreativeProduct;
import com.snow.business.cultural.domain.dto.CommentSubmitRequest;
import com.snow.business.cultural.mapper.CulturalCreativeCommentMapper;
import com.snow.business.cultural.mapper.CulturalCreativeProductMapper;
import com.snow.business.cultural.service.ICulturalCreativeService;
import com.snow.common.core.domain.entity.SysUser;
import com.snow.common.core.domain.model.LoginUser;
import com.snow.common.exception.ServiceException;
import com.snow.common.utils.StringUtils;

/**
 * 文创服务实现
 */
@Service
public class CulturalCreativeServiceImpl implements ICulturalCreativeService
{
    @Autowired
    private CulturalCreativeProductMapper culturalCreativeProductMapper;

    @Autowired
    private CulturalCreativeCommentMapper culturalCreativeCommentMapper;

    @Override
    public CulturalCreativeProduct selectCulturalCreativeProductById(Long id)
    {
        return culturalCreativeProductMapper.selectCulturalCreativeProductById(id);
    }

    @Override
    public List<CulturalCreativeProduct> selectCulturalCreativeProductList(CulturalCreativeProduct product)
    {
        return culturalCreativeProductMapper.selectCulturalCreativeProductList(product);
    }

    @Override
    public Map<String, Object> selectCulturalCreativeFull(Long productId)
    {
        CulturalCreativeComment q = new CulturalCreativeComment();
        q.setProductId(productId);
        q.setStatus("0");
        q.setAuditStatus("1");

        Map<String, Object> data = new HashMap<>();
        data.put("product", selectCulturalCreativeProductById(productId));
        data.put("comments", culturalCreativeCommentMapper.selectCulturalCreativeCommentList(q));
        return data;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertCulturalCreativeProduct(CulturalCreativeProduct product)
    {
        return culturalCreativeProductMapper.insertCulturalCreativeProduct(product);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateCulturalCreativeProduct(CulturalCreativeProduct product)
    {
        return culturalCreativeProductMapper.updateCulturalCreativeProduct(product);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteCulturalCreativeProductByIds(Long[] ids)
    {
        return culturalCreativeProductMapper.deleteCulturalCreativeProductByIds(ids);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long submitCulturalCreativeComment(Long productId, CommentSubmitRequest request)
    {
        if (productId == null || productId <= 0)
        {
            throw new ServiceException("商品ID无效");
        }
        if (request == null)
        {
            throw new ServiceException("参数错误");
        }
        String content = StringUtils.trim(request.getContent());
        if (StringUtils.isEmpty(content))
        {
            throw new ServiceException("请填写评论内容");
        }
        if (content.length() > 1000)
        {
            throw new ServiceException("评论内容不能超过1000字");
        }
        int score = request.getScore() == null ? 5 : request.getScore();
        if (score < 1 || score > 5)
        {
            throw new ServiceException("评分范围为1~5星");
        }
        String isAnonymous = "1".equals(request.getIsAnonymous()) ? "1" : "0";

        CulturalCreativeProduct product = culturalCreativeProductMapper.selectCulturalCreativeProductById(productId);
        if (product == null)
        {
            throw new ServiceException("商品不存在");
        }
        if (!"0".equals(product.getStatus()))
        {
            throw new ServiceException("商品已下架，暂不能评论");
        }

        Long userId = null;
        String nickname = "游客";
        String avatar = "";
        try
        {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.getPrincipal() instanceof LoginUser)
            {
                LoginUser loginUser = (LoginUser) authentication.getPrincipal();
                userId = loginUser.getUserId();
                SysUser u = loginUser.getUser();
                if (u != null)
                {
                    if (StringUtils.isNotEmpty(u.getNickName()))
                    {
                        nickname = u.getNickName();
                    }
                    else if (StringUtils.isNotEmpty(loginUser.getUsername()))
                    {
                        nickname = loginUser.getUsername();
                    }
                    if (StringUtils.isNotEmpty(u.getAvatar()))
                    {
                        avatar = u.getAvatar();
                    }
                }
            }
        }
        catch (Exception ignored)
        {
        }

        JSONArray imgArr = new JSONArray();
        if (request.getImagePaths() != null)
        {
            int sort = 1;
            for (String path : request.getImagePaths())
            {
                if (StringUtils.isEmpty(path))
                {
                    continue;
                }
                if (sort > 6)
                {
                    break;
                }
                JSONObject o = new JSONObject();
                o.put("url", path.trim());
                o.put("sort", sort++);
                imgArr.add(o);
            }
        }
        String imagesJson = imgArr.isEmpty() ? "[]" : imgArr.toJSONString();

        CulturalCreativeComment row = new CulturalCreativeComment();
        row.setProductId(productId);
        row.setUserId(userId);
        row.setUserNickname(nickname);
        row.setUserAvatar(avatar);
        row.setIsAnonymous(isAnonymous);
        row.setScore(score);
        row.setContent(content);
        row.setImagesJson(imagesJson);
        row.setLikeCount(0);
        row.setStatus("0");
        row.setAuditStatus("1");

        int n = culturalCreativeCommentMapper.insertCulturalCreativeComment(row);
        if (n <= 0)
        {
            throw new ServiceException("评论提交失败，请稍后重试");
        }
        culturalCreativeProductMapper.recalculateReviewStats(productId);
        return row.getId();
    }
}
