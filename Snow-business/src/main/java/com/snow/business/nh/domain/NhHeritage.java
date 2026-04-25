package com.snow.business.nh.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.snow.common.core.domain.BaseEntity;
import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * Intangible cultural heritage entity for nh_heritage.
 */
public class NhHeritage extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Primary key. */
    private Long id;

    /** Heritage code. */
    private String heritageCode;

    /** Heritage name. */
    private String name;

    /** Category. */
    private String category;

    /** Region. */
    private String region;

    /** Level. */
    private String level;

    /** Representative inheritor. */
    private String inheritor;

    /** Description. */
    private String description;

    /** Images JSON array text. */
    private String imagesJson;

    /** Cover image path. */
    private String coverImage;

    /** Status(0 normal, 1 disabled). */
    private String status;

    /** Delete flag(0 exists, 2 deleted). */
    private String delFlag;

    /** Remark. */
    private String remark;

    /** Create start time filter. */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /** Create end time filter. */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public String getHeritageCode()
    {
        return heritageCode;
    }

    public void setHeritageCode(String heritageCode)
    {
        this.heritageCode = heritageCode;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getCategory()
    {
        return category;
    }

    public void setCategory(String category)
    {
        this.category = category;
    }

    public String getRegion()
    {
        return region;
    }

    public void setRegion(String region)
    {
        this.region = region;
    }

    public String getLevel()
    {
        return level;
    }

    public void setLevel(String level)
    {
        this.level = level;
    }

    public String getInheritor()
    {
        return inheritor;
    }

    public void setInheritor(String inheritor)
    {
        this.inheritor = inheritor;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getImagesJson()
    {
        return imagesJson;
    }

    public void setImagesJson(String imagesJson)
    {
        this.imagesJson = imagesJson;
    }

    public String getCoverImage()
    {
        return coverImage;
    }

    public void setCoverImage(String coverImage)
    {
        this.coverImage = coverImage;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    public String getRemark()
    {
        return remark;
    }

    public void setRemark(String remark)
    {
        this.remark = remark;
    }

    public Date getStartTime()
    {
        return startTime;
    }

    public void setStartTime(Date startTime)
    {
        this.startTime = startTime;
    }

    public Date getEndTime()
    {
        return endTime;
    }

    public void setEndTime(Date endTime)
    {
        this.endTime = endTime;
    }
}
