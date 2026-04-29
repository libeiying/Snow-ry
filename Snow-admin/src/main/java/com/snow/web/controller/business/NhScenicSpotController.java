package com.snow.web.controller.business;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.snow.business.scenic.domain.NhScenicSpot;
import com.snow.business.scenic.service.INhScenicSpotService;
import com.snow.common.annotation.Anonymous;
import com.snow.common.annotation.Log;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;
import com.snow.common.enums.BusinessType;
import com.snow.framework.config.ServerConfig;
import com.snow.web.controller.business.support.MediaUrlResolver;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/scenic/spot")
public class NhScenicSpotController extends BaseController
{
    @Autowired
    private INhScenicSpotService nhScenicSpotService;
    @Autowired
    private ServerConfig serverConfig;

    @Anonymous
    @GetMapping("/page")
    public TableDataInfo page(NhScenicSpot nhScenicSpot)
    {
        startPage();
        TableDataInfo table = getDataTable(nhScenicSpotService.selectNhScenicSpotList(nhScenicSpot));
        String baseUrl = serverConfig.getUrl();
        List<?> rows = table.getRows();
        if (rows != null)
        {
            for (Object row : rows)
            {
                if (row instanceof NhScenicSpot)
                {
                    NhScenicSpot item = (NhScenicSpot) row;
                    item.setImagesJson(MediaUrlResolver.resolveJsonArrayText(baseUrl, item.getImagesJson()));
                }
            }
        }
        return table;
    }

    @Anonymous
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        NhScenicSpot data = nhScenicSpotService.selectNhScenicSpotById(id);
        if (data == null)
        {
            return AjaxResult.error("Record not found");
        }
        return AjaxResult.success(toDetail(data, serverConfig.getUrl()));
    }

    @Anonymous
    @Log(title = "ScenicSpot", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ScenicSaveReq req)
    {
        return toAjax(nhScenicSpotService.insertNhScenicSpot(req.toEntity()));
    }

    @Anonymous
    @Log(title = "ScenicSpot", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}")
    public AjaxResult edit(@PathVariable("id") Long id, @RequestBody ScenicSaveReq req)
    {
        NhScenicSpot data = req.toEntity();
        data.setId(id);
        return toAjax(nhScenicSpotService.updateNhScenicSpot(data));
    }

    @Anonymous
    @Log(title = "ScenicSpot", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public AjaxResult remove(@PathVariable("id") Long id)
    {
        return toAjax(nhScenicSpotService.deleteNhScenicSpotById(id));
    }

    @Anonymous
    @Log(title = "ScenicSpot", businessType = BusinessType.DELETE)
    @PostMapping("/batch-delete")
    public AjaxResult batchDelete(@RequestBody BatchDeleteReq req)
    {
        return toAjax(nhScenicSpotService.deleteNhScenicSpotByIds(req.getIds()));
    }

    private Map<String, Object> toDetail(NhScenicSpot data, String baseUrl)
    {
        Map<String, Object> detail = new LinkedHashMap<>();
        detail.put("id", data.getId());
        detail.put("spotName", data.getSpotName());
        detail.put("city", data.getCity());
        detail.put("spotContent", data.getSpotContent());
        detail.put("imagesJson", parseImages(baseUrl, data.getImagesJson()));
        return detail;
    }

    private JSONArray parseImages(String baseUrl, String imagesJson)
    {
        if (imagesJson == null || imagesJson.isEmpty())
        {
            return new JSONArray();
        }
        return MediaUrlResolver.resolveJsonArray(baseUrl, JSON.parseArray(imagesJson));
    }

    public static class ScenicSaveReq
    {
        private String spotName;
        private String city;
        private String spotContent;
        private List<String> imagesJson;

        public NhScenicSpot toEntity()
        {
            NhScenicSpot data = new NhScenicSpot();
            data.setSpotName(this.spotName);
            data.setCity(this.city);
            data.setSpotContent(this.spotContent);
            data.setImagesJson(this.imagesJson == null ? "[]" : JSON.toJSONString(this.imagesJson));
            return data;
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

        public List<String> getImagesJson()
        {
            return imagesJson;
        }

        public void setImagesJson(List<String> imagesJson)
        {
            this.imagesJson = imagesJson;
        }
    }

    public static class BatchDeleteReq
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
