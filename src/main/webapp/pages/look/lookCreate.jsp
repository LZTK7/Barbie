<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Wardrobe" %>
<%@ page import="com.barbie.dao.WardrobeDao" %>
<%@ page import="com.barbie.model.User" %>
<%@ page import="com.barbie.util.SessionUtil" %>
<%
    User user = SessionUtil.getLoginUser(request.getSession());
    WardrobeDao wardrobeDao = new WardrobeDao();
    List<Wardrobe> wardrobeList = wardrobeDao.findByUserId(user.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>创建搭配 - Barbie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header h2 { font-size: 20px; }
        .back-btn { color: #666; text-decoration: none; font-size: 14px; }
        .form-box { background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 14px; font-weight: bold; color: #333; margin-bottom: 4px; }
        .form-group label .required { color: #ff6b81; }
        .form-group input, .form-group select { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; box-sizing: border-box; }
        .wardrobe-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-top: 8px; max-height: 300px; overflow-y: auto; }
        .wardrobe-item { background: #f9f9f9; border: 2px solid #e8e8e8; border-radius: 8px; padding: 8px; text-align: center; cursor: pointer; transition: all 0.3s; }
        .wardrobe-item:hover { border-color: #ff6b81; }
        .wardrobe-item.selected { border-color: #ff6b81; background: #fff0f2; }
        .wardrobe-item img { width: 100%; height: 80px; object-fit: cover; border-radius: 4px; background: #f0f0f0; }
        .wardrobe-item .item-name { font-size: 12px; margin-top: 4px; }
        .wardrobe-item .item-category { font-size: 10px; color: #999; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
        .btn-submit { width: 100%; padding: 12px; background: #ff6b81; color: white; border: none; border-radius: 6px; font-size: 16px; cursor: pointer; }
        .btn-submit:hover { background: #e8556b; }
        .hint { font-size: 12px; color: #999; margin-top: 8px; }
        .selected-count { font-size: 14px; color: #ff6b81; font-weight: bold; }
        .wardrobe-empty { grid-column: 1/4; text-align: center; color: #999; padding: 20px; }
        .wardrobe-empty a { color: #ff6b81; text-decoration: none; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>✨ 创建搭配</h2>
        <a href="${pageContext.request.contextPath}/look/list" class="back-btn">← 返回</a>
    </div>

    <div class="form-box">
        <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/look/create" method="post" id="lookForm">
            <div class="form-group">
                <label>搭配名称 <span class="required">*</span></label>
                <input type="text" name="name" placeholder="如：通勤约会两穿" required>
            </div>

            <div class="form-group">
                <label>选择衣服 <span class="required">*</span> <span class="selected-count" id="countDisplay">已选 0 件（至少选2件）</span></label>
                <div class="wardrobe-grid" id="wardrobeGrid">
                    <%
                        if (wardrobeList == null || wardrobeList.isEmpty()) {
                    %>
                    <div class="wardrobe-empty">
                        🈳 衣橱是空的，请先去 <a href="${pageContext.request.contextPath}/pages/wardrobe/wardrobeImport.jsp">导入衣服</a>
                    </div>
                    <%
                    } else {
                        for (Wardrobe w : wardrobeList) {
                            String imgPath = w.getImages();
                            if (imgPath != null && !imgPath.isEmpty() && !imgPath.startsWith("uploads/")) {
                                imgPath = "uploads/" + imgPath;
                            }
                    %>
                    <div class="wardrobe-item" data-id="<%= w.getId() %>" onclick="toggleSelect(this)">
                        <img src="${pageContext.request.contextPath}/<%= imgPath %>" alt="<%= w.getName() %>">
                        <div class="item-name"><%= w.getName() %></div>
                        <div class="item-category"><%= w.getCategory() %></div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
                <div class="hint">💡 点击选择衣服，再次点击取消选择（2~6件）</div>
            </div>

            <div class="form-group">
                <label>场景</label>
                <select name="scene">
                    <option value="">请选择（选填）</option>
                    <option value="通勤">通勤</option>
                    <option value="街头">街头</option>
                    <option value="约会">约会</option>
                    <option value="运动">运动</option>
                    <option value="度假">度假</option>
                </select>
            </div>

            <div class="form-group">
                <label>季节</label>
                <select name="season">
                    <option value="">请选择（选填）</option>
                    <option value="春">春</option>
                    <option value="夏">夏</option>
                    <option value="秋">秋</option>
                    <option value="冬">冬</option>
                    <option value="四季">四季</option>
                </select>
            </div>

            <input type="hidden" name="wardrobeIds" id="wardrobeIds" value="">

            <button type="submit" class="btn-submit" onclick="return prepareSubmit()">💾 保存搭配</button>
        </form>
    </div>
</div>

<script>
    var selectedIds = [];

    function toggleSelect(element) {
        var id = element.dataset.id;
        var index = selectedIds.indexOf(id);
        if (index > -1) {
            selectedIds.splice(index, 1);
            element.classList.remove('selected');
        } else {
            if (selectedIds.length >= 6) {
                alert('最多选择6件衣服');
                return;
            }
            selectedIds.push(id);
            element.classList.add('selected');
        }
        var count = selectedIds.length;
        document.getElementById('countDisplay').textContent = '已选 ' + count + ' 件（' + (count >= 2 ? '✅ 可以创建' : '至少选2件') + '）';
    }

    function prepareSubmit() {
        if (selectedIds.length < 2) {
            alert('请至少选择2件衣服');
            return false;
        }
        document.getElementById('wardrobeIds').value = selectedIds.join(',');
        return true;
    }
</script>
</body>
</html>