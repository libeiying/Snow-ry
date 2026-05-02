package com.snow.business.northeast.domain;

import java.math.BigDecimal;
import com.snow.common.core.domain.BaseEntity;

/**
 * 东北路线模板表 northeast_route_template
 */
public class NortheastRouteTemplate extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private String templateCode;
    private String title;
    private String province;
    private String city;
    private String routeType;
    private Integer days;
    private Integer nights;
    private String seasonTags;
    private String themeTags;
    private BigDecimal budgetMin;
    private BigDecimal budgetMax;
    private String suitableFor;
    private String summary;
    private String highlights;
    private String dailyPlanJson;
    private String attractionCodes;
    private String transportSuggestion;
    private BigDecimal estimatedCost;
    private Integer status;
    private String source;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTemplateCode() { return templateCode; }
    public void setTemplateCode(String templateCode) { this.templateCode = templateCode; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getRouteType() { return routeType; }
    public void setRouteType(String routeType) { this.routeType = routeType; }
    public Integer getDays() { return days; }
    public void setDays(Integer days) { this.days = days; }
    public Integer getNights() { return nights; }
    public void setNights(Integer nights) { this.nights = nights; }
    public String getSeasonTags() { return seasonTags; }
    public void setSeasonTags(String seasonTags) { this.seasonTags = seasonTags; }
    public String getThemeTags() { return themeTags; }
    public void setThemeTags(String themeTags) { this.themeTags = themeTags; }
    public BigDecimal getBudgetMin() { return budgetMin; }
    public void setBudgetMin(BigDecimal budgetMin) { this.budgetMin = budgetMin; }
    public BigDecimal getBudgetMax() { return budgetMax; }
    public void setBudgetMax(BigDecimal budgetMax) { this.budgetMax = budgetMax; }
    public String getSuitableFor() { return suitableFor; }
    public void setSuitableFor(String suitableFor) { this.suitableFor = suitableFor; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public String getHighlights() { return highlights; }
    public void setHighlights(String highlights) { this.highlights = highlights; }
    public String getDailyPlanJson() { return dailyPlanJson; }
    public void setDailyPlanJson(String dailyPlanJson) { this.dailyPlanJson = dailyPlanJson; }
    public String getAttractionCodes() { return attractionCodes; }
    public void setAttractionCodes(String attractionCodes) { this.attractionCodes = attractionCodes; }
    public String getTransportSuggestion() { return transportSuggestion; }
    public void setTransportSuggestion(String transportSuggestion) { this.transportSuggestion = transportSuggestion; }
    public BigDecimal getEstimatedCost() { return estimatedCost; }
    public void setEstimatedCost(BigDecimal estimatedCost) { this.estimatedCost = estimatedCost; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }
}
