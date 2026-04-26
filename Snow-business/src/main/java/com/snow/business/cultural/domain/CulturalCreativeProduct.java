package com.snow.business.cultural.domain;

import java.math.BigDecimal;
import com.snow.common.annotation.Excel;
import com.snow.common.core.domain.BaseEntity;

/**
 * 文创商品主表 cultural_creative_products
 */
public class CulturalCreativeProduct extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    @Excel(name = "商品编码")
    private String productCode;
    @Excel(name = "商品名称")
    private String title;
    private String subTitle;
    private String categoryCode;
    @Excel(name = "分类")
    private String categoryName;
    @Excel(name = "售价")
    private BigDecimal price;
    private BigDecimal marketPrice;
    @Excel(name = "库存")
    private Integer stock;
    @Excel(name = "销量")
    private Integer salesCount;
    private String coverImage;
    private String imagesJson;
    private String specJson;
    private String serviceJson;
    @Excel(name = "评论数")
    private Integer reviewCount;
    @Excel(name = "评分")
    private BigDecimal reviewScore;
    private Integer sortOrder;
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public String getProductCode()
    {
        return productCode;
    }

    public void setProductCode(String productCode)
    {
        this.productCode = productCode;
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

    public String getCategoryCode()
    {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode)
    {
        this.categoryCode = categoryCode;
    }

    public String getCategoryName()
    {
        return categoryName;
    }

    public void setCategoryName(String categoryName)
    {
        this.categoryName = categoryName;
    }

    public BigDecimal getPrice()
    {
        return price;
    }

    public void setPrice(BigDecimal price)
    {
        this.price = price;
    }

    public BigDecimal getMarketPrice()
    {
        return marketPrice;
    }

    public void setMarketPrice(BigDecimal marketPrice)
    {
        this.marketPrice = marketPrice;
    }

    public Integer getStock()
    {
        return stock;
    }

    public void setStock(Integer stock)
    {
        this.stock = stock;
    }

    public Integer getSalesCount()
    {
        return salesCount;
    }

    public void setSalesCount(Integer salesCount)
    {
        this.salesCount = salesCount;
    }

    public String getCoverImage()
    {
        return coverImage;
    }

    public void setCoverImage(String coverImage)
    {
        this.coverImage = coverImage;
    }

    public String getImagesJson()
    {
        return imagesJson;
    }

    public void setImagesJson(String imagesJson)
    {
        this.imagesJson = imagesJson;
    }

    public String getSpecJson()
    {
        return specJson;
    }

    public void setSpecJson(String specJson)
    {
        this.specJson = specJson;
    }

    public String getServiceJson()
    {
        return serviceJson;
    }

    public void setServiceJson(String serviceJson)
    {
        this.serviceJson = serviceJson;
    }

    public Integer getReviewCount()
    {
        return reviewCount;
    }

    public void setReviewCount(Integer reviewCount)
    {
        this.reviewCount = reviewCount;
    }

    public BigDecimal getReviewScore()
    {
        return reviewScore;
    }

    public void setReviewScore(BigDecimal reviewScore)
    {
        this.reviewScore = reviewScore;
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
