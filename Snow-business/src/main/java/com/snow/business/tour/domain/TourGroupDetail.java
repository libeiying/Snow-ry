package com.snow.business.tour.domain;

import com.snow.common.core.domain.BaseEntity;

/**
 * 旅游团详情表 tour_group_details（1团1详情）
 */
public class TourGroupDetail extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private Long id;

    /** 旅游团ID */
    private Long groupId;

    /** 亮点 */
    private String highlights;

    /** 行程介绍（富文本） */
    private String itineraryText;

    /** 费用包含（富文本） */
    private String costIncludes;

    /** 费用不含（富文本） */
    private String costExcludes;

    /** 预订须知/退改政策（富文本） */
    private String bookingNotes;

    /** 多图JSON */
    private String imagesJson;

    /** 状态（0正常 1停用） */
    private String status;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getGroupId()
    {
        return groupId;
    }

    public void setGroupId(Long groupId)
    {
        this.groupId = groupId;
    }

    public String getHighlights()
    {
        return highlights;
    }

    public void setHighlights(String highlights)
    {
        this.highlights = highlights;
    }

    public String getItineraryText()
    {
        return itineraryText;
    }

    public void setItineraryText(String itineraryText)
    {
        this.itineraryText = itineraryText;
    }

    public String getCostIncludes()
    {
        return costIncludes;
    }

    public void setCostIncludes(String costIncludes)
    {
        this.costIncludes = costIncludes;
    }

    public String getCostExcludes()
    {
        return costExcludes;
    }

    public void setCostExcludes(String costExcludes)
    {
        this.costExcludes = costExcludes;
    }

    public String getBookingNotes()
    {
        return bookingNotes;
    }

    public void setBookingNotes(String bookingNotes)
    {
        this.bookingNotes = bookingNotes;
    }

    public String getImagesJson()
    {
        return imagesJson;
    }

    public void setImagesJson(String imagesJson)
    {
        this.imagesJson = imagesJson;
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

