package com.snow.business.northeast.domain;

import java.math.BigDecimal;
import com.snow.common.core.domain.BaseEntity;

/**
 * 东北景点关联关系表 northeast_attraction_relation
 */
public class NortheastAttractionRelation extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private String fromAttractionCode;
    private String toAttractionCode;
    private String relationType;
    private BigDecimal distanceKm;
    private Integer travelMinutes;
    private Integer sortOrder;
    private String remark;
    private Integer status;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getFromAttractionCode() { return fromAttractionCode; }
    public void setFromAttractionCode(String fromAttractionCode) { this.fromAttractionCode = fromAttractionCode; }
    public String getToAttractionCode() { return toAttractionCode; }
    public void setToAttractionCode(String toAttractionCode) { this.toAttractionCode = toAttractionCode; }
    public String getRelationType() { return relationType; }
    public void setRelationType(String relationType) { this.relationType = relationType; }
    public BigDecimal getDistanceKm() { return distanceKm; }
    public void setDistanceKm(BigDecimal distanceKm) { this.distanceKm = distanceKm; }
    public Integer getTravelMinutes() { return travelMinutes; }
    public void setTravelMinutes(Integer travelMinutes) { this.travelMinutes = travelMinutes; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
}
