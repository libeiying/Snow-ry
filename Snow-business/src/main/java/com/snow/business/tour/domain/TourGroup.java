package com.snow.business.tour.domain;

import java.math.BigDecimal;
import com.snow.common.core.domain.BaseEntity;

/**
 * 旅游团主表 tour_groups
 */
public class TourGroup extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private Long id;

    /** 团编号 */
    private String groupCode;

    /** 标题 */
    private String title;

    /** 副标题 */
    private String subTitle;

    /** 出发地 */
    private String departureCity;

    /** 目的地 */
    private String destinationCity;

    /** 天数 */
    private Integer days;

    /** 夜数 */
    private Integer nights;

    /** 起价 */
    private BigDecimal minPrice;

    /** 封面图 */
    private String coverImage;

    /** 标签（逗号分隔） */
    private String tags;

    /** 排序 */
    private Integer sortOrder;

    /** 状态（0上架 1下架） */
    private String status;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public String getGroupCode()
    {
        return groupCode;
    }

    public void setGroupCode(String groupCode)
    {
        this.groupCode = groupCode;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getSubTitle()
    {
        return subTitle;
    }

    public void setSubTitle(String subTitle)
    {
        this.subTitle = subTitle;
    }

    public String getDepartureCity()
    {
        return departureCity;
    }

    public void setDepartureCity(String departureCity)
    {
        this.departureCity = departureCity;
    }

    public String getDestinationCity()
    {
        return destinationCity;
    }

    public void setDestinationCity(String destinationCity)
    {
        this.destinationCity = destinationCity;
    }

    public Integer getDays()
    {
        return days;
    }

    public void setDays(Integer days)
    {
        this.days = days;
    }

    public Integer getNights()
    {
        return nights;
    }

    public void setNights(Integer nights)
    {
        this.nights = nights;
    }

    public BigDecimal getMinPrice()
    {
        return minPrice;
    }

    public void setMinPrice(BigDecimal minPrice)
    {
        this.minPrice = minPrice;
    }

    public String getCoverImage()
    {
        return coverImage;
    }

    public void setCoverImage(String coverImage)
    {
        this.coverImage = coverImage;
    }

    public String getTags()
    {
        return tags;
    }

    public void setTags(String tags)
    {
        this.tags = tags;
    }

    public Integer getSortOrder()
    {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder)
    {
        this.sortOrder = sortOrder;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }
}

