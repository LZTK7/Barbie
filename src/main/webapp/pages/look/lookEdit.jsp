<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Wardrobe, com.barbie.model.Look" %>
<%@ page import="com.barbie.dao.WardrobeDao" %>
<%@ page import="com.barbie.model.User" %>
<%@ page import="com.barbie.util.SessionUtil" %>
<%@ page import="java.util.Arrays" %>
<%
    User user = SessionUtil.getLoginUser(request.getSession());
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/user/login.jsp");
        return;
    }
    Look look = (Look) request.getAttribute("look");
    List<Wardrobe> wardrobeList = (List<Wardrobe>) request.getAttribute("wardrobeList");
    List<String> selectedIds = (List<String>) request.getAttribute("selectedIds");

    WardrobeDao wardrobeDao = new WardrobeDao();
    if (wardrobeList == null) {
        wardrobeList = wardrobeDao.findByUserId(user.getId());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改搭配 - Barbie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 700px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header h2 { font-size: 20px; }
        .back-btn { color: #666; text-decoration: none; font-size: 14px; }
        .form-box { background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 14px; font-weight: bold; color: #333; margin-bottom: 4px; }
        .form-group label .required { color: #ff6b81; }
        .form-group input, .form-group select { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; box-sizing: border-box; }
        .item-grid { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 8px; }
        .item-card { background: #f9f9f9; border: 2px solid #e8e8e8; border-radius: 8px; padding: 8px; text-align: center; cursor: pointer; transition: all 0.3s; width: 80px; }
        .item-card:hover { border-color: #ff6b81; }
        .item-card.selected { border-color: #ff6b81; background: #fff0f2; }
        .item-card.pending { border-color: #4ecdc4; background: #f0fffe; }
        .item-card img { width: 60px; height: 60px; object-fit: cover; border-radius: 4px; background: #f0f0f0; }
        .item-card .item-name { font-size: 11px; margin-top: 4px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .item-card .item-category { font-size: 10px; color: #999; }
        .item-card .badge { font-size: 9px; padding: 1px 6px; border-radius: 8px; color: white; display: inline-block; margin-top: 2px; }
        .badge-owned { background: #6c757d; }
        .badge-pending { background: #4ecdc4; }
        .badge-remove { background: #ff6b81; cursor: pointer; }
        .search-area { background: #f5f5f5; padding: 12px; border-radius: 8px; margin-top: 8px; }
        .search-area input { width: 65%; padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        .search-area button { padding: 8px 16px; background: #ff6b81; color: white; border: none; border-radius: 6px; cursor: pointer; }
        .search-area button:hover { background: #e8556b; }
        .search-results { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 8px; max-height: 200px; overflow-y: auto; }
        .search-result-item { background: white; border: 1px solid #ddd; border-radius: 6px; padding: 6px; text-align: center; width: 70px; }
        .search-result-item:hover { border-color: #4ecdc4; }
        .search-result-item img { width: 50px; height: 50px; object-fit: cover; border-radius: 4px; }
        .search-result-item .price { font-size: 11px; color: #ff6b81; font-weight: bold; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
        .btn-submit { width: 100%; padding: 12px; background: #ff6b81; color: white; border: none; border-radius: 6px; font-size: 16px; cursor: pointer; }
        .btn-submit:hover { background: #e8556b; }
        .hint { font-size: 12px; color: #999; margin-top: 8px; }
        .selected-count { font-size: 14px; color: #ff6b81; font-weight: bold; }
        .empty-text { color: #999; padding: 20px; text-align: center; }
        .pending-summary { background: #f0fffe; padding: 8px 12px; border-radius: 6px; margin-top: 8px; font-size: 13px; color: #333; }
        .pending-summary .price-total { color: #ff6b81; font-weight: bold; }
        .add-btn { font-size: 10px; background: #4ecdc4; color: white; border: none; border-radius: 4px; padding: 2px 6px; cursor: pointer; margin-top: 2px; }
        .add-btn:hover { background: #3bbdb5; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>✏️ 修改搭配</h2>
        <a href="${pageContext.request.contextPath}/look/list" class="back-btn">← 返回</a>
    </div>

    <div class="form-box">
        <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/look/edit" method="post" id="editForm">
            <input type="hidden" name="id" value="<%= look.getId() %>">

            <div class="form-group">
                <label>搭配名称 <span class="required">*</span></label>
                <input type="text" name="name" value="<%= look.getName() %>" required>
            </div>

            <!-- 已有衣服 -->
            <div class="form-group">
                <label>已有衣服 <span class="selected-count" id="ownedCount">已选 0 件</span></label>
                <div class="item-grid" id="ownedGrid">
                    <%
                        if (wardrobeList == null || wardrobeList.isEmpty()) {
                    %>
                    <div class="empty-text">衣橱为空</div>
                    <%
                    } else {
                        for (Wardrobe w : wardrobeList) {
                            String imgPath = w.getImages();
                            if (imgPath != null && !imgPath.isEmpty() && !imgPath.startsWith("uploads/")) {
                                imgPath = "uploads/" + imgPath;
                            }
                            boolean isSelected = selectedIds != null && selectedIds.contains(String.valueOf(w.getId()));
                    %>
                    <div class="item-card <%= isSelected ? "selected" : "" %>" data-id="<%= w.getId() %>" onclick="toggleOwned(this)">
                        <img src="${pageContext.request.contextPath}/<%= imgPath %>" alt="<%= w.getName() %>">
                        <div class="item-name"><%= w.getName() %></div>
                        <div class="item-category"><%= w.getCategory() %></div>
                        <span class="badge badge-owned">已有</span>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
                <div class="hint">💡 点击选择已有衣服，再次点击取消选择</div>
            </div>

            <!-- 搜索待购 -->
            <div class="form-group">
                <label>搜索待购衣服</label>
                <div class="search-area">
                    <input type="text" id="searchKeyword" placeholder="搜索商品..." onkeyup="if(event.keyCode==13) searchProducts()">
                    <button type="button" onclick="searchProducts()">🔍 搜索</button>
                    <div class="search-results" id="searchResults"></div>
                </div>
                <div class="hint">💡 搜索平台商品，点击「添加」自动保存</div>
            </div>

            <!-- 待购列表 -->
            <div class="form-group">
                <label>待购衣服 <span class="selected-count" id="pendingCount">已添加 0 件</span></label>
                <div class="item-grid" id="pendingGrid"></div>
                <div class="pending-summary" id="pendingSummary">待购合计：¥<span id="pendingTotal">0.00</span></div>
            </div>

            <div class="form-group">
                <label>场景</label>
                <select name="scene">
                    <option value="">请选择（选填）</option>
                    <option value="通勤" <%= "通勤".equals(look.getScene()) ? "selected" : "" %>>通勤</option>
                    <option value="街头" <%= "街头".equals(look.getScene()) ? "selected" : "" %>>街头</option>
                    <option value="约会" <%= "约会".equals(look.getScene()) ? "selected" : "" %>>约会</option>
                    <option value="运动" <%= "运动".equals(look.getScene()) ? "selected" : "" %>>运动</option>
                    <option value="度假" <%= "度假".equals(look.getScene()) ? "selected" : "" %>>度假</option>
                </select>
            </div>

            <div class="form-group">
                <label>季节</label>
                <select name="season">
                    <option value="">请选择（选填）</option>
                    <option value="春" <%= "春".equals(look.getSeason()) ? "selected" : "" %>>春</option>
                    <option value="夏" <%= "夏".equals(look.getSeason()) ? "selected" : "" %>>夏</option>
                    <option value="秋" <%= "秋".equals(look.getSeason()) ? "selected" : "" %>>秋</option>
                    <option value="冬" <%= "冬".equals(look.getSeason()) ? "selected" : "" %>>冬</option>
                    <option value="四季" <%= "四季".equals(look.getSeason()) ? "selected" : "" %>>四季</option>
                </select>
            </div>

            <input type="hidden" name="wardrobeIds" id="wardrobeIds" value="<%= look.getWardrobeIds() %>">
            <input type="hidden" name="pendingIds" id="pendingIds" value="<%= look.getPendingIds() %>">

            <button type="submit" class="btn-submit">💾 保存修改</button>
        </form>
    </div>
</div>

<script>
    var ownedIds = [];
    var pendingIds = [];
    var pendingProducts = [];

    // 初始化
    document.addEventListener('DOMContentLoaded', function() {
        var ownedHidden = document.getElementById('wardrobeIds');
        var pendingHidden = document.getElementById('pendingIds');

        if (ownedHidden.value) {
            ownedIds = ownedHidden.value.split(',').filter(function(id) { return id !== ''; });
            document.querySelectorAll('#ownedGrid .item-card').forEach(function(el) {
                if (ownedIds.indexOf(el.dataset.id) > -1) {
                    el.classList.add('selected');
                }
            });
        }

        if (pendingHidden.value && pendingHidden.value.trim() !== '') {
            pendingIds = pendingHidden.value.split(',').filter(function(id) { return id !== ''; });
            // 从后端获取待购商品详情
            fetchPendingProducts(pendingIds.join(','));
        } else {
            updateCounts();
        }
    });

    function fetchPendingProducts(ids) {
        fetch('${pageContext.request.contextPath}/look/getPendingProducts?ids=' + ids)
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('请求失败: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                pendingProducts = data;
                renderPending();
                updateCounts();
            })
            .catch(function(error) {
                console.error('获取待购商品详情失败:', error);
                // 降级方案
                pendingIds.forEach(function(id) {
                    pendingProducts.push({id: id, name: '商品' + id, img: '', price: 0});
                });
                renderPending();
                updateCounts();
            });
    }

    function toggleOwned(element) {
        var id = element.dataset.id;
        var index = ownedIds.indexOf(id);
        if (index > -1) {
            ownedIds.splice(index, 1);
            element.classList.remove('selected');
        } else {
            if (ownedIds.length + pendingIds.length >= 6) {
                alert('最多选择6件衣服（包含待购）');
                return;
            }
            ownedIds.push(id);
            element.classList.add('selected');
        }
        updateCounts();
    }

    function searchProducts() {
        var keyword = document.getElementById('searchKeyword').value.trim();
        if (!keyword) {
            alert('请输入搜索关键词');
            return;
        }

        fetch('${pageContext.request.contextPath}/look/search?keyword=' + encodeURIComponent(keyword))
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('请求失败: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                var container = document.getElementById('searchResults');
                if (data.length === 0) {
                    container.innerHTML = '<div class="empty-text">未找到相关商品</div>';
                    return;
                }
                var html = '';
                data.forEach(function(p) {
                    var images = p.images ? p.images.split(',') : [];
                    var img = images.length > 0 ? images[0] : '';
                    var isAdded = pendingIds.indexOf(String(p.id)) > -1;
                    html += '<div class="search-result-item">';
                    if (img) {
                        html += '<img src="${pageContext.request.contextPath}/uploads/' + img + '" alt="' + p.name + '">';
                    } else {
                        html += '<div style="width:50px;height:50px;background:#f0f0f0;border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:20px;">👕</div>';
                    }
                    html += '<div class="item-name">' + p.name.substring(0, 8) + '</div>';
                    html += '<div class="price">¥' + p.price.toFixed(0) + '</div>';
                    if (isAdded) {
                        html += '<span class="badge badge-pending" style="font-size:8px;">已加</span>';
                    } else {
                        html += '<button type="button" class="add-btn" onclick="addPending(' + p.id + ', \'' + p.name.replace(/'/g, "\\'") + '\', \'' + img + '\', ' + p.price + ')">添加</button>';
                    }
                    html += '</div>';
                });
                container.innerHTML = html;
            })
            .catch(function(error) {
                console.error('搜索失败:', error);
                document.getElementById('searchResults').innerHTML = '<div class="empty-text">搜索失败，请确认已登录</div>';
            });
    }

    function addPending(id, name, img, price) {
        if (pendingIds.indexOf(String(id)) > -1) {
            alert('已添加');
            return;
        }
        if (ownedIds.length + pendingIds.length >= 6) {
            alert('最多选择6件衣服（包含待购）');
            return;
        }

        // 先更新前端
        pendingIds.push(String(id));
        pendingProducts.push({
            id: id,
            name: name,
            img: img,
            price: price,
            images: img,
            category: ''
        });
        updateCounts();
        renderPending();

        // 自动保存到数据库
        var lookId = document.querySelector('input[name="id"]').value;
        fetch('${pageContext.request.contextPath}/look/addPending', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'lookId=' + lookId + '&productId=' + id
        })
            .then(function(response) {
                if (response.ok) {
                    console.log('✅ 待购商品已保存');
                } else {
                    console.error('❌ 保存失败');
                }
            })
            .catch(function(error) {
                console.error('请求失败:', error);
            });

        // 刷新搜索结果
        var keyword = document.getElementById('searchKeyword').value.trim();
        if (keyword) searchProducts();
    }

    function removePending(index) {
        var id = pendingIds[index];
        pendingIds.splice(index, 1);
        pendingProducts.splice(index, 1);
        updateCounts();
        renderPending();

        // 自动保存到数据库
        var lookId = document.querySelector('input[name="id"]').value;
        fetch('${pageContext.request.contextPath}/look/removePending', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'lookId=' + lookId + '&productId=' + id
        })
            .then(function(response) {
                if (response.ok) {
                    console.log('✅ 待购商品已移除');
                } else {
                    console.error('❌ 移除失败');
                }
            })
            .catch(function(error) {
                console.error('请求失败:', error);
            });

        var keyword = document.getElementById('searchKeyword').value.trim();
        if (keyword) searchProducts();
    }

    function renderPending() {
        var container = document.getElementById('pendingGrid');
        if (pendingProducts.length === 0) {
            container.innerHTML = '<div class="empty-text">暂无待购衣服</div>';
            return;
        }
        var html = '';
        var total = 0;
        pendingProducts.forEach(function(p, index) {
            var price = parseFloat(p.price) || 0;
            total += price;
            var img = p.img || p.images || '';
            if (img && !img.startsWith('uploads/') && !img.startsWith('http')) {
                img = 'uploads/' + img;
            }
            html += '<div class="item-card pending">';
            if (img) {
                html += '<img src="${pageContext.request.contextPath}/' + img + '" alt="' + (p.name || '商品') + '" style="width:60px;height:60px;object-fit:cover;border-radius:4px;background:#f0f0f0;">';
            } else {
                html += '<div style="width:60px;height:60px;background:#f0f0f0;border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:24px;">👕</div>';
            }
            html += '<div class="item-name">' + (p.name || '商品').substring(0, 8) + '</div>';
            html += '<div style="font-size:11px;color:#ff6b81;font-weight:bold;">¥' + price.toFixed(0) + '</div>';
            html += '<span class="badge badge-pending badge-remove" onclick="removePending(' + index + ')">✕ 移除</span>';
            html += '</div>';
        });
        container.innerHTML = html;
        document.getElementById('pendingTotal').textContent = total.toFixed(2);
    }

    function updateCounts() {
        document.getElementById('ownedCount').textContent = '已选 ' + ownedIds.length + ' 件';
        document.getElementById('pendingCount').textContent = '已添加 ' + pendingIds.length + ' 件';
        document.getElementById('wardrobeIds').value = ownedIds.join(',');
        document.getElementById('pendingIds').value = pendingIds.join(',');
    }

    document.getElementById('editForm').addEventListener('submit', function(e) {
        if (ownedIds.length + pendingIds.length < 2) {
            alert('请至少选择2件衣服（已有+待购合计）');
            e.preventDefault();
            return false;
        }
        if (ownedIds.length < 1) {
            alert('请至少选择1件已有衣服');
            e.preventDefault();
            return false;
        }
        document.getElementById('wardrobeIds').value = ownedIds.join(',');
        document.getElementById('pendingIds').value = pendingIds.join(',');
        return true;
    });
</script>
</body>
</html>