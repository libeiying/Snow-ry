package com.snow.business.route.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.snow.common.core.domain.BaseEntity;
import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * Recommend route entity for nh_recommend_route.
 *
 * Columns: id, route_date, spot_name, sub_title, spot_content
 */
public class NhRecommendRoute extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date routeDate;

    private String spotName;

    private String subTitle;

    private String spotContent;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date startDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date endDate;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Date getRouteDate()
    {
        return routeDate;
    }

    public void setRouteDate(Date routeDate)
    {
        this.routeDate = routeDate;
    }

    public String getSpotName()
    {
        return spotName;
    }

    public void setSpotName(String spotName)
    {
        this.spotName = spotName;
    }

    public String getSubTitle()
    {
        return subTitle;
    }

    public void setSubTitle(String subTitle)
    {
        this.subTitle = subTitle;
    }

    public String getSpotContent()
    {
        return spotContent;
    }

    public void setSpotContent(String spotContent)
    {
        this.spotContent = spotContent;
    }

    public Date getStartDate()
    {
        return startDate;
    }

    public void setStartDate(Date startDate)
    {
        this.startDate = startDate;
    }

    public Date getEndDate()
    {
        return endDate;
    }

    public void setEndDate(Date endDate)
    {
        this.endDate = endDate;
    }
}
