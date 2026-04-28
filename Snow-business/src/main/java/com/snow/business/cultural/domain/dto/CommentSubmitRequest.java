package com.snow.business.cultural.domain.dto;

import java.util.List;

/**
 * 用户端提交文创评论
 */
public class CommentSubmitRequest
{
    private Integer score = 5;
    private String content;
    /** 0 否 1 是 */
    private String isAnonymous = "0";
    /** 相对路径列表，如 /profile/upload/...（与通用上传返回 fileName 一致） */
    private List<String> imagePaths;

    public Integer getScore()
    {
        return score;
    }

    public void setScore(Integer score)
    {
        this.score = score;
    }

    public String getContent()
    {
        return content;
    }

    public void setContent(String content)
    {
        this.content = content;
    }

    public String getIsAnonymous()
    {
        return isAnonymous;
    }

    public void setIsAnonymous(String isAnonymous)
    {
        this.isAnonymous = isAnonymous;
    }

    public List<String> getImagePaths()
    {
        return imagePaths;
    }

    public void setImagePaths(List<String> imagePaths)
    {
        this.imagePaths = imagePaths;
    }
}
