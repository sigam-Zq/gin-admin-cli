package api

import (
	"{{.RootImportPath}}/internal/library/utils"
	"{{.ModuleImportPath}}/biz"
	"{{.ModuleImportPath}}/schema"
	"github.com/gin-gonic/gin"
)

{{$name := .Name}}

{{with .Comment}}// {{.}}{{else}}// {{$name}} api{{end}}
type {{$name}} struct {
	{{$name}}BIZ *biz.{{$name}}
}

// @Tags {{$name}}API
// @Security ApiKeyAuth
// @Summary Query {{lowerSpace .Name}} list
{{- if not .DisablePagination}}
// @Param current query int true "pagination index" default(1)
// @Param pageSize query int true "pagination size" default(10)
{{- end}}
{{- range .Fields}}{{$fieldType := .Type}}
{{- with .Query}}
{{- if .InQuery}}
// @Param {{.FormTag}} query {{convSwaggerType $fieldType}} false "{{.Comment}}"
{{- end}}
{{- end}}
{{- end}}
// @Success 200 {object} utils.ResponseResult{data=[]schema.{{$name}}}
// @Failure 401 {object} utils.ResponseResult
// @Failure 500 {object} utils.ResponseResult
// @Router /api/v1/{{lowerPlural .Name}} [get]
func (a *{{$name}}) Query(c *gin.Context) {
	ctx := c.Request.Context()
	var params schema.{{$name}}QueryParam
	if err := utils.ParseQuery(c, &params); err != nil {
		utils.ResError(c, err)
		return
	}

	result, err := a.{{$name}}BIZ.Query(ctx, params)
	if err != nil {
		utils.ResError(c, err)
		return
	}
	utils.ResPage(c, result.Data, result.PageResult)
}

// @Tags {{$name}}API
// @Security ApiKeyAuth
// @Summary Get {{lowerSpace .Name}} record by ID
// @Param id path string true "unique id"
// @Success 200 {object} utils.ResponseResult{data=schema.{{$name}}}
// @Failure 401 {object} utils.ResponseResult
// @Failure 500 {object} utils.ResponseResult
// @Router /api/v1/{{lowerPlural .Name}}/{id} [get]
func (a *{{$name}}) Get(c *gin.Context) {
	ctx := c.Request.Context()
	item, err := a.{{$name}}BIZ.Get(ctx, c.Param("id"))
	if err != nil {
		utils.ResError(c, err)
		return
	}
	utils.ResSuccess(c, item)
}

// @Tags {{$name}}API
// @Security ApiKeyAuth
// @Summary Create {{lowerSpace .Name}} record
// @Param body body schema.{{$name}}Save true "Request body"
// @Success 200 {object} utils.ResponseResult{data=schema.{{$name}}}
// @Failure 400 {object} utils.ResponseResult
// @Failure 401 {object} utils.ResponseResult
// @Failure 500 {object} utils.ResponseResult
// @Router /api/v1/{{lowerPlural .Name}} [post]
func (a *{{$name}}) Create(c *gin.Context) {
	ctx := c.Request.Context()
	item := new(schema.{{$name}}Save)
	if err := utils.ParseJSON(c, item); err != nil {
		utils.ResError(c, err)
		return
	} else if err := item.Validate(); err != nil {
		utils.ResError(c, err)
		return
	}

	result, err := a.{{$name}}BIZ.Create(ctx, item)
	if err != nil {
		utils.ResError(c, err)
		return
	}
	utils.ResSuccess(c, result)
}

// @Tags {{$name}}API
// @Security ApiKeyAuth
// @Summary Update {{lowerSpace .Name}} record by ID
// @Param id path string true "unique id"
// @Param body body schema.{{$name}}Save true "Request body"
// @Success 200 {object} utils.ResponseResult
// @Failure 400 {object} utils.ResponseResult
// @Failure 401 {object} utils.ResponseResult
// @Failure 500 {object} utils.ResponseResult
// @Router /api/v1/{{lowerPlural .Name}}/{id} [put]
func (a *{{$name}}) Update(c *gin.Context) {
	ctx := c.Request.Context()
	item := new(schema.{{$name}}Save)
	if err := utils.ParseJSON(c, item); err != nil {
		utils.ResError(c, err)
		return
	} else if err := item.Validate(); err != nil {
		utils.ResError(c, err)
		return
	}

	err := a.{{$name}}BIZ.Update(ctx, c.Param("id"), item)
	if err != nil {
		utils.ResError(c, err)
		return
	}
	utils.ResOK(c)
}

// @Tags {{$name}}API
// @Security ApiKeyAuth
// @Summary Delete {{lowerSpace .Name}} record by ID
// @Param id path string true "unique id"
// @Success 200 {object} utils.ResponseResult
// @Failure 401 {object} utils.ResponseResult
// @Failure 500 {object} utils.ResponseResult
// @Router /api/v1/{{lowerPlural .Name}}/{id} [delete]
func (a *{{$name}}) Delete(c *gin.Context) {
	ctx := c.Request.Context()
	err := a.{{$name}}BIZ.Delete(ctx, c.Param("id"))
	if err != nil {
		utils.ResError(c, err)
		return
	}
	utils.ResOK(c)
}