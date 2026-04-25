package com.snow.business.cultural.mapper;

import java.util.List;
import com.snow.business.cultural.domain.CulturalCreativeComment;

/**
 * 文创评论表 Mapper
 */
public interface CulturalCreativeCommentMapper
{
    public List<CulturalCreativeComment> selectCulturalCreativeCommentList(CulturalCreativeComment comment);
}
