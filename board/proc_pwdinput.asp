<%
Sort=Request("sort")
Idx=Request("idx")

pageSize=uf_getRequest(Request("pageSize"),"int","","10")
page=uf_getRequest(Request("page"),"int","","1")

BBSCode=Request("BBSCode")
Search=Request("Search")
searchStr=Request("searchStr")
serstoreidx=Request("serstoreidx")
seritemidx=Request("seritemidx")
serboardsort=Request("serboardsort")

Call HK_BBSSetup(BBsCode)
BBsViewModeChk("write")
BbsAdminChk()
%>