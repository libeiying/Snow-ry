package com.snow.web.controller.business;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.snow.business.nh.domain.NhHeritage;
import com.snow.business.nh.service.INhHeritageService;
import com.snow.common.annotation.Anonymous;
import com.snow.common.annotation.Log;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;
import com.snow.common.enums.BusinessType;
import com.snow.framework.config.ServerConfig;
import com.snow.framework.web.service.OssUploadService;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Heritage management API.
 */
@RestController
@RequestMapping("/api/nh/heritage")
public class NhHeritageController extends BaseController
{
    @Autowired
    private INhHeritageService nhHeritageService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private OssUploadService ossUploadService;

    /**
     * Query heritage list with pagination.
     */
    @Anonymous
    @GetMapping("/page")
    public TableDataInfo page(NhHeritage nhHeritage)
    {
        startPage();
        TableDataInfo table = getDataTable(nhHeritageService.selectNhHeritageList(nhHeritage));
        String baseUrl = serverConfig.getUrl();
        List<?> rows = table.getRows();
        if (rows != null)
        {
            for (Object row : rows)
            {
                if (row instanceof NhHeritage)
                {
                    NhHeritage item = (NhHeritage) row;
                    item.setCoverImage(ossUploadService.resolveForApi(baseUrl, item.getCoverImage()));
                    item.setImagesJson(ossUploadService.resolveJsonArrayText(baseUrl, item.getImagesJson()));
                }
            }
        }
        return table;
    }

    /**
     * Query heritage detail.
     */
    @Anonymous
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        NhHeritage data = nhHeritageService.selectNhHeritageById(id);
        if (data == null)
        {
            return AjaxResult.error("Record not found");
        }
        return AjaxResult.success(toDetail(data, serverConfig.getUrl()));
    }

    /**
     * Create heritage.
     */
    @Anonymous
    @Log(title = "Heritage", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody HeritageSaveReq req)
    {
        return toAjax(nhHeritageService.insertNhHeritage(req.toEntity()));
    }

    /**
     * Update heritage.
     */
    @Anonymous
    @Log(title = "Heritage", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}")
    public AjaxResult edit(@PathVariable("id") Long id, @RequestBody HeritageSaveReq req)
    {
        NhHeritage data = req.toEntity();
        data.setId(id);
        return toAjax(nhHeritageService.updateNhHeritage(data));
    }

    /**
     * Change heritage status.
     */
    @Anonymous
    @Log(title = "Heritage", businessType = BusinessType.UPDATE)
    @PatchMapping("/{id}/status")
    public AjaxResult changeStatus(@PathVariable("id") Long id, @RequestBody HeritageStatusReq req)
    {
        return toAjax(nhHeritageService.updateNhHeritageStatus(id, req.getStatus(), null));
    }

    /**
     * Logical delete by id.
     */
    @Anonymous
    @Log(title = "Heritage", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public AjaxResult remove(@PathVariable("id") Long id)
    {
        return toAjax(nhHeritageService.deleteNhHeritageById(id));
    }

    /**
     * Logical batch delete.
     */
    @Anonymous
    @Log(title = "Heritage", businessType = BusinessType.DELETE)
    @PostMapping("/batch-delete")
    public AjaxResult batchDelete(@RequestBody HeritageBatchDeleteReq req)
    {
        Long[] ids = req.getIds();
        return toAjax(nhHeritageService.deleteNhHeritageByIds(ids));
    }

    private Map<String, Object> toDetail(NhHeritage data, String baseUrl)
    {
        Map<String, Object> detail = new LinkedHashMap<>();
        detail.put("id", data.getId());
        detail.put("heritageCode", data.getHeritageCode());
        detail.put("name", data.getName());
        detail.put("category", data.getCategory());
        detail.put("region", data.getRegion());
        detail.put("level", data.getLevel());
        detail.put("inheritor", data.getInheritor());
        detail.put("description", data.getDescription());
        detail.put("imagesJson", parseImages(baseUrl, data.getImagesJson()));
        detail.put("status", data.getStatus());
        detail.put("remark", data.getRemark());
        detail.put("coverImage", ossUploadService.resolveForApi(baseUrl, data.getCoverImage()));
        detail.put("createBy", data.getCreateBy());
        detail.put("createTime", data.getCreateTime());
        detail.put("updateBy", data.getUpdateBy());
        detail.put("updateTime", data.getUpdateTime());
        return detail;
    }

    private JSONArray parseImages(String baseUrl, String imagesJson)
    {
        if (imagesJson == null || imagesJson.isEmpty())
        {
            return new JSONArray();
        }
        return ossUploadService.resolveJsonArray(baseUrl, JSON.parseArray(imagesJson));
    }

    public static class HeritageSaveReq
    {
        private String heritageCode;
        private String name;
        private String category;
        private String region;
        private String level;
        private String inheritor;
        private String description;
        private List<String> imagesJson;
        private String status;
        private String remark;
        private String coverImage;

        public NhHeritage toEntity()
        {
            NhHeritage data = new NhHeritage();
            data.setHeritageCode(this.heritageCode);
            data.setName(this.name);
            data.setCategory(this.category);
            data.setRegion(this.region);
            data.setLevel(this.level);
            data.setInheritor(this.inheritor);
            data.setDescription(this.description);
            data.setImagesJson(this.imagesJson == null ? "[]" : JSON.toJSONString(this.imagesJson));
            data.setStatus(this.status);
            data.setRemark(this.remark);
            data.setCoverImage(this.coverImage);
            return data;
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

        public List<String> getImagesJson()
        {
            return imagesJson;
        }

        public void setImagesJson(List<String> imagesJson)
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

        public String getRemark()
        {
            return remark;
        }

        public void setRemark(String remark)
        {
            this.remark = remark;
        }

        public String getCoverImage()
        {
            return coverImage;
        }

        public void setCoverImage(String coverImage)
        {
            this.coverImage = coverImage;
        }
    }

    public static class HeritageStatusReq
    {
        private String status;

        public String getStatus()
        {
            return status;
        }

        public void setStatus(String status)
        {
            this.status = status;
        }
    }

    public static class HeritageBatchDeleteReq
    {
        private Long[] ids;

        public Long[] getIds()
        {
            return ids;
        }

        public void setIds(Long[] ids)
        {
            this.ids = ids;
        }
    }
}
