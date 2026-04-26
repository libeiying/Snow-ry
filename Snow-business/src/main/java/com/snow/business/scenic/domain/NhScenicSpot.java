package com.snow.business.scenic.domain;

import com.snow.common.core.domain.BaseEntity;

/**
 * Scenic spot entity for nh_scenic_spot.
 *
 * Columns: id, spot_name, city, spot_content, images_json
 */
public class NhScenicSpot extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;

    private String spotName;

    private String city;

    private String spotContent;

    /** JSON array string in DB. */
    private String imagesJson;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public String getSpotName()
    {
        return spotName;
    }

    public void setSpotName(String spotName)
    {
        this.spotName = spotName;
    }

    public String getCity()
    {
        return city;
    }

    public void setCity(String city)
    {
        this.city = city;
    }

    public String getSpotContent()
    {
        return spotContent;
    }

    public void setSpotContent(String spotContent)
    {
        this.spotContent = spotContent;
    }

    public String getImagesJson()
    {
        return imagesJson;
    }

    public void setImagesJson(String imagesJson)
    {
        this.imagesJson = imagesJson;
    }
}
