package com.snow.business.northeast.domain;

import java.math.BigDecimal;
import com.snow.common.core.domain.BaseEntity;

/**
 * 东北景点主表 northeast_attraction
 */
public class NortheastAttraction extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private String code;
    private String name;
    private String alias;
    private String province;
    private String city;
    private String district;
    private String address;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private String level;
    private String themeTags;
    private String seasonTags;
    private String bestMonths;
    private String openHours;
    private BigDecimal durationHours;
    private BigDecimal ticketPrice;
    private String transportation;
    private String crowdLevel;
    private String suitableFor;
    private String summary;
    private String highlights;
    private String travelTips;
    private String imageUrl;
    private Integer status;
    private String source;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getAlias() { return alias; }
    public void setAlias(String alias) { this.alias = alias; }
    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public BigDecimal getLatitude() { return latitude; }
    public void setLatitude(BigDecimal latitude) { this.latitude = latitude; }
    public BigDecimal getLongitude() { return longitude; }
    public void setLongitude(BigDecimal longitude) { this.longitude = longitude; }
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    public String getThemeTags() { return themeTags; }
    public void setThemeTags(String themeTags) { this.themeTags = themeTags; }
    public String getSeasonTags() { return seasonTags; }
    public void setSeasonTags(String seasonTags) { this.seasonTags = seasonTags; }
    public String getBestMonths() { return bestMonths; }
    public void setBestMonths(String bestMonths) { this.bestMonths = bestMonths; }
    public String getOpenHours() { return openHours; }
    public void setOpenHours(String openHours) { this.openHours = openHours; }
    public BigDecimal getDurationHours() { return durationHours; }
    public void setDurationHours(BigDecimal durationHours) { this.durationHours = durationHours; }
    public BigDecimal getTicketPrice() { return ticketPrice; }
    public void setTicketPrice(BigDecimal ticketPrice) { this.ticketPrice = ticketPrice; }
    public String getTransportation() { return transportation; }
    public void setTransportation(String transportation) { this.transportation = transportation; }
    public String getCrowdLevel() { return crowdLevel; }
    public void setCrowdLevel(String crowdLevel) { this.crowdLevel = crowdLevel; }
    public String getSuitableFor() { return suitableFor; }
    public void setSuitableFor(String suitableFor) { this.suitableFor = suitableFor; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public String getHighlights() { return highlights; }
    public void setHighlights(String highlights) { this.highlights = highlights; }
    public String getTravelTips() { return travelTips; }
    public void setTravelTips(String travelTips) { this.travelTips = travelTips; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }
}
