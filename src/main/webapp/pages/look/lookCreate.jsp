<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Wardrobe" %>
<%@ page import="com.barbie.dao.WardrobeDao" %>
<%@ page import="com.barbie.model.User" %>
<%@ page import="com.barbie.util.SessionUtil" %>
<%
    User user = SessionUtil.getLoginUser(request.getSession());
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/user/login.jsp");
        return;
    }
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
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; height: 100vh; overflow: hidden; }

        .app { display: flex; height: 100vh; }

        .preview-area {
            flex: 1;
            background: white;
            padding: 20px;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            border-right: 2px solid #f0f0f0;
        }
        .preview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .preview-header h2 { font-size: 18px; color: #333; }
        .preview-header .hint-text { font-size: 12px; color: #999; }

        .look-name-input {
            font-size: 18px;
            font-weight: bold;
            border: none;
            border-bottom: 2px dashed #ddd;
            padding: 4px 8px;
            width: 200px;
            outline: none;
            background: transparent;
        }
        .look-name-input:focus { border-bottom-color: #ff6b81; }

        .mannequin {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 20px 0;
            min-height: 400px;
        }
        .zone {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            border-radius: 10px;
            min-height: 90px;
            width: 100%;
            max-width: 420px;
            border: 2px dashed #eee;
            transition: all 0.3s;
            background: #fafafa;
        }
        .zone-head { border-color: #ffd93d; background: #fffbee; }
        .zone-body { border-color: #6bcbff; background: #f0f8ff; min-height: 150px; }
        .zone-foot { border-color: #ff6b81; background: #fff0f2; }

        .zone-label {
            font-size: 11px;
            color: #ccc;
            letter-spacing: 2px;
            width: 100%;
            text-align: center;
        }
        .zone .empty-slot { font-size: 13px; color: #ddd; }

        .item-preview {
            background: white;
            border-radius: 8px;
            padding: 6px 10px;
            text-align: center;
            border: 2px solid #eee;
            width: 70px;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
        }
        .item-preview:hover { border-color: #ff6b81; transform: scale(1.05); }
        .item-preview img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
            background: #f0f0f0;
        }
        .item-preview .name { font-size: 10px; color: #333; margin-top: 2px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .item-preview .remove {
            position: absolute;
            top: -6px;
            right: -6px;
            background: #ff6b81;
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 12px;
            line-height: 18px;
            text-align: center;
            cursor: pointer;
            display: none;
        }
        .item-preview:hover .remove { display: block; }
        .item-preview.pending { border-color: #4ecdc4; background: #f0fffe; }
        .badge-preview { font-size: 8px; padding: 1px 6px; border-radius: 8px; color: white; display: inline-block; }
        .badge-owned { background: #6c757d; }
        .badge-pending { background: #4ecdc4; }

        .preview-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 12px;
            border-top: 1px solid #f0f0f0;
            margin-top: auto;
        }
        .preview-footer .info { font-size: 13px; color: #666; }
        .preview-footer .info span { color: #ff6b81; font-weight: bold; }
        .btn-save {
            padding: 10px 32px;
            background: #ff6b81;
            color: white;
            border: none;
            border-radius: 20px;
            font-size: 15px;
            cursor: pointer;
        }
        .btn-save:hover { background: #e8556b; }

        .panel-area {
            width: 420px;
            background: white;
            padding: 20px;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }
        .panel-area h3 { font-size: 15px; color: #333; margin-bottom: 12px; }

        .filter-tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 12px;
        }
        .filter-tabs button {
            padding: 4px 14px;
            border-radius: 14px;
            border: 1px solid #ddd;
            background: white;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .filter-tabs button:hover { border-color: #ff6b81; }
        .filter-tabs button.active { background: #ff6b81; color: white; border-color: #ff6b81; }

        .wardrobe-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
            max-height: 300px;
            overflow-y: auto;
            padding-right: 4px;
            margin-bottom: 12px;
        }
        .wardrobe-grid .item-card {
            background: #f9f9f9;
            border-radius: 8px;
            padding: 6px;
            text-align: center;
            border: 2px solid #eee;
            cursor: pointer;
            transition: all 0.3s;
        }
        .wardrobe-grid .item-card:hover { border-color: #ff6b81; transform: scale(1.03); }
        .wardrobe-grid .item-card.added {
            border-color: #ff6b81;
            background: #fff0f2;
        }
        .wardrobe-grid .item-card img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
            background: #f0f0f0;
        }
        .wardrobe-grid .item-card .name { font-size: 10px; color: #333; margin-top: 2px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .wardrobe-grid .item-card .category { font-size: 9px; color: #999; }
        .wardrobe-grid .item-card .status-text { font-size: 9px; color: #ff6b81; margin-top: 2px; }

        .search-area { display: flex; gap: 8px; margin-bottom: 12px; }
        .search-area input { flex: 1; padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; }
        .search-area button { padding: 8px 16px; background: #ff6b81; color: white; border: none; border-radius: 6px; cursor: pointer; }
        .search-area button:hover { background: #e8556b; }

        .search-results {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 8px;
            max-height: 160px;
            overflow-y: auto;
        }
        .search-result-item {
            background: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 4px;
            text-align: center;
            font-size: 11px;
        }
        .search-result-item img { width: 40px; height: 40px; object-fit: cover; border-radius: 4px; }
        .search-result-item .price { color: #ff6b81; font-weight: bold; }
        .search-result-item .add-btn {
            background: #4ecdc4;
            color: white;
            border: none;
            border-radius: 3px;
            padding: 2px 8px;
            cursor: pointer;
            font-size: 10px;
        }
        .search-result-item .add-btn:hover { background: #3bbdb5; }
        .search-result-item .added-badge { font-size: 9px; color: #4ecdc4; }

        .empty-text { color: #999; font-size: 13px; text-align: center; padding: 20px 0; }

        .back-link { margin-top: 12px; text-align: center; }
        .back-link a { color: #999; text-decoration: none; font-size: 13px; }
        .back-link a:hover { color: #666; }

        .scene-season {
            display: flex;
            gap: 12px;
            margin-top: 8px;
        }
        .scene-season select {
            flex: 1;
            padding: 6px 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 13px;
        }

        @media (max-width: 900px) {
            .app { flex-direction: column; }
            .panel-area { width: 100%; max-height: 50vh; }
            .preview-area { max-height: 50vh; }
        }
    </style>
</head>
<body>

<div class="app">
    <!-- ===== 左侧预览区 ===== -->
    <div class="preview-area">
        <div class="preview-header">
            <h2>👀 实时预览</h2>
            <div class="actions">
                <span class="hint-text">💡 点击左侧衣服可移除</span>
            </div>
        </div>

        <div class="look-name-input" id="lookNameInput" contenteditable="true" placeholder="输入搭配名称...">我的搭配</div>

        <div class="mannequin" id="mannequin">
            <div class="zone zone-head" id="zoneHead">
                <div class="zone-label">— 头部 —</div>
                <div class="empty-slot">点击右侧添加帽子/头饰</div>
            </div>
            <div class="zone zone-body" id="zoneBody">
                <div class="zone-label">— 身体 —</div>
                <div class="empty-slot">点击右侧添加上装/外套/下装</div>
            </div>
            <div class="zone zone-foot" id="zoneFoot">
                <div class="zone-label">— 脚部 —</div>
                <div class="empty-slot">点击右侧添加鞋子/袜子</div>
            </div>
        </div>

        <div class="preview-footer">
            <div class="info">已选: <span id="totalCount">0</span> 件 &nbsp;|&nbsp; 待购: <span id="pendingCount">0</span> 件</div>
            <div>
                <span style="font-size:13px;color:#666;margin-right:12px;">待购合计: ¥<span id="previewTotal">0</span></span>
                <button class="btn-save" onclick="saveLook()">💾 保存搭配</button>
            </div>
        </div>
    </div>

    <!-- ===== 右侧操作区 ===== -->
    <div class="panel-area">
        <h3>👔 我的衣橱</h3>

        <div class="filter-tabs" id="filterTabs">
            <button class="active" data-filter="all" onclick="filterWardrobe('all')">全部</button>
            <button data-filter="上装" onclick="filterWardrobe('上装')">上装</button>
            <button data-filter="下装" onclick="filterWardrobe('下装')">下装</button>
            <button data-filter="外套" onclick="filterWardrobe('外套')">外套</button>
            <button data-filter="连衣裙" onclick="filterWardrobe('连衣裙')">连衣裙</button>
            <button data-filter="鞋" onclick="filterWardrobe('鞋')">鞋</button>
            <button data-filter="包" onclick="filterWardrobe('包')">包</button>
            <button data-filter="配饰" onclick="filterWardrobe('配饰')">配饰</button>
        </div>

        <div class="wardrobe-grid" id="wardrobeGrid"></div>

        <h3>🔍 搜索待购</h3>
        <div class="search-area">
            <input type="text" id="searchKeyword" placeholder="搜索商品..." onkeyup="if(event.keyCode==13) searchProducts()">
            <button type="button" onclick="searchProducts()">搜索</button>
        </div>
        <div class="search-results" id="searchResults"><div class="empty-text">搜索平台商品，添加到搭配</div></div>

        <div style="margin-top:12px;">
            <label style="font-size:13px;font-weight:bold;">场景</label>
            <div class="scene-season">
                <select id="sceneSelect">
                    <option value="">请选择</option>
                    <option value="通勤">通勤</option>
                    <option value="街头">街头</option>
                    <option value="约会">约会</option>
                    <option value="运动">运动</option>
                    <option value="度假">度假</option>
                </select>
                <select id="seasonSelect">
                    <option value="">请选择</option>
                    <option value="春">春</option>
                    <option value="夏">夏</option>
                    <option value="秋">秋</option>
                    <option value="冬">冬</option>
                    <option value="四季">四季</option>
                </select>
            </div>
        </div>

        <div class="back-link">
            <a href="${pageContext.request.contextPath}/look/list">← 返回搭配列表</a>
        </div>
    </div>
</div>

<!-- 隐藏字段 -->
<input type="hidden" id="wardrobeIds" value="">
<input type="hidden" id="pendingIds" value="">

<script>
    // ===== 状态管理 =====
    var ownedIds = [];
    var pendingIds = [];
    var pendingProducts = [];
    var allWardrobe = [];
    var currentFilter = 'all';
    var pendingSearchResults = [];

    // ===== 初始化衣橱数据 =====
    <%
        StringBuilder jsWardrobe = new StringBuilder("[");
        if (wardrobeList != null) {
            for (int i = 0; i < wardrobeList.size(); i++) {
                Wardrobe w = wardrobeList.get(i);
                String imgPath = w.getImages();
                if (imgPath != null && !imgPath.isEmpty() && !imgPath.startsWith("uploads/")) {
                    imgPath = "uploads/" + imgPath;
                }
                if (i > 0) jsWardrobe.append(",");
                jsWardrobe.append("{id:").append(w.getId())
                         .append(",name:'").append(w.getName().replace("'", "\\'")).append("'")
                         .append(",category:'").append(w.getCategory()).append("'")
                         .append(",img:'").append(imgPath).append("'")
                         .append(",source:'").append(w.getSourceType()).append("'}");
            }
        }
        jsWardrobe.append("]");
    %>

    allWardrobe = <%= jsWardrobe.toString() %>;

    // ===== 渲染衣橱网格 =====
    function renderWardrobe(filter) {
        var grid = document.getElementById('wardrobeGrid');
        var filtered = filter === 'all' ? allWardrobe : allWardrobe.filter(function(w) { return w.category === filter; });
        if (filtered.length === 0) {
            grid.innerHTML = '<div class="empty-text" style="grid-column:1/5;">衣橱为空或没有此品类</div>';
            return;
        }
        var html = '';
        filtered.forEach(function(w) {
            var isAdded = ownedIds.indexOf(String(w.id)) > -1;
            var img = w.img ? w.img : '';
            html += '<div class="item-card' + (isAdded ? ' added' : '') + '" onclick="toggleOwned(' + w.id + ')" title="' + (isAdded ? '点击移除' : '点击添加') + '">';
            if (img) {
                html += '<img src="${pageContext.request.contextPath}/' + img + '" alt="' + w.name + '">';
            } else {
                html += '<div style="width:50px;height:50px;background:#f0f0f0;border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:24px;">👕</div>';
            }
            html += '<div class="name">' + w.name.substring(0, 6) + '</div>';
            html += '<div class="category">' + w.category + '</div>';
            html += '<div class="status-text">' + (isAdded ? '✅ 已添加' : '点击添加') + '</div>';
            html += '</div>';
        });
        grid.innerHTML = html;
    }

    // ===== 分类筛选 =====
    function filterWardrobe(filter) {
        currentFilter = filter;
        document.querySelectorAll('#filterTabs button').forEach(function(b) {
            b.classList.toggle('active', b.dataset.filter === filter);
        });
        renderWardrobe(filter);
    }

    // ===== 右侧点击添加/删除 =====
    function toggleOwned(id) {
        var index = ownedIds.indexOf(String(id));
        if (index > -1) {
            ownedIds.splice(index, 1);
        } else {
            if (ownedIds.length + pendingIds.length >= 6) {
                alert('最多选择6件衣服');
                return;
            }
            ownedIds.push(String(id));
        }
        renderWardrobe(currentFilter);
        renderMannequin();
        updateCounts();
    }

    // ===== 从预览移除 =====
    function removeFromPreview(id, type) {
        if (type === 'owned') {
            var idx = ownedIds.indexOf(String(id));
            if (idx > -1) ownedIds.splice(idx, 1);
        } else if (type === 'pending') {
            var idx = pendingIds.indexOf(String(id));
            if (idx > -1) {
                pendingIds.splice(idx, 1);
                pendingProducts.splice(idx, 1);
            }
        }
        renderWardrobe(currentFilter);
        renderMannequin();
        updateCounts();
        renderSearchResults();
    }

    // ===== 获取衣服详情 =====
    function getWardrobeItem(id) {
        for (var i = 0; i < allWardrobe.length; i++) {
            if (String(allWardrobe[i].id) === String(id)) return allWardrobe[i];
        }
        return null;
    }

    // ===== 渲染人台预览（全部显示，不过滤） =====
    function renderMannequin() {
        var headItems = [], bodyItems = [], footItems = [];

        // 已有衣服分类
        ownedIds.forEach(function(id) {
            var item = getWardrobeItem(id);
            if (!item) return;
            var cat = item.category;
            if (cat === '帽子' || cat === '头饰' || cat === '配饰') headItems.push(item);
            else if (cat === '袜子' || cat === '鞋') footItems.push(item);
            else bodyItems.push(item);
        });

        // 待购衣服分类
        pendingProducts.forEach(function(p) {
            var cat = p.category || '上装';
            if (cat === '帽子' || cat === '头饰' || cat === '配饰') headItems.push(p);
            else if (cat === '袜子' || cat === '鞋') footItems.push(p);
            else bodyItems.push(p);
        });

        // ✅ 不做任何过滤，全部显示（支持连衣裙+裤子叠穿）
        renderZone('zoneHead', headItems);
        renderZone('zoneBody', bodyItems);
        renderZone('zoneFoot', footItems);
    }

    function renderZone(zoneId, items) {
        var zone = document.getElementById(zoneId);
        var label = zone.querySelector('.zone-label');
        if (items.length === 0) {
            var emptyText = '暂无';
            if (zoneId === 'zoneHead') emptyText = '点击右侧添加帽子/头饰';
            else if (zoneId === 'zoneBody') emptyText = '点击右侧添加上装/外套/下装';
            else if (zoneId === 'zoneFoot') emptyText = '点击右侧添加鞋子/袜子';
            zone.innerHTML = '<div class="zone-label">' + (label ? label.textContent : '') + '</div><div class="empty-slot">' + emptyText + '</div>';
            return;
        }
        var html = '<div class="zone-label">' + (label ? label.textContent : '') + '</div>';
        items.forEach(function(item) {
            var isPending = item.source === 'pending' || item.hasOwnProperty('price');
            var id = item.id;
            var type = isPending ? 'pending' : 'owned';
            var img = item.img || '';
            if (img && !img.startsWith('uploads/') && !img.startsWith('http')) {
                img = 'uploads/' + img;
            }
            html += '<div class="item-preview' + (isPending ? ' pending' : '') + '" onclick="removeFromPreview(' + id + ', \'' + type + '\')" title="点击移除">';
            if (img) {
                html += '<img src="${pageContext.request.contextPath}/' + img + '" alt="' + item.name + '">';
            } else {
                html += '<div style="width:50px;height:50px;background:#f0f0f0;border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:24px;">👕</div>';
            }
            html += '<div class="name">' + (item.name || '商品').substring(0, 6) + '</div>';
            html += '<span class="badge-preview ' + (isPending ? 'badge-pending' : 'badge-owned') + '">' + (isPending ? '待购' : '已有') + '</span>';
            html += '<div class="remove">×</div>';
            html += '</div>';
        });
        zone.innerHTML = html;
    }

    // ===== 更新计数 =====
    function updateCounts() {
        document.getElementById('totalCount').textContent = ownedIds.length + pendingIds.length;
        document.getElementById('pendingCount').textContent = pendingIds.length;
        var total = 0;
        pendingProducts.forEach(function(p) { total += parseFloat(p.price) || 0; });
        document.getElementById('previewTotal').textContent = total.toFixed(0);
        document.getElementById('wardrobeIds').value = ownedIds.join(',');
        document.getElementById('pendingIds').value = pendingIds.join(',');
    }

    // ===== 搜索待购 =====
    function searchProducts() {
        var keyword = document.getElementById('searchKeyword').value.trim();
        if (!keyword) { alert('请输入搜索关键词'); return; }
        fetch('${pageContext.request.contextPath}/look/search?keyword=' + encodeURIComponent(keyword))
            .then(function(r) { return r.json(); })
            .then(function(data) {
                pendingSearchResults = data;
                renderSearchResults();
            })
            .catch(function() {
                document.getElementById('searchResults').innerHTML = '<div class="empty-text">搜索失败</div>';
            });
    }

    function renderSearchResults() {
        var container = document.getElementById('searchResults');
        if (!pendingSearchResults || pendingSearchResults.length === 0) {
            container.innerHTML = '<div class="empty-text">未找到商品</div>';
            return;
        }
        var html = '';
        pendingSearchResults.forEach(function(p) {
            var isAdded = pendingIds.indexOf(String(p.id)) > -1;
            var images = p.images ? p.images.split(',') : [];
            var img = images.length > 0 ? images[0] : '';
            // 修复图片路径：如果已包含 uploads/ 则不再添加
            if (img && !img.startsWith('uploads/') && !img.startsWith('http')) {
                img = 'uploads/' + img;
            }
            html += '<div class="search-result-item">';
            if (img) {
                html += '<img src="${pageContext.request.contextPath}/' + img + '" alt="' + p.name + '">';
            } else {
                html += '<div style="width:40px;height:40px;background:#f0f0f0;border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:20px;">👕</div>';
            }
            html += '<div>' + p.name.substring(0, 6) + '</div>';
            html += '<div class="price">¥' + p.price.toFixed(0) + '</div>';
            if (isAdded) {
                html += '<div class="added-badge">✅ 已加</div>';
            } else {
                html += '<button class="add-btn" onclick="addPending(' + p.id + ', \'' + p.name.replace(/'/g, "\\'") + '\', \'' + img + '\', ' + p.price + ', \'' + (p.category || '上装') + '\')">添加</button>';
            }
            html += '</div>';
        });
        container.innerHTML = html;
    }

    // ===== 添加待购 =====
    function addPending(id, name, img, price, category) {
        if (pendingIds.indexOf(String(id)) > -1) { alert('已添加'); return; }
        if (ownedIds.length + pendingIds.length >= 6) { alert('最多选择6件衣服'); return; }
        pendingIds.push(String(id));
        pendingProducts.push({id: id, name: name, img: img, price: price, category: category || '上装', source: 'pending'});
        renderMannequin();
        updateCounts();
        renderSearchResults();
    }

    // ===== 保存搭配 =====
    function saveLook() {
        var name = document.getElementById('lookNameInput').textContent.trim() || '我的搭配';
        var scene = document.getElementById('sceneSelect').value;
        var season = document.getElementById('seasonSelect').value;

        if (ownedIds.length + pendingIds.length < 2) {
            alert('请至少选择2件衣服（已有+待购合计）');
            return;
        }
        if (ownedIds.length < 1) {
            alert('请至少选择1件已有衣服');
            return;
        }

        var form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/look/create';
        form.innerHTML =
            '<input type="hidden" name="name" value="' + name + '">' +
            '<input type="hidden" name="wardrobeIds" value="' + ownedIds.join(',') + '">' +
            '<input type="hidden" name="pendingIds" value="' + pendingIds.join(',') + '">' +
            '<input type="hidden" name="scene" value="' + scene + '">' +
            '<input type="hidden" name="season" value="' + season + '">';
        document.body.appendChild(form);
        form.submit();
    }

    // ===== 初始渲染 =====
    renderWardrobe('all');
    renderMannequin();
    updateCounts();
</script>

</body>
</html>